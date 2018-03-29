/**
* Description: Core cover level tabs function. Override the defaults in your own verticalCoverLevelTabs.js file.
* In order to implement it on your own vertical, you must:
* 1. Add the markup to vertical_quote.jsp (see travel_quote.jsp)
*	<div class="coverLevelTabs hidden-xs">
		<div class="currentTabsContainer"></div>
	</div>
* 2. Add the markup to results.tag for mobile version (see travel/results.tag):
*	<div class="container">
		<div class="row coverLevelTabs visible-xs">
			<div class="currentTabsContainer"></div>
		</div>
	</div>
* 3. Create verticalCoverLevelTabs.js (see travelCoverLevelTabs.js)
* 3.1 It should contain an init, getActiveTabSet (if you have conditions that split the tabs e.g. Single/Multi trip in travel)
* and updateSettings function and anything else you want.
* 3.2 Once you have the skeleton, just set up the tabs with the filter conditions you require
*		NOTE: Ideally, the additional parameters to filter on would be added server-side.
*		Travel manipulates the results object at present in travelResults.js
* 4. Initialise the verticalCoverLevelTabs in vertical.js and in results onInitialise
* 5. Run updateSettings in onBeforeEnter to reset the view etc (especially if counting products).
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			coverLevelTabs: {
				CHANGE_COVER_TAB: "CHANGE_COVER_TAB"
			}
		},
		moduleEvents = events.coverLevelTabs;

	var counts = {},
		currentRankingFilter = 'default',
		hasRunTrackingCall = [],
		recordFullTabJourney = false,
		originatingTab = 'default',
		departingTab = [],
		defaults = {
		enabled: true, // whether it should be enabled for this vertical.
		verticalMapping: {}, // each vertical's definition of a tab
		activeTabIndex: false, // nothing by default.
		disableAnimationsBetweenTabs: true,
		/**
		 * The array of tabs you want built
		 * NOTE: These options cannot individually be overloaded through $.extend, pass in your full object.
		 */
		activeTabSet: [{
			label: "Comprehensive",
			rankingFilter: "C",
			defaultTab: true, 
			showCount: true,
			/**
			 * The set of Results filters you want to add to the model based off your tab criteria.
			 * @param renderView
			 */
			filter: function(renderView) {

			}
		}]
	},
	settings = {},
	initialised = false,
	$tabsContainer = $('.coverLevelTabs'),
	$currentTabContainer = $('.currentTabsContainer');

	/**
	 * Needs to:
	 * 1. Initialise on resultsFetchFinish or resultsLoaded
	 */
	function initCoverLevelTabs(options) {
		if(!initialised) {
			initialised = true;

			settings = $.extend(true, {}, defaults, options);

			if (settings.enabled === false) {
				return;
			}

			applyEventListeners();
			eventSubscriptions();
		}
	}

	function _coverTypeEvent (element) {
        var $el = $(element),
            tabIndex = $el.attr('data-clt-index');
        log("[coverleveltabs] click", tabIndex);

        if(tabIndex === '' || settings.activeTabIndex === tabIndex) {
            return;
        }
        if(typeof settings.activeTabSet[tabIndex] === 'undefined') {
            return;
        }

        if(typeof settings.activeTabSet[tabIndex].filter === 'function') {

            var filterAnimate = Results.settings.animation.filter.active;

            if(settings.disableAnimationsBetweenTabs === true) {
                // Disable Animation
                Results.settings.animation.filter.active = false;
            }

            // populate navbar cover text
            $('.navbar-cover-text').html('Showing ' + counts[settings.activeTabSet[tabIndex].rankingFilter] + ' ' + settings.activeTabSet[tabIndex].label.toLowerCase().replace('cover', 'plans'));

            // trigger filter call
            settings.activeTabSet[tabIndex].filter();
            $el.siblings().removeClass('active').end().addClass('active');
            settings.activeTabIndex = tabIndex;
            setRankingFilter(settings.activeTabSet[tabIndex].rankingFilter);
            meerkat.messaging.publish(moduleEvents.CHANGE_COVER_TAB, {
                activeTab: getRankingFilter()
            });

            if(settings.disableAnimationsBetweenTabs === true) {
                // Re-Enable Animation, or set to whatever it was before.
                Results.settings.animation.filter.active = filterAnimate;
            }


            var additionalData = {
                    'recordRanking': 'Y'
                },
                hasTrackedThisTab = hasRunTrackingCall.indexOf(getRankingFilter()) !== -1;
            // todo: above will not work on IE8 unless we have that shim for indexOf on array.

            if(hasTrackedThisTab) {
                additionalData.recordRanking = 'N';
                additionalData.products = [];
            }

            // grab the tab they've clicked on
            // recordFullTabJourney gives us the option to record all the other tab clicks in between
            if (!recordFullTabJourney){
                departingTab = [];
            }

            departingTab.push(getRankingFilter());

            // reset it for the next "filter"
            meerkat.modules.resultsRankings.resetTrackingProductObject();
            // run the trackQuoteResultsList event again, with new products/rankingFilter
            meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
                additionalData: additionalData,
                onAfterEventMode: meerkat.modules.resultsTracking.getResultsEventMode()
            });
            if(meerkat.modules.resultsTracking.getResultsEventMode().toLowerCase() == "load") {
                meerkat.modules.resultsTracking.setResultsEventMode("Refresh");
            }

						var rankingData = meerkat.modules.resultsRankings.getWriteRankData(Results.settings.rankings, meerkat.modules.resultsRankings.fetchProductsToRank(true));
						meerkat.modules.resultsRankings.sendQuoteRanking("Cover Level Tabs", rankingData);

            // No need to append twice!
            if(!hasTrackedThisTab) {
                hasRunTrackingCall.push(getRankingFilter());
            }

            // scroll back to the top of the page
            meerkat.modules.utils.scrollPageTo("html body", 350, 0, function() {
                meerkat.modules.journeyEngine.sessionCamRecorder({"navigationId":"CoverLevel"+getRankingFilter()});
            });
        }
	}

	function applyEventListeners() {

		// Unnecessary if it doesn't exist in the page
		if(!$tabsContainer.length) {
			return;
		}

		$tabsContainer.off('click', '.clt-action').on('click', '.clt-action', function(e) {
			_coverTypeEvent(this);
		});

        $tabsContainer.off('change', 'input[name="cover-type-mobile-radio-group"]').on('change', 'input[name="cover-type-mobile-radio-group"]', function (e) {
            _coverTypeEvent(this);
            var $el = $(this),
                tabIndex = $el.attr('data-clt-index');

            if (tabIndex) {
                var coverLevelText = settings.activeTabSet[tabIndex].label.replace('<span class=\'hidden-xs\'>Cover</span>', '');
                $('.mobile-active-cover-type').empty().text(coverLevelText);
                $('#coverTypeDropdownBtn').dropdown('toggle');
            }
        });
	}

	function eventSubscriptions() {

		meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_BEFORE_DATA_READY, setup);
//		$(document).on("resultsFetchStart", function onResultsFetchStart() {
//			$tabsContainer.hide();
//		});
//		meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_DATA_READY, function showCoverLevelTabs() {
//			$tabsContainer.show();
//		});

		// listen to filters. i.e. if you filter a result set within a section e.g. car.
	}

	function setup() {
		log("[coverleveltabs] Setup");
		buildTabs();
		activateDefault();
	}

	/**
	 * The class is added in buildTabs, and clicked here, as
	 * activation should be separate to template rendering
	 */
	function activateDefault() {
		state = meerkat.modules.deviceMediaState.get();
		if(state === 'xs') {
			$('.visible-xs .cover-type-mobile.active').click();
			$('#coverTypeDropdownBtn').dropdown('toggle');
		} else {
			$('.hidden-xs .clt-action.active').click();
		}
	}

	function transformTabs(tabs) {
		var lastCoverTabLevel = $('#' + meerkat.site.vertical + '_lastCoverTabLevel').val();
		if (lastCoverTabLevel != null) {
			for (var i = 0; i < tabs.length; i++) {
				var rankingFilter = tabs[i].rankingFilter;
				tabs[i].defaultTab = rankingFilter === lastCoverTabLevel;
			}
		}
		return tabs;
	}

	/**
	 * Build the DOM structure for the current tabs.
	 */
	function buildTabs() {
		settings.activeTabSet = transformTabs(settings.activeTabSet);
		if(typeof settings.activeTabSet === 'undefined') {
			return;
		}
		log("[coverleveltabs] buildTabs", settings.activeTabSet);
        var destination = $('#travel_destination').val();
		var tabLength = settings.activeTabSet.length,
		xsCols = parseInt(6 / tabLength, 10),
		state = meerkat.modules.deviceMediaState.get();
		var out = '';
		var resetFilters = '';
		var mobileCoverTypes = '';
		for(out = '', i = 0; i < tabLength; i ++) {
			var tab = settings.activeTabSet[i],
				count = counts[tab.rankingFilter] || null;
			var coverTypeValue = tab.label.replace('<span class=\'hidden-xs\'>Cover</span>', '').toLowerCase().trim().replace(' ', '_');
			var coverTypeText = tab.label.replace('<span class=\'hidden-xs\'>Cover</span>', '');

			if (tab.defaultTab) {
                $('.mobile-active-cover-type').empty().text(coverTypeText);
			}

            // results headers
            out += '<div class="col-xs-4 col-sm-3 col-md-3 col-lg-' + xsCols + ' text-center clt-action ' + (tab.defaultTab === true ? 'active' : '') + '" data-clt-index="' + i + '" data-ranking-filter="' + tab.rankingFilter + '">';
            out += (tab.label.replace('Cover', '')) + (state !== 'xs' && tab.showCount === true && count !== null ? ' <span class="tabCount">(' + (count) + ')</span>' : '');
            out += '</div>';


			// mobile cover types
            mobileCoverTypes += '<div class="dropdown-item">';
            mobileCoverTypes += 	'<div class="radio">';
            mobileCoverTypes += 		'<input type="radio" name="cover-type-mobile-radio-group" id="mobile_reset_filter_' + coverTypeValue + '" class="radioButton-custom  cover-type-mobile radio '+ (tab.defaultTab === true ? 'active' : '') +'" data-clt-index="' + i +'" value="' + coverTypeValue + '" data-ranking-filter="' + tab.rankingFilter +'">';
            mobileCoverTypes += 		'<label for="mobile_reset_filter_' + coverTypeValue + '">' + coverTypeText + '</label>';
            mobileCoverTypes += 	'</div>';
            mobileCoverTypes += '</div>';

			// custom code due to requirement
			switch (coverTypeValue) {
				case 'mid_range':
                    coverTypeValue = 'comprehensive_' + coverTypeValue;
                    coverTypeText = 'Comprehensive & <br>Mid Range';
                    break;

				case 'basic':
					coverTypeValue = 'all';
					coverTypeText = 'All';
					break;
			}

			// reset filters
			resetFilters += '<div class="dropdown-item">';
			resetFilters += 	'<div class="radio">';
			resetFilters += 		'<input type="radio" name="reset-filters-radio-group" id="reset_filter_' + coverTypeValue + '" class="radioButton-custom  radio" data-reset-filter-index="' + i +'" value="' + coverTypeValue + '" data-ranking-filter="' + tab.rankingFilter +'"' + (tab.defaultTab === true ? 'checked' : '') + '>';
			resetFilters += 		'<label for="reset_filter_' + coverTypeValue + '">' + coverTypeText + '</label>';
			resetFilters += 	'</div>';
            resetFilters += '</div>';

			// set the originatingTab
			if (tab.defaultTab === true) {
				// retrieve the text value
				originatingTab = settings.verticalMapping[tab.rankingFilter];
			}
		}

        $('.reset-travel-filters').empty().html(resetFilters);

		if (state != 'xs') {
            $currentTabContainer.empty().html(out);
            $('.navbar-mobile').empty();
		} else {
            $('.mobile-cover-types').empty().html(mobileCoverTypes);
            $('.navbar-desktop').empty();
            $('.navbar__travel-filters').show();
		}

		meerkat.modules.travelResultFilters.resetCustomFilters();

		// hide filters for mobile, tablet & AMT
		if (tabLength == 2 || destination == 'AUS') {
			$('.clt-trip-filter').hide();
			$('.mobile-cover-type').show();
		} else {
            $('.clt-trip-filter').show();
		}
	}

    /**
	 * Update the count of the tabs as per changed results
     */
	function updateTabCounts() {
		var currentTabIndex = 0;
		$('.hidden-xs [data-clt-index]').each(function (key, tab) {
			if ($(tab).hasClass('active')) {
				currentTabIndex = $(tab).data('clt-index');
                $('.navbar-cover-text').html('Showing ' + counts[settings.activeTabSet[currentTabIndex].rankingFilter] + ' ' + settings.activeTabSet[currentTabIndex].label.toLowerCase().replace('cover', 'plans'));
            }
			var ranking = $(tab).data('ranking-filter');
			$(tab).find('.tabCount').empty().html('(' + counts[ranking] + ')');
		});

		updateCustomTabCount();
	}

    /**
	 * Update the custom tab count when results change
     */
	function updateCustomTabCount() {
		if ($('[data-travel-filter="custom"]').length) {
            $('[data-travel-filter="custom"]').empty().html('Custom (' + Results.model.travelFilteredProductsCount + ')');

            if (settings.activeTabIndex === -1) {
                meerkat.modules.coverLevelTabs.buildCustomTab();
            }
        }
	}

    /**
	 * Reset the tab results count
     */
	function resetTabResultsCount() {
		counts = {};
	}

    /**
	 * Build the custom tab as per the filter values
     */
	function buildCustomTab() {
		var customTab = '';
		var customRadioMobile = '';
        var tabLength = settings.activeTabSet.length;
        var xsCols = parseInt(6 / tabLength, 10);
        settings.activeTabIndex = -1;
        $('[data-travel-filter="custom"]').remove();
        $('.clt-action').removeClass('active');

        if (state !== 'xs') {
            customTab += '<div class="col-xs-' + xsCols + ' text-center clt-action active" data-travel-filter="custom">';
            customTab += 	'Custom (' + Results.model.travelFilteredProductsCount + ')';
            customTab += '</div>';
            $('.navbar-cover-text').empty().html('Showing ' + Results.model.travelFilteredProductsCount + ' custom plans');
            $('.currentTabsContainer').append(customTab);
            $('[data-travel-filter="custom"]').click(function () {
                settings.activeTabIndex = -1;
                $(this).siblings().removeClass('active').end().addClass('active');
                $('.navbar-cover-text').empty().html('Showing ' + Results.model.travelFilteredProductsCount + ' custom plans');
                Results.model.travelResultFilter(true, true, true);
            });
		} else {
            if ($('[data-travel-filter="custom-mobile"]').length === 0) {
                customRadioMobile += '<div class="dropdown-item">';
                customRadioMobile += 	'<div class="radio">';
                customRadioMobile += 		'<input type="radio" name="cover-type-mobile-radio-group" id="mobile_cover_type_custom" class="radioButton-custom radio" data-travel-filter="custom-mobile">';
                customRadioMobile += 		'<label for="mobile_cover_type_custom">Custom</label>';
                customRadioMobile += 	'</div>';
                customRadioMobile += '</div>';
                $('.mobile-cover-types').append(customRadioMobile);
			}
            $('.mobile-active-cover-type').empty().text('Custom');
            $('[data-travel-filter="custom-mobile"]').prop("checked", true);

            $('[data-travel-filter="custom-mobile"]').change(function () {
                $('.mobile-active-cover-type').empty().text('Custom');
                settings.activeTabIndex = -1;
                Results.model.travelResultFilter(true, true, true);
                $('#coverTypeDropdownBtn').dropdown('toggle');
			});
		}
	}

	// return the originating tab value
	function getOriginatingTab() {
		return originatingTab;
	}

	// return the departing tab value. Depending
	function getDepartingTabJourney() {

		var departingTabJourney = "default";

		if (settings.enabled) {
			departingTabJourney = "";
			var sep = ""; // separator
			for (var i = 0; i < departingTab.length; i++) {
				departingTabJourney += sep + settings.verticalMapping[departingTab[i]];
				sep = ",";
			}
		}

		// clear the departing tab array every time we handover
		// not required for now but can be added as an option later
		// departingTab = [];

		return departingTabJourney;
	}

	/**
	 * It needs to reset in onBeforeEnter as result counts can change.
	 * @param Array of POJO activeTabSet
	 */
	function setActiveTabSet(activeTabSet) {
		log("[coverleveltabs] activeTabSet", activeTabSet);
		settings.activeTabSet = activeTabSet;
	}

	function getActiveTabIndex () {
		return settings.activeTabIndex;
	}

	/**
	 * Increment a counter for each result as we massage, so we don't have to filter again.
	 * If we remove massaging to add the cover level into backend, results would need to return the count.
	 * This function not work cross-vertical in future, but currently is the only real way to get counts without re-filtering each tab.
	 * Is incremented from
	 */
	function incrementCount(coverLevel) {
		if(typeof counts[coverLevel] === "undefined") {
			counts[coverLevel] = 0;
		}
		counts[coverLevel]++;
	}

	function setRankingFilter(rankingFilter) {
		currentRankingFilter = rankingFilter;
	}

	function getRankingFilter() {
		return currentRankingFilter;
	}

	function isEnabled() {
		return settings.enabled || false;
	}

	/**
	 * OnBeforeEnter, clear the current tabs (as counts or actual tabs may change)
	 * Set the active tab set based on criteria specified in {vertical}CoverLevelTabs.js
	 * Reset hasRunTrackingCall to empty array, as each new load will require the call to be run again.
	 * Set activeTabIndex back to default
	 * @param {POJO} activeTabSet
	 */
	function resetView(activeTabSet) {
		log("[coverleveltabs] resetView");
        $('.navbar-cover-text').empty();
        $('.navbar__travel-filters').hide();
        $('.clt-trip-filter').hide();
		$currentTabContainer.empty();
		hasRunTrackingCall = [];
		settings.activeTabIndex = false;
		setActiveTabSet(activeTabSet);
		counts = {};
	}

	meerkat.modules.register("coverLevelTabs", {
		initCoverLevelTabs: initCoverLevelTabs,
		events: events,
		setActiveTabSet: setActiveTabSet,
		getActiveTabIndex: getActiveTabIndex,
		resetView: resetView,
		getRankingFilter: getRankingFilter,
		isEnabled: isEnabled,
		incrementCount: incrementCount,
		getOriginatingTab: getOriginatingTab,
		getDepartingTabJourney: getDepartingTabJourney,
		buildCustomTab: buildCustomTab,
        updateTabCounts: updateTabCounts,
        updateCustomTabCount: updateCustomTabCount,
        resetTabResultsCount: resetTabResultsCount
	});

})(jQuery);