;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
		// Defined here because it's published in Results.js
		RESULTS_ERROR: 'RESULTS_ERROR'
	};

	meerkatEvents.carResults = {
		RESULTS_RENDER_COMPLETED : "RESULTS_RENDER_COMPLETED"
	};

	var $component; //Stores the jQuery object for the component group
	var previousBreakpoint;
	var best_price_count = 5;
	var needToBuildFeatures = false;

	function initPage(){

		initResults();

		Features.init();
		meerkat.modules.compare.initCompare();
		eventSubscriptions();

		breakpointTracking();

	}

	function onReturnToPage(){
		breakpointTracking();
		if (previousBreakpoint !== meerkat.modules.deviceMediaState.get()) {
			Results.view.calculateResultsContainerWidth();
			Features.clearSetHeights();
			Features.balanceVisibleRowsHeight();
		}
		Results.pagination.refresh();
	}

	function initResults(){

		try {
			var displayMode = 'price';
			if(typeof meerkat.site != 'undefined' && typeof meerkat.site.resultOptions != 'undefined') {
				// confirming its either features or price.
				displayMode = meerkat.site.resultOptions.displayMode == 'features' ? 'features' : 'price';
			}
			// Split-test to display features by default
			if(meerkat.modules.splitTest.isActive(2)) {
				displayMode = 'features';
			}
			// Init the main Results object
			Results.init({
				url: "ajax/json/car_quote_results.jsp",
				runShowResultsPage: false, // Don't let Results.view do it's normal thing.
				paths: {
					productId: "productId",
					productName: "headline.name",
					productBrandCode: "brandCode",
					price: {
						annually: "headline.lumpSumTotal",
						/* The annual property is here as a hack because Payment Type (#quote_paymentType) is configured incorrectly.
						When upgrading Car, someone should reconfigure the sort to be 'annually'. We haven't done so due to potential impact on reporting etc.
						*/
						annual: "headline.lumpSumTotal",
						monthly: "headline.instalmentTotal"
					},
					availability: {
						product: "available",
						price: {
							annually: "headline.lumpSumTotal",
							annual: "headline.lumpSumTotal",
							monthly: "headline.instalmentTotal"
						}
					}
				},
				show: {
					savings: false,
					featuresCategories: false,
					nonAvailablePrices: true,     // This will apply the availability.price rule
					nonAvailableProducts: false,  // This will apply the availability.product rule
					unavailableCombined: true     // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
				},
				availability: {
					product: ["equals", "Y"],
					price: ["notEquals", -1] // As a filter this should never match, but is here due to inconsistent Car data model and work-around for Results.setFrequency
				},
				render: {
					templateEngine: '_',
					features: {
						mode: 'populate',
						headers: false,
						numberOfXSColumns: 1
					},
					dockCompareBar: false
				},
				displayMode: displayMode, // features, price
				pagination: {
					mode: 'page',
					touchEnabled: Modernizr.touch
				},
				sort: {
					sortBy: 'price.annually'
				},
				//frequency: "annually",
				/* See comment above */
				frequency: "annual",
				animation: {
					results: {
						individual: {
							active: false
						},
						delay: 500,
						options: {
							easing: "swing", // animation easing type
							duration: 1000
						}
					},
					shuffle: {
						active: true,
						options: {
							easing: "swing", // animation easing type
							duration: 1000
						}
					},
					filter: {
						reposition: {
							options: {
								easing: "swing" // animation easing type
							}
						}
					}
				},
				elements: {
					features:{
						values: ".content",
						extras: ".children"
					}
				},
				templates:{
					pagination:{
						pageText: 'Product {{=currentPage}} of {{=totalPages}}'
					}
				},
				dictionary: {
					valueMap:[
						{
							key:'Y',
							value: "<span class='icon icon-tick'></span>"
						},
						{
							key:'N',
							value: "<span class='icon icon-cross'></span>"
						},
						{
							key:'R',
							value: "Restricted / Conditional"
						},
						{
							key:'AI',
							value: "Additional Information"
						},
						{
							key:'O',
							value: "Optional"
						},
						{
							key:'L',
							value: "Limited"
						},
						{
							key:'SCH',
							value: "As shown in schedule"
						},
						{
							key:'NA',
							value: "Non Applicable"
						},
						{
							key:'E',
							value: "Excluded"
						},
						{
							key:'NE',
							value: "No Exclusion"
						},
						{
							key:'NS',
							value: "No Sub Limit"
						},
						{
							key:'OTH',
							value: ""
						}
					]
				},
				rankings: {
					paths: {
						rank_productId: "productId",
						rank_premium: "headline.lumpSumTotal"
				},
					filterUnavailableProducts : false
				},
				incrementTransactionId : false
			});

		}
		catch(e) {
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.carResults.init(); '+e.message, e);
		}
	}

	function eventSubscriptions() {

		// Capture offer terms link clicks
		$(document.body).on('click', 'a.offerTerms', launchOfferTerms);

		// Handle result row click
		$(Results.settings.elements.resultsContainer).on('click', '.result-row', resultRowClick);

		// When the navar docks/undocks
		meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
			$('#resultsPage').css('margin-top', '35px');
		});
		meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
			$('#resultsPage').css('margin-top', '0');
		});

		// When the excess filter changes, fetch new results
		meerkat.messaging.subscribe(meerkatEvents.carFilters.CHANGED, function onFilterChange(obj){
			if (obj && obj.hasOwnProperty('excess')) {
				// This is a little dirty however we need to temporarily override the
				// setting which prevents the tranId from being incremented.
				Results.settings.incrementTransactionId = true;
				get();
				Results.settings.incrementTransactionId = false;
			} else {
				meerkat.modules.resultsTracking.setResultsEventMode('Refresh');
			}

			meerkat.modules.session.poke();
		});

		// If error occurs, go back in the journey
		meerkat.messaging.subscribe(events.RESULTS_ERROR, function() {
			// Delayed to allow journey engine to unlock
			_.delay(function() {
				meerkat.modules.journeyEngine.gotoPath('previous');
			}, 1000);
		});

		$(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function(){
			Features.buildHtml();
		});

		// Run the show method even when there are no available products
		// This will render the unavailable combined template
		$(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
			Results.view.show();
		});

		$(document).on("resultsLoaded", onResultsLoaded);

		// Scroll to the top when results come back
		$(document).on("resultsReturned", function(){
			meerkat.modules.utilities.scrollPageTo($("header"));

			// Reset the feature header to match the new column content.
			$(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");

		});

		// Start fetching results
		$(document).on("resultsFetchStart", function onResultsFetchStart() {
			meerkat.modules.journeyEngine.loadingShow('getting your quotes');
			$('#resultsPage, .loadingDisclaimerText').removeClass('hidden');
			if (meerkat.site.tracking.brandCode == 'ctm' && meerkat.modules.splitTest.isActive(4)) {
				$('#resultsPage, .loadingQuoteText').removeClass('hidden');
			} else {
				$('#resultsPage, .loadingDisclaimerText').addClass('originalDisclaimer');
			}
			// Hide pagination
			Results.pagination.hide();
		});

		// Fetching done
		$(document).on("resultsFetchFinish", function onResultsFetchFinish() {

			// Results are hidden in the CSS so we don't see the scaffolding after #benefits
			$(Results.settings.elements.page).show();

			meerkat.modules.journeyEngine.loadingHide();

			$('.loadingDisclaimerText').addClass('hidden');
			if (meerkat.site.tracking.brandCode == 'ctm' && meerkat.modules.splitTest.isActive(4)) {
				$('.loadingQuoteText').addClass('hidden');
			} else {
				$('.loadingDisclaimerText').addClass('originalDisclaimer');
			}

			if (Results.getDisplayMode() !== 'price') {
				// Show pagination
				Results.pagination.show();
			}
			else {
				$(document.body).removeClass('priceMode').addClass('priceMode');
			}

			// If no providers opted to show results, display the no results modal.
			var availableCounts = 0;
			$.each(Results.model.returnedProducts, function(){
				if (this.available === 'Y' && this.productId !== 'CURR') {
					availableCounts++;
				}
			});
			// Check products length in case the reason for no results is an error e.g. 500
			if (availableCounts === 0 && _.isArray(Results.model.returnedProducts) && Results.model.returnedProducts.length > 0) {
				showNoResults();
			}

				meerkat.messaging.publish(meerkatEvents.carResults.RESULTS_RENDER_COMPLETED);

		});

		$(document).on("populateFeaturesStart", function onPopulateFeaturesStart() {
			meerkat.modules.performanceProfiling.startTest('results');

		});

		$(Results.settings.elements.resultsContainer).on("populateFeaturesEnd", function onPopulateFeaturesEnd() {

			var time = meerkat.modules.performanceProfiling.endTest('results');

			var score
			if(time < 800){
				score = meerkat.modules.performanceProfiling.PERFORMANCE.HIGH;
			}else if (time < 8000 && meerkat.modules.performanceProfiling.isIE8() === false){
				score = meerkat.modules.performanceProfiling.PERFORMANCE.MEDIUM;
			}else{
				score = meerkat.modules.performanceProfiling.PERFORMANCE.LOW;
			}

			Results.setPerformanceMode(score);

		});

		$(document).on("resultPageChange", function(event) {
			var pageData = event.pageData;
			if(pageData.measurements === null) return false;

			var items = Results.getFilteredResults().length;
			var columnsPerPage = pageData.measurements.columnsPerPage;
			var freeColumns = (columnsPerPage*pageData.measurements.numberOfPages)-items;
		});

		// Hovering a row cell adds a class to the whole row to make it highlightable
		$(document).on("FeaturesRendered", function(){

			$(Features.target + " .expandable > " + Results.settings.elements.features.values).on("mouseenter", function(){
				var featureId = $(this).attr("data-featureId");
				var $hoverRow = $( Features.target + ' [data-featureId="' + featureId + '"]' );

				$hoverRow.addClass( Results.settings.elements.features.expandableHover.replace(/[#\.]/g, '') );
			})
			.on("mouseleave", function(){
				var featureId = $(this).attr("data-featureId");
				var $hoverRow = $( Features.target + ' [data-featureId="' + featureId + '"]' );

				$hoverRow.removeClass( Results.settings.elements.features.expandableHover.replace(/[#\.]/g, '') );
			});
		});


		//meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, publishExtraSuperTagEvents);
		//meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, publishExtraSuperTagEvents);
	}

	function breakpointTracking(){

		startColumnWidthTracking();

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter(){
			if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results') {
				startColumnWidthTracking();
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function resultsXsBreakpointLeave(){
			stopColumnWidthTracking();
			Results.pagination.setCurrentPageNumber(1);
			Results.pagination.resync();
		});

	}

	function startColumnWidthTracking() {
		if (meerkat.modules.deviceMediaState.get() === 'xs' && Results.getDisplayMode() === 'features') {
			Results.view.startColumnWidthTracking( $(window), Results.settings.render.features.numberOfXSColumns, false );
			Results.pagination.setCurrentPageNumber(1);
			Results.pagination.resync();
		}
	}

	function stopColumnWidthTracking() {
		Results.view.stopColumnWidthTracking();
	}

	function recordPreviousBreakpoint(){
		previousBreakpoint = meerkat.modules.deviceMediaState.get();
	}

	// Wrapper around results component, load results data
	function get() {
		meerkat.modules.carContactOptins.validateOptins();
		Results.get();
	}

	function onResultsLoaded() {
		startColumnWidthTracking();

		// Reset vars
		switch(Results.getDisplayMode()) {
			case 'features':
				switchToFeaturesMode(false);
			break;
			default:
				needToBuildFeatures = true;
				switchToPriceMode(false);
			break;
		}

	}

	function showNoResults() {
		if (meerkat.modules.hasOwnProperty('carFilters')) {
			meerkat.modules.carFilters.disable();
		}
	}

	/**
	 * This function has been refactored into calling a core resultsTracking module.
	 * It has remained here so verticals can run their own unique calls.
	 */
	function publishExtraSuperTagEvents() {
		var $excess = $('#navbar-filter .dropdown.filter-excess span:first-child'),
		preferredExcess = "default";

		if($excess.length) {
			preferredExcess = $excess.text().toLowerCase();
			preferredExcess = preferredExcess.indexOf("please") !== -1 ? null : preferredExcess;
		}

		meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
			additionalData: {
				paymentPlan: $('#navbar-filter .dropdown.filter-frequency span:first-child').text(),
				preferredExcess: preferredExcess
			},
			onAfterEventMode: 'Load'
		});
	}

	function launchOfferTerms(event) {
		meerkat.modules.carMoreInfo.setScrollPosition();
		event.preventDefault();

		var $element = $(event.target);
		var $termsContent = $element.next('.offerTerms-content');

		var $logo =				$element.closest('.resultInsert, .more-info-content, .call-modal').find('.companyLogo');
		var $productName =		$element.closest('.resultInsert, .more-info-content, .call-modal').find('.productTitle, .productName');

		meerkat.modules.dialogs.show({
			title: $logo.clone().wrap('<p>').addClass('hidden-xs').parent().html() + "<div class='hidden-xs heading'>" + $productName.html() + "</div>" + "<div class='heading'>Offer terms</div>",
			hashId: 'offer-terms',
			className: 'offer-terms-modal',
			openOnHashChange: false,
			closeOnHashChange: true,
			htmlContent: $logo.clone().wrap('<p>').removeClass('hidden-xs').addClass('hidden-sm hidden-md hidden-lg').parent().html() + "<h2 class='visible-xs heading'>" + $productName.html() + "</h2>" +  $termsContent.html()
		});
	}
	/**
	 * DOM cleanup/display to swap to price mode
	 * @param {Boolean} doTracking: whether to run tracking or not
	 * The doTracking parameter is used to ensure tracking is not performed when
	 * loading the page with a pre-set default display mode e.g. ?display=price
	 */
	function switchToPriceMode(doTracking) {
		if(typeof doTracking == 'undefined') {
			doTracking = true;
		}
		// Confirm results is initiated
		if (Results.getDisplayMode() === null) return;

		if(Results.getDisplayMode() !== 'price') {

		Results.pagination.hide();
		$('header .xs-results-pagination').addClass('hidden');

		Results.setDisplayMode('price');

		stopColumnWidthTracking();

		$(document.body).addClass('priceMode');
		$(window).scrollTop(0);

		if(doTracking) {
				meerkat.modules.resultsTracking.setResultsEventMode('Refresh');
			publishExtraSuperTagEvents();
		}
	}
	}

	/**
	 * DOM cleanup/display to swap to features mode
	 * @param {Boolean} doTracking: whether to run tracking or not
	 * The doTracking parameter is used to ensure tracking is not performed when
	 * loading the page with a pre-set default display mode e.g. ?display=features
	 */
	function switchToFeaturesMode(doTracking) {
		if(typeof doTracking == 'undefined') {
			doTracking = true;
		}
		// Confirm results is inited
		if (Results.getDisplayMode() === null) return;

		if(Results.getDisplayMode() !== 'features') {

		// Force a refresh if we need to rebuild the features. Would be needed if the results were initially loaded in Price mode.
		var forceRefresh = (needToBuildFeatures === true);

		Results.setDisplayMode('features', forceRefresh);

		// On XS this will make the columns fit into the viewport. Necessary to do before pagination calculations.
		startColumnWidthTracking();

		// Double check that features mode fits into viewport

		_.defer(function() {
			Results.pagination.gotoPage(1);
			if (meerkat.modules.deviceMediaState.get() === 'xs') {
				Results.view.setColumnWidth($(window), Results.settings.render.features.numberOfXSColumns, false);
			}
			Results.pagination.setupNativeScroll();
		});

		// Refresh XS pagination
		Results.pagination.show(true);
		$('header .xs-results-pagination').removeClass('hidden');

		needToBuildFeatures = false;
		$(document.body).removeClass('priceMode');
		$(window).scrollTop(0);
		if(doTracking) {
				meerkat.modules.resultsTracking.setResultsEventMode('Refresh');
			publishExtraSuperTagEvents();
		}
	}
	}

	function resultRowClick(event) {
		// Ensure only in XS price mode
		if ($(Results.settings.elements.resultsContainer).hasClass('priceMode') === false) return;
		if (meerkat.modules.deviceMediaState.get() !== 'xs') return;

		//console.log(event);

		var $resultrow = $(event.target);
		if ($resultrow.hasClass('result-row') === false) {
			$resultrow = $resultrow.parents('.result-row');
		}

		// Row must be available to click it.
		if (typeof $resultrow.attr('data-available') === 'undefined' || $resultrow.attr('data-available') !== 'Y') return;

		// Set product and launch bridging
		meerkat.modules.moreInfo.setProduct(Results.getResult('productId', $resultrow.attr('data-productId')));
		meerkat.modules.carMoreInfo.runDisplayMethod();
	}

	function init(){

		$component = $("#resultsPage");

		meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);

		// Elements to lock when entering compare mode
		meerkat.messaging.subscribe(meerkatEvents.compare.AFTER_ENTER_COMPARE_MODE, function() {
			$('.filter-excess, .filter-excess a').addClass('disabled');
			$('.filter-featuresmode, .filter-pricemode').addClass('hidden');
		});

		// Elements to lock when exiting compare mode
		meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, function() {
			$('.filter-excess, .filter-excess a').removeClass('disabled');
			$('.filter-featuresmode, .filter-pricemode').removeClass('hidden');
		});


	}

	meerkat.modules.register('carResults', {
		init: init,
		initPage: initPage,
		onReturnToPage: onReturnToPage,
		get: get,
		stopColumnWidthTracking: stopColumnWidthTracking,
		recordPreviousBreakpoint: recordPreviousBreakpoint,
		switchToPriceMode: switchToPriceMode,
		switchToFeaturesMode: switchToFeaturesMode,
		showNoResults: showNoResults,
		publishExtraSuperTagEvents: publishExtraSuperTagEvents
	});

})(jQuery);
