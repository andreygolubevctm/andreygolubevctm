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
	var $destinationsfs;

	function initPage(){
		if(!initialised) {
			initialised = true;
			initResults();
			initFilterProviderNames();
			eventSubscriptions();
		}
	}

	function initFilterProviderNames() {


		var data = {};
		$destinationsfs = $("#travel-filter-brands");
		//$travelDestinations = $('#travel_destinations');

		if(meerkat.site.isDev === true){
			// need to wait for the development.deferred module to be initialised
			// then wait for the ajax call there to get all available service URL
			// IE8-10 is not working because for some reason the promise doesn't get set until 10 secs later

			meerkat.modules.utils.pluginReady("development").done(function() {
				meerkat.modules.development.getAggregationServicePromise().done(function() {
					data.environmentOverride = $("#developmentAggregatorEnvironment").val();
					getActiveProviderNames(data);
				});
			});

			return;
		}
		 getActiveProviderNames(data);
	}

	function invokeBrandFilter(value){
		var _filters = Results.model.travelFilters;
		if (_filters.PROVIDERS.indexOf(value) == -1) {
			_filters.PROVIDERS.push(value);
		} else {
			_filters.PROVIDERS.splice(_filters.PROVIDERS.indexOf(value), 1);
		}
		Results.model.travelFilters = _filters;
		_displayCustomResults(false, true);

		var TOTAL_PROVIDERS = 28;

		if(_filters.PROVIDERS.length > 0 && _filters.PROVIDERS.length < TOTAL_PROVIDERS) {
			$('.brands-select-toggle').data('brands-toggle', 'none');
			$('.brands-select-toggle').empty().text('Select none');
		}else{
			$('.brands-select-toggle').data('brands-toggle', 'all');
			$('.brands-select-toggle').empty().text('Select all');
		}

	}
	function _displayCustomResults(customFilter, matchAllFilter) {
		if (meerkat.modules.deviceMediaState.get() === 'lg') {
			Results.model.travelResultFilter(true, true, matchAllFilter);
			meerkat.modules.coverLevelTabs.buildCustomTab();
		}
		if (customFilter) {
			$('input[name="reset-filters-radio-group"]').prop('checked', false);
		}
	}

	function getActiveProviderNames(data) {
		meerkat.modules.comms.get({
			url: "spring/rest/travel/filterProviderList/list.json",
			data: data,
			cache: true,
			errorLevel: "warning",
			dataType: 'json'
		})
			.done(function onSuccess(providerList) {
				$.each(providerList,function(i,prov){
					$('#travel-filter-brands').append('<div class="col-sm-6 col-md-4 text-left col-brand">'+
						           '<div class="checkbox">'+
						              '<input type="checkbox" data-provider-code='+
										prov.code +' name='+prov.dashedName+' id='+prov.dashedName+' class="checkbox-custom  checkbox" value='+prov.dashedName+
										' checked="checked">'+
						              '<label for='+prov.dashedName+'>'+prov.name+'</label>'+
						          '</div>'+
						      ' </div>');
				});
				 $('.col-brand input[type="checkbox"]').change(function () {
				 	invokeBrandFilter($(this).data('provider-code'));
				 });
			})
			.fail(function onError(obj, txt, errorThrown) {
				exception(txt + ': ' + errorThrown);
			});
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

	//  Note that as per CTM-3983 australian territories include:
	//   Australia ('AUS')
	//   Norfolk Island ('NFK')
	//   Cocos Island  ('CCK')
	//   Christmas Island ('CXR')
	//   Heard and McDonald Islands ('HMD')
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

		 //  Note that as per CTM-3983 australian territories include:
		 //   Australia ('AUS')
		 //   Norfolk Island ('NFK')
		 //   Cocos Island  ('CCK')
		 //   Christmas Island ('CXR')
		 //   Heard and McDonald Islands ('HMD')
		 var noDomesticTerritoryDestinationDescriptionsFound = false;
		 if (result.des.indexOf('Australia') == -1 && result.des.indexOf('Christmas Island') == -1
			 && result.des.indexOf('Norfolk Island') == -1 && result.des.indexOf('Cocos (Keeling) Islands') == -1
			 && result.des.indexOf('Heard Island and McDonald Islands') == -1) {
			 noDomesticTerritoryDestinationDescriptionsFound = true;
		 }

     if (noDomesticTerritoryDestinationDescriptionsFound && result.des.indexOf('Domestic') == -1) {
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

		var isOnlyDomesticTerritories = getIsOnlyDomesticTerritoriesSelected();

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
				// TRV-769 Set value and text to $0 for quotes for JUST Domestic.
				// added the policyType check because it was causing a bug
				// the bug is caused by the user selecting Domestic for single trip then selecting AMT
				// BTW not a huge fan of this, the backend should of probably handled setting the medicalValue to 0
				//CTM-204 added the test for non cruise trip Types
				// ie do not override medicalValues when cruise trip type is selected
				 if (isOnlyDomesticTerritories && policyType == 'Single Trip' && !isCruise) {
				 	obj.medicalValue = 0;
				 	obj.medical = "N/A";
				 }
				if (isCoverLevelTabsEnabled === true) {
					if (policyType == 'Single Trip') {
						obj.coverLevel = getCoverLevel(obj, isOnlyDomesticTerritories);
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
		$(document.body).on('click', 'a.productSuitability', launchProductSuitability);
		$(document.body).on('click', 'a.learnMoreDomestic', launchLearnMoreDomestic);
		$(document.body).on('click', 'a.learnMoreInternational', launchLearnMoreInternational);

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
			var loadingMessage =  $('<div />').html(meerkat.site.quoteLoadingMessage).text();

			$(".travelResultsDisclaimerHeader").hide();
			meerkat.modules.journeyEngine.loadingShow(loadingMessage);
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

	//The default return logic is used for annual multi trip journeys
	function isDomestic() {

		if (meerkat.modules.travel.getVerticalFilter() === 'Single Trip') {
			return getIsOnlyDomesticTerritoriesSelected();
		}

		return $('#travel_filter_domestic:checked').val() === "D";
	}

    // This checks if all the destinations supplied are Australian territories see CTM-3983.
	// treated as domestic if no destinations supplied - which should never happen
	// there are more efficient ways to do this but web-ctm needs to support ie11
	// Note in most situations you should use use the isDomestic function above rather than this function
	//       in most situations as it has the correct checks for Annual multi trip functionality
	function getIsOnlyDomesticTerritoriesSelected() {
		var isDomesticTravel = true;

		var theDestinationsStr = $('#travel_destination').val();

		if (theDestinationsStr.length > 0) {
			var destinationsArray = theDestinationsStr.split(',');

			for (var i = 0; i < destinationsArray.length; i++) {
				if (isDomesticTravel) {
					var destination = destinationsArray[i];
					isDomesticTravel = (
						destination === 'AUS' || destination === 'CCK' || destination === 'CXR'
						|| destination === 'HMD' || destination === 'NFK'
					);
				}
			}

		}
		return isDomesticTravel;
	}

	function denoteDisclaimer(isDomestic) {
		var disclaimerText = "", oSMedical2ColText = "", cancelFeeColText = "", luggageColText = "";

		if (isDomestic ) {
			oSMedical2ColText = "Expenses";
			cancelFeeColText = "Cancellation Fee&nbsp;Cover";
			luggageColText = "Luggage";
		} else {
			oSMedical2ColText = "Expenses";
			cancelFeeColText = "Cancellation Fee&nbsp;Cover";
			luggageColText = "Luggage";
		}

		// This is coming from the WebCTM database, ctm.content_control contentKey = travelAdvisoryMessageDomestic, travelAdvisoryMessageInternational
		disclaimerText = isDomestic ? meerkat.site.advisoryMessage.domestic : meerkat.site.advisoryMessage.international;
		var disclaimerHtml = $('<div />').html(disclaimerText).text();

		$(".travelResultsDisclaimerHeader").html(disclaimerHtml);
		$(".oSMedical2ColText").html(oSMedical2ColText);
		$(".cancelFeeColText").html(cancelFeeColText);
		$(".luggageColText").html(luggageColText);

		setColVisibilityAndStylesByTravelType(isDomestic);
	}

	function setColVisibilityAndStylesByTravelType(isDomestic) {
		var isActuallyDomestic = getIsOnlyDomesticTerritoriesSelected();

		//set visibility of os medical and rental vehicle columns
		$(".medicalTitle").toggle(!isDomestic && !isActuallyDomestic);
		$(".medicalAmount").toggle(!isDomestic && !isActuallyDomestic);
		$(".os-medical-col").toggle(!isDomestic && !isActuallyDomestic);
		$(".rentalVehicleTitle").toggle(isDomestic || isActuallyDomestic);
		$(".rentalVehicle").toggle(isDomestic || isActuallyDomestic);
		$(".rental-vehicle-col").toggle(isDomestic || isActuallyDomestic);

		// alter background colour for every second column
		var evenRowIndex = 1;
		$(".column-banded-row").each(function() {
			$(this).children().each(function() {
					$(this).toggleClass("evenRow", evenRowIndex % 2 === 0);
					if ($(this).css('display') !== 'none') {
						evenRowIndex ++;
					}
			});
		});

		$('.medicalCondsAssessed').qtip({
			content: {
				text: 'Insurer allows assessment of pre-existing medical conditions.'
			},
			show: { event: 'mouseenter click' },
			position: {
				my: 'top center',
				at: 'bottom center',
				adjust: { x: 0 }
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

	function launchProductSuitability(event) {
		event.preventDefault();

		var $element = $(event.target);
		var $productSuitabilityContent = $element.closest('.resultInsert, .more-info-content').find('.productSuitability-content');
		var $logo =				$element.closest('.resultInsert, .more-info-content').find('.travelCompanyLogo');
		var $productName = $element.closest('.resultInsert, .more-info-content').find('.productSuitability-title');

		meerkat.modules.dialogs.show({
			title: $logo.clone().wrap('<div >').addClass('hidden-xs').parent().html() +
				"<div class='verticalCenterContainer '>" +
					"<h2 class='hidden-xs title-suitability'>" + $productName.html() + "</h2>"
				+ "</div> ",
			hashId: 'Product-suitability',
			className: 'product-suitability-modal',
			openOnHashChange: false,
			closeOnHashChange: true,
			htmlContent: $logo.clone().wrap('<p>').removeClass('hidden-xs').addClass('hidden-sm hidden-md hidden-lg').parent().html() + "<h2 class='visible-xs heading'>" + $productName.html() + "</h2><div class='termsWrapper suitabilityContentWrapper'>" +  $productSuitabilityContent.html() + "</div>"
		});
	}


	function launchLearnMoreDomestic(event) {
		event.preventDefault();

		meerkat.modules.dialogs.show({
			title:"",
			hashId: 'learn-more',
			className: 'learn-more-modal',
			openOnHashChange: false,
			closeOnHashChange: true,
			htmlContent: "<h2 class='visible-xs heading'>" +  "</h2><div class='termsWrapper learnMoreWrapper'>"
				+ "<p><strong>Exclusions and sub-limits</strong></p>"
				+ "<p>Exclusions and sub-limits may apply to each policy benefit and these differ between providers. Please read the Product Disclosure Statement (PDS) to ensure the product is right for you. </p>"
				+"</div>"
		});
	}

	function launchLearnMoreInternational(event) {
		event.preventDefault();

		meerkat.modules.dialogs.show({
			title:"",
			hashId: 'learn-more',
			className: 'learn-more-modal',
			openOnHashChange: false,
			closeOnHashChange: true,
			htmlContent: "<h2 class='visible-xs heading'>" +  "</h2><div class='termsWrapper learnMoreWrapper'>"
				+ "<p><strong>Exclusions and sub-limits</strong></p>"
				+ "<p>Exclusions and sub-limits may apply to each policy benefit and these differ between providers. Please read the Product Disclosure Statement (PDS) to ensure the product is right for you. </p> <br />"
				+ "<p><strong>Smartraveller.gov.au</strong></p>"
				+ "<p>The Smartraveller.gov.au website provides detailed travel advice about most worldwide destinations and this may affect the cover your chosen product provides in those destinations. </p>"
				+ "<p>It is important that you refer to the travel alerts/restrictions of your chosen insurer as some insurers will also exclude countries with increased travel risk in addition to official government warnings. </p>"
				+"</div>"
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
		var $resultrow = $(event.target);

		// Don't trigger if the apply button is clicked.
		if ($(event.target).hasClass('btn-apply') || $(event.target).parent().hasClass('btn-apply')) return;
		// Don't trigger if the PDS or product suitability link be clicked
		if ($(event.target).hasClass('productSuitability') || $(event.target).hasClass('showDoc')) return;
		// Ensure only in XS price mode
		if ($(Results.settings.elements.resultsContainer).hasClass('priceMode') === false) return;
		if (meerkat.modules.deviceMediaState.get() !== 'xs') return;

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
		setColVisibilityAndStylesByTravelType: setColVisibilityAndStylesByTravelType,
		getIsOnlyDomesticTerritoriesSelected: getIsOnlyDomesticTerritoriesSelected
	});

})(jQuery);
