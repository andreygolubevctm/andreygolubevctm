<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="required" 	required="false"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="contactName"	value="${go:nameFromXpath(xpath)}_name" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />
<c:set var="optIn"			value="${go:nameFromXpath(xpath)}_call" />
<c:set var="contactNumberText"	value="In case you need assistance" />

<%-- Vars required for contactNumber split testing --%>
<c:if test="${data.settings['split-test-phone-number'] eq 'Y'}">
	<core:split_test codes="A,B"
			dataVar="health/contactNumberSplitTest"
			forceNew="false"
			supertagName="contactNumberSplitTest"
			paramName="contactNumber"
			var="contactNumberMandatory" />

<c:choose>
	<c:when test="${contactNumberMandatory eq 'A'}">
		<c:set var="contactNumberMandatory" value="true" />
			<c:set var="contactNumberText" value="Please provide at least one contact telephone number" />
	</c:when>
	<c:otherwise>
		<c:set var="contactNumberMandatory" value="false" />
		<c:set var="contactNumberText" value="In case you need assistance" />
	</c:otherwise>
</c:choose>
</c:if>
<%-- END: Split Test --%>

<%-- HTML --%>
<div id="${name}-selection" class="health-your_details">

	<form:fieldset legend="Your Details" >

		<form:row label="Name" className="clear">
			<field:input xpath="${xpath}/name" title="name" required="${callCentre}" size="50" />
		</form:row>

		<form:row label="Email Address" className="clear">
			<field:contact_email xpath="${xpath}/email" title="your email address" required="false" />
			<field:hidden xpath="${xpath}/previousemails" />
			<div class="helptext">We'll send any documents here</div>
		</form:row>

		<core:clear />

		<group:contact_numbers xpath="${xpath}/contactNumber" required="${contactNumberMandatory}" helptext="${contactNumberText}" />

		<c:set var="termsAndConditions">
			<div class="termsAndConditionslabel">
				I understand comparethemarket.com.au compares health insurance
				policies from a range of
				<a href='http://www.comparethemarket.com.au/health-insurance/#tab_nav_1432_0' target='_blank'>participating suppliers</a>.
				By providing my contact details I agree that comparethemarket.com.au may
				contact me about the services they provide.
			</div>
		</c:set>

		<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
		<form:row label="" className="health-contact-details-optin-group">
			<div class="termsConditionsError">
				<span>Please agree to our terms &amp; conditions</span>
			</div>
			<field:customisable-checkbox xpath="${xpath}/optin" theme="replicaLarge" value="Y" className="validate" required="false" label="${true}" title="${termsAndConditions}"
					errorMsg="Please agree to the Terms &amp; Conditions" />
		</form:row>

		<%-- COMPETITION START --%>
		<jsp:useBean id="now" class="java.util.Date" />
		<fmt:parseDate var="compStart" pattern="yyyy-MM-dd HH:mm" value="2013-11-07 09:00" type="both" />
		<fmt:parseDate var="compFinish" pattern="yyyy-MM-dd HH:mm" value="2013-12-16 09:00" type="both" />
		<c:if test="${now >= compStart and now < compFinish}">
		<form:row label="" className="health-competition-optin-group">
			<c:set var="competitionLabel">
				<div class="termsAndConditionslabel">
					For your chance to win $1000 as part of our Healthy 'n' Wealthy competition, tick here.
					Your entry will be registered when you have entered your details and have viewed our Compare page.
					<a href='http://www.comparethemarket.com.au/competition/termsandconditions.pdf' target='_blank'>Terms &amp; conditions</a>.
				</div>
			</c:set>
			<field:customisable-checkbox xpath="${xpath}/competition/optin" theme="replicaLarge" value="Y" required="false" label="${true}" title="${competitionLabel}" errorMsg="Please tick" />
			<field:hidden xpath="${xpath}/competition/previous" />
		</form:row>
		</c:if>
		<%-- COMPETITION END --%>

	</form:fieldset>

	<field:hidden xpath="${xpath}/call" />
	<field:hidden xpath="health/altContactFormRendered" constantValue="Y" />

	<simples:referral_tracking vertical="health" />
</div>


<%-- CSS --%>
<go:style marker="css-head">
	<%-- Hide the opt-in unless in Simples --%>
	<c:if test="${empty callCentre}">
	#health_application_optInEmail-group {
		display: none !important;
	}
	</c:if>
	#${name}_call {
		float:left;
	}
	.health_contactDetails_call {
		width: 400px;
		margin-left: 207px;
	}
	#${name}-selection .clear { clear:both; }
		.health-contact-details-call-group { min-height:0; }
		.health-contact-details-call-group .fieldrow_value {padding-top:5px !important;}

	.health-contact-details-optin-group {
		width: 425px;
		margin-left: 195px;
		margin-top:10px;
		margin-bottom:5px;
	}

	#${name}-selection .helptext {
		width: 400px;
		font-style: italic;
		color: #ccc;
		margin-bottom: 8px;
	}

	.health-contact-details-optin-group .fieldrow_label {
		display: none;
	}

	.health-contact-details-optin-group .fieldrow_value {
		width: 400px;
	}

	.health-contact-details-optin-group .fieldrow_value input {
		float: left;
		margin-left: 5px;
	}

	.health-contact-details-optin-group .fieldrow_value label {
		float: right;
		width: 370px;
		font-size: 88%;
	}

	<%-- COMPETITION START --%>
	.health-competition-optin-group {
		width: 425px;
		margin-left: 195px;
		margin-top:10px;
		margin-bottom:5px;
	}
	.health-competition-optin-group .fieldrow_label {
		display: none;
	}
	.health-competition-optin-group .fieldrow_value {
		width: 400px;
	}
	.health-competition-optin-group .fieldrow_value input {
		float: left;
		margin-left: 5px;
	}
	.health-competition-optin-group .fieldrow_value label {
		float: right;
		width: 370px;
		font-size: 88%;
	}
	<%-- COMPETITION END --%>
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	$(function() {
		$("#${name}_call").buttonset();
	});


	var contactEmailElement = $('#health_contactDetails_email');
	var applicationEmailElement = $('#health_application_email');
	var emailOptinElement = $('#health_application_optInEmail');

	var contactMobileElement = $('#${contactNumber}_mobile');
	var contactMobileElementInput = $('#${contactNumber}_mobileinput');
	var contactOtherElement = $('#${contactNumber}_other');
	var contactOtherElementInput = $('#${contactNumber}_otherinput');

	$('#${name}_previousemails').val( contactEmailElement.val() );
	${name}_original_phone_number = contactMobileElement.val();

	phoneNumberInteractFunction = function(){

		var tel = $(this).val();

		<%-- Optin for callback only if phone entered AND universal optin checked --%>
		if( $('#${name}_optin').is(':checked') ) {
		$('#${optIn}').val( tel.length ? 'Y' : 'N');
		} else {
			$('#${optIn}').val('N')
		}

		if(!tel.length || ${name}_original_phone_number != tel){
			$('#${name}_call').find('label[aria-pressed="true"]').each(function(key, value){
				$(this).attr("aria-pressed", "false");
				$(this).removeClass("ui-state-active");
				$('#' + $(this).attr("for")).removeAttr("checked");
			});
		};

		${name}_original_phone_number = tel;
	}

	contactMobileElementInput.on('keyup keypress blur change', phoneNumberInteractFunction);
	contactOtherElementInput.on('keyup keypress blur change', phoneNumberInteractFunction);

	$('#${contactName}').change(function() {
		<%--TODO: add messaging framework
			meerkat.messaging.publish("CONTACT_DETAILS", {name : $(this).val()});
		--%>
		$(document).trigger("CONTACT_DETAILS", [{name : $(this).val()}]);
	});


	<%-- Use both elements as the checkbox sits over the label --%>
	var universalOptinElements = [
			$('#${name}_optin'),
			$('#${name}_optin').siblings('label').first()
	];

	<%-- Trigger blur events on phone and email elements when the
		the optin checkbox is clicked --%>
	for(var i = 0; i < universalOptinElements.length; i++) {
		universalOptinElements[i].on('click', function(){
			contactEmailElement.trigger('blur');
			contactOtherElementInput.trigger('blur');
			contactMobileElementInput.trigger('blur');
	});
	}

	contactEmailElement.on('blur', function(){
		var optIn = false;
		var email = $(this).val();
		var original_email = $('#${name}_previousemails').val();
		if(isValidEmailAddress(email)) {
			optIn = true;
		}

		<%-- We want to store any valid emails entered during the users session so that
			we can opt-out the old ones and just keep the new ones. --%>
		if(isValidEmailAddress(email)) {
			var original_emails = $('#${name}_previousemails').val();
			if( original_emails != '' ) {
				var email_exists = false;
				var email_list = original_emails.split(',');
				for(var i = 0; i < email_list.length; i++) {
					if(email == email_list[i]) {
						email_exists = true;
					}
				}
				if( !email_exists ) {
					$('#${name}_previousemails').val(original_emails + ',' + email);
				}
		} else {
				$('#${name}_previousemails').val(email);
		}
		}

		<%-- Do optin for marketing if email entered AND user has selected universal login --%>
		if(isValidEmailAddress(email) && $('#${name}_optin').is(':checked') ) {
			emailOptinElement.prop('checked', true);
		} else {
			emailOptinElement.prop('checked', null);
			optIn = false;
		}

		<%-- HLT-476: only forward update the email address if application email is empty --%>
		if( isValidEmailAddress(email) && applicationEmailElement.val() == '' ) {
		applicationEmailElement.val(email);
		}

		$(document).trigger(SaveQuote.setMarketingEvent, [optIn, email]);
	});

	var contactDetailsMobile = new ContactDetails();
	var contactDetailsOther = new ContactDetails();
	contactDetailsMobile.init(contactMobileElementInput , contactMobileElement, false, true);
	contactDetailsOther.init(contactOtherElementInput , contactOtherElement, true, false);
	contactDetailsMobile.journeyStage = 1;
	contactDetailsOther.journeyStage = 1;
	var ${name}ContactDetailsCallback = function(event, inputs) {
		if(jQuery.type(inputs.name) === "string" && inputs.name != '' && $('#${contactName}').val == '') {
			$('#${contactName}').val(inputs.name);
		}
		contactDetailsMobile.setPhoneNumber(inputs, true);
		contactDetailsOther.setPhoneNumber(inputs, true);
		}
	var ${name}ContactDetailsEmailCallback = function(event, optIn, emailAddress) {
		if(contactEmailElement.val() == '') {
			contactEmailElement.val(emailAddress);
		}
	}

	<%--TODO: add messaging framework
		meerkat.messaging.subscribe("CONTACT_DETAILS", ${name}ContactDetailsCallback, window);
		meerkat.messaging.subscribe(SaveQuote.emailChangeEvent, ${name}ContactDetailsEmailCallback, window);
	--%>
	$(document).on(SaveQuote.emailChangeEvent, ${name}ContactDetailsEmailCallback);
	$(document).on("CONTACT_DETAILS", ${name}ContactDetailsCallback);

	<%-- Commented out until Retrieve Quotes has been finalised!!! AB for MS and LB
	contactEmailElement.trigger('blur');
	--%>

<c:if test="${empty callCentre}">
	<%-- Trigger blur events on elements that have values at load time --%>
	if( String($('#${contactNumber}').val()).length ) {
		contactMobileElementInput.trigger("blur");
		contactOtherElementInput.trigger("blur");
	}
	if( String(contactEmailElement.val()).length ) {
		contactEmailElement.trigger("blur");
	}
</c:if>
<c:if test="${not empty callCentre}">
	<%-- Move Step 2 contact details to top --%>
	$('#health_contactDetails-selection').insertBefore('#health_healthCover-selection');
</c:if>

	slide_callbacks.register({
		direction:	"reverse",
		slide_id:	1,
		callback: 	function() {
			$.validator.prototype.applyWindowListeners();
		}
	});

	<%-- COMPETITION START --%>
	$('#health_contactDetails_competition_optin').on('change', function() {
		if ($(this).is(':checked')) {
			$('#${contactName}').rules('add', {required:true, messages:{required:'Please enter your name to be eligible for the competition'}});
			$('#${name}_email').rules('add', {required:true, messages:{required:'Please enter your email address to be eligible for the competition'}});
			<c:if test="${!contactNumberMandatory}">
				contactMobileElementInput.rules('add', {
						requiredOneContactNumber:true,
						messages:{
							requiredOneContactNumber:'Please enter your phone number to be eligible for the competition'
		}
				});
			</c:if>
		}
		else {
			<c:if test="${empty callCentre}">$('#${contactName}').rules('remove', 'required');</c:if>
			$('#${name}_email').rules('remove', 'required');
			<c:if test="${!contactNumberMandatory}">
				contactMobileElement.rules('remove', 'requiredOneContactNumber');
			</c:if>
			$('#${contactName}').valid();
			$('#${name}_email').valid();
			contactMobileElementInput.valid();
			contactOtherElementInput.valid();
		}
	});
	<%-- COMPETITION END --%>
</go:script>

<go:script marker="js-head">
	$.validator.addMethod('termsConditionsMessage', function(value, element, param) {
		if( $(element).is(':checked') ){
			$('.termsConditionsError').hide();
			return true;
		} else {
			$('.termsConditionsError').show();
			return false;
		};
	});
</go:script>


<%-- VALIDATION --%>
<go:validate selector="${name}_optin" rule="termsConditionsMessage" parm="true" message="Please agree to the Terms &amp; Conditions" />