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
var Results = new Object();
Results = {

	view: new Object(),
	model: new Object(),

	init: function( userSettings ){

		Results.view = ResultsView;
		Results.model = ResultsModel;

		var settings = {
			url: "ajax/json/results.jsp", // where to get results from
			formSelector: "#mainform",
			paths: {
				results: {
					rootElement: "results",
					list: "results.result"
				},
				price: { // result object path to the price property
					annual: "price.annual.total",
					monthly: "price.monthly.total",
					fortnightly: "price.fortnightly.total",
					weekly: "price.weekly.total",
					daily: "price.daily.total"
				},
				availability: { // result object path to the price availability property if any (setting it will also enable sorting by availability)
					price:{
						annual: "price.annual.available",
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
				sortBy: "price.annual",
				sortDir: "asc"
			},
			frequency: "annual",
			displayMode: "price",
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
						duration: 1000,
						percentage: 1 // 1 = 100%, 0.5 = 50%, etc. this is relative to the size of the visible container
					}
				}
			},
			elements: {
				page: "#resultsPage",
				container: ".results-table",
				rows: ".result-row",
				templates: {
					result: "#result-template",
					unavailable: "#unavailable-template",
					currentProduct: "#current-product-template",
					feature: "#feature-template"
				},
				noResults: ".noResults",
				resultsFetchError: ".resultsFetchError",
				leftNav: ".resultsLeftNav",
				rightNav: ".resultsRightNav",
				resultsContainer: ".resultsContainer",
				resultsOverflow: ".resultsOverflow",
				features: {
					headers: ".featuresHeaders",
					list: ".featuresList",
					allElements: ".featuresElements",
					expandable: ".expandable",
					expandableHover: ".expandableHover",
					values: ".featuresValues",
					extras: ".featuresExtras"
				}
			},
			show: {
				featuresComparison: false,
				featuresCategories: true,
				topResult: true,
				currentProduct: true,
				nonAvailableProducts: true,
				nonAvailablePrices: true,
				savings: true
			},
			dictionary:{
				loadingMessage: "Loading Your Quotes..."
			}
		};
		$.extend(true, settings, userSettings);

		Results.settings = settings;

		Results.view.$containerElement = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container );

		/* ACTIONS */

			// features navigation
			$( Results.settings.elements.leftNav + "," + Results.settings.elements.rightNav ).on("click", function(){

				Results.view.scrollResults( $(this) );

			});

	},

	/* url and data are optional */
	get: function( url, data ){
		Results.model.fetch( url, data );
	},

	render: function(){
		Results.view.show();
	},

	reset: function() {

		$(Results.settings.elements.resultsContainer).trigger("resultsReset");

		// @todo = find a way to reset all the values relying on the settings (e.g. Results.settings.sort.sortBy Results.settings.frequency, etc.)
		// i.e. reset to default settings extended with userSettings
		Results.model.flush();


		QuoteEngine.updateAddress();

	},

	reviseDetails: function(){
		QuoteEngine.setOnResults(false);

		if( Compare && typeof(Compare) != "undefined" ) {
			Compare.reset();
		}
		Results.view.toggleResultsPage();

		Results.reset();
	},

	// to change the sortBy value, the path needs to be set in Results.settings.paths first
	// i.e. Results.settings.paths = "path.to.name.property.in.result.object" then change Results.settings.sort.sortBy = "name"
	sortBy: function( sortBy, sortDir ){
		// check that we know the path to the sortBy property in the result object
		if( typeof( Object.byString( Results.settings.paths, sortBy) ) != "undefined" ){
			Results.settings.sort.sortBy = sortBy;
			if( sortDir && sortDir.length > 0 && $.inArray(sortDir, ["asc","desc"]) != -1 ) {
				Results.settings.sort.sortDir = sortDir;
			}
			Results.model.sort();
		} else {
			console.log("The sortBy function has been called but it could not find the path to the property it should be sorted by: sortBy=", sortBy,"| sortDir=", sortDir);
		}
	},

	getSortBy: function(){
		return Results.settings.sort.sortBy;
	},

	getSortDir: function(){
		return Results.settings.sort.sortDir;
	},

	filterBy: function( filterBy, condition, options, renderView ){
		if( typeof( Object.byString( Results.settings.paths, filterBy ) ) != "undefined" ){
			Results.model.addFilter( filterBy, condition, options );
			if( renderView ){
				Results.model.filter();
			}
		} else {
			console.log("This filter could not find the path to the property it should be filtered by: filterBy= filterBy=", filterBy, "| condition=", condition, "| options=", options);
		}
	},

	unfilterBy: function( filterBy, condition, renderView ){
		if( typeof( Object.byString( Results.settings.paths, filterBy ) ) != "undefined" ){
			Results.model.removeFilter( filterBy, condition );
			if( renderView ){
				Results.model.filter();
			}
		} else {
			console.log("This filter could not find the path to the property it should be unfiltered by: filterBy=", filterBy, "| condition=", condition);
		}

	},

	getFrequency: function(){
		return Results.settings.frequency;
	},

	setFrequency: function( frequency ){

		// if we don't want the unavailable prices to be displayed
		if( !Results.settings.show.nonAvailablePrices ){
			// remove all the previously added filters on price availability for frequency
			$.each(Results.settings.paths.price, function( currentFrequency, pricePath ){
				Results.unfilterBy( "availability.price." + currentFrequency, "value" );
			});
			// apply the selected frequency's availability filter
			Results.filterBy( "availability.price." + frequency, "value", {equals: "Y"}, true );
		}

		// record new selected frequency and sort by this frequency's price
		Results.settings.frequency = frequency;
		Results.sortBy( "price." +  frequency );

	},

	addCurrentProduct: function( identifierPathName, product ){

		Results.model.addCurrentProduct( product );
		Results.setCurrentProduct( identifierPathName, Object.byString( product, identifierPathName ) );

	},

	removeCurrentProduct: function() {
		Results.model.currentProduct = false;
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

	getResultByIndex: function( productIndex ){
		return Results.model.returnedProducts[ productIndex ];
	},

	getTopResult: function(){
		return Results.model.sortedProducts && Results.model.sortedProducts.length > 0 ? Results.model.sortedProducts[0] : false;
	},

	getReturnedResults: function(){
		return Results.model.returnedProducts;
	},

	getSortedResults: function(){
		return Results.model.sortedProducts;
	},

	getFilteredResults: function(){
		return Results.model.filteredProducts;
	},

	setDisplayMode: function( mode ){
		Results.view.setDisplayMode( mode );
	},

	isResultDisplayed: function (resultModel){

		if( $.inArray( resultModel, Results.model.filteredProducts ) == -1 ){
			return false;
		}

		return true;
	},

	onError:function(message, page, description, data){

		FatalErrorDialog.exec({
			message:		message,
			page:			page,
			description:	description,
			data:			data
		});

	}

};