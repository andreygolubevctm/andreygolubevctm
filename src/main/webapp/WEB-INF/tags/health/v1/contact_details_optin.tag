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
<c:if test="${competitionEnabledSetting == 'Y' && competitionSecret == 'vU9CD4NjT3S6p7a83a4t'}"> <%--Split test needs to allow previous competition ($1000 promo) to remain active. TODO: Cleanup--%>
	<c:set var="competitionEnabled" value="${true}" />
</c:if>

<!-- Name is mandatory for both online and callcentre, other fields only mandatory for online -->
<c:set var="required" value="${true}" />
<c:if test="${callCentre}">
	<c:set var="required" value="${false}" />
</c:if>

<%-- HTML --%>
<div id="${name}-selection" class="health-your_details">

	<form_v2:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<%-- Please check the database for this content --%>
			<c:if test="${competitionEnabled == true}">
				<content:get key="healthCompetitionRightColumnPromo"/>
			</c:if>
		</jsp:attribute>

		<jsp:body>

			<form_v2:fieldset legend="Contact Details" >
				<ui:bubble variant="chatty">
					<h4>All About You</h4>
					<p>By filling in your details below, we'll be able to email you your quotes and/or call you back if needed.</p>
				</ui:bubble>

				<c:set var="firstNamePlaceHolder">
					<content:get key="firstNamePlaceHolder"/>
				</c:set>

				<c:set var="emailPlaceHolder">
					<content:get key="emailPlaceHolder"/>
				</c:set>

				<c:set var="fieldXpath" value="${xpath}/name" />
				<form_v2:row label="First Name" fieldXpath="${fieldXpath}" className="clear">
					<field_v1:person_name xpath="${fieldXpath}" title="name" required="true" placeholder="${firstNamePlaceHolder}" />
				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/email" />
				<form_v2:row label="Email Address" fieldXpath="${fieldXpath}" className="clear">
					<field_v2:email xpath="${fieldXpath}" title="your email address" required="${required}" placeHolder="${emailPlaceHolder}" />
					<field_v1:hidden xpath="${xpath}/emailsecondary" />
					<field_v1:hidden xpath="${xpath}/emailhistory" />
				</form_v2:row>

				<group_v2:contact_numbers xpath="${xpath}/contactNumber" required="${required}" />

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

				<c:set var="termsAndConditions">
					<%-- PLEASE NOTE THAT THE MENTION OF COMPARE THE MARKET IN THE TEXT BELOW IS ON PURPOSE --%>
					<c:if test="${callCentre}">
						<c:out value="<p class='text-danger'>IB Only:" escapeXml="False" />
					</c:if>
					I understand <content:optin key="brandDisplayName" useSpan="true"/> compares health insurance policies from a range of
					<a href='<content:get key="participatingSuppliersLink"/>' target='_blank'>participating suppliers</a>.
					By providing my contact details I agree that <content:optin useSpan="true" content="comparethemarket.com.au"/> may contact me, during the Call Centre <a href="javascript:;" data-toggle="dialog" data-content="#view_all_hours" data-dialog-hash-id="view_all_hours" data-title="Call Centre Hours" data-cache="true">opening hours</a>, about the services they provide.
					I confirm that I have read the <form_v1:link_privacy_statement />.
					<c:if test="${callCentre}">
						<c:out value="</p>" escapeXml="False" />
					</c:if>
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

				<%-- COMPETITION START --%>
				<c:if test="${competitionEnabled == true}">
					<c:set var="competitionPreCheckboxContainer"><content:get key="competitionPreCheckboxContainer"/></c:set>
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

			</form_v2:fieldset>

		</jsp:body>

	</form_v2:fieldset_columns>

	<field_v1:hidden xpath="health/altContactFormRendered" constantValue="Y" />


</div>




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