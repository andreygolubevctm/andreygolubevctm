/**
 * Description: Roadside setup
 */
;(function ($, undefined) {


    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var moduleEvents = {
        roadside: {},
        WEBAPP_LOCK: 'WEBAPP_LOCK',
        WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
    }, steps = null;

    function initRoadside() {

        $(document).ready(function () {

            // Only init if generic
            if (meerkat.site.vertical !== "roadside")
                return false;

            initStickyHeader();

            // Init common stuff
            initJourneyEngine();

            eventDelegates();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }

        });

    }

    function initStickyHeader() {
        $(window).scroll(function() {
            var windowYOffset = window.pageYOffset;
            if (windowYOffset >= 16) {
                $('.header-wrap').addClass('stuck');
                $('#logo').addClass('stuck');
            } else {
                $('.header-wrap').removeClass('stuck');
                $('#logo').removeClass('stuck');
            }
        });
    }

    function eventDelegates() {

    }

    function initJourneyEngine() {

        // Initialise the journey engine steps and bar
        initProgressBar(false);

        // Initialise the journey engine
        var startStepId = null;
        if (meerkat.site.isFromBrochureSite === true) {
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
                        action: 'Retrieve',
                        vertical: meerkat.site.vertical
                    }
                });
            } else {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: 'trackQuoteEvent',
                    object: {
                        action: 'Start',
                        vertical: meerkat.site.vertical
                    }
                });
            }
        });
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

    function setJourneyEngineSteps() {

        var startStep = {
            title: 'Your Car',
            navigationId: 'start',
            slideIndex: 0,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.roadside.getTrackingFieldsObject
            },
            onInitialise: function onStartInit(event) {
                meerkat.modules.jqueryValidate.initJourneyValidator();
            }
        };

        var results = {
            title: 'Roadside Quotes',
            navigationId: 'results',
            slideIndex: 1,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.roadside.getTrackingFieldsObject
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.roadsideResults.initPage();
                meerkat.modules.roadsideMoreInfo.initMoreInfo();
                meerkat.modules.showMoreQuotesPrompt.initPromptBar();
                meerkat.modules.roadsideSorting.initSorting();
                meerkat.modules.partnerTransfer.initTransfer();
            },
            onBeforeEnter: function enterResultsStep(event) {
                Results.removeSelectedProduct();
                // Always force it to be a "Load" in utilities, as currently, we always get a new tranid.
                meerkat.modules.resultsTracking.setResultsEventMode('Load');
                $('#resultsPage').addClass('hidden');
                meerkat.modules.roadsideSorting.resetToDefaultSort();
            },
            onAfterEnter: function afterEnterResults(event) {
                if (event.isForward === true) {
                    meerkat.modules.roadsideResults.get();
                }
            }, onAfterLeave: function(event) {
                if(event.isBackward) {
                    meerkat.modules.showMoreQuotesPrompt.disablePromptBar();
                }
            }
        };

        steps = {
            startStep: startStep,
            results: results
        };

    }

    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([
            {
                label: 'Your Car',
                navigationId: steps.startStep.navigationId
            },
            {
                label: 'Roadside Quotes',
                navigationId: steps.results.navigationId
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
            productName: product.provider,
            productBrandCode: product.brandCode
        }, {type: "A", productId: product.productId});
    }

    // Build an object to be sent by tracking.
    function getTrackingFieldsObject(special_case) {
        try {

            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furthest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

            var state = $("#roadside_riskAddress_state").val(),
                yearOfManufacture = $('#roadside_vehicle_year').val(),
                makeOfCar = $('#roadside_vehicle_makeDes').val(),
                actionStep = '';

            switch (current_step) {
                case 0:
                    actionStep = "roadside your car";
                    break;
                case 1:
                    if (special_case === true) {
                        actionStep = 'roadside more info';
                    } else {
                        actionStep = 'roadside results';
                    }
                    break;
            }

            var response = {
                actionStep: actionStep,
                quoteReferenceNumber: meerkat.modules.transactionId.get(),
                email: null,
                emailID: null,
                yearOfManufacture: null,
                makeOfCar: null,
                state: null,
                marketOptIn: null,
                okToCall: null
            };

            // Push in values from 2nd slide only when have been beyond it
            if (furthest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
                _.extend(response, {
                    yearOfManufacture: yearOfManufacture,
                    makeOfCar: makeOfCar,
                    state: state,
                    marketOptIn: null,
                    okToCall: null
                });
            }

            return response;

        } catch (e) {
            return {};
        }
    }

    meerkat.modules.register("roadside", {
        init: initRoadside,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject,
        trackHandover: trackHandover
    });


})(jQuery);
