;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
		// Defined here because it's published in Results.js
		RESULTS_ERROR: 'RESULTS_ERROR'
	};

	meerkatEvents.carResults = {
		FEATURES_CALL_ACTION: 'FEATURES_CALL_ACTION',
		FEATURES_CALL_ACTION_MODAL: 'FEATURES_CALL_ACTION_MODAL',
		FEATURES_SUBMIT_CALLBACK: 'FEATURES_SUBMIT_CALLBACK'
	};

	var $component; //Stores the jQuery object for the component group
	var previousBreakpoint;
	var best_price_count = 5;
	var needToBuildFeatures = false;

	function initPage(){

		initResults();

		initCompare();
		Features.init();
		meerkat.modules.compare.initCompare();

		breakpointTracking();
		eventSubscriptions();
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
				annually: "price.annualPremium",
				annual: "price.annualPremium",
				monthly: "price.annualisedMonthlyPremium"
			};
			var rank_premium = "price.annualPremium";
			var carQuoteResultsUrl = "ajax/json/car_quote_results.jsp";

			// Init the main Results object
			Results.init({
				url: carQuoteResultsUrl,
				runShowResultsPage: false, // Don't let Results.view do it's normal thing.
				paths: {
					productId: "productId",
					productName: "headline.name",
					productBrandCode: "brandCode",
					price: price,
					availability: {
						product: "available",
						price: price
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
						container: "#results_v5.featuresMode",
						values: ".content",
						extras: ".children"
					}
				},
				templates:{
					pagination:{
						pageText: '{{ if(currentPage <= availableCounts) { }} Product {{=currentPage}} of {{=(availableCounts)}} {{ } }}'
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
						rank_premium: rank_premium
					},
					filterUnavailableProducts : true
				},
				incrementTransactionId : false
			});

		}
		catch(e) {
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.carResults.initResults(); '+e.message, e);
		}
	}

	function eventSubscriptions() {

		// Capture offer terms link clicks
		$(document.body).on('click', 'a.offerTerms', launchOfferTerms);

		// When the navar docks/undocks
		meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
			var margin = (meerkat.modules.deviceMediaState.get() === 'lg') ? '-10px' : '-25px';
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
		meerkat.messaging.subscribe(meerkatEvents.carFilters.CHANGED, function onFilterChange(obj){
			if (obj && obj.hasOwnProperty('excess') || obj && obj.hasOwnProperty('coverType')) {
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
		meerkat.messaging.subscribe(events.RESULTS_ERROR, function () {
			// Delayed to allow journey engine to unlock
			_.delay(function () {
				meerkat.modules.journeyEngine.gotoPath('previous');
			}, 1000);
		});

		// Model updated, make changes before rendering
		meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
			massageResultsObject();
		});

		$(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function () {
			Features.buildHtml();
		});

		// Run the show method even when there are no available products
		// This will render the unavailable combined template
		$(Results.settings.elements.resultsContainer).on("noFilteredResults", function () {
			Results.view.show();
		});

		$(document).on("resultsLoaded", onResultsLoaded);

		// Scroll to the top when results come back
		$(document).on("resultsReturned", function () {
			meerkat.modules.utils.scrollPageTo($("header"));

			// Reset the feature header to match the new column content.
			$(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");

		});

		// Start fetching results
		$(document).on("resultsFetchStart", function onResultsFetchStart() {
			meerkat.modules.journeyEngine.loadingShow('getting your quotes', null, 'Quotes are indicative and subject to change based on further questions by the insurer.');
			$('#resultsPage, .loadingDisclaimerText').removeClass('hidden');
			if (meerkat.site.tracking.brandCode == 'ctm') {
				$('.loadingQuoteText, .loadingPromise').removeClass('hidden');
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
			if (meerkat.site.tracking.brandCode == 'ctm') {
				$('.loadingQuoteText').addClass('hidden');
			}

			if (Results.getDisplayMode() !== 'price') {
				// Show pagination
				Results.pagination.show();
			}
			else {
				$(document.body).removeClass('priceMode').addClass('priceMode');
			}

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
			if (time < 800) {
				score = meerkat.modules.performanceProfiling.PERFORMANCE.HIGH;
			} else if (time < 8000 && meerkat.modules.performanceProfiling.isIE8() === false) {
				score = meerkat.modules.performanceProfiling.PERFORMANCE.MEDIUM;
			} else {
				score = meerkat.modules.performanceProfiling.PERFORMANCE.LOW;
			}

			Results.setPerformanceMode(score);

		});

		$(document).on("resultPageChange", function (event) {
			var pageData = event.pageData;
			if (pageData.measurements === null) return false;

			var items = Results.getFilteredResults().length;
			var columnsPerPage = pageData.measurements.columnsPerPage;
			var freeColumns = (columnsPerPage * pageData.measurements.numberOfPages) - items;
		});

		// Hovering a row cell adds a class to the whole row to make it highlightable
		$(document).on("FeaturesRendered", function () {

			$(Features.target + " .expandable > " + Results.settings.elements.features.values).off('mouseenter mouseleave').on("mouseenter", function () {
					var featureId = $(this).attr("data-featureId");
					var $hoverRow = $(Features.target + ' [data-featureId="' + featureId + '"]');

					$hoverRow.addClass(Results.settings.elements.features.expandableHover.replace(/[#\.]/g, ''));
				})
				.on("mouseleave", function () {
					var featureId = $(this).attr("data-featureId");
					var $hoverRow = $(Features.target + ' [data-featureId="' + featureId + '"]');

					$hoverRow.removeClass(Results.settings.elements.features.expandableHover.replace(/[#\.]/g, ''));
				});
		});

		$(document.body).on('click', '#results_v5 .btnContainer .btn-call-actions', function triggerMoreInfoCallActions(event) {
			var element = $(this);
			meerkat.messaging.publish(meerkatEvents.carResults.FEATURES_CALL_ACTION, {
				event: event,
				element: element
			});
		});

		$(document.body).on('click', '#results_v5 .call-modal .btn-call-actions', function triggerMoreInfoCallActionsFromModal(event) {
			var element = $(this);
			meerkat.messaging.publish(meerkatEvents.carResults.FEATURES_CALL_ACTION_MODAL, {
				event: event,
				element: element
			});
		});

		$(document.body).on('click', '#results_v5 .btn-submit-callback', function triggerMoreInfoSubmitCallback(event) {
			var element = $(this);
			meerkat.messaging.publish(meerkatEvents.carResults.FEATURES_SUBMIT_CALLBACK, {
				event: event,
				element: element
			});
		});

		meerkat.messaging.subscribe(meerkatEvents.resultsMobileDisplayModeToggle.DISPLAY_MODE_CHANGED, function(obj) {
			if (obj.displayMode === 'price') {
				switchToPriceMode(true);
			} else {
				switchToFeaturesMode(true);
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
        var envParam = "";
        Results.updateAggregatorEnvironment();
		meerkat.modules.carContactOptins.validateOptins();
		meerkat.modules.resultsFeatures.fetchStructure('carws_').done(function() {
			meerkat.modules.carExotic.toggleFamousResultsPage();

			if (!meerkat.modules.carExotic.isExotic()) {
				Results.get();
			}
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

	function massageResultsObject(products) {
		products = products || Results.model.returnedProducts;

		_.each(products, function massageJson(result, index) {
			// If the brandCode is iBox, add the quoteReferenceNumber to a persisted xpath.
			if (result.brandCode == 'IBOX') {
				if (meerkat.site.IBOXquoteNumber === null) {
					// Set the value to the "global" site variable to "persist".
					meerkat.site.IBOXquoteNumber = result.quoteNumber;
				}
				// Set the hidden xpath.
				// "quote/quoteReferenceNumber"
				$('#quote_quoteReferenceNumber').val(meerkat.site.IBOXquoteNumber);
			}
			if (!_.isNull(result.price) && !_.isUndefined(result.price)) {
				// Add formatted annual premium (ie without decimals)
				if (!_.isEmpty(result.price) && !_.isUndefined(result.price.annualPremium)) {
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
				if (result.excess !== null && !_.isUndefined(result.excess)) {
					result.excessFormatted = meerkat.modules.currencyField.formatCurrency(result.excess, {roundToDecimalPlace: 0});
				}
			}
		});
	}

	function showNoResults() {
		if (meerkat.modules.hasOwnProperty('carFilters')) {
			meerkat.modules.carFilters.disable();
		}

		if (meerkat.modules.hasOwnProperty('mobileNavButtons')) {
			meerkat.modules.mobileNavButtons.disable();
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

	function toggleNoResultsFeaturesMode() {
		if (Results.model.availableCounts === 0) {
			$(Results.settings.elements.features.container + " " + Results.settings.elements.features.allElements).hide();
			$(Results.settings.elements.features.container).removeClass('featuresMode').find('.results-table').removeAttr('style');

		} else {
			// revert everything
			$(Results.settings.elements.features.container + " " + Results.settings.elements.features.allElements).show();
			if (!$(Results.settings.elements.features.container).hasClass('featuresMode')) {
				$(Results.settings.elements.features.container).addClass('featuresMode');
			}
		}
	}

	function initCompare(){

		$component = $("#resultsPage");

		meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);

		// Elements to lock when entering compare mode
		meerkat.messaging.subscribe(meerkatEvents.compare.AFTER_ENTER_COMPARE_MODE, function() {
			$('.filter-cancel-label a').trigger('click');
			$('.filter-cover-type, .filter-cover-type a, .filter-excess, .filter-excess a').addClass('disabled');
			$('.filter-featuresmode, .filter-pricemode, .filter-view-label').addClass('hidden');
			$('.filter-frequency-label').css('margin-right', $('.back-to-price-mode').width());
		});

		// Elements to lock when exiting compare mode
		meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, function() {
			$('.filter-excess, .filter-excess a').removeClass('disabled');
			$('.filter-featuresmode, .filter-pricemode, .filter-view-label').removeClass('hidden');
			$('.filter-frequency-label').removeAttr('style');
		});


	}

	meerkat.modules.register('carResults', {
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
