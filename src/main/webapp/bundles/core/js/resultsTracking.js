/**
 * Brief explanation of the module and what it achieves. <example: Example pattern code for a meerkat module.>
 * Link to any applicable confluence docs: <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			resultsTracking: {
				TRACK_QUOTE_RESULTS_LIST: 'TRACK_QUOTE_RESULTS_LIST'
			}
		},
		moduleEvents = events.resultsTracking;

	/**
	 * @var resultsEventMode
	 * Load: New TranId ONLY
	 * Refresh: e.g. Sorting, cover level tabs, etc
	 */

	var resultsEventMode = 'Load';


	/* main entrypoint for the module to run first */
	function initResultsTracking() {
		if(meerkat.site.vertical === 'generic' || meerkat.site.vertical === "") {
			return;
		}
		meerkat.messaging.subscribe(moduleEvents.TRACK_QUOTE_RESULTS_LIST, trackQuoteResultsList);
	}

	/**
	 * Set the event mode e.g. Load, Compare, Refresh
	 */
	function setResultsEventMode(mode) {
		resultsEventMode = mode;
	}

	/**
	 * Retrieve the current event mode.
	 */
	function getResultsEventMode() {
		return resultsEventMode;
	}

	/** Fetch the display mode
	 *  Modes: compare, price, feature
	 */
	function getTrackingDisplayMode() {
		var display;
		if(meerkat.modules.compare.isCompareOpen() === true) {
			display = 'compare';
		} else {
			display = Results.getDisplayMode();
			// drop the trailing S off of features
			display = display.indexOf("f") === 0 ? display.slice(0, -1) : display;
		}

		return display;
	}

	/**
	 * This call is a merging of the previous trackQuoteList and trackQuoteProductList calls.
	 * It has been centralised, as previously all other verticals ran it independently.
	 * It accepts an eventObject in the format:
	 * {additionalData: {"Foo":"Bar"}, onAfterEventMode: "Refresh|Load"}
	 */
	function trackQuoteResultsList(eventObject) {
		log("[trackQuoteResultsList]", eventObject);

		eventObject = eventObject || {};

		var trackingVertical =  meerkat.modules.tracking.getTrackingVertical();

		/**
		 * This is the core "all verticals" data that is sent to tracking.
		 * The following data is added automatically by the tracking module during the call in updateObjectData:
		 *		brandCode, transactionID, rootID, currentJourney, vertical, verticalFilter
		 */
		var data = {
				actionStep: trackingVertical + ' results',
				display: getTrackingDisplayMode(),
				event: resultsEventMode,
				products: meerkat.modules.resultsRankings.getTrackingProductObject(),
				// this check is used below because coverLevelTabs module is currently not in the core folder.
				rankingFilter: (typeof meerkat.modules.coverLevelTabs !== 'undefined' ? meerkat.modules.coverLevelTabs.getRankingFilter() : 'default'),
				// this is overridden by caller functions to "N" if we do not need to record/update omniture ranking for this tracking call.
				recordRanking: 'Y',
				// couponId passed from email campaign, brochureware, vdn, online offers
				offeredCouponID: meerkat.modules.coupon.getCurrentCoupon() ? meerkat.modules.coupon.getCurrentCoupon().couponId : null
		};

		// extend the data
		if(typeof eventObject.additionalData === 'object') {
			data = $.extend({}, data, eventObject.additionalData);
		}

		// fire the tracking call
		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteResultsList',
			object:	data
		});

		// perform any post work
		if(typeof eventObject.onAfterEventMode === 'string') {
			setResultsEventMode(eventObject.onAfterEventMode);
		}

	}

	meerkat.modules.register('resultsTracking', {
		init: initResultsTracking,
		events: events,
		setResultsEventMode: setResultsEventMode,
		getResultsEventMode: getResultsEventMode,
		trackQuoteResultsList: trackQuoteResultsList
	});

})(jQuery);