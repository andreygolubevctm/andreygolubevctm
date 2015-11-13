/**
 * Description: External documentation:
 */


(function($, undefined) {

    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;

    var moduleEvents = {
        fuel: {

        },
        WEBAPP_LOCK : 'WEBAPP_LOCK',
        WEBAPP_UNLOCK : 'WEBAPP_UNLOCK'
    }, steps = null;

    var skipToResults = false;

    function initFuel() {
        $(document).ready(function() {
            // Only init if fuel
            if (meerkat.site.vertical !== "fuel")
                return false;

            meerkat.modules.fuelPrefill.setHashArray();

            // Init common stuff
            initJourneyEngine();
            eventDelegates();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
        });
    }

    function eventDelegates() { }


    function initJourneyEngine() {
        // Initialise the journey engine steps and bar
        initProgressBar(false);

        // Initialise the journey engine
        var startStepId = null;
        if (meerkat.site.isFromBrochureSite === true && meerkat.modules.address.getWindowHashAsArray().length === 1) {
            startStepId = steps.startStep.navigationId;
            skipToResults = true;
        }
        // Use the stage user was on when saving their quote
        else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'latest') {
            startStepId = steps.resultsStep.navigationId;
        } else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'amend') {
            startStepId = steps.startStep.navigationId;
        }

        $(document).ready(function(){
            meerkat.modules.journeyEngine.configure({
                startStepId : startStepId,
                steps : _.toArray(steps)
            });

            // Call initial supertag call
            var transaction_id = meerkat.modules.transactionId.get();

            if(meerkat.site.isNewQuote === false){
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method:'trackQuoteEvent',
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
            title : 'Fuel Details',
            navigationId : 'start',
            slideIndex : 0,
            validation: {
                validate: true
            },
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.fuel.getTrackingFieldsObject
            },
            onInitialise: function(){
                meerkat.modules.jqueryValidate.initJourneyValidator();
                meerkat.modules.fuelPrefill.initFuelPrefill();
            },
            onAfterEnter: function() {
                if (skipToResults) {
                    meerkat.modules.journeyEngine.gotoPath("next");
                    skipToResults = false;
                }
            }
        };

        var resultsStep = {
            title : 'Fuel Prices',
            navigationId : 'results',
            slideIndex : 1,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.fuel.getTrackingFieldsObject
            },
            additionalHashInfo: function() {
                var fuelTypes = $("#fuel_hidden").val(),
                    location = $("#fuel_location").val().replace(/\s/g, "+");

                return location + "/" + fuelTypes;
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.fuelResults.initPage();
                meerkat.modules.showMoreQuotesPrompt.initPromptBar();
                meerkat.modules.fuelSorting.initSorting();
                meerkat.modules.fuelResultsMap.initFuelResultsMap();
                meerkat.modules.fuelCharts.initFuelCharts();
            },
            onAfterEnter: function afterEnterResults(event) {
                meerkat.modules.fuelResults.get();
                meerkat.modules.fuelResultsMap.resetMap();
            },
            onAfterLeave: function(event) {
                if(event.isBackward) {
                    meerkat.modules.showMoreQuotesPrompt.disablePromptBar();
                }
            }
        };

        /**
         * Add more steps as separate variables here
         */
        steps = {
            startStep: startStep,
            resultsStep: resultsStep
        };
    }

    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([
            {
                label: 'Fuel Details',
                navigationId: steps.startStep.navigationId
            }, {
                label: 'Fuel Prices',
                navigationId: steps.resultsStep.navigationId
            }
        ]);
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
                    state: location[location.length-1],
                    postcode: location[location.length-2]
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
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject
    });
})(jQuery);