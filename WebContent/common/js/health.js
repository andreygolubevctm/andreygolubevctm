var HealthMode = new Object();
HealthMode = {
	CONFIRMATION: 'confirmation',
	QUOTE: 'quote'
};
var Health = new Object();
Health = {
	_mode: HealthMode.QUOTE,
	ajaxPending : false,
	ajaxPendingSingle : false,
	ajaxPendingAbout : false,
	ajaxPendingSaveConfirm: false,
	ajaxPendingRates: false,
	ajaxReq: false,
	confirmed : false,
	_resultsLoaded: false,
	_ratesLoaded: false,
	_rates: false,
	confirmationID: '',
	loadingSavedResults : false,
	savedResultsTransactionId : '',

	// Need to ensure request details can be stored when fatal error thrown
	_lastRebatesCall : {
		data : null,
		response : null
	},
	_lastRatesCall : {
		data : null,
		response : null
	},
	
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
				if( QuoteEngine._options.prevSlide >= 2 && (QuoteEngine._options.prevSlide - 1) < 2 ) {
					QuoteEngine._options.trackOnStep = false;
					referenceNo.generateNewTransactionID(3, function(transactionId) {
						Track.nextClicked(QuoteEngine.getCurrentSlide());
						QuoteEngine.trackOnStep = true;
					});
					Compare.reset();
					contactPanelHandler.reinit();
				}
			}
		});
		
		// Add listener when going to application phase to reset the call us
		// window scroll event listener
		slide_callbacks.register({
			mode:		"after",
			direction:	"forward",
			slide_id:	3,
			callback: 	function() {				
				contactPanelHandler.reinit();
			}
		});
		
		// Add listener to toggle the alt-results button on slide 2
		slide_callbacks.register({
			mode:		"after",
			slide_id:	-1,
			callback: 	function() {
				Results._editBenefits = false;
				if( QuoteEngine._options.currentSlide == 1 ) {
					$('#results-alt-buttons').show();
					$('#next-step').hide();
				} else {
					$('#results-alt-buttons').hide();
					$('#next-step').show();
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
	
	//load in Ajax calls of the items that make up a result-set
	fetchPrices: function(incrementTransactionId){
		Health._resetLoaders();	
		//Health.fetchRates();
		Loading.show("Fetching Your Health Insurance Quotes...", function() {
			//$("#loading-popup").css({"top":"150px"});
		});		
		Health.fetchPricesX(incrementTransactionId);
	},
	
	//are there any relevant ajax calls in progress?
	_inProgress: function(){
		if( Health.ajaxPending || Health.ajaxPendingRates  ){
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
		if (Health.ajaxPendingRates && this.ajaxReq) {
			this.ajaxReq.abort(); //Abort previous call so can get rates using latest params
		};
		
		if(!healthChoices.getRatesCheck()){			
			return false; //don't have the right data
		};
		
		var dat = healthChoices.getRates();

		Health._lastRebatesCall.data = dat;

		this.ajaxPendingRates = true;
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
				Health.ajaxPendingRates = false;

				Health._lastRebatesCall.response = jsonResult;

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
				Health._lastRebatesCall.response = txt;
				Health.ajaxPendingRates = false;
				Health._fail(txt, false, {description:"Health.fetchRates(). AJAX request returned an error.", data:dat});
				Health.manual = false;
				return false;
			}
		});

		return Health.manual;
	},
		
	//call the main bulk of prices!
	fetchPricesX: function(incrementTransactionId) {
		if (Health.ajaxPending){			
			return; // we're still waiting for the results.
		};
		
		if (!Health._rates){ //can't load because the rates were never called
			Health._fail('Rates were not loaded', false, {description:"Health.fetchPricesX(). No Health._rates available.", data: Health._lastRebatesCall});
			return false;
		};
		
		var dat = serialiseWithoutEmptyFields('#mainform') + Health._rates + '&health_showAll=Y&health_onResultsPage=Y';
		
		if (Health.loadingSavedResults) {
			dat +="&health_retrieve_SavedResults=Y&health_retrieve_transactionId=" + Health.savedResultsTransactionId;
		} else {
			dat +="&health_retrieve_SavedResults=N";
		}
		incrementTransactionId = incrementTransactionId || referenceNo.waitingOnNewTransactionId;
		if(incrementTransactionId) {
			referenceNo.cancelGenerateNewTransactionID();
		}
		dat +="&health_incrementTransactionId="+ incrementTransactionId;

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
				if( jsonResult.hasOwnProperty("error") || jsonResult.results.price.hasOwnProperty("error") ) {
					var errorMessage = 'Unhandled error.';
					if (jsonResult.error && typeof jsonResult.error.transactionId != 'undefined') {
						referenceNo.setTransactionId(jsonResult.error.transactionId);
						if (jsonResult.error.message) {
							errorMessage = jsonResult.error.message;
						}
					}
					else if (jsonResult.results && jsonResult.results.price && typeof jsonResult.results.price.transactionId != 'undefined') {
						referenceNo.setTransactionId(jsonResult.results.price.transactionId);
						if (jsonResult.results.price.error.message) {
							errorMessage = jsonResult.results.price.error.message;
						}
					}
					Track.healthResults(referenceNo.getTransactionID(false));
					Loading.hide();
					Results.hidePage();
					QuoteEngine._options.animating = false;
					$('#slide1').animate( { 'max-height':'5000px' }, 750 );
					QuoteEngine.gotoSlide({
						index:		1, 
						speed:		"fast", 
						callback:	function() {
							FatalErrorDialog.exec({
								message:		errorMessage,
								page:			"health.js",
								description:	"Health.fetchPricesX(). JSON Result contained an error message.",
								data:			jsonResult
							});
						}
					});
				} else {
					if(typeof( jsonResult.results.info.transactionId) != 'undefined') {
						referenceNo.setTransactionId(jsonResult.results.info.transactionId);
				}
					Track.healthResults(referenceNo.getTransactionID(false));
					Health._resultsLoaded = true;
					Results._pricesHaveChanged = jsonResult.results.info.pricesHaveChanged;
					Results.prices(jsonResult.results.price);
					Health._resultsGroupLoaded(); //check both parts are loaded
					Health.manual = true;
					Health.loadingSavedResults = false;

					//--- COMPETITION START
					var contactNumber = "";
					var contactNumberMobileVal = $('#health_contactDetails_contactNumber_mobile').val();
					if(contactNumberMobileVal != "") {
						contactNumber = contactNumberMobileVal;
					} else {
						contactNumber = $('#health_contactDetails_contactNumber_other').val();
				}
					$('#health_contactDetails_competition_previous').val($('#health_contactDetails_name').val() + '::' + $('#health_contactDetails_email').val() + '::' + contactNumber);
					//--- COMPETITION END
				}
				return true;
			},
			error: function(obj, txt, errorThrown){
				Loading.hide();
				Health.ajaxPending = false;
				Health.manual = false;
				FatalErrorDialog.exec({
					message:		"An undefined error has occurred - please try again later.",
					page:			"health.js",
					description:	"Health.fetchPricesX(). AJAX request returned an error: " + txt + ' ' + errorThrown,
					data:			dat
				});
				Track.healthResults(referenceNo.getTransactionID(false));
				return false;
			}
		});
	
		return Health.manual;
	},
	
	//the single price call
	fetchPrice: function(onResultsPage){
		if (Health.ajaxPendingSingle){
			return; // we're still waiting for the results.
		};
		
		if (!Health._rates){ //can't load because the rates were never called
			Health._fail('Rates were not loaded', {description:"Health.fetchPrice(). No Health._rates available.", data: Health._lastRebatesCall});
			return false;
		};
		
		var dat = serialiseWithoutEmptyFields('#mainform');
		Health.ajaxPendingSingle = true;
		var dataInput = dat + Health._rates + '&health_showAll=N';
		if(onResultsPage) {
			dataInput += '&health_onResultsPage=Y';
		}
		this.ajaxReq = 
		$.ajax({
			url: "ajax/json/health_quote_results.jsp",
			data: dataInput,
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
					// Remove once testing completed
					Health.injectAltPremium(jsonResult.results.price);
					
					Results._selectedProduct = jsonResult.results.price;
					Health.manualSingle = true;
					return true;					
				};				

			},
			error: function(obj, txt, errorThrown) {
				Health.ajaxPendingSingle = false;
				Health.manualSingle = false;
				FatalErrorDialog.exec({
					message:		"An undefined error has occurred - please try again later.",
					page:			"health.js",
					description:	"Health.fetchPrice(). AJAX request returned an error: " + txt + ' ' + errorThrown,
					data:			dat
				});
				return false;
			}
		});
	
		return Health.manualSingle;
	},
	
	injectAltPremium: function(jsonObject) {
		
		// Comment this out if you want to force injection of dummy altPremium data
		return;
	
		if(typeof jsonObject == 'undefined'){
			return;
		};
		
		var rate = 1.1; // 10% rise
	
		if( jsonObject.constructor == Array ) {
			for(var i = 0; i < jsonObject.length; i++) {
				if(!jsonObject[i].hasOwnProperty("altPremium")) {
					jsonObject[i].altPremiumFrom = altPremium.from;
					jsonObject[i].altPremium = {};
					for(var j in jsonObject[i].premium) {
						jsonObject[i].altPremium[j] = {};
						jsonObject[i].altPremium[j].discounted = jsonObject[i].premium[j].discounted;
						jsonObject[i].altPremium[j].pricing = jsonObject[i].premium[j].pricing;
						var val = Number((Number(jsonObject[i].premium[j].value) * rate).toFixed(2));
						jsonObject[i].altPremium[j].text = val.formatMoney();
						jsonObject[i].altPremium[j].value = val;
					}
				}
			}
		} else {
			if(!jsonObject.hasOwnProperty("altPremium")) {
				jsonObject.altPremiumFrom = altPremium.from;
				jsonObject.altPremium = {};
				for(var k in jsonObject.premium) {
					jsonObject.altPremium[k] = {};
					jsonObject.altPremium[k].discounted = jsonObject.premium[k].discounted;
					jsonObject.altPremium[k].pricing = jsonObject.premium[k].pricing;
					var val = Number((Number(jsonObject.premium[k].value) * rate).toFixed(2));
					jsonObject.altPremium[k].text = val.formatMoney();
					jsonObject.altPremium[k].value = val;
				}
			}
			
		}
	},
	
	//get the about rates
	//NOTE: this is a shared call with policy snapshot
	fetchAbout: function(id){
		if (Health.ajaxPendingAbout){
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
	saveConfirmation: function( _policyNo, _confirmationID ) {
		if (Health.ajaxPendingSaveConfirm){
			return; // we're still waiting for the results.
		};
		Health.confirmed = true;
		Health.confirmationID = _confirmationID;
				Health.ajaxPendingSaveConfirm = false;
					Health.ajaxReturnSaveConfirm = true;
					QuoteEngine._callbackIfNavigationIsDisabled =  function() {
						Health.updateURLToConfirmationPageURL();
					};
					Health.updateURLToConfirmationPageURL();
		return Health.ajaxReturnSaveConfirm;
	},	
	
	updateURLToConfirmationPageURL: function(){
		var newURL = "health_quote.jsp?action=confirmation&ConfirmationID="
			+ Health.confirmationID + "#/?stage=5";
		if(window.history.pushState) {
			window.history.pushState("confirmation", "Compare The Market Australia - Health Quote Confirmation", newURL);
		} else {
			window.location.replace(newURL);

		}
	},
	//call the rates to populate the form items
	setRates: function(){		
		if( Health.fetchRates() ){
			var _rebate = Results.getRebate();
			Health._rates = '&health_rebate='+_rebate+'&health_loading='+Results.getLoading();
			
			$('#health_rebate').val(_rebate).removeAttr("disabled");
			$('#health_loading').val(Results.getLoading()).removeAttr("disabled");
			//$('#health_rebates_group').slideDown();
			
			//create the message
			if( healthCoverDetails.getRebateChoice() == 'N') {
				var _rebateTxt = "You've chosen not to take the rebate as a reduction to your premium.  <br />No problem - your price will be displayed without the rebate";
			} else if( _rebate == '0' ) {
				var _rebateTxt = "Unfortunately you do not qualify for the Australian Government rebate.<br />Find out how the <a href='javascript:MedicareLevySurchargeDialog.launch();' title='More information about the Medicare Levy Surcharge'>Medicare Levy Surcharge</a> could impact you if you don't take out private hospital cover.";
			} else {
				var _rebateTxt = "A rebate of "+ _rebate +"% will be applied to your price";
			};
			
			$('#health_rebate-readonly').html(_rebateTxt);
			$('#health_loading-readonly').html('Your estimated LHC loading is ' + Results.getLoading() + '%');

		} else {
			Health._rates = false;
			//$('#health_rebates_group').slideUp();
			$('#health_rebates, #health_loading').val('');
			$('#health_rebates-readonly, #health_loading-readonly').empty();
		};
		
		healthCoverDetails.setTiers();
		
	},
	submitApplication: function(){
		if(!Health.ajaxPending) {
			Health.ajaxPending = true;
			QuoteEngine._allowNavigation= false;
			Loading.show("Submitting your application...");
			healthApplicationDetails.setFinalPremium();
			
			var dat = serialiseWithoutEmptyFields('#mainform');
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
						Health._appResult(jsonResult);
					Health.ajaxPending = false;
				},
				error: function(obj, txt, errorThrown){
						QuoteEngine._allowNavigation=true;
						Write.touchQuote("F", function(){
						Health.ajaxPending = false;
						Health._appFail(txt + ' ' + errorThrown, {description:"Health.submitApplication(). AJAX request failed: " + txt + ", " + errorThrown, data:dat});
					}, "Application Submisson. Ajax Request Failed: " + txt + ' ' + errorThrown);
					return false;
				}
			});
		}
	},
	_appResult:function(resultData){
		QuoteEngine._allowNavigation=true;
		Loading.hide();
		// go to confirmation page then disable the slider
		if (resultData.result && resultData.result.success){
				$("#policyNumber").text(resultData.result.policyNo);
				QuoteEngine._options.nav.next();
				QuoteEngine.scrollTo('html');
			QuoteEngine._allowNavigation=false;
			Health.saveConfirmation( resultData.result.policyNo, resultData.result.confirmationID );
			if (typeof(callMeBack) !== 'undefined' && callMeBack.hide) {
				callMeBack.hide();
			}
			return true;
		} else {
			var msg='';
			try {
				// Handle errors return by provider
				if (resultData.result && resultData.result.errors) {
					var target = resultData.result.errors;
					if ($.isArray(target.error)) {
						target = target.error;
					}
					$.each(target, function(i, error) {
						msg += '[code '+error.code+'] ' + error.original;
						if( target.length > 1 && i < target.length - 1 ) {
							msg += "<br />";
						}
					});
					if (msg=='') {
						msg = 'An unhandled error was received.';
					}
				// Handle internal SOAP error
				} else if (resultData.hasOwnProperty("error") && typeof resultData.error == "object" && resultData.error.hasOwnProperty("type")) {
					switch(resultData.error.type) {
						case "timeout":
					msg= "Fund application service timed out.";
							break;
						case "parsing":
							msg = "Error parsing the XML request - report issue to developers.";
							break;
						case "confirmed":
							msg = "application has already been submitted";
							break;
						case "http":
						default:
							msg ='['+resultData.error.code+'] ' + resultData.error.message + " (report issue to developers)";
							break;
					}
				// Handle unhandled error
				} else {
					msg='An unhandled error was received.';
				}
			} catch(e) {
				msg='An unexpected error occurred.';
			}
			
				Health._appFail(msg, {description:"Health._appResult(). Submission of application failed: " + msg, data:resultData});
				//call the custom fail handler for each fund
				if (healthFunds.applicationFailed) {
					healthFunds.applicationFailed();
			};
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
			error: function(obj, txt, errorThrown) {
				FatalErrorDialog.exec({
					message:		"An undefined error has occurred - please try again later.",
					page:			"health.js",
					description:	"Health.checkQuoteOwnership(). AJAX request failed: "+ txt + ' ' + errorThrown,
					data:			dat
				});
			}
		});
	
		return true;
	},
		
	touchQuote: function(touchtype, callback, comment, allData)
	{
		comment = comment || null;
		allData = allData || false;
		
		var dat = {touchtype:touchtype};
		
		if (comment != null) {
			dat.comment = comment;
		}
		
		//Send form data unless recording a Fail
		if (allData === true) {
			dat = $.param(dat) + '&' + serialiseWithoutEmptyFields('#mainform');
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
						description:	"Write.touchQuote(). JSON result was not successful: " + jsonResult.result.message,
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
			error: function(obj, txt, errorThrown) {
				FatalErrorDialog.exec({
					message:		"An undefined error has occurred - please try again later.",
					page:			"health.js",
					description:	"Write.touchQuote(). AJAX request failed: " + txt + ' ' + errorThrown,
					data:			dat
				});
			}
		});
		
		return true;
	},
	gotToConfirmation: function() {
		$('.button-wrapper, .qe-screen').css('visibility','hidden');

		//Bypass QuoteEngine and all its callbacks
		if (Health._mode === HealthMode.CONFIRMATION) {
			$('#slide5').css( { 'visibility':'visible', 'max-height':'5000px' });
			$('body').removeClass('stage-0').addClass('stage-5');
			$('#qe-main').css('left', -$('#slide5').position().left);
			Confirmation.init();
		}
		else {
		QuoteEngine.gotoSlide({'noAnimation':true, 'index':5});
	}
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

function returnDate(_dateString){
	return new Date(_dateString.substring(6,10), _dateString.substring(3,5) - 1, _dateString.substring(0,2));
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

Number.prototype.formatMoney = function(c, d, t){
	var n = this, 
		c = isNaN(c = Math.abs(c)) ? 2 : c, 
		d = d == undefined ? "." : d, 
		t = t == undefined ? "," : t, 
		s = n < 0 ? "-" : "", 
		i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", 
		j = (j = i.length) > 3 ? j % 3 : 0;
		
	return '$' + s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

isValidEmailAddress = function(emailAddress) {
	var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
	return pattern.test(emailAddress);
};
