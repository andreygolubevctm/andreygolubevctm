var Roadside = new Object();
Roadside = {
	ajaxPending : false,

	fetch_count : 0,

	fetchPrices: function() {
		if (Roadside.ajaxPending){
			// we're still waiting for the results.
			return;
		}
		Loading.show("Fetching Your Roadside Assistance Quotes...");
		var dat = $("#mainform").serialize() + "&fetchcount=" + (Roadside.fetch_count++);
		Roadside.ajaxPending = true;
		this.ajaxReq =
		$.ajax({
			url: "ajax/json/sar_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			success: function(jsonResult){
				//fields should be validated client side but an error is returned from server side if empty data is sent
				if(jsonResult.errorType == "VALIDATION_FAILED") {
					handleServerSideValidation(jsonResult.validationErrors);
				} else if(jsonResult.errorType == "NO_TRAN_ID") {
					FatalErrorDialog.display("An error occurred when fetching prices : an internal error is stopping this request");
				} else {
					Results.update(jsonResult.results.price);
					Results.show();
					Results._revising = true;
				};
				Roadside.ajaxPending = false;
				Loading.hide();
				return false;
			},
			dataType: "json",
			error: function(obj, txt, errorThrown) {
				Roadside.ajaxPending = false;
				Loading.hide();
				FatalErrorDialog.exec({
					message:		"An error occurred when fetching prices: " + txt,
					page:			"common/roadside.js:fetchPrices()",
					description:	"An error occurred when trying to successfully call or parse the roadside results: " + txt + ' ' + errorThrown,
					data:			dat
				});
			},
			timeout:60000,
			complete: function() {
				if (typeof referenceNo !== 'undefined') {
					referenceNo.getTransactionID(true);
				}
			}

		});
	}
};