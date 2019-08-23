;(function($){

	var meerkat = window.meerkat,
			meerkatEvents = meerkat.modules.events;

	var events = {
			// Defined here because it's published in Results.js
			RESULTS_ERROR: 'RESULTS_ERROR'
	};
	var $component, //Stores the jQuery object for the component group
			best_price_count = 10, price_log_count = 10,
			initialised = false;

	function initPage(){
		if(!initialised) {
			initialised = true;
			initResults();
			eventSubscriptions();
		}
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
						list: "results.result",
						providerCode: "serviceName"
					},
					productId: "productId",
					productName: "name",
					productBrandCode: "provider",
					coverLevel: "info.coverLevel",
					price: {
						premium: "price"
					},
					benefits: {
						cxdfee: "info.cxdfeeValue",
						excess: "info.excessValue",
						medical: "info.medicalValue",
						luggage: "info.luggageValue",
						rentalVehicle: "info.rentalVehicleValue"
					},
					availability: {
						product: "available"
					}
				},
				show: {
					nonAvailableProducts: false, // This will apply the availability.product rule
					unavailableCombined: true    // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
				},
				availability: {
					product: ["equals", "Y"]
				},
				render: {
					templateEngine: '_',
					dockCompareBar: false
				},
				displayMode: 'price', // features, price
				pagination: {
					touchEnabled: false
				},
				sort: { // check in health
					sortBy: 'price.premium',
					sortDir: 'asc',
					randomizeMatchingPremiums: true
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
	 
	 function getDestinationsValue(isAus, isComprehensive) {
		 if (isAus) {
			 return 0;
		 } else if (isComprehensive) {
			 return 20000000;
		 }
		 return 10000000;
	 }

	 function getCoverLevel(tripInfo, isAus) {
		 var excessValue = tripInfo.excessValue <= Results.model.travelFilters.EXCESS;
		 var medicalValue = tripInfo.medicalValue;
		 var cxdfeeValue = tripInfo.cxdfeeValue;
		 var luggageValue = tripInfo.luggageValue;
		
		 var compCancelValue = isAus ? 10000 : 20000;
		 var isComprehensive = excessValue && cxdfeeValue >= compCancelValue && luggageValue >= 5000;
		 var isMidRange = excessValue && cxdfeeValue >= 5000 && luggageValue >= 2500;
		 var isBase = cxdfeeValue < 5000 || luggageValue < 2500;
		 var destinationsValue = getDestinationsValue(isAus, isComprehensive);
		 var level;

		 if (isComprehensive && medicalValue >= destinationsValue) {
			 level = 'C';
			 meerkat.modules.coverLevelTabs.incrementCount(level);
			 return level;
		 } else if (isMidRange && medicalValue >= destinationsValue) {
			 level = 'M';
			 meerkat.modules.coverLevelTabs.incrementCount(level);
			 return level;
		 } else if (isBase || (medicalValue < destinationsValue))  {
			 level = 'B';
			 if (excessValue) {
					meerkat.modules.coverLevelTabs.incrementCount(level);
			 }
			 return level;
		 }
	 }
	 
	 function getCoverLevelForMultiTrip(tripInfo, result) {
		 var level;

		 if (_.isBoolean(result.isDomestic) ) {
			 level = result.isDomestic === true ? 'D' : getCoverLevel(tripInfo, false) + 'I';
			 meerkat.modules.coverLevelTabs.incrementCount(level);
			 return level;
		 }

     if (result.des.indexOf('Australia') == -1 && result.des.indexOf('Domestic') == -1) {
			 	 level = getCoverLevel(tripInfo, false) + 'I';
         meerkat.modules.coverLevelTabs.incrementCount(level);
         return level;
     }

     level = 'D';
     meerkat.modules.coverLevelTabs.incrementCount(level);
     return level;
	 }
	 
	/**
	* Pre-filter the results object to add another parameter. This will be unnecessary when the field comes back from Java.
	*/
	function massageResultsObject(products) {
		var policyType = meerkat.modules.travel.getVerticalFilter();
		var isAus = $('#travel_destination').val() === 'AUS';
		var isCoverLevelTabsEnabled = meerkat.modules.coverLevelTabs.isEnabled();
		var isCruise = meerkat.modules.tripType.get().cruise.active;

		_.each(products, function massageJson(result, index) {
			if (result.available == 'Y') {

				if (typeof result.info !== 'object') {
					return;
				}
				var obj = result.info;
				// Add provider property (for tracking purposes)
				if (_.isUndefined(result.provider) || _.isEmpty(result.provider)) {
					result.provider = result.service;
				}
				// TRV-667: replace any non digit words with $0 e.g. Optional Extra
				if (typeof obj.luggage !== 'undefined' && obj.luggageValue <= 0) {
					obj.luggage = "$0";
				}
				// TRV-769 Set value and text to $0 for quotes for JUST Australia.
				// added the policyType check because it was causing a bug
				// the bus is caused by the user selecting Aus for single trip then selecting AMT
				// BTW not a huge fan of this, the backend should of probably handled setting the medicalValue to 0
				//CTM-204 added the test for non cruise trip Types
				// ie do not override medicalValues when cruise trip type is selected
				 if (isAus && policyType == 'Single Trip' && !isCruise) {
				 	obj.medicalValue = 0;
				 	obj.medical = "N/A";
				 }
				if (isCoverLevelTabsEnabled === true) {
					if (policyType == 'Single Trip') {
						obj.coverLevel = getCoverLevel(obj, isAus);
					} else {
						obj.coverLevel = getCoverLevelForMultiTrip(obj, result);
					}
				}
			}
		});
		return products;
	}

	function eventSubscriptions() { // might not need all/any

		$(document.body).on('click', 'a.offerTerms', launchOfferTerms);

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
			setColVisibilityAndStylesByTravelType(isDomestic());
		});

		// If error occurs, go back in the journey
		meerkat.messaging.subscribe(events.RESULTS_ERROR, function resultsError() {
			// Delayed to allow journey engine to unlock
			_.delay(function() {
				meerkat.modules.journeyEngine.gotoPath('previous');
			}, 1000);
		});

		// update disclaimer and heading text as required if multi trip
		$('input[type=radio][name=amt-toggle]').change(function() {
			if (meerkat.modules.travel.getVerticalFilter() === 'Multi Trip') {
				denoteDisclaimer(this.value === 'D');
			}
		});

		$('.travel-disclaimer-banner-dismiss').click(function() {
			$(".travel-disclaimer-banner").hide();
		});

		// Scroll to the top when results come back
		$(document).on("resultsReturned", function(){
			meerkat.modules.utils.scrollPageTo($("header"));

			// Reset the feature header to match the new column content.
			$(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");

			// update disclaimer and heading text as required
			var domestic = isDomestic();

			denoteDisclaimer(domestic);
		});

		// Start fetching results
		$(document).on("resultsFetchStart", function onResultsFetchStart() {
			$(".travelResultsDisclaimerHeader").hide();
			meerkat.modules.journeyEngine.loadingShow('...getting your quotes...');
			$component.removeClass('hidden');
			meerkat.modules.travelResultFilters.updateFilterForDestination();

			// Hide pagination
			Results.pagination.hide();
		});

		// Fetching done
		$(document).on("resultsFetchFinish", function onResultsFetchFinish() {

			// Results are hidden in the CSS so we don't see the scaffolding after #benefits
			$(Results.settings.elements.page).show();

			meerkat.modules.journeyEngine.loadingHide();
			$(".travelResultsDisclaimerHeader").show();

			if (Results.getDisplayMode() !== 'price') {
				// Show pagination
				Results.pagination.show();
			}
			else {
				$(document.body).removeClass('priceMode').addClass('priceMode');
			}

			var currentProduct,
					previousProduct;
			$.each(Results.model.sortedProducts, function massageSortedProducts(index, result){
				// alternate any pricing results if two or more results have the exact same price
				previousProduct = currentProduct;
				currentProduct = result;
				if ((typeof previousProduct !== 'undefined' && typeof currentProduct !== 'undefined')  && (previousProduct.available == 'Y' && currentProduct.available == 'Y')
					&& (previousProduct.service != currentProduct.service) && (previousProduct.price == currentProduct.price) && (meerkat.modules.transactionId.get() % 2 === 0)
				) {
					// swap the products around
					result[index] = previousProduct;
					result[index - 1] = currentProduct;
				}
			});

			// resort again
			Results.model.sort(true);

			// If no providers opted to show results, display the no results modal.
			var availableCounts = 0;
			$.each(Results.model.returnedProducts, function(){
				if (this.available === 'Y' && this.productId !== 'CURR') {
					availableCounts++;
				}
				else if (this.available === 'N') {
					// Track each Product that doesn't quote
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: 'trackQuoteNotProvided',
                        object: {
                            productID: this.productId
                        }
                    });
				}
			});

			if (availableCounts === 0 && !Results.model.hasValidationErrors ) {
				if (Results.model.isBlockedQuote) {
					// show the custom popup
					showBlockedResults();
				} else {
					var fromDateElement = document.getElementById('travel_dates_fromDate');
					var fromDates = fromDateElement.value.split('/');
					
					if(fromDates && fromDates.length === 3) {
						var fromDate = new Date(fromDates[1] + '/' + fromDates[0] + '/' + fromDates[2]);
						var todayDate = meerkat.site.serverDate;
						if (fromDate < todayDate) {
							// quote is old that's why there's no results
							invalidQuoteDueToDate();
						} else {
							showNoResults();
						}
					}else{
						showNoResults();
					}
				}
			} else {
				meerkat.modules.salesTracking.addPHGImpressionTracking();
			}

			//set visibility of os medical and rental vehicle columns
			var domestic = isDomestic();

			setColVisibilityAndStylesByTravelType(domestic);
		});

		// Handle result row click
		$(Results.settings.elements.resultsContainer).on('click', '.result-row', resultRowClick);
	}

	function isDomestic() {
		
		if (meerkat.modules.travel.getVerticalFilter() === 'Single Trip') {
			return $('#travel_destination').val() === 'AUS';
		}

		return $('#travel_filter_domestic:checked').val() === "D";
	}

	function denoteDisclaimer(isDomestic) {
		var disclaimerText = "", oSMedical2ColText = "", cancelFeeColText = "", luggageColText = "";

		if (isDomestic ) {
			disclaimerText = "Before choosing a Policy, please note that for cancellation fee cover* and luggage** there are some exclusions and sub-limits that apply for each Policy. Always read the Product Disclosure Statement (PDS) before purchasing.";
			oSMedical2ColText = "Expenses";
			cancelFeeColText = "Cancellation Fee&nbsp;Cover*";
			luggageColText = "Luggage**";
		} else {
			disclaimerText = "Before choosing a Policy, please note that for overseas medical expenses*, cancellation fee cover** and luggage*** there are some exclusions and sub-limits that apply for each Policy.  Always read the Product Disclosure Statement (PDS) before purchasing.";
			oSMedical2ColText = "Expenses*";
			cancelFeeColText = "Cancellation Fee&nbsp;Cover**";
			luggageColText = "Luggage***";
		}
		$(".travelResultsDisclaimerHeader").html(disclaimerText);
		$(".oSMedical2ColText").html(oSMedical2ColText);
		$(".cancelFeeColText").html(cancelFeeColText);
		$(".luggageColText").html(luggageColText);

		setColVisibilityAndStylesByTravelType(isDomestic);
	}

	function setColVisibilityAndStylesByTravelType(isDomestic) {
		var destination = $('#travel_destination').val();

		//set visibility of os medical and rental vehicle columns
		$(".medicalTitle").toggle(!isDomestic && destination !== 'AUS');
		$(".medicalAmount").toggle(!isDomestic && destination !== 'AUS');
		$(".os-medical-col").toggle(!isDomestic && destination !== 'AUS');
		$(".rentalVehicleTitle").toggle(isDomestic || destination === 'AUS');
		$(".rentalVehicle").toggle(isDomestic || destination === 'AUS');
		$(".rental-vehicle-col").toggle(isDomestic || destination === 'AUS');

		// alter background colour for every second column
		$(".luggageAmount").toggleClass("evenRow", !isDomestic);
		$(".cdxfeeAmount").toggleClass("evenRow", isDomestic);

		$('.medicalCondsAssessed').qtip({
			content: {
				text: 'Insurer allows assessment of pre-existing medical conditions.'
			},
			show: { event: 'mouseenter click' },
			position: {
				my: 'top right',
				at: 'bottom right',
				adjust: { x: -4 }
			},
			style: {
				classes: 'qtip-bootstrap',
				tip: {
					width: 14,
					height: 12,
					mimic: 'center'
				}
			}
		});
	}

	function launchOfferTerms(event) {
		event.preventDefault();

		var $element = $(event.target);
		var $termsContent = $element.next('.offerTerms-content');

		var $logo =				$element.closest('.resultInsert, .more-info-content').find('.travelCompanyLogo');
		var $productName =		$element.closest('.resultInsert, .more-info-content').find('.productTitle span:first, h2.productTitle:first');

		meerkat.modules.dialogs.show({
			title: $logo.clone().wrap('<p>').addClass('hidden-xs').parent().html() + "<div class='hidden-xs heading'>" + $productName.html() + "</div>" + "<div class='heading'>Offer terms</div>",
			hashId: 'offer-terms',
			className: 'offer-terms-modal',
			openOnHashChange: false,
			closeOnHashChange: true,
			htmlContent: $logo.clone().wrap('<p>').removeClass('hidden-xs').addClass('hidden-sm hidden-md hidden-lg').parent().html() + "<h2 class='visible-xs heading'>" + $productName.html() + "</h2><div class='termsWrapper'>" +  $termsContent.html() + "</div>"
		});
	}

	function rankingCallback(product, position) {
		var data = {};

		// If the is the first time sorting, send the prm as well.
		data["rank_premium" + position] = product.price;
		data["rank_productId" + position] = product.productId;
		data["best_price" + position] = 1;
		data["best_price_price" + position] = product.priceText;

		if (typeof product.info.coverLevel !== 'undefined' && position === 0)
		{
			data["coverLevelType" + position] = product.info.coverLevel;
		}

		if( _.isNumber(best_price_count) && position < best_price_count) {
			data["best_price_providerName" + position] = product.provider;
			data["best_price_productName" + position] = product.name;
			data["best_price_excess" + position] = typeof product.info.excess !== 'undefined' ? product.info.excess : 0;
			data["best_price_medical" + position] = typeof product.info.medical !== 'undefined' ? product.info.medical : 0;
			data["best_price_cxdfee" + position] = typeof product.info.cxdfee !== 'undefined' ? product.info.cxdfee : 0;
			data["best_price_luggage" + position] = typeof product.info.luggage !== 'undefined' ? product.info.luggage : 0;
			data["best_price_rentalVehicle" + position] = typeof product.info.rentalVehicle !== 'undefined' ? product.info.rentalVehicle : 0;
			data["best_price_service" + position] = product.service;
			data["best_price_url" + position] = product.quoteUrl;
		}
		// These price recordings are not used for best price. It is just so we can send the premium in the same format to the JSP.
		// Ideally, we wouldn't need to label the params as "best_price"
		if(_.isNumber(price_log_count) && position < price_log_count && position >= best_price_count) {
			data["best_price" + position] = 1;
			data["best_price_price" + position] = product.priceText;
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

	// Wrapper around results component, load results data
	function get() {
    Results.updateAggregatorEnvironment();
		Results.get();
	}

	function invalidQuoteDueToDate() {
		meerkat.modules.travelDatepicker.reset();
		setTimeout(function() {
			meerkat.modules.address.setHash('start');
			showInvalidDateModal();
		}, 150);
	}

	function showInvalidDateModal() {
		var element = document.getElementById('invalid-date').outerHTML;
		meerkat.modules.dialogs.show({
			htmlContent: element
		});
	}

	function showNoResults() {
		meerkat.modules.dialogs.show({
			htmlContent: $('#no-results-content')[0].outerHTML
		});
	}

	function showBlockedResults() {
		meerkat.modules.dialogs.show({
			htmlContent: $('#blocked-ip-address')[0].outerHTML
		});
	}

	/**
	 * This function has been refactored into calling a core resultsTracking module.
	 * It has remained here so verticals can run their own unique calls.
	 */
	function publishExtraTrackingEvents(additionalData) {
		additionalData = typeof additionalData === 'undefined' ? {} : additionalData;

		meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
			additionalData: $.extend({
				sortBy: Results.getSortBy() +'-'+ Results.getSortDir()
			}, additionalData),
			onAfterEventMode: meerkat.modules.resultsTracking.getResultsEventMode()
		});
	}

	function init(){
		$(document).ready(function() {
			$component = $("#resultsPage");
		});
	}

	meerkat.modules.register('travelResults', {
		init: init,
		initPage: initPage,
		get: get,
		showNoResults: showNoResults,
		rankingCallback: rankingCallback,
		publishExtraTrackingEvents: publishExtraTrackingEvents,
		invalidQuoteDueToDate: invalidQuoteDueToDate,
		setColVisibilityAndStylesByTravelType: setColVisibilityAndStylesByTravelType
	});

})(jQuery);
