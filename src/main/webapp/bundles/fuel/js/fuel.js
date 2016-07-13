(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var moduleEvents = {
        fuel: {}
    }, steps = null;

    function initFuel() {
        $(document).ready(function () {
            // Only init if fuel
            if (meerkat.site.vertical !== "fuel")
                return false;

            //meerkat.modules.fuelPrefill.setHashArray();

            // Init common stuff
            initJourneyEngine();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
        });
    }

    function applyEventListeners() {
        $(document).on('change', '#fuel_type_id', function () {
            meerkat.modules.fuelResults.get();
        });
    }

    function initJourneyEngine() {
        setJourneyEngineSteps();

        // Initialise the journey engine
        var startStepId = null;
        if (meerkat.site.isFromBrochureSite === true && meerkat.modules.address.getWindowHashAsArray().length === 1) {
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

            // Call initial supertag call
            var transaction_id = meerkat.modules.transactionId.get();

            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackQuoteEvent',
                object: {
                    action: 'Start',
                    transactionID: parseInt(transaction_id, 10),
                    vertical: meerkat.site.vertical
                }
            });
        });
    }

    function setJourneyEngineSteps() {
        var startStep = {
            title: 'Fuel Details',
            navigationId: 'start',
            slideIndex: 0,
            validation: {
                validate: true
            },
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.fuel.getTrackingFieldsObject
            },
            onInitialise: function () {
                meerkat.modules.jqueryValidate.initJourneyValidator();
                meerkat.modules.fuelMap.initGoogleAPI();
                //meerkat.modules.fuelPrefill.initFuelPrefill();
            },
            onAfterEnter: function () {
            }
        };

        /**
         * Add more steps as separate variables here
         */
        steps = {
            startStep: startStep
            //,resultsStep: resultsStep
        };
    }

    // Build an object to be sent by tracking.
    function getTrackingFieldsObject(special_case) {
        try {

            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furthest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

            var location = $("#fuel_location").val().split(' '),
                actionStep = '';

            switch (current_step) {
                case 0:
                    actionStep = "fuel details";
                    break;
                case 1:
                    if (special_case === true) {
                        actionStep = 'fuel more info';
                    } else {
                        actionStep = 'fuel results';
                    }
                    break;
            }

            var response = {
                actionStep: actionStep,
                quoteReferenceNumber: meerkat.modules.transactionId.get()
            };

            // Push in values from 2nd slide only when have been beyond it
            if (furthest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
                _.extend(response, {
                    state: location[location.length - 1],
                    postcode: location[location.length - 2]
                });
            }

            return response;

        } catch (e) {
            return {};
        }
    }

    meerkat.modules.register("fuel", {
        init: initFuel,
        events: moduleEvents,
        getTrackingFieldsObject: getTrackingFieldsObject
    });
})(jQuery);