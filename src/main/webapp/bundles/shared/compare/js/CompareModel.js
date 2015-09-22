CompareModel = new Object();
CompareModel = {

	products: new Array(),

	add: function( product ){

		if( Compare.model.products.length < Compare.settings.maximum ) {
			Compare.model.products.push( product );
			Compare.view.add( product.id );
		}

		if(Compare.model.products.length === Compare.settings.maximum){
			$(Compare.settings.elements.bar).trigger("compareBucketFull");
		}

	},

	remove: function( productId ){

		var lengthBefore = Compare.model.products.length;

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

		if(lengthBefore === Compare.settings.maximum){
			$(Compare.settings.elements.bar).trigger("compareBucketAvailable");
		}

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