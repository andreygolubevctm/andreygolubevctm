;(function($, undefined){

	/**
	 * sessionsCamCommonListeners: provides a common module where vertical agnostic events
	 * can be subscribed to and actioned in one place rather than arbitrarily spread throughout
	 * the code-base;
	 **/

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {},
	moduleEvents = events;

	// We want to ignore the results page triggered by the journey engine and only use the
	// loading and results shown triggers
	var skipStepForSessionCam = ["results"];

	// Display-mode is set when results first initialised (before results shown) - we want to
	// ignore this first call and only listen when mode is actually changed
	var ignoreSetResultsDisplayMode = true;

	var stepCopy = {
			RESULTS_LOADING : "resultsLoading",
			RESULTS_PAGE : "resultsPage",
			MOREINFO_PAGE : "MoreInfo"
	};

	function init(){
		// Triggers results loading virtual page
		msg.subscribe(ResultsModel.moduleEvents.WEBAPP_LOCK, setResultsLoadingPage);
		// Triggers new page after results sorted and rendered
		msg.subscribe(meerkat.modules.events.RESULTS_RANKING_READY, _.bind(setResultsShownPage, this, 2000));
		// Triggers new page when results display mode is changed
		msg.subscribe(ResultsView.moduleEvents.RESULTS_TOGGLE_MODE, onResultsDisplayTypeSet);
		/* Set the initial virtual page based on the navigationId rather than simply defaulting
		 * to the page name - accounts for quotes being retrieved and testing with preload */
		msg.subscribe(meerkat.modules.events.journeyEngine.READY, setInitialPage);
	}

	function addStepToIgnoreList(navigationId) {
		if(_.indexOf(skipStepForSessionCam, navigationId) === -1) {
			skipStepForSessionCam.push(navigationId);
		}
	}

	function updateVirtualPageFromJourneyEngine(step, delay) {
		if(!_.isArray(skipStepForSessionCam) || _.indexOf(skipStepForSessionCam, step.navigationId) === -1) {
			updateVirtualPage(step, delay);
		}
	}

	function updateVirtualPage(step, delay) {
		delay = delay || 1000;
		if (window.sessionCamRecorder) {
			if (window.sessionCamRecorder.createVirtualPageLoad) {
				setTimeout(function() {
					log("[sessionCamHelper:createVirtualPageLoad]", step);
					window.sessionCamRecorder.createVirtualPageLoad(location.pathname + "/" + step.navigationId);
				}, delay);
			}
		}
	}

	function setInitialPage() {
		setTimeout(function() {
			updateVirtualPageFromJourneyEngine(meerkat.modules.journeyEngine.getCurrentStep());
		}, 2000); // Use delay to allow time for sessioncam to load
	}

	function setResultsLoadingPage(data, delay) {
		data = data || false;
		delay = delay || false;
		if(data !== false && _.has(data,"source") && data.source === "resultsModel") {
			updateVirtualPage({navigationId:stepCopy.RESULTS_LOADING}, delay);
		}
	}

	function setResultsShownPage(delay) {
		delay = delay || false;
		updateVirtualPage(getResultsStep(), delay);
	}

	function onResultsDisplayTypeSet() {
		if(ignoreSetResultsDisplayMode === false) {
			setResultsShownPage();
		}
		ignoreSetResultsDisplayMode = true;
	}

	function setMoreInfoModal(delay) {
		delay = delay || false;
		updateVirtualPage(getMoreInfoStep(), delay);
	}

	function getResultsStep() {
		return {navigationId:stepCopy.RESULTS_PAGE + "-" + Results.getDisplayMode()};
	}

	function getMoreInfoStep(suffix) {
		suffix = suffix || false;
		return appendToStep({navigationId:stepCopy.MOREINFO_PAGE}, suffix);
	}

	function appendToStep(step, suffix) {
		suffix = suffix || false;
		if(suffix !== false && !_.isEmpty(suffix)) {
			step.navigationId += "-" + suffix;
		}
		return step;
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
		getMoreInfoStep: getMoreInfoStep
	});

})(jQuery);