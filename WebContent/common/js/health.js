var Health = new Object();
Health = {
	_mode: 'quote',
	ajaxPending : false,
	ajaxPendingSingle : false,
	ajaxPendingAbout : false,
	ajaxPendingSaveConfirm: false,
	ratesPending: false,
	_resultsLoaded: false,
	_ratesLoaded: false,
	_rates: false,

	_new_quote : quoteCheck._new_quote,

	_init : function()
	{
		// Add listener when going back to the situation/benefits or rebates page start
		// a new transaction ID and also reset the compare panel of results page
		slide_callbacks.register({
			mode:		"before",
			direction:	"reverse",
			slide_id:	-1,
			callback: 	function() {
				if( QuoteEngine._options.prevSlide >= 2 && (QuoteEngine._options.prevSlide - 1) < 2 )
				{
					Health.generateNewQuote();
					Compare.reset();
				}
			}
		});

		try {
			$.address.internalChange(function(event){
				if(event.parameters.stage == 1) {
					Compare.reset();
				}
			});
		} catch(e) { /* IGNORE **/ }
	},

	generateNewQuote: function()
	{
		ReferenceNo.getTransactionID( ReferenceNo._FLAG_INCREMENT );
	},

	//load in Ajax calls of the items that make up a result-set
	fetchPrices: function(){
		Health._resetLoaders();
		//Health.fetchRates();
		Loading.show("Fetching Your Health Insurance Quotes...", function() {
			//$("#loading-popup").css({"top":"150px"});
		});
		Health.fetchPricesX();
	},

	//are there any relevant ajax calls in progress?
	_inProgress: function(){
		if( Health.ajaxPending || Health.ratesPending  ){
			return true;
		};
			return false;
	},

	//has the data loaded
	_loaded: function(){
		if( Health._resultsLoaded && Health._rates) {
			return true;
		};
			return false;
	},

	//make sure the JS functions are default
	_resetLoaders: function(){
		Health._resultsLoaded = false;
		Health._ratesLoaded = false;
	},

	//check both components are correctly loaded and than render page
	_resultsGroupLoaded: function(){
		if( Health._loaded() ){
			Results.show();
		};
	},

	//a call has failed, check if both are finished
	_fail: function(txt, silent, data){
		if( !Health._inProgress() ){
			//FIX: need to kill the quote-engine from going ahead a slide (or perhaps call the previous button instead.)
			if(silent != true){
				FatalErrorDialog.exec({
					message:		"An error occurred when fetching prices:" + txt,
					page:			"health.js",
					description:	typeof data == "object" && data.hasOwnProperty("description") ? data.description : "Health._fail()",
					data:			typeof data == "object" && data.hasOwnProperty("data") ? data.data : null
				});
			};
			Health._resetLoaders();
			Loading.hide();
			return false;
		};
	},

	//call the loading and rebate rates
	fetchRates: function(){
		if(Health.ratesPending){
			return; //still waiting for an active ajax
		};

		if(!healthChoices.getRatesCheck()){
			return false; //don't have the right data
		};

		var dat = healthChoices.getRates();
		this.ratesPending = true;
		this.ajaxReq =
		$.ajax({
			url: "ajax/json/health_rebate.jsp",
			data: dat,
			dataType: "json",
			type: 'GET',
			async: false,
			timeout:30000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				Health.ratesPending = false;
				if(jsonResult.status == 'ok'){
					Results.rates(jsonResult);
					Health._ratesLoaded = true;
					//Health._resultsGroupLoaded(); //check both parts are loaded
					Health.manual = true;
					return true;
				} else {
					Results.rates(jsonResult);
					Health._fail(jsonResult.message, true);
					Health.manual = false;
					return false;
				};
			},
			error: function(obj,txt){
				Health.ratesPending = false;
				Health._fail(txt, false, {description:"Health.fetchRates(). AJAX request returned an error.", data:dat});
				Health.manual = false;
				return false;
			}
		});

		return Health.manual;
	},

	//call the main bulk of prices!
	fetchPricesX: function(){
		if (Health.ajaxPending){
			return; // we're still waiting for the results.
		};

		if (!Health._rates){ //can't load because the rates were never called
			Health._fail('Rates were not loaded', false, {description:"Health.fetchPricesX(). No Health._rates available."});
			return false;
		};

		var dat = $("#mainform").serialize() + Health._rates + '&health_showAll=Y';

		Health.ajaxPending = true;
		this.ajaxReq =
		$.ajax({
			url: "ajax/json/health_quote_results.jsp",
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
				Health.ajaxPending = false;
				if( jsonResult.hasOwnProperty("error") )
				{
					Loading.hide();
					Results.hidePage();
					QuoteEngine._options.animating = false;
					$('#slide1').animate( { 'max-height':'5000px' }, 750 );
					QuoteEngine.gotoSlide({
						index:		1,
						speed:		"fast",
						callback:	function() {
							FatalErrorDialog.exec({
								message:		jsonResult.error,
								page:			"health.js",
								description:	"Health.fetchPricesX(). JSON Result contained an error message.",
								data:			jsonResult
							});
						}
					});
				}
				else
				{
					Health._resultsLoaded = true;
					Results.prices(jsonResult.results.price);
					Health._resultsGroupLoaded(); //check both parts are loaded
					Health.manual = true;
				}
				return true;
			},
			error: function(obj,txt){
				Loading.hide();
				Health.ajaxPending = false;
				Health.manual = false;
				FatalErrorDialog.exec({
					message:		"An undefined error has occurred - please try again later.",
					page:			"health.js",
					description:	"Health.fetchPricesX(). AJAX request returned an error: " + txt,
					data:			dat
				});
				return false;
			}
		});

		return Health.manual;
	},

	//the single price call
	fetchPrice: function(){
		if (Health.ajaxPendingSingle){
			return; // we're still waiting for the results.
		};

		if (!Health._rates){ //can't load because the rates were never called
			Health._fail('Rates were not loaded', {description:"Health.fetchPrice(). No Health._rates available."});
			return false;
		};

		var dat = $("#mainform").serialize();
		Health.ajaxPendingSingle = true;
		this.ajaxReq =
		$.ajax({
			url: "ajax/json/health_quote_results.jsp",
			data: dat + Health._rates + '&health_showAll=N&ignoretouch=Y',
			dataType: "json",
			type: "POST",
			async: false,
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
				Health.ajaxPendingSingle = false;

				//make sure the single product is actually available
				if(jsonResult.results.price.available == 'N'){
					Health.manualSingle = false;
					return false;
				} else {
					Results._selectedProduct = jsonResult.results.price;
					Health.manualSingle = true;
					return true;
				};

			},
			error: function(obj,txt){
				Health.ajaxPendingSingle = false;
				Health.manualSingle = false;
				FatalErrorDialog.exec({
					message:		"An undefined error has occurred - please try again later.",
					page:			"health.js",
					description:	"Health.fetchPrice(). AJAX request returned an error: " + txt,
					data:			dat
				});
				return false;
			}
		});

		return Health.manualSingle;
	},

	//get the about rates
	//NOTE: this is a shared call with policy snapshot
	fetchAbout: function(id){
		if (Health.ajaxPendingAdult){
			return; // we're still waiting for the results.
		};
		Health.ajaxPendingAbout = true;
		this.ajaxReq =
		$.ajax({
			url: "health_fund_info/"+ id.toUpperCase() +"/about.html",
			dataType: "html",
			type: "GET",
			async: false,
			timeout:30000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(htmlResult){
				Health.ajaxPendingAbout = false;
				Health.aboutHTML = htmlResult;
				return true;
			},
			error: function(obj,txt){
				Health.ajaxPendingAbout = false;
				Health.aboutHTML = 'Apologies, we could not download the information at this time. Please try again.';
				return false;
			}
		});
		return Health.aboutHTML; //NOTE: also used by the save confirmation function
	},

	//Saving the confirmation information
	saveConfirmation: function( policyNo ){
		if (Health.ajaxPendingSaveConfirm){
			return; // we're still waiting for the results.
		};
		Health.ajaxPendingSaveConfirm = true;
		this.ajaxReq =
		$.ajax({
			url: "ajax/write/save_health_confirmation.jsp",
			dataType: "xml",
			data: { product:JSON.stringify(Results._selectedProduct), policyNo:policyNo, about:Health.aboutHTML, whatsNext:healthPolicySnapshot._nextInfoHTML, startDate:$('#health_payment_details_start').val(), frequency:paymentSelectsHandler.getFrequency(), policyNo:"" },
			type: "POST",
			async: true,
			timeout:30000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(xmlResult){
				Health.ajaxPendingSaveConfirm = false;
				if( $(xmlResult).find('response status').text() == 'ERROR' ){
					Health.ajaxReturnSaveConfirm = false;
					return false;
				} else {
					Health.ajaxReturnSaveConfirm = true;
					return true;
				};
			},
			error: function(obj,txt){
				Health.ajaxPendingSaveConfirm = false;
				Health.ajaxReturnSaveConfirm = false;
				return false;
			}
		});
		return Health.ajaxReturnSaveConfirm;
	},

	//call the rates to populate the form items
	setRates: function(){
		if( Health.fetchRates() ){
			var _rebate = Results.getRebate();
			Health._rates = '&health_rebate='+_rebate+'&health_loading='+Results.getLoading();

			$('#health_rebate').val(_rebate).removeAttr("disabled");
			$('#health_loading').val(Results.getLoading()).removeAttr("disabled");
			$('#health_rebates_group').slideDown();

			//create the message
			if( healthCoverDetails.getRebateChoice() == 'N') {
				var _rebateTxt = "You've chosen not to take the rebate as a reduction to your premium.  <br />No problem - your price will be displayed without the rebate";
			} else if( _rebate == '0' ) {
				var _rebateTxt = "Unfortunately you do not qualify for the Australian Government rebate.<br />Find out how the <a href='javascript:MedicareLevySurchargeDialog.launch();' title='More information about the Medicare Levy Surcharge'>Medicare Levy Surcharge</a> could impact you if you don't take out private hospital cover.";
			} else {
				var _rebateTxt = "A rebate of "+ _rebate +"% will be applied to your price";
			};

			$('#health_rebate-readonly').html(_rebateTxt);
			$('#health_loading-readonly').html('LHC loading of ' + Results.getLoading() + '% will be applied to your price');

		} else {
			Health._rates = false;
			$('#health_rebates_group').slideUp();
			$('#health_rebates, #health_loading').val('');
			$('#health_rebates-readonly, #health_loading-readonly').empty();
		};

		healthCoverDetails.setTiers();

	},
	submitApplication: function(){

		Health.touchQuote("P", function(){

			Loading.show("Submitting your application...");

			/* //FIX: Hijacked the call
			Health._appResult( {"result":{"errors":{"error":{"text":"Socket is closed","code":0}},"policyNo":"123123123","success":true,"responseTime":3836}}  );
			return;
			END://FIX */

			healthApplicationDetails.setFinalPremium();

			var dat = $("#mainform").serialize();
			Health.ajaxPending = true;
			this.ajaxReq =
			$.ajax({
				url: "ajax/json/health_application.jsp",
				data: dat + Health._rates,
				dataType: "json",
				type: "POST",
				async: true,
				timeout:600000,
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				success: function(jsonResult){
					Health.ajaxPending = false;
					Health._appResult(jsonResult);
				},
				error: function(obj, txt, errorThrown){
					Health.touchQuote("F", function(){
						Health.ajaxPending = false;
						Health._appFail(txt + ' ' + errorThrown, {description:"Health.submitApplication(). AJAX request failed: " + txt + ", " + errorThrown, data:dat});
					}, "Application Submisson. Ajax Request Failed: " + txt + ' ' + errorThrown);
					return false;
				}
			});
		});
	},
	_appResult:function(resultData){
		Loading.hide();

		if (resultData.result && resultData.result.success){
			Health.touchQuote("C", function(){
				$("#policyNumber").text(resultData.result.policyNo);
				QuoteEngine._options.nav.next();
				this.scrollTo('html');
				Health.saveConfirmation( resultData.result.policyNo );
			});
			return true;
		} else {

			var msg='';
			try {
				if (resultData.result && resultData.result.errors) {
					var target = resultData.result.errors;
					if ($.isArray(target.error)) {
						target = target.error;
					}
					$.each(target, function(i, error) {
						msg+=error.text + ' [code '+error.code+']';
						if( target.length > 1 && i < target.length - 1 ) {
							msg += "<br />";
						}
					});
					if (msg=='') {
						msg = 'An unhandled error was received.';
					}
				} else if (resultData.hasOwnProperty("error") && resultData.error && resultData.error.type=='timeout'){
					msg= "Fund application service timed out.";
				} else if (resultData.hasOwnProperty("error") && typeof resultData.error == "object" && resultData.error.hasOwnProperty("code")) {
					msg='['+resultData.error.code+'] ' + resultData.error.message;
				} else {
					msg='An unhandled error was received.';
				}
			} catch(e) {
				msg='An unexpected error occurred.';
			}

			Health.touchQuote("F", function(){
				Health._appFail(msg, {description:"Health._appResult(). Submission of application failed: " + msg, data:resultData});
				//call the custom fail handler for each fund
				if (healthFunds.applicationFailed) {
					healthFunds.applicationFailed();
				}
			}, "Application Submisson. Application Rejected: " + msg);
			return false;
		}
	},

	_appFail:function(txt, data){
		Loading.hide();
		FatalErrorDialog.exec({
			message:		"Application failed due to a technical error: " + txt,
			page:			"health.js",
			description:	typeof data == "object" && data.hasOwnProperty("description") ? data.description : "Health._appFail()",
			data:			typeof data == "object" && data.hasOwnProperty("data") ? data.data : null
		});
	},

	checkQuoteOwnership: function( callback )
	{
		var dat = {quoteType:"health"};
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
						page:			"health.js",
						description:	"Health.checkQuoteOwnership(). JSON result was not successful: "+ jsonResult.result.message,
						data:			dat
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
					page:			"health.js",
					description:	"Health.checkQuoteOwnership(). AJAX request failed: "+ txt,
					data:			dat
				});
			}
		});

		return true;
	},

	touchQuote: function( touchtype, callback, comment )
	{
		comment = comment || null;

		var dat = {touchtype:touchtype};

		if( comment != null && touchtype == 'F' ) {
			dat.comment = encodeURIComponent(comment);
		}

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
						page:			"health.js",
						description:	"Health.touchQuote(). JSON result was not successful: " + jsonResult.result.message,
						data:			dat
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
					page:			"health.js",
					description:	"Health.touchQuote(). AJAX request failed: " + txt,
					data:			dat
				});
			}
		});

		return true;
	}
};

Health._init();

function returnAge(_dobString){
	var _now = new Date;
		_now.setHours(00,00,00);
	var _dob = returnDate(_dobString);
	var _years = _now.getFullYear() - _dob.getFullYear();

	if(_years < 1){
		return (_now - _dob) / (1000 * 60 * 60 * 24 * 365);
	};

	//leap year offset
	var _leapYears = _years - ( _now.getFullYear() % 4);
	_leapYears = (_leapYears - ( _leapYears % 4 )) /4;
	var _offset1 = ((_leapYears * 366) + ((_years - _leapYears) * 365)) / _years;

	//birthday offset - as it's always so close
	if(  (_dob.getMonth() == _now.getMonth()) && (_dob.getDate() > _now.getDate()) ){
		var _offset2 = -.005;
	} else {
		var _offset2 = +.005;
	};

	var _age = (_now - _dob) / (1000 * 60 * 60 * 24 * _offset1) + _offset2;
	return _age;
};

function returnDate(_dobString){
	return new Date(_dobString.substring(6,10), _dobString.substring(3,5) - 1, _dobString.substring(0,2));
};

/**
 * isLessThan31Or31AndBeforeJuly1() test whether the dob provided makes the user less than
 * 31 or is currently 31 but the current datea is before 1st July following their birthday.
 *
 * @param _dobString	String representation of a birthday (eg 24/02/1986)
 * @returns {Boolean}
 */
function isLessThan31Or31AndBeforeJuly1(_dobString) {
	var age = Math.floor(returnAge(_dobString));
	if( age < 31 ) {
		return false;
	} else if( age == 31 ){
		var dob = returnDate(_dobString);
		var birthday = returnDate(_dobString);
		birthday.setFullYear(dob.getFullYear() + 31);
		var now = new Date();
		if ( dob.getMonth() + 1 < 7 && (now.getMonth() + 1 >= 7 || now.getFullYear() > birthday.getFullYear()) ) {
			return true;
		} else if (dob.getMonth() + 1 >= 7 && now.getMonth() + 1 >= 7 && now.getFullYear() > birthday.getFullYear()) {
			return true;
		} else {
			return false;
		}
	} else {
		return true;
	}
}

//reset the radio object from a button container
function resetRadio($_obj, value){
	$_obj.find('input').removeAttr('checked');
	$_obj.find('input[value='+ value +']').attr('checked', true);
	$_obj.find('input').button('refresh');
};

//return a number with a leading zero if required
function leadingZero(value){
	if(value < 10){
		value = '0' + value;
	};
	return value;
}
