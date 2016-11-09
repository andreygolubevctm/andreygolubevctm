<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="contactName"	value="${go:nameFromXpath(xpath)}_name" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />
<c:set var="optIn"			value="${go:nameFromXpath(xpath)}_call" />

<c:set var="val_optin"				value="Y" />
<c:set var="val_optout"				value="N" />

<%-- Vars for competition --%>
<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
<c:set var="competitionSecret"><content:get key="competitionSecret"/></c:set>
<c:set var="competitionEnabled" value="${false}" />
<c:if test="${competitionEnabledSetting == 'Y' && competitionSecret == 'kSdRdpu5bdM5UkKQ8gsK'}">
	<c:set var="competitionEnabled" value="${true}" />
</c:if>

<%-- Name is mandatory for both online and callcentre, other fields only mandatory for online --%>
<c:set var="required" value="${true}" />
<c:if test="${callCentre}">
	<c:set var="required" value="${false}" />
</c:if>

<c:set var="postLegendText">
	To help you reduce your taxes this financial year, enter your details below and we'll show you the limited hospital cover products on the next page
</c:set>

<%-- HTML --%>

		<form_v3:fieldset legend="Contact details" postLegend="${postLegendText}" id="aboutYouContactDetails" >

			<c:set var="firstNamePlaceHolder">
				<content:get key="firstNamePlaceHolder"/>
			</c:set>

			<c:set var="emailPlaceHolder">
				<content:get key="emailPlaceHolder"/>
			</c:set>

			<c:set var="fieldXpath" value="${xpath}/name" />
			<form_v3:row label="Your first name" fieldXpath="${fieldXpath}" className="clear required_input">
				<field_v1:person_name xpath="${fieldXpath}" title="name" required="true" maxlength="24"  />
			</form_v3:row>

			<c:set var="fieldXpath" value="${xpath}/flexiContactNumber" />
			<form_v3:row label="Your phone number" fieldXpath="${fieldXpath}" className="clear required_input">
				<field_v1:flexi_contact_number xpath="${fieldXpath}" required="${required}" maxLength="20"  additionalAttributes=" data-attach=false"/>
			</form_v3:row>

			<c:set var="fieldXpath" value="${xpath}/email" />
			<form_v3:row label="Your email address" fieldXpath="${fieldXpath}" className="clear required_input">
				<field_v2:email xpath="${fieldXpath}" title="your email address" required="${required}" additionalAttributes=" data-attach=false"  />
				<field_v1:hidden xpath="${xpath}/emailsecondary" />
				<field_v1:hidden xpath="${xpath}/emailhistory" />
			</form_v3:row>

			<group_v3:contact_numbers_hidden xpath="${xpath}/contactNumber" />

			<%-- Optin fields (hidden) for email and phone --%>
			<field_v1:hidden xpath="${xpath}/optInEmail" defaultValue="${val_optout}" />
			<field_v1:hidden xpath="${xpath}/call" defaultValue="${val_optout}" />

			<%-- form privacy_optin --%>
			<c:choose>
				<%-- Only render a hidden field when the checkbox has already been selected --%>
				<c:when test="${data['health/privacyoptin'] eq 'Y'}">
					<field_v1:hidden xpath="health/privacyoptin" defaultValue="Y" constantValue="Y" />
				</c:when>
				<c:otherwise>
					<field_v1:hidden xpath="health/privacyoptin" className="validate" />
				</c:otherwise>
			</c:choose>

			<%-- Override set in splittest_helper tag --%>
			<c:if test="${showOptInOnSlide3 eq true}">
				<c:set var="termsAndConditions">
					<%-- PLEASE NOTE THAT THE MENTION OF COMPARE THE MARKET IN THE TEXT BELOW IS ON PURPOSE --%>
					I understand <content:optin key="brandDisplayName" useSpan="true"/> compares health insurance policies from a range of
					<a href='<content:get key="participatingSuppliersLink"/>' target='_blank'>participating suppliers</a>.
					By providing my contact details I agree that <content:optin useSpan="true" content="comparethemarket.com.au"/> may contact me, during the Call Centre <a href="javascript:;" data-toggle="dialog" data-content="#view_all_hours" data-dialog-hash-id="view_all_hours" data-title="Call Centre Hours" data-cache="true">opening hours</a>, about the services they provide.
					I confirm that I have read the <form_v1:link_privacy_statement />.
				</c:set>

				<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
				<form_v2:row className="health-contact-details-optin-group" hideHelpIconCol="true">
					<field_v2:checkbox
							xpath="${xpath}/optin"
							value="Y"
							className="validate"
							required="true"
							label="${true}"
							title="${termsAndConditions}"
							errorMsg="Please agree to the Terms &amp; Conditions" />
				</form_v2:row>
			</c:if>

			<%-- COMPETITION START --%>
			<c:if test="${competitionEnabled == true}">
				<c:set var="competitionPreCheckboxContainer"><content:get key="competitionPreCheckboxContainer"/></c:set>

				<c:out value="${competitionPreCheckboxContainer}" escapeXml="false" />
				<c:if test="${!fn:contains(competitionPreCheckboxContainer, 'health1000promoImage')}">
					<c:set var="offset_class" value=" no-offset"/>
				</c:if>
				<c:if test="${not empty competitionPreCheckboxContainer}">
					<form_v2:row className="competition-optin-group ${offset_class}" hideHelpIconCol="true">
						<c:out value="${competitionPreCheckboxContainer}" escapeXml="false" />
					</form_v2:row>
				</c:if>
				<form_v2:row className="competition-optin-group" hideHelpIconCol="true">
					<c:set var="competitionLabel">
						<content:get key="competitionCheckboxText"/>
					</c:set>
					<field_v2:checkbox xpath="${xpath}/competition/optin" value="Y" required="false" label="${true}" title="${competitionLabel}" errorMsg="Please tick" />
					<field_v1:hidden xpath="${xpath}/competition/previous" />
				</form_v2:row>
			</c:if>
			<%-- COMPETITION END --%>

			<c:if test="${!pageSettings.getSetting('inInEnabled')}">
				<simples:referral_tracking vertical="health" />
			</c:if>

		</form_v3:fieldset>

<field_v1:hidden xpath="health/altContactFormRendered" constantValue="Y" />







<%-- JAVASCRIPT --%>
<go:script marker="onready">

	var contactEmailElement = $('#health_contactDetails_email');
	var contactMobileElementInput = $('#${contactNumber}_mobileinput');
	var contactOtherElementInput = $('#${contactNumber}_otherinput');

	phoneNumberInteractFunction = function(){

	var tel = $(this).val();

	<%-- IE sees the placeholder as its value so let's clear that if necessary--%>
	if( tel.indexOf('(00') === 0 ) {
	tel = '';
	}

	<%-- Optin for callback only if phone entered AND universal optin checked --%>
	if( $('#${name}_optin').is(':checked') ) {
	$('#${optIn}').prop('checked', (tel.length ? true : false));
	} else {
	$('#${optIn}').prop('checked', false);
	}


	}

	contactMobileElementInput.on('keyup keypress blur change', phoneNumberInteractFunction);
	contactOtherElementInput.on('keyup keypress blur change', phoneNumberInteractFunction);

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

	<%-- COMPETITION START --%>
	$('#health_contactDetails_competition_optin').on('change', function() {
	if ($(this).is(':checked')) {
	$('#${contactName}').setRequired(true, 'Please enter your name to be eligible for the competition');
	contactEmailElement.setRequired(true, 'Please enter your email address to be eligible for the competition');
	contactMobileElementInput.addRule('requireOneContactNumber', true, 'Please enter your phone number to be eligible for the competition');
	}
	else {
	<c:if test="${empty callCentre and required == false}">$('#${contactName}').setRequired(false);</c:if>
	<%-- This rule applies to both call center and non call center users --%>
	<c:if test="${not empty callCentre or required}">
		$('#${contactName}').setRequired(true, 'Please enter name');
	</c:if>
	<%-- These rules are separate to the callCenter one above as they only apply to non simples uers --%>
	<c:if test="${required}">
		contactEmailElement.setRequired(true, 'Please enter your email address');
		contactMobileElementInput.addRule('requireOneContactNumber', true, 'Please include at least one phone number');
	</c:if>
	<c:if test="${required == false}">
		contactEmailElement.setRequired(false);
		contactMobileElementInput.removeRule('requireOneContactNumber');
		$('#${contactName}').valid();
		contactEmailElement.valid();
		contactMobileElementInput.valid();
		contactOtherElementInput.valid();
	</c:if>
	}
	});
	<%-- COMPETITION END --%>
</go:script>