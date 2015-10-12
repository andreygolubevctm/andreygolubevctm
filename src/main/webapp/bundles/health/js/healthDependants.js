(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            healthDependants: {}
        },
        moduleEvents = events.healthDependants;

    var _dependents = 0,
        _limit = 12,
        maxAge = 25,
        defaultConfig = {
            'fulltime': false,
            'school': true,
            'schoolMin': 22,
            'schoolMax': 24,
            'schoolID': false,
            'schoolIDMandatory': false,
            'schoolDate': false,
            'schoolDateMandatory': false,
            'defacto': false,
            'defactoMin': 21,
            'defactoMax': 24,
            'apprentice': false
        },
        config = {},
        dependantTemplate;

    function initHealthDependants() {
        resetConfig();

        $(document).ready(function () {
            //var $tpl = $('#health-dependants-template').html();
            //dependantTemplate = _.template($tpl);
            // var htmlString = dependantTemplate(currentProduct);
            // $productSnapshot.html(htmlString);
            applyEventListeners();
        });


    }

    function applyEventListeners() {
        // Sync income tier value (which can be changed if you change the number of dependants you have).
        $('#health_application_dependants_income').on('change', function () {
            $('#mainform').find('.health_cover_details_income').val($(this).val());
        });

        // Perform checks and show/hide questions when the dependant's DOB changes
        $('.health_dependant_details .dateinput_container input.serialise').on('change', function (event) {
            checkDependant($(this).closest('.health_dependant_details').attr('data-id'));
            $(this).valid();
        });

        // Perform checks and show/hide questions when the fulltime radio button changes
        $('.health_dependant_details_fulltimeGroup input').on('change', function (event) {
            checkDependant($(this).closest('.health_dependant_details').attr('data-id'));
            $(this).parents('.health_dependant_details').find('.dateinput_container input.serialise').valid();
        });

        // Add/Remove dependants
        $('#health_application_dependants-selection').find(".remove-last-dependent").on("click", function () {
            dropDependant();
        }).end().find(".add-new-dependent").on("click", function () {
            addDependant();
        });
    }

    function resetConfig() {

        config = defaultConfig;

        maxAge = 25;
    }

    function getMaxAge() {
        return maxAge;
    }

    function setMaxAge(age) {
        maxAge = age;
    }

    function getConfig() {
        return config;
    }

    /**
     * Specific partners have different rules, so config is updated in healthFunds_***.jsp
     * @param updatedConfig
     */
    function updateConfig(updatedConfig) {
        config = $.extend({}, defaultConfig, updatedConfig);
    }

    function renderDependant() {

    }

    function setDependants() {
        var _dependants = $('#mainform').find('.health_cover_details_dependants').find('select').val();
        if (healthCoverDetails.getRebateChoice() == 'Y' && !isNaN(_dependants)) {
            _dependents = _dependants;
        } else {
            _dependents = 1;
        }

        if (healthChoices.hasChildren()) {
            $('#health_application_dependants-selection').show();
        } else {
            $('#health_application_dependants-selection').hide();
            return;
        }

        updateDependantOptionsDOM();

        $('#health_application_dependants-selection').find('.health_dependant_details').each(function () {
            var index = parseInt($(this).attr('data-id'));
            if (index > _dependents) {
                $(this).hide();
            }
            else {
                $(this).show();
            }


            checkDependant(index);
        });
    }

    function addDependant() {
        if (_dependents < _limit) {
            _dependents++;
            var $_obj = $('#health_application_dependants_dependant' + _dependents);

            // Reset values
            $_obj.find('input[type=text], select').val('');
            resetRadio($_obj.find('.health_dependant_details_maritalincomestatus'), '');

            // Reset validation
            $_obj.find('.error-field label').remove();
            $_obj.find('.has-error, .has-success').removeClass('has-error').removeClass('has-success');

            $_obj.show();
            updateDependantOptionsDOM();
            hasChanged();

            $('html').animate({
                scrollTop: $_obj.offset().top - 50
            }, 250);
        }
    }

    function dropDependant() {
        if (_dependents > 0) {
            $('#health_application_dependants_dependant' + _dependents).find("input[type=text]").each(function () {
                $(this).val("");
            });
            $('#health_application_dependants_dependant' + _dependents).find("input[type=radio]:checked").each(function () {
                this.checked = false;
            });
            $('#health_application_dependants_dependant' + _dependents).find("select").each(function () {
                $(this).removeAttr("selected");
            });
            $('#health_application_dependants_dependant' + _dependents).hide();
            _dependents--;
            updateDependantOptionsDOM();
            hasChanged();

            if (_dependents > 0) {
                $_obj = $('#health_application_dependants_dependant' + _dependents);
            } else {
                $_obj = $('#health_application_dependants-selection');
            }

            $('html').animate({
                scrollTop: $_obj.offset().top - 50
            }, 250);
        }
    }

    function checkDependant(e) {
        var index = e;
        if (isNaN(e) && typeof e == 'object') {
            index = e.data;
        }
        // Create an age check mechanism
        var dob = $('#health_application_dependants_dependant' + index + '_dob').val();
        var age;

        if (!dob.length) {
            age = 0;
        } else {
            age = getAge(dob);
            if (isNaN(age)) {
                return false;
            }
        }

        // Check the individual questions
        addFullTime(index, age);
        addSchool(index, age);
        addDefacto(index, age);
        addApprentice(index, age);
    }

    function updateDependantOptionsDOM() {
        if (_dependents <= 0) {
            // hide all remove dependant buttons
            $("#health_application_dependants-selection").find(".remove-last-dependent").hide();

            $('#health_application_dependants_threshold').slideDown();
            //$("#health_application_dependants_dependantrequired").val("").addClass("validate");
        } else if (!$("#dependents_list_options").find(".remove-last-dependent").is(":visible")) {
            $('#health_application_dependants_threshold').slideUp();

            // Show ONLY the last remove dependant button
            $("#health_application_dependants-selection").find(".remove-last-dependent").hide(); // 1st, hide all.
            $("#health_application_dependants-selection .health_dependant_details:visible:last").find(".remove-last-dependent").show();


            //$("#health_application_dependants_dependantrequired").val("ignoreme").removeClass("validate");
        }

        if (_dependents >= _limit) {
            $("#health-dependants").find(".add-new-dependent").hide();
        } else if ($("#health-dependants").find(".add-new-dependent").not(":visible")) {
            $("#health-dependants").find(".add-new-dependent").show();
        }
    }

    function addFullTime(index, age) {
        if (config.fulltime !== true) {
            $('#health_application_dependants-selection').find('.health_dependant_details_fulltimeGroup').hide();
            // reset validation of dob to original
            //TODO: Fix this to ensure the rules are added/removed properly.
            $('#health_application_dependants_dependant' + index + '_dob').removeRule('validateFulltime').addRule('limitDependentAgeToUnder25');
            return false;
        }

        if ((age >= config.schoolMin) && (age <= config.schoolMax)) {
            $('#health_application_dependants-selection').find('.dependant' + index).find('.health_dependant_details_fulltimeGroup').show();
        } else {
            $('#health_application_dependants-selection').find('.dependant' + index).find('.health_dependant_details_fulltimeGroup').hide();
        }

        // change validation method for dob field if fulltime is enabled
        //TODO: Fix this to ensure the rules are added/removed properly.
        $('#health_application_dependants_dependant' + index + '_dob').removeRule('limitDependentAgeToUnder25').addRule('validateFulltime');
    }

    function addSchool(index, age) {
        if (config.school === false) {
            $('#health_application_dependants-selection').find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').hide();
            return false;
        }
        if ((age >= config.schoolMin) && (age <= config.schoolMax)
            && (config.fulltime !== true || $('#health_application_dependants_dependant' + index + '_fulltime_Y').is(':checked'))) {
            $('#health_application_dependants-selection').find('.dependant' + index).find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').show();
            // Show/hide ID number field, with optional validation
            if (config.schoolID === false) {
                $('#health_application_dependants-selection').find('.dependant' + index).find('.health_dependant_details_schoolIDGroup').hide();
            }
            else {
                $('#health_application_dependants_dependant' + index + '_schoolID').setRequired(config.schoolIDMandatory, 'Please enter dependant ' + index + '\'s student ID');
            }
            // Show/hide date study commenced field, with optional validation
            if (config.schoolDate !== true) {
                $('#health_application_dependants-selection').find('.dependant' + index).find('.health_dependant_details_schoolDateGroup').hide();
            }
            else {
                $('#health_application_dependants_dependant' + index + '_schoolDate').setRequired(config.schoolDateMandatory, 'Please enter date that dependant ' + index + ' commenced study');
            }
        } else {
            $('#health_application_dependants-selection').find('.dependant' + index).find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').hide();
        }
    }

    function addApprentice(index, age) {
        if (config.apprentice !== true) {
            $('#health_application_dependants-selection').find('.health_dependant_details_apprenticeGroup').hide();
            return false;
        }

        if ((age >= config.schoolMin) && (age <= config.schoolMax)) {
            $('#health_application_dependants-selection').find('.dependant' + index).find('.health_dependant_details_apprenticeGroup').show();
        } else {
            $('#health_application_dependants-selection').find('.dependant' + index).find('.health_dependant_details_apprenticeGroup').hide();
        }

        // change validation method for dob field if fulltime is enabled
        //$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_dob').rules('remove', 'limitDependentAgeToUnder25');
        //$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_dob').rules('add', 'validateFulltime');

    }

    function addDefacto(index, age) {
        if (config.defacto === false) {
            return false;
        }
        if ((age >= config.defactoMin) && (age <= config.defactoMax)) {
            $('#health_application_dependants-selection').find('.dependant' + index).find('.health_dependant_details_maritalincomestatus').show();
        } else {
            $('#health_application_dependants-selection').find('.dependant' + index).find('.health_dependant_details_maritalincomestatus').hide();
        }
    }

    function hasChanged() {
        var $_obj = $('#health_application_dependants-selection').find('.health-dependants-tier');
        if (healthCoverDetails.getRebateChoice() == 'N') {
            $_obj.slideUp();
        } else if (_dependents > 0) {
            // Call the summary panel error message
            //healthPolicyDetails.error();

            // Refresh/Call the Dependants and rebate tiers
            $('#health_healthCover_dependants').val(_dependents).trigger('change');

            // Change the income questions
            var $_original = $('#health_healthCover_tier');
            $_obj.find('select').html($_original.find('select').html());
            $_obj.find('#health_application_dependants_incomeMessage').text($_original.find('span').text());
            if ($_obj.is(':hidden')) {
                $_obj.slideDown();
            }
        } else {
            $_obj.slideUp();
        }
    }

    function getAge(dob) {
        var dob_pieces = dob.split("/");
        var year = Number(dob_pieces[2]);
        var month = Number(dob_pieces[1]) - 1;
        var day = Number(dob_pieces[0]);
        var today = new Date();
        var age = today.getFullYear() - year;
        if (today.getMonth() < month || (today.getMonth() == month && today.getDate() < day)) {
            age--;
        }

        return age;
    }

    meerkat.modules.register("healthDependants", {
        initHealthDependants: initHealthDependants,
        events: events,
        resetConfig: resetConfig,
        getConfig: getConfig,
        updateConfig: updateConfig,
        getMaxAge: getMaxAge,
        setMaxAge: setMaxAge,
        setDependants: setDependants,
        updateDependantOptionsDOM: updateDependantOptionsDOM
    });

})(jQuery);


