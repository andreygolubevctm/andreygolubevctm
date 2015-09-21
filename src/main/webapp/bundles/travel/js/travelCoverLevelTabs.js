/**
 * Description:
 * External documentation:
 */
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			travelCoverLevelTabs: {

			}
		},
		moduleEvents = events.travelCoverLevelTabs;

	var singleTripTabs = [{
		label : "Comprehensive <span class='hidden-xs'>Cover</span>",
		rankingFilter : "C",
		defaultTab : true,
		disableAnimationsBetweenTabs : true,
		showCount : true,
		filter : function() {
			Results.filterBy("coverLevel", "value", {
				"equals" : "C"
			}, true);
		}
	}, {
		label : "Mid Range <span class='hidden-xs'>Cover</span>",
		rankingFilter : "M",
		defaultTab : false,
		showCount : true,
		filter : function() {
			Results.filterBy("coverLevel", "value", {
				"equals" : "M"
			}, true);

		}
	}, {
		label : "Basic <span class='hidden-xs'>Cover</span>",
		rankingFilter : "B",
		showCount : true,
		defaultTab : false,
		filter : function() {
			Results.filterBy("coverLevel", "value", {
					"equals": "B"
				}, true);
			}
		}],
		annualMultiTripTabs = [{
			label: "International <span class='hidden-xs'>Cover</span>",
			rankingFilter: "I",
			defaultTab: true,
			showCount: true,
			filter: function() {
				Results.filterBy("coverLevel", "value", {
					"equals": "I"
				}, true);
			}
		},
		{
			label: "Domestic <span class='hidden-xs'>Cover</span>",
			rankingFilter: "D",
			defaultTab: false,
			showCount: true,
			filter: function() {
				Results.filterBy("coverLevel", "value", {
					"equals": "D"
				}, true);
			}
		}],
		$policyType;


	function initTravelCoverLevelTabs() {

		// Remove this after A/B test
		if(!meerkat.modules.splitTest.isActive([2,3,4,83])) {
			return;
		}

		setupABTestParameters();
		// end AB test code

		var options = {
			enabled: true,
			tabCount : 3,
			activeTabSet : getActiveTabSet(),
			hasMultipleTabTypes: true,
			verticalMapping : tabMapping()
		};
		meerkat.modules.coverLevelTabs.initCoverLevelTabs(options);
		
		$(document).ready(function () {
			meerkat.messaging.subscribe(meerkatEvents.coverLevelTabs.CHANGE_COVER_TAB, function onTabChange(eventObject) {
				if (eventObject.activeTab == "D") {
					meerkat.modules.showMoreQuotesPrompt.disableForCoverLevelTabs();
				} else {
					meerkat.modules.showMoreQuotesPrompt.resetForCoverLevelTabs();
				}
			});
		});
	}

	/* This maps the shortcuts (eg C, M, B etc... ) to an actual tab */
	function tabMapping() {
		return {
			DEFAULT: 'DEFAULT',
			C: 'Comprehensive',
			M: 'Mid Range',
			B: 'Basic',
			I: 'International',
			D: 'Domestic'
		}
	}

	/**
	 * Remove parameter after A/B test
	 * Temporary function to set the default tabs for A/B testing.
	 * J2 [0]: Comprehensive
	 * J3 [1]: Mid Range
	 * J4 [2]: Basic
	 */
	function setupABTestParameters() {

		singleTripTabs[0].defaultTab = false;
		singleTripTabs[1].defaultTab = false;
		singleTripTabs[2].defaultTab = false;

		if(meerkat.modules.splitTest.isActive(2)) {
			singleTripTabs[0].defaultTab = true;
		} else if(meerkat.modules.splitTest.isActive([3,83])) {
			singleTripTabs[1].defaultTab = true;
		} else if(meerkat.modules.splitTest.isActive(4)) {
			singleTripTabs[2].defaultTab = true;
		}
	}
	/**
	 * Retrieve the tab object to use based on specific criteria
	 */
	function getActiveTabSet() {
		switch ($('input[name=travel_policyType]:checked').val()) {
		case 'A':
			return annualMultiTripTabs;
		case 'S':
			return singleTripTabs;
		}
	}

	/**
	 * Reset the active tab setting onto the cover level tab object So it
	 * doesn't have to be re-initialised on each beforeEnter. As results can
	 * change, it needs to be updated.
	 */
	function updateSettings() {
		if(meerkat.modules.coverLevelTabs.isEnabled()) {
			meerkat.modules.coverLevelTabs.resetView(getActiveTabSet());
		}
	}

	meerkat.modules.register("travelCoverLevelTabs", {
		initTravelCoverLevelTabs : initTravelCoverLevelTabs,
		events : events,
		updateSettings : updateSettings
	});

})(jQuery);