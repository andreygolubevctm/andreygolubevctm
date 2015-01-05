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
				utilitiesChoices.updateApplyNowSlide();

				var template = $("#terms-template").html();
				var msg = $(parseTemplate( template, Results._selectedProduct ) );
				$('#termsConditions').html(msg);

				$('#page').show();
				$('#resultsPage').hide();

				$('.right-panel').not('.slideScrapesContainer').show();
				$("#next-step").css("width", "170px");
				$("#next-step span").html("Submit Application");
			}
		});

		// Apply Now
		slide_callbacks.register({
			mode:		'before',
			slide_id:	3,
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
			errors = [''];
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
			dat += "&transactionId="+referenceNo.getTransactionID();
			
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
					if(typeof json.errors != 'undefined' && json.errors.length > 0) {
						Loading.hide();
						ServerSideValidation.outputValidationErrors({
							validationErrors: json.error.errorDetails.validationErrors,
							startStage: 0,
							singleStage: true
						});

						/* TODO -- FIX
						if (typeof json.error.transactionId != 'undefined') {
							referenceNo.setTransactionId(json.error.transactionId);
						}
						*/
						return false;
					} else if (json.plans.length == 0) {
						var msgs = [];

							msgs.push({code:0,message:"No products were found"});

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
					/* TODO -- FIX
					if( json.price.length ) {
						for(var i = 0; i < json.price.length; i++) {
							json.price[i].transactionId = json.transactionId;
						}
					}
					*/
					$("#utilities_partner_uniqueCustomerId").val(json.uniqueCustomerId);
					Results.update(json.plans);
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

	fetchProductDetail: function( product, callback ) {

			var dat = {
				productId: product.planId
			};

			$.ajax({
			url: "utilities/moreinfo/get.json",
				data: dat,
				type: "POST",
				async: true,
				dataType: "json",
				timeout:60000,
				cache: false,
				success: function(json){
				if (json.errors.length >0 ) {
						return false;
					}

				$.extend(true, product, json);

					if( typeof callback == "function" ) {
						callback();
					}

				return false;
				},
				error: function(obj,txt,errorThrown) {
				UtilitiesQuote.error('Sorry, unable to find product '+productId, txt+' '+errorThrown, {
						description:	"UtilitiesQuote.fetchProductDetail(). AJAX request failed: " + txt + " " + errorThrown,
						data:			dat
					});

				if( typeof callback == "function" ) {
					callback(null);
				}


					return false;
				}
			});
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
	
		_.delay(function(){
		QuoteEngine.prevSlide();
		},1000)
		
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
					UtilitiesQuote.ajaxPending = false;
					UtilitiesQuote.errorSubmitApplication(txt + ' ' + errorThrown, {
						description:	"UtilitiesQuote.submitApplication(). AJAX request failed: " + txt + " " + errorThrown,
						data:			dat
					});
					return false;
				}
			});

		}

	},


	getUtilitiesForPostcode : function(postcode, suburb, callback) {

		// updated for thoughtworld

		var dat = {
			postcode: postcode,
			suburb: suburb,
			transactionId: referenceNo.getTransactionID()
		};

		$.ajax({
			url: "utilities/providers/get.json",
			data: dat,
			type: "POST",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			success: function(json){
				if (json.errors.length >0 ) {
					return false;
				}

				if( typeof callback == "function" ) {
					callback(json);
				}

				return false;
			},
			error: function(obj,txt,errorThrown) {
				UtilitiesQuote.error('Sorry, it looks like energy comparison services are not available for your state at this time. For general information regarding your energy bills and consumption, we\'d suggest visiting <a href="http://www.energymadeeasy.gov.au">www.energymadeeasy.gov.au</a> ('+postcode+')', "", {
					description:	"UtilitiesQuote.getUtilitiesForPostcode() " + txt + " " + errorThrown,
					data:			dat
				});

				if( typeof callback == "function" ) {
					callback(null);
				}


					return false;
				}
				});


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

			}
	}
};

UtilitiesQuote._init();

