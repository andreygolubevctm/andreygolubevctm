var Compare = new Object();
Compare = {

	view: false,
	model: false,
	settings: false,

	topPosition: false,

	

	init: function( userSettings ){

		Compare.view = CompareView;
		Compare.model = CompareModel;

		var settings = {
			paths: {
				features: "features"
			},
			animation: {
				add: {
					speed: 400, // speed of the animation when adding a product to the comparison bar
					easing: "easeInOutQuart" // easing of the animation when adding a product to the comparison bar
				},
				remove: {
					type: "explode",
					speed: 400, // speed of the animation when adding a product to the comparison bar
					options: {
						easing: "easeInOutQuart",
						pieces: 16
					}
				},
				open: {
					options: {
						effect: "slide",
						direction: "up"
					}
				},
				close: {
					options: {
						effect: "slide",
						direction: "up",
						complete: function(){
							$(Compare.settings.elements.container).show().css("position", "absolute").css("left", "-20000px");
						}
					}
				}
			},
			compareBarRenderer:IconsModeCompareBarRenderer,
			elements: {
				container: "#compare-results",
				button: ".compareBtn",
				bar: ".compareBar",
				boxes: ".compareBox",
				companyImage: ".companyImage",
				savings: ".savemsg",
				savingsValue: "#save_val",
				compareTable: "#compareTableData",
				featureValuesContainer: ".featureValuesContainer",
				featuresValues: ".featuresValues",
				templates: {
					product: "#compare-product-column-template",
					featureRow: "#feature-row-template",
					featureExtraRow: "#feature-extra-row-template",
					feature: "#feature-template",
					featureExtra: "#extra-feature-template",
					featureHeader: "#feature-header-template"
				}
			},
			minimum: 2,
			maximum: 3,
			dictionary:{
				compareLabel: "Compare",
				clearBasketLabel: "Back to all results"
			}
		};
		$.extend(true, settings, userSettings);

		Compare.settings = settings;

		/* SET EVENTS */
		$(document).on("click", ".compareCloseIcon", function(){
			// TODO THIS MIGHT NEED TO BE DEPENDANT ON RENDERER TYPE
			var productId;

			if(typeof $(this).attr('data-productId') !== 'undefined'){
				productId = $(this).attr('data-productId');
			}else{
				productId = $(this).siblings(".compareBoxLogo").find("img").attr("data-productId");
			}
			
			Compare.remove( productId );
		});

		$(Results.settings.elements.resultsContainer).on("resultsReset", function(){
			Compare.reset();
		});

	},

	add: function( product ) {
		Compare.model.add( product );
	},

	remove: function( productId ){
		Compare.model.remove( productId );
	},

	reset: function(){
		Compare.view.reset();
		Compare.model.flush();
	},

	getComparedQuantity: function(){
		return Compare.model.products.length;
	},

	getComparedProducts: function(){
		return Compare.model.products;
	},

	getComparedProductIds: function(){
		var productIds = new Array();
		$.each( Compare.model.products, function(index, product){
			productIds.push( product.id );
		});
		return productIds;
	},

	getComparedProductObjects: function(){
		var productObjects = new Array();
		$.each( Compare.model.products, function(index, product){
			productObjects.push( product.object );
		});
		return productObjects;
	},

	applyFilters: function(){
		Compare.model.applyFilters();
	},

	open: function(){
		Compare.model.open();
	},

	close: function(){
		Compare.view.close();
	},

	filterResults: function(){
		Compare.view.filterResults();
	},

	unfilterResults: function(){
		Compare.view.unfilterResults();
	},

	setSavings: function( value ){
		Compare.model.setSavings( value );
	},

	addRowFromResultData: function( title, path, position ){
		Compare.view.addRowFromResultData( title, path, position );
	}
};
