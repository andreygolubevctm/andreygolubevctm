var ResultsModel = new Object();
ResultsModel = {

	returnedProducts: false,
	filteredProducts: false,
	sortedProducts: false,

	currentProduct: false,
	selectedProduct: false,
	filters: new Array(),

	resultsLoadedOnce: false,

	/* url and data are optional */
	fetch: function( url, data ) {
		$(Results.settings.elements.resultsContainer).trigger("resultsFetchStart");

		try{
			Results.model.flush();
			if(typeof Loading !== "undefined") Loading.show(Results.settings.dictionary.loadingMessage);
			if(typeof Compare !== 'undefined') Compare.reset();

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
				} else {
					data = Results.model.getFormData( $(Results.settings.formSelector) );
				}
			}
		}catch(e){
			Results.onError('Sorry, an error occurred fetching results', 'Results.js', 'Results.fetch(); '+e.message, e);
		}

		if(Results.model.resultsLoadedOnce == true){

			if(url.indexOf('?') == -1){
				url += '?id_handler=increment_tranId';
			}else{
				url += '&id_handler=increment_tranId';
			}
		}

		$.ajax({
			url: url,
			data: data,
			type: "POST",
			async: true,
			dataType: "json",
			cache: false,
			success: function(jsonResult){
				try{
					if(jsonResult && jsonResult.messages && jsonResult.messages.length > 0){
						// if there are error messages returned by the web services, register them
						// @todo = these errors used to be done this way through Ajax on Utilities. They really should be checked through the fetched URL jsp on the back end side
						// so get rid of this empty if() and add the check on the soap aggregator returned XML
					}

					if(typeof jsonResult.error !== 'undefined' && jsonResult.error.type == "validation") {
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
				}
				catch(e){
					Results.model.handleFetchError( data, "Try/Catch fail on success: "+e.message );
				}

				if (typeof referenceNo !== 'undefined') {
					var newTranID = 0;
					if (jsonResult.hasOwnProperty('results') && jsonResult.results.hasOwnProperty('info') && jsonResult.results.info.hasOwnProperty('transactionId')) {
						newTranID = jsonResult.results.info.transactionId;
					}
					else if (jsonResult.hasOwnProperty('error') && jsonResult.error.hasOwnProperty('transactionId')) {
						newTranID = jsonResult.error.transactionId;
					}
					if (newTranID !== 0) {
						referenceNo.setTransactionId(newTranID);
					}
				}
			},
			error: function(jqXHR, txt, errorThrown){
				Results.model.handleFetchError( data, "AJAX request failed: " + txt + " " + errorThrown );
			},
			complete: function(){
				if (typeof Loading !== "undefined") Loading.hide();
				$(Results.settings.elements.resultsContainer).trigger("resultsFetchFinish");
			}
		});

	},

	handleFetchError: function( data, description ){
		if( typeof(Loading) != "undefined") Loading.hide();
		Results.reviseDetails();
		Results.onError("Sorry, an error occurred when fetching quotes", "common/js/Results.js for " + Results.settings.vertical, "Results.fetch(). " + description, data);

	},

	reset: function(){

		Results.model.flush();

		Results.model.currentProduct = false;
		Results.settings.frequency = 'annual';
		Results.model.filters = [];

	},

	flush: function(){

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

				if( !Object.byString( jsonResult, Results.settings.paths.results.list ).length ) {
					Results.model.returnedProducts = [Object.byString( jsonResult, Results.settings.paths.results.list )];
				} else {
					Results.model.returnedProducts = Object.byString( jsonResult, Results.settings.paths.results.list );
				}

				if( Results.model.currentProduct && Results.model.currentProduct.product ){
					Results.model.returnedProducts.push( Results.model.currentProduct.product );
				}

				$(Results.settings.elements.resultsContainer).trigger("resultsReturned");

				// potentially remove non available products
				var options = {};

				if( !Results.settings.show.nonAvailableProducts ){
					options[Results.settings.availability.product[0]] = Results.settings.availability.product[1];
					Results.model.addFilter( "availability.product", "value", options );
				}

				options = {}; // reset
				if( !Results.settings.show.nonAvailablePrices ){
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


	},

	sort: function(renderView){

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
					//console.log(value, filter.options, product);
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

	}
};