var IPQuote = {
		
	ajaxPending : false,
	
	premiumFrequency : false,
	
	_new_quote : quoteCheck._new_quote,
	
	_init : function()
	{
		slide_callbacks.register({
			mode:		"before",
			direction:	"reverse",
			slide_id:	-1,
			callback: 	function() {
				if( QuoteEngine._options.prevSlide >= 1 )
				{
					IPQuote.generateNewQuote();
				}
			}
		});
	},
	
	generateNewQuote: function()
	{
		ReferenceNo.getTransactionID( ReferenceNo._FLAG_INCREMENT );
	},
	
	fetchPrices: function(){		
		if (IPQuote.ajaxPending){
			// we're still waiting for the results.
			return; 
		}
		Loading.show("Loading premiums...");
		var dat = $("#mainform").serialize();
		IPQuote.ajaxPending = true;
		$.ajax({
			url: "ajax/json/ip_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				IPQuote.ajaxPending = false;	
				Loading.hide();
				if( IPQuote.isValidResultsResponse(jsonResult) )
				{
					if( IPQuote.responseContainsProducts(jsonResult) )
					{
						// Update form with client/product data
						LifebrokerRef.updateClientFormFields( jsonResult.results.client.reference, null );
						
						Results.update(IPQuote.sanitiseResults(jsonResult.results.products.premium, jsonResult.results.client.reference, jsonResult.results.transactionId), jsonResult.results.transactionId);
						Results.show();
						Results._revising = true;
						
						// Form updated with client reference now so update databucket again 
						LifebrokerRef.updateDataBucket();
					}
					else
					{
						Results.showErrors(["No results found, please <a href='javascript:Results.reviseDetails()' title='Revise your details'>revise your details</a>."]);
					}
				}
				else
				{
					var msg = "Invalid response received. Please try again later.";
					try {
						if( typeof jsonResult.results.products.error == "string" && jsonResult.results.products.error.constructor == String )
						{
							msg = jsonResult.results.products.error + " Please <a href='javascript:Results.reviseDetails()' title='Revise your details'>revise your details</a>.";
						}
					} catch(e) { /* IGNORE */ }
					
					Results.showErrors([msg]);
				}
				return false;
			},
			error: function(obj,txt){
				IPQuote.ajaxPending = false;
				Loading.hide();
				Results.showErrors(["An error occurred when fetching premiums: " + txt]);
			}
		});
	},
	
	isValidResultsResponse : function( json ) 
	{
		return typeof json.results == 'object' && (typeof json.results.products == 'object' || json.results.products == "") && typeof json.results.client == 'object';
	},
	
	responseContainsProducts : function( json ) 
	{
		return typeof json.results.products == "object" && json.results.products.hasOwnProperty("premium") && typeof json.results.products.premium == "object" && json.results.products.premium instanceof Array && json.results.products.premium.length;
	},
	
	/**
	 * sanitiseResults is needed to remove results that may not contain all required fields.
	 * Occasionally a result will only contain the product id and value. 
	 * 
	 * We're also going to add the client ref to each product for ease of later use.
	 */
	sanitiseResults: function(results, client_ref, transaction_id)
	{
		var output = [];
		 
		for(var i=0; i < results.length; i++)
		{
			if(
				results[i].hasOwnProperty("below_min") &&
				results[i].below_min != "Y" &&
				results[i].hasOwnProperty("company") &&
				results[i].hasOwnProperty("description") &&
				results[i].hasOwnProperty("name") &&
				results[i].hasOwnProperty("product_id") &&
				results[i].hasOwnProperty("stars") &&
				results[i].hasOwnProperty("value") && 
				IPQuote.productInWhiteList( results[i] )
			)
			{
				results[i].client_ref = client_ref;
				results[i].transaction_id = transaction_id;
				results[i].price = IPQuote.getPrettyNumber( IPQuote.getAdjustedPremium(results[i].value) );
				results[i].thumb = results[i].company.toLowerCase().replace(" ", "_") + ".png";
				results[i].pds = "pds/life/pds_" + results[i].company.toLowerCase().replace(" ", "_") + ".pdf";
				output.push(results[i]);
			}
		}
		
		return output;
	},
	
	getAdjustedPremium : function( premium )
	{
		/* The correct premiums as per frequency appears to be in results by default */
		switch( IPQuote.premiumFrequency )
		{
			/*case "H":
				return premium * 6;
				break;
			case "Y":
				return premium * 12;
				break;*/
			case "M":
			default:
				return premium;
				break;
		}
	},
	
	getPremiumFrequencyTerm : function()
	{
		switch( IPQuote.premiumFrequency )
		{
			case "H":
				return "Half Yearly";
				break;
			case "Y":
				return "Yearly";
				break;
			case "M":
			default:
				return "Monthly";
				break;
		}
	},
	
	getPrettyNumber : function( num )
	{
		if( isNaN(num) ) {
			num = "0.00";
		}
		else if( String(num).indexOf(".") == -1 ) {
			num = num + ".00";
		} else {
			var left = String(String(num).split(".")[0]);
			var right = String(String(num).split(".")[1]);
			
			if( right.length < 2 )
			{
				for(var i=2; i > right.length; i--)
				{
					right += "0";
				}
				
				num = left + "." + right;
			}
			else if( right.length > 2 ) {
				num = left + "." + right.substring(0,2);
			}
			else
			{
				num = String(num);
			}
		}
		
		return num;
	},
	
	fetchProductSelection: function( request_type, product, callback )
	{			
		if (IPQuote.ajaxPending){
			return; 
		}
		Loading.show("Loading income protection product...");
		var dat = {
			request_type:	request_type,
			product_id:		product.product_id,
			client_ref:		product.client_ref,
			product:		product
		};
		IPQuote.ajaxPending = true;
		$.ajax({
			url: "ajax/json/ip_product_selection.jsp",
			data: dat,
			type: "POST",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				IPQuote.ajaxPending = false;	
				Loading.hide();
				product.transaction_id = jsonResult.results.transactionId;
				product.features = IPQuote.sanitiseFeatures(jsonResult.results.features.feature);
				
				// Update form with client/product data
				LifebrokerRef.updateClientFormFields( product.client_ref, product.product_id );	
				
				// Form updated with product id now so update databucket again 
				LifebrokerRef.updateDataBucket();
				
				if( typeof callback == 'function' )
				{
					callback();
				}
				return false;
			},
			error: function(obj,txt){
				IPQuote.ajaxPending = false;
				Loading.hide();
				FatalErrorDialog.exec({
					message:		"An error occurred when fetching the product:" + txt,
					page:			"ip.js",
					description:	"IPQuote.fetchProductSelection().  AJAX Request failed: " + txt,
					data:			dat
				});
			}
		});
	},
	
	sanitiseFeatures : function(features)
	{
		var whitelist = {
				available : 	[],
				unavailable :	[]
		};
		
		// List of feature code groups applicable to age
		var age_groups = {
				cover_continues : 		[10701,10702,10703],
				cover_continues_def :	[20801,20802],
				benefit_period : 		[53209,53210,53211,53212]
		};
		
		var output = {
				available:{},
				unavailable:{},
				extras:		{
					term:	"Term Life Cover", 
					tpd:	"Total and Permanent Disablement Cover", 
					trauma:	"Trauma Cover"
				}
		};
		
		if( typeof features == "object" && features.constructor == Array )
		{
			for(var i = 0; i < features.length; i++)
			{
				var type = features[i].available ? "available" : "unavailable";
				
				// Only proceed if in whitelist
				if( IPQuote.arrayIndex(whitelist[type], features[i].id) === false )
				{
					// Test if feature is age related
					var age_group = false;
					var age_pos = false;
					for(var j in age_groups)
					{
						var pos = IPQuote.arrayIndex(age_groups[j], features[i].id);
						if( pos !== false && pos >= 0 )
						{
							age_group = j;
							age_pos = pos;
							break;
						}
					}
					
					// Just add if not age related
					if(	!age_group ) 
					{
						output[type][features[i].id] = features[i].name;
					}
					// Otherwise only add if age is the highest in its group and
					// delete any lesser ones added previously
					else
					{
						var age_highest = true;
						for(var k = 0; k < age_groups[age_group].length; k++)
						{
							if( output[type].hasOwnProperty(age_groups[age_group][k]) )
							{
								if( k < age_pos )
								{
									delete output[type][age_groups[age_group][k]];
								}
								else
								{
									age_highest = false;
								}
							}
						}
						
						if( age_highest )
						{
							output[type][features[i].id] = features[i].name;
						}
					}
				}
			}
		}	
		
		return output;
	},
	
	arrayIndex : function(arr, token)
	{
		if( typeof arr == "object" && arr.constructor == Array )
		{
			for(var i = 0; i < arr.length; i++)
			{
				if( arr[i] == token )
				{
					return i;
				}
			}
		}
		
		return false;
	},
	
	groupFeatures : function(features)
	{
		var output = {};
		
		for(var i = 0; i < features.length; i++)
		{
			var f = features[i];
			var code = f.name;
			
			if( !output.hasOwnProperty(code) )
			{
				output[code] = {};
			}
			
			output[code][f.id] = f.name;
		}
		
		//console.info(output);
	},
	
	/**
	 * Method is to check the product against a valid product list once available
	 */
	productInWhiteList : function( product )
	{
		return true;
	},
	
	submitApplication: function(product, callback ){		
		
		// Update form with client/product data
		LifebrokerRef.updateClientFormFields( product.client_ref, product.product_id );			
		
		var submit = function() {
			
			IPQuote.touchQuote("P", function(){
				Loading.show("Submitting application...");
				var dat = {
					request_type:	"REQUEST-CALL",
					product_id:		product.product_id,
					client_ref:		product.client_ref,
					product:		product
				};
				
				$.ajax({
					url: "ajax/json/ip_submit_application.jsp",
					data: dat,
					type: "POST",
					async: true,
					dataType: "json",
					timeout:60000,
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
					success: function(jsonResult){
						Loading.hide();
						IPProductDialog.close(IPConfirmationPage.show);
						return false;
					},
					error: function(obj,txt){
						Loading.hide();
						IPQuote.touchQuote("F", function() {
							FatalErrorDialog.exec({
								message:		"An error occurred when submitting the application:" + txt,
								page:			"ip.js",
								description:	"IPQuote.submitApplication().  AJAX Request failed: " + txt,
								data:			dat
							});
						});
					}
				});
			});
		};
		
		if( $("#ip_contactDetails_call").val() == "N" )
		{
			CallbackConfirmDialog.launch( function() {
				IPQuote.updateLifebroker( product, submit );
			} );
		}
		else
		{
			submit();
		}
	},
	
	updateLifebroker : function( product, callback ) {	
		if (IPQuote.ajaxPending){
			// we're still waiting for the results.
			return; 
		}
		Loading.show("Loading...");
		var dat = $("#mainform").serialize();
		
		// Force this field to be updated - actual change would have occured after
		// this function was added to the callback
		dat = dat.replace('ip_contactDetails_call=N','ip_contactDetails_call=Y');
		
		IPQuote.ajaxPending = true;
		$.ajax({
			url: "ajax/json/ip_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				IPQuote.ajaxPending = false;	
				Loading.hide();
				if( IPQuote.isValidResultsResponse(jsonResult) )
				{
					product.client_ref = jsonResult.results.client.reference;
					
					// Update form with client/product data
					LifebrokerRef.updateClientFormFields( product.client_ref, null );
					
					if( typeof callback == "function" ) {
						callback();
					}
				}
				else
				{
					var msg = "Invalid response received. Please try again later.";
					try {
						if( typeof jsonResult.results.products.error == "string" && jsonResult.results.products.error.constructor == String )
						{
							msg = jsonResult.results.products.error + " Please <a href='javascript:Results.reviseDetails()' title='Revise your details'>revise your details</a>.";
						}
					} catch(e) { /* IGNORE */ }
					
					Results.showErrors([msg]);
				}
				return false;
			},
			error: function(obj,txt){
				IPQuote.ajaxPending = false;
				Loading.hide();
				Results.showErrors(["An error occurred contacting Lifebroker: " + txt]);
			}
		});		
	},
		
	checkQuoteOwnership: function( callback ) {
		var dat = {quoteType:"ip"};
		$.ajax({
			url: "ajax/json/access_check.jsp",
			data: dat,
			dataType: "json",
			type: "POST",
			async: true,
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				if( !Number(jsonResult.result.success) )
				{
					FatalErrorDialog.exec({
						message:		jsonResult.result.message,
						page:			"ip.js",
						description:	"IPQuote.checkQuoteOwnership().  jsonResult contains error message: " + jsonResult.result.message,
						data:			{sent:dat,received:jsonResult}
					});
				}
				else
				{
					if( typeof callback == "function" )
					{
						callback();
					}
				}
				
				return false;
			},
			error: function(obj,txt){
				FatalErrorDialog.exec({
					message:		"An undefined error has occured - please try again later.",
					page:			"ip.js",
					description:	"IPQuote.checkQuoteOwnership().  AJAX Request failed: " + txt,
					data:			dat
				});
				return false;
			}
		});
	
		return true;
	},
		
	touchQuote: function( touchtype, callback ) {
		var dat = {touchtype:touchtype};
		$.ajax({
			url: "ajax/json/access_touch.jsp",
			data: dat,
			dataType: "json",
			type: "POST",
			async: true,
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				if( !Number(jsonResult.result.success) )
				{
					FatalErrorDialog.exec({
						message:		jsonResult.result.message,
						page:			"ip.js",
						description:	"IPQuote.touchQuote().  jsonResult contains error message: " + jsonResult.result.message,
						data:			{sent:dat,received:jsonResult}
					});
				}
				else
				{
					if( typeof callback == "function" )
					{
						callback();
					}
				}
				
				return false;
			},
			error: function(obj,txt){
				FatalErrorDialog.exec({
					message:		"An undefined error has occured - please try again later.",
					page:			"ip.js",
					description:	"IPQuote.checkQuoteOwnership().  AJAX request failed: " + txt,
					data:			dat
				});
				return false;
			}
		});
	},
	
	restartQuote: function() {		
		Loading.show("Start New Quote...");
		var dat = {quoteType:"ip"};
		$.ajax({
			url: "ajax/json/restart_quote.jsp",
			data: dat,
			type: "POST",
			async: false,
			dataType: "json",
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(json){
				Loading.hide();
				
				if(json && json.result.destUrl)
				{
					window.location.href = json.result.destUrl;
				}
				else
				{
					FatalErrorDialog.exec({
						message:		"Sorry, an error occurred trying to start a new quote.",
						page:			"ip.js",
						description:	"IPQuote.restartQuote().  No destUrl contained in response.",
						data:			json
					});
				};
				
				return false;
			},
			error: function(obj,txt){
				Loading.hide();
				FatalErrorDialog.exec({
					message:		"Sorry, an error occurred trying to start a new quote.",
					page:			"ip.js",
					description:	"IPQuote.restartQuote().  AJAX request failed: " + txt,
					data:			dat
				});
			}
		});
	},
	
	onRequestCallback: function() {
		if( $("#ip_contactDetails_call").val() == "Y" )
		{
			IPQuote.requestCallback();
		}
		else
		{
			CallbackConfirmDialog.launch( IPQuote.doRequestCallback );
		}
	},
	
	doRequestCallback : function() {
		IPQuote.requestCallback();
	},
	
	requestCallback: function() {	
		
		Loading.show("Requesting Callback...");
		
		var dat = $("#mainform").serialize();
		
		// Force this field to be updated - actual change would have occured after
		// this function was added to the callback
		dat = dat.replace('ip_contactDetails_call=N','ip_contactDetails_call=Y');
		
		$.ajax({
			url: "ajax/json/ip_request_call.jsp",
			data: dat,
			type: "POST",
			async: false,
			dataType: "json",
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				Loading.hide();
				if( $('#callbackconfirm-dialog').is(":visible") ) {
					CallbackConfirmDialog.close(IPConfirmationPage.show);
				} else {
				IPConfirmationPage.show();
				}
				return false;
			},
			error: function(obj,txt){
				Loading.hide();
				FatalErrorDialog.exec({
					message:		"An error occurred when submitting your request:" + txt,
					page:			"ip.js",
					description:	"IPQuote.requestCallBack().  AJAX request failed: " + txt,
					data:			dat
				});
			}
		});
	}
};

IPQuote._init();
