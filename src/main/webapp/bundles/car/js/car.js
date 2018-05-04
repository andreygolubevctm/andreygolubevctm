/**
 * Description: External documentation:
 */

(function ($, undefined) {

    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
        car: {},
        WEBAPP_LOCK: 'WEBAPP_LOCK',
        WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
    }, steps = null;

    var templateAccessories;

    // Elements
    var $typeOfCover;

    function initCar() {
        $(document).ready(function () {

            // Only init if car
            if (meerkat.site.vertical !== "car")
                return false;

            $typeOfCover = $('#quote_typeOfCover');

            // Init common stuff
            initJourneyEngine();

            // Only continue if not confirmation page.
            if (meerkat.site.pageAction === "confirmation") {
                return false;
            }

            eventDelegates();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }

            var $e = $('#quote-accessories-template');
            if ($e.length > 0) {
                templateAccessories = _.template($e.html());
            }
            $e = $('#more-info-template');
            if ($e.length > 0) {
                templateMoreInfo = _.template($e.html());
            }
            $e = $('#calldirect-template');
            if ($e.length > 0) {
                templateCallDirect = _.template($e.html());
            }
        });

    }

    function eventDelegates() {

    }

    function initJourneyEngine() {

        if (meerkat.site.pageAction === "confirmation") {

            meerkat.modules.journeyEngine.configure(null);

        } else {

            // Initialise the journey engine steps and bar
            initProgressBar(true);

            // Initialise the journey engine
            var startStepId = null;
            if (meerkat.site.isFromBrochureSite === true) {
                startStepId = steps.startStep.navigationId;
            }
            // Use the stage user was on when saving their quote
            else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'latest') {
                startStepId = steps.resultsStep.navigationId;
            } else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'amend') {
                startStepId = steps.startStep.navigationId;
            } else {
                startStepId = meerkat.modules.emailLoadQuote.getStartStepOverride(startStepId);
            }

            // Defered to allow time for the slide modules to init e.g. vehicle selection
            $(document).ready(function () {
                var callback = function delayedJourneyEngineInit() {
                    meerkat.modules.journeyEngine.configure({
                        startStepId: startStepId,
                        steps: _.toArray(steps)
                    });

                    // Call initial supertag call
                    var transaction_id = meerkat.modules.transactionId.get();

                    if (meerkat.site.isNewQuote === false) {
                        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                            method: 'trackQuoteEvent',
                            object: {
                                action: 'Retrieve',
                                transactionID: parseInt(transaction_id, 10),
                                vertical: meerkat.site.vertical
                            }
                        });
                    } else {
                        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                            method: 'trackQuoteEvent',
                            object: {
                                action: 'Start',
                                transactionID: parseInt(transaction_id, 10),
                                vertical: meerkat.site.vertical
                            }
                        });
                    }
                };

                /* create delay when quote is not new so that journey
                   can finish setting up before directing to results.
                   And yes!, a defer will not cut the mustard */
                if(meerkat.site.isNewQuote === false) {
                    _.delay(callback, 500);
                } else {
                    callback();
                }
            });
        }
    }

    /**
     * Initialise and configure the progress bar.
     *
     * @param {bool}
     *            render
     */
    function initProgressBar(render) {
        setJourneyEngineSteps();
        configureProgressBar();
        if (render) {
            meerkat.modules.journeyProgressBar.render(true);
        }
    }
    
    function initAddressSearch() {
      var xpath = 'quote/riskAddress';
      meerkat.modules.addressLookupV2.getStreetSearch().init(xpath);
      meerkat.modules.addressLookupV2.getHiddenPostcodeSearch().init('street', xpath);
    }

    function setJourneyEngineSteps() {

        var startStep = {
            title: 'Your Car',
            navigationId: 'start',
            slideIndex: 0,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.car.getTrackingFieldsObject
            },
            onInitialise: function onStartInit(event) {
                meerkat.modules.jqueryValidate.initJourneyValidator();
                meerkat.modules.currencyField.initCurrency();
                // Hook up privacy optin to Email Quote button
                var $emailQuoteBtn = $(".slide-feature-emailquote, .save-quote");

                // Initial value from preload/load quote
                if ($("#quote_privacyoptin").is(':checked')) {
                    $emailQuoteBtn.addClass("privacyOptinChecked");
                }

                $("#quote_privacyoptin").on('change', function (event) {
                    if ($(this).is(':checked')) {
                        $emailQuoteBtn.addClass("privacyOptinChecked");
                    } else {
                        $emailQuoteBtn.removeClass("privacyOptinChecked");
                    }
                });

                if (meerkat.site.isRegoLookup) {
                    meerkat.modules.carRegoLookup.triggerEntry();
                } else {
                    // runs lookup() regardless...
                    if (!meerkat.modules.carExotic.isExotic() && !meerkat.modules.carRegoLookup.lookup() && meerkat.site.tracking.brandCode === 'ctm') {
                        // if lookup() returns false runs the redirect function
                        meerkat.modules.carRegoLookup.redirectToRegoFields();
                    }
                }

                configureContactDetails();
                initAddressSearch();
            },
            validation: {
                validate: true,
                customValidation: function (callback) {
                    if (!meerkat.modules.carExotic.isExotic()) {
                        if (meerkat.modules.carRegoLookup.isRegoLookupMode()) {
                            meerkat.modules.carRegoLookup.setSearchState();
                            meerkat.modules.carRegoLookup.setSearchRego();
                            meerkat.modules.carRegoLookup.lookup(callback);
                        } else {
                            $('#quote_vehicle_selection').find('select').each(function () {
                                if ($(this).is('[disabled]')) {
                                    callback(false);
                                    return;
                                }
                            });
                            callback(true);
                        }
                    } else {
                        callback(true);
                    }
                }
            }
        };

        var optionsStep = {
            title: 'Car Details',
            navigationId: 'options',
            slideIndex: 1,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.car.getTrackingFieldsObject
            },
            tracking: {
                touchType: 'H',
                touchComment: 'OptionsAccs',
                includeFormData: true
            },
            onInitialise: function () {
                meerkat.modules.octoberComp.closeMobileBanner();
                meerkat.modules.carTypeOfCover.initCarTypeOfCover();
                meerkat.modules.carCommencementDate.initCarCommencementDate();
                meerkat.modules.carYoungDrivers.initCarYoungDrivers();
                meerkat.modules.carUsingYourCar.initUsingYourCar();
            },
            onBeforeEnter: function (event) {
                meerkat.modules.carExotic.toggleQuestions();
                meerkat.modules.carExotic.updateSpeechBubble();
            }
        };

        var detailsStep = {
            title: 'Driver Details',
            navigationId: 'details',
            slideIndex: 2,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.car.getTrackingFieldsObject
            },
            tracking: {
                touchType: 'H',
                touchComment: 'DriverDtls',
                includeFormData: true
            },
            onBeforeEnter: function (event) {
                meerkat.modules.carExotic.toggleReasonFields();
            }
        };

        var addressStep = {
            title: 'Address & Contact',
            navigationId: 'address',
            slideIndex: 3,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.car.getTrackingFieldsObject
            },
            tracking: {
                touchType: 'H',
                touchComment: 'AddressCon',
                includeFormData: true
            },
            onInitialise: function (event) {
                meerkat.modules.resultsFeatures.fetchStructure('carws_');
            },
            onBeforeEnter: function (event) {
                meerkat.modules.carExotic.toggleRequiredFields();
            },
            onAfterEnter: function (event) {
            },
            onBeforeLeave: function (event) {
            }
        };

        var resultsStep = {
            title: 'Results',
            navigationId: 'results',
            slideIndex: 4,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.car.getTrackingFieldsObject
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.octoberComp.hideMobileBanner();
                meerkat.modules.octoberComp.showNav();
                meerkat.modules.carResults.initPage();
                meerkat.modules.carMoreInfo.initMoreInfo();
                meerkat.modules.carFilters.initCarFilters();
                meerkat.modules.carEditDetails.initEditDetails();
                meerkat.modules.resultsMobileDisplayModeToggle.initToggle();
            },
            onBeforeEnter: function enterResultsStep(event) {
                meerkat.modules.journeyProgressBar.hide();
                $('#resultsPage').addClass('hidden');
                meerkat.modules.carExotic.toggleNavBarContents();
                // show disclaimer here.
                // Sync the filters to the results engine
                if (!meerkat.modules.carExotic.isExotic()) {
                    if (meerkat.modules.deviceMediaState.get() === 'xs') {
                        meerkat.modules.mobileNavButtons.enable();
                    }
                    meerkat.modules.carFilters.updateFilters();
                } else {
                    if (meerkat.modules.deviceMediaState.get() === 'xs') {
                        meerkat.modules.mobileNavButtons.disableSpecificButtons('refine,save');
                        meerkat.modules.saveQuote.disable();
                    }
                    meerkat.modules.tracking.recordTouch('R','Results Page', 'FAME-01-01', true);
                    meerkat.modules.tracking.recordTouch('EC','Famous Transaction', 'FAME-01-01', true);
                }
            },
            onAfterEnter: function afterEnterResults(event) {
                meerkat.modules.carResults.get();

                // Show the filters bar
                meerkat.modules.carFilters.show();
                if (!meerkat.modules.carExotic.isExotic()) {
                    meerkat.modules.carFilters.enable();

                    $('.header-wrap .quoteSnapshot').removeClass("hidden");
                } else {
                    meerkat.modules.carFilters.disable();
                }
            },
            onBeforeLeave: function (event) {
                // Increment the transactionId
                if (event.isBackward === true) {
                    meerkat.modules.transactionId.getNew(3);
                    $('.header-wrap .quoteSnapshot').addClass("hidden");
                }
            },
            onAfterLeave: function (event) {
                meerkat.modules.journeyProgressBar.show();
                meerkat.modules.octoberComp.showMobileBanner();
                meerkat.modules.octoberComp.hideNav();
                // Hide the filters bar
                meerkat.modules.carFilters.hide();
                meerkat.modules.carEditDetails.hide();
            }
        };

        steps = {
            startStep: startStep,
            optionsStep: optionsStep,
            detailsStep: detailsStep,
            addressStep: addressStep,
            resultsStep: resultsStep
        };

    }

    function configureProgressBar() {

        var progressBarConfig = [
            {
                label: 'Your Car',
                navigationId: steps.startStep.navigationId
            },
            {
                label: 'Car Details',
                navigationId: steps.optionsStep.navigationId
            },
            {
                label: 'Driver Details',
                navigationId: steps.detailsStep.navigationId
            },
            {
                label: 'Address & Contact',
                navigationId: steps.addressStep.navigationId
            },
            {
                label: 'Your Quotes',
                navigationId: steps.resultsStep.navigationId
            }
        ];
        // Combines the first two steps in the progress bar.
        // Make car details match your car.
        progressBarConfig[0].matchAdditionalSteps = [steps.optionsStep.navigationId];
        //Remove the car details step.
        progressBarConfig.splice(1,1);
        meerkat.modules.journeyProgressBar.configure(progressBarConfig);
    }

    function getVerticalFilter() {
        return $typeOfCover.val() || null;
    }

    // Build an object to be sent by SuperTag tracking.
    function getTrackingFieldsObject(special_case) {
        try {

            special_case = special_case || false;

            var yob = $('#quote_drivers_regular_dob').val();
            if (yob.length > 4) {
                yob = yob.substring(yob.length - 4);
            }

            var gender = null;
            var gVal = $('input[name=quote_drivers_regular_gender]:checked').val();
            if (!_.isUndefined(gVal)) {
                switch (gVal) {
                    case 'M':
                        gender = 'Male';
                        break;
                    case 'F':
                        gender = 'Female';
                        break;
                }
            }

            var marketOptIn = null;
            var mVal = $('input[name=quote_contact_marketing]:checked').val();
            if (!_.isUndefined(mVal)) {
                marketOptIn = mVal;
            }

            var okToCall = null;
            var oVal = $('input[name=quote_contact_oktocall]:checked').val();
            if (!_.isUndefined(oVal)) {
                okToCall = oVal;
            }

            var postCode = $('#quote_riskAddress_postCode').val();
            var stateCode = $('#quote_riskAddress_state').val();
            var vehYear = $('#quote_vehicle_year').val();
            var vehMake = $('#quote_vehicle_make option:selected').text();
            var $vehicleUsage = $('#quote_vehicle_use');
            var $vehicleFieldSet = $('#quote_vehicleFieldSet');
            var coverType = $('#quote_typeOfCover').val();

            var vehUsage = $vehicleUsage.text();

            if ($vehicleUsage[0].selectedIndex > 1) {
                if ($vehicleFieldSet.find('.goodsPayment input:checked').val() == 'Y') {
                    vehUsage = $vehicleFieldSet.find('.goodsPayment').text();
                } else if ($vehicleFieldSet.find('.passengerPayment input:checked').val() == 'Y') {
                    vehUsage = $vehicleFieldSet.find('.passengerPayment').text();
                }
            }

            // strip anything after the ?
            if (vehUsage.indexOf("?") > 0) {
                vehUsage = vehUsage.substr(0, vehUsage.indexOf("?"));
            }

            // finally check if it's over 100 characters. If so chop it back to 98
            if (vehUsage.length > 100) {
                vehUsage = vehUsage.substr(0, 98);
            }

            var email = $('#quote_contact_email').val();

            var commencementDate = $("#quote_options_commencementDate").val();

            var transactionId = meerkat.modules.transactionId.get();

            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

            var actionStep = '';

            switch (current_step) {
                case 0:
                    actionStep = "your car";
                    break;
                case 1:
                    actionStep = 'car details';
                    break;
                case 2:
                    actionStep = 'driver details';
                    break;
                case 3:
                    actionStep = 'address contact';
                    break;
                case 4:
                    if (special_case === true) {
                        actionStep = 'more info';
                    } else {
                        actionStep = 'car results';
                    }
                    break;
            }

            var response = {
                vertical: meerkat.site.vertical,
                actionStep: actionStep,
                transactionID: transactionId,
                quoteReferenceNumber: transactionId,
                yearOfManufacture: null,
                makeOfCar: null,
                vehicleUsage: null,
                gender: null,
                yearOfBirth: null,
                postCode: null,
                state: null,
                email: null,
                emailID: null,
                marketOptIn: null,
                okToCall: null,
                commencementDate: null,
                verticalFilter: null
            };

            // Push in values from 1st slide only when have been beyond it
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
                _.extend(response, {
                    yearOfManufacture: vehYear,
                    makeOfCar: vehMake
                });
            }

            // Push in values from 2nd slide only when have been beyond it
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('options')) {
                _.extend(response, {
                    vehicleUsage: vehUsage,
                    verticalFilter: coverType
                });
            }

            // Push in values from 2nd slide only when have been beyond it
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('details')) {
                _.extend(response, {
                    yearOfBirth: yob,
                    gender: gender
                });
            }

            // Push in values from 2nd slide only when have been beyond it
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('address')) {
                _.extend(response, {
                    postCode: postCode,
                    state: stateCode,
                    email: email,
                    marketOptIn: marketOptIn,
                    okToCall: okToCall,
                    commencementDate: commencementDate
                });
            }

            var crossVerticalOptin = meerkat.modules.leadCapture.getTrackingData();

            if (crossVerticalOptin !== null && current_step === meerkat.modules.journeyEngine.getStepIndex('results')) {
                _.extend(response, {
                    crossVerticalOptin: crossVerticalOptin
                });
            }

            return response;

        } catch (e) {
            return false;
        }
    }

    function configureContactDetails(){
        var contactDetailsFields = {
            email: [
                {
                    $field: $("#quote_contact_email"),
                    $optInField: $("#quote_contact_marketing")
                }
            ]
        };
        meerkat.modules.contactDetails.configure(contactDetailsFields);
    }

    meerkat.modules.register("car", {
        init: initCar,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject,
        getVerticalFilter: getVerticalFilter
    });

})(jQuery);
