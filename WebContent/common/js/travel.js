var Travel = new Object();
Travel = {
	ajaxPending : false,

	fetchPrices: function(){
		if (Travel.ajaxPending){
			// we're still waiting for the results.
			return;
		}
		Loading.show("Loading prices...");
		var dat = serialiseWithoutEmptyFields('#mainform' , false);
		dat = dat + "&initialSort=" + Results._initialSort;
		dat = dat + "&incrementTransactionId=" + Results._incrementTransactionId;
		Travel.ajaxPending = true;
		this.ajaxReq =
		$.ajax({
			url: "ajax/json/travel_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			success: function(jsonResult){
				Travel.ajaxPending = false;
				if(typeof jsonResult.error != 'undefined' && jsonResult.error.type == "validation") {
					Loading.hide(function() {
						ServerSideValidation.outputValidationErrors({
							validationErrors: jsonResult.error.errorDetails.validationErrors,
							startStage: 0,
							singleStage : true
						});
					});
					if (typeof jsonResult.error.transactionId != 'undefined') {
						referenceNo.setTransactionId(jsonResult.error.transactionId);
					}
				} else {
					Travel.assignBestPrice( jsonResult.results.price );
					Results.update(jsonResult.results.price);
					Results.show();
					Results._revising = true;
					Loading.hide();
				}
				return false;
			},
			dataType: "json",
			error: function(obj, txt, errorThrown) {
				Travel.ajaxPending = false;
				Loading.hide();
				FatalErrorDialog.exec({
					message:		"An error occurred when fetching prices: " + txt,
					page:			"common/travel.js",
					description:	"fetchPrices(). An error occurred when trying to successfully call or parse the travel results: " + txt + ' ' + errorThrown,
					data:			dat
				});
			},
			timeout:60000,
			complete: function() {
				if (typeof referenceNo !== 'undefined')
					Track._transactionID = referenceNo.getTransactionID(true);
			}
		});
	},
	assignBestPrice : function( prices ) {
		if( typeof prices == "object" && prices.constructor == Array ) {
			var limit = prices.length;
			var best = {
					index : false,
					price : 0
			};
			for(var i=0; i<limit; i++) {
				var p = prices[i];
				if(typeof p.price != 'undefined' || p.price != null) {
					if(best.index === false || best.price > p.price) {
						best.index = i;
						best.price = p.price;
					}
				}
			}
			if( best.price !== false ) {
				prices[best.index]['best_price'] = true;
			}
		}
	}
}
