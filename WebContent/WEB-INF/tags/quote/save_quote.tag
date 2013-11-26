<%@ tag description="save quotes pop up"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%@ attribute name="quoteType"	required="false"	description="The vertical this quote is for"%>
<%@ attribute name="vertical"	required="false"	description="The vertical this quote is for"%>
<%@ attribute name="mainJS"		required="false"	description="The vertical this quote is for"%>
<%@ attribute name="includeCallMeback"	required="false"	description="display call back after save quote"%>


<c:if test="${not empty data.userData && not empty data.userData.emailAddress}">
	<c:set var="savedEmail" value="${data.userData.emailAddress}" />
</c:if>
<c:set var="prefix" value="callmeback_save_" />
<c:set var="optinFieldXpath" value="${fn:replace(optinField, '_','/')}" />

<c:set var="isOperator">
	<c:choose>
		<c:when test="${not empty data.login.user.uid}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${empty includeCallMeback || isOperator}">
	<c:set var="includeCallMeback" value="false" />
</c:if>

<c:set var="vertical_main_js">
	<c:choose>
		<c:when test="${not empty mainJS and mainJS}">${mainJS}</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<go:style marker="css-head-ie7">
</go:style>

<go:style marker="css-head">
	.password-row, #saveQuoteCallMeBackForm {
		display: none;
	}

	#save-callmeback-result-header {
		display:none;
	}

	.save_marketing_row  {
		display:none;
		width: 100%;
	}

	.password {
		width:220px; 
	}
</go:style>

<go:style marker="css-head-ie8">
	#save-popup .primary-button {
		background-color: #009934;
	}
</go:style>

<go:style marker="css-head-ie8">
	.save-outcome-result {
		display:none;
	}
</go:style>

<c:choose>
	<c:when test="${fn:contains('car,ip,life', quoteType)}">
		<c:set var="headerText" value="Save Your Quotes" />
		<c:set var="saveButtonText" value="Save quotes" />
		<c:set var="sendConfirm" value="no" />
		<c:set var="logInInstructions" value="Click 'Save quotes' to have your quotes saved" />
		<c:set var="createLogInInstructions" value="Please create a login to have your quotes saved" />
	</c:when>
	<c:otherwise>
		<c:set var="headerText" value="Email me my quote" />
		<c:set var="saveButtonText" value="Email my quote" />
		<c:set var="logInInstructions" value="Click 'Email my quote' to have your quote emailed" />
		<c:set var="createLogInInstructions" value="Please create a login to have your quote emailed" />
		<c:set var="sendConfirm" value="yes" />
	</c:otherwise>
</c:choose>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var SessionSaveQuote = {
	_IS_OPERATOR : ${isOperator},
	quoteType :'${quoteType}',
	_VERT_MAIN_JS : ${vertical_main_js},
	SAVED_EMAIL : '${savedEmail}',
	CALLMEBACK : ${includeCallMeback},
	DEFAULT_HEADER_TEXT : '${headerText}',
	SAVE_BUTTON_TEXT : '${saveButtonText}',
	SENDCONFIRM : '${sendConfirm}',
	LOG_IN_INSTRUCTIONS : "${logInInstructions}",
	CREATE_LOG_IN_INSTRUCTIONS : "${createLogInInstructions}"
}

var SaveQuote = new Object();
SaveQuote = {
	_CONFIRM : "confirm",
	_SAVE : "save",
	_ERROR : "error",
	_AUTH_ERROR : "authentication failed",
	FORM : "FORM",
	SAVE_FORM : "SAVE_FORM",
	DATABASE : "DATABASE",
	isConfirmed : false,
	optInSelected : false,
	confirmedEvent : 'isConfirmed',
	resaveText : 'Save Quote',
	setMarketingEvent : 'setMarketing',
	emailChangeEvent : 'emailChange',
	callMeBackSubmitEvent : 'callMeBackSubmit',
	callMeBackResult : 'callMeBackResult',
	optInMap : new Object(),
	_origZ : 0,
	_mode : "",
	userExists : false,
	_callback : null,
	waitingOnCallMeResult : false,
	userRequestedCallMeBack : false,
	<c:if test="${includeCallMeback}">
	contactDetails : new ContactDetails(),
	</c:if>
	_timer: false,<%-- Holds a setTimeout --%>
	_ajaxRequest: {
		obj: false,<%-- The jquery ajax request object --%>
		requestedEmail: false,
		inProgress: false
	},
	_preservePrimaryText: '',
	confirmValid: false,
	
			
	checkQuoteOwnership : function( callback ) {
		if( typeof SessionSaveQuote._VERT_MAIN_JS == "object" && SessionSaveQuote._VERT_MAIN_JS.hasOwnProperty("checkQuoteOwnership") ) {
			SessionSaveQuote._VERT_MAIN_JS.checkQuoteOwnership( callback );
			}
		else
		{
			callback();
		}
	},
	
	updateErrorFeedback: function( errors ) {
		if(typeof errors == "object" && errors.length) {
			var element = $("#save-outcome-error-details").find(".customisable").first();
			for( var i = 0; i < errors.length; i++ ) {
				element.append( errors[i].error );
				
				if( i + 1 < errors.length ) {
					element.append("<br /><br />");
				}
			}
		}
		else
		{
			$("#save-outcome-error-details").find(".customisable").first().empty().hide();
		}
	},
	
	showResults: function() {
		$(".save-outcome-result").show();
		$("#save-operator").hide();
	},

	customError: function(message, className, elementId) {
		var error = "<li class='" + className + "'>" +
						"<label for='" + elementId + "' generated='true' class='error' style='display: inline;'>" +
							message +
						"</label>"+
					"</li>";
		$('#' + elementId).addClass('error');
		$(".error-panel-middle ul").append(error);
		$(".error-panel-middle ul").show();
		$("#save_quote_errors").show();
		$('#' + elementId).change(function() {
			if($(this).val() != '') {
				$('.' + className).remove();
			}
		});
	},

	toggleUnlock: function() {
		if( SessionSaveQuote._IS_OPERATOR ) {
			if($('#operator-save-form').find('input:checked').val() == 'Y' ) {
				$("#operator-save-form").hide();
			}
		}
	},

	/**
	 * @param defaults	Object		[optional] Contains email and optin properties to update the form with
	 * @param callback	Function	[optional] Function to call before save to update the quote form's optin field
	 */
	show: function(mode, defaults, callback){
		$(".loginExists").remove();
		SaveQuote.checkQuoteOwnership(function(){
			if (typeof mode != "undefined" && mode) {
				SaveQuote._mode = mode;
			} else {
				SaveQuote._mode = SaveQuote._SAVE;
			}	
			switch(SaveQuote._mode) {
			case SaveQuote._CONFIRM:
			if(!SaveQuote.isConfirmed) {
				<%--TODO: add listening framework
					meerkat.messaging.publish(SaveQuote.confirmedEvent);
				--%>
				$(document).trigger(SaveQuote.confirmedEvent);
				var optIn = $('#save_marketing').attr('checked') == 'checked';
				<%--TODO: add listening framework
					meerkat.messaging.publish(SaveQuote.emailChangeEvent, optIn, $("#save_email").val());
				--%>
				$(document).trigger(SaveQuote.emailChangeEvent, [optIn, $("#save_email").val()]);
				SaveQuote.isConfirmed = true;
			}
			SaveQuote.showResults();
			$(".saveQuoteInstructions").hide();
			$("#userSaveForm").hide();
			$("#save-outcome-error-details").hide();
			$("#save-outcome-result-header").text('Your quote has been saved!');
				break; 
			case SaveQuote._ERROR:
			SaveQuote.showResults();
			$("#save-outcome-success-details").hide();
			$("#save-outcome-result-header").text('Save quotes failed');
			SaveQuote.bindEmailButton();
			$('.secondary-button').show();
				break; 
		case SaveQuote._AUTH_ERROR:
			SaveQuote.customError(SaveQuote.INVALID_PASSWORD, 'loginExists', 'save_password');
			SaveQuote.bindEmailButton();
			$('.secondary-button').show();
			$("#save-outcome-success-details").hide();
			$("#save-outcome-error-details").hide();
			$("#save-outcome-result-header").hide();
			SaveQuote._mode = SaveQuote._SAVE;
			break;
			default:
			$(".save-outcome-result").hide();
				
				SaveQuote._callback = callback;
				
			<%-- If we already have a save email address (which is same as questionset), just attempt to save the quote --%>
			if ( !SessionSaveQuote._IS_OPERATOR && SaveQuote.isConfirmed) {
				var stage = QuoteEngine.getCurrentSlide();
				if (typeof $.address.parameter("stage") != 'undefined') {
					if($.address.parameter("stage") instanceof Array) {
						stage = $.address.parameter("stage")[0];
					} else {
						stage = $.address.parameter("stage");
				}
				}
				$('#' + SessionSaveQuote.quoteType + "_journey_stage").val(stage);
				Write.touchQuote("S", SaveQuote.saveCallBack, null, true);
			} else if (SessionSaveQuote._IS_OPERATOR && SaveQuote.isConfirmed) {
				$('#userSaveForm').show();
				$('.save_marketing_row').hide();
				$('.credentials').hide();
				$('.secondary-button').show();
				SaveQuote.bindUpdateButton();
				SaveQuote.bindCancelButton();
				$("#save-outcome-result-header").hide();
			} else {
				if($('#save_email').val() == '' || !$("#userSaveForm").validate().element('#save_email')) {
					SaveQuote.disablePrimaryButton();
				}
				$("#save-outcome").hide();
					$("#save-operator").hide();
					
					$("#userSaveForm").find("h4").eq(0).show();
					$("#userSaveForm").find("div.fieldrow").eq(0).show();
					$("#userSaveForm").find("div.fieldrow").eq(3).show();
				
					$("#userSaveForm").show();
					}
									
				<%-- If we're not already showing an overlay .. create one. --%>
				if (!$(".ui-widget-overlay").is(":visible")) {
					var overlay = $("<div>").attr("id","save-overlay")
											.addClass("ui-widget-overlay")
											.css({	"height":$(document).height() + "px", 
													"width":$(document).width()+"px"
												});
					$("body").append(overlay);
					$(overlay).fadeIn("fast");
						
				<%-- Otherwise just mess with the existing overlay's z-index --%>
				}
				else
				{
					SaveQuote._origZ = $(".ui-widget-overlay").css("z-index");
					$(".ui-widget-overlay").css("z-index","2000");
				}
	
				<%-- Show the popup --%>
				$("#save-popup").center().show("slide",{"direction":"down"},300);
				//omnitureReporting(20);
				break;
			}
		});
	}, 
	hide: function() {
		$("#save-popup").hide("slide",{"direction":"up"},300);
		
		<%-- Abort any ajax that is running --%>
		if (SaveQuote._ajaxRequest.inProgress && SaveQuote._ajaxRequest.obj) {
			SaveQuote._ajaxRequest.obj.abort();
			SaveQuote._ajaxRequest.inProgress = false;
		}

		<%-- Did we add a specific overlay? if so remove. --%>
		if ($("#save-overlay").length) {
			$("#save-overlay").remove();
		} else {
			$(".ui-widget-overlay").css("z-index",SaveQuote._origZ);
		}
	}, 
	contactDetailsCallback : function(event , inputs) {
		if(jQuery.type(inputs.name) === "string" && inputs.name != '') {
			$('#callmeback_save_name').val(inputs.name);
		}
		if(jQuery.type(inputs.phoneNumber) === "string" && inputs.phoneNumber != '') {
			SaveQuote.contactDetails.setPhoneNumber(inputs,true);
		}
	},
	contactDetailsCallbackResult : function(event , success, outcomeMessage) {
		if(success) {
		<%--TODO: add messaging framework
			meerkat.messaging.unSubscribe("CONTACT_DETAILS", contactDetailsCallbackHandler);
			meerkat.messaging.unSubscribe(callMeBack.callMeBackResult, contactDetailsCallbackResulthandler);
		--%>
			$(document).off("CONTACT_DETAILS", SaveQuote.contactDetailsCallback);
			$(document).off(callMeBack.callMeBackResult, SaveQuote.contactDetailsCallbackResult);
		}
		SaveQuote.userRequestedCallMeBack = success;
		if(SaveQuote.waitingOnCallMeResult) {
			$("#save-callmeback-result-header").show();
			$("#save-callmeback-result-header").text(outcomeMessage);
			SaveQuote.waitingOnCallMeResult = false;
			if(success) {
				<%--TODO: add messaging framework
					meerkat.messaging.unSubscribe("CONTACT_DETAILS", contactDetailsCallbackHandler);
				--%>
				$(document).off("CONTACT_DETAILS", SaveQuote.contactDetailsCallback);
				$('#saveQuoteCallMeBackForm').hide();
				SaveQuote.bindCloseButton(function(){
						$("#save-callmeback-result-header").hide();
				});
				$("#save-popup .secondary-button").hide();
			}
		}
	},
	onSetMarketingEventCallBack : function(event, optIn , emailAddress) {
		if(!SaveQuote.isConfirmed) {
			SaveQuote.handleOptIn(emailAddress, optIn, SaveQuote.FORM);
			if(emailAddress != '' && emailAddress != $("#save_email").val()) {
				$("#save_email").val(emailAddress);
				SaveQuote.emailChanged();
			}
		}
	},
	init : function() {
		$("#save-popup").hide();
		$("#user-save-form").hide();
		$("#save-outcome").hide();
		$("#save-operator").hide();
		<%--TODO: add messaging framework
			meerkat.messaging.subscribe(SaveQuote.setMarketingEvent, SaveQuote.onSetMarketingEventCallBack, window);
		--%>
		$(document).on(SaveQuote.setMarketingEvent, SaveQuote.onSetMarketingEventCallBack);
		if(SessionSaveQuote.CALLMEBACK && !SessionSaveQuote._IS_OPERATOR) {
			<%--TODO: add messaging framework
				meerkat.messaging.subscribe("CONTACT_DETAILS", SaveQuote.contactDetailsCallback, window);
				meerkat.messaging.subscribe(callMeBack.callMeBackResult, SaveQuote.contactDetailsCallbackResult, window);
			--%>
			$(document).on("CONTACT_DETAILS", SaveQuote.contactDetailsCallback);
			$(document).on(callMeBack.callMeBackResult, SaveQuote.contactDetailsCallbackResult);
		}
		$("#save_email").change(SaveQuote.emailKeyChange);
			
		$("#save_marketing").change(function() {
			SaveQuote.handleOptIn($("#save_email").val(), $(this).prop('checked'), SaveQuote.SAVE_FORM);
			});
		if(SessionSaveQuote.SAVED_EMAIL != '' && $('#save_email').val() != '') {
					$('#save_email').val(SessionSaveQuote.SAVED_EMAIL);
					SaveQuote.emailChanged();
				}
		if( SessionSaveQuote._IS_OPERATOR ) {
			$("#operator-save-unlock").buttonset();
		}
	},
	save: function() {
		if (SaveQuote._mode == SaveQuote._SAVE) {
			$("#userSaveForm").validate().element('#save_email');
			if($('#save_password').is(":visible")) {
				$("#userSaveForm").validate().element('#save_password');
			}
			if($('#save_confirm').is(":visible")) {
				$("#userSaveForm").validate().element('#save_confirm');
			}
		}
		<%-- If no validation errors, save the quote. --%>
		/* resetForm() doesn't work in the old version of validate that we are using */
		if ($("#userSaveForm").validate().numberOfInvalids() == 0 || SaveQuote.userExists) {
			if(SaveQuote.isConfirmed && SessionSaveQuote._IS_OPERATOR) {
				var stage = QuoteEngine.getCurrentSlide();
				if (typeof $.address.parameter("stage") != 'undefined') {
					if($.address.parameter("stage") instanceof Array) {
						stage = $.address.parameter("stage")[0];
					} else {
						stage = $.address.parameter("stage");
					}
				}
				$('#' + SessionSaveQuote.quoteType + "_journey_stage").val(stage);
				Write.touchQuote("S", SaveQuote.saveCallBack, null, true);
				if($('#operator-save-unlock').find('input:checked').val() == "Y") {
					Write.touchQuote("X");
				}
			} else {
					SaveQuote._ajaxSave();
				}		
			}
	},
	disablePrimaryButton  : function() {
		if ($("#save-popup .primary-button").attr('disabled') === undefined) {
			$("#save-popup .primary-button").attr("disabled", "disabled");
			$("#save-popup .primary-button").addClass("disabled");
			$("#save-popup .primary-button").removeClass("enabled");
		}
	},
	enablePrimaryButton  : function() {
		if ($("#save-popup .primary-button").attr('disabled') !== undefined) {
			$("#save-popup .primary-button").removeAttr("disabled")
			$("#save-popup .primary-button").addClass("enabled");
			$("#save-popup .primary-button").removeClass("disabled");
		}
	}, 
	primaryButtonWaitStart: function() {
		SaveQuote._preservePrimaryText = $("#save-popup .primary-button span").text();
		$("#save-popup .primary-button span").text('Please wait...');
	},
	primaryButtonWaitEnd: function() {
		$("#save-popup .primary-button span").text(SaveQuote._preservePrimaryText);
	},
	_ajaxSave : function() {
		<%-- Save already in progress --%>
		if (SaveQuote._ajaxRequest.inProgress) {
			return;
		}
		
		SaveQuote.primaryButtonWaitStart();
		SaveQuote.disablePrimaryButton();

		if( typeof SaveQuote._callback == "function" ) {
			SaveQuote._callback( $("input[name='save_marketing']:checked", "#userSaveForm").val() );
		}
		var dat = "";
		var url = "ajax/json/save_email_quote_mysql.jsp";
		
		if($('#saved_email').size() == 0) {
			var savedEmailEl = document.createElement("input");
			savedEmailEl.type = "hidden";
			savedEmailEl.name = "saved_email";
			savedEmailEl.id = "saved_email";
			$('#mainform').append(savedEmailEl);
		}
		
		if($('#saved_marketing').size() == 0) {
			var savedMarketingEl = document.createElement("input");
			savedMarketingEl.type = "hidden";
			savedMarketingEl.name = "saved_marketing";
			savedMarketingEl.id = "saved_marketing";
			$('#mainform').append(savedMarketingEl);
		}
		$('#saved_email').val($('#save_email').val());
		$('#saved_marketing').val($('#save_marketing').val());

		var journey_id = SessionSaveQuote.quoteType + "_journey_stage";
		if($('#' + journey_id).size() == 0) {
			var savedJournyEl = document.createElement("input");
			savedJournyEl.type = "hidden";
			savedJournyEl.name = journey_id;
			savedJournyEl.id = journey_id;
			$('#mainform').append(savedJournyEl);
		}

		var stage = QuoteEngine.getCurrentSlide();
		if (typeof $.address.parameter("stage") != 'undefined') {
			if($.address.parameter("stage") instanceof Array) {
				stage = $.address.parameter("stage")[0];
			} else {
				stage = $.address.parameter("stage");
			}
		}
		$('#' + journey_id).val(stage);

		dat = "&" + serialiseWithoutEmptyFields('#userSaveForm') + "&" + serialiseWithoutEmptyFields('#mainform') +
			"&quoteType=" +SessionSaveQuote.quoteType + "&brand=" + Settings.brand + "&vertical=" +
			Settings.vertical +
			"&sendConfirm=" + SessionSaveQuote.SENDCONFIRM;
		switch(Track._type) {
			case "Health":
				if( Health._rates !== false ) {
					dat += Health._rates;
				}
				break;
			default:
				break;
		}
		
		<%-- ajax save the quote. --%>
		SaveQuote._ajaxRequest.obj = $.ajax({
			url: url,
			data: dat,
			type: "POST",
			dataType: "json",
			async: false,
			cache: false,
			beforeSend : function(xhr,setting) {
				SaveQuote._ajaxRequest.inProgress = true;

				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				SaveQuote.primaryButtonWaitEnd();
				SaveQuote.saveCallBack(jsonResult.result == "OK" , jsonResult.transactionId);
				return false;
			},
			error: function(obj,txt, jsonResult){
				SaveQuote.primaryButtonWaitEnd();
				try {
					var errors = eval(obj.responseText);
					if(typeof errors == "object" && errors.length > 0 && errors[0].error == "Authentication Failed") {
						SaveQuote.show(SaveQuote._AUTH_ERROR);
					} else {
					SaveQuote.updateErrorFeedback(errors);
					SaveQuote.show(SaveQuote._ERROR);
					}
				} catch(e) {
					SaveQuote.updateErrorFeedback();
					SaveQuote.show(SaveQuote._ERROR);
				}
				if(SessionSaveQuote._IS_OPERATOR || ($('#save_password').val() != '' && $('#save_confirm').val() != '')) {
				SaveQuote.enablePrimaryButton();
				}
			},
			complete: function() {
				SaveQuote._ajaxRequest.inProgress = false;
			},
			timeout:30000
		});
				
		if(SessionSaveQuote._IS_OPERATOR)
				{
			$('#save_unlock').find('input').removeAttr('checked');
			$('#save_unlock').find('input').button('refresh');
					}
	},
					
	saveCallBack: function(success, transactionId) {
		if (success) {
			SaveQuote._callback = null;
			if(SaveQuote.isConfirmed || SessionSaveQuote._IS_OPERATOR || SaveQuote.userRequestedCallMeBack || !SessionSaveQuote.CALLMEBACK) {
						SaveQuote.bindCloseButton();
						$("#save-popup .secondary-button").unbind('click');
						$("#save-popup .secondary-button").hide();
			} else {
						$('#saveQuoteCallMeBackForm').show();
						SaveQuote.bindCallMeBackButton();
						SaveQuote.bindCallMeBackCloseButton();
			}
					SaveQuote.show(SaveQuote._CONFIRM);
			SaveQuote.toggleUnlock();
			try {
				if(typeof(transactionId) != 'undefined') {
					referenceNo.setTransactionId(jsonResult.transactionId);
				}
				if(SessionSaveQuote.quoteType == 'car') {
				Track.startSaveRetrieve(referenceNo.getTransactionID(false) , 'Save');
				} else if(SessionSaveQuote.quoteType == 'ip' ||
													SessionSaveQuote.quoteType == 'life' ||
													SessionSaveQuote.quoteType == 'health') {
						Track.onSaveQuote();
					}
			} catch(e){
				/* IGNORE */
				}
		}  else {
					SaveQuote.show(SaveQuote._ERROR);
				}		
		SaveQuote.enablePrimaryButton();
	},
	emailChanged  : function() {
		var valid = $("#userSaveForm").validate().valid('#save_email');
		if(!SaveQuote.isConfirmed && valid) {
			$('#save_marketing').prop('checked', SaveQuote.optInSelected);
			SaveQuote.checkUserExists();
		}
	},
	emailKeyChange  : function(e) {
		<%-- 13=Enter, 9=Tab --%>
		if (e.keyCode == 13 || e.keyCode == 9) {
			SaveQuote.emailChanged();
		}
		else {
			<%-- Input has changed --%>
			if (SaveQuote._ajaxRequest.requestedEmail != $("#save_email").val()) {
				SaveQuote.disablePrimaryButton();
				<%-- Trigger the email changed after a short time --%>
				clearInterval(SaveQuote._timer);
				SaveQuote._timer = setTimeout(SaveQuote.emailChanged, 600);
			}
			else if($('#save_password').val() != "" && $('#save_password').val() != "") {
				SaveQuote.enablePrimaryButton();
			}
		}
	},
	handleOptIn  : function(emailAddress, optInMarketing, source) {
		if(emailAddress != "") {
			SaveQuote.optInMap[[emailAddress, source]] = optInMarketing;
			var optedInDatabase = SaveQuote.optInMap[[emailAddress, SaveQuote.DATABASE]]
			optedInDatabase =  (typeof optedInDatabase != "undefined") && optedInDatabase;
				
			var optedInForm = SaveQuote.optInMap[[emailAddress, SaveQuote.FORM]];
			optedInForm = (typeof optedInForm != "undefined") && optedInForm;
								
			var optedInSaveForm = SaveQuote.optInMap[[emailAddress, SaveQuote.SAVE_FORM]];
			optedInSaveForm = (typeof optedInSaveForm != "undefined") && optedInSaveForm;

			if(optedInDatabase || optedInForm) {
				$('.save_marketing_row').hide();
				$('#save_marketing').prop('checked', true);
			} else {
				$('.save_marketing_row').show();
				$('#save_marketing').prop('checked', optedInSaveForm);
			}
		}
			},
	setToEmailMe : function() {
		$("#save-popup h5.saveQuoteTitle").text(SessionSaveQuote.DEFAULT_HEADER_TEXT);
		SaveQuote.bindEmailButton();
		SaveQuote.bindCancelButton();
	},
	bindCancelButton : function() {
		$("#save-popup .secondary-button").unbind('click');
		$("#save-popup .secondary-button").click(function(){
			SaveQuote.hide();
		});
		$("#save-popup .secondary-button").show();
	},
	bindEmailButton: function() {
		$("#save-popup .primary-button").unbind('click');
		$("#save-popup .primary-button span").text(SessionSaveQuote.SAVE_BUTTON_TEXT);
		$("#save-popup .primary-button").click(SaveQuote.save)
	},
	bindCloseButton: function(callback) {
		$("#save-popup .primary-button").unbind('click');
		$("#save-popup .primary-button span").text("Close");
		$("#save-popup .primary-button").click(function() {
			SaveQuote.hide();
			SaveQuote.bindEmailButton();
			if (typeof callback === 'function') {
				callback();
					}
		})
	},
	bindCallMeBackButton: function() {
		$("#save-popup .primary-button").unbind('click');
		$("#save-popup .primary-button span").text("Call me");
		$("#save-popup .primary-button").click(function(){
			if(!SaveQuote.waitingOnCallMeResult) {
				var callMeBackName = $("#callmeback_save_name").val();
				var callMeBackPhone = $("#callmeback_save_phone").val();
				var callMeBackTime = $("#callmeback_save_time").val();
				$("#mainform").validate().resetNumberOfInvalids();
				$("#saveQuoteCallMeBackForm :input").each(function(index) {
					var valid = $(this).valid();
				});
				// If no validation errors, save the quote..
				if ($("#saveQuoteCallMeBackForm").validate().numberOfInvalids() == 0) {
					SaveQuote.waitingOnCallMeResult = true;
					<%--TODO: add messaging framework
						meerkat.messaging.publish(callMeBack.callMeBackSubmitEvent, callMeBackName, callMeBackPhone, callMeBackTime);
						meerkat.messaging.publish("CONTACT_DETAILS", {name : callMeBackName, phoneNumber : callMeBackPhone});
					--%>
					$(document).trigger(callMeBack.callMeBackSubmitEvent, [callMeBackName, callMeBackPhone, callMeBackTime]);
					$(document).trigger("CONTACT_DETAILS", [{name : callMeBackName}]);
					}
				}
		});
	},
	bindCallMeBackCloseButton : function() {
		$("#save-popup .secondary-button").unbind('click');
		$("#save-popup .secondary-button").text("Close");
		$("#save-popup .secondary-button").click(function() {
			<%-- TODO: add messaging framework
				meerkat.messaging.unSubscribe("CONTACT_DETAILS", contactDetailsCallbackHandler);
				meerkat.messaging.unSubscribe(callMeBack.callMeBackResult, contactDetailsCallbackResultHandler);
			--%>
			$(document).off("CONTACT_DETAILS", SaveQuote.contactDetailsCallback);
			$(document).off(callMeBack.callMeBackResult, SaveQuote.contactDetailsCallbackResult);
				
			SaveQuote.waitingOnCallMeResult = false;

			$('#saveQuoteCallMeBackForm').remove();
			$('#save-callmeback-result-header').remove();

			SaveQuote.hide();
			SaveQuote.bindEmailButton();
			SaveQuote.bindCloseButton();
		});
		$("#save-popup .secondary-button").show();
			},
	bindUpdateButton: function() {
		$("#save-popup .primary-button").unbind('click');
		$("#save-popup .primary-button span").text("Update Quote");
		$('#save-popup h5.saveQuoteTitle').text("Save my Quote");
		$("#save-popup .primary-button").click(function() {
			SaveQuote.save();
		})
	},
	checkUserExists: function() {
		<%-- We're already checking, or we've already checked --%>
		if (SaveQuote._ajaxRequest.requestedEmail == $("#save_email").val()) {
			if (!SaveQuote._ajaxRequest.inProgress) {
				SaveQuote.primaryButtonWaitEnd();
				if(SessionSaveQuote._IS_OPERATOR || ($('#save_password').val() != '' && $('#save_confirm').val() != '')) {
					SaveQuote.enablePrimaryButton();
				}
			}
			return;
		}
		
		SaveQuote.primaryButtonWaitStart();
		SaveQuote.disablePrimaryButton();

		var emailAddress = $("#save_email").val();
		SaveQuote._ajaxRequest.requestedEmail = emailAddress;

		<%-- Abort any previous check user ajax that is running --%>
		if (SaveQuote._ajaxRequest.inProgress && SaveQuote._ajaxRequest.obj) {
			SaveQuote._ajaxRequest.obj.abort();
			SaveQuote._ajaxRequest.inProgress = false;
		}
	
		SaveQuote._ajaxRequest.obj = $.ajax({
			url: "ajax/json/get_user_exists.jsp",
			data: {"save_email":emailAddress,"vertical":SessionSaveQuote.quoteType},
			type: "POST",
			dataType: "json",
			async: true,
			cache: false,
			beforeSend : function(xhr,setting) {
				SaveQuote._ajaxRequest.inProgress = true;

				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},

			success: function(jsonResult){
				SaveQuote.primaryButtonWaitEnd();
				SaveQuote.userExists = jsonResult.exists;
				SaveQuote.handleOptIn(emailAddress, jsonResult.optInMarketing && jsonResult.exists, SaveQuote.DATABASE);
				if(!SessionSaveQuote._IS_OPERATOR) {
					if(jsonResult.exists) {
						$('.saveQuoteInstructions').text(SessionSaveQuote.LOG_IN_INSTRUCTIONS);
						$('.password-row').slideUp('normal');
					} else {
						$('.saveQuoteInstructions').text(SessionSaveQuote.CREATE_LOG_IN_INSTRUCTIONS);
						$('.password-row').slideDown('normal');
						$('.loginExists').remove();
						SaveQuote.listenOnPasswordChange();
				}
				}
			},
				
			error: function(obj,txt){
				SaveQuote.primaryButtonWaitEnd();
				SaveQuote.userExists = false;
				if(!SessionSaveQuote._IS_OPERATOR) {
					$('.saveQuoteInstructions').text(SessionSaveQuote.CREATE_LOG_IN_INSTRUCTIONS);
					$('.password-row').slideDown('normal', function() {
						if($("#save_password").val() == '') {
							$('#save_password').focus();
			}
		});
					$('.loginExists').remove();
					SaveQuote.listenOnPasswordChange();
				}
	},
			complete: function() {
				if(SaveQuote.userExists) {
					SaveQuote.enablePrimaryButton();
				} else {
					if(SessionSaveQuote._IS_OPERATOR) {
						SaveQuote.enablePrimaryButton();
					} else if($('#save_password').val() != '' && $('#save_confirm').val() != '') {
						SaveQuote.confirmValid = $("#userSaveForm").validate().element('#save_confirm');
						if(SaveQuote.confirmValid) {
							SaveQuote.enablePrimaryButton();
						}
					}
					SaveQuote.listenOnPasswordChange();
				}
				SaveQuote._ajaxRequest.inProgress = false;
	},
			timeout:30000
		});
	},
	listenOnPasswordChange: function() {
		$("#save_password").off('change.savequote').on('change.savequote', function() {
			var valid = $("#userSaveForm").validate().element('#save_password');
			/* only enable if confirm is valid too */
			if(valid && $('#save_confirm').val() == $('#save_password').val()) {
				SaveQuote.enablePrimaryButton();
			} else {
				SaveQuote.disablePrimaryButton();
		}
		});
		$("#save_confirm").off('change.savequote').on('change.savequote', function() {
			/* only validate if the user has interacted with save_confirm */
			SaveQuote.confirmValid = $("#userSaveForm").validate().element('#save_confirm');
			if(SaveQuote.confirmValid) {
				SaveQuote.enablePrimaryButton();
			} else {
				SaveQuote.disablePrimaryButton();
		}
		});
	},
	confirmKeyChange: function(e) {
		if($('#save_confirm').val().length >= $('#save_password').val().length) {
			SaveQuote.confirmValid = $("#userSaveForm").validate().element('#save_confirm');
			if(SaveQuote.confirmValid) {
				SaveQuote.enablePrimaryButton();
			} else {
				SaveQuote.disablePrimaryButton();
		}
		} else {
			SaveQuote.confirmValid = false;
			SaveQuote.disablePrimaryButton();
		}
	}
}
</go:script>
<go:script marker="jquery-ui">
	SaveQuote.setToEmailMe();
</go:script>
<go:script marker="onready">
	SaveQuote.init();
	<c:if test="${includeCallMeback}">
	$('#saveQuoteCallMeBackForm').validate({
		rules: {
			callmeback_save_name: {
				required:true
			},
				callmeback_save_phoneinput: {
					validateTelNo:true
			},
			callmeback_save_time: {
				required:true
			}
		},
		messages: {
				callmeback_save_phoneinput:{
					validateTelNo:"Please enter the contact number in the format (area code)(local number) for landline or 04xxxxxxxx for mobile"
				},
			callmeback_save_time: "Please select when you want us to call you back"
		},
		errorContainer: "#saveQuoteCallMeBackForm .lightBoxValidationErrors, #saveQuoteCallMeBackForm .lightBoxValidationErrors p",
		errorLabelContainer:"#saveQuoteCallMeBackForm .lightBoxValidationErrors ul",
		wrapper: "li",
		debug:true
	});
	</c:if>
	$("#userSaveForm").validate({
     	rules: { 
            save_email: { 
            	required:true,
            	email:true
            },
            save_password: {
            	required:true,
                minlength: 6            	
            },
            save_confirm: {
            	required:true,
            	equalTo:"#save_password"
            }
        }, 
        messages: { 
        	save_email: "Please enter a valid email address",
            save_password: { 
            	required: "Please enter a password",
            	minlength: jQuery.format("Password must be at least {0} characters")
            },
            save_confirm: "Password and confirmation password must match"
        },
		errorContainer: "#userSaveForm .lightBoxValidationErrors, #userSaveForm .lightBoxValidationErrors p",
		errorLabelContainer:"#userSaveForm .lightBoxValidationErrors ul",
		wrapper: "li",
		debug:true
	});
	
	$('#save_email').on('blur',function() { $(this).val($.trim($(this).val())); });
	
	<c:if test="${includeCallMeback}">
	SaveQuote.contactDetails.init($('#callmeback_save_phoneinput') , $('#callmeback_save_phone'), true, true);
	</c:if>
</go:script>

<%-- HTML --%>
<div id="save-popup">
	<h5 class="saveQuoteTitle">${headerText}</h5>
	
	
	<div class="content" >
		<form novalidate name="userSaveForm" autocomplete="off" action="none" method="POST" id="userSaveForm" style="">
			<c:choose>
				<c:when test="${isOperator}">
					<h6 class="saveQuoteInstructions vertical_fieldrow_label">Please enter the email you want the quote sent to.</h6>
				</c:when>
				<c:otherwise>
					<h6 class="saveQuoteInstructions vertical_fieldrow_label">We will check if you have an existing login or create a new one for you.</h6>
				</c:otherwise>
			</c:choose>
			
			<form:row label="Your email address" horizontal="false" className="credentials">
				<field:contact_email
							xpath="save/email"
							required="false"
							title="your email address"
							onKeyUp="SaveQuote.emailKeyChange(event);"
							/>
			</form:row>
			
			<c:if test="${!isOperator}">
				<div class="password-row" >
					<form:row label="Set password" horizontal="false" className="credentials ">
						<field:password xpath="save/password" required="false"
						title="your password" minlength="6" />
			</form:row>
			
					<form:row label="Confirm password" horizontal="false" className="credentials required" id="save_confirm_row">
						<field:password xpath="save/confirm" required="false" title="your password for confirmation"
						onKeyUp="SaveQuote.confirmKeyChange(event);"/>
			</form:row>	
				</div>
			</c:if>
						
			<div class="save_marketing_row">
				<field:customisable-checkbox
					theme="lightGrey" xpath="save/marketing"
					value="Y" required="false"
					className="marketing"
					label="true"
					title="Please keep me informed via email of news and other offers" />
			</div>
			<c:if test="${isOperator}">
			<div id="operator-save-form">
				<h4>Do you want to unlock this quote so the client can access it?</h4>
				
					<form:row label="Unlock Quote" horizontal="false">
					<field:array_radio id="operator-save-unlock" xpath="save/unlock" required="true" items="Y=Yes,N=No" title="Do you wish to unlock this quote?" />
				</form:row>
				</div>
			</c:if>
			<div id="save_quote_errors" class="lightBoxValidationErrors" >
					<div class="error-panel-top small"><h3>Oops...</h3></div>
					<div class="error-panel-middle small"><ul></ul></div>
					<div class="error-panel-bottom small"></div>
				</div>				
		</form>
		<h6 id="save-outcome-result-header" class="save-outcome-result">RESULT</h6>
		<c:if test="${!isOperator}">
			<div id="save-outcome-success-details" class="save-outcome-result">
				<p>
					To retrieve your quote <a href="${data['settings/root-url']}${data.settings.styleCode}/retrieve_quotes.jsp">click here</a>.
				</p>
			</div>
		</c:if>
		<c:if test="${!isOperator && includeCallMeback}">
			<form novalidate name="saveQuoteCallMeBackForm" action="none" method="POST" id="saveQuoteCallMeBackForm" style="">
				<h5>Get a call back</h5>
				<form:row label="Your name" horizontal="false">
					<field:input xpath="callmeback/save/name" title="name" required="false"  />
				</form:row>
						<form:row label="Your best contact number" horizontal="false">
							<field:contact_telno xpath="callmeback/save/phone" required="true" title="contact number" />
						</form:row>
						<form:row label="Best time to contact you" horizontal="false">
							<field:array_select items="=Please choose...,M=Morning,A=Afternoon,E=Evening (excludes WA)"
								xpath="callmeback/save/time" title="Best time to call"
								required="false" />
						</form:row>
						<p class="sub">Our Australian based call centre hours are<br/>Mon - Thu: 8:30am-8pm &amp; Fri: 8:30am-6:00pm (AEST)</p>
						<div id="call_back_quote_errors" class="lightBoxValidationErrors" >
				<div class="error-panel-top small"><h3>Oops...</h3></div>
				<div class="error-panel-middle small"><ul></ul></div>
				<div class="error-panel-bottom small"></div>
			</div>
			</form>
			<h6 id="save-callmeback-result-header" >RESULT</h6>
		</c:if>
		<div id="save-outcome-error-details" class="save-outcome-result">
			<p>An error occurred when trying to get a call back</p>
		<p class="customisable"><!-- empty --></p>
		<p>Please try again at a later time.</p>
	</div>
	</div>
	
	<div class="buttons">
		<button class="primary-button disabled" disabled  type="button"><span>${saveButtonText}</span></button>
		<a href="javascript:void(0);" class="secondary-button">Cancel</a>
	</div>
	<c:if test="${!isOperator && quoteType == 'health'}">
		<%-- This will float to the right when we have cross sell --%>
		<div class="promotional callUsNow">
			Compare The Market product availability can change from time to time - to ensure your first choice is still available buy today, either on-line or call us on
			<br />
			<strong>1800 777712</strong>
</div>
	</c:if>
</div>