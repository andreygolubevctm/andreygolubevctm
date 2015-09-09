;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
		// Defined here because it's published in Results.js
		RESULTS_ERROR: 'RESULTS_ERROR'
	};


	var $component; //Stores the jQuery object for the component group
	var previousBreakpoint;
	var best_price_count = 5;
	var needToBuildFeatures = false;

	function initPage(){

		$component = $('#resultsPage');

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

			var price = {
				annual: "price.annual.total",
				monthly: "price.monthly.total"
			};
			var productAvailable = "productAvailable";
			var productName = "headline.name";
			var homeQuoteResultsUrl = "ajax/json/home_results.jsp";
			if (meerkat.modules.splitTest.isActive(40) || meerkat.site.isDefaultToHomeQuote) {
				price = {
					annual: "price.annualPremium",
					annually: "price.annualPremium",
					monthly: "price.annualisedMonthlyPremium"
				};
				productAvailable = "available";
				productName = "productName";
				homeQuoteResultsUrl = "ajax/json/home_results_ws.jsp"
			}

			// Init the main Results object
			Results.init({
				url: homeQuoteResultsUrl,
				runShowResultsPage: false, // Don't let Results.view do it's normal thing.
				paths: {
					price: price,
					availability: {
						product: productAvailable
					},
					productId: "productId",
					productBrandCode: "brandCode",
					productName: productName
				},
				show: {
					savings: false,
					featuresCategories: false,
					nonAvailableProducts: false,  // This will apply the availability.product rule
					unavailableCombined: true     // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
				},
				availability: {
					product: ["equals", "Y"]
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
					touchEnabled: Modernizr.touch,
					emptyContainerFunction: emptyPaginationLinks,
					afterPaginationRefreshFunction: afterPaginationRefresh
				},
				sort: {
					sortBy: 'price.annually'
				},
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
						rank_premium: price.annual
					},
					filterUnavailableProducts: false
				},
				incrementTransactionId: false
			});

		}
		catch(e) {
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.homeResults.initResults(); '+e.message, e);
		}
	}

	function eventSubscriptions() {

		// Capture offer terms link clicks
		$(document.body).on('click', 'a.offerTerms', launchOfferTerms);

		// Handle result row click
		$(Results.settings.elements.resultsContainer).on('click', '.result-row', resultRowClick);

//TODO
		// When the navar docks/undocks
		meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
			$('#resultsPage').css('margin-top', '35px');
		});
		meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
			$('#resultsPage').css('margin-top', '0');
		});

		// When the excess filter changes, fetch new results
		meerkat.messaging.subscribe(meerkatEvents.homeFilters.CHANGED, function onFilterChange(obj){
			if (obj && (obj.hasOwnProperty('homeExcess') || obj.hasOwnProperty('contentsExcess'))) {
				// This is a little dirty however we need to temporarily override the
				// setting which prevents the tranId from being incremented.
				meerkat.modules.resultsTracking.setResultsEventMode('Load');
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

		// Model updated, make changes before rendering
		meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
			massageResultsObject();
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
			meerkat.modules.utils.scrollPageTo($("header"));

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
				if (meerkat.modules.splitTest.isActive(40) || meerkat.site.isDefaultToHomeQuote) {
					if (this.available === 'Y' && this.productId !== 'CURR') {
						availableCounts++;
					}
				} else {
					if (this.productAvailable === 'Y' && this.productId !== 'CURR') {
						availableCounts++;
					}
				}
			});
			// Check products length in case the reason for no results is an error e.g. 500
			if (availableCounts === 0 && _.isArray(Results.model.returnedProducts) && Results.model.returnedProducts.length > 0) {
				showNoResults();
			}

			meerkat.messaging.publish(meerkatEvents.commencementDate.RESULTS_RENDER_COMPLETED);

		});

		$(document).on("populateFeaturesStart", function onPopulateFeaturesStart() {
			meerkat.modules.performanceProfiling.startTest('results');

		});

		$(Results.settings.elements.resultsContainer).on("populateFeaturesEnd", function onPopulateFeaturesEnd() {

			var time = meerkat.modules.performanceProfiling.endTest('results');

			var score;
			if(time < 800){
				score = meerkat.modules.performanceProfiling.PERFORMANCE.HIGH;
			}else if (time < 8000 && meerkat.modules.performanceProfiling.isIE8() === false){
				score = meerkat.modules.performanceProfiling.PERFORMANCE.MEDIUM;
			}else{
				score = meerkat.modules.performanceProfiling.PERFORMANCE.LOW;
			}

			Results.setPerformanceMode(score);

			var coverType = meerkat.modules.home.getCoverType();
			if (coverType === 'H') { // Home Only Cover
				$.each($('.featuresList'), function moveHome() { $(this).children('.homeFeature').appendTo($(this)) });
				$.each($('.featuresList'), function moveContents() { $(this).children('.contentsFeature').appendTo($(this)) });
			}
			else { //Either Contents Only Cover or Home & Contents Cover
				$.each($('.featuresList'), function moveContents() { $(this).children('.contentsFeature').appendTo($(this)) });
				$.each($('.featuresList'), function moveHome() { $(this).children('.homeFeature').appendTo($(this)) });
			}

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
	}

	// After the results have been fetched, force data onto it to support our Results engine.
	function massageResultsObject(products) {
		products = products || Results.model.returnedProducts;

		if (meerkat.modules.splitTest.isActive(40) || meerkat.site.isDefaultToHomeQuote) {

			_.each(products, function massageJson(result, index) {
				// Add properties
				if (result.price != null && !_.isUndefined(result.price)) {

					// Annually
					if (!_.isUndefined(result.price.annualPremium)) {
						result.price.annualPremiumFormatted = meerkat.modules.currencyField.formatCurrency(result.price.annualPremium, {roundToDecimalPlace: 0});
					}

					//Monthly
					if (!_.isUndefined(result.price.monthlyPremium)) {
						if (!_.isUndefined(result.price.monthlyPremium)) {
							result.price.monthlyPremiumFormatted = meerkat.modules.currencyField.formatCurrency(result.price.monthlyPremium, {roundToDecimalPlace: 2});
						}
						if (!_.isUndefined(result.price.monthlyFirstMonth)) {
							result.price.monthlyFirstMonthFormatted = meerkat.modules.currencyField.formatCurrency(result.price.monthlyFirstMonth, {roundToDecimalPlace: 2});
						}
						if (!_.isUndefined(result.price.annualisedMonthlyPremium)) {
							result.price.annualisedMonthlyPremiumFormatted = meerkat.modules.currencyField.formatCurrency(result.price.annualisedMonthlyPremium, {roundToDecimalPlace: 2});
						}
					}
				}

				if (result.homeExcess != null && !_.isUndefined(result.homeExcess)) {
					if (!_.isUndefined(result.homeExcess.amount)) {
						result.homeExcess.amountFormatted = meerkat.modules.currencyField.formatCurrency(result.homeExcess.amount, {roundToDecimalPlace: 0});
					}
				}

				if (result.contentsExcess != null && !_.isUndefined(result.contentsExcess)) {
					if (!_.isUndefined(result.contentsExcess.amount)) {
						result.contentsExcess.amountFormatted = meerkat.modules.currencyField.formatCurrency(result.contentsExcess.amount, {roundToDecimalPlace: 0});
					}
				}
			});

		} else {

			_.each(products, function massageJson(result, index) {
				// Add properties
				if (!_.isUndefined(result.price)) {
					// Annually
					if (!_.isUndefined(result.price.annual) && !_.isUndefined(result.price.annual.total)) {
						result.price.annual.totalFormatted = meerkat.modules.currencyField.formatCurrency(result.price.annual.total, {roundToDecimalPlace: 0});
					}

					//Monthly
					if (!_.isUndefined(result.price.monthly)) {
						if (!_.isUndefined(result.price.monthly.total)) {
							result.price.monthly.totalFormatted = meerkat.modules.currencyField.formatCurrency(result.price.monthly.total, {roundToDecimalPlace: 2});
						}
						if (!_.isUndefined(result.price.monthly.amount)) {
							result.price.monthly.amountFormatted = meerkat.modules.currencyField.formatCurrency(result.price.monthly.amount, {roundToDecimalPlace: 2});
						}
						if (!_.isUndefined(result.price.monthly.firstPayment)) {
							result.price.monthly.firstPaymentFormatted = meerkat.modules.currencyField.formatCurrency(result.price.monthly.firstPayment, {roundToDecimalPlace: 2});
						}
					}
				}

				if (!_.isUndefined(result.HHB)) {
					if (!_.isUndefined(result.HHB.excess) && !_.isUndefined(result.HHB.excess.amount)) {
						result.HHB.excess.amountFormatted = meerkat.modules.currencyField.formatCurrency(result.HHB.excess.amount, {roundToDecimalPlace: 0});
					}
				}

				if (!_.isUndefined(result.HHC)) {
					if (!_.isUndefined(result.HHC.excess) && !_.isUndefined(result.HHC.excess.amount)) {
						result.HHC.excess.amountFormatted = meerkat.modules.currencyField.formatCurrency(result.HHC.excess.amount, {roundToDecimalPlace: 0});
					}
				}
			});
		}
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
		// Use classes for type to trigger hide/show feature rows
		$component.removeClass('coverTypeContents coverTypeHome');
		var coverType = meerkat.modules.home.getCoverType();
		if (coverType === 'H') {
			$component.removeClass('coverTypeContents').addClass('coverTypeHome');
		}
		else if (coverType === 'C') {
			$component.addClass('coverTypeContents').removeClass('coverTypeHome');
		}

		var envParam = "";
		if(meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi'){
			$("#environmentOverride").val($("#developmentAggregatorEnvironment").val());
		}
		var verticalToUse = meerkat.modules.splitTest.isActive(40) || meerkat.site.isDefaultToHomeQuote ? 'hncamsws_' : 'hncams';
		// Fetch results
		meerkat.modules.resultsFeatures.fetchStructure(verticalToUse).done(function() {
			Results.get();
		});
	}



	// This is used by ResultsPagination
	// Custom code to remove pagination links but retain other elements
	function emptyPaginationLinks($container) {
		$container.find('.btn-pagination').parent('li').remove();
		$container.find('.pagination-label').addClass('hidden');
	}

	function afterPaginationRefresh($container) {
		if ($container.find('.btn-pagination').length > 0) {
			$container.find('.pagination-label').removeClass('hidden');
		}
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
		if (meerkat.site.tracking.brandCode == 'ctm') {
			meerkat.modules.dialogs.show({
				htmlContent: $('#no-results-content')[0].outerHTML
			});
		}

		if (meerkat.modules.hasOwnProperty('homeFilters')) {
			meerkat.modules.homeFilters.disable();
		}
	}

	/**
	 * This function has been refactored into calling a core resultsTracking module.
	 * It has remained here so verticals can run their own unique calls.
	 */
	function publishExtraSuperTagEvents() {

		var coverType = meerkat.modules.home.getCoverType(),
			homeExcess = null,
			contentsExcess = null;

		if(coverType == 'H' || coverType == 'HC') {
			homeExcess = $('#home_homeExcess').val()  || $('#home_baseHomeExcess').val();
		}

		if(coverType == 'C' || coverType == 'HC') {
			contentsExcess = $('#home_contentsExcess').val() || $('#home_baseContentsExcess').val();
		}

		meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
			additionalData: {
				paymentPlan: $('#navbar-filter .dropdown.filter-frequency span:first-child').text(),
				homeExcess: homeExcess,
				contentsExcess: contentsExcess
			},
			onAfterEventMode: 'Load'
		});
	}

	function launchOfferTerms(event) {
		meerkat.modules.homeMoreInfo.setScrollPosition();
		event.preventDefault();

		var $element = $(event.target);
		var $termsContent = $element.next('.offerTerms-content');

		var $logo =				$element.closest('.resultInsert, .more-info-content, .call-modal').find('.companyLogo');
		var $productName =		$element.closest('.resultInsert, .more-info-content, .call-modal').find('.productTitle, .productName');

		meerkat.modules.dialogs.show({
			title: $logo.clone().wrap('<p>').addClass('hidden-xs').parent().html() + "<div class='hidden-xs heading'>" + $productName.html() + "</div>" + "<div class='heading'>Offer terms</div>",
			hashId: 'offer-terms',
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


		var $resultrow = $(event.target);
		if ($resultrow.hasClass('result-row') === false) {
			$resultrow = $resultrow.parents('.result-row');
		}

		// Row must be available to click it.
		if (typeof $resultrow.attr('data-available') === 'undefined' || $resultrow.attr('data-available') !== 'Y') return;

		// Set product and launch bridging
		meerkat.modules.moreInfo.setProduct(Results.getResult('productId', $resultrow.attr('data-productId')));
		meerkat.modules.homeMoreInfo.runDisplayMethod();
	}

	function init(){
		meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);

		// Elements to lock when entering compare mode
		meerkat.messaging.subscribe(meerkatEvents.compare.AFTER_ENTER_COMPARE_MODE, function() {

			$('.filter-excess, .filter-excess a, .excess-update, .excess-update a').addClass('disabled');
			$('.filter-featuresmode, .filter-pricemode').addClass('hidden');
		});
		// Elements to lock when exiting compare mode
		meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, function() {
			$('.filter-excess, .filter-excess a, .excess-update, .excess-update a').removeClass('disabled');
			$('.filter-featuresmode, .filter-pricemode').removeClass('hidden');
		});

	}

	meerkat.modules.register('homeResults', {
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
