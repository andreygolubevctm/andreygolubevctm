<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="field_email" 	value="${name}_email" />
<c:set var="is_callcentre">
	<c:choose>
		<c:when test="${empty callCentre}"><c:out value="false" /></c:when>
		<c:otherwise><c:out value="true" /></c:otherwise>
	</c:choose>
</c:set>


<%-- HTML --%>
<div id="${name}-selection" class="health_application-details">

	<form:fieldset legend="Your Contact Details">

		<h5>Residential Address</h5>
		<group:address xpath="${xpath}/address" type="R" />
		<core:clear />
		
		<%-- POSTAL defaults to Y if not pre-loaded --%>
		<c:if test="${ (empty data[xpath].postalMatch) && (empty data['health/contactDetails/email']) }">
			<go:setData dataVar="data" xpath="${xpath}/postalMatch" value="Y" />
		</c:if>	
		
		<h5>Postal Address</h5>
		<form:row label=" " >		
			<field:checkbox xpath="${xpath}/postalMatch" value="Y" title="My postal address is the same" required="false" label="I agree to receive news &amp; offer emails from Compare the Market" />
		</form:row>
		
		<div id="${name}_postalGroup">			
			<group:address xpath="${xpath}/postal" type="P" />
		</div>

		<h5>Please enter at least 1 phone number</h5>
		
		<group:contact_numbers xpath="${xpath}" required="true" />
		
		<core:clear />
		
		<form:row label="Email address" id="${name}_emailGroup">
			<span class="fieldrow_legend" id="${name}_emailMessage">we'll send your confirmation here</span>
			<field:contact_email xpath="${xpath}/email" title="your email address" required="true" size="40" />			
		</form:row>
		
		<simples:dialogue id="14" vertical="health" mandatory="true" />
		
		<form:row label=" " id="${name}_optInEmail-group" >
			<field:checkbox xpath="${xpath}/optInEmail" value="Y"
				title="Stay up to date with news and offers from comparethemarket.com.au direct to your inbox!"
				required="false"
				label="true" />
		</form:row>
		
		<form:row label=" " id="${name}_okToCall-group" >
			<field:checkbox xpath="health_contactDetails_call" value="Y"
				title="Our dedicated Health Insurance consultants will give you a call to chat about your Health Insurance needs and questions."
				required="false"
				label="true" />
		</form:row>

		<%-- Default contact Point to off --%>
		<form:row label="How would you like <span>the Fund</span> to send you information?" id="${name}_contactPoint-group"
					className="health_application-details_contact-group">
			<field:array_radio items="E=Email,P=Post" xpath="${xpath}/contactPoint" title="like the fund to contact you" required="false" id="${name}_contactPoint" />
		</form:row>
		
		<%-- Product Information --%>
		<field:hidden xpath="${xpath}/provider" className="health_application_details_provider" />
		<field:hidden xpath="${xpath}/productId" className="health_application_details_productId" />
		<field:hidden xpath="${xpath}/productName" className="health_application_details_productNumber" />
		<field:hidden xpath="${xpath}/productTitle" className="health_application_details_productTitle" />
		<field:hidden xpath="${xpath}/paymentAmt" className="health_application_details_paymentAmt" />
		<field:hidden xpath="${xpath}/paymentFreq" className="health_application_details_paymentFreq" />
		<field:hidden xpath="${xpath}/paymentHospital" className="health_application_details_paymentLHCfree" />
	
	</form:fieldset>

</div>


<%-- CSS --%>
<go:style marker="css-head">
	#${name}_postalGroup {
		min-height:0;
	}

	#${name}_mobile-group {
		width:60%;
	}
	#${name}_other-group {
		width:40%;
	}
	#${name}_other-group .fieldrow_label  {
		width:86px;
		margin-right:0px;
	}
	#${name}_optInEmail-group .fieldrow_value,
	#${name}_okToCall-group .fieldrow_value {
		margin-top:10px;
	}
	#${name}_optInEmail-group .fieldrow_value input,
	#${name}_optInEmail-group .fieldrow_value label,
	#${name}_okToCall-group .fieldrow_value input,
	#${name}_okToCall-group .fieldrow_value label {
		float: left;
	}
	#${name}_optInEmail-group .fieldrow_value label,
	#${name}_okToCall-group .fieldrow_value label {
		margin-left: 8px;
		width: 350px;
	}
	.health .error .refineSearch {
		text-decoration:underline;
		cursor:pointer;
	}
	#${name}_contactPoint-group {
		display:none;
	}
	#${name}_contactPoint-group .fieldrow_value {
		margin-top:7px;
	}
</go:style>


<%-- JAVASCRIPT --%>
<c:set var="contactPointPath" value="${xpath}/contactPoint" />
<c:set var="contactPointValue" value="${data[contactPointPath]}" />

<go:script marker="js-head">
	var healthApplicationDetails = {
		preloadedValue: '${contactPointValue}',
		periods: 1,

		init: function(){
			this.setPostal();
			$('#${name}_postalMatch').on('change', function(){
				healthApplicationDetails.setPostal();
			});
		},
		setPostal: function(){
			if( $('#${name}_postalMatch').is(':checked')  ){
				$('#${name}_postalGroup').slideUp();
			} else {
				$('#${name}_postalGroup').slideDown();
			};
		},
		<%-- this is called to populate the price premiums just before the application is submitted --%>
		setFinalPremium: function(){
			$('#${name}_paymentAmt').val( healthApplicationDetails.premium * healthApplicationDetails.periods);
			$('#${name}_paymentFreq').val( healthApplicationDetails.premium);
			$('#${name}_paymentHospital').val( healthApplicationDetails.hospitalPremium * healthApplicationDetails.periods);
		},
		showHowToSendInfo: function(providerName, required) {
			var contactPointGroup = $('#mainform').find('#${name}_contactPoint-group');
			var contactPoint = contactPointGroup.find('.fieldrow_label').find('span');
			var contactPointText = contactPoint.text();
			contactPoint.text( providerName);
			if (required) {
				contactPointGroup.find('input').rules('add', {required:true, messages:{required:'Please choose how you would like ' + providerName + ' to contact you'}});
		}
			else {
				contactPointGroup.find('input').rules('remove', 'required');
			}
			contactPointGroup.show();
		},
		hideHowToSendInfo: function() {
			var contactPointGroup = $('#mainform').find('#${name}_contactPoint-group');
			contactPointGroup.hide();
		},
		addOption: function(labelText, formValue) {
			var el = $('#mainform').find('#${name}_contactPoint');
	
			el.find('label').removeClass('ui-corner-right');
			el.find('input').removeClass('last-child');
		
			el.append('<input id="${name}_contactPoint_' + formValue + '" type="radio" name="${name}_contactPoint" value="' + formValue + '" class="last-child ui-helper-hidden-accessible">');
			el.append('<label id="${name}_contactPoint_' + formValue + '_label" for="${name}_contactPoint_' + formValue + '" aria-pressed="false" class="ui-button ui-widget ui-state-default ui-button-text-only ui-corner-right" role="button" aria-disabled="false">' + labelText + '</label>');
			el.buttonset();
		
			<%-- Reselect this option if user previously selected it (e.g. after we've loaded this quote) --%>
			if (el.find('input:checked').length == 0 && this.preloadedValue == formValue) {
				$('#${name}_contactPoint_' + formValue).prop('checked', true);
				$('#${name}_contactPoint_' + formValue + '_label').attr('aria-pressed', true).addClass('ui-state-active').removeClass('ui-state-default');
			}
	},
		removeLastOption: function() {
			var el = $('#mainform').find('#${name}_contactPoint');
			el.find('label').last().remove();
			el.find('input').last().remove();
			el.find('label').last().addClass('ui-corner-right');
			el.find('input').last().addClass('last-child');
		}
		,
		testStatesParity : function() {
			var element = $('#health_application_address_state');
			if( element.val() != $('#health_situation_state').val() ){
				<%-- Check min address requirements exist before drawing attention to this error - ONLY throw error if you have a suburb, postcode & state --%>
				var suburb = $('#health_application_address_suburbName').val();
				var postcode = $('#health_application_address_postCode').val();
				var state = $('#health_application_address_state').val();
				if( suburb.length && suburb.indexOf('Please select') < 0 && postcode.length == 4 && state.length ) {
					$('#${name}_address_postCode').addClass('error');
					return false;
				}
			}

			<%-- If not a true error then remove the error message (and hide if it was the only one) --%>
			$('#slideErrorContainer label[for="health_application_address_state"]').parent().remove();
			if( $('#slideErrorContainer .error-list').find('li:visible').length == 0 ) {
				$('#slideErrorContainer').hide();
			}
			$('#${name}_address_postCode').removeClass('error');
			return true;
		}
	};

$.validator.addMethod("matchStates",
	function(value, element) {
		return healthApplicationDetails.testStatesParity();
	},
	"Your address does not match the original state provided"
);	

</go:script>

<go:script marker="onready">

	<%-- Listen for changes in any of these any trigger parity check whether to remove the parity check error message --%>
	$('#health_application_address_postCode, #health_application_address_streetSearch, #health_application_address_suburb').change(
		healthApplicationDetails.testStatesParity
	);

	$.address.internalChange(function(event){
		if(event.parameters.stage == 3)
		{
			<%-- Check marketing optin - show if no email in questionset or IS Simples --%>
			if( $("#health_contactDetails_email").val() == '' || ${is_callcentre} === true ) {
				$('#${name}_optInEmail-group').show();
			}
			<%-- Check okToCall optin - show if no phone numbers in questionset and NOT Simples --%>
			if( $('#health_contactDetails_contactNumber_mobile').val() == '' && $('#health_contactDetails_contactNumber_other').val() == '' && ${is_callcentre} === false ) {
				$('#${name}_okToCall-group').show();
			}


			var email = $("#${field_email}").val();
			if(!email.length) {
				$("#${field_email}").val( $("#health_contactDetails_email").val() );
			}
		}
	});

	healthApplicationDetails.init();
	
	$('#${name}_address_state').addClass('validate');
	
	<%-- Go back to the start of the application question set, due to a 'fatal' type error --%>
	$('#slideErrorContainer').delegate('.refineSearch', 'click', function() {
		<%-- Update the suburb, postcode & state fields in Slide 0 --%>
		var suburb = $('#health_application_address_suburbName').val();
		var postcode = $('#health_application_address_postCode').val();
		var state = $('#health_application_address_state').val();
		$('#health_situation_location').val([suburb, postcode, state].join(' '));
		$('#health_situation_suburb').val(suburb);
		$('#health_situation_postcode').val(postcode);
		$('#health_situation_state').val(state);
		healthChoices.setState(state);

		<%-- Goto Slide 1 and resubmit for results --%>
		Results.resubmitForNewResults();
	});
	
	$(function() {
		$('#${name}_contactPoint-group').buttonset();
	});
		
	var ${name}ContactDetailsMobileInputElement = $('#health_application_mobileinput');
	var ${name}ContactDetailsOtherInputElement = $('#health_application_otherinput');

	${name}ContactDetailsMobileInputElement.on('blur', function(event) {
		if($(this).valid()) {
		healthChoices.setContactNumberReverse();
		}
	});
	${name}ContactDetailsOtherInputElement.on('blur', function(event) {
		if($(this).valid()) {
			healthChoices.setContactNumberReverse();
	}
	});
	var ${name}OtherContactDetails = new ContactDetails();
	var ${name}MobileContactDetails = new ContactDetails();
	${name}OtherContactDetails.init(${name}ContactDetailsOtherInputElement , $('#health_application_other'), true, false);
	${name}MobileContactDetails.init(${name}ContactDetailsMobileInputElement , $('#health_application_mobile'), false, true);
	${name}MobileContactDetails.journeyStage = 3;
	${name}OtherContactDetails.journeyStage = 3;
		
	<%--TODO: add messaging framework
		meerkat.messaging.subscribe("CONTACT_DETAILS", ${name}ContactDetailsCallback, window);
	--%>
	$(document).on("CONTACT_DETAILS", function(event, inputs) {
		${name}OtherContactDetails.setPhoneNumber(inputs ,true);
		${name}MobileContactDetails.setPhoneNumber(inputs ,true);
	});

	<%-- Do alternate JS if new Contact Details for is used --%>
	if( $('#health_altContactFormRendered') ) {

		var applicationEmailElement = $('#health_application_email');
		var emailOptinElement = $('#health_application_optInEmail');

		applicationEmailElement.on('blur', function(){
			var optIn = false;
			var email = $(this).val();
			if(isValidEmailAddress(email)) {
				optIn = true;
			}

			$(document).trigger(SaveQuote.setMarketingEvent, [optIn, email]);
		});

		$(document).on(SaveQuote.emailChangeEvent, function(event, optIn, emailAddress) {
			if(!isValidEmailAddress(applicationEmailElement.val()) && isValidEmailAddress(emailAddress) && optIn) {
				applicationEmailElement.val(emailAddress).trigger('blur');
			}
		});
	<%-- Otherwise use the standard JS --%>
	} else {
		var applicationEmailElement = $('#${name}_email');
		var emailOptInElement = $('#${name}_optInEmail');

		emailOptInElement.change(function() {
			var optIn = $(this).is(':checked');
			$(document).trigger(SaveQuote.setMarketingEvent, [optIn, applicationEmailElement.val()]);
		});
		applicationEmailElement.change(function() {
			var optIn = emailOptInElement.is(':checked');
			$(document).trigger(SaveQuote.setMarketingEvent, [optIn, $(this).val()]);
			emailOptInElement.show();
			$("label[for='health_application_optInEmail']").show();
		});

		$(document).on(SaveQuote.emailChangeEvent, function(event, optIn, emailAddress) {
			if(!isValidEmailAddress(applicationEmailElement.val())) {
				applicationEmailElement.val(emailAddress);
			}
			if(applicationEmailElement.val() == emailAddress) {
				if(optIn) {
					emailOptInElement.prop('checked', true);
					emailOptInElement.hide();
					$("label[for='health_application_optInEmail']").hide();
				} else {
					emailOptInElement.prop('checked', null);
					emailOptInElement.show();
					$("label[for='health_application_optInEmail']").show();
				}
			}
		});
	}

</go:script>

<go:validate selector="${name}_address_state" rule="matchStates" parm="true" message="Health product details, prices and availability are based on the state in which you reside. The postcode entered here does not match the original state provided at the start of the search. If you have made a mistake with the postcode on this page please rectify it before continuing. Otherwise please <span class='refineSearch'>click here</span> to carry out the quote again using this state." />