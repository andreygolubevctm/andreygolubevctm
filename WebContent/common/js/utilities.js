var UtilitiesQuote = {
		
	ajaxPending : false,
	
	_new_quote : quoteCheck._new_quote,
	
	_init : function()
	{
		
		// Any slide
		slide_callbacks.register({
			mode:		'before',
			slide_id:	-1,
			callback:	function() {
				
				if( QuoteEngine.getCurrentSlide() != 1){
					
					$("#next-step").css("width", "140px");
					$("#next-step span").html("Next step");
					
					$('#summary-header').slideUp('fast', function(){
						$('#steps').slideDown('fast');
					});
					$('#page').slideUp('fast', function() {
						$('#resultsPage').slideUp('fast', function() {
							$('#page').slideDown('fast', function() {
								
							});
						});
					});
					
				}
				
			}
		});
		
		// Back to "form" from "results"
		slide_callbacks.register({
			mode:		'before',
			direction:	'reverse',
			slide_id:	0,
			callback:	function() {
				UtilitiesQuote.generateNewQuote();
			}
		});
		
		// To "results" from "form"
		slide_callbacks.register({
			mode:		'before',
			direction:	'forward',
			slide_id:	1,
			callback: 	function() {
				if (QuoteEngine._options.prevSlide >= 1)
				{
					if( UtilitiesQuote.responseContainsProducts(jsonResult) )
					{
						Results.update(UtilitiesQuote.sanitiseResults(jsonResult.results.products.product, jsonResult.results.client.reference, jsonResult.results.transactionId), jsonResult.results.transactionId);
						Results.show();
						Results._revising = true;
					}
					else
					{
						Results.showErrors(["No results found, please <a href='javascript:Results.reviseDetails()' title='Revise your details'>revise your details</a>."]);
					}
					$('#resultsPage').hide();
					$('#page').show();
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
				UtilitiesQuote.ajaxPending = false;
				Loading.hide();
				Results.showErrors(["An error occurred when fetching premiums: " + txt]);
			}
		});		
		if (typeof messages == 'object') {
			var m = [];
			$.each(messages, function(i, message) {
				m.push(message);
			});
			messages = m;
		}
		if (!$.isArray(messages)) {
			messages = [messages];
		}
		if (messages.length == 0) {
			messages.push('Unknown error.');
		}

		var content = '';
		content += '<b>'+title+'</b>';
		content += '<ul style="margin:0.25em 0 0 1.2em; list-style:disc"><li>' + messages.join('</li><li>') + '</li></ul>';
		content += '<br />Please try again.';

		FatalErrorDialog.exec({
			message:		content,
			page:			"utilities.js",
			description:	typeof data == "object" && data.hasOwnProperty("description") ? data.description : "UtilitiesQuote.error()",
			data:			typeof data == "object" && data.hasOwnProperty("data") ? data.data : null
		});
	},
	
	error: function(title, messages, data) {
		Loading.hide();
		
		if (typeof messages == 'object') {
			var m = [];
			$.each(messages, function(i, message) {
				m.push(message);
			});
			messages = m;
		}
		if (!$.isArray(messages)) {
			messages = [messages];
		}
		if (messages.length == 0) {
			messages.push('Unknown error.');
		}

		var content = '';
		content += '<b>'+title+'</b>';
		content += '<ul style="margin:0.25em 0 0 1.2em; list-style:disc"><li>' + messages.join('</li><li>') + '</li></ul>';
		content += '<br />Please try again.';

		FatalErrorDialog.exec({
			message:		content,
			page:			"utilities.js",
			description:	typeof data == "object" && data.hasOwnProperty("description") ? data.description : "UtilitiesQuote.error()",
			data:			typeof data == "object" && data.hasOwnProperty("data") ? data.data : null
		});
	},
	
	errorFetchPrices: function(messages) {
		UtilitiesQuote.fetchPricesResponse = false;
		QuoteEngine.prevSlide();
		UtilitiesQuote.error('An error occurred when fetching premiums', messages, {
			description:	"UtilitiesQuote.errorFetchPrices()",
			data:			null
		});
	},
	
	generateNewQuote: function() {
		ReferenceNo.getTransactionID( ReferenceNo._FLAG_INCREMENT );
	},
	
	fetchPrices: function() {
		
		if (!UtilitiesQuote.ajaxPending){
			Loading.show("Loading Quotes...");
			
			var dat = $("#mainform").serialize();
			UtilitiesQuote.ajaxPending = true;
			$.ajax({
				url: "ajax/json/utilities_quote_results.jsp",
				data: dat,
				type: "POST",
				async: true,
				dataType: "json",
				timeout:60000,
				cache: false,
				success: function(json){
					UtilitiesQuote.ajaxPending = false;
					
					if (json && json.results) {
						json = json.results; //for convenience
					}
					if (!json || !json.price || (json.status && json.status=='ERROR')) {
						var msgs = [];
						if (json.messages)
							msgs = json.messages;
						UtilitiesQuote.errorFetchPrices(msgs);
						return false;
					};
					
					UtilitiesQuote.fetchPricesResponse = true;
					
					// Let's sneak the tranID into each product - save an ajax call
					if( json.price.length ) {
						for(var i = 0; i < json.price.length; i++) {
							json.price[i].transactionId = json.transactionId;
						}
					}
					
					Results.update(json.price);
					Results.show();
					Loading.hide();
				},
				error: function(obj,txt,errorThrown){
					UtilitiesQuote.ajaxPending = false;
					UtilitiesQuote.errorFetchPrices(txt + ' ' + errorThrown);
					return false;
				}
			});
			return UtilitiesQuote.fetchPricesResponse;
		}
	},
	
	getPrettyNumber : function( num ) {
		
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
	
	fetchProductDetail: function( product_obj, callback ) {
		
		if (!UtilitiesQuote.ajaxPending) {
			Loading.show("Loading Product...");
			var dat = {
					productId :	product_obj.productId,
					searchId : product_obj.searchId,
					ProductClassPackage : product_obj.info.ProductClassPackage
			};
			UtilitiesQuote.ajaxPending = true;
			$.ajax({
				url: "ajax/json/utilities_get_productdetail.jsp",
				data: dat,
				type: "POST",
				async: true,
				dataType: "json",
				timeout:60000,
				cache: false,
				success: function(json){
					UtilitiesQuote.ajaxPending = false;
					
					if (!json || !json.results || !json.results.price || (json.status && json.status=='ERROR')) {
						var msgs = ['Invalid product details were fetched.'];
						if (json.messages.message) {
							msgs = json.messages.message;
						}
						UtilitiesQuote.error('An error occurred when fetching product details', msgs, {
							description:	"UtilitiesQuote.fetchProductDetail(). JSON Response contained error messages. ",
							data:			json
						});
						return false;
					}
					
					// Quick bit of sanitisation
					var tmp = {
							search_id: 			product_obj.search_id,
							company:			product_obj.company,
							companyCode:		product_obj.companyCode,
							estimatedCost:		product_obj.estimatedCost,
							estimatedSaving:	product_obj.estimatedSaving,
							greenpower:			product_obj.greenpower,
							thumb:				product_obj.thumb,
							bestdeal:			product_obj.bestdeal,
							contractPeriod:		product_obj.contractPeriod,
							maxCancellationFee:	product_obj.maxCancellationFee,
							package_type:		product_obj.package_type
					};
					
					tmp = $.extend(json.results.price, tmp);
					Results.setSelectedProduct(tmp);
					
					if (typeof callback == "function") {
						callback();
					}

					Loading.hide();
				},
				error: function(obj,txt,errorThrown) {
					UtilitiesQuote.error('An error occurred when fetching product details', txt+' '+errorThrown, {
						description:	"UtilitiesQuote.fetchProductDetail(). AJAX request failed: " + txt + " " + errorThrown,
						data:			dat
					});
					return false;
				}
			});
		}
	},
	
	arrayIndex : function(arr, token) {
		
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
	
	/**
	 * Method is to check the product against a valid product list once available
	 */
	productInWhiteList : function( product ) {
		return true;
	},
	
	errorSubmitApplication: function(messages, data) {
		QuoteEngine.prevSlide();
		UtilitiesQuote.error('An error occurred when submitting the application', messages, data);
	},
	
	submitApplication: function(product, callback ) {
		
		if (!UtilitiesQuote.ajaxPending){
			
			Loading.show("Submitting application...");
			
			var dat = $("#mainform").serialize();
			UtilitiesQuote.ajaxPending = true;
			
			$.ajax({
				url: "ajax/json/utilities_submit_application.jsp",
				data: dat,
				type: "POST",
				async: true,
				dataType: "json",
				timeout:60000,
				cache: false,
				success: function(json){
					
					UtilitiesQuote.ajaxPending = false;
					
					if (json && json.results) {
						json = json.results; //for convenience
					}
					if (!json || (json.status && json.status=='ERROR')) {
						var msgs = ['Submitting your application has failed, please try again or contact us if the problem persists.'];
						if (json.messages.message) {
							msgs = json.messages.message;
						}
						UtilitiesQuote.errorSubmitApplication(msgs, {
							description:	"UtilitiesQuote.submitApplication(). JSON response contained an error messages.",
							data:			json
						});
						return false;
					}
					Loading.hide();
					
					UtilitiesConfirmationPage.show(json);
					return false;
				},
				error: function(obj,txt,errorThrown) {
					UtilitiesQuote.errorSubmitApplication(txt + ' ' + errorThrown, {
						description:	"UtilitiesQuote.submitApplication(). AJAX request failed: " + txt + " " + errorThrown,
						data:			dat
					});
					return false;
				}
			});
			
		}
		
	},
	
	getUtilitiesForPostcode : function(postcode, callback) {
		
		var dat = {postcode: postcode};
		$.ajax({
			url: "ajax/json/utilities_get_utilitiesforpostcode.jsp",
			data: dat,
			type: "GET",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			success: function(json){
				
				if (!json
					|| !json.ArrayOfProductClassPackageType
					|| !json.ArrayOfProductClassPackageType.ProductClassPackageType) {
					return false;
				}
				
				if( typeof callback == "function" ) {
					callback(json.ArrayOfProductClassPackageType.ProductClassPackageType);
				}
				
				return false;
			},
			error: function(obj,txt,errorThrown) {
				UtilitiesQuote.error('An error occurred when retrieving the utilities for postcode '+postcode, txt+' '+errorThrown, {
					description:	"UtilitiesQuote.getUtilitiesForPostcode(). AJAX request failed: " + txt + " " + errorThrown,
					data:			dat
				});
				return false;
			}
		});
			
		
	},
	
	getProviderBusinessDaysNotice : function(providerCode, callback) {
		
		if (!UtilitiesQuote.ajaxPending){
			
			UtilitiesQuote.ajaxPending = true;
			var dat = {providerCode: providerCode};
			$.ajax({
				url: "ajax/json/utilities_get_providerbusinessdaysnotice.jsp",
				data: dat,
				type: "GET",
				async: true,
				dataType: "json",
				timeout:60000,
				cache: false,
				success: function(json){
					
					UtilitiesQuote.ajaxPending = false;
					
					if (!json
						|| !json.int
						|| !json.int.content) {
						return false;
					}
					
					if( typeof callback == "function" ) {
						callback(json.int.content);
					}
					
					return false;
				},
				error: function(obj,txt,errorThrown) {
					UtilitiesQuote.error('An error occurred when retrieving the number of business days of notice for retailer code '+providerCode, txt+' '+errorThrown, {
						description:	"UtilitiesQuote.getProviderBusinessDaysNotice(). AJAX request failed: " + txt + " " + errorThrown,
						data:			dat
					});
					return false;
				}
			});
			
		}
		
	},
		
	checkQuoteOwnership: function( callback ) {
		
	},
	
	getProviderBusinessDaysNotice : function(providerCode, callback) {
		
		var dat = {providerCode: providerCode};
		$.ajax({
			url: "ajax/json/utilities_get_providerbusinessdaysnotice.jsp",
			data: dat,
			type: "GET",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			success: function(json){
				
				if (!json
					|| !json.int
					|| !json.int.content) {
					return false;
				}
				
				if( typeof callback == "function" ) {
					callback(json.int.content);
				}
				
				return false;
			},
			error: function(obj,txt,errorThrown) {
				UtilitiesQuote.error('An error occurred when retrieving the number of business days of notice for retailer code '+providerCode, txt+' '+errorThrown, {
					description:	"UtilitiesQuote.getProviderBusinessDaysNotice(). AJAX request failed: " + txt + " " + errorThrown,
					data:			dat
				});
				return false;
			}
		});
		
	},
	
	getEnergyProfile : function(searchId, callback) {
		
		var dat = {searchId: searchId};
		$.ajax({
			url: "ajax/json/utilities_get_energyprofile.jsp",
			data: dat,
			type: "GET",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			success: function(json){
				
				if (!json
					|| !json.energyprofile) {
					return false;
				}
				
				if( typeof callback == "function" ) {
					callback(json.energyprofile);
				}
				
				return false;
			},
			error: function(obj,txt,errorThrown) {
				UtilitiesQuote.error('An error occurred when retrieving the energy profile for search ID '+searchID, txt+' '+errorThrown, {
					description:	"UtilitiesQuote.getEnergyProfile(). AJAX request failed: " + txt + " " + errorThrown,
					data:			dat
				});
				return false;
			}
		});
			
	},
		
	checkQuoteOwnership: function( callback ) {
		
		var dat = {quoteType:"utilities"};
		$.ajax({
			url: "ajax/json/access_check.jsp",
			data: dat,
			dataType: "json",
			type: "POST",
			async: true,
			timeout:60000,
			cache: false,
			success: function(jsonResult){
				if( !Number(jsonResult.result.success) )
				{
					FatalErrorDialog.exec({
						message:		jsonResult.result.message,
						page:			"utilities.js",
						description:	"UtilitiesQuote.checkQuoteOwnership(). jsonResult contained an error message: " + jsonResult.result.message,
						data:			jsonResult
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
					page:			"utilities.js",
					description:	"UtilitiesQuote.checkQuoteOwnership(). AJAX request failed: " + txt,
					data:			dat
				});
				return false;
			}
		});
	
		return true;
		
	},
		
	touchQuote: function( touchtype, callback )
	{
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
						page:			"utilities.js",
						description:	"UtilitiesQuote.touchQuote(). jsonResult contained an error message: " + jsonResult.result.message,
						data:			jsonResult
					});
				}
				else
				{
					if( typeof callback == "function" )
					{
						callback();
					}
				}
			},
			error: function(obj,txt){
				FatalErrorDialog.exec({
					message:		"An undefined error has occurred - please try again later.",
					page:			"utilities.js",
					description:	"UtilitiesQuote.touchQuote(). AJAX request failed: " + txt,
					data:			dat
				});
			}
		});
		
		return true;
	},
	
	restartQuote: function() {		
		Loading.show("Start New Quote...");
		var dat = {quoteType:"utilities"};
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
						page:			"utilities.js",
						description:	"UtilitiesQuote.restartQuote(). JSON response did not contain a destUrl",
						data:			json
					});
				};
				
				return false;
			},
			error: function(obj,txt){
				Loading.hide();
				FatalErrorDialog.exec({
					message:		"Sorry, an error occurred trying to start a new quote.",
					page:			"utilities.js",
					description:	"UtilitiesQuote.restartQuote(), ALAX request failed: " + txt,
					data:			dat
				});
			}
		});
	}
};

UtilitiesQuote._init();

var History=new Object();
History.showStart=function(){
	document.location.href="${data['settings/root-url']}";
};
