(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            healthDependants: {}
        },
        $dependantsTemplateWrapper,
        dependantTemplate,
        defaultDependant = {
            dependantId: 1,
            title: "",
            firstName: "",
            middleName: "",
            lastName: "",
            fulltime: "",
            school: "",
            schoolDate: "",
            schoolID: "",
            maritalincomestatus: "",
            apprentice: ""
        },
        dependantLimit = 12,
        dependantsArr = [],
        /**
         * Default configuration for the dependant template.
         * @type {{showMiddleName: boolean, fulltime: boolean, school: boolean, schoolMin: number, schoolMax: number, schoolID: boolean, schoolIDMandatory: boolean, schoolDate: boolean, schoolDateMandatory: boolean, defacto: boolean, defactoMin: number, defactoMax: number, apprentice: boolean}}
         */
        defaultProviderConfig = {
            showMiddleName: false,
            showFullTimeField: false,
            /**
             * In order to show school date or ID, showSchoolFields must be set to true.
             * Note: these fields only display based on schoolMin/Max
             */
            showSchoolFields: true,
            useSchoolDropdownMenu: false,
            schoolMin: 22,
            schoolMax: 24,
            showSchoolIdField: false,
            schoolIdRequired: false,
            showSchoolCommencementField: false,
            schoolDateRequired: false,
            showDefactoField: false,
            defactoMin: 21,
            defactoMax: 24,
            showApprenticeField: false
        },
        providerConfig = {},
        maxDependantAge = 25;

    function initHealthDependants() {
        $dependantsTemplateWrapper = $("#health-dependants-wrapper");
        if (!situationEnablesDependants()) {
            clearDependants();
            return;
        }

        // setup default provider config.
        resetConfig();

        // set up template
        dependantTemplate = _.template($('#health-dependants-template').html());

        if (getNumberOfDependants() === 0) {
            dependantsArr.push(defaultDependant);
        }

        renderDependants();
        applyEventListeners();
    }

    /**
     * Whenever you enter into application phase, it is possible that you had 6 dependants before
     * and then you went back and set it to 3. So in this case, it should delete the 3.
     */
    function updateDependantConfiguration() {

        var dependantCountSpecified = $('#health_healthCover_dependants').val() || 0;
        // TODO: unsure if this is necessary. Would create x dependant entries from what was specified.
        /*if(healthCoverDetails.getRebateChoice() == 'Y' && dependantCountSpecified > 0) {
         for(var i = 0; i < dependantCountSpecified;i++) {
         dependantsArr.push(defaultDependant);
         }
         }*/
        var hasChildren = healthChoices.hasChildren();
        $('#health_application_dependants-selection').toggle(hasChildren);
        $('#health_application_dependants_threshold').toggle(dependantCountSpecified <= 0);

        if (!hasChildren) {
            return;
        }

        // If you have 7 dependants and you specify 3 in the situation step,
        // it should iterate in reverse and delete 7,6,5,4
        // TODO: test with 1,2,3 etc.
        for (var i = getNumberOfDependants(); i >= dependantCountSpecified; i--) {
            deleteDependant(i, false);
        }
        updateApplicationDetails();
    }

    /**
     * Event Listeners for Health Dependants
     */
    function applyEventListeners() {

        $dependantsTemplateWrapper.on('click', ".remove-dependent", function () {
            deleteDependant($(this).attr('data-id'), true);
            updateApplicationDetails();
        });

        $('#dependents_list_options').on('click', ".add-new-dependent", function () {
            addNewDependant();
        });
    }

    /**
     * Remove the data from the object
     * Remove the template
     * @param index
     * @param {bool} doAnimate - whether or not to animate to the previous dependant.
     * NOTE: would have to reflow all the ids, or run renderDependants()
     *          if you wanted to delete dependents from the middle instead of end.
     */
    function deleteDependant(index, doAnimate) {

        // Wipe the HTML to remove events and content from the DOM.
        $('#health_application_dependants_dependant' + index).empty();
        dependantsArr.splice(index, 1);

        doAnimate = typeof doAnimate == 'undefined' ? true : doAnimate;
        //TODO: test this with 1 and 2 dependants.
        if (doAnimate && getNumberOfDependants() > 1) {
            animateToDependant($('#health_application_dependants_dependant' + getNumberOfDependants() - 1));
        }
        //TODO hide all remove-dependant options except for last one.
    }

    /**
     * Displays the estimated taxable income menu if the
     * customer has selected to apply the rebate and has dependants.
     */
    function updateApplicationDetails() {

        var $applyPageIncomeTierMenu = $('.health-dependants-tier', $('#health_application_dependants-selection')),
            depCount = getNumberOfDependants();
        if (depCount > 0) {
            // Refresh the dependants on the situation step
            $('#health_healthCover_dependants').val(depCount).trigger('change');
            // Refresh rebate tiers on apply step.
            var $situationIncomeTierWrapper = $('#health_healthCover_tier');
            $applyPageIncomeTierMenu.find('select').html($situationIncomeTierWrapper.find('select').html());
            $('#health_application_dependants_incomeMessage').text($situationIncomeTierWrapper.find('span').text());
            $applyPageIncomeTierMenu.slideDown();
        } else {
            $applyPageIncomeTierMenu.slideUp();
        }
    }

    function animateToDependant($el) {
        if (!$el.length) {
            return;
        }
        $('html, body').animate({
            scrollTop: $el.offset().top - 50
        }, 250);
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
    }

    /**
     * Extending the default Dependant because otherwise it may pass by reference.
     * We also always add a blank dependant to the object.
     */
    function addNewDependant() {
        var numDependants = getNumberOfDependants();
        if (numDependants < dependantLimit) {
            var blankDependant = $.extend({}, defaultDependant, {dependantId: numDependants + 1});
            console.log(blankDependant);
            $dependantsTemplateWrapper.append(dependantTemplate(blankDependant));
            // push their data onto the array
            dependantsArr.push(blankDependant);
            updateApplicationDetails();
            //TODO: test this animation
            animateToDependant($('#health_application_dependants_dependant' + getNumberOfDependants() - 1));
            //TODO hide all remove-dependant options except for last one.
        }
    }

    /**
     * Reset all the dependant information.
     */
    function clearDependants() {
        $dependantsTemplateWrapper.empty();
        dependantsArr = [];
        resetConfig();
    }

    /**
     * Get the number that have been added.
     * @returns {Number|number}
     */
    function getNumberOfDependants() {
        return dependantsArr.length || 0;
    }

    /**
     * Whether or not to bother rendering anything for dependants.
     * Only Family and Single Parent Family render Dependants.
     * @returns {boolean}
     */
    function situationEnablesDependants() {
        return healthChoices._cover == 'SPF' || healthChoices._cover == 'F';
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
    };

    function getEducationalInstitutions() {
        return educationalInstitutions;
    }

    meerkat.modules.register("healthDependants", {
        initHealthDependants: initHealthDependants,
        events: events,
        resetConfig: resetConfig,
        getConfig: getConfig,
        updateConfig: updateConfig,
        getMaxAge: getMaxAge,
        setMaxAge: setMaxAge,
        updateDependantConfiguration: updateDependantConfiguration,
        getEducationalInstitutions: getEducationalInstitutions
    });

})(jQuery);