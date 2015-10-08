;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		supertagEventMode = 'Load';

	var events = {
		// Defined here because it's published in Results.js
		RESULTS_ERROR: 'RESULTS_ERROR',

		RESULTS_REMAINING_PRODUCTS: 'HOMELOAN_RESULTS_REMAINING_PRODUCTS'
	};

	var $component; //Stores the jQuery object for the component group
	var previousBreakpoint;
	var best_price_count = 5;
	var needToBuildFeatures = false;

	function initPage(){

		initResults();

		Features.init();
		meerkat.modules.compare.initCompare({
			callbacks: {
				switchMode: function(mode) {
					switch(mode) {
						case 'features':
							switchToFeaturesMode(true);
						break;
						case 'price':
							switchToPriceMode(true);
						break;
					}
				}
			}
		});
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
			// Init the main Results object
			Results.init({
				//url: "homeloan/results/get.json", //This is the ideal URL - done via java router - however it's not really complete yet (no touches, quote write, etc).
				url: "ajax/json/homeloan_results.jsp",
				runShowResultsPage: false, // Don't let Results.view do it's normal thing.
				paths: {
					results: {
						rootElement: "responseData",
						list: "responseData.searchResults",
						general: "responseData.totalCount"
					},
					price: {
						monthly: "monthlyRepayments"
					},
					rate: "intrRate",
					availability: {
						product: "productAvailable",
						price: {
							monthly: "monthly"
						}
					},
					productId: "id",
					productBrandCode: "brandCode",
					productName: "lenderProductName"
				},
				show: {
					topResult: false,
					savings: false,
					featuresCategories: false,
					nonAvailableProducts: false,  // This will apply the availability.product rule
					unavailableCombined: true     // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
				},
				availability: {
					product: ['equals', 'Y'],
					price: ['equals', true]
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
					sortBy: false
				},
				frequency: "monthly",
				animation: {
					results: {
						individual: {
							active: false
						},
						delay: 500,
						options: {
							easing: "swing", // animation easing type
							duration: 0
						}
					},
					shuffle: {
						active: false,
						options: {
							easing: "swing", // animation easing type
							duration: 0
						}
					},
					filter: {
						active: false,
						reposition: {
							options: {
								duration: 0,
								easing: "swing" // animation easing type
							}
						},
						appear: {
							options: {
								duration: 0
							}
						},
						disappear: {
							options: {
								duration: 0
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
							key: 'Y',
							value: "<span class='icon icon-tick'></span>"
						},
						{
							key: 'N',
							value: "<span class='icon icon-cross'></span>"
						}
					]
				},
				rankings: {
					paths: {
						rank_productId: "id",
						rank_premium: "monthlyRepayments"
					},
					filterUnavailableProducts: false
				},
				incrementTransactionId: false
			});

		}
		catch(e) {
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.homeloanResults.initResults(); '+e.message, e);
		}
	}

	function eventSubscriptions() {

		// Capture enquiry link clicks
		$(document.body).on('click', '.btn-enquire-now', enquireNowClick);

		// Handle result row click
		$(Results.settings.elements.resultsContainer).on('click', '.result-row', resultRowClick);

		// When the navar docks/undocks
		meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
			$('#resultsPage').css('margin-top', '37px');
		});
		meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
			$('#resultsPage').css('margin-top', '0');
		});

		// When the filters change
		meerkat.messaging.subscribe(meerkatEvents.homeloanFilters.CHANGED, function onFilterChange(obj) {
			Results.settings.incrementTransactionId = true;
			meerkat.modules.session.poke();
		});

		// If error occurs, go back in the journey
		meerkat.messaging.subscribe(events.RESULTS_ERROR, function resultsError() {
			// Delayed to allow journey engine to unlock
			_.delay(function() {
				meerkat.modules.journeyEngine.gotoPath('previous');
			}, 1000);
		});

		// Model updated, make changes before rendering
		meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
			Results.model.returnedProducts = massageResultsObject(Results.model.returnedProducts);

			// Populating sorted products is a trick for HML due to setting sortBy:false
			Results.model.sortedProducts = Results.model.returnedProducts;
		});

		$(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function(){
			Features.buildHtml();
		});

		// Run the show method even when there are no available products
		// This will render the unavailable combined template
		$(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
			Results.view.show();
		});

		// No results
		$(Results.settings.elements.resultsContainer).on("noResults", function onResultsNone() {
			showNoResults();
		});

		$(document).on("resultsLoaded", onResultsLoaded);

		// Scroll to the top when results come back
		$(document).on("resultsReturned", function() {
			meerkat.modules.utils.scrollPageTo($("header"));
			$('.morePromptContainer, .comparison-rate-disclaimer').removeClass('hidden');
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
	}

	// After the results have been fetched, force data onto it to support our Results engine.
	function massageResultsObject(products) {

		if (_.isArray(products) && products.length > 0 && _.isArray(products[0])) {
			products = [{
				productAvailable: 'N'
			}];
		}
		else {
			_.each(products, function massageJson(result, index) {

				_.each(result, function changeProperties(value, key, list) {
					// Remap true/false to Y/N
					if (value === true) {
						result[key] = 'Y';
					}
					else if (value === false) {
						result[key] = 'N';
					}
				});

				// Add properties
				result.productAvailable = 'Y';

				// Required for core supertag calls.
				result.brandCode = result.lender;
				result.productId = result.id;

				result.formatted = {
					intrRate:		Number(result.intrRate).toFixed(2) + '%',
					comparRate:		Number(result.comparRate).toFixed(2) + '%',
					appFees:		meerkat.modules.currencyField.formatCurrency(result.appFees).replace('$0.00', '$0'),
					settlFees:		meerkat.modules.currencyField.formatCurrency(result.settlFees).replace('$0.00', '$0'),
					ongoingFees:	meerkat.modules.currencyField.formatCurrency(result.ongoingFees).replace('$0.00', '$0'),
					repayments:	{
						monthly:		meerkat.modules.currencyField.formatCurrency(result.monthlyRepayments, {roundToDecimalPlace: 0}),
						fortnightly:	meerkat.modules.currencyField.formatCurrency(result.fortnightlyRepayments).replace('.00', ''),
						weekly:			meerkat.modules.currencyField.formatCurrency(result.weeklyRepayments).replace('.00', '')
					}
				};

				result.formatted.repayments.monthlyFull = result.formatted.repayments.monthly + ' monthly';
				result.formatted.repayments.fortnightlyFull = result.formatted.repayments.fortnightly + ' fortnightly';
				result.formatted.repayments.weeklyFull = result.formatted.repayments.weekly + ' weekly';

				if (result.ongoingFees > 0) {
					result.formatted.ongoingFees = result.formatted.ongoingFees + ' ' + result.ongoingFeesCycle;
				}
			});
		}

		return products;
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
		// Reset page number
		$('#homeloan_results_pageNumber').val('1');
		meerkat.modules.resultsFeatures.fetchStructure('hmlams').done(function() {
			Results.get();
		});
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

	/**
	 * This function has been refactored into calling a core resultsTracking module.
	 * It has remained here so verticals can run their own unique calls.
	 */
	function publishExtraSuperTagEvents() {
		meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
			additionalData: {
				loadMoreResultsPageNumber: "1"
			},
			onAfterEventMode: 'Load'
		});
	}

	function launchOfferTerms(event) {
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
				publishExtraSuperTagEvents();
			}
		}
	}

	function enquireNowClick(event) {

		event.preventDefault();

		var $enquireNow = $(event.target).closest("a[data-productId]");
		if($enquireNow.attr("data-productId")) {
			Results.setSelectedProduct($enquireNow.attr("data-productId"));
		}

		meerkat.modules.homeloan.trackHandover();

		meerkat.modules.journeyEngine.gotoPath('next', $enquireNow);
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
		Results.model.setSelectedProduct($resultrow.attr('data-productId'));
		meerkat.modules.homeloanMoreInfo.runDisplayMethod();
	}

	function init(){

		$component = $('#resultsPage');

		meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
		// Elements to lock when entering compare mode
		meerkat.messaging.subscribe(meerkatEvents.compare.AFTER_ENTER_COMPARE_MODE, function() {

			$('.slide-feature-filters, .slide-feature-filters a').addClass('inactive disabled');
		});
		// Elements to lock when exiting compare mode
		meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, function() {
			$('.slide-feature-filters, .slide-feature-filters a').removeClass('inactive disabled');
		});
	}

	meerkat.modules.register('homeloanResults', {
		init: init,
		initPage: initPage,
		events: events,
		onReturnToPage: onReturnToPage,
		get: get,
		stopColumnWidthTracking: stopColumnWidthTracking,
		recordPreviousBreakpoint: recordPreviousBreakpoint,
		switchToPriceMode: switchToPriceMode,
		switchToFeaturesMode: switchToFeaturesMode,
		showNoResults: showNoResults,
		publishExtraSuperTagEvents: publishExtraSuperTagEvents,
		massageResultsObject: massageResultsObject
	});

})(jQuery);
