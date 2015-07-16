/**
 * Description: External documentation:
 */
(function($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
        lmi: {

        },
        WEBAPP_LOCK : 'WEBAPP_LOCK',
        WEBAPP_UNLOCK : 'WEBAPP_UNLOCK'
    }, steps = null;

    function initLmi() {
        $(document).ready(function() {
            // Only init if carlmi or homelmi
            if (meerkat.site.vertical !== "carlmi" && meerkat.site.vertical !== "homelmi") {
                return false;
            }

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
            title : 'Select Brands',
            navigationId : 'start',
            slideIndex : 0,
            onInitialise: function() {
                if(meerkat.site.brands.length) {
                    var brands = meerkat.site.brands.split(',');
                    for(var i =0;i< brands.length;i++) {
                        $('input[id=product'+brands[i]+'_check]').prop('checked', true);
                    }
                }
            },
            validation:{
                validate:true,
                customValidation:function(callback){
                    var count = 0;
                    $('input[name='+meerkat.site.vertical+'_brand]').each(function(){
                        if($(this).prop('checked')) {
                            count++;
                        }
                    });
                    callback(count > 0);
                }
            }
        };

        var resultsStep = {
            title : 'Compare Features',
            navigationId : 'results',
            slideIndex : 1,
            onInitialise: function onResultsInit(event) {
                meerkat.modules.lmiResults.initPage();
                var options = {
                    anchorPosition: '#results_v3 > div.featuresHeaders > div.featuresList',
                    extraDockedItem: 'div.comparisonFeaturesDisclosure',
                    stationaryDockingOffset: 40
                };
                meerkat.modules.showMoreQuotesPrompt.initPromptBar(options);
            },
            onBeforeEnter: function enterResultsStep(event) {
                // shouldn't do much of this when returning from enquire
                if (event.isForward === true) {
                    // Always force it to be a "Load" in utilities, as currently, we always get a new tranid.
                    meerkat.modules.resultsTracking.setResultsEventMode('Load');
                    $('#resultsPage').addClass('hidden');
                }
            },
            onAfterEnter: function afterEnterResults(event) {
                if (event.isForward === true) {
                    meerkat.modules.lmiResults.get();
                }
            }, onAfterLeave: function(event) {
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
                label: 'Select Brands',
                navigationId: steps.startStep.navigationId
            }, {
                label: 'Compare Features',
                navigationId: steps.resultsStep.navigationId
            }
        ]);
    }

    meerkat.modules.register("lmi", {
        init: initLmi,
        events: moduleEvents,
        initProgressBar: initProgressBar
    });

})(jQuery);