var Roadside = new Object();
Roadside = {
	ajaxPending : false,
	
	fetchPrices: function(){	
		if (Roadside.ajaxPending){
			// we're still waiting for the results.
			return; 
		}
		Loading.show("Fetching Your<br>Roadside Assistance Quotes...");
		var dat = $("#mainform").serialize();
		Roadside.ajaxPending = true;
		this.ajaxReq = 
		$.ajax({
			url: "ajax/json/sar_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			success: function(jsonResult){
				Roadside.ajaxPending = false;	
				Results.update(jsonResult.results.price);
				Results.show();
				Results._revising = true;
				Loading.hide();
				return false;
			},
			dataType: "json",
			error: function(obj,txt){
				Roadside.ajaxPending = false;
				Loading.hide();
				alert("An error occurred when fetching prices :" + txt);
			},
			timeout:60000
		});
	}
};