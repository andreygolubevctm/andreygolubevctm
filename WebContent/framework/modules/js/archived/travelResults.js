;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		supertagEventMode = 'Load';

	var templates =  {
		premiumsPopOver :
			'<div class="result-row" id="result_{{= productId }}" style="display:none;">' +
				'<div class="provider view_details" onclick="javascript:void(0);" data-view_details="true" data-id="{{= productId }}" data-url="{{= quoteUrl }}" data-subtitle="{{= subTitle }}">' +
					'<div class="thumb"><img src="common/images/logos/travel/{{= productId }}.png" /></div>'+
				'</div>'+
				'<div class="des">'+
					'<h5 id="productName_{{= productId }}"><div onclick="javascript:void(0);" data-view_details="true" data-id="{{= productId }}" data-url="{{= quoteUrl }}" data-subtitle="{{= subTitle }}" class="productName view_details">{{= des }}</div></h5>'+
				'</div>'+
				'<div class="excess" id="excess_{{= productId }}">'+
					'<span>{{= info.excess.text }}</span>'+
				'</div>'+
				'<div class="medical" id="medical_{{= productId }}">'+
					'<span>{{= info.medical.text }}</span>'+
				'</div>'+
				'<div class="cxdfee" id="cxdfee_{{= productId }}">'+
					'<span>{{= info.cxdfee.text }}</span>'+
				'</div>'+
				'<div class="luggage" id="luggage_{{= productId }}">'+
					'<span>{{= info.luggage.text }}</span>'+
				'</div>'+
				'<div class="price" id="price_{{= productId }}">'+
					'<span>{{= priceText }}</span>'+
				'</div>'+
				'<div class="link">'+
					'<a id="pdsbtn_{{= productId }}" href="{{= subTitle }}" class="pdsbtn" target="_blank" ><span>PDS</span></a>'+
					'<a id="moreinfobtn_{{= productId }}" href="javascript:void(0);" data-view_details="true" data-id="{{= productId }}"  data-url="{{= quoteUrl }}" data-subtitle="{{= subTitle }}" class="moreinfobtn view_details" ><span>More Info</span></a>'+
				'</div>'+
				'<div class="buy">'+
					'<a id="buybtn_{{= productId }}" href="javascript:void(0);" data-applyOnline="true" data-id="{{= productId }}" class="buybtnbig orange" ><span>Buy Now</span></a>'+
				'</div>'+
			'</div>'
	};

	var moduleEvents = {
			travelResults: {
				SELECTED_PRODUCT_CHANGED: 'SELECTED_PRODUCT_CHANGED',
				SELECTED_PRODUCT_RESET: 'SELECTED_PRODUCT_RESET',
				PREMIUM_UPDATED: 'PREMIUM_UPDATED'
			},
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
		};

	var $component; //Stores the jQuery object for the component group
	var selectedProduct = null;
	var previousBreakpoint;
	var best_price_count = 5;

	function initPage(){

		initResults();

		Features.init();

		eventSubscriptions();

		breakpointTracking();

	}

	function onReturnToPage(){
		breakpointTracking();
		if(previousBreakpoint !== meerkat.modules.deviceMediaState.get()) {
			Results.view.calculateResultsContainerWidth();
			Features.clearSetHeights();
			Features.balanceVisibleRowsHeight();
		}
		Results.pagination.refresh();
	}

	function initResults(){


		try{

			// Init the main Results object
			Results.init({
				url: "ajax/json/travel_quote_results.jsp",
				runShowResultsPage: false,
				paths: {
					results: {
						list: "results.price.priceText",
						info: "results.price.info"
					},
					brand: "info.Name",
					productId: "productId",
					price: { // result object path to the price property
						annually: "premium.annually.lhcfreevalue",
						monthly: "premium.monthly.lhcfreevalue",
						fortnightly: "premium.fortnightly.lhcfreevalue"
					},
					benefitsSort: 'info.rank'
				},
				show: {
					// Apply Results availability filter (rule below)
					nonAvailablePrices: false
				},
				availability: {
					// This means the price has to be != 0 to display e.g. premium.annual.lhcfreevalue != 0
					price: ["notEquals", 0]
				},
				render: {
					templateEngine: '_',
					features:{
						mode:'populate',
						headers:false
					},
					dockCompareBar:false
				},
				displayMode: "features",
				paginationMode: 'page',
				sort: {
					sortBy: "benefitsSort"
				},
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
							easing: "swing" // animation easing type
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
				dictionary:{
					valueMap:[
						{
							key:'Y',
							value: "<span class='icon-tick'></span>"
						},
						{
							key:'N',
							value: "<span class='icon-cross'></span>"
						},
						{
							key:'R',
							value: "Restricted"
						},
						{
							key:'-',
							value: "&nbsp;"
						}
					]
				}
			});

		}catch(e){
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.travelResults.init(); '+e.message, e);
		}
	}

	function eventSubscriptions(){

		$(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function(){
			Features.buildHtml();
		});

		$(document).on("generalReturned", function(){
			var generalInfo = Results.getReturnedGeneral();
			if(generalInfo.pricesHaveChanged){
				meerkat.modules.dialogs.show({
					title: "Just a quick note",
					htmlContent: $('#quick-note').html(),
					buttons: [{
						label: "Show latest results",
						className: "btn btn-success",
						closeWindow: true
					}]
				});
			}
			$("input[name='health_retrieve_savedResults']").val("N");
		});

		$(document).on("resultsLoaded", onResultsLoaded);

		$(document).on("resultsReturned", function(){
			Compare.reset();
			meerkat.modules.utilities.scrollPageTo($("header"));

			// Reset the feature header to match the new column content.
			$(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");

		});

		$(document).on("resultsDataReady", function(){
			writeRanking();
		});

		$(document).on("resultsFetchStart", function onResultsFetchStart() {

			toggleMarketingMessage(false);
			toggleResultsLowNumberMessage(false);
			meerkat.modules.journeyEngine.loadingShow('...getting your quotes...');

			// Hide pagination
			$('header .slide-feature-pagination, header a[data-results-pagination-control]').addClass('hidden');
		});

		$(document).on("resultsFetchFinish", function onResultsFetchFinish() {
			var pageMeasurements = Results.pagination.calculatePageMeasurements();
			var items = Results.getFilteredResults().length;
			var columnsPerPage = pageMeasurements.columnsPerPage;
			var freeColumns = (columnsPerPage*pageMeasurements.numberOfPages)-items;
			if((columnsPerPage - items) > 2) {
				toggleResultsLowNumberMessage(true, freeColumns);
			}else {
				toggleResultsLowNumberMessage(false);
			}
			_.defer(function() {
				// Show pagination
				$('header .slide-feature-pagination, header a[data-results-pagination-control]').removeClass('hidden');
			});

			meerkat.modules.journeyEngine.loadingHide();

			// if call centre user amends an existing quote and no product has been selected yet, then select it from retrieved data
			if(!meerkat.site.isNewQuote && !Results.getSelectedProduct() && meerkat.site.isCallCentreUser) {
				Results.setSelectedProduct( $('.health_application_details_productId').val() );
				var product = Results.getSelectedProduct();
				if (product) {
					meerkat.modules.travelResults.setSelectedProduct(product);
				}
			}

			// Results are hidden in the CSS so we don't see the scaffolding after #benefits
			$(Results.settings.elements.page).show();

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



		$(document).on("resultPageChange", function(event){

			var pageData = event.pageData;
			if(pageData.measurements === null) return false;

			var items = Results.getFilteredResults().length;
			var columnsPerPage = pageData.measurements.columnsPerPage;
			var freeColumns = (columnsPerPage*pageData.measurements.numberOfPages)-items;

			if(pageData.measurements.numberOfPages === 1 && (columnsPerPage - items) > 2) {
				toggleResultsLowNumberMessage(true, freeColumns);
			}else {
				toggleResultsLowNumberMessage(false);
			}

			if(Compare.view.resultsFiltered === false) {
				if(pageData.pageNumber === pageData.measurements.numberOfPages && freeColumns > 2){
					toggleMarketingMessage(true, freeColumns);
					return true;
				}
				toggleMarketingMessage(false);
			}
		});

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



	function breakpointTracking(){

		if( meerkat.modules.deviceMediaState.get() == "xs") {
			startColumnWidthTracking();
		}

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter(){
			if( meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results" ){
				startColumnWidthTracking();
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function resultsXsBreakpointLeave(){
			stopColumnWidthTracking();
		});

	}

	function startColumnWidthTracking(){
		Results.view.startColumnWidthTracking( $(window), 2, false );
	}

	function stopColumnWidthTracking(){
		Results.view.stopColumnWidthTracking();
	}

	function recordPreviousBreakpoint(){
		previousBreakpoint = meerkat.modules.deviceMediaState.get();
	}

	// Wrapper around results component, load results data
	function get(){
		// Load rates before loading the results data (hidden fields are populated when rates are loaded).
		meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'healthLoadRates' });
		meerkat.modules.health.loadRates(function afterFetchRates(){
			meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'healthLoadRates' });
			Results.get();
		});
	}

	// Get the selected product - a clone of the product object from the results component.
	function getSelectedProduct(){
		return selectedProduct;
	}

	function getSelectedProductPremium(frequency){
		var selectedProduct = getSelectedProduct();
		return selectedProduct.premium[frequency];
	}

	function setSelectedProduct(product, premiumChangeEvent){

		selectedProduct = product;

		// Set hidden fields with selected product info.
		var $_main = $('#mainform');
		if(product === null){
			$_main.find('.health_application_details_provider').val("");
			$_main.find('.health_application_details_productId').val("");
			$_main.find('.health_application_details_productNumber').val("");
			$_main.find('.health_application_details_productTitle').val("");
		}else{
			$_main.find('.health_application_details_provider').val(selectedProduct.info.provider);
			$_main.find('.health_application_details_productId').val(selectedProduct.productId);
			$_main.find('.health_application_details_productNumber').val(selectedProduct.info.productCode);
			$_main.find('.health_application_details_productTitle').val(selectedProduct.info.productTitle);

			/* @todo = should be moved to the Results object */
			if(premiumChangeEvent === true){
				meerkat.messaging.publish(moduleEvents.travelResults.PREMIUM_UPDATED, selectedProduct);
			}else{
				meerkat.messaging.publish(moduleEvents.travelResults.SELECTED_PRODUCT_CHANGED, selectedProduct);
				$(Results.settings.elements.rows).removeClass("active");
				$(Results.settings.elements.rows + "[data-productid=" + selectedProduct.productId + "]").addClass("active");
			}

		}

	}

	function resetSelectedProduct(){
		// Need to reset the health fund setting.
		healthFunds.unload();

		// Reset selected product.
		setSelectedProduct(null);

		meerkat.messaging.publish(moduleEvents.travelResults.SELECTED_PRODUCT_RESET);
	}

	// Load an individual product from the results service call. (used to refresh premium info on the payment step)
	function getProductData(callback){
		meerkat.modules.health.loadRates(function afterFetchRates(data) {
			if(data === null){

				// This has failed.
				callback(null);

			}else{

				var postData = meerkat.modules.journeyEngine.getFormData();

				// Override some form data to only return a single product.
				_.findWhere(postData, {name: "health_showAll"}).value = "N";
				_.findWhere(postData, {name: "health_onResultsPage"}).value = "N";
				_.findWhere(postData, {name: "health_incrementTransactionId"}).value = "N";

				// Dynamically add these fields because they are disabled when this method is called.
				postData.push({name: "health_payment_details_start", value:$("#health_payment_details_start").val()});
				postData.push({name: "health_payment_details_type", value:meerkat.modules.healthPaymentStep.getSelectedPaymentMethod()});
				postData.push({name: "health_payment_details_frequency", value:meerkat.modules.healthPaymentStep.getSelectedFrequency()});

				meerkat.modules.comms.post({
					url:"ajax/json/health_quote_results.jsp",
					data: postData,
					cache: false,
					errorLevel: "warning",
					onSuccess: function onGetProductSuccess(data){
						Results.model.updateTransactionIdFromResult(data);

						if (!data.results || !data.results.price || data.results.price.available === 'N') {
							callback(null);
						} else {
							callback(data.results.price);
						}

					},
					onError: function onGetProductError(data){
						callback(null);
					}
				});
			}

		});
	}


	function onResultsLoaded() {

		if( meerkat.modules.deviceMediaState.get() == "xs") {
			startColumnWidthTracking();
		}

		updateBasketCount();

		// Listen to compare events
		try{

			// Compare checkboxes and top result
			$("#resultsPage .compare").unbind().on("click", function(){

				var $checkbox = $(this);
				var productId = $checkbox.parents( Results.settings.elements.rows ).attr("data-productId");
				var productObject = Results.getResult( "productId", productId );

				var product = {
					id: productId,
					object: productObject
				};

				if( $checkbox.is(":checked") ){
					Compare.add( product );
				} else {
					Compare.remove( productId );
				}

			});
		}catch(e){
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'FeaturesResults.setResultsActions(); '+e.message, e);
		}

		if( meerkat.site.isCallCentreUser ){
			createPremiumsPopOver();
		}
	}

	/*
	 * recreate the Simples tooltips over prices for Simples users
	 * when the results get loaded/reloaded
	 */
	function createPremiumsPopOver() {
		$('#resultsPage .price').each(function(){

			var $this = $(this);
			var productId = $this.parents( Results.settings.elements.rows ).attr("data-productId");
			var product = Results.getResultByProductId(productId);

			var htmlTemplate = _.template(templates.premiumsPopOver);

			var text = htmlTemplate({
				product : product,
				frequency : Results.getFrequency()
			});

			meerkat.modules.popovers.create({
				element: $this,
				contentValue: text,
				contentType: 'content',
				showEvent: 'mouseenter click',
				position: {
						my: 'top center',
						at: 'bottom center'
				},
				style: {
					classes: 'priceTooltips'
				}
			});

		});
	}



	function toggleMarketingMessage(show, columns){
		if(show){
			$(".resultsMarketingMessage").addClass('show');
			$(".resultsMarketingMessage").attr('data-columns', columns);
		}else{
			$(".resultsMarketingMessage").removeClass('show');
		}
	}

	function writeRanking() {
		// Note, this isn't using the common ranking code used in other verticals because the data model sent is different.
		// We should aim to have a consitent data model so we can use the same code. (see how car works)

		var frequency = Results.getFrequency(); // eg monthly.yearly etc...
		var sortBy = Results.getSortBy();
		var sortDir = Results.getSortDir();
		var sortedPrices = Results.getFilteredResults();

		var data = {
			rootPath: 'health',
			rankBy: sortBy + "-" + sortDir,
			rank_count: sortedPrices.length
		};

		var externalTrackingData = [];

		for (var i = 0 ; i < sortedPrices.length; i++) {

			var price = sortedPrices[i];
			var prodId = price.productId.replace('PHIO-HEALTH-', '');
			data["rank_productId" + i] = prodId;
			data["rank_price_actual" + i] = price.premium[frequency].value.toFixed(2);
			data["rank_price_shown" + i] = price.premium[frequency].lhcfreevalue.toFixed(2);
			data["rank_frequency" + i] = frequency;
			data["rank_lhc" + i] = price.premium[frequency].lhc;
			data["rank_rebate" + i] = price.premium[frequency].rebate;
			data["rank_discounted" + i] = price.premium[frequency].discounted;

			if( _.isNumber(best_price_count) && i < best_price_count ) {
				data["rank_provider" + i] = price.info.provider;
				data["rank_providerName" + i] = price.info.providerName;
				data["rank_productName" + i] = price.info.productTitle;
				data["rank_productCode" + i] = price.info.productCode;
				data["rank_premium" + i] = price.premium[Results.settings.frequency].lhcfreetext;
				data["rank_premiumText" + i] = price.premium[Results.settings.frequency].lhcfreepricing;
			}

			var rank = i+1;
			externalTrackingData.push({
				productID : price.productId,
				ranking:rank
			});
		}

		meerkat.modules.comms.post({
			url:'ajax/write/quote_ranking.jsp',
			data:data,
			errorLevel: "silent"
		});

		// Do supertag...

		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:'trackQuoteProductList',
			object:{
				products: externalTrackingData
			}
		});

		var excess = "ALL";
		switch($("#health_excess").val())
		{
			case 1:
				excess = "0";
				break;
			case 2:
				excess = "1-250";
				break;
			case 3:
				excess = "251-500";
				break;
			default:
				excess = "ALL";
				break;
		}

		var sortHealthRanking = Results.getSortBy() === "benefitsSort" ? "Benefits" : "Lowest Price";

		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:'trackQuoteList',
			object:{
				preferredExcess: excess,
				sortPaymentFrequency: frequency,
				sortHealthRanking: sortHealthRanking,
				event: supertagEventMode
			}
		});

		supertagEventMode = 'Refresh'; // update for next call.
	}

	function init(){

		$component = $("#resultsPage");

		meerkat.messaging.subscribe(meerkatEvents.healthBenefits.CHANGED, onBenefitsSelectionChange);

	}

	meerkat.modules.register('travelResults', {
		init: init,
		events: moduleEvents,
		initPage: initPage,
		onReturnToPage:onReturnToPage,
		get:get,
		getSelectedProduct:getSelectedProduct,
		setSelectedProduct:setSelectedProduct,
		resetSelectedProduct:resetSelectedProduct,
		getProductData:getProductData,
		getSelectedProductPremium:getSelectedProductPremium,
		stopColumnWidthTracking: stopColumnWidthTracking,
		toggleMarketingMessage:toggleMarketingMessage,
		recordPreviousBreakpoint:recordPreviousBreakpoint
	});

})(jQuery);
