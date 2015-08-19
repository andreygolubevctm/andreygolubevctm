;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		$resultsLowNumberMessage,
		$component, //Stores the jQuery object for the component group
		selectedProduct = null,
		previousBreakpoint,
		best_price_count = 5,
		isLhcApplicable = 'N',
		premiumIncreaseContent = $('.healthPremiumIncreaseContent'),

		templates =  {
		premiumsPopOver :
				'{{ if(product.premium.hasOwnProperty(frequency)) { }}' +
				'<strong>Total Price including rebate and LHC: </strong><span class="highlighted">{{= product.premium[frequency].text }}</span><br/> ' +
				'<strong>Price including rebate but no LHC: </strong>{{=product.premium[frequency].lhcfreetext}}<br/> ' +
				'<strong>Price including LHC but no rebate: </strong>{{= product.premium[frequency].baseAndLHC }}<br/> ' +
				'<strong>Base price: </strong>{{= product.premium[frequency].base }}<br/> ' +
				'{{ } }}' +
				'<hr/> ' +
				'{{ if(product.premium.hasOwnProperty(\'fortnightly\')) { }}' +
				'<strong>Fortnightly (ex LHC): </strong>{{=product.premium.fortnightly.lhcfreetext}}<br/> ' +
				'{{ } }}' +
				'{{ if(product.premium.hasOwnProperty(\'monthly\')) { }}' +
				'<strong>Monthly (ex LHC): </strong>{{=product.premium.monthly.lhcfreetext}}<br/> ' +
				'{{ } }}' +
				'{{ if(product.premium.hasOwnProperty(\'annually\')) { }}' +
				'<strong>Annually (ex LHC): </strong>{{= product.premium.annually.lhcfreetext}}<br/> ' +
				'{{ } }}' +
				'<hr/> ' +
				'{{ if(product.hasOwnProperty(\'info\')) { }}' +
				'<strong>Name: </strong>{{=product.info.productTitle}}<br/> ' +
				'<strong>Product Code: </strong>{{=product.info.productCode}}<br/> ' +
				'<strong>Product ID: </strong>{{=product.productId}}<br/>' +
				'<strong>State: </strong>{{=product.info.State}}<br/> ' +
					'<strong>Membership Type: </strong>{{=product.info.Category}}' +
				'{{ } }}'
		},
		moduleEvents = {
			healthResults: {
				SELECTED_PRODUCT_CHANGED: 'SELECTED_PRODUCT_CHANGED',
				SELECTED_PRODUCT_RESET: 'SELECTED_PRODUCT_RESET',
				PREMIUM_UPDATED: 'PREMIUM_UPDATED'
			},
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK',
			RESULTS_ERROR: 'RESULTS_ERROR'
		};


	function initPage(){

		initResults();

		initCompare();

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
		$('.adjustFilters').on("click", function displayFiltersClicked(event) {
			event.preventDefault();
			event.stopPropagation();
			meerkat.modules.healthFilters.open();
		});

		$resultsLowNumberMessage = $(".resultsLowNumberMessage, .resultsMarketingMessages");

		var frequencyValue = $('#health_filter_frequency').val();
		frequencyValue = meerkat.modules.healthResults.getFrequencyInWords(frequencyValue) || 'monthly';



		try{

			// Init the main Results object
			Results.init({
				url: "ajax/json/health_quote_results.jsp",
				runShowResultsPage: false, // Don't let Results.view do it's normal thing.
				paths: {
					results: {
						list: "results.price",
						info: "results.info"
					},
					brand: "info.Name",
					productBrandCode: "info.providerName", // for tracking
					productId: "productId",
					productTitle: "info.productTitle",
					productName: "info.productTitle", // for tracking
					price: { // result object path to the price property
						annually: "premium.annually.lhcfreevalue",
						monthly: "premium.monthly.lhcfreevalue",
						fortnightly: "premium.fortnightly.lhcfreevalue"
					},
					availability: { // result object path to the price availability property (see corresponding availability.price)
						product: "available",
						price: {
							annually: "premium.annual.lhcfreevalue",
							monthly: "premium.monthly.lhcfreevalue",
							fortnightly: "premium.fortnightly.lhcfreevalue"
						}
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
						headers: false,
						numberOfXSColumns: 2
					},
					dockCompareBar:false
				},
				displayMode: "features",
				pagination: {
					mode: 'page',
					touchEnabled: Modernizr.touch
				},
				sort: {
					sortBy: "benefitsSort"
				},
				frequency: frequencyValue,
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
				},
				rankings: {
					triggers : ['RESULTS_DATA_READY'],
					callback : meerkat.modules.healthResults.rankingCallback,
					forceIdNumeric : true
				}
			});

		}catch(e){
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.healthResults.initResults(); '+e.message, e);
		}
	}

	function initCompare(){

		// Init the comparison bar
		var compareSettings = {
			compareBarRenderer: ListModeCompareBarRenderer,
			elements: {
				button: ".compareBtn",
				bar: ".compareBar",
				boxes: ".compareBox"
			},
			dictionary:{
				compareLabel: 'Compare <span class="icon icon-arrow-right"></span>',
				clearBasketLabel: 'Clear Shortlist <span class="icon icon-arrow-right"></span>'
			}
		};

		Compare.init(compareSettings);

		$compareBasket = $(Compare.settings.elements.bar);

		$compareBasket.on("compareAdded", function(event, productId ){

			// Close the more info panel if open.
			if(meerkat.modules.moreInfo.getOpenProduct() !== null && meerkat.modules.moreInfo.getOpenProduct().productId !== productId) {
				meerkat.modules.moreInfo.close();
			}

			$compareBasket.addClass("active");
			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId='" + productId + "']" ).addClass('compared');

			if( Compare.view.resultsFiltered === false && (Compare.model.products.length === Compare.settings.maximum) ){
				$(".compareBtn").addClass("compareInActive"); // disable the button straight away as slow devices still let you tap it.
				_.delay(function(){
					compareResults();
				}, 250);

			}
		});

		$compareBasket.on("compareRemoved", function(event, productId){

			if( Compare.view.resultsFiltered && (Compare.model.products.length >= Compare.settings.minimum) ){
				compareResults();
			}
			$element = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId='" + productId + "']" );
			$element.removeClass('compared');
			$element.find(".compareCheckbox input").prop("checked", false);

			if(Compare.model.products.length === 0 ){
				$(".compareBar").removeClass("active");
				toggleMarketingMessage(false);
				toggleResultsLowNumberMessage(true);
			}
		});

		$compareBasket.on("compareNonAvailable", function(event){
			if( Compare.view.resultsFiltered ){
				resetCompare(); // was just unfilter
			}
		});

		// Prevent the user from adding too many items to the bucket.
		$compareBasket.on("compareBucketFull", function(event){
			$(".result .compareCheckbox :input").not(":checked").prop('disabled', true);
		});

		$compareBasket.on("compareBucketAvailable", function(event){
			$(".result .compareCheckbox :input").prop('disabled', false);
		});

		// Compare button clicked.
		$compareBasket.on("compareClick", function(event){
			if( !Compare.view.resultsFiltered ) {
				compareResults();

			} else {
				resetCompare();
			}
		});



	}

	function resetCompare(){
		$container = $(Results.settings.elements.container);
		// Do this stuff now (even though we don't have to) so low performing devices look good
		if(Results.settings.animation.filter.active){
			$container.find('.compared').removeClass('compared');
		}else{
			// Do even more stuff for lower performance devices look reasonable.
			$container.find('.compared').removeClass('compared notfiltered').addClass('filtered');
		}

		$container.find('.compareCheckbox input').prop("checked", false);
		$(".compareBtn").addClass("compareInActive");

		_.defer(function(){
			Compare.unfilterResults();
			_.defer(function(){
			Compare.reset();
		});
		});
	}

	function compareResults(){

		_.defer(function(){

			Compare.filterResults();

			_.defer(function(){

				toggleMarketingMessage(true, 5-Results.getFilteredResults().length);
				toggleResultsLowNumberMessage(false);

				_.delay(function(){

					// Expand hospital and extra sections
					if(Results.settings.render.features.expandRowsOnComparison){
						$(".featuresHeaders .featuresList > .section.expandable.collapsed > .content").trigger('click');

						// Expand selected items details.
						$(".featuresHeaders .featuresList > .selectionHolder > .children > .category.expandable.collapsed > .content").trigger('click');
					}

					// Close the more info panel if open.
					if(meerkat.modules.moreInfo.getOpenProduct() !== null){
						meerkat.modules.moreInfo.close();
					}

					// Publish tracking events.
					meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
						touchType:'H',
						touchComment: 'ResCompare',
						simplesUser: meerkat.site.isCallCentreUser
					});

					var compareArray = [];
					var items = Results.getFilteredResults();
					for (var i = 0; i < items.length; i++)
					{
						var product = items[i];
						compareArray.push({productID : product.productId});
					}

					meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
						method:'trackQuoteComparison',
						object:{
							products: compareArray,
							simplesUser: meerkat.site.isCallCentreUser
						}
					});

				},Results.settings.animation.features.scroll.duration+100);
			});

		});
	}


	function updateBasketCount(){
		var items = Results.getFilteredResults().length;
		var label = items + ' product';
		if(items != 1) label = label+'s';
		$(".compareBar .productCount").text(label);
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
						className: "btn btn-next",
						closeWindow: true
					}]
				});
				$("input[name='health_retrieve_savedResults']").val("N");
			}
		});

		$(document).on("resultsLoaded", onResultsLoaded);

		$(document).on("resultsReturned", function(){
			Compare.reset();
			meerkat.modules.utils.scrollPageTo($("header"));

			// Reset the feature header to match the new column content.
			$(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");

			if (premiumIncreaseContent.length > 0){
				_.defer(function(){
					premiumIncreaseContent.click();
				});
			}

			// coupon logic, filter for user, then render banner
			meerkat.modules.coupon.loadCoupon('filter', null, function successCallBack(){
				meerkat.modules.coupon.renderCouponBanner();
		});
		});

		$(document).on("resultsDataReady", function(){
			updateBasketCount();
			if( meerkat.site.isCallCentreUser ){
				createPremiumsPopOver();
			}
		});

		$(document).on("resultsFetchStart", function onResultsFetchStart() {

			toggleMarketingMessage(false);
			toggleResultsLowNumberMessage(false);
			meerkat.modules.journeyEngine.loadingShow('getting your quotes');

			// Hide pagination
			$('header .slide-feature-pagination, header a[data-results-pagination-control]').addClass('hidden');
		});

		// If error occurs, go back in the journey
		meerkat.messaging.subscribe(moduleEvents.RESULTS_ERROR, function resultsError() {
			// Delayed to allow journey engine to unlock
			_.delay(function() {
				meerkat.modules.journeyEngine.gotoPath('previous');
			}, 1000);
		});

		$(document).on("resultsFetchFinish", function onResultsFetchFinish() {
			toggleResultsLowNumberMessage(true);

			_.defer(function() {
				// Show pagination
				$('header .slide-feature-pagination, header a[data-results-pagination-control]').removeClass('hidden');
				// Setup scroll
				Results.pagination.setupNativeScroll();
			});

			meerkat.modules.journeyEngine.loadingHide();

			if(!meerkat.site.isNewQuote && !Results.getSelectedProduct() && meerkat.site.isCallCentreUser) {
				Results.setSelectedProduct($('.health_application_details_productId').val() );
				var product = Results.getSelectedProduct();
				if (product) {
					meerkat.modules.healthResults.setSelectedProduct(product);
				}
			}

			// if online user load quote from brochures edm (with attached productId), compare it with returend result set, if it is in there, select it, and go to apply stage.
			if(($('input[name="health_directApplication"]').val() === 'Y')) {
				Results.setSelectedProduct( meerkat.site.loadProductId );
				var productMatched = Results.getSelectedProduct();
				if (productMatched) {
					meerkat.modules.healthResults.setSelectedProduct(productMatched);
					meerkat.modules.journeyEngine.gotoPath("next");
				}else{
					var productUpdated = Results.getResult("productTitle", meerkat.site.loadProductTitle);
					var htmlContent = "";

					if (productUpdated){
						meerkat.modules.healthResults.setSelectedProduct(productUpdated);
						htmlContent	=	"Thanks for visiting " + meerkat.site.content.brandDisplayName + ". Please note that for this particular product, " +
										"the price and/or features have changed since the last time you were comparing. If you need further assistance, " +
										"you can chat to one of our Health Insurance Specialists on <span class=\"callCentreHelpNumber\">" + meerkat.site.content.callCentreHelpNumber + "</span>, and they will be able to help you with your options.";
					}else{
						$('#health_application_productId').val(''); // reset selected productId to prevent it getting saved into transaction details.
						$('#health_application_productTitle').val(''); // reset selected productTitle to prevent it getting saved into transaction details.
						htmlContent	=	"Thanks for visiting " + meerkat.site.content.brandDisplayName + ". Unfortunately the product you're looking for is no longer available. " +
										"Please head to your results page to compare available policies or alternatively, " +
										"chat to one of our Health Insurance Specialists on <span class=\"callCentreHelpNumber\">" + meerkat.site.content.callCentreHelpNumber + "</span>, and they will be able to help you with your options.";
					}

					meerkat.modules.dialogs.show({
						title: "Just a quick note",
						htmlContent: htmlContent,
						buttons: [{
							label: "Show latest results",
							className: "btn btn-next",
							closeWindow: true
						}]
					});
				}

				// reset
					meerkat.site.loadProductId = '';
				meerkat.site.loadProductTitle = '';
				$('input[name="health_directApplication"]').val('');
				}

			// Results are hidden in the CSS so we don't see the scaffolding after #benefits
			$(Results.settings.elements.page).show();
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



		$(document).on("resultPageChange", function(event){

			var pageData = event.pageData;
			if(pageData.measurements === null) return false;

			var numberOfPages = pageData.measurements.numberOfPages;
			var items = Results.getFilteredResults().length;
			var columnsPerPage = pageData.measurements.columnsPerPage;
			var freeColumns = (columnsPerPage*numberOfPages)-items;
			var pageNumber = pageData.pageNumber;

			meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
				additionalData: {
					pageNumber: pageNumber,
					numberOfPages: numberOfPages
				},
				onAfterEventMode: 'Load'
			});

			if(freeColumns > 1 && numberOfPages === 1) {
				toggleResultsLowNumberMessage(true);
				toggleMarketingMessage(false);

			}else {
				toggleResultsLowNumberMessage(false);
				if(Compare.view.resultsFiltered === false) {

					if(pageNumber === pageData.measurements.numberOfPages && freeColumns > 2){
						toggleMarketingMessage(true, freeColumns);
						return true;
					}
					toggleMarketingMessage(false);
				}
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

		// When the excess filter changes, fetch new results
		meerkat.messaging.subscribe(meerkatEvents.healthFilters.CHANGED, function onFilterChange(obj){
			resetCompare();

			if (obj && obj.hasOwnProperty('filter-frequency-change')) {
				meerkat.modules.resultsTracking.setResultsEventMode('Refresh'); // Only for events that dont cause a new TranId
	}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function onHealthResultsXsEnterChange(){
			resetCompare();
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
		Results.view.startColumnWidthTracking( $(window), Results.settings.render.features.numberOfXSColumns, false );
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

	function getFrequencyInLetters(frequency){
		switch(frequency){
			case 'weekly':
				return 'W';
			case 'fortnightly':
				return 'F';
			case 'monthly':
				return 'M';
			case 'quarterly':
				return 'Q';
			case 'halfyearly':
				return 'H';
			case 'annually':
				return 'A';
			default:
				return false;
		}
	}

	function getFrequencyInWords(frequency){
		switch(frequency){
			case 'W':
				return 'weekly';
			case 'F':
				return 'fortnightly';
			case 'M':
				return 'monthly';
			case 'Q':
				return 'quarterly';
			case 'H':
				return 'halfyearly';
			case 'A':
				return 'annually';
			default:
				return false;
		}
	}

	function getNumberOfPeriodsForFrequency(frequency){
		switch(frequency){
			case 'weekly':
				return 52;
			case 'fortnightly':
				return 26;
			case 'quarterly':
				return 4;
			case 'halfyearly':
				return 2;
			case 'annually':
				return 1;
			default:
				return 12;
		}
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
			$_main.find('.health_application_details_providerName').val("");
		}else{
			$_main.find('.health_application_details_provider').val(selectedProduct.info.provider);
			$_main.find('.health_application_details_productId').val(selectedProduct.productId);
			$_main.find('.health_application_details_productNumber').val(selectedProduct.info.productCode);
			$_main.find('.health_application_details_productTitle').val(selectedProduct.info.productTitle);
			$_main.find('.health_application_details_providerName').val(selectedProduct.info.providerName);

			if(premiumChangeEvent === true){
				meerkat.messaging.publish(moduleEvents.healthResults.PREMIUM_UPDATED, selectedProduct);
			}else{
				meerkat.messaging.publish(moduleEvents.healthResults.SELECTED_PRODUCT_CHANGED, selectedProduct);
				$(Results.settings.elements.rows).removeClass("active");

				var $targetProduct = $(Results.settings.elements.rows + "[data-productid='" + selectedProduct.productId + "']");
				var targetPosition = $targetProduct.data('position') + 1;
				$targetProduct.addClass("active");
				Results.pagination.gotoPosition(targetPosition, true, false);
			}

			// update transaction details otherwise we will have to wait until people get to payment page
			meerkat.modules.writeQuote.write({
				health_application_provider: selectedProduct.info.provider,
				health_application_productId: selectedProduct.productId,
				health_application_productName: selectedProduct.info.productCode,
				health_application_productTitle: selectedProduct.info.productTitle
			}, false);

		}

	}

	function resetSelectedProduct(){
		// Need to reset the health fund setting.
		healthFunds.unload();

		// Reset selected product.
		setSelectedProduct(null);

		meerkat.messaging.publish(moduleEvents.healthResults.SELECTED_PRODUCT_RESET);
	}

	// Load an individual product from the results service call. (used to refresh premium info on the payment step)
	function getProductData(callback){
		meerkat.modules.health.loadRates(function afterFetchRates(data){
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


	// Change the results templates to promote features to the 'selected' features row.

	function onBenefitsSelectionChange(selectedBenefits, callback){

		// Reset the template first. Place the cloned elements back in the results template.

		$component.find('.featuresTemplateComponent .selectionHolder [data-skey]').each(function( index, elementA ) {

			var $element = $(elementA);
			var key = $element.attr('data-skey');
			var parentKey = $element.attr('data-par-skey');
			var elementIndex = Number($element.attr('data-index'));

			$parentFeatureList = $element.parents('.featuresTemplateComponent').first();

			if(elementIndex === 0){
				var $item = $parentFeatureList.find('div[data-skey="'+parentKey+'"].hasShortlistableChildren .children').first();
				if( $item.attr('data-skey') === key ){
					$item.after($element);
				} else {
					$item.prepend($element);
				}
			}else{
				var beforeIndex = elementIndex - 1;
				$parentFeatureList.find('.hasShortlistableChildren div[data-par-skey="'+parentKey+'"][data-index="'+beforeIndex+'"]').first().after($element);
			}

		});


		// Place the elements in their new position

		for(var i=0;i<selectedBenefits.length;i++){

			var key = selectedBenefits[i];
			/*jshint -W083 */
			$component.find('.featuresTemplateComponent div[data-skey="'+key+'"]').each(function( index, elementA ) {
				var $element = $(elementA);
				var parentKey = $element.attr('data-par-skey');
				if(parentKey != null){
					// Find the place where we will drop the element, create a clone if it doesn't exist.
					$parentFeatureList = $element.parents('.featuresTemplateComponent').first();
					$parentFeatureList.find('.selection_'+parentKey+' .children').first().append($element);
				}
			});
			/*jshint +W083 */

		}

		// Hide top level sections which were not shortlisted.

		$component.find('.featuresTemplateComponent > .section.hasShortlistableChildren').each(function( index, elementA ) {

			var $element = $(elementA);
			var key = $element.attr('data-skey');
			var $selectionElement = $component.find('.cell.selection_'+key);

			if(selectedBenefits.indexOf(key) === -1){

				$element.hide();
				$selectionElement.hide();

			}else{

				$element.show();

				var selectedCount = $component.find('.featuresHeaders .selection_'+key+'> .children > .cell').length;

				if(selectedCount === 0){

					$selectionElement.hide();

				}else{

					$selectionElement.show();

					var $linkedElement = $component.find('.featuresHeaders div[data-skey="'+key+'"]');
					var availableCount = selectedCount + $linkedElement.find('> .children > .cell').length;

					$selectionElement.find('.content .extraText .selectedCount').text(selectedCount);
					$selectionElement.find('.content .extraText .availableCount').text(availableCount);

				}
			}

		});

		// when hospital is set to off in [Customise Cover] hide the excess section
		var $excessSection = $('.cell.excessSection');
		_.contains(selectedBenefits, 'Hospital') ? $excessSection.show() : $excessSection.hide();

		// If on the results step, reload the results data. Can this be more generic?
		if(typeof callback === 'undefined'){
			if(meerkat.modules.journeyEngine.getCurrentStepIndex() === 4){
				get();
			}
		}else{
			callback();
		}

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

			if(product.hasOwnProperty('premium')) {
			var htmlTemplate = _.template(templates.premiumsPopOver);

			var text = htmlTemplate({
				product : product,
				frequency : Results.getFrequency()
			});

				meerkat.modules.popovers.create({
					element: $this,
					contentValue: text,
					contentType: 'content',
					showEvent: 'mouseenter',
					position: {
						my: 'top center',
						at: 'bottom center'
					},
					style: {
						classes: 'priceTooltips'
					}
				});
			} else {
				meerkat.modules.errorHandling.error({
					message:		'product does not have property premium',
					page:			'healthResults.js',
					description:	'createPremiumsPopOver()',
					errorLevel:		'silent',
					data:			product
			});
		}
		});
	}



	function toggleMarketingMessage(show, columns){
		var $marketingMessage = $(".resultsMarketingMessage");
		if(show){
			$marketingMessage.addClass('show').attr('data-columns', columns);
		}else{
			$marketingMessage.removeClass('show');
		}
	}


	function toggleResultsLowNumberMessage(show) {
		var freeColumns;
		if(show){
			var pageMeasurements = Results.pagination.calculatePageMeasurements();
			if(pageMeasurements == null) {
				show = false;
			} else {
				var items = Results.getFilteredResults().length;
				freeColumns = pageMeasurements.columnsPerPage-items;
				if(freeColumns < 2 || pageMeasurements.numberOfPages !== 1) {
					show = false;
				}
			}
		}

		if(show){
			$resultsLowNumberMessage.addClass('show');
			$resultsLowNumberMessage.attr('data-columns', freeColumns);
		}else{
			$resultsLowNumberMessage.removeClass('show');
		}
		return show;
	}

	function rankingCallback(product, position) {

		var data = {};
		var frequency = Results.getFrequency(); // eg monthly.yearly etc..
		var prodId = product.productId.replace('PHIO-HEALTH-', '');
		data["rank_productId" + position] = prodId;
		data["rank_price_actual" + position] = product.premium[frequency].value.toFixed(2);
		data["rank_price_shown" + position] = product.premium[frequency].lhcfreevalue.toFixed(2);
		data["rank_frequency" + position] = frequency;
		data["rank_lhc" + position] = product.premium[frequency].lhc;
		data["rank_rebate" + position] = product.premium[frequency].rebate;
		data["rank_discounted" + position] = product.premium[frequency].discounted;

		if( _.isNumber(best_price_count) && position < best_price_count ) {
			data["rank_provider" + position] = product.info.provider;
			data["rank_providerName" + position] = product.info.providerName;
			data["rank_productName" + position] = product.info.productTitle;
			data["rank_productCode" + position] = product.info.productCode;
			data["rank_premium" + position] = product.premium[Results.settings.frequency].lhcfreetext;
			data["rank_premiumText" + position] = product.premium[Results.settings.frequency].lhcfreepricing;
			}

		return data;
		}

	/**
	 * This function has been refactored into calling a core resultsTracking module.
	 * It has remained here so verticals can run their own unique calls.
	 */
	function publishExtraSuperTagEvents() {

		meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
			additionalData: {
				preferredExcess: getPreferredExcess(),
				paymentPlan: Results.getFrequency(),
				sortBy: (Results.getSortBy() === "benefitsSort" ? "Benefits" : "Lowest Price"),
				simplesUser: meerkat.site.isCallCentreUser,
				isLhcApplicable: isLhcApplicable
			},
			onAfterEventMode: 'Load'
		});
	}

	function getPreferredExcess() {
		var excess = null;
		switch($("#health_excess").val()) {
			case '1':
				excess = "0";
				break;
			case '2':
				excess = "1-250";
				break;
			case '3':
				excess = "251-500";
				break;
			default:
				excess = "ALL";
				break;
		}
		return excess;
			}

	function setLhcApplicable(lhcLoading){
		isLhcApplicable = lhcLoading > 0 ? 'Y' : 'N';
	}

	function init(){

		$component = $("#resultsPage");

		meerkat.messaging.subscribe(meerkatEvents.healthBenefits.CHANGED, onBenefitsSelectionChange);
		meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
	}

	meerkat.modules.register('healthResults', {
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
		getNumberOfPeriodsForFrequency:getNumberOfPeriodsForFrequency,
		getFrequencyInLetters: getFrequencyInLetters,
		getFrequencyInWords: getFrequencyInWords,
		stopColumnWidthTracking: stopColumnWidthTracking,
		toggleMarketingMessage:toggleMarketingMessage,
		toggleResultsLowNumberMessage:toggleResultsLowNumberMessage,
		onBenefitsSelectionChange:onBenefitsSelectionChange,
		recordPreviousBreakpoint:recordPreviousBreakpoint,
		rankingCallback: rankingCallback,
		publishExtraSuperTagEvents: publishExtraSuperTagEvents,
		setLhcApplicable: setLhcApplicable
	});

})(jQuery);
