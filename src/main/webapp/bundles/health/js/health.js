;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        moduleEvents = {
            health: {
                CHANGE_MAY_AFFECT_PREMIUM: 'CHANGE_MAY_AFFECT_PREMIUM',
                SNAPSHOT_FIELDS_CHANGE: 'SNAPSHOT_FIELDS_CHANGE'
            },
            WEBAPP_LOCK: 'WEBAPP_LOCK',
            WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
        },
        hasSeenResultsScreen = false,
        rates = null,
        steps = null,
        stateSubmitInProgress = false;

    /* This is a temporary function for the split test by altering the layout. */
    function adjustLayout() {
        var $mainform = $('#mainform');
        $mainform.find('.col-sm-8')
            .not('.short-list-item')
            .not('.nestedGroup .col-sm-8')
            .not('.results-column-container')
            .removeClass('col-sm-8').addClass('col-sm-9');
        $mainform.find('.col-sm-offset-4')
            .not('#applicationForm_1 .col-sm-offset-4')
            .not('#applicationForm_2 .col-sm-offset-4')
            .removeClass('col-sm-offset-4').addClass('col-sm-offset-3');
    }


    function configureContactDetails() {

        var contactDetailsOptinField = $("#health_contactDetails_optin");

        // define fields here that are multiple (i.e. email field on contact details and on application step) so that they get prefilled
        // or fields that need to publish an event when their value gets changed so that another module can pick it up
        // the category names are generally arbitrary but some are used specifically and should use those types (email, name, potentially phone in the future)
        var contactDetailsFields = {
            name: [
                {
                    $field: $("#health_contactDetails_name")
                },
                {
                    $field: $("#health_application_primary_firstname"),
                    $otherField: $("#health_application_primary_surname")
                }
            ],
            dob_primary: [
                {
                    $field: $("#health_healthCover_primary_dob"), // this is a hidden field
                    $fieldInput: $("#health_healthCover_primary_dob") // pointing at the same field as a trick to force change event on itself when forward populated
                },
                {
                    $field: $("#health_application_primary_dob"), // this is a hidden field
                    $fieldInput: $("#health_application_primary_dob") // pointing at the same field as a trick to force change event on itself when forward populated
                }
            ],
            dob_secondary: [
                {
                    $field: $('#partner-health-cover').find("input[name='health_healthCover_partner_dob']"), // this is a hidden field
                    $fieldInput: $('#partner-health-cover').find("input[name='health_healthCover_partner_dob']") // pointing at the same field as a trick to force change event on itself when forward populated
                },
                {
                    $field: $("#health_application_partner_dob"), // this is a hidden field
                    $fieldInput: $("#health_application_partner_dob") // pointing at the same field as a trick to force change event on itself when forward populated
                }
            ],
            email: [
                // email from details step
                {
                    $field: $("#health_contactDetails_email"),
                    $optInField: contactDetailsOptinField
                },
                // email from application step
                {
                    $field: $("#health_application_email"),
                    $optInField: $("#health_application_optInEmail")
                }
            ],
            mobile: [
                // mobile from details step
                {
                    $field: $("#health_contactDetails_contactNumber_mobile"),
                    $optInField: contactDetailsOptinField
                },
                // mobile from application step
                {
                    $field: $("#health_application_mobile"),
                    $fieldInput: $("#health_application_mobileinput")
                }
            ],
            otherPhone: [
                // otherPhone from details step
                {
                    $field: $("#health_contactDetails_contactNumber_other"),
                    $optInField: contactDetailsOptinField
                },
                // otherPhone from application step
                {
                    $field: $("#health_application_other"),
                    $fieldInput: $("#health_application_otherinput")
                }
            ],
            flexiPhone: [
                // flexiPhone from details step
                {
                    $field: $("#health_contactDetails_flexiContactNumber"),
                    $fieldInput: $("#health_contactDetails_flexiContactNumberinput")
                },
                // otherPhone and mobile from quote step
                {
                    $field: $("#health_application_mobileinput"),
                    $otherField: $("#health_application_otherinput")
                }
            ],
            flexiPhoneV2: [
                // flexiPhone from details step
                {
                    $field: $("#health_contactDetails_flexiContactNumber"),
                    $fieldInput: $("#health_contactDetails_flexiContactNumberinput")
                },
                // otherPhone and mobile from quote step
                {
                    $field: $("#health_contactDetails_contactNumber_mobile"),
                    $otherField: $("#health_contactDetails_contactNumber_other")
                }
            ],
            postcode: [
                // postcode from details step
                { $field: $("#health_situation_postcode") },
                //postcode from application step
                {
                    $field: $("#health_application_address_postCode"),
                    $fieldInput: $("#health_application_address_postCode")
                }
            ]
        };

        meerkat.modules.contactDetails.configure(contactDetailsFields);

    }

    // Use the situation value to determine if a partner is visible on the journey.
    function hasPartner() {
        var cover = $(':input[name="health_situation_healthCvr"]').val();
        if (cover == 'F' || cover == 'C') {
            return true;
        } else {
            return false;
        }
    }

    // Make the rates object available outside of this module.
    function getRates() {
        return rates;
    }

    // Make the rebate available publicly, and handle rates property being null.
    function getRebate() {
        if (!_.isNull(rates) && rates.rebate) {
            return rates.rebate;
        }
        else {
            return 0;
        }
    }

    // Set the rates object and hidden fields in the form so it is included in post data.
    function setRates(ratesObject) {
        rates = ratesObject;
        $("#health_rebate").val((rates.rebate || ''));
        $("#health_rebateChangeover").val((rates.rebateChangeover || ''));
        $("#health_loading").val((rates.loading || ''));
        $("#health_primaryCAE").val((rates.primaryCAE || ''));
        $("#health_partnerCAE").val((rates.partnerCAE || ''));

        meerkat.modules.healthResults.setLhcApplicable(rates.loading);
    }

    function loadRatesBeforeResultsPage(forceRebate, callback) {

        var $healthCoverDetails = $('#contactForm');

        var postData = {
            dependants: $healthCoverDetails.find(':input[name="health_healthCover_dependants"]').val(),
            income: $healthCoverDetails.find(':input[name="health_healthCover_income"]').val() || 0,
            rebate_choice: forceRebate === true ? 'Y' : $healthCoverDetails.find('input[name="health_healthCover_rebate"]:checked').val(),
            primary_dob: $healthCoverDetails.find('#health_healthCover_primary_dob').val(),
            primary_loading: $healthCoverDetails.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
            primary_current: meerkat.modules.healthAboutYou.getPrimaryCurrentCover(),
            primary_loading_manual: $healthCoverDetails.find('.primary-lhc').val(),
            cover: $('#startForm').find(':input[name="health_situation_healthCvr"]').val()
        };

        // If the customer answers Yes for current health insurance, assume 0% LHC
        if (postData.primary_current === 'Y' && postData.primary_loading !== 'N') {
            postData.primary_loading = 'Y';
        }

        if (hasPartner()) {
            postData.partner_dob = $healthCoverDetails.find('input[name="health_healthCover_partner_dob"]').val();
            postData.partner_current = meerkat.modules.healthAboutYou.getPartnerCurrentCover() || 'N';
            postData.partner_loading = $healthCoverDetails.find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val() || 'N';
            postData.partner_loading_manual = $healthCoverDetails.find('input[name="health_healthCover_partner_lhc"]').val();
        }

        if (!fetchRates(postData, true, callback)) {
            exception("Failed to fetch rates");
        }
    }

    // Load the rates object via ajax. Also validates currently filled in fields to ensure only valid attempts are made.
    function loadRates(callback) {

        var $healthCoverDetails = $('#contactForm');

        var postData = {
            dependants: $healthCoverDetails.find(':input[name="health_healthCover_dependants"]').val(),
            income: $healthCoverDetails.find(':input[name="health_healthCover_income"]').val() || 0,
            rebate_choice: $healthCoverDetails.find('input[name="health_healthCover_rebate"]:checked').val() || 'Y',
            primary_dob: $healthCoverDetails.find('#health_healthCover_primary_dob').val(),
            primary_loading: $healthCoverDetails.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
            primary_current: meerkat.modules.healthAboutYou.getPrimaryCurrentCover(),
            primary_loading_manual: $healthCoverDetails.find('.primary-lhc').val(),
            partner_dob: $healthCoverDetails.find('#health_healthCover_partner_dob').val(),
            partner_loading: $healthCoverDetails.find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val(),
            partner_current: meerkat.modules.healthAboutYou.getPartnerCurrentCover(),
            partner_loading_manual: $healthCoverDetails.find('.partner-lhc').val(),
            cover: $('#startForm').find(':input[name="health_situation_healthCvr"]').val()
        };

        if ($('#health_application_provider, #health_application_productId').val() === '') {

            // before application stage
            postData.primary_dob = $('#health_healthCover_primary_dob').val();

        } else {

            // in application stage
            postData.primary_dob = $('#health_application_primary_dob').val();
            postData.partner_dob = $('#health_application_partner_dob').val() || postData.primary_dob;  // must default, otherwise fetchRates fails.
            postData.primary_current = ( meerkat.modules.healthPreviousFund.getPrimaryFund() == 'NONE' ) ? 'N' : 'Y';
            postData.partner_current = ( meerkat.modules.healthPreviousFund.getPartnerFund() == 'NONE' ) ? 'N' : 'Y';

        }

        if (!fetchRates(postData, true, callback)) {
            exception("Failed to Fetch Health Rebate Rates");
        }
    }

    function fetchRates(postData, canSetRates, callback) {
        // Check if there is enough data to ask the server.
        var coverTypeHasPartner = hasPartner();
        if (postData.cover === '') return false;
        if (postData.rebate_choice === '') return false;
        if (postData.primary_dob === '') return false;
        if (coverTypeHasPartner && postData.partner_dob === '')  return false;

        if (meerkat.modules.age.returnAge(postData.primary_dob) < 0) return false;
        if (coverTypeHasPartner && meerkat.modules.age.returnAge(postData.partner_dob) < 0)  return false;
        if (postData.rebate_choice === "Y" && postData.income === "") return false;

        // check in valid date format
        var dateRegex = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;

        if (!postData.primary_dob.match(dateRegex)) return false;
        if (coverTypeHasPartner && !postData.partner_dob.match(dateRegex))  return false;

        return meerkat.modules.comms.post({
            url: "ajax/json/health_rebate.jsp",
            data: postData,
            cache: true,
            errorLevel: "warning",
            onSuccess: function onRatesSuccess(data) {
                if (canSetRates === true) setRates(data);
                if (!_.isNull(callback) && typeof callback !== 'undefined') {
                    callback(data);
                }
            }
        });
    }


    function changeStateAndQuote(event) {
        event.preventDefault();

        var suburb = $('#health_application_address_suburbName').val();
        var postcode = $('#health_application_address_postCode').val();
        var state = $('#health_application_address_state').val();
        $('#health_situation_location').val([suburb, postcode, state].join(' '));
        $('#health_situation_suburb').val(suburb);
        $('#health_situation_postcode').val(postcode);
        $('#health_situation_state').val(state);
        healthChoices.setState(state);

        window.location = this.href;

        var handler = meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function changeStateAndQuoteStep(step) {
            meerkat.messaging.unsubscribe(meerkatEvents.journeyEngine.STEP_CHANGED, handler);
            meerkat.modules.healthResults.get();
        });

        //OLD CODE: Results.resubmitForNewResults();
    }


    function enableSubmitApplication() {
        // Enable button, hide spinner
        var $button = $('#submit_btn');
        $button.removeClass('disabled');
        meerkat.modules.loadingAnimation.hide($button);
    }

    function disableSubmitApplication(isSameSource) {
        // Disable button, show spinner
        var $button = $('#submit_btn');
        $button.addClass('disabled');
        if (isSameSource === true) {
            meerkat.modules.loadingAnimation.showAfter($button);
        }
    }

    function submitApplication() {

        if (stateSubmitInProgress === true) {
            alert('Your application is still being submitted. Please wait.');
            return;
        }
        stateSubmitInProgress = true;

        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'submitApplication' });

        try {

            Results.updateApplicationEnvironment();

            var postData = meerkat.modules.journeyEngine.getFormData();

            // Disable fields must happen after the post data has been collected.
            meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'submitApplication', disableFields: true });


            var healthApplicationUrl = "ajax/json/health_application.jsp";
            if (meerkat.modules.splitTest.isActive(401) || meerkat.site.isDefaultToHealthApply) {
                healthApplicationUrl = "ajax/json/health_application_ws.jsp";
            }

            meerkat.modules.comms.post({
                url: healthApplicationUrl,
                data: postData,
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "silent",
                timeout: 250000, //10secs more than SOAP timeout
                onSuccess: function onSubmitSuccess(resultData) {

                    meerkat.modules.leavePageWarning.disable();

                    var redirectURL = "health_confirmation.jsp?action=confirmation&transactionId=" + meerkat.modules.transactionId.get() + "&token=";
                    var extraParameters = "";

                    if (meerkat.site.utm_source !== '' && meerkat.site.utm_medium !== '' && meerkat.site.utm_campaign !== '') {
                        extraParameters = "&utm_source=" + meerkat.site.utm_source + "&utm_medium=" + meerkat.site.utm_medium + "&utm_campaign=" + meerkat.site.utm_campaign;
                    }

                    // Success
                    if (resultData.result && resultData.result.success) {
                        window.location.replace(redirectURL + resultData.result.confirmationID + extraParameters);

                        // Pending and not a call centre user (we want them to see the errors)
                    } else if (resultData.result && resultData.result.pendingID && resultData.result.pendingID.length > 0 && (!resultData.result.callcentre || resultData.result.callcentre !== true)) {
                        window.location.replace(redirectURL + resultData.result.pendingID + extraParameters);

                        // Handle errors
                    } else {
                        // Normally this shouldn't be reached because it should go via the onError handler thanks to the comms module detecting the error.
                        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'submitApplication' });
                        handleSubmittedApplicationErrors(resultData);
                    }
                },
                onError: onSubmitApplicationError,
                onComplete: function onSubmitComplete() {
                    stateSubmitInProgress = false;
                }
            });

        }
        catch (e) {
            stateSubmitInProgress = false;
            onSubmitApplicationError();
        }

    }

    function onSubmitApplicationError(jqXHR, textStatus, errorThrown, settings, data) {
        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'submitApplication' });
        stateSubmitInProgress = false;
        if (errorThrown == meerkat.modules.comms.getCheckAuthenticatedLabel()) {
            // Handling of this error is defined in comms module
        } else if (textStatus == 'Server generated error') {
            handleSubmittedApplicationErrors(errorThrown);
        } else {
            handleSubmittedApplicationErrors(data);
        }
    }

    function handleSubmittedApplicationErrors(resultData) {
        var error = resultData;
        if (resultData.hasOwnProperty("error") && typeof resultData.error == "object") {
            error = resultData.error;
        }


        var msg = '';
        var validationFailure = false;
        try {
            // Handle errors return by provider
            if (resultData.result && resultData.result.errors) {
                var target = resultData.result.errors;
                if ($.isArray(target.error)) {
                    target = target.error;
                }
                $.each(target, function (i, error) {
                    msg += "<p>";
                    msg += '[Code: ' + error.code + '] ' + error.text;
                    msg += "</p>";
                });
                if (msg === '') {
                    msg = 'An unhandled error was received.';
                }
                // Handle internal SOAP error
            } else if (error && error.hasOwnProperty("type")) {
                switch (error.type) {
                    case "validation":
                        validationFailure = true;
                        break;
                    case "timeout":
                        msg = "Fund application service timed out.";
                        break;
                    case "parsing":
                        msg = "Error parsing the XML request - report issue to developers.";
                        break;
                    case "confirmed":
                        msg = error.message;
                        break;
                    case "transaction":
                        msg = error.message;
                        break;
                    case "submission":
                        msg = error.message;
                        break;
                    default:
                        msg = '[' + error.code + '] ' + error.message + " (Please report to IT before continuing)";
                        break;
                }
                // Handle unhandled error
            } else {
                msg = 'An unhandled error was received.';
            }
        } catch (e) {
            msg = 'Application unsuccessful. Failed to handle response: ' + e.message;
        }

        if (validationFailure) {
            meerkat.modules.serverSideValidationOutput.outputValidationErrors({
                validationErrors: error.errorDetails.validationErrors,
                startStage: 'payment'
            });
            if (typeof error.transactionId != 'undefined') {
                meerkat.modules.transactionId.set(error.transactionId);
            }
        } else {

            // Only show the real error to the Call Centre operator
            if (meerkat.site.isCallCentreUser === false) {
                msg = "Please contact us on <span class=\"callCentreHelpNumber\">" + meerkat.site.content.callCentreHelpNumber + "</span> for assistance.";
            }
            meerkat.modules.errorHandling.error({
                message: "<strong>Application failed:</strong><br/>" + msg,
                page: "health.js",
                errorLevel: "warning",
                description: "handleSubmittedApplicationErrors(). Submit failed: " + msg,
                data: resultData
            });

            //call the custom fail handler for each fund
            if (healthFunds.applicationFailed) {
                healthFunds.applicationFailed();
            }
        }

    }

    // Hide/show about you
    function toggleAboutYou() {

        if (meerkat.site.isFromBrochureSite === true) {
            var $healthSitLocation = $('#health_situation_location'),
                $healthSitHealthCvr = $('#health_situation_healthCvr');

            if ($healthSitHealthCvr.isValid()) {
                $healthSitHealthCvr.attr('data-attach', 'true').blur()/*.parents('.fieldrow').hide()*/;
            }

            if ($healthSitLocation.isValid(true)) {
                $healthSitLocation.attr('data-attach', 'true').blur()/*.parents('.fieldrow').hide()*/;
            }

            if ($healthSitHealthCvr.val() !== '') {
                $('.health-cover').addClass('hidden');
            }

            if ($healthSitLocation.val() !== '') {
                $('.health-location').addClass('hidden');
            }

            if ($healthSitHealthCvr.val() !== '' && $healthSitLocation.val() !== '') {
                $('.health-about-you, .health-about-you-title').addClass('hidden');
            }

            $('.btn-edit').on('click', function () {
                toggleAboutYou();
            });

            meerkat.site.isFromBrochureSite = false;
        } else {
            $('.health-cover').removeClass('hidden');
            $('.health-location').removeClass('hidden');
            $('.health-about-you, .health-about-you-title').removeClass('hidden');
            $('.health-situation .fieldset-column-side .sidebar-box').css('margin-top', '');
        }
    }

    function toggleRebate() {
        if (meerkat.modules.healthCoverDetails.isRebateApplied()) {
            $('#health_healthCover_tier').show();
            if (getSituation() === 'F' || getSituation() === 'SPF') {
                $('.health_cover_details_dependants').show();
            }
        } else {
            $('#health_healthCover_tier').hide();
            $('.health_cover_details_dependants').hide();
        }
        meerkat.modules.healthCoverDetails.setIncomeBase();
    }

    function initHealth() {

        var self = this;

        $(document).ready(function () {

            // Only init if health... obviously...
            if (meerkat.site.vertical !== "health") return false;

            // Init common stuff
            initJourneyEngine();

            // Only continue if not confirmation page.
            if (meerkat.site.pageAction === "confirmation") return false;



            eventSubscriptions();
            configureContactDetails();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {

                // If retrieving a quote and a product had been selected, inject the fund's application set.
                if (typeof healthFunds !== 'undefined' && healthFunds.checkIfNeedToInjectOnAmend) {
                    healthFunds.checkIfNeedToInjectOnAmend(function onLoadedAmeded() {
                        // Need to mark any populated field with a data attribute so it is picked up with by the journeyEngine.getFormData()
                        // This is because values from forward steps will not be selected and will be lost when the quote is re-saved.
                        meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
                    });
                } else {
                    meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
                }
            }

            $("#health_contactDetails_optin").on("click", function () {
                var optinVal = $(this).is(":checked") ? "Y" : "N";
                $('#health_privacyoptin').val(optinVal);
                $("#health_contactDetails_optInEmail").val(optinVal);
                $("#health_contactDetails_call").val(optinVal);
            });

            if ($('input[name="health_directApplication"]').val() === 'Y') {
                $('#health_application_productId').val(meerkat.site.loadProductId);
                $('#health_application_productTitle').val(meerkat.site.loadProductTitle);
            }

            if (meerkat.site.isCallCentreUser === true) {
                meerkat.modules.simplesSnapshot.initSimplesSnapshot();
            }

            adjustLayout();

        });


    }

    function getCoverType() {
        return $('#health_situation_coverType input').filter(":checked").val();
    }

    function getSituation() {
        return $('#health_situation_healthCvr').val();
    }

    function getHospitalCoverLevel() {
        return $('#health_benefits_covertype').val();
    }

    meerkat.modules.register("health", {
        init: initHealth,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject,
        getCoverType: getCoverType,
        getSituation: getSituation,
        getHospitalCoverLevel: getHospitalCoverLevel,
        getRates: getRates,
        setRates: setRates,
        getRebate: getRebate,
        fetchRates: fetchRates,
        loadRates: loadRates,
        loadRatesBeforeResultsPage: loadRatesBeforeResultsPage,
        hasPartner: hasPartner
    });

})(jQuery);