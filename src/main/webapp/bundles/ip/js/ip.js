;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            life: {

            },
            WEBAPP_LOCK: 'WEBAPP_LOCK',
            WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
        },
        steps = null;

    function initIP() {
        $(document).ready(function() {
            // Only init if life
            if (meerkat.site.vertical !== "ip")
                return false;

            // Init common stuff
            initJourneyEngine();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
        });
    }

    function initJourneyEngine() {
        // Initialise the journey engine steps and bar
        initProgressBar(true);

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

    function initProgressBar(render){

        setJourneyEngineSteps();

        if(render){
            meerkat.modules.journeyProgressBar.render(true);
        }
    }

    function setJourneyEngineSteps(){

        var startStep = {
            title: 'Income Protection Details',
            navigationId: 'start',
            slideIndex:0,
            externalTracking:{
                method:'trackQuoteForms',
                object:meerkat.modules.ip.getTrackingFieldsObject
            },
            onInitialise: function onStartInit(event){

            }
        };

        var aboutYouStep = {
            title: 'About You',
            navigationId: 'about',
            slideIndex:1,
            externalTracking:{
                method:'trackQuoteForms',
                object:meerkat.modules.ip.getTrackingFieldsObject
            },
            onInitialise:function onDetailsInit(event){


            }
        };
        var contactStep = {
            title: 'Contact Details',
            navigationId: 'contact',
            slideIndex: 2,
            onInitialise: function onContactInit(event){

            }
        };

        var resultsStep = {
            title: 'Your Results',
            navigationId: 'results',
            slideIndex: 3,
            onInitialise: function onInitResults(event){

            }
        };

        var confirmationStep = {
            title: 'Confirmation',
            navigationId: 'apply',
            slideIndex: 4,
            onInitialise: function onInitApplyStep(event) {

            }
        };

        steps = {
            startStep: startStep,
            aboutYouStep: aboutYouStep,
            contactStep: contactStep,
            resultsStep: resultsStep,
            confirmationStep: confirmationStep
        };
    }

    // Build an object to be sent by SuperTag tracking.
    function getTrackingFieldsObject(){
        return {};
    }

    meerkat.modules.register("ip", {
        init: initIP,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject
    });

})(jQuery);