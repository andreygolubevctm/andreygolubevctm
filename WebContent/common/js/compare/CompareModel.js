CompareModel = new Object();
CompareModel = {

	products: new Array(),

	add: function( product ){

		if( Compare.model.products.length < Compare.settings.maximum ) {
			Compare.model.products.push( product );
			Compare.view.add( product.id );
		} else {
			// @todo = display error message saying the compare bar is full
			// Compare.view.toggleLimitError();
		}

	},

	remove: function( productId ){

		$.each( Compare.model.products, function(index, currentProduct){
			if( productId == currentProduct.id ){
				Compare.model.products.splice( index, 1 );
				Compare.view.remove( productId );
				return false;
			}
		});

		if( Compare.model.products.length < Compare.settings.minimum ){
			$(Compare.settings.elements.bar).trigger("compareNonAvailable");
		}

		// @todo = remove the error message that says the limit of product to compare has been reached if it's displayed
		// Compare.view.toggleLimitError();
	},

	open: function(){
		Compare.view.open();
	},

	flush: function(){

		while( typeof(Compare.model.products[0]) != "undefined" ){
			Compare.model.remove( Compare.model.products[0].id );
		}

	},

	applyFilters: function(){

		var filteredResults = Results.getFilteredResults();

		$.each( Compare.model.products, function(index, product){
			if( $.inArray( product.object, filteredResults ) == -1 ){
				Compare.remove( product.id );
			}
		});

	},

	setSavings: function( value ){

		if( value == "" || isNaN(value) || value <= 0 ){
			Compare.view.hideSavings();
		} else {
			Compare.view.showSavings( value );
		}

	}
}