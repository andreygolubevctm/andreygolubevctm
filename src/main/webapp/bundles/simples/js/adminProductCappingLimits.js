/**
 * Product Capping Limits implementation of crud.js
 */
;(function($, undefined){
	
	var meerkat = window.meerkat;
	var CRUD;
 
	function init() {
		$(document).ready(function() {
			if($("#product-capping-limits-container").length) {
				CRUD = new meerkat.modules.crud.newCRUD({
					baseURL: "../../admin/productCappingLimits",
					//primaryKey: "cappingLimitsKey",  todo: DELETE this line!!!! ############################
					primaryKey: "cappingLimitId",
					models: {
						datum: function(data) {
							return {
								extraData: {
									limitLeft: data.cappingAmount - data.currentJoinCount,
									category: function() {
										return data.cappingLimitCategory === "H" ? "Hard" : "Soft";
									},
									type: function(){
										var curDate = new Date().setHours(0,0,0,0);

										if(new Date(data.effectiveEnd).setHours(0,0,0,0) >= curDate) {
											if(new Date(data.effectiveStart).setHours(0,0,0,0) >= curDate) {
												return "future";
											} else {
												return "current";
											}
										} else {
											return "past";
										}
									}
								}
							};
						}
					},
					renderResults: renderCappingsHTML
				});
				
				CRUD.getDeleteRequestData = function($row) {
					return CRUD.dataSet.get($row.data("id")).data;
				};
 
				CRUD.get();

			}
		});
	}

	/**
	 * Renders the complete offers list HTML
	 */
	function renderCappingsHTML() {
		var types = ["current", "future", "past"];

		for(var i = 0; i < types.length; i++) {
			var type = types[i],
				cappings = CRUD.dataSet.getByType(type),
				cappingHTML = "";

			for(var j = 0; j < cappings.length; j++) {
				cappingHTML += cappings[j].html;
			}

			$("#" + type + "-cappings-container")
				.html(cappingHTML)
				.closest(".row")
				.find("h1 small")
				.text("(" + cappings.length + ")");
		}
	}

	/**
	 * Actions to do on sort refresh
	 */
	function refresh() {
		CRUD.renderResults();
	}
 
	meerkat.modules.register('adminProductCappingLimits', {
		init: init,
		refresh: refresh
	});
	
})(jQuery);