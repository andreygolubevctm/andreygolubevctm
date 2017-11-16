(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthDependants: {
                DEPENDANTS_RENDERED: 'DEPENDANTS_RENDERED'
            }
        },
        moduleInitialised = false,
        $dependantsTemplateWrapper,
        dependantTemplate,
        /**
         * The data that makes up a dependant.
         * @type {{dependantId: number, title: string, firstName: string, middleName: string, lastname: string, fulltime: string, school: string, schoolDate: string, schoolID: string, dob: string, dobInputD: string, dobInputY: string, dobInputM: string, maritalincomestatus: string, apprentice: string}}
         */
        defaultDependant = {
            dependantId: 1,
            title: "",
            firstName: "",
            middleName: "",
            lastname: "",
            fulltime: "",
            school: "",
            schoolDate: "",
            schoolID: "",
            dob: "",
            dobInputD: "",
            dobInputY: "",
            dobInputM: "",
            maritalincomestatus: "",
            relationship:"",
            apprentice: ""
        },
        dependantLimit = 12,
        dependantsArr = [],
        /**
         * Default configuration for the dependant template.
         * @type {{showMiddleName: boolean, fulltime: boolean, school: boolean, schoolMinAge: number, schoolMaxAge: number, schoolID: boolean, schoolIDMandatory: boolean, schoolDate: boolean, schoolDateMandatory: boolean, defacto: boolean, defactoMinAge: number, defactoMaxAge: number, apprentice: boolean}}
         */
        defaultProviderConfig = {
            showMiddleName: false,
            showFullTimeField: false,
            /**
             * In order to show school date or ID, showSchoolFields must be set to true.
             * Note: these fields only display based on schoolMinAge/Max
             */
            showSchoolFields: true,
            useSchoolDropdownMenu: false,
            schoolMinAge: 22,
            schoolMaxAge: 24,
            showSchoolIdField: false,
            schoolIdRequired: false,
            schoolIdMaxLength: 50,
            showSchoolCommencementField: false,
            schoolDateRequired: false,
            showMaritalStatusField: false,
            showRelationship:false,
            defactoMinAge: 21,
            defactoMaxAge: 24,
            showApprenticeField: false,
            extendedFamilyMinAge: 21,
            extendedFamilyMaxAge: 25
        },
        providerConfig,
        maxDependantAge = 25,
        $elements;

    function initHealthDependants() {
        $dependantsTemplateWrapper = $("#health-dependants-wrapper");
        if (!situationEnablesDependants()) {
            clearDependants();
        }

        if(!situationEnablesDependants()) return;

        // setup default provider config.
        if (!providerConfig) {
            resetConfig();
        }

        // set up template
        dependantTemplate = _.template($('#health-dependants-template').html());

        var noOfDependants = getNumberOfDependants();
        if(_.isEmpty(dependantsArr)) {
            if (typeof meerkat.site.dependants != 'undefined') {
                dependantsArr = addDataBucketDependantsToList();
            } else if (_.isNumber(noOfDependants) && noOfDependants > 0) {
                for (var i = 0; i < noOfDependants; i++) {
                    dependantsArr.push(getDefaultDependant());
                }
            } else if (noOfDependants === 0) {
                dependantsArr.push(getDefaultDependant());
            }
        }


        renderDependants();
        applyEventListeners();
    }

    function init() {
        $(document).ready(function () {
            $elements = {
                dependantsRow: $('#health_healthCover_dependants_field_row'),
                dependants: $('select[name=health_healthCover_dependants]')
            };

            aboutYouApplyEventListeners();
            moduleInitialised = true;
        });
    }

    function getDefaultDependant() {
        return _.extend({},defaultDependant);
    }

    function aboutYouApplyEventListeners() {

        // toggle the dependants field
        meerkat.messaging.subscribe(meerkatEvents.healthSituation.SITUATION_CHANGED, function toggleZDependants(selected) {
            toggleDependants();
        });
    }

    function toggleDependants() {
        var showDependants = situationEnablesDependants();
        if(moduleInitialised) {
                $elements.dependantsRow.toggleClass('hidden', !showDependants);
        } else {
            _.defer(function(){
                $elements.dependantsRow.toggleClass('hidden', !showDependants);
            });
        }
    }

    /**
     * Event Listeners for Health Dependants
     */
    function applyEventListeners() {
        meerkat.messaging.subscribe(meerkat.modules.journeyEngine.events.journeyEngine.STEP_CHANGED, function stepChangedEvent(navInfo) {
            if(navInfo.isForward && navInfo.navigationId === 'apply' && dependantsArr.length) {
                $('.health_dependant_details').each(function() {
                    var $this = $(this);
                    toggleDependantFields($this);
                }).promise().done(function() {
                    renderDependants();
                });
            }
        });

        $dependantsTemplateWrapper.off('click.removeDependant').on('click.removeDependant', ".remove-dependent", function removeDependantClick(e) {
            deleteDependant($(this).attr('data-id'), true);
            updateApplicationDetails();
        }).on('change', '.dateinput_container input.serialise, .health_dependant_details_fulltimeGroup input', function dependantAgeFullTimeChange() {
            var $wrapper = $(this).closest('.health_dependant_details');
            toggleDependantFields($wrapper);
        }).on('change', ':input', function changeInput() {
            var $el = $(this),
                dependantId = $el.closest('.health_dependant_details').attr('data-id'),
                objIndex = $el.attr('id').replace(/health_application_dependants_dependant[0-9]{1}_/, '');
            dependantsArr[dependantId - 1][objIndex] = $(this).val();
        });

        $('#dependents_list_options')
            .off('click', '.add-new-dependent')
            .on('click', ".add-new-dependent", function addDependantClick(e) {
                e.stopPropagation();
                addNewDependant(true);
            });

        // Sync income tier value (which can be changed if you change the number of dependants you have).
        $('#health_application_dependants_income').on('change', function syncIncomeTierValues() {
            $('.health_cover_details_income').val($(this).val());
        });
    }

    /**
     * Apply events to the date elements, only after the template has been rendered.
     */
    function applyDateEvents() {
        $('[data-provide=dateinput]', $dependantsTemplateWrapper).each(function applyDateEventsOnDateInputs() {
            meerkat.modules.formDateInput.initDateComponent($(this));
        });
    }

    /**
     * Whenever you enter into application phase, it is possible that you had 6 dependants before
     * and then you went back and set it to 3. So in this case, it should delete the 3.
     */
    function updateDependantConfiguration() {

        initHealthDependants();

        var dependantCountSpecified = $elements.dependants.val() || 1;
        var hasChildren = situationEnablesDependants();
        $('#health_application_dependants-selection').toggle(hasChildren);
        $('#health_application_dependants_threshold').toggle(dependantCountSpecified <= 0);
        if (!hasChildren) {
            clearDependants();
            return;
        }

        // If you had set 5 dependants, then went back and changed to 3...
        if (dependantCountSpecified < getNumberOfDependants()) {
            for (var i = getNumberOfDependants(); i > dependantCountSpecified; i--) {
                deleteDependant(i, false);
            }
        } else {
            // Generate X number of dependants.
            var hasChosenToApplyRebate = meerkat.modules.healthRebate.isRebateApplied();
            if (hasChosenToApplyRebate && dependantCountSpecified > 0) {
                // Add to existing dependants
                while (getNumberOfDependants() < dependantCountSpecified) {
                    addNewDependant(false);
                }
            }
        }

        updateApplicationDetails();
    }

    /**
     * Displays or hides fields for dependants based on the age.
     * In order for these fields to be rendered into a dependants template, the provider has to specify
     * the configuration that it wants to show full time, or school id, etc in the healthFund JSP
     */
    function toggleDependantFields($wrapper) {

        var dependantId = $wrapper.attr('data-id'),
            selectorPrefix = '#health_application_dependants_dependant' + dependantId,
            $dob = $(selectorPrefix + '_dob');
        var age = meerkat.modules.age.returnAge($dob.val(), true) || 0;
        
        // see   \health\js\healthDependants.js if extendedFamily integration is required in the future
        // If the dependant is between the school age
        if (age >= providerConfig.schoolMinAge && age <= providerConfig.schoolMaxAge) {
            // If the config is set to true, we want to remove the class.
            // To remove a class, toggleClass needs false, so we flip the config option.
            $(selectorPrefix + '_fulltimeGroup').toggleClass('hidden', !providerConfig.showFullTimeField);
            $(selectorPrefix + '_schoolGroup').toggleClass('hidden', !providerConfig.showSchoolFields);
            $(selectorPrefix + '_schoolIDGroup').toggleClass('hidden', !providerConfig.showSchoolIdField);
            $(selectorPrefix + '_schoolDateGroup').toggleClass('hidden', !providerConfig.showSchoolCommencementField);
            $(selectorPrefix + '_apprenticeGroup').toggleClass('hidden', !providerConfig.showApprenticeField);
            $('[name=health_application_dependants_dependant' + dependantId + '_schoolID]').prop('required',providerConfig.schoolIdRequired);
        } else {
            // Hide them all if they aren't in the date range.
            $(selectorPrefix + '_fulltimeGroup, ' + selectorPrefix + '_schoolGroup, ' + selectorPrefix + '_schoolIDGroup, ' + selectorPrefix + '_schoolDateGroup,' + selectorPrefix + '_apprenticeGroup').addClass('hidden');
        }
    }

    /**
     * Remove the data from the object
     * Remove the template
     * @param index The dependants ID in the html
     * @param {bool} doAnimate - whether or not to animate to the previous dependant.
     */
    function deleteDependant(index, doAnimate) {

        index = parseInt(index, 10);

        var isLastDependant = index == getNumberOfDependants();
        // Remove it
        dependantsArr.splice(index - 1, 1);
        // Render stuff
        if (!isLastDependant) {
            // Wipe the HTML to remove events and content from the DOM.
            $('#health_application_dependants_dependant' + index).empty().remove();
            // Don't animate when deleting in the middle, its confusing.
            doAnimate = false;
        }

        renderDependants();

        doAnimate = typeof doAnimate == 'undefined' ? true : doAnimate;
        if (doAnimate && getNumberOfDependants() > 1) {
            animateToDependant($('#health_application_dependants_dependant' + getNumberOfDependants()));
        }
    }

    /**
     * Render all the available dependant templates.
     * This only runs once onInitialise, as it renders for the
     * count of dependants (this could be from preload, or a quote)
     * To add dependants, use "addNewDependant()"
     */
    function renderDependants() {
        var outHtml = "";
        for (var i = 0; i < getNumberOfDependants(); i++) {
            // Dependants array is indexed at 0, but needs to display as 1.
            dependantsArr[i].dependantId = i + 1;
            outHtml += dependantTemplate(dependantsArr[i]);
        }
        $dependantsTemplateWrapper.html(outHtml);
        applyDateEvents();
        updateNonTextFieldsValues();
        meerkat.modules.datepicker.initModule();

        meerkat.messaging.publish(moduleEvents.healthDependants.DEPENDANTS_RENDERED);
    }

    /**
     * In order to maintain the proper state when returning, we need to manually populate.
     * This is because the radio/select menu/dob components don't accept a defaultValue which is a
     * template variable. The tag wouldn't render the HTML properly.
     */
    function updateNonTextFieldsValues() {

        for (var i = 0; i < getNumberOfDependants(); i++) {
            var prefix = '#health_application_dependants_dependant' + (i + 1),
                dobParts = dependantsArr[i].dob.split('/');
            $(prefix + '_title').val(dependantsArr[i].title);
            if (dobParts.length) {
                $(prefix + '_dobInputD').val(dobParts[0]);
                $(prefix + '_dobInputM').val(dobParts[1]);
                $(prefix + '_dobInputY').val(dobParts[2]);
                $(prefix + '_dob').val(dependantsArr[i].dob);
            }

            if (providerConfig.useSchoolDropdownMenu) {
                $(prefix + '_school').val(dependantsArr[i].school);
            }
            if (providerConfig.showMaritalStatusField) {
                $(prefix + '_maritalincomestatus').val(dependantsArr[i].maritalincomestatus);
            }
            if(providerConfig.showRelationship) {
                $(prefix + '_relationship').val(dependantsArr[i].relationship);
            }
            if (providerConfig.showApprenticeField) {
                $(prefix + '_apprentice').val(dependantsArr[i].apprentice);
            }

        }

        $dependantsTemplateWrapper.find('.serialise').each(function(){
            var $that = $(this);
            if(!_.isEmpty($that.val())) {
                $that.change();
            }
        });
    }

    /**
     * Extending the default Dependant because otherwise it may pass by reference.
     * We also always add a blank dependant to the object.
     * @param {bool} doAnimate whether or not to animate down to the next dependant.
     */
    function addNewDependant(doAnimate) {
        var numDependants = getNumberOfDependants();
        if (numDependants < dependantLimit) {
            var dependantId = numDependants + 1;

            var blankDependant = $.extend({}, getDefaultDependant(), {dependantId: dependantId});
            $dependantsTemplateWrapper.append(dependantTemplate(blankDependant));
            dependantsArr.push(blankDependant);

            applyDateEvents();

            updateApplicationDetails();

            doAnimate = typeof doAnimate == 'undefined' ? true : doAnimate;
            if (doAnimate) {
                animateToDependant($('#health_application_dependants_dependant' + getNumberOfDependants()));
            }

            meerkat.messaging.publish(moduleEvents.healthDependants.DEPENDANTS_RENDERED);
        }
    }

    /**
     * Reset all the dependant information.
     */
    function clearDependants() {
        $dependantsTemplateWrapper.empty();
        dependantsArr = [];
    }

    /**
     * Displays the estimated taxable income menu if the
     * customer has selected to apply the rebate and has dependants.
     * Also populates the dependants tier menu with content from the initial cover step.
     */
    function updateApplicationDetails() {
        var $applyPageIncomeTierMenu = $('.health-dependants-tier', '#health_application_dependants-selection'),
            depCount = getNumberOfDependants();

        // Difference between health v1 and health v2 can be removed when v1 is removed.
        var hasChosenToNotApplyRebate = !meerkat.modules.healthRebate.isRebateApplied();
        if (hasChosenToNotApplyRebate) {
            $applyPageIncomeTierMenu.slideUp();
        } else if (depCount > 0) {
            var $depCount = $elements.dependants,
                originalDepCount = $depCount.val();
            // Refresh the dependants on the situation step. Only reset it to a smaller number if
            $depCount.val(depCount).trigger('change');
            // Refresh rebate tiers on apply step.
            $applyPageIncomeTierMenu.find('select').html($('#health_healthCover_income').html());
            $('#health_application_dependants_incomeMessage').text('this includes an adjustment for your dependants');

            // Hide if the dependant count is the same.
            if(depCount == originalDepCount) {
                $applyPageIncomeTierMenu.slideUp();
            } else {
                $applyPageIncomeTierMenu.slideDown();
            }
        } else {
            $applyPageIncomeTierMenu.slideUp();
        }
    }

    /**
     * Get the number that have been added.
     * This function will return 1 if there is 1 dependant.
     * The first dependant will be at index 0 of the array.
     * @returns {Number|number}
     */
    function getNumberOfDependants() {
        return dependantsArr.length || 0;
    }

    /**
     * Dependants are currently dumped into settings.tag. Ideally, this would be pulled in via an XHR
     * request when the application step loads.
     * @returns {*}
     */
    function addDataBucketDependantsToList() {
        var list = meerkat.site.dependants.dependants;
        return _.keys(list).map(function (key) {
            var keyId = key.replace('dependant', ''), newObj = list[key];
            newObj.order = parseInt(keyId, 10);
            return newObj;
        }).sort(function (a, b) { // sort(from smallest to largest)
            return a['order'] - b['order'];
        });
    }

    /**
     * Whether or not to bother rendering anything for dependants.
     * Only Family and Single Parent Family render Dependants.
     * @returns {boolean}
     */
    function situationEnablesDependants() {
        var coverCode = meerkat.modules.healthChoices.returnCoverCode();
        return coverCode == 'SPF' || coverCode == 'F' || coverCode == 'ESP' || coverCode == 'EF';
    }

    function animateToDependant($el) {
        if (!$el.length) {
            return;
        }
        $('html, body').stop(true, true).animate({
            scrollTop: $el.offset().top - 50
        }, 500);
    }

    /**
     * Set the default configuration and maxAge variables.
     */
    function resetConfig() {
        providerConfig = defaultProviderConfig;
        maxDependantAge = 25;
    }

    /**
     * Specific partners have different rules, so config is updated in healthFunds_***.jsp
     * @param updatedConfig
     */
    function updateConfig(updatedConfig) {
        providerConfig = $.extend({}, defaultProviderConfig, updatedConfig);
    }

    function getConfig() {
        return providerConfig;
    }

    function getMaxAge() {
        return maxDependantAge;
    }

    function setMaxAge(age) {
        maxDependantAge = age;
    }

    var educationalInstitutions = {
            "ACP": "Australian College of Phys. Ed",
            "ACT": "Australian College of Theology",
            "ACTH": "ACT High Schools",
            "ACU": "Australian Catholic University",
            "ADA": "Australian Defence Force Academy",
            "AFTR": "Australian Film, TV &amp; Radio School",
            "AIR": "Air Academy, Brit Aerospace Flight Trng",
            "AMC": "Austalian Maritime College",
            "ANU": "Australian National University",
            "AVO": "Avondale College",
            "BC": "Batchelor College",
            "BU": "Bond University",
            "CQU": "Central Queensland Universty",
            "CSU": "Charles Sturt University",
            "CUT": "Curtin University of Technology",
            "DU": "Deakin University",
            "ECU": "Edith Cowan University",
            "EDUC": "Education Institute Default",
            "FU": "Flinders University of SA",
            "GC": "Gatton College",
            "GU": "Griffith University",
            "JCUNQ": "James Cook University of Northern QLD",
            "KVBVC": "KvB College of Visual Communication",
            "LTU": "La Trobe University",
            "MAQ": "Maquarie University",
            "MMCM": "Melba Memorial Conservatorium of Music",
            "MTC": "Moore Theological College",
            "MU": "Monash University",
            "MURUN": "Murdoch University",
            "NAISD": "Natn&apos;l Aborign&apos;l &amp; Islander Skills Dev Ass.",
            "NDUA": "Notre Dame University Australia",
            "NIDA": "National Institute of Dramatic Art",
            "NSWH": "NSW High Schools",
            "NSWT": "NSW TAFE",
            "NT": "Northern Territory High Schools",
            "NTT": "NT TAFE",
            "NTU": "Northern Territory University",
            "OLA": "Open Learnng Australia",
            "OTHER": "Other Registered Tertiary Institutions",
            "PSC": "Photography Studies College",
            "QCM": "Queensland Conservatorium of Music",
            "QCU": "Queensland College of Art",
            "QLDH": "QLD High Schools",
            "QLDT": "QLD TAFE",
            "QUT": "Queensland University of Technology",
            "RMIT": "Royal Melbourne Institute of Techn.",
            "SA": "South Australian High Schools",
            "SAT": "SA TAFE",
            "SCD": "Sydney College of Divinity",
            "SCM": "Sydney Conservatorium of Music",
            "SCU": "Southern Cross University",
            "SCUC": "Sunshine Coast University College",
            "SIT": "Swinburn Institute of Technology",
            "SJC": "St Johns College",
            "SYD": "University of Sydney",
            "TAS": "TAS High Schools",
            "TT": "TAS TAFE",
            "UA": "University of Adelaide",
            "UB": "University of Ballarat",
            "UC": "University of Canberra",
            "UM": "University of Melbourne",
            "UN": "University of Newcastle",
            "UNC": "University of Capricornia Rockhampton",
            "UNE": "University of New England",
            "UNSW": "University Of New South Wales",
            "UQ": "University of Queensland",
            "USA": "University of South Australia",
            "USQ": "University of Southern Queensland",
            "UT": "University of Tasmania",
            "UTS": "University of Technlogy Sydney",
            "UW": "University of Wollongong",
            "UWA": "University of Western Australia",
            "UWS": "University of Western Sydney",
            "VCAH": "VIC College of Agriculture &amp; Horticulture",
            "VIC": "Victorian High Schools",
            "VICT": "VIC TAFE",
            "VU": "Victoria University",
            "VUT": "Victoria University of Technology",
            "WA": "Western Australia-High Schools",
            "WAT": "WA TAFE"
        },
        cachedList;

    function getEducationalInstitutionsOptions() {
        if (cachedList) {
            return cachedList;
        }
        cachedList = '';
        var keys = _.keys(educationalInstitutions);
        for (var i = 0; i < keys.length; i++) {
            cachedList += '<option value="' + keys[i] + '">' + educationalInstitutions[keys[i]] + '</option>';
        }
        return cachedList;
    }

    meerkat.modules.register("healthDependants", {
        init: init,
        events: moduleEvents,
        initHealthDependants: initHealthDependants,
        resetConfig: resetConfig,
        getConfig: getConfig,
        updateConfig: updateConfig,
        getMaxAge: getMaxAge,
        setMaxAge: setMaxAge,
        updateDependantConfiguration: updateDependantConfiguration,
        getEducationalInstitutionsOptions: getEducationalInstitutionsOptions,
        situationEnablesDependants: situationEnablesDependants,
        toggleDependants: toggleDependants,
        getNumberOfDependants: getNumberOfDependants,
        updateApplicationDetails: updateApplicationDetails
    });

})(jQuery);