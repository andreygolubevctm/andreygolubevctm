/**
 * Product Capping Summary implementation of crud.js
 */
;(function($, undefined){
	
	var meerkat = window.meerkat;
	var CRUD;
 
	function init() {
		$(document).ready(function() {
			if($("#fund-product-capping-summary-container").length) {

				CRUD = new meerkat.modules.crud.newCRUD({
					baseURL: "../../admin/productCappingLimits",
					primaryKey: "providerCode",
					renderResults: renderCappingsHTML
				});

				CRUD.getSummary();

			}
		});
	}

	/**
	 * Renders the complete offers list HTML
	 */
	function renderCappingsHTML() {

		var cappings = CRUD.dataSet.get(),
			cappingHTML = "";

		for(var j = 0; j < cappings.length; j++) {
			cappingHTML += cappings[j].html;
		}

		$("#product-capping-summary-container")
			.html(cappingHTML)
			.closest(".row")
			.find("h1 small")
			.text("(" + cappings.length + ")");
	}


	/**
	 * Actions to do on sort refresh
	 */
	function refresh() {
		CRUD.renderResults();
	}
 
	meerkat.modules.register('adminFundProductCappingSummary', {
		init: init,
		refresh: refresh
	});
	
})(jQuery);