var ResultsModel = {
	ajaxRequest: false,

	returnedGeneral: false,
	isBlockedQuote: false,
	returnedProducts: false,
	filteredProducts: false,
	sortedProducts: false,
	hasValidationErrors : false,
	currentProduct: false,
	selectedProduct: false,
	pinnedProduct: false,
	filters: [],
	availablePartners: [],

	resultsLoadedOnce: false,

	moduleEvents: {
		WEBAPP_LOCK: 'WEBAPP_LOCK',
		WEBAPP_UNLOCK: 'WEBAPP_UNLOCK',
		RESULTS_DATA_READY: 'RESULTS_DATA_READY',
		RESULTS_BEFORE_DATA_READY: 'RESULTS_BEFORE_DATA_READY',
		RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW: 'RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW',
		RESULTS_UPDATED_INFO_RECEIVED: 'RESULTS_UPDATED_INFO_RECEIVED'
	},

    handleValidationError: function(jsonResult) {
		if (typeof Loading !== "undefined") {
                    Loading.hide();
                }

		Results.model.hasValidationErrors = typeof( Object.byString(jsonResult, Results.settings.paths.results.errors) ) === 'object';

		Results.reviseDetails();
		meerkat.modules.serverSideValidationOutput.outputValidationErrors({
			validationErrors: jsonResult.error.errorDetails.validationErrors,
			startStage: 'start'
		});
	},

	/* url and data are optional */
	fetch: function( url, data ) {
		Results.model.startResultsFetch();

		try{
			Results.model.flush();

			if (Results.settings.runShowResultsPage === true) {
				Results.view.showResultsPage();
			}

			// @todo = 2 different locations change the URL, which one is correct?
			try{
				// TODO REMOVE
				$.address.parameter("stage", "results", false );
			}catch(e){
				// ok
			}
			if( typeof url == "undefined" ){
				url = Results.settings.url;
			}

			if( typeof data == "undefined" ){
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
			}
		}catch(e){
			Results.onError('Sorry, an error occurred fetching results', 'Results.js', 'Results.model.fetch(); '+e.message, e);
		}

		if(Results.model.resultsLoadedOnce === true){
			var hasIncTranIdSetting = Results.settings.hasOwnProperty('incrementTransactionId');
			if(!hasIncTranIdSetting || (hasIncTranIdSetting && Results.settings.incrementTransactionId === true)) {
				url += (url.indexOf('?') == -1 ? '?' : '&') + 'id_handler=increment_tranId';
			}
		}

		var request = {
			url: url,
			data: data,
			type: "POST",
			async: true,
			dataType: "json",
			cache: false,
			success: function(jsonResult){
				Results.model.updateTransactionIdFromResult(jsonResult);
				meerkat.modules.verificationToken.readTokenFromResponse(jsonResult);

				if( typeof meerkat != 'undefined') {
					if (jsonResult.hasOwnProperty('results')) {
						if(jsonResult.results.hasOwnProperty('info')) {
							Results.model.isBlockedQuote = (typeof jsonResult.results.info !== "undefined" && typeof jsonResult.results.info.blocked === "boolean" && jsonResult.results.info.blocked === true);
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
					// TODO: this is health only and really doesn't belong here
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

					}  else if(typeof meerkat.modules.serverSideValidationOutput !== 'undefined' && typeof jsonResult.error !== 'undefined' && jsonResult.error.type == "validation") {
						Results.model.handleValidationError(jsonResult);
					} else if(typeof jsonResult.error !== 'undefined') {
						meerkat.modules.verificationToken.readIfTokenError(jsonResult.error);
					} else if( !jsonResult || typeof( Object.byString( jsonResult, Results.settings.paths.results.rootElement ) ) == "undefined" ){
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
			error: function(jqXHR, txt, errorThrown) {
				var jsonResult = {};
				try {
					jsonResult = $.parseJSON(jqXHR.responseText);
				} catch (error) {}
                Results.model.ajaxRequest = false;
                if(typeof meerkat.modules.serverSideValidationOutput !== 'undefined' && jsonResult.type == "validation") {
                    Results.model.handleValidationError({error : jsonResult});
                }
				// status/readyState can be 0 if abort OR if timeout, so check for timeout only.
				else if (jqXHR.status === 429) {
					Results.model.isBlockedQuote = true;
				} else if ((jqXHR.status !== 0 && jqXHR.readyState !== 0) || txt == 'timeout') { // is an error or timeout
					Results.model.handleFetchError( data, "AJAX request failed: " + txt + " " + errorThrown );
				}
			},
			complete: function(){
				Results.model.ajaxRequest = false;
				Results.model.finishResultsFetch();
			}
		};
		meerkat.modules.verificationToken.addTokenToRequest(request);
		Results.model.ajaxRequest = $.ajax(request);

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
			meerkat.modules.transactionId.set(newTranID);
		}
	},

	handleFetchError: function( data, description ){
		if (typeof Loading !== "undefined") Loading.hide();
		Results.reviseDetails();
		var callString = '';
		if(typeof meerkat !== 'undefined' && typeof meerkat.site !== 'undefined'
			&& typeof meerkat.site.content !== 'undefined' && typeof meerkat.site.content.callCentreHelpNumber != 'undefined' && meerkat.site.content.callCentreHelpNumber.length > 0) {
			callString = 'If the problem persists, please feel free to discuss your comparison needs with our call centre on ' + meerkat.site.content.callCentreHelpNumber + '.';
		}
		Results.onError("Sorry, an error occurred while retrieving your results.<br />Please close this message and try again. " + callString, "common/js/Results.js for " + Results.model.getVertical(), "Results.model.fetch(). " + description, data);
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
		Results.model.customFilteredProducts = [];
		Results.model.popularProducts = [];

		Results.view.flush();

	},

	getFormData: function(form){
		return form.find(":input:visible, input[type=hidden], :input[data-visible=true]").filter(function(){
			return $(this).val() !== "" && $(this).val() != "Please choose...";
		}).serializeArray();
	},

	update: function( jsonResult ) {

		try{

			if(
				Object.byString( jsonResult, Results.settings.paths.results.rootElement ) !== "" &&
				Object.byString( jsonResult, Results.settings.paths.results.list ) &&
				( Object.byString( jsonResult, Results.settings.paths.results.list ).length > 0 || typeof( Object.byString( jsonResult, Results.settings.paths.results.list ) ) == "object" )
			) {
				var isEmptyArray = false;

				if( Object.byString( jsonResult, Results.settings.paths.results.general ) &&
					Object.byString( jsonResult, Results.settings.paths.results.general ) !== ""
				) {
					Results.model.returnedGeneral = Object.byString( jsonResult, Results.settings.paths.results.general );
					$(Results.settings.elements.resultsContainer).trigger("generalReturned");
				}

				if( !Object.byString( jsonResult, Results.settings.paths.results.list ).length ) {
					// This is stupid... if there are no results it pushes 'no results' into an empty array. It actually puts an empty array inside an array.
					Results.model.returnedProducts = [Object.byString( jsonResult, Results.settings.paths.results.list )];
					//is because of this that a flag gets place here so that we can explicitly not display results otherwise we get exception message.
				} else {
					Results.model.returnedProducts = Object.byString( jsonResult, Results.settings.paths.results.list );
				}

				if (Results.model.returnedProducts.length === 0) {
					isEmptyArray = true;
				}

				if( Results.model.currentProduct && Results.model.currentProduct.product ){
					Results.model.returnedProducts.push( Results.model.currentProduct.product );
				}

				var availableCounts = 0;
				_.each(Results.model.returnedProducts, function updateResultsModelProperties(obj){
					// Store the provider code if the partner returns at least 1 product
					if (Results.settings.paths.results.providerCode !== false) {
						// Update available partners
						if (obj.available == 'Y' && !_.contains(Results.model.availablePartners, obj[Results.settings.paths.results.providerCode])) {
							Results.model.availablePartners.push(obj[Results.settings.paths.results.providerCode]);
						}
					}
					// Update available count
					if (obj.available === 'Y' && obj.productId !== 'CURR') {
						availableCounts++;
					}
				});

				Results.model.availableCounts = availableCounts;

				// Publish event
				meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW);

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

				if ((Results.settings.sort.randomizeMatchingPremiums === true)) {

					// do a pre-sort first as working on the returned products won't work because all the products are returned grouped by provider
					// this is done to sort by price
					Results.model.sort(false);

					// if cover level tabs is used for another vertical, we sort and arrange price according to group.
					if (meerkat.modules.coverLevelTabs.isEnabled()) {
						var priceNode = typeof Results.settings.paths.price.premium !== 'undefined' ? Results.settings.paths.price.premium : Results.settings.paths.price.annually;

						// sort the products by cover level first and if need be, sort by price
						Results.model.sortedProducts = Results.model.sortedProducts.sort(function(a, b) {
							if ((typeof a !== 'undefined' && typeof b !== 'undefined') && (a.available === 'Y' && b.available === 'Y')) {
								return (a[priceNode] - b[priceNode]);
							}

							return 0;
						});
					}

					var  currentProduct,
						previousProduct,
						newProductOrder = [],
						startIndex = 0,
						endIndex = 0,
						priceMatch = false,
						tempProductOrder = [];

					// loop through all the sorted products
					_.each(Results.model.sortedProducts, function massageSortedProducts(result, index){

						// alternate any pricing results if two or more results have the exact same price
						previousProduct = currentProduct;
						currentProduct = result;

						if ((typeof previousProduct !== 'undefined' && typeof currentProduct !== 'undefined')  && (previousProduct.available == 'Y' && currentProduct.available == 'Y')
							&& (previousProduct.service != currentProduct.service) && (previousProduct.price == currentProduct.price)
						) {
							if (!priceMatch) priceMatch = true;

							// set the startIndex once
							if (startIndex === 0) {
								startIndex = index - 1;
								tempProductOrder.push(previousProduct);
							}

							// keep updating the endIndex
							endIndex = index;
							tempProductOrder.push(currentProduct);
						} else {
							if (priceMatch) {
								newProductOrder  = Results.model.shuffleResults(tempProductOrder,newProductOrder,startIndex,endIndex);
								// reset the vars
								startIndex = 0;
								endIndex = 0;
								priceMatch = false;
								tempProductOrder = [];
							}

							// and add the current product as per normal
							newProductOrder[index] = result;
						}

					});
					// If the last two products contain the same price we need to force it to shuffle results
					if(priceMatch) {
						newProductOrder  = Results.model.shuffleResults(tempProductOrder,newProductOrder,startIndex,endIndex);
					}
					Results.model.returnedProducts = newProductOrder; // set the new order (if there was a re-order)
					Results.model.sortedProducts = []; // reset the sortedProducts array
				}

				if(!isEmptyArray) {

					Results.model.filterAndSort(false);

					Results.view.show();
				}
				else {
					Results.view.showNoResults();
					$(Results.settings.elements.resultsContainer).trigger("noResults");
				}

			} else {
				Results.view.showNoResults();
				$(Results.settings.elements.resultsContainer).trigger("noResults");
			}

		}catch(e){
			Results.onError('Sorry, an error occurred updating results', 'Results.js', 'Results.model.update(); '+e.message, e);
		}
		Results.model.resultsLoadedOnce = true;

	},

	shuffleResults: function(tempProductOrder,newProductOrder,startIndex,endIndex) {

		// Fisher-Yates (aka Knuth) Shuffle. Everyday shufflin' ...
		var currentIndex = tempProductOrder.length, temporaryValue, randomIndex ;

		// While there remain elements to shuffle...
		while (0 !== currentIndex) {

			// Pick a remaining element...
			randomIndex = Math.floor(Math.random() * currentIndex);
			currentIndex -= 1;

			// And swap it with the current element.
			temporaryValue = tempProductOrder[currentIndex];
			tempProductOrder[currentIndex] = tempProductOrder[randomIndex];
			tempProductOrder[randomIndex] = temporaryValue;
		}

		// put the sorted products into the newProductOrder array
		for (var i = startIndex; i <= endIndex; i++) {
			newProductOrder[i] = tempProductOrder.shift();
		}
		return newProductOrder;



	},

	filterAndSort: function(renderView){
		Results.model.sort(renderView);
		Results.model.filter(renderView);
		$(Results.settings.elements.resultsContainer).trigger("resultsDataReady");
		meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_BEFORE_DATA_READY);
		_.defer(function() {
			meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_DATA_READY);
		});
	},

	sort: function(renderView) {
		// Is sort disabled?
		if (Results.settings.sort.sortBy === false) return false;

		if( Results.model.returnedProducts.length > 0 ){
			var previousSortedResults;
			if( Results.model.sortedProducts.length > 0 ){
				previousSortedResults = Results.model.sortedProducts.slice(); // slice forces the copy instead of referencing it
			}

			var results = Results.model.returnedProducts.slice(); // slice forces the copy instead of referencing it
			var sortByMethod = typeof Results.getSortByMethod() === 'function' ? Results.getSortByMethod() : Results.model.defaultSortMethod();

			Results.model.sortedProducts = results.sort(sortByMethod);

			if( typeof previousSortedResults != "undefined" && renderView !== false){
				Results.view.shuffle( previousSortedResults );
			}

			Results.pagination.gotoStart(true);

			var config = Results.settings.rankings;
			if(_.isObject(config) && config.hasOwnProperty("resultsSortedModelToUse") && !_.isUndefined(Results.model[config.resultsSortedModelToUse]) && _.isArray(Results.model[config.resultsSortedModelToUse])) {
				Results.model[config.resultsSortedModelToUse] = Results.model[config.resultsSortedModelToUse].sort(sortByMethod);
			}
		}

	},

	defaultSortMethod: function(resultA, resultB) {
		var resultsData = null;
		var returnedResults = null;

		if (Results.model.landlordFilter != null && (resultA.available === 'Y' || resultB.available === 'Y')) {
			resultsData = {
				a: resultA,
				b: resultB
			};
			returnedResults = Results.model.landlordFilter(resultsData);
			if (returnedResults) {
				resultA = returnedResults.resultA;
				resultB = returnedResults.resultB;
			}
		}

		var valueA = Object.byString(resultA, Object.byString( Results.settings.paths, Results.settings.sort.sortBy) ) ;
		var valueB = Object.byString(resultB, Object.byString( Results.settings.paths, Results.settings.sort.sortBy) ) ;
		var returnValue;

		if(isNaN(valueA) || isNaN(valueB)){
			valueA = String(valueA).toLowerCase();
			valueB = String(valueB).toLowerCase();
		}

		// if availability needs to be checked during sorting
		var frequencyPriceAvailability = Results.settings.paths.availability.price[ Results.settings.frequency ];
		if( frequencyPriceAvailability && frequencyPriceAvailability !== '' ) {

			var availabilityA = Object.byString( resultA, frequencyPriceAvailability );
			var availabilityB = Object.byString( resultB, frequencyPriceAvailability );

			if( availabilityB == 'N' || !valueB || valueB === "" ){
				return -1;
			}

			if( availabilityA == 'N' || !valueA || valueA === "" ){
				return 1;
			}
		}

		// sorting for real & wool for home & contents
		if (Results.model.homeCustomSort != null) {
			resultsData = {
				brandCodes: [resultA.brandCode, resultB.brandCode],
				values: [valueA, valueB]
			};

			returnedResults = Results.model.homeCustomSort(resultsData);
			// only returns a value if real and wool have the same premium
			if (returnedResults) {
				return returnedResults;
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

			if(typeof valueA =="undefined" || typeof valueB == "undefined"){
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
	},
	landlordFilter: null,
	homeCustomSort: null,
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

	filter: function( renderView, doNotGoToStart ){

		var getFilteredProducts = function(products) {

			var filteredProducts=[], valid, value;

			$.each(products, function (productIndex, product) {

				valid = true;

				$.each(Results.model.filters, function (filterIndex, filter) {

					value = Object.byString(product, filter.path);

					if (typeof value !== "undefined") {
						switch (filter.condition) {
							case "value":
								valid = Results.model.filterByValue(value, filter.options);
								break;
							case "range":
								valid = Results.model.filterByRange(value, filter.options);
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

				if (valid) {
					filteredProducts.push(product);
				}

			});

			return filteredProducts;
		};


		var initialProducts = Results.model.sortedProducts.slice();
		Results.model.filteredProducts = getFilteredProducts(initialProducts);

		if( typeof Compare !== "undefined" ) Compare.applyFilters();

		if( renderView !== false ) {
			if(Results.getFilteredResults().length === 0){
				Results.view.showNoFilteredResults();
				$(Results.settings.elements.resultsContainer).trigger("noFilteredResults");
			}else{
				Results.view.filter();
                if (doNotGoToStart === true) { return; }
				Results.pagination.gotoStart(true);
			}

		}

		var config = Results.settings.rankings;
		if(_.isObject(config) && config.hasOwnProperty("resultsFilteredModelToUse") && !_.isUndefined(Results.model[config.resultsFilteredModelToUse]) && _.isArray(Results.model[config.resultsFilteredModelToUse])) {
			initialProducts = Results.model[config.resultsFilteredModelToUse];
			Results.model[config.resultsFilteredModelToUse] = getFilteredProducts(initialProducts);
		}

	},

    filterUsingExcess: function( renderView, doNotGoToStart ){

        var initialProducts = Results.model.sortedProducts.slice();
        var finalProducts = [];

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

            if( valid ) {
                $.each(product.benefits, function (index, benefit) {
                    if (benefit.type == 'EXCESS' && benefit.value <= Results.model.travelFilters.EXCESS) {
                        finalProducts.push(product);
                    }
                });
            }

        });

        Results.model.filteredProducts = finalProducts;

        if( typeof Compare !== "undefined" ) Compare.applyFilters();

        if( renderView !== false ) {
            if(Results.getFilteredResults().length === 0){
                Results.view.showNoFilteredResults();
                $(Results.settings.elements.resultsContainer).trigger("noFilteredResults");
            }else{
                Results.view.filter();
                if (doNotGoToStart === true) { return; }
                Results.pagination.gotoStart(true);
            }

        }
    },

    travelResultFilter: function (renderView, doNotGoToStart, matchAllFilters) {
        var initialProducts = Results.model.sortedProducts.slice();
        var destination = $('#travel_destination').val();

        var finalProducts = [];
        var _filters = {
            EXCESS: 0,
            LUGGAGE: 0,
            CXDFEE: 0,
            MEDICAL: 0,
            RENTALVEHICLE: 0
        };
        var _modelFilters = Results.model.travelFilters;

        $.each(initialProducts, function (productIndex, product) {
            if (product.available == 'Y' && $.isArray(product.benefits) && product.benefits.length !== 0) {

              // Reset the Rental vehicle benfit value
              _filters.RENTALVEHICLE = 0;

                $.each(product.benefits, function (index, benefit) {
                    switch (benefit.type) {
                        case 'EXCESS':
                            _filters.EXCESS = benefit.value;
                            break;
                        case 'LUGGAGE':
                            _filters.LUGGAGE = benefit.value;
                            break;
                        case 'CXDFEE':
                            _filters.CXDFEE = benefit.value;
                            break;
                        case 'MEDICAL':
                            _filters.MEDICAL = benefit.value;
                            break;
                        case 'RENTALVEH':
                            _filters.RENTALVEHICLE = benefit.value;
                            break;
                        case 'RENTAL_EXCESS':
                            _filters.RENTALVEHICLE = benefit.value;
                            break;
                        case 'CUSTOM':
                            if(benefit.label.toLowerCase().indexOf('rental car') > -1 ||
                            	 benefit.label.toLowerCase().indexOf('rental vehicle') > -1) {
                            	_filters.RENTALVEHICLE = benefit.value;
                            }
                            break;

                    }
                });

				if (matchAllFilters) {
                    if ((_filters.EXCESS <= _modelFilters.EXCESS) &&
                       ((_filters.LUGGAGE >= _modelFilters.LUGGAGE) &&
                        (_filters.CXDFEE >= _modelFilters.CXDFEE) &&
                        ((destination !== 'AUS' && _filters.MEDICAL >= _modelFilters.MEDICAL) || 
                         (destination === 'AUS' && _filters.RENTALVEHICLE >= _modelFilters.RENTALVEHICLE)) &&
                        (_modelFilters.PROVIDERS.indexOf(product.serviceName) == -1))) {
                        finalProducts.push(product);
                    }
				} else {
                    if ((_filters.EXCESS <= _modelFilters.EXCESS) &&
                       ((_filters.LUGGAGE >= _modelFilters.LUGGAGE) ||
                        (_filters.CXDFEE >= _modelFilters.CXDFEE) ||
                        (_filters.MEDICAL >= _modelFilters.MEDICAL) ||
                        (_filters.RENTALVEHICLE >= _modelFilters.RENTALVEHICLE)) &&
                        (_modelFilters.PROVIDERS.indexOf(product.serviceName) == -1)) {
                        finalProducts.push(product);
                    }
				}

            }
        });

        Results.model.filteredProducts = finalProducts;
				Results.model.travelFilteredProductsCount = finalProducts.length;
				meerkat.modules.travelResults.setColVisibilityAndStylesByTravelType(destination === 'AUS');

        if (typeof Compare !== "undefined") Compare.applyFilters();

        if (renderView !== false) {
            if (Results.getFilteredResults().length === 0) {
                Results.view.showNoFilteredResults();
                $(Results.settings.elements.resultsContainer).trigger("noFilteredResults");
            } else {
                Results.view.filter();
                if (doNotGoToStart === true) {
                    return;
                }
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
			} else if( options.hasOwnProperty('notInArray') && $.isArray( options.notInArray ) ){
				return $.inArray( String( value) , options.notInArray ) == -1;
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

	addCurrentProduct: function( product ){

		if( Results.model.currentProduct ) {
			$.extend( Results.model.currentProduct, {
				product: product
			});
		} else {
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

	setPinnedProduct: function( product ) {
		return Results.model.pinnedProduct = product;
	},

	removePinnedProduct: function() {
		Results.model.pinnedProduct = false;
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
		} else if (result) {
			return result;
		} else if (Results.getPinnedProduct().productId === value) {
			return Results.getPinnedProduct();
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
		_.defer(function() {
			meerkat.messaging.publish(Results.model.moduleEvents.WEBAPP_UNLOCK, { source: 'resultsModel' });
		});
		$(Results.settings.elements.resultsContainer).trigger("resultsFetchFinish");
	},

	publishResultsDataReady: function() {
		$(Results.settings.elements.resultsContainer).trigger("resultsReturned");
		meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_DATA_READY);
	}
};
