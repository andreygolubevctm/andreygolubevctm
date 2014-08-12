;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		supertagEventMode = 'Load';

	var supertagResultsEventMode = 'Load';

	var $component; //Stores the jQuery object for the component group
	var previousBreakpoint;
	var best_price_count = 1;
	var needToBuildFeatures = false;

	function initPage(){

		initResults();

		//Features.init();
		Compare.init();

		eventSubscriptions();

//		breakpointTracking();

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

			// Init the main Results object
			Results.init({
				url: "ajax/json/travel_quote_results.jsp",
				//url: 'zzz_travel_results.json',
				runShowResultsPage: false, // Don't let Results.view do it's normal thing.
				paths: {
					results: {
						list: "results.price"
					},
					productId: "productId",
					price: {
						premium: "price"
					},
					benefits: {
						cxdfee: "info.cxdfee.value",
						excess: "info.excess.value",
						medical: "info.medical.value",
						luggage: "info.luggage.value"
					},
					availability: {
						product: "available"
					}
				},
				show: {
					//nonAvailablePrices: true,     // This will apply the availability.price rule
					nonAvailableProducts: false, // This will apply the availability.product rule
					unavailableCombined: true    // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
				},
				availability: {
					product: ["equals", "Y"]
				},
				render: {
					templateEngine: '_',
					/*features: {
						mode: 'populate',
						headers: false,
						numberOfXSColumns: 1
					},*/
					dockCompareBar: false
				},
				displayMode: 'price', // features, price
				paginationTouchEnabled: false,
				sort: { // check in health
					sortBy: 'price.premium',
					sortDir: 'asc'
				},
				frequency: "premium",	
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
				rankings: {
					triggers : ['RESULTS_DATA_READY'],					
					callback : meerkat.modules.travelResults.rankingCallback,
					forceIdNumeric : false
				}
			});
		}
		catch(e) {
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.travelResults.init(); '+e.message, e);
		}
	}

	function eventSubscriptions() { // might not need all/any

		// When the navar docks/undocks
		meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
			$component.css('margin-top', '8px');
		});
		meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
			$component.css('margin-top', '0');
		});

		// Run the show method even when there are no available products
		// This will render the unavailable combined template
		$(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
			Results.view.show();
		});

		//$(document).on("resultsLoaded", onResultsLoaded);

		// Scroll to the top when results come back
		$(document).on("resultsReturned", function(){
			meerkat.modules.utilities.scrollPageTo($("header"));

			// Reset the feature header to match the new column content.
			$(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");

		});

		// Start fetching results
		$(document).on("resultsFetchStart", function onResultsFetchStart() {
			meerkat.modules.journeyEngine.loadingShow('...getting your quotes...');
			$component.removeClass('hidden');

			// Hide pagination
			Results.pagination.hide();
		});

		// Fetching done
		$(document).on("resultsFetchFinish", function onResultsFetchFinish() {

			// Results are hidden in the CSS so we don't see the scaffolding after #benefits
			$(Results.settings.elements.page).show();

			meerkat.modules.journeyEngine.loadingHide();

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

		// Handle result row click
		$(Results.settings.elements.resultsContainer).on('click', '.result-row', resultRowClick);
	}

	function rankingCallback(product, position) {
		var data = {};
		
		// If the is the first time sorting, send the prm as well
		data["rank_premium" + position] = product.price;
		data["rank_productId" + position] = product.productId;

		if( _.isNumber(best_price_count) && position < best_price_count ) {
			data["best_price" + position] = 1;
			data["best_price_productName" + position] = product.name;
			data["best_price_excess" + position] = product.info.excess.text;
			data["best_price_medical" + position] = product.info.medical.text;
			data["best_price_cxdfee" + position] = product.info.cxdfee.text;
			data["best_price_luggage" + position] = product.info.luggage.text;
			data["best_price_price" + position] = product.priceText;
			data["best_price_url" + position] = product.quoteUrl;
		}

		return data;
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
		meerkat.modules.travelMoreInfo.runDisplayMethod();
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

	// Wrapper around results component, load results data
	function get() {
		Results.get();
	}

	function onResultsLoaded() {
		startColumnWidthTracking();

		// Reset vars
		if (Results.getDisplayMode() !== 'features')
			needToBuildFeatures = true;
	}

	function showNoResults() {
		meerkat.modules.dialogs.show({
			htmlContent: $('#no-results-content')[0].outerHTML
		});
	}

	function publishExtraSuperTagEvents() {
		var data = {
				vertical: meerkat.site.vertical,
				actionStep: meerkat.site.vertical + ' results',
				event: supertagResultsEventMode
		};

		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteList',
			object:	data
		});

		supertagResultsEventMode = 'Refresh'; // update for next call.*/
	}

	function init(){
		$component = $("#resultsPage");

		meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
	}

	meerkat.modules.register('travelResults', {
		init: init,
		initPage: initPage,
//		onReturnToPage: onReturnToPage,
		get: get,
//		stopColumnWidthTracking: stopColumnWidthTracking,
		showNoResults: showNoResults,
		rankingCallback: rankingCallback
	});

})(jQuery);
