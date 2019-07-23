;(function ($, undefined) {

    /**
     * sessionsCamCommonListeners: provides a common module where vertical agnostic events
     * can be subscribed to and actioned in one place rather than arbitrarily spread throughout
     * the code-base;
     **/

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        exception = meetkat.logging.exception,
        msg = meerkat.messaging;

    var events = {};

    // We want to ignore the results page triggered by the journey engine and only use the
    // loading and results shown triggers
    var skipStepForSessionCam = ["results"];

    var activeNavigationId = false;

    // Display-mode is set when results first initialised (before results shown) - we want to
    // ignore this first call and only listen when mode is actually changed
    var ignoreSetResultsDisplayMode = true;

    var stepCopy = {
        RESULTS_LOADING: "resultsLoading",
        RESULTS_PAGE: "resultsPage",
        MOREINFO_PAGE: "MoreInfo"
    };

    function init() {
        // Triggers results loading virtual page
        if(typeof ResultsModel != 'undefined') {
            msg.subscribe(ResultsModel.moduleEvents.WEBAPP_LOCK, setResultsLoadingPage);
        }
        // Triggers new page after results sorted and rendered
        msg.subscribe(meerkat.modules.events.RESULTS_RANKING_READY, _.bind(setResultsShownPage, this, 2000));
        // Triggers new page when results display mode is changed
        if(typeof ResultsView != 'undefined') {
            msg.subscribe(ResultsView.moduleEvents.RESULTS_TOGGLE_MODE, onResultsDisplayTypeSet);
        }
        /* Set the initial virtual page based on the navigationId rather than simply defaulting
         * to the page name - accounts for quotes being retrieved and testing with preload */
        msg.subscribe(meerkat.modules.events.journeyEngine.READY, setInitialPage);
    }

    function addStepToIgnoreList(navigationId) {
        if (_.indexOf(skipStepForSessionCam, navigationId) === -1) {
            skipStepForSessionCam.push(navigationId);
        }
    }

    function updateVirtualPageFromJourneyEngine(step, delay) {
        if (!_.isArray(skipStepForSessionCam) || (_.isObject(step) && _.indexOf(skipStepForSessionCam, step.navigationId) === -1)) {
            updateVirtualPage(step, delay);
        }
    }

    function updateVirtualPage(step, delay) {
        delay = delay || 1000;
        if (_.isObject(step) && step.hasOwnProperty('navigationId') && step.navigationId !== activeNavigationId) {
            activeNavigationId = step.navigationId;
            if (window.sessionCamRecorder) {
                if (window.sessionCamRecorder.createVirtualPageLoad) {
                    setTimeout(function () {
                        log("[sessionCamHelper:createVirtualPageLoad]", step);
                        window.sessionCamRecorder.createVirtualPageLoad(location.pathname + "/" + activeNavigationId);
                    }, delay);
                }
            }
        }
    }

    function setInitialPage() {
        meerkat.modules.utils.pluginReady('sessionCamRecorder').then(function () {
            updateVirtualPageFromJourneyEngine(meerkat.modules.journeyEngine.getCurrentStep());
            // If a guid is returned then a cookie 'sc.UserId' is created
            // with that value set for 8760 hours (1 year) and the same value
            // will be returned in the future from the same browser for any site
            // if the cookie is not cleared.
            if (window.sessionCamRecorder && _.isFunction(window.sessionCamRecorder.getSessionCamUserId)) {
                window.sessionCamRecorder.getSessionCamUserId();
            }
        })
        .catch(function onError(obj, txt, errorThrown) {
			exception(txt + ': ' + errorThrown);
		})
    }

    function setResultsLoadingPage(data, delay) {
        data = data || false;
        delay = delay || false;
        if (data !== false && _.has(data, "source") && data.source === "resultsModel") {
            updateVirtualPage({navigationId: stepCopy.RESULTS_LOADING}, delay);
        }
    }

    function setResultsShownPage(delay) {
        delay = delay || false;
        updateVirtualPage(getResultsStep(), delay);
    }

    function onResultsDisplayTypeSet() {
        if (ignoreSetResultsDisplayMode === false) {
            setResultsShownPage();
        }
        ignoreSetResultsDisplayMode = false;
    }

    function setMoreInfoModal(delay) {
        delay = delay || false;
        updateVirtualPage(getMoreInfoStep(), delay);
    }

    function getResultsStep() {
        return {navigationId: stepCopy.RESULTS_PAGE + "-" + Results.getDisplayMode()};
    }

    function getMoreInfoStep(suffix) {
        suffix = suffix || false;
        return appendToStep({navigationId: stepCopy.MOREINFO_PAGE}, suffix);
    }

    function appendToStep(step, suffix) {
        suffix = suffix || false;
        if (suffix !== false && !_.isEmpty(suffix)) {
            step.navigationId += "-" + suffix;
        }
        return step;
    }

    /**
     * @jira HLT-2820
     * Completely stops the recording.
     * NOTE: this may not be a long term supported function from sessioncam.
     * They don't have the ability to pause and resume. Health results is too heavy, even on Chrome Desktop
     */
    function stopSessionCam() {
        if (window.sessionCamRecorder && _.isFunction(window.sessionCamRecorder.endSession)) {
            window.sessionCamRecorder.endSession();
        }
    }

    meerkat.modules.register("sessionCamHelper", {
        init: init,
        events: events,
        updateVirtualPage: updateVirtualPage,
        updateVirtualPageFromJourneyEngine: updateVirtualPageFromJourneyEngine,
        addStepToIgnoreList: addStepToIgnoreList,
        setResultsLoadingPage: setResultsLoadingPage,
        setResultsShownPage: setResultsShownPage,
        setMoreInfoModal: setMoreInfoModal,
        getMoreInfoStep: getMoreInfoStep,
        stop: stopSessionCam
    });

})(jQuery);