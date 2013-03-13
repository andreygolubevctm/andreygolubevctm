var Travel = new Object();
Travel = {
	ajaxPending : false,

	fetchPrices: function(){		
		if (Travel.ajaxPending){
			// we're still waiting for the results.
			return; 
		}
		Loading.show("Loading prices...");
		var dat = $("#mainform").serialize();
		Travel.ajaxPending = true;
		this.ajaxReq = 
		$.ajax({
			url: "ajax/json/travel_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			success: function(jsonResult){
				Travel.ajaxPending = false;	
				Results.update(jsonResult.results.price);
				Results.show();
				Results._revising = true;
				Loading.hide();
				return false;
			},
			dataType: "json",
			error: function(obj,txt){
				Travel.ajaxPending = false;
				Loading.hide();
				FatalErrorDialog.display("An error occurred when fetching prices:" + txt, dat);
			},
			timeout:60000
		});
	}
}


