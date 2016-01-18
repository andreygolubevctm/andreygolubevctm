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
		defaultTab : false,
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
		defaultTab : true,
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
		$policyType,
		initialised = false;


	function initTravelCoverLevelTabs() {
		if(!initialised) {
			initialised = true;

			var options = {
				enabled: true,
				tabCount: 3,
				activeTabSet: getActiveTabSet(),
				hasMultipleTabTypes: true,
				verticalMapping: tabMapping()
			};
			meerkat.modules.coverLevelTabs.initCoverLevelTabs(options);

			meerkat.messaging.subscribe(meerkatEvents.coverLevelTabs.CHANGE_COVER_TAB, function onTabChange(eventObject) {
				if (eventObject.activeTab == "D") {
					meerkat.modules.showMoreQuotesPrompt.disableForCoverLevelTabs();
				} else {
					meerkat.modules.showMoreQuotesPrompt.resetForCoverLevelTabs();
				}
			});
		}
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
		};
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