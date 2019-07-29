;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
        retrievequotesComponent: {},
        WEBAPP_LOCK: 'WEBAPP_LOCK',
        WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
    };

    function initJourneyEngine() {


        // Initialise the journey engine steps and bar
        initProgressBar(false);

        // Initialise the journey engine
        var startStepId = null;

        $(document).ready(function () {

            meerkat.modules.journeyEngine.configure({
                startStepId: startStepId,
                steps: _.toArray(steps)
            });
        });
    }

    /**
     * Initialise and configure the progress bar.
     *
     * @param {bool} render
     */
    function initProgressBar(render) {
        setJourneyEngineSteps();
        //configureProgressBar();
    }

    function setJourneyEngineSteps() {

        var startStep = {
            title: 'Login',
            navigationId: 'login',
            slideIndex: 0,
            onInitialise: function onInitialise() {
                meerkat.modules.jqueryValidate.initJourneyValidator();
            },
            onAfterEnter: function onStartAfterEnter() {
                if(meerkat.site.loggedIn)
                    meerkat.modules.journeyEngine.gotoPath("next");
            },
            validation: {
                validate: true,
                customValidation: function (callback) {
                    if(meerkat.site.loggedIn) {
                        callback(true);
                        return;
                    }
                    meerkat.modules.retrievequotesLogin.doLoginAndRetrieve().then(function (data, textStatus, jqXHR) {
                        if (typeof data !== 'undefined' && data !== null && data.previousQuotes) {
                            meerkat.site.responseJson = data;
                            callback(true);
                        } else {
                            try {
                                callback(false);
                            } catch (e) {
                            }
                            meerkat.modules.retrievequotesLogin.handleLoginFailure(jqXHR, textStatus, "");
                        }
                    }).catch(function (jqXHR, textStatus, errorThrown) {
                        try {
                            callback(false);
                        } catch (e) {
                        }
                        meerkat.modules.retrievequotesLogin.handleLoginFailure(jqXHR, textStatus, errorThrown);
                        return;
                    }).always(function() {
                        meerkat.modules.loadingAnimation.hide($(".btn-login"));
                    });
                }
            }
        };

        var resultsStep = {
            title: 'Your Quotes',
            navigationId: 'quotes',
            slideIndex: 1,
            onBeforeEnter: function () {
                meerkat.modules.retrievequotesListQuotes.renderQuotes();
            },
            onAfterEnter: function() {
                if($.trim($("#quote-result-list").html()) === "") {
                    meerkat.modules.retrievequotesListQuotes.noResults();
                }
            }
        };

        steps = {
            startStep: startStep,
            resultsStep: resultsStep
        };

    }

    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([]);
    }

    meerkat.modules.register("retrievequotesComponent", {
        init: initJourneyEngine,
        events: moduleEvents
    });

})(jQuery);