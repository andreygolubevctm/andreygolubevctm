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

					$('#resultsPage').slideUp('fast', function() {
						$('#page').slideDown('fast');
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
				referenceNo.generateNewTransactionID(3);
				$('.right-panel').not('.slideScrapesContainer').show();
			}
		});

		// To "results" from "form"
		slide_callbacks.register({
			mode:		'before',
			direction:	'forward',
			slide_id:	1,
			callback: 	function() {
				$('#page').slideUp('fast', function() {
					UtilitiesQuote.fetchPrices();
				});
			}
		});

		// Back to "results" from "fill out your details"
		slide_callbacks.register({
			mode:		'before',
			direction:	'reverse',
			slide_id:	1,
			callback: 	function() {
				$('#page').slideUp('fast', function() {
					$('#resultsPage').slideDown('fast');
				});
			}
		});

		// Fill out your details
		slide_callbacks.register({
			mode:		'before',
			direction: 	'forward',
			slide_id:	2,
			callback:	function() {
				ApplyOnlineDialog.close();

				utilitiesChoices.setProduct(Results._selectedProduct);
				utilitiesChoices.updateApplicationSlide();

				$('#page').show();
				$('#resultsPage').hide();

				$('.right-panel').not('.slideScrapesContainer').show();
			}
		});

		// Apply Now
		slide_callbacks.register({
			mode:		'before',
			slide_id:	3,
			callback:	function() {
				utilitiesChoices.updateApplyNowSlide();
			}
		});
		slide_callbacks.register({
			mode:		'after',
			slide_id:	3,
			callback:	function() {
				$("#next-step").css("width", "170px");
				$("#next-step span").html("Submit Application");
			}
		});


		// Confirmation
		slide_callbacks.register({
			mode:		'before',
			slide_id:	4,
			callback:	function() {
				UtilitiesQuote.submitApplication(utilitiesChoices._product);
			}
		});
	},

	error: function(title, errors, data) {

		UtilitiesQuote.ajaxPending = false;
		Loading.hide();

		if ($.isArray(errors)) {
			var m = [];
			$.each(errors, function(i, error) {
				if( error.code > 0 ) {
					m.push("Service is currently unavailable. Please try again later.");
				} else {
					m.push(error.message);
				}
			});
			errors = m;
		} else if (typeof errors == 'object' && errors.hasOwnProperty('error')) {
			errors = [errors.error.message];
		}

		if (!$.isArray(errors) || errors.length == 0) {
			errors = ['An undefined error has occured.'];
		}

		var content = '';
		content += '<b>'+title+'</b>';
		content += '<ul style="margin:0.25em 0 0 1.2em; list-style:disc"><li>' + errors.join('</li><li>') + '</li></ul>';

		FatalErrorDialog.exec({
			message:		content,
			page:			"utilities.js",
			description:	typeof data == "object" && data.hasOwnProperty("description") ? data.description : "UtilitiesQuote.error()",
			data:			typeof data == "object" && data.hasOwnProperty("data") ? data.data : null
		});
	},

	errorFetchPrices: function(errors) {
		UtilitiesQuote.fetchPricesResponse = false;
		QuoteEngine.prevSlide();
		UtilitiesQuote.error('An error occurred when fetching your comparison', errors, {
			description:	"UtilitiesQuote.errorFetchPrices()",
			data:			null
		});
	},
	fetchPrices: function() {

		if (!UtilitiesQuote.ajaxPending){
			Loading.show("Loading Quotes...");

			var dat = serialiseWithoutEmptyFields('#mainform');
			
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
					if(typeof json.error != 'undefined' && json.error.type == "validation") {
						Loading.hide();
						ServerSideValidation.outputValidationErrors({
							validationErrors: json.error.errorDetails.validationErrors,
							startStage: 0,
							singleStage: true
						});
						if (typeof json.error.transactionId != 'undefined') {
							referenceNo.setTransactionId(json.error.transactionId);
						}
						return false;
					} else if (!json || !json.price || (json.status && json.status=='ERROR')) {
						var msgs = [];
						if (typeof json.errors == "object" && ($.isArray(json.errors) || json.errors.hasOwnProperty("error"))) {
							if($.isArray(json.errors)) {
								msgs = json.errors;
							} else {
								msgs.push(json.errors.error);
							}
						} else {
							msgs.push({code:0,message:"No products were found"});
						}

						if( msgs.length && msgs[0].message.indexOf("No products were found") != -1 ) {
							Results.showErrors(["No results found, please <a href='javascript:void(0);' data-revisedetails='true' title='Revise your details'>revise your details</a>."]);
							} else {
								UtilitiesQuote.errorFetchPrices(msgs);
							}
							Loading.hide();
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
					return false;
				},
				error: function(obj,txt,errorThrown){
					UtilitiesQuote.errorFetchPrices(txt + ' - ' + errorThrown);
					return false;
				},
				complete: function() {
					if (typeof referenceNo !== 'undefined') {
						referenceNo.getTransactionID(true);
					}
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
					ProductClassPackage : product_obj.info.ProductClassPackage,
					transactionId:referenceNo.getTransactionID()
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

					if (json && json.results) {
						json = json.results; //for convenience
					}
					if (!json || !json.price || (json.status && json.status=='ERROR')) {
						var msgs = [];
						if (typeof json.errors == "object" && ($.isArray(json.errors) || json.errors.hasOwnProperty("error"))) {
							if($.isArray(json.errors)) {
								msgs = json.errors;
							} else {
								msgs.push(json.errors.error);
						}
						} else {
							msgs.push({code:500,message:"Failed to find product details."});
						}
						UtilitiesQuote.error('An error occurred when fetching product details', msgs, {
							description:	"UtilitiesQuote.fetchProductDetail(). JSON Response contained error messages. ",
							data:			json
						});
						return false;
					}

					/* no need to re-assign selected product as [a] this may not be a selected product and
					 * [b] product_obj is already a reference to the product (whichever it is) */
					$.extend(true, product_obj, json.price);

					if( typeof callback == "function" ) {
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

	errorSubmitApplication: function(errors, data) {
		QuoteEngine.prevSlide();
		UtilitiesQuote.error('An error occurred when submitting the application', errors, data);
	},

	submitApplication: function(product, callback ) {

		if (!UtilitiesQuote.ajaxPending){

			Loading.show("Submitting application...");

			var dat = serialiseWithoutEmptyFields('#mainform');
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
					if(typeof json.error != 'undefined' && json.error.type == "validation") {
						Loading.hide();
						ServerSideValidation.outputValidationErrors({
							validationErrors: json.error.errorDetails.validationErrors,
							startStage: 2,
							singleStage: false
						});
						if (typeof json.error.transactionId != 'undefined') {
							referenceNo.setTransactionId(json.error.transactionId);
						}
						return false;
					} else if (!json || (json.status && json.status=='ERROR')) {
						var msgs = {error:{code:0,message:'Submitting your application has failed, please try again or contact us if the problem persists.'}};
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
					|| !json.arrayofproductclasspackagetype
					|| !json.arrayofproductclasspackagetype.productclasspackagetype) {
					return false;
				}

				if( typeof callback == "function" ) {
					callback(json.arrayofproductclasspackagetype.productclasspackagetype);
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

	getMoveInAvailability : function(providerCode, state, callback) {

		var dat = {
			providerCode: providerCode, 
			state: state,
			transactionId: referenceNo.getTransactionID()
		};
		$.ajax({
			url: "ajax/json/utilities_get_moveinavailability.jsp",
			data: dat,
			type: "GET",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			success: function(json){
				if (!json
					|| !json.results) {
					return false;
				}

				if( typeof callback == "function" ) {
					callback(json.results);
				}

				return false;
			},
			error: function(obj,txt,errorThrown) {
				UtilitiesQuote.error('An error occurred when retrieving the move in availability for retailer code ' + providerCode + ' and state ' + state, txt+' '+errorThrown, {
					description:	"UtilitiesQuote.getMoveInAvailability(). AJAX request failed: " + txt + " " + errorThrown,
					data:			dat
				});
				return false;
			}
		});

	},

	getPublicHolidays: function(params, callback){

		$.ajax({
			url: "ajax/json/read_public_holidays.jsp",
			data: params,
			type: "POST",
			async: true,
			dataType: "script",
			timeout:20000,
			cache: false,
			success: function(publicHolidaysString){
				/* should return an array of public holidays but in a string so needs to be evaluated */
				publicHolidays = eval(publicHolidaysString);

				if( !$.isArray(publicHolidays) ) {
					FatalErrorDialog.register({
						message:		"Error retrieving list of public holidays.",
						page:			"common/js/utilities.js",
						description:	"UtilitiesQuote.getPublicHolidays(). Returned results were not an array: " + publicHolidaysString,
						data:			params
					});
				}

				if( typeof callback == "function" ) {
					callback(publicHolidays);
				}
			},
			error: function(obj, txt, errorThrown) {
				FatalErrorDialog.register({
					message:		"Error retrieving list of public holidays.",
					page:			"common/js/utilities.js",
					description:	"UtilitiesQuote.getPublicHolidays(). AJAX request failed: " + txt + " " + errorThrown,
					data:			params
				});
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

		var dat = {
			quoteType:"utilities",
			transactionId:referenceNo.getTransactionID()
		};
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
			error: function(obj, txt, errorThrown){
				FatalErrorDialog.exec({
					message:		"An undefined error has occured - please try again later.",
					page:			"utilities.js",
					description:	"UtilitiesQuote.checkQuoteOwnership(). AJAX request failed: " + txt + ' ' + errorThrown,
					data:			dat
				});
				return false;
			}
		});

		return true;

	},

	restartQuote: function() {
		Loading.show("Start New Quote...");
		var dat = {
			quoteType:"utilities",
			transactionId:referenceNo.getTransactionID()
		};
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
			error: function(obj, txt, errorThrown){
				Loading.hide();
				FatalErrorDialog.exec({
					message:		"Sorry, an error occurred trying to start a new quote.",
					page:			"utilities.js",
					description:	"UtilitiesQuote.restartQuote(), AJAX request failed: " + txt + ' ' + errorThrown,
					data:			dat
				});
			}
		});
	},

	// Update the form field - PRJAGGL-99
	updateReceiptId : function( receiptid, product ) {
		if($("#utilities_order_receiptid").val() == '') {
			$("#utilities_order_receiptid").val( receiptid );
			$("#utilities_order_productid").val( product.productId );
			$("#utilities_order_estimatedcosts").val( product.price.Maximum );
			UtilitiesQuote.registerSale();
		}
	},

	registerSale : function( receiptid ) {

		var dat = serialiseWithoutEmptyFields('#mainform');
		$.ajax({
			url: "ajax/json/utilities_register_sale.jsp",
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
				// Nothing to do
				return false;
			},
			error: function(obj, txt, errorThrown){
				FatalErrorDialog.register({
					message:		"An error occurred trying to start a new quote.",
					page:			"utilities.js",
					description:	"UtilitiesQuote.registerSale(), AJAX request failed: " + txt + ' ' + errorThrown,
					data:			dat
				});
			}
		});
	}
};

UtilitiesQuote._init();

