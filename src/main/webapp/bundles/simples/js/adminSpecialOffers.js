/**
 * Implementation of adminDataCRUD.js for Special Offers page
 * 
 * Documentation here:
 * http://confluence:8090/display/CM/Creating+Simples+Admin+Interfaces
 */
;(function($, undefined){
	
	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var CRUD;

	function init() {
		$(document).ready(function() {
			if($("#special-offers-container").length) {
				CRUD = new meerkat.modules.adminDataCRUD.newCRUD({
					baseURL: "admin/offers",
					primaryKey: "offerId",
					models: {
						datum: function(offer) {
							return {
								extraData: {
									type: function () {
										var curDate = new Date(),
											startDate = new Date(offer.effectiveStart).setHours(0, 0, 0, 0),
											endDate = new Date(offer.effectiveEnd).setHours(23, 59, 59, 0);

										if (startDate > curDate.setHours(0, 0, 0, 0)) {
											return "future";
										} else if (startDate <= curDate.setHours(0, 0, 0, 0) && endDate >= curDate.setHours(23, 59, 59, 0)) {
											return "current";
										} else {
											return "past";
										}
									}
								}
							};
						}
					},
					renderResults: renderOffersHTML
				});
				
				CRUD.get();
			}
		});
	}
	
	/**
	 * Renders the complete offers list HTML
	 */
	function renderOffersHTML() {
		var types = ["current", "future", "past"];
		
		for(var i = 0; i < types.length; i++) {
			var type = types[i],
				offers = CRUD.dataSet.getByType(type),
				offerHTML = "";
			
			for(var j = 0; j < offers.length; j++) {
				offerHTML += offers[j].html;
			}
			
			$("#" + type + "-special-offers-container")
				.html(offerHTML)
				.closest(".row")
				.find("h1 small")
				.text("(" + offers.length + ")");
		}
	}
	
	/**
	 * Actions to do on sort refresh
	 */
	function refresh() {
		CRUD.renderResults();
	}

	meerkat.modules.register('adminSpecialOffers', {
		init: init,
		refresh: refresh
	});
	
})(jQuery);