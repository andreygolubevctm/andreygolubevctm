var ResultsModel = new Object();
ResultsModel = {
	ajaxRequest: false,

	returnedGeneral: false,

	returnedProducts: false,
	filteredProducts: false,
	sortedProducts: false,

	currentProduct: false,
	selectedProduct: false,
	filters: new Array(),

	resultsLoadedOnce: false,

	moduleEvents: {
		WEBAPP_LOCK: 'WEBAPP_LOCK',
		WEBAPP_UNLOCK: 'WEBAPP_UNLOCK',
		RESULTS_DATA_READY: 'RESULTS_DATA_READY',
		RESULTS_BEFORE_DATA_READY: 'RESULTS_BEFORE_DATA_READY',
		RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW: 'RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW',
		RESULTS_UPDATED_INFO_RECEIVED: 'RESULTS_UPDATED_INFO_RECEIVED'
	},

	/* url and data are optional */
	fetch: function( url, data ) {
		Results.model.startResultsFetch();

		try{
			Results.model.flush();
			if(typeof Loading !== "undefined") {Loading.show(Results.settings.dictionary.loadingMessage);}
			if(typeof Compare !== 'undefined') {Compare.reset();}

			if (Results.settings.runShowResultsPage === true) {
				Results.view.showResultsPage();
			}

			// @todo manage the ajax calls concurrency

			// @todo = 2 different locations change the URL, which one is correct?
			try{
				// TODO REMOVE
				$.address.parameter("stage", "results", false );
			}catch(e){
				// ok
			}
			if( typeof(url) == "undefined" ){
				url = Results.settings.url;
			}

			if( typeof(data) == "undefined" ){
				var data;
				if( typeof meerkat !== "undefined" ){
					data = meerkat.modules.form.getData( $(Results.settings.formSelector) );
					data.push({
						name: 'transactionId',
						value: meerkat.modules.transactionId.get()
					});

					if(meerkat.site.isCallCentreUser) {
						data.push({
							name: meerkat.modules.comms.getCheckAuthenticatedLabel(),
							value: true
						});
					}
				} else {
					data = Results.model.getFormData( $(Results.settings.formSelector) );
					data.push({
						name: 'transactionId',
						value: referenceNo.getTransactionID()
					});
				}

				
			}
		}catch(e){
			Results.onError('Sorry, an error occurred fetching results', 'Results.js', 'Results.model.fetch(); '+e.message, e);
		}

		if(Results.model.resultsLoadedOnce == true){
			var hasIncTranIdSetting = Results.settings.hasOwnProperty('incrementTransactionId');
			if(!hasIncTranIdSetting || (hasIncTranIdSetting && Results.settings.incrementTransactionId === true)) {
				url += (url.indexOf('?') == -1 ? '?' : '&') + 'id_handler=increment_tranId';
			}
		}

		Results.model.ajaxRequest = $.ajax({
			url: url,
			data: data,
			type: "POST",
			async: true,
			dataType: "json",
			cache: false,
			success: function(jsonResult){

				Results.model.updateTransactionIdFromResult(jsonResult);

				if( typeof meerkat != 'undefined') {
					if (jsonResult.hasOwnProperty('results')) {
						if(jsonResult.results.hasOwnProperty('info')) {
							meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_UPDATED_INFO_RECEIVED, jsonResult.results.info);
						}
					}
				}

				try{
					if(jsonResult && jsonResult.messages && jsonResult.messages.length > 0){
						// if there are error messages returned by the web services, register them
						// @todo = these errors used to be done this way through Ajax on Utilities. They really should be checked through the fetched URL jsp on the back end side
						// so get rid of this empty if() and add the check on the soap aggregator returned XML
					}

					// check meerkat object
					if(typeof meerkat !== "undefined" && typeof jsonResult.error !== "undefined" && jsonResult.error == meerkat.modules.comms.getCheckAuthenticatedLabel()) {

						if (typeof Loading !== "undefined") Loading.hide();

						// Take user back to previous step (wrapped in defer for IE8)
						_.defer(function(){
							meerkat.modules.journeyEngine.gotoPath('previous');
						});

						if(!meerkat.modules.dialogs.isDialogOpen(jsonResult.error)) {
							meerkat.modules.errorHandling.error({
								errorLevel:		'warning',
								id:				jsonResult.error,
								message:		"Your Simples login session has been lost. Please open Simples in a separate tab, login, then you can continue with this quote.",
								page:			'ResultsModel.js',
								description:	"Error loading url: " + url + ' : ' + jsonResult.error,
								data:			data
							});
						}

					} else if(typeof jsonResult.error !== 'undefined' && jsonResult.error.type == "validation") {
						if (typeof Loading !== "undefined") Loading.hide();
						Results.reviseDetails();
						ServerSideValidation.outputValidationErrors({
								validationErrors: jsonResult.error.errorDetails.validationErrors,
								startStage: 0
						});
					}
					else if( !jsonResult || typeof( Object.byString( jsonResult, Results.settings.paths.results.rootElement ) ) == "undefined" ){
						Results.model.handleFetchError( jsonResult, "Returned results did not have the expected format" );
					}
					else {
						Results.model.update( jsonResult );
					}

					Results.model.triggerEventsFromResult(jsonResult);
				}
				catch(e){
					Results.model.handleFetchError( data, "Try/Catch fail on success: "+e.message );
				}

				
			},
			error: function(jqXHR, txt, errorThrown){
				Results.model.ajaxRequest = false;
				if (jqXHR.status === 0 || jqXHR.readyState === 0) { // Aborted - not an error
					return;
				} else {
				Results.model.handleFetchError( data, "AJAX request failed: " + txt + " " + errorThrown );
				}
			},
			complete: function(){
				Results.model.ajaxRequest = false;
				Results.model.finishResultsFetch();
			}
					});

	},

	triggerEventsFromResult: function(jsonResult) {
		if(typeof meerkat !== "undefined" && typeof jsonResult == "object" && jsonResult.hasOwnProperty("results") && jsonResult.results.hasOwnProperty("events")) {
			for(var i in jsonResult.results.events) {
				if(jsonResult.results.events.hasOwnProperty(i)) {
					meerkat.messaging.publish(i, jsonResult.results.events[i]);
				}
			}
		}
	},

	updateTransactionIdFromResult: function( jsonResult ){
		var newTranID = 0;
		if (jsonResult.hasOwnProperty('info') && jsonResult.info.hasOwnProperty('transactionId')) {
			newTranID = jsonResult.info.transactionId;
		}
		else if (jsonResult.hasOwnProperty('error') && jsonResult.error.hasOwnProperty('transactionId')) {
			newTranID = jsonResult.error.transactionId;
		}
		else if (jsonResult.hasOwnProperty('results')) {
			if (jsonResult.results.hasOwnProperty('transactionId')) {
				newTranID = jsonResult.results.transactionId;
			}
			else if (jsonResult.results.hasOwnProperty('info') && jsonResult.results.info.hasOwnProperty('transactionId')) {
			newTranID = jsonResult.results.info.transactionId;
		}
			else if (jsonResult.results.hasOwnProperty('noresults') && jsonResult.results.noresults.hasOwnProperty('transactionId')) {
				newTranID = jsonResult.results.noresults.transactionId;
		}
		}
		if (newTranID !== 0) {
			if (typeof meerkat !== 'undefined') {
				meerkat.modules.transactionId.set(newTranID);
			} else if (typeof referenceNo !== 'undefined') {
				referenceNo.setTransactionId(newTranID);
			}
		}
	},

	handleFetchError: function( data, description ){
		if (typeof Loading !== "undefined") Loading.hide();
		Results.reviseDetails();
		Results.onError("Sorry, an error occured with the results page.<br />Please close this message and click 'next' to reload your results.", "common/js/Results.js for " + Results.model.getVertical(), "Results.model.fetch(). " + description, data);
	},

	getVertical: function() {
		var vertical = "unknown";
		if(Results.settings.hasOwnProperty('vertical')) {
			vertical = Results.settings.vertical;
		} else if (typeof meerkat == 'object' && meerkat.site.hasOwnProperty('vertical')) {
			vertical = meerkat.site.vertical;
		}

		return vertical;
	},

	reset: function(){

		Results.model.flush();

		Results.model.currentProduct = false;
		Results.settings.frequency = 'annual';
		Results.model.filters = [];

	},

	flush: function(){

		Results.model.returnedGeneral = [];
		Results.model.returnedProducts = [];
		Results.model.sortedProducts = [];
		Results.model.filteredProducts = [];

		Results.view.flush();

	},

	getFormData: function(form){
		return form.find(":input:visible, input[type=hidden], :input[data-visible=true]").filter(function(){
			return $(this).val() != "" && $(this).val() != "Please choose...";
		}).serializeArray();
	},

	update: function( jsonResult ) {

		try{

			if(
				Object.byString( jsonResult, Results.settings.paths.results.rootElement ) != "" &&
				Object.byString( jsonResult, Results.settings.paths.results.list ) &&
				( Object.byString( jsonResult, Results.settings.paths.results.list ).length > 0 || typeof( Object.byString( jsonResult, Results.settings.paths.results.list ) ) == "object" )
			) {

				if( Object.byString( jsonResult, Results.settings.paths.results.general ) &&
					Object.byString( jsonResult, Results.settings.paths.results.general ) != "" 
				) {
					Results.model.returnedGeneral = Object.byString( jsonResult, Results.settings.paths.results.general );
					$(Results.settings.elements.resultsContainer).trigger("generalReturned");
				}

				if( !Object.byString( jsonResult, Results.settings.paths.results.list ).length ) {
					// This is stupid... if there are no results it pushes 'no results' into an empty array. It actually puts an empty array inside an array.
					Results.model.returnedProducts = [Object.byString( jsonResult, Results.settings.paths.results.list )];
				} else {
					Results.model.returnedProducts = Object.byString( jsonResult, Results.settings.paths.results.list );
				}

				if( Results.model.currentProduct && Results.model.currentProduct.product ){
					Results.model.returnedProducts.push( Results.model.currentProduct.product );
				}

				// Publish event
				if (typeof meerkat !== 'undefined') {
					meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW);
				}

				$(Results.settings.elements.resultsContainer).trigger("resultsReturned");

				// potentially remove non-available PRODUCTS
				var options = {};
				if (!Results.settings.show.nonAvailableProducts) {
					options[Results.settings.availability.product[0]] = Results.settings.availability.product[1];
					Results.model.addFilter( "availability.product", "value", options );
				}

				// potentially remove non-available PRICES
				options = {}; // reset
				if (!Results.settings.show.nonAvailablePrices) {
					options[Results.settings.availability.price[0]] = Results.settings.availability.price[1];
					Results.model.addFilter( "availability.price." + Results.settings.frequency, "value", options );
				}

				Results.model.filterAndSort(false);

				Results.view.show();

			} else {
				Results.view.showNoResults();
				$(Results.settings.elements.resultsContainer).trigger("noResults");
			}

		}catch(e){
			Results.onError('Sorry, an error occurred updating results', 'Results.js', 'Results.model.update(); '+e.message, e);
		}
		Results.model.resultsLoadedOnce = true;

	},

	filterAndSort: function(renderView){
		Results.model.sort(renderView);
		Results.model.filter(renderView);
		$(Results.settings.elements.resultsContainer).trigger("resultsDataReady");
		if (typeof meerkat !== 'undefined') {
			meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_BEFORE_DATA_READY);
			_.defer(function() {
			meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_DATA_READY);
			});
		}
	},

	sort: function(renderView) {
		// Is sort disabled?
		if (Results.settings.sort.sortBy === false) return false;

		if( Results.model.returnedProducts.length > 0 ){

			if( Results.model.sortedProducts.length > 0 ){
				var previousSortedResults = Results.model.sortedProducts.slice(); // slice forces the copy instead of referencing it
			}

			var results = Results.model.returnedProducts.slice(); // slice forces the copy instead of referencing it

			Results.model.sortedProducts = results.sort( function( resultA, resultB ) {

				var valueA = Object.byString(resultA, Object.byString( Results.settings.paths, Results.settings.sort.sortBy) ) ;
				var valueB = Object.byString(resultB, Object.byString( Results.settings.paths, Results.settings.sort.sortBy) ) ;

				if(isNaN(valueA) || isNaN(valueB)){
					valueA = String(valueA).toLowerCase();
					valueB = String(valueB).toLowerCase();
				}

				// if availability needs to be checked during sorting
				var frequencyPriceAvailability = Results.settings.paths.availability.price[ Results.settings.frequency ];
				if( frequencyPriceAvailability && frequencyPriceAvailability != '' ){

					var availabilityA = Object.byString( resultA, frequencyPriceAvailability );
					var availabilityB = Object.byString( resultB, frequencyPriceAvailability );

					if( availabilityB == 'N' || !valueB || valueB == "" ){
						return -1;
					}

					if( availabilityA == 'N' || !valueA || valueA == "" ){
						return 1;
					}
				}

				if (valueA < valueB){
					returnValue = -1;
				} else if (valueA > valueB){
					returnValue = 1;
				} else if( Results.settings.sort.sortBy.indexOf("price.") == -1 ) {

					var currentFrequencyPricePath = Object.byString( Results.settings.paths, "price." + Results.settings.frequency );

					// values are the same and sortBy != "price", then sort on price
					valueA = Object.byString(resultA, currentFrequencyPricePath );
					valueB = Object.byString(resultB, currentFrequencyPricePath );

					if(valueA == null || valueB == null){
						return 0;
					}
					return valueA - valueB; // return early to avoid the sort direction impact, we sort by asc price by default

				} else {
					returnValue = valueA - valueB;
				}

				if( Results.settings.sort.sortDir == 'desc' ){
					returnValue *= -1;
				}
				return returnValue;
			} );

			if( typeof(previousSortedResults) != "undefined" && renderView !== false){
				Results.view.shuffle( previousSortedResults );
			}

			Results.pagination.gotoStart(true);

		}

	},

	addFilter: function( filterBy, condition, options ){

		if(
			typeof filterBy !== "undefined" &&
			typeof condition !== "undefined" &&
			typeof options !== "undefined" &&
			filterBy !== "" &&
			condition !== ""
		){

			var path = Object.byString( Results.settings.paths, filterBy);

			if( typeof path !== "undefined" ){

				// if a filter already exists with same path and condition, then just update options
				var filterIndex = Results.model.findFilter( path, condition );
				if( filterIndex !== false ){
					Results.model.filters[filterIndex].options = options;
				} else {
					// otherwise add the new filter
					Results.model.filters.push({
						path: path,
						condition: condition,
						options: options
					});
				}

			} else {
				console.log("This filter could not find the path to the property it should be filtered by: filterBy=", filterBy, "| condition=", condition, "| options=", options);
			}

		}

	},

	removeFilter: function( filterBy, condition ){

		if( typeof(filterBy) != "undefined" && typeof(condition) != "undefined" ){

			var path = Object.byString( Results.settings.paths, filterBy);

			if( typeof(path) != "undefined" ){

				var filterIndex = Results.model.findFilter( path, condition );
				if( filterIndex !== false ){
					Results.model.filters.splice( filterIndex, 1 );
				}

			} else {
				console.log("This filter could not find the path to the property it should be unfiltered by: filterBy=", filterBy, "| condition=", condition);
			}

		}

	},

	findFilter: function( path, condition ){

		if( typeof path !== "undefined" && typeof condition !== "undefined" ){

			var filterIndex = false;
			$.each( Results.model.filters, function(index, filter){
				if(filter.path == path && filter.condition == condition){
					filterIndex = index;
					return false; //foreach break
				}
			});
			return filterIndex;

		}

		return false;
	},

	filter: function( renderView ){

		var initialProducts = Results.model.sortedProducts.slice();
		var finalProducts = new Array();

		var valid, value;

		$.each( initialProducts, function( productIndex, product ){

			valid = true;

			$.each( Results.model.filters, function( filterIndex, filter ){

				value = Object.byString( product, filter.path );

				if( typeof value !== "undefined"){
					switch( filter.condition ){
					case "value":
						valid = Results.model.filterByValue( value, filter.options );
						break;
					case "range":
						valid = Results.model.filterByRange( value, filter.options );
						break;
					default:
						console.log("The filter condition type seems to be erroneous");
					break;
					}
				}

				if (!valid) {
					return false;
				}

			});

			if( valid ){
				finalProducts.push(product);
			}

		});

		Results.model.filteredProducts = finalProducts;

		if( typeof Compare !== "undefined" ) Compare.applyFilters();

		if( renderView !== false ){
			if(Results.getFilteredResults().length === 0){
				Results.view.showNoFilteredResults();
				$(Results.settings.elements.resultsContainer).trigger("noFilteredResults");
			}else{
				Results.view.filter();
				Results.pagination.gotoStart(true);
			}

		}
	},

	filterByValue: function(value, options){

		if( !options || typeof options === "undefined" ){
			console.log("Check the parameters passed to Results.model.filterByValue()");
			return true;
		} else {

			if( options.hasOwnProperty('equals') ){
				return value == options.equals;
			} else if( options.hasOwnProperty('notEquals') ){
				return value != options.notEquals;
			} else if( options.hasOwnProperty('inArray') && $.isArray( options.inArray ) ){
				return $.inArray( String( value) , options.inArray ) != -1;
			} else {
				console.log("Options from this value filter are incorrect and has not been applied: ", value, options);
				return true;
			}

		}
	},

	filterByRange: function( value, options ){

		if( !options || typeof(options) == "undefined" ){
			console.log("Check the parameters passed to Results.model.filterByRange()");
			return true;
		} else if( options.hasOwnProperty('min') || options.hasOwnProperty('max') ){
			if( (options.hasOwnProperty('min') && value < options.min) || (options.hasOwnProperty('max') && value > options.max) ){
				return false;
			} else {
				return true;
			}
		} else {
			console.log("Options from this range filter are incorrect and have not been applied: ", value, options);
			return true;
		}

	},

	filterByDateRange: function( value, options ){
		// @todo
	},

	addCurrentProduct: function( product ){

		if( Results.model.currentProduct ) {
			$.extend( Results.model.currentProduct, {
				product: product
			});
		} else {
			Results.model.currentProduct = new Object();
			Results.model.currentProduct = { product: product };
		}

	},

	setCurrentProduct: function( identifierPathName, currentProduct ){

		if( Results.model.currentProduct ) {
			$.extend( Results.model.currentProduct, {
				path: Object.byString( Results.settings.paths, identifierPathName ),
				value: currentProduct
			});
		} else {
			Results.model.currentProduct = new Object();
			Results.model.currentProduct = {
				path: Object.byString( Results.settings.paths, identifierPathName ),
				value: currentProduct
			};
		}

	},

	setSelectedProduct: function( productId ){
		return Results.model.selectedProduct = Results.model.getResult( "productId", productId );
	},

	removeSelectedProduct: function(){
		Results.model.selectedProduct = false;
	},

	getResult: function( identifierPathName, value, returnIndex ){

		var result = false;
		var resultIndex = false;
		$.each( Results.model.returnedProducts, function(index, product){
			var productValue = Object.byString( product, Object.byString( Results.settings.paths, identifierPathName ) );
			if( productValue == value ){
				result = product;
				resultIndex = index;
				return false;
			}
		});

		if( returnIndex ){
			return resultIndex;
		} else {
			return result;
		}

	},

	getResultIndex: function( identifierPathName, value ){
		return Results.model.getResult( identifierPathName, value, true );
	},

	setFrequency: function( frequency, refreshView ){

		Results.settings.frequency = frequency;

		if(refreshView !== false ){
			Results.view.toggleFrequency( frequency );
		}

	},

	startResultsFetch: function() {
		if(typeof meerkat != 'undefined') {
			meerkat.messaging.publish(Results.model.moduleEvents.WEBAPP_LOCK, { source: 'resultsModel' });
	}
		$(Results.settings.elements.resultsContainer).trigger("resultsFetchStart");
	},

	finishResultsFetch: function() {
		if (typeof Loading !== "undefined") Loading.hide();
		if(typeof meerkat != 'undefined') {
			_.defer(function() {
				meerkat.messaging.publish(Results.model.moduleEvents.WEBAPP_UNLOCK, { source: 'resultsModel' });
			});
		}
		$(Results.settings.elements.resultsContainer).trigger("resultsFetchFinish");
	},

	publishResultsDataReady: function() {
		if(typeof meerkat !== 'undefined') {
			$(Results.settings.elements.resultsContainer).trigger("resultsReturned");
			meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_DATA_READY);
		}
	}
};