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
			Results.filterByExcess("coverLevel", "value", {
				"equals" : "C"
			}, true);
		}
	}, {
		label : "Mid Range <span class='hidden-xs'>Cover</span>",
		rankingFilter : "M",
		defaultTab : false,
		showCount : true,
		filter : function() {
			Results.filterByExcess("coverLevel", "value", {
				"equals" : "M"
			}, true);

		}
	}, {
		label : "Basic <span class='hidden-xs'>Cover</span>",
		rankingFilter : "B",
		showCount : true,
		defaultTab : false,
		filter : function() {
			Results.filterByExcess("coverLevel", "value", {
					"equals": "B"
				}, true);
			}
		}],
		intAnnualMultiTripTabs = [{
            label : "Comprehensive <span class='hidden-xs'>Cover</span>",
            rankingFilter : "CI",
            defaultTab : true,
            disableAnimationsBetweenTabs : true,
            showCount : true,
            filter : function() {
                Results.filterByExcess("coverLevel", "value", {
                    "equals" : "CI"
                }, true);
            }
        }, {
            label : "Mid Range <span class='hidden-xs'>Cover</span>",
            rankingFilter : "MI",
            defaultTab : false,
            showCount : true,
            filter : function() {
                Results.filterByExcess("coverLevel", "value", {
                    "equals" : "MI"
                }, true);

            }
        }, {
            label : "Basic <span class='hidden-xs'>Cover</span>",
            rankingFilter : "BI",
            showCount : true,
            defaultTab : false,
            filter : function() {
                Results.filterByExcess("coverLevel", "value", {
                    "equals": "BI"
                }, true);
            }
        }],
		domesticANNUALmultiTripTabs = [{
            label: "Domestic <span class='hidden-xs'>Cover</span>",
            rankingFilter: "D",
            defaultTab: true,
            showCount: true,
            filter: function() {
                Results.filterByExcess("coverLevel", "value", {
                    "equals": "D"
                }, true);
            }
        }],
		$policyType,
		initialised = false;


	function initTravelCoverLevelTabs(isAmtDomestic, reInit) {
		if(!initialised || reInit) {
			initialised = true;

            var destination = $('#travel_destination').val();
			var options = {
				enabled: true,
				tabCount: 3,
				activeTabSet: getActiveTabSet(isAmtDomestic),
				hasMultipleTabTypes: true,
				verticalMapping: tabMapping(),
				callback: function () {
                    // hide filters for mobile, tablet & AMT
                    if (isAMT() || destination === 'AUS') {
                        $('.clt-trip-filter').hide();
                        $('.mobile-cover-type').show();
                    } else {
                        $('.clt-trip-filter').show();
                    }
                    // show amt filter if in AMT journey
                    $('.amt-filter').toggle(isAMT());
                }
			};
			meerkat.modules.coverLevelTabs.initCoverLevelTabs(options, reInit);

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
	 * Check if the journey is AMT or SingleTrip
     * @returns {Boolean}
     */
	function isAMT() {
        return $('input[name=travel_policyType]:checked').val() === 'A';
    }

	/**
	 * Retrieve the tab object to use based on specific criteria
	 */
	function getActiveTabSet(isAmtDomestic) {
	    if (isAMT()) {
	        return isAmtDomestic ? domesticANNUALmultiTripTabs : intAnnualMultiTripTabs;
        }

        return singleTripTabs;
	}

	function getCurrentCoverLevelTab() {
		return meerkat.modules.coverLevelTabs.getRankingFilter();
	}

	/** END HELPER METHODS **/

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
		updateSettings : updateSettings,
		setDefaultSingleCoverLevelTab : setDefaultSingleCoverLevelTab,
		setDefaultMultiCoverLevelTab : setDefaultMultiCoverLevelTab,
		getCurrentCoverLevelTab : getCurrentCoverLevelTab
	});

})(jQuery);