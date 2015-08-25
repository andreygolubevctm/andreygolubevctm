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
            onInitialise: function onStartInit(event) {
                console.log("Initialising Validator Core");
                meerkat.modules.jqueryValidate.initJourneyValidator();
            }
        };

        var resultsStep = {
            title: 'Choose a plan',
            navigationId: 'results',
            slideIndex: 1,
            onInitialise: function onResultsInit(event) {
            },
            onBeforeEnter: function enterResultsStep(event) {
            },
            onAfterEnter: function afterEnterResults(event) {
            },
            onAfterLeave: function(event) {
            }
        };

        var enquiryStep = {
            title: 'Fill out your details',
            navigationId: 'enquiry',
            slideIndex: 2,
            onInitialise: function () {
            },
            onBeforeEnter: function () {
            },
            onAfterEnter: function() {
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


    meerkat.modules.register("validationTest", {
        init: initUtilities,
        events: moduleEvents,
        initProgressBar: initProgressBar
    });


})(jQuery);