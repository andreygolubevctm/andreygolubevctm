;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var moduleEvents = {
        utilities: {},
        WEBAPP_LOCK: 'WEBAPP_LOCK',
        WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
    }, steps = null;

    function initUtilities() {

        $(document).ready(function () {

            // Only init if generic
            if (meerkat.site.vertical !== "utilities")
                return false;

            // Init common stuff
            initJourneyEngine();

            // Only continue if not confirmation page.
            if (meerkat.site.pageAction === "confirmation") {
                return false;
            }

            meerkat.modules.utilitiesForwardPopulation.configure();

            eventDelegates();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
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
            initProgressBar(false);

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
            }


            $(document).ready(function () {

                meerkat.modules.journeyEngine.configure({
                    startStepId: startStepId,
                    steps: _.toArray(steps)
                });

                if (meerkat.site.isNewQuote === false) {
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: 'trackQuoteEvent',
                        object: {
                            action: 'Retrieve'
                        }
                    });
                } else {
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: 'trackQuoteEvent',
                        object: {
                            action: 'Start'
                        }
                    });
                }
            });


        }
    }

    /**
     * Initialise and configure the progress bar.
     *
     * @param {bool} render
     */
    function initProgressBar(render) {
        setJourneyEngineSteps();
        configureProgressBar();
        if (render) {
            meerkat.modules.journeyProgressBar.render(true);
        }
    }

    function setJourneyEngineSteps() {

        var startStep = {
            title: 'Household details',
            navigationId: 'start',
            slideIndex: 0,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.utilities.getTrackingFieldsObject
            },
            onInitialise: function onStartInit(event) {
                meerkat.modules.jqueryValidate.initJourneyValidator();
                $('#utilities_resultsDisplayed_competition_optin').trigger('change.applyValidationRules');
            },
            validation: {
                validate: true,
                customValidation: function (callback) {
                    var $options = $('#utilities_householdDetails_whatToCompare').find('input[type=radio]'),
                        count = 0;

                    $options.each(function () {
                        if ($(this).prop('disabled')) {
                            count++;
                        }
                    });
                    var doContinue = count != 3;
                    if(!doContinue) {
                        meerkat.modules.utilitiesHouseholdDetailsFields.showErrorOccurred();
                    }
                    callback(doContinue);

                }
            }
        };

        var resultsStep = {
            title: 'Choose a plan',
            navigationId: 'results',
            slideIndex: 1,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.utilities.getTrackingFieldsObject
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.utilitiesResults.initPage();
                meerkat.modules.utilitiesSorting.initSorting();
                meerkat.modules.utilitiesMoreInfo.initMoreInfo();
                meerkat.modules.showMoreQuotesPrompt.initPromptBar();
                meerkat.modules.utilitiesSnapshot.initUtilitiesSnapshot();
            },
            onBeforeEnter: function enterResultsStep(event) {
                Results.removeSelectedProduct();
                // shouldn't do much of this when returning from enquire
                if (event.isForward === true) {
                    // Always force it to be a "Load" in utilities, as currently, we always get a new tranid.
                    meerkat.modules.resultsTracking.setResultsEventMode('Load');
                    $('#resultsPage').addClass('hidden');
                    meerkat.modules.utilitiesSorting.resetToDefaultSort();
                    meerkat.modules.utilitiesSorting.toggleColumns();
                    meerkat.modules.utilitiesSnapshot.onEnterResults();
                }
            },
            onAfterEnter: function afterEnterResults(event) {
                if (event.isForward === true) {
                    meerkat.modules.utilitiesResults.get();
                }
            },
            onAfterLeave: function(event) {
                if(event.isBackward) {
                    meerkat.modules.showMoreQuotesPrompt.disablePromptBar();
                }
            }
        };

        var enquiryStep = {
            title: 'Fill out your details',
            navigationId: 'enquiry',
            slideIndex: 2,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.utilities.getTrackingFieldsObject
            },
            onInitialise: function () {
                meerkat.modules.utilitiesEnquirySubmit.initUtilitiesEnquirySubmit();
            },
            onBeforeEnter: function () {
                meerkat.modules.utilitiesSnapshot.onEnterEnquire();
                meerkat.modules.utilitiesEnquiryFields.setContent();
            },
            onAfterEnter: function() {
                $("#utilities_application_details_email").trigger("change");
            }
        };

        steps = {
            startStep: startStep,
            resultsStep: resultsStep,
            enquiryStep: enquiryStep
        };

    }

    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([
            {
                label: 'Household details',
                navigationId: steps.startStep.navigationId
            },
            {
                label: 'Choose a plan',
                navigationId: steps.resultsStep.navigationId
            },
            {
                label: 'Fill out your details',
                navigationId: steps.enquiryStep.navigationId
            }
        ]);
    }

    function trackHandover() {
        var product = Results.getSelectedProduct();
        var transaction_id = meerkat.modules.transactionId.get();
        meerkat.modules.partnerTransfer.trackHandoverEvent({
            product: product,
            type: 'ONLINE',
            quoteReferenceNumber: transaction_id,
            productID: product.productId,
            productName: product.retailerName,
            productBrandCode: product.brandCode
        }, {type: "A", productId: product.productId });
    }

    // Build an object to be sent by SuperTag tracking.
    // Postcode, state,
    function getTrackingFieldsObject(special_case) {
        try {

            var marketOptIn = $('#utilities_resultsDisplayed_optinMarketing').val() === "Y" ? "Y" : "N";
            var okToCall = $('#utilities_resultsDisplayed_optinPhone').val() === "Y" ? "Y" : "N";

            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furthest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

            var email = $("#utilities_resultsDisplayed_email").val(),
                postCode = $("#utilities_householdDetails_postcode").val(),
                state = $("#utilities_householdDetails_state").val(),
                actionStep = '';

            switch (current_step) {
                case 0:
                    actionStep = "energy household";
                    break;
                case 1:
                    if (special_case === true) {
                        actionStep = 'energy more info';
                    } else {
                        actionStep = 'energy choose';
                    }
                    break;
                case 2:
                    actionStep = "energy your details";
                    break;
            }

            var response = {
                actionStep: actionStep,
                quoteReferenceNumber: meerkat.modules.utilitiesResults.getThoughtWorldReferenceNumber() || meerkat.modules.transactionId.get(),
                email: null,
                emailID: null,
                marketOptIn: null,
                okToCall: null,
                state: null,
                postCode: null
            };

            // Push in values from 2nd slide only when have been beyond it
            if (furthest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
                _.extend(response, {
                    email: email,
                    state: state,
                    postCode: postCode,
                    marketOptIn: marketOptIn,
                    okToCall: okToCall
                });
            }

            return response;

        } catch (e) {
            return false;
        }
    }

    function getVerticalFilter() {
        return $(".what-to-compare").find("input[type='radio']:checked").val() || null;
    }

    meerkat.modules.register("utilities", {
        init: initUtilities,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject,
        getVerticalFilter: getVerticalFilter,
        trackHandover: trackHandover
    });


})(jQuery);