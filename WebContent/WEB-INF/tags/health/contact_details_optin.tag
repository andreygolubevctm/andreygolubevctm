<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="required" 	required="false"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />
<c:set var="optIn"			value="${go:nameFromXpath(xpath)}_call" />


<%-- HTML --%>
<div id="${name}-selection" class="health-your_details">

	<form:fieldset legend="Your Details" >

		<form:row label="Name" className="clear">
			<field:input xpath="${xpath}/name" title="name" required="${callCentre}" size="50" />
		</form:row>

		<form:row label="Email Address" className="clear">
			<field:contact_email xpath="${xpath}/email" title="your email address" required="false" />
			<div class="helptext">We'll send any documents here</div>
		</form:row>

		<form:row label="Phone Number">
			<field:contact_telno xpath="${xpath}/contactNumber" required="false" className="contact_number" />
			<div class="helptext">In case you need assistance</div>
		</form:row>

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

	</form:fieldset>

	<field:hidden xpath="${xpath}/call" />
	<field:hidden xpath="health/altContactFormRendered" constantValue="Y" />

</div>


<%-- CSS --%>
<go:style marker="css-head">
	#health_application_optInEmail-group {
		display: none !important;
	}
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
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	$(function() {
		$("#${name}_call").buttonset();
	});

	${name}_original_phone_number = $('#${contactNumber}').val();

	$('#${optIn}').val( $('#${contactNumber}').val().length ? 'Y' : 'N');

	$('#${contactNumber}').on('update keypress blur', function(){

		var tel = $(this).val();

		$('#${optIn}').val( tel.length ? 'Y' : 'N');

		if(!tel.length || ${name}_original_phone_number != tel){
			$('#${name}_call').find('label[aria-pressed="true"]').each(function(key, value){
				$(this).attr("aria-pressed", "false");
				$(this).removeClass("ui-state-active");
				$('#' + $(this).attr("for")).removeAttr("checked");
			});
		};

		${name}_original_phone_number = tel;
	});

	$('#${contactNumber}').on('blur', function(){
		healthChoices.setContactNumber();
	});

	var contactEmailElement = $('#health_contactDetails_email');
	var applicationEmailElement = $('#health_application_email');
	var emailOptinElement = $('#health_application_optInEmail');

	contactEmailElement.on('blur', function(){
		var optIn = false;
		var email = $(this).val();
		if(isValidEmailAddress(email)) {
			optIn = true;
		} else {
			$(this).val('');
		}
		if(isValidEmailAddress(email)) {
			emailOptinElement.prop('checked', true);
		} else {
			emailOptinElement.prop('checked', null);
		}
		applicationEmailElement.val(email);
		<%-- Commented out until Retrieve Quotes has been finalised!!! AB for MS and LB
		$(document).trigger(SaveQuote.setMarketingEvent, [optIn, email]);
		--%>
	});

	$(document).on(SaveQuote.emailChangeEvent, function(event, optIn, emailAddress) {
		if(!isValidEmailAddress(contactEmailElement.val()) && isValidEmailAddress(emailAddress) && optIn) {
			contactEmailElement.val(emailAddress).trigger('blur');
		}
	});

	<%-- Commented out until Retrieve Quotes has been finalised!!! AB for MS and LB
	contactEmailElement.trigger('blur');
	--%>

<c:if test="${empty callCentre}">
	if( String($('#${contactNumber}').val()).length ) {
		$('#${contactNumber}').trigger("blur");
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