;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
		// Defined here because it's published in Results.js
		RESULTS_ERROR: 'RESULTS_ERROR'
	};

	meerkatEvents.homeResults = {
		FEATURES_CALL_ACTION: 'FEATURES_CALL_ACTION',
		FEATURES_CALL_ACTION_MODAL: 'FEATURES_CALL_ACTION_MODAL',
		FEATURES_SUBMIT_CALLBACK: 'FEATURES_SUBMIT_CALLBACK'
	};

	var $component; //Stores the jQuery object for the component group
	var previousBreakpoint;
	var best_price_count = 5;
	var needToBuildFeatures = false;

	function initPage(){

		$component = $('#resultsPage');

		initCompare();

		initResults();

		Features.init();
		meerkat.modules.compare.initCompare();
		eventSubscriptions();

		breakpointTracking();
	}
	
	function affixFix() {
		var $navbar = $('#navbar-main');
		if ($navbar.data('bs.affix') && $navbar.data('bs.affix').options) {
			$navbar.data('bs.affix').options.offset.top = $navbar.offset().top;
		}

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
			var displayMode = 'features';
			if(_.has(meerkat.site,'resultOptions') && _.isObject(meerkat.site.resultOptions) && _.has(meerkat.site.resultOptions,'displayMode')) {
				displayMode = meerkat.site.resultOptions.displayMode;
			}

			var price = {
				annual: "price.annualPremium",
				annually: "price.annualPremium",
				monthly: "price.annualisedMonthlyPremium",
				monthlyAvailable: "price.monthlyAvailable",
				annualAvailable: "price.annualAvailable"
			};
			var features = {
				lossrent: "features.lossrent.value",
				rdef: "features.rdef.value",
				malt: "features.malt.value"
			};
			var productAvailable = "available";
			var productName = "productName";
			var homeQuoteResultsUrl = "ajax/json/home_results_ws.jsp";


			// Init the main Results object
			Results.init({
				url: homeQuoteResultsUrl,
				runShowResultsPage: false, // Don't let Results.view do it's normal thing.
				paths: {
					price: price,
					availability: {
						product: productAvailable,
						price: price
					},
					features: features,
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
						pageText: '{{ if(currentPage <= availableCounts) { }} Product {{=currentPage}} of {{=availableCounts}} {{ } }}'
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
						rank_premium: "price.annualPremium"
					},
					filterUnavailableProducts: true
				},
				incrementTransactionId: false
			});
		}
		catch(e) {
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.homeResults.initResults(); '+e.message, e);
		}
	}

	function sortRealAndWool(results) {
		var isWoolOrRealA = (results.brandCodes[0] === 'WOOL' || results.brandCodes[0] === "REIN");
		var isWoolOrRealB = (results.brandCodes[1] === 'WOOL' || results.brandCodes[1] === "REIN");
		var sameBrand = (results.brandCodes[0] === results.brandCodes[1]);
		if (isWoolOrRealA && isWoolOrRealB && !sameBrand) {
			if (results.values[0] === results.values[1]) {
				return results.brandCodes[0] === 'WOOL' ? -1 : 1;
			}
		}
	}

	function landlordFilter(results) {
		var filters = meerkat.site.landlordFilters;
		if (filters && !filters.showall) {
			for (var key in filters) {
				if (filters[key] === true) {
					if (!results.a.features[key] || (results.a.features && results.a.features[key].value !== "Y")) {
						results.a.available = "N";
					}
					if (!results.b.features[key] || (results.a.features && results.b.features[key].value !== "Y")) {
						results.b.available = "N";
					}
				}
			}
		}
	}

	function eventSubscriptions() {
		meerkat.messaging.subscribe(meerkatEvents.commencementDate.RESULTS_RENDER_COMPLETED, function landlordSortFilter() {
			if (meerkat.site.isLandlord) {
					meerkat.modules.homeFilters.setLandlordFilters();
			}
		});
		meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
			Results.model.landlordFilter = landlordFilter;
			Results.model.homeCustomSort = sortRealAndWool;
		});

		// Capture offer terms link clicks
		$(document.body).on('click', 'a.offerTerms', launchOfferTerms);
		$(document.body).on('click', 'a.priceDisclaimer', showPriceDisclaimer);

		// TODO
		// When the navar docks/undocks
		meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
			var margin = (meerkat.modules.deviceMediaState.get() === 'lg') ? '-60px' : '-80px';
			$('#resultsPage').css('margin-top', margin);
			$('.productSummary .headerButtonWrapper').css('visibility', 'hidden');
			$(Results.settings.elements.resultsContainer).addClass('affixed-settings');
		});
		meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
			$('#resultsPage').css('margin-top', '0');
			$('.productSummary .headerButtonWrapper').css('visibility', 'visible');
			$(Results.settings.elements.resultsContainer).removeClass('affixed-settings');
		});

		// When the excess filter changes, fetch new results
		meerkat.messaging.subscribe(meerkatEvents.homeFilters.CHANGED, function onFilterChange(obj){
			if (obj && (obj.homeExcess || obj.contentsExcess)) {
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
			meerkat.modules.journeyEngine.loadingShow('getting your quotes', null, 'Quotes are indicative and subject to change based on further questions by the insurer.');
			$('#resultsPage, .loadingDisclaimerText').removeClass('hidden');
			// Hide pagination
			Results.pagination.hide();
		});

		// Fetching done
		$(document).on("resultsFetchFinish", function onResultsFetchFinish() {
			meerkat.modules.homeFilters.setHomeResultsFilter();
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
			// Check products length in case the reason for no results is an error e.g. 500
			if (Results.model.availableCounts === 0 && _.isArray(Results.model.returnedProducts) && Results.model.returnedProducts.length > 0) {
				showNoResults();
				toggleNoResultsFeaturesMode();
			}

            $.each(Results.model.returnedProducts, function(){
            	if (this.available === 'N') {
                    // Track each Product that doesn't quote
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: 'trackQuoteNotProvided',
                        object: {
                            productID: this.productId
                        }
                    });
				}
            });

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

		$(document.body).on('click', '#results_v5 .btnContainer .btn-call-actions', function triggerMoreInfoCallActions(event) {
			var element = $(this);
			meerkat.messaging.publish(meerkatEvents.homeResults.FEATURES_CALL_ACTION, {event: event, element: element});
		});

		$(document.body).on('click', '#results_v5 .call-modal .btn-call-actions', function triggerMoreInfoCallActionsFromModal(event) {
			var element = $(this);
			meerkat.messaging.publish(meerkatEvents.homeResults.FEATURES_CALL_ACTION_MODAL, {event: event, element: element});
		});

		$(document.body).on('click', '#results_v5 .btn-submit-callback', function triggerMoreInfoSubmitCallback(event) {
			var element = $(this);
			meerkat.messaging.publish(meerkatEvents.homeResults.FEATURES_SUBMIT_CALLBACK, {event: event, element: element});
		});

		meerkat.messaging.subscribe(meerkatEvents.resultsMobileDisplayModeToggle.DISPLAY_MODE_CHANGED, function onDisplayModeChanged(obj) {
			if (obj.displayMode === 'price') {
				switchToPriceMode(true);
			} else {
				switchToFeaturesMode(true);
			}
		});
	}

	// After the results have been fetched, force data onto it to support our Results engine.
	function massageResultsObject(products) {
		products = products || Results.model.returnedProducts;
		_.each(products, function massageJson(result, index) {
			// Add properties
			if (!_.isNull(result.price) && !_.isUndefined(result.price)) {

				// Annually
				if (!_.isUndefined(result.price.annualPremium)) {
					result.price.annualPremiumFormatted = meerkat.modules.currencyField.formatCurrency(Math.ceil(result.price.annualPremium), {roundToDecimalPlace: 0, symbol: '', digitGroupSymbol:''});
				}

				//Monthly
				if (!_.isUndefined(result.price.monthlyPremium)) {
					if (!_.isUndefined(result.price.monthlyPremium)) {
						result.price.monthlyPremiumFormatted = meerkat.modules.currencyField.formatCurrency(result.price.monthlyPremium, {roundToDecimalPlace: 2, symbol: ''});
					}
					if (!_.isUndefined(result.price.monthlyFirstMonth)) {
						result.price.monthlyFirstMonthFormatted = meerkat.modules.currencyField.formatCurrency(result.price.monthlyFirstMonth, {roundToDecimalPlace: 2, symbol: ''});
					}
					if (!_.isUndefined(result.price.annualisedMonthlyPremium)) {
						result.price.annualisedMonthlyPremiumFormatted = meerkat.modules.currencyField.formatCurrency(result.price.annualisedMonthlyPremium, {roundToDecimalPlace: 2, symbol: ''});
					}
				}
			}

			if (!_.isNull(result.homeExcess) && !_.isUndefined(result.homeExcess)) {
				if (!_.isUndefined(result.homeExcess.amount)) {
					result.homeExcess.amountFormatted = meerkat.modules.currencyField.formatCurrency(result.homeExcess.amount, {roundToDecimalPlace: 0});
				}
			}

			if (!_.isNull(result.contentsExcess) && !_.isUndefined(result.contentsExcess)) {
				if (!_.isUndefined(result.contentsExcess.amount)) {
					result.contentsExcess.amountFormatted = meerkat.modules.currencyField.formatCurrency(result.contentsExcess.amount, {roundToDecimalPlace: 0});
				}
			}
		});
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

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_SM, function resultsSmBreakpointEnter(){
			if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results') {
				Results.pagination.setCurrentPageNumber(1);
				Results.pagination.resync();
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_SM, function resultsSmBreakpointLeave(){
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
		Results.updateAggregatorEnvironment();
		// Fetch results
		meerkat.modules.resultsFeatures.fetchStructure('hncamsws_').done(function() {
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
		affixFix();
	}
	
	function toggleNoResultsFeaturesMode() {
	if (Results.model.availableCounts === 0) {
		$("#results_v5.featuresMode " + Results.settings.elements.features.allElements).hide();
		$("#results_v5.featuresMode").removeClass('featuresMode').find('.results-table').removeAttr('style');
	} else {
		// revert everything
		$(Results.settings.elements.features.container + " " + Results.settings.elements.features.allElements).show();
		if (!$(Results.settings.elements.features.container).hasClass('featuresMode')) {
			$(Results.settings.elements.features.container).addClass('featuresMode');
		}
	}
}

	function showNoResults() {
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

	function showPriceDisclaimer(event) {
		meerkat.modules.homeMoreInfo.setScrollPosition();
		event.preventDefault();

		var $element = $(event.target);
		var $termsContent = $element.next('.priceDisclaimer-content');

		var $logo =				$element.closest('.resultInsert, .more-info-content, .call-modal').find('.companyLogo');
		var $productName =		$element.closest('.resultInsert, .more-info-content, .call-modal').find('.productTitle, .productName');

		meerkat.modules.dialogs.show({
			title: $logo.clone().wrap('<p>').addClass('hidden-xs').parent().html() + "<div class='hidden-xs heading'>" + $productName.html() + "</div>" + "<div class='heading'>Price Disclaimer</div>",
			hashId: 'price-disclaimer',
			className: 'price-disclaimer-modal',
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
				if (meerkat.modules.deviceMediaState.get() === 'sm') {
					stopColumnWidthTracking();
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
			toggleNoResultsFeaturesMode();
		}
	}

	function initCompare(){
		meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);

		// Elements to lock when entering compare mode
		meerkat.messaging.subscribe(meerkatEvents.compare.AFTER_ENTER_COMPARE_MODE, function() {

			$('.filter-excess, .filter-excess a, .excess-update, .excess-update a').addClass('disabled');
			$('.filter-featuresmode, .filter-pricemode, .filter-view-label').addClass('hidden');
			$('.filter-frequency-label').css('margin-right', $('.back-to-price-mode').width());
		});
		// Elements to lock when exiting compare mode
		meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, function() {
			$('.filter-excess, .filter-excess a, .excess-update, .excess-update a').removeClass('disabled');
			$('.filter-featuresmode, .filter-pricemode, .filter-view-label').removeClass('hidden');
			$('.filter-frequency-label').removeAttr('style');
		});

	}

	meerkat.modules.register('homeResults', {
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
