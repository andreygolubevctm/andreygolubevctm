/** ////////////////////////////////////////////////////////////
//// Results                                                ////
////--------------------------------------------------------////
//// Results screen for carlmi, car, home & contents       ////
////--------------------------------------------------------////
//// REQUIRES: jquery as $                                  ////
////--------------------------------------------------------////
//////////////////////////////////////////////////////////////*/

/////////////////////////////////////////////////
// Results Code
/////////////////////////////////////////////////
var Results = {

	view: {},
	model: {},
	cachedProcessedTemplates: {},
	$pinnedResultRow: null,

	moduleEvents: {
		RESULTS_INITIALISED: 'RESULTS_INITIALISED',
		RESULTS_ERROR: 'RESULTS_ERROR'
	},

	init: function( userSettings ){

		Results.view = ResultsView;
		Results.model = ResultsModel;
		Results.pagination = ResultsPagination;

		var settings = {
			url: "ajax/json/results.jsp", // where to get results from
			formSelector: "#mainform",
			runShowResultsPage: true, // this runs Results.view.showResultsPage(). Set to false on Small Screen Framework, or you'll pay the price.
			paths: {
				results: {
					rootElement: "results",
					list: "results.result",
					general: "results.info",
					providerCode: false, // path of the provider code for each vertical as it's different for each vertical. Example usage for PHG tracking code
					errors: "error"
				},
				price: { // result object path to the price property
					annually: "price.annual.total",
					quarterly: "price.quarterly.total",
					monthly: "price.monthly.total",
					fortnightly: "price.fortnightly.total",
					weekly: "price.weekly.total",
					daily: "price.daily.total"
				},
				availability: { // result object path to the price availability property if any (setting it will also enable sorting by availability)
					price: {
						annually: "price.annual.available",
						quarterly: "price.quarterly.available",
						monthly: "price.monthly.available",
						fortnightly: "price.fortnightly.available",
						weekly: "price.weekly.available",
						daily: "price.daily.available"
					},
					product: "productAvailable"
				},
				productId: "productId",
				features: "compareFeatures.features"
			},
			sort: {
				// to change the sortBy value, the path needs to be set in Results.settings.paths first
				// i.e. Results.settings.paths = "path.to.name.property.in.result.object" then change Results.settings.sort.sortBy = "name"
				// same goes for filtering by some field
				sortBy: "price.annually",
				sortByMethod: Results.model.defaultSortMethod,
				sortDir: "asc",
				randomizeMatchingPremiums: false
			},
			frequency: "annually",
			displayMode: "price",
			pagination: {
				margin: 0,
				mode: 'slide', //page
				touchEnabled: false,
				emptyContainerFunction: false, //You can specify a function for custom code that will empty the pagination container
				afterPaginationRefreshFunction: false, //You can specify a function for custom code to run after the pagination links have been generated
				useSubPixelWidths: false
			},
			availability: {
				// These are arrays so that $.extend does not combine with overrides
				product: ["equals", "Y"],
				price: ["equals", "Y"]
			},
			animation: {
				results: {
					individual: {
						active: true, // if results should be animated one by one or as a whole
						delay: -50, // when to start the next result animation compared to the end of the current animated individual
						acceleration: 25 // increase speed every time an individual result is displayed, set to 0 for no acceleration
					},
					delay: 100, // delay before starting to display the results
					options: {
						effect: "slide", // type of animation
						direction: "right", // animation direction (for animation types with spatial movement,
						easing: "easeInOutQuart", // animation easing type
						duration: 400 // animation speed
					}
				},
				shuffle: {
					active: true, // only used for individual animations, will first display the results in the order they returned and then shuffle them in sorted order
					options: {
						duration: 400, // animation speed of the shuffle
						easing: "easeInOutQuart", // animation easing of the shuffle
						queue: "shuffle"
					}
				},
				filter: {
					active: true,
					queue: "filter",
					reposition: {
						options: {
							duration: 1000, // animation speed of the shuffle
							easing: "easeInOutQuart" // animation easing of the shuffle
						}
					},
					appear: {
						options: {
							duration: 1200
						}
					},
					disappear: {
						options: {
							duration: 1000
						}
					}
				},
				features: {
					scroll: {
						active:true,
						duration: 1000,
						percentage: 1 // 1 = 100%, 0.5 = 50%, etc. this is relative to the size of the visible container
					}
				}
			},
			elements: {
				frequency: ".frequency",
				reviseButton: ".reviseButton",
				page: "#resultsPage",
				container: ".results-table",
				rows: ".result-row",
				productHeaders: ".result",
				templates: {
					result: "#result-template",
					unavailable: "#unavailable-template",
					unavailableCombined: "#unavailable-combined-template",
					error: "#error-template",
					currentProduct: "#current-product-template",
					feature: "#feature-template"
				},
				noResults: ".noResults",
				resultsFetchError: ".resultsFetchError",
				resultsContainer: ".resultsContainer",
				resultsOverflow: ".resultsOverflow",
				features: {
					headers: ".featuresHeaders",
					list: ".featuresList",
					allElements: ".featuresElements",
					expandable: ".expandable",
					expandableHover: ".expandableHover",
					values: ".featuresValues",
					extras: ".featuresExtras",
					renderTemplatesBasedOnFeatureIndex: false
				}
			},
			render:{
				templateEngine: '_',
				features: {
					mode: 'populate',
					headers: true,
					expandRowsOnComparison: true,
					numberOfXSColumns: 2
				},
				dockCompareBar:true
			},
			templates:{
				pagination:{
					pageItem: '<li><a class="btn-pagination" data-results-pagination-control="{{= pageNumber}}" ' + meerkat.modules.dataAnalyticsHelper.get("pagination {{= pageNumber}}",'"') + '>{{= label}}</a></li>',
					pageText: 'Page {{=currentPage}} of {{=totalPages}}',
					page: '<li><a class="btn-pagination icon icon-angle-{{=icon}}" data-results-pagination-control="{{= type}}" ' + meerkat.modules.dataAnalyticsHelper.get("pagination {{= type}}",'"') + '><!-- empty --></a></li>',
                    summary: null
				}
			},
			show: {
				resultsAsRows: true, // set to false if you don't want to render result-row's (either features or price mode)
				featuresCategories: true,
				topResult: true,
				currentProduct: true,
				nonAvailableProducts: true,
				nonAvailablePrices: true,
				savings: true,
				unavailableCombined: false // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
			},
			dictionary:{
				loadingMessage: "Loading Your Quotes...",
				valueMap:[ // features values will be parsed against that array of objects with "key" being the text looked for and "value" being the replacement
					/* i.e.
					{
						key:'Y',
						value: "<span class='icon-tick'></span>"
					},
					{
						key:'N',
						value: "<span class='icon-cross'></span>"
					}
					*/
				]
			},
			rankings: {
				/* NO DEFAULTS: either use paths to pick out all the values from a price results object
				 * or provide a callback (eg meerkat.modules.healthResults.rankingCallback). If omitted
				 * then the results object will not make any ranking calls.
				 *
				 * You can optionally:
				 * a] provide a list of trigger events which fire the write ranking function.
				 *    By default it will occur on RESULTS_DATA_READY and RESULTS_SORTED but can be overridden
				 *    by providing your own list.
				 * b] forceIdNumeric will force the productId to be trimmed of any non-numeric characters (for health)

				paths : {
					rank_productId : "productId",
					rank_premium : "price.annual.total"
				}

				-- OR --

				callback : reference_to_callback_function

				-- OPTIONAL --

				triggers : ['RESULTS_DATA_READY','RESULTS_SORTED']

				forceIdNumeric : boolean

				*/
				filterUnavailableProducts: true
			},
			// Flag to auto-increment the transactionId when requesting results
			incrementTransactionId : true,
			balanceCurrentPageRowsHeightOnly: {
				mobile: false
			},
			popularProducts: {
				enabled: false
			}
		};
		$.extend(true, settings, userSettings);

		Results.settings = settings;

		Results.view.$containerElement = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container );

		Results.pagination.init();

		Results.view.setDisplayMode( Results.settings.displayMode, true );

		if(typeof meerkat !== 'undefined') {
			meerkat.messaging.publish(Results.moduleEvents.RESULTS_INITIALISED);
		}
	},

	/* url and data are optional */
	get: function( url, data ){
		Results.model.fetch( url, data );
	},

	render: function(){
		Results.view.show();
		Results.pagination.refresh();
	},

	reset: function() {

		$(Results.settings.elements.resultsContainer).trigger("resultsReset"); // will trigger a Compare.reset()

		// @todo = find a way to reset all the values relying on the settings (e.g. Results.settings.sort.sortBy Results.settings.frequency, etc.)
		// i.e. reset to default settings extended with userSettings
		Results.model.flush();
		Results.pagination.reset();


		if( typeof(QuoteEngine) != "undefined") QuoteEngine.updateAddress();

	},

	reviseDetails: function(){

		if (typeof QuoteEngine !== 'undefined') QuoteEngine.setOnResults(false);

		if (typeof Track !== 'undefined' && typeof Track.quoteLoadRefresh !== 'undefined') {
			Track.quoteLoadRefresh("Refresh"); // TODO - this should be moved to vertical specific places.
		}

		Results.view.toggleResultsPage();

		Results.reset(); // will trigger an event that will also call Compare.reset()
	},

	// to change the sortBy value, the path needs to be set in Results.settings.paths first
	// i.e. Results.settings.paths = "path.to.name.property.in.result.object" then change Results.settings.sort.sortBy = "name"
	sortBy: function( sortBy, sortDir ){
		if (Results.setSortBy(sortBy)) {
			if (sortDir) {
				Results.setSortDir(sortDir);
			}
			Results.model.sort();
			return true;
		} else {
			return false;
		}
	},

	getSortBy: function(){
		return Results.settings.sort.sortBy;
	},

	getSortByMethod: function(){
		return Results.settings.sort.sortByMethod;
	},

	getSortDir: function(){
		return Results.settings.sort.sortDir;
	},

	setSortBy: function( sortBy ){
		// check that we know the path to the sortBy property in the result object
		if( typeof Object.byString( Results.settings.paths, sortBy) !== "undefined" ) {
			Results.settings.sort.sortBy = sortBy;
			return true;
		}
		console.log("Results.setSortBy() has been called but it could not find the path to the property it should be sorted by: sortBy=", sortBy);
		return false;
	},
	setSortByMethod: function( sortByMethod ){
		if( typeof sortByMethod === 'function' ) {
			Results.settings.sort.sortByMethod = sortByMethod;
			return true;
		}
		if(sortByMethod === null) {
			Results.settings.sort.sortByMethod = Results.model.defaultSortMethod;
		}
		console.log("Results.setSortByMethod() has been called but the parameter is not a function.", sortByMethod);
		return false;
	},
	setSortDir: function( sortDir ){
		if( sortDir && sortDir.length > 0 && $.inArray(sortDir, ["asc","desc"]) != -1 ) {
			Results.settings.sort.sortDir = sortDir;
			return true;
		}
		console.log("Results.setSortDir() has been called but it was provided an invalid argument: sortDir=", sortDir);
		return false;
	},

	filterBy: function( filterBy, condition, options, renderView, doNotGoToStart ){
		if( typeof Object.byString( Results.settings.paths, filterBy ) !== "undefined" ){
			Results.model.addFilter( filterBy, condition, options );
			Results.model.filter(renderView, doNotGoToStart);
		} else {
			console.log("This filter could not find the path to the property it should be filtered by: filterBy= filterBy=", filterBy, "| condition=", condition, "| options=", options);
		}
	},

	unfilterBy: function( filterBy, condition, renderView ){

		if( typeof Object.byString( Results.settings.paths, filterBy ) !== "undefined" ){
			Results.model.removeFilter( filterBy, condition );
			if( renderView ){
				Results.model.filter(renderView);
			}
		} else {
			console.log("This filter could not find the path to the property it should be unfiltered by: filterBy=", filterBy, "| condition=", condition);
		}

	},

	applyFiltersAndSorts:function(){
		Results.model.filterAndSort(true);
		Results.view.toggleFrequency(Results.settings.frequency);
	},

	getFrequency: function(){
		return Results.settings.frequency;
	},

	setFrequency: function( frequency, renderView ){

		if(typeof renderView === 'undefined') renderView = true;

		// if we don't want the unavailable prices to be displayed
		if (!Results.settings.show.nonAvailablePrices) {
			// remove all the previously added filters on price availability for frequency
			$.each(Results.settings.paths.price, function( currentFrequency ){
				Results.unfilterBy( "availability.price." + currentFrequency, "value" , false); // maybe render view should be true??
			});
			// apply the selected frequency's availability filter
			var options = {};
			options[Results.settings.availability.price[0]] = Results.settings.availability.price[1];
			Results.filterBy( "availability.price." + frequency, "value", options, renderView );
		}

		// record new selected frequency and sort by this frequency's price
		Results.model.setFrequency( frequency, renderView );

		if (renderView !== false) {
			Results.sortBy( "price." +  frequency );
		}
	},

	addCurrentProduct: function( identifierPathName, product ){

		Results.model.addCurrentProduct( product );
		Results.setCurrentProduct( identifierPathName, Object.byString( product, identifierPathName ) );

	},

	setCurrentProduct: function( identifierPathName, currentProduct ){
		if( typeof( Object.byString( Results.settings.paths, identifierPathName ) ) != "undefined" ){
			Results.model.setCurrentProduct( identifierPathName, currentProduct );
		} else {
			console.log("You have been trying to set the current product but the path to the identifier does not seem to exists: identifierPathName=", identifierPathName, "| currentProduct=", currentProduct);
		}
	},

	getResult: function( identifierPathName, value ){

		if( typeof( Object.byString( Results.settings.paths, identifierPathName ) ) != "undefined" ){
			return Results.model.getResult( identifierPathName, value );
		} else {
			console.log("You have been trying to retrieve a result through an identifier, but the path to that identifier does not seem to exist in the results objects: identifierPathName=", identifierPathName, "| value=", value);
		}

	},

	getResultIndex: function( identifierPathName, value ){

		if( typeof( Object.byString( Results.settings.paths, identifierPathName ) ) != "undefined" ){
			return Results.model.getResultIndex( identifierPathName, value );
		} else {
			console.log("You have been trying to retrieve a result through an identifier, but the path to that identifier does not seem to exist in the results objects: identifierPathName=", identifierPathName, "| value=", value);
		}

	},

	getResultByProductId: function( productId ){
		return Results.getResult( Results.settings.paths.productId, productId );
	},

	getTopResult: function(){
		return Results.model.sortedProducts && Results.model.sortedProducts.length > 0 ? Results.model.sortedProducts[0] : false;
	},

	getReturnedGeneral: function(){
		return Results.model.returnedGeneral;
	},

	getReturnedResults: function(){
		return Results.model.returnedProducts;
	},

	getAjaxRequest: function(){
		return Results.model.ajaxRequest;
	},

	getSortedResults: function(){
		return Results.model.sortedProducts;
	},

	getFilteredResults: function(){
		return Results.model.filteredProducts;
	},

	getSelectedProduct: function(){
		return Results.model.selectedProduct;
	},

	setSelectedProduct: function( productId ){
		return Results.model.setSelectedProduct( productId );
	},
	// delete/remove/clear/reset selected product
	removeSelectedProduct: function(  ){
		Results.model.removeSelectedProduct();
	},

	getDisplayMode: function() {
		if (typeof Results.settings === 'undefined' || Results.settings.hasOwnProperty('displayMode') !== true) return null;
		return Results.settings.displayMode;
	},

	setDisplayMode: function(mode, forceRefresh) {
		Results.view.setDisplayMode(mode, forceRefresh);
	},

	setPerformanceMode:function(level){
		var profile = meerkat.modules.performanceProfiling.PERFORMANCE;

		switch(level){
			case profile.LOW:
				Results.settings.animation.filter.active = false;
				Results.settings.animation.shuffle.active = false;
				Results.settings.animation.features.scroll.active = false;
				Results.settings.render.features.expandRowsOnComparison = false;
				break;

			case profile.MEDIUM:
				Results.settings.animation.filter.active = false;
				Results.settings.animation.shuffle.active = false;
				Results.settings.animation.features.scroll.active = true;
				Results.settings.render.features.expandRowsOnComparison = true;
				break;

			case profile.HIGH:
				Results.settings.animation.filter.active = true;
				Results.settings.animation.shuffle.active = true;
				Results.settings.animation.features.scroll.active = true;
				Results.settings.render.features.expandRowsOnComparison = true;
				break;
		}
	},

	onError:function(message, page, description, data){

			meerkat.messaging.publish(Results.moduleEvents.RESULTS_ERROR);

			meerkat.modules.errorHandling.error({
				errorLevel:		'warning',
				message:		message,
				page:			page,
				description:	description,
				data:			data
			});
            meerkat.logging.exception(data);
	},

	startResultsFetch:function() {
		Results.model.startResultsFetch();
	},

	finishResultsFetch:function() {
		Results.model.finishResultsFetch();
	},

	publishResultsDataReady:function() {
		Results.model.publishResultsDataReady();
	},

	updateAggregatorEnvironment:function() {
		if(meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi'){
			$("#environmentOverride").val($("#developmentAggregatorEnvironment").val());
		}
	},

	updateStaticBranch:function() {
		if(meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi'){
			$("#staticOverride").val($("#developmentStaticBranches").val());
		}
	},

	updateApplicationEnvironment:function() {
		if(meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi'){
			$("#environmentOverride").val($("#developmentApplicationEnvironment").val());
		}
	},
    /**
	 * Used in Health V4 designs to pin a product. Should be able to be used anywhere else, if the DOM structure lines up.
     * @param {Integer|String} pinnedProductId
     * @param {Function} beforePin
     * @returns {null}
     */
	pinProduct: function(pinnedProductId, beforePin) {
		if(Results.getDisplayMode() === 'price') {
			return;
		}
        var product = Results.model.getResult("productId", pinnedProductId);
        if (!product) {
            return;
        }
        product.isPinned = 'Y';

        // Must copy the element before filtering or it gets unnecessary classes etc.
        Results.$pinnedResultRow = $('.result_' + pinnedProductId).clone(true);

		// Now do the filtering to filter this product out of the normal results.
        Results.filterBy('isPinned', "value", { "notEquals": 'Y' });

        if(typeof beforePin === 'function') {
        	beforePin.call(this, pinnedProductId, Results.$pinnedResultRow);
		}

		// Now prepend it to the results container, outside of results overflow.
        Results.$pinnedResultRow.prependTo($(Results.settings.elements.resultsContainer));
		var $resultsOverflow = $(Results.settings.elements.resultsOverflow);
        $resultsOverflow.addClass('product-pinned');
        var pageMeasurements = ResultsPagination.getPageMeasurements();
        if (pageMeasurements) {
        	// Reduce the container width by one column
            $resultsOverflow
                .width($resultsOverflow.width() - pageMeasurements.columnWidth);
        }
        Results.pagination.hasPinnedProduct = true;
        return Results.$pinnedResultRow;
	},

	unpinProduct: function(pinnedProductId) {
        if (!pinnedProductId) {
            return;
        }

        var product = Results.model.getResult("productId", pinnedProductId);
        if (!product) {
            return;
        }

        if(Results.$pinnedResultRow) {
            Results.$pinnedResultRow.remove();
            Results.$pinnedResultRow = null;
        }

        $(Results.settings.elements.resultsOverflow).removeAttr('style');
        Results.unfilterBy('isPinned', "value", true);
        product.isPinned = 'N';
        $(Results.settings.elements.resultsOverflow).removeClass('product-pinned');
        Results.pagination.hasPinnedProduct = false;
	}
};