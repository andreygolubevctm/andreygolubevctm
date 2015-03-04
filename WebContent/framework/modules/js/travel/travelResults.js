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

		initResults();

		//Features.init();

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
					productName: "name",
					productBrandCode: "provider",
					coverLevel: "info.coverLevel",
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
				pagination: {
					touchEnabled: false
				},
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
					forceIdNumeric : false,
					filterUnavailableProducts : true
				}
			});
		}
		catch(e) {
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.travelResults.initResults(); '+e.message, e);
		}
	}
	/**
	 * Pre-filter the results object to add another parameter. This will be unnecessary when the field comes back from Java.
	 */
	function massageResultsObject(products) {
		if(meerkat.modules.coverLevelTabs.isEnabled() !== true) {
			return products;
		}

		var policyType = meerkat.modules.travel.getVerticalFilter();
		_.each(products, function massageJson(result, index) {
			if(typeof result.info !== 'object') {
				return;
			}

			var obj = result.info;
			if(policyType == 'Single Trip') {

				/**
				 * Currently ignore medical if destination country is JUST AU.
				 */
				var medical = 5000000,
				countryList = meerkat.modules.travelCountrySelection.getCountryList();
				countryList = typeof countryList.toString === 'function' ? countryList.toString() : countryList[0];
				if(countryList == "pa:au") {
					medical = 0;
				}

				if(obj.excess.value <= 250 && obj.medical.value >= medical
						&& obj.cxdfee.value >= 7500 && obj.luggage.value >= 7500) {
					obj.coverLevel = 'C';
					meerkat.modules.coverLevelTabs.incrementCount("C");
				} else if (obj.excess.value <= 250 && obj.medical.value >= medical
						&& obj.cxdfee.value >= 2500
						&& obj.luggage.value >= 2500) {
					obj.coverLevel = 'M';
					meerkat.modules.coverLevelTabs.incrementCount("M");
				} else {
					obj.coverLevel = 'B';
					meerkat.modules.coverLevelTabs.incrementCount("B");
				}
			} else {
				if(result.des.indexOf('Australia') == -1) {
					obj.coverLevel = 'I';
					meerkat.modules.coverLevelTabs.incrementCount("I");
				} else {
					obj.coverLevel = 'D';
					meerkat.modules.coverLevelTabs.incrementCount("D");
				}
			}
		});
		return products;
	}

	function eventSubscriptions() { // might not need all/any

		// Model updated, make changes before rendering
		meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
			Results.model.returnedProducts = massageResultsObject(Results.model.returnedProducts);

			// Populating sorted products is a trick for HML due to setting sortBy:false
			Results.model.sortedProducts = Results.model.returnedProducts;
		});

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

		// If error occurs, go back in the journey
		meerkat.messaging.subscribe(events.RESULTS_ERROR, function resultsError() {
			// Delayed to allow journey engine to unlock
			_.delay(function() {
				meerkat.modules.journeyEngine.gotoPath('previous');
			}, 1000);
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

			if (availableCounts === 0 && !Results.model.hasValidationErrors) {
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

		if (typeof product.info.coverLevel !== 'undefined')
		{
			data["coverLevelType" + position] = product.info.coverLevel;
		} 

		if( _.isNumber(best_price_count) && position < best_price_count) {
			data["best_price" + position] = 1;
			data["best_price_providerName" + position] = product.provider;
			data["best_price_productName" + position] = product.name;
			data["best_price_excess" + position] = typeof product.info.excess !== 'undefined' ? product.info.excess.text : 0;
			data["best_price_medical" + position] = typeof product.info.medical !== 'undefined' ? product.info.medical.text : 0;
			data["best_price_cxdfee" + position] = typeof product.info.cxdfee !== 'undefined' ? product.info.cxdfee.text : 0;
			data["best_price_luggage" + position] = typeof product.info.luggage !== 'undefined' ? product.info.luggage.text : 0;
			data["best_price_price" + position] = product.priceText;
			data["best_price_service" + position] = product.service;
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

	/**
	 * This function has been refactored into calling a core resultsTracking module.
	 * It has remained here so verticals can run their own unique calls.
	 */
	function publishExtraSuperTagEvents(additionalData) {
		additionalData = typeof additionalData === 'undefined' ? {} : additionalData;
		meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
			additionalData: $.extend({
				sortBy: Results.getSortBy() +'-'+ Results.getSortDir()
			}, additionalData),
			onAfterEventMode: 'Refresh'
		});
	}

	function init(){
		$(document).ready(function() {
			$component = $("#resultsPage");
			var currentJourney = meerkat.modules.tracking.getCurrentJourney();
			if(currentJourney != 2 && currentJourney != 3 && currentJourney != 4) {
				meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
			}
		});
	}

	meerkat.modules.register('travelResults', {
		init: init,
		initPage: initPage,
		get: get,
		showNoResults: showNoResults,
		rankingCallback: rankingCallback,
		publishExtraSuperTagEvents: publishExtraSuperTagEvents
	});

})(jQuery);
