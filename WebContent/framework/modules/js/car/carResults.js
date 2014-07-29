;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		supertagEventMode = 'Load';

	var supertagResultsEventMode = 'Load';

	var $component; //Stores the jQuery object for the component group
	var previousBreakpoint;
	var best_price_count = 5;
	var needToBuildFeatures = false;

	function initPage(){

		initResults();

		Features.init();
		Compare.init();

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

// TODO //
		try {
			var displayMode = 'price';
			if(typeof meerkat.site != 'undefined' && typeof meerkat.site.resultOptions != 'undefined') {
				// confirming its either features or price.
				displayMode = meerkat.site.resultOptions.displayMode == 'features' ? 'features' : 'price';
			}
			// Init the main Results object
			Results.init({
				url: "ajax/json/car_quote_results.jsp",
				//url: 'zzz_car_results.json',
				runShowResultsPage: false, // Don't let Results.view do it's normal thing.
				paths: {
					productId: "productId",
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
				paginationMode: 'page',
				paginationTouchEnabled: Modernizr.touch,
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
						active: false,
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
						productId: "productId",
						price: "headline.lumpSumTotal"
					}
				}
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
				get();
			}
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
			// Hide pagination
			Results.pagination.hide();
		});

		// Fetching done
		$(document).on("resultsFetchFinish", function onResultsFetchFinish() {

			// Results are hidden in the CSS so we don't see the scaffolding after #benefits
			$(Results.settings.elements.page).show();

			meerkat.modules.journeyEngine.loadingHide();
			$('.loadingDisclaimerText').addClass('hidden');

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
			if (availableCounts === 0) {
				showNoResults();
			}

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


		meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, publishExtraSuperTagEvents);
		meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, publishExtraSuperTagEvents);

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
		meerkat.modules.dialogs.show({
			htmlContent: $('#no-results-content')[0].outerHTML
		});
	}

	function publishExtraSuperTagEvents() {

		var display = Results.getDisplayMode();
		if(display.indexOf("f") === 0) {
			display = display.slice(0, -1); // drop the trailing S off of features
		}

		var data = {
				vertical: meerkat.site.vertical,
				actionStep: meerkat.site.vertical + ' results',
				display: display,
				paymentPlan: $('#navbar-filter .dropdown.filter-frequency span:first-child').text(),
				preferredExcess: $('#navbar-filter .dropdown.filter-excess span:first-child').text(),
				event: supertagResultsEventMode
		};

		if(data.preferredExcess.toLowerCase().indexOf("please") !== -1) {
			data.preferredExcess = '';
		}

		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteList',
			object:	data
		});

		supertagResultsEventMode = 'Refresh'; // update for next call.*/
	}

	function launchOfferTerms(event) {
		event.preventDefault();

		var $element = $(event.target);
		var $termsContent = $element.next('.offerTerms-content');

		meerkat.modules.dialogs.show({
			title: 'Offer terms',
			hashId: 'offer-terms',
			openOnHashChange: false,
			closeOnHashChange: true,
			htmlContent: $termsContent.html()
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
		// Confirm results is inited
		if (Results.getDisplayMode() === null) return;

		Results.pagination.hide();
		$('header .xs-results-pagination').addClass('hidden');

		Results.setDisplayMode('price');

		stopColumnWidthTracking();

		$(document.body).addClass('priceMode');
		$(window).scrollTop(0);

		if(doTracking) {
			publishExtraSuperTagEvents();
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
			publishExtraSuperTagEvents();
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
		showNoResults: showNoResults
	});

})(jQuery);
