/**
 * Fund capping limits implementation of adminDataCRUD.js
 */
;(function($, undefined){
	
	var meerkat = window.meerkat;
	var CRUD;
 
	function init() {
		$(document).ready(function() {
			if($("#fund-capping-limits-container").length) {
				CRUD = new meerkat.modules.adminDataCRUD.newCRUD({
					baseURL: "../../admin/cappingLimits",
					primaryKey: "cappingLimitsKey", 
					models: {
						datum: function(data) {
							return {
								extraData: {
									limitLeft: data.cappingAmount - data.currentJoinCount,
									type: function(){
										var curDate = new Date().setHours(0,0,0,0);

										if(new Date(data.effectiveEnd).setHours(0,0,0,0) >= curDate) {
											return "current";
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
		var types = ["current", "past"];

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
 
	meerkat.modules.register('adminFundCappingLimits', {
		init: init,
		refresh: refresh
	});
	
})(jQuery);