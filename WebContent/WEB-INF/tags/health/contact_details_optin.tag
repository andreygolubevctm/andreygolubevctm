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

<c:set var="val_optin"				value="Y" />
<c:set var="val_optout"				value="N" />

<%-- Vars for competition --%>
	<jsp:useBean id="now" class="java.util.Date"/>
	<fmt:parseDate var="compStart" pattern="yyyy-MM-dd HH:mm" value="2013-11-07 09:00" type="both" />
	<fmt:parseDate var="compFinish" pattern="yyyy-MM-dd HH:mm" value="2014-05-02 09:00" type="both" />
	<c:set var="healthynwealthyActive" value="${false}" />
	<c:set var="healthynwealthyActive" value="${now >= compStart and now < compFinish}" />

<%-- HTML --%>
<div id="${name}-selection" class="health-your_details">

	<form_new:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<%-- HLT-608: This content is temporarily required for the October Health'N'Wealth promotion --%>
			<c:if test="${healthynwealthyActive == true}">
				<div id="healthynwealthy" class="promotion hidden-xs">
					<img src="brand/ctm/competition/october_promo.png" />
				</div>
			</c:if>
			<%-- END HLT-608 --%>
		</jsp:attribute>

		<jsp:body>
			<simples:dialogue id="25" vertical="health" mandatory="true" />
			<simples:dialogue id="35" vertical="health" className="red">
				<jsp:attribute name="body_start">
					<div class="row">
						<div class="col-sm-8">
				</jsp:attribute>
				<jsp:body>
						</div>
						<div class="col-sm-4">
							<field_new:array_radio xpath="health/simples/privacycheck" items="Y=Yes,N=No" required="true" title="privacy check Yes/No" />
						</div>
					</div>
				</jsp:body>
			</simples:dialogue>
			<simples:dialogue id="36" vertical="health" mandatory="true" className="hidden simples-privacycheck-statement" />

			<c:if test="${callCentre}">
				<%-- Requirements as per AGG-1704 --%>
				<go:script marker="onready">
					<%-- Show additional mandatory dialogue if 'No' was chosen. --%>
					$('.simples-dialogue-35 :input').on('change', function simplesPrivacyCheck() {
						if (this.value === 'Y') {
							$('.simples-privacycheck-statement').addClass('hidden');
						}
						else {
							$('.simples-privacycheck-statement').removeClass('hidden');
						}
					});

					<%-- Outbound/Inbound change --%>
					$('#health_simples_contactType_inbound').parent().parent().find('input').on('change', function() {
						<%-- Privacy optin already ticked e.g. previous quote --%>
						if ($('#health_privacyoptin').attr('type') === 'hidden') return;

						<%-- Inbound --%>
						if ('inbound' === $('#health_simples_contactType_inbound').parent().parent().find('input:checked').val()) {
							$('.simples-dialogue-35 #health_simples_privacycheck_N').prop('checked', true).change();
							$('#health_privacyoptin').prop('checked', false).change();
						}
						<%-- Outbound --%>
						else {
							$('.simples-dialogue-35 #health_simples_privacycheck_N').prop('checked', true).change();
							//$('#health_privacyoptin').prop('checked', true).change();
						}
					});

					<%-- Handle pre-filled --%>
					<%-- User has already accepted the privacy statement --%>
					if ($('#health_privacyoptin').attr('type') === 'hidden') {
						$('.simples-dialogue-35 #health_simples_privacycheck_Y').prop('checked', true).change();
					}
					<%-- Operator has previously selected No for privacy check --%>
					else if ($('.simples-dialogue-35 :input:checked').val() === 'N') {
						$('.simples-privacycheck-statement').removeClass('hidden');
					}
				</go:script>
			</c:if>

			<form_new:fieldset legend="Contact Details" >
				<ui:bubble variant="chatty">
					<h4>All About You</h4>
					<p>By filling in your details below, we'll be able to email you your quotes and/or call you back if needed.</p>
				</ui:bubble>

				<c:set var="fieldXpath" value="${xpath}/name" />
				<form_new:row label="First Name" fieldXpath="${fieldXpath}" className="clear">
					<field:person_name xpath="${fieldXpath}" title="name" required="${callCentre}" placeholder="Sergei" />
				</form_new:row>

				<c:set var="fieldXpath" value="${xpath}/email" />
				<form_new:row label="Email Address" fieldXpath="${fieldXpath}" className="clear">
					<field_new:email xpath="${fieldXpath}" title="your email address" required="false" placeHolder="sergei@comparethemarket.com.au" />
					<field:hidden xpath="${xpath}/emailsecondary" />
					<field:hidden xpath="${xpath}/emailhistory" />
				</form_new:row>

				<group_new:contact_numbers xpath="${xpath}/contactNumber" required="false" helptext="${contactNumberText}" />

				<%-- Optin fields (hidden) for email and phone --%>
				<field:hidden xpath="${xpath}/optInEmail" defaultValue="${val_optout}" />
				<field:hidden xpath="${xpath}/call" defaultValue="${val_optout}" />

				<c:set var="termsAndConditions">
					I understand comparethemarket.com.au compares health insurance policies from a range of
					<a href='http://www.comparethemarket.com.au/health-insurance/#tab_nav_1432_0' target='_blank'>participating suppliers</a>.
					By providing my contact details I agree that comparethemarket.com.au may
					contact me about the services they provide.
				</c:set>

				<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
				<form_new:row className="health-contact-details-optin-group" hideHelpIconCol="true">
					<field_new:checkbox
						xpath="${xpath}/optin"
						value="Y"
						className="validate"
						required="false"
						label="${true}"
						title="${termsAndConditions}"
						errorMsg="Please agree to the Terms &amp; Conditions" />
				</form_new:row>

				<%-- COMPETITION START --%>
				<c:if test="${healthynwealthyActive == true}">
					<form_new:row className="health-competition-optin-group" hideHelpIconCol="true">
						<c:set var="competitionLabel">
							For your chance to win $1000 as part of our Healthy 'n' Wealthy competition, tick here.
							Your entry will be registered when you have entered your details and have viewed our Compare page.
							<a href='http://www.comparethemarket.com.au/competition/termsandconditions.pdf' target='_blank'>Terms &amp; conditions</a>.
						</c:set>
						<field_new:checkbox xpath="${xpath}/competition/optin" value="Y" required="false" label="${true}" title="${competitionLabel}" errorMsg="Please tick" />
						<field:hidden xpath="${xpath}/competition/previous" />
					</form_new:row>
				</c:if>
				<%-- COMPETITION END --%>

				<%-- form:privacy_optin --%>
				<c:choose>
					<%-- Only render a hidden field when the checkbox has already been selected --%>
					<c:when test="${data['health/privacyoptin'] eq 'Y'}">
						<field:hidden xpath="health/privacyoptin" defaultValue="Y" constantValue="Y" />
					</c:when>
					<c:otherwise>
						<form_new:row hideHelpIconCol="true">
							<c:set var="label">
								I have read the <a data-toggle="dialog" data-content="legal/privacy_statement.jsp" data-cache="true" data-dialog-hash-id="privacystatement" href="legal/privacy_statement.jsp" target="_blank">privacy statement</a>.
							</c:set>
							<field_new:checkbox
								xpath="health/privacyoptin"
								value="Y"
								className="validate"
								required="true"
								label="${true}"
								title="${label}"
								errorMsg="Please confirm you have read the privacy statement" />
						</form_new:row>
					</c:otherwise>
				</c:choose>

			</form_new:fieldset>

			<simples:referral_tracking vertical="health" />

		</jsp:body>

	</form_new:fieldset_columns>

	<field:hidden xpath="health/altContactFormRendered" constantValue="Y" />


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
			$('#${contactName}').rules('add', {required:true, messages:{required:'Please enter your name to be eligible for the competition'}});
			contactEmailElement.rules('add', {required:true, messages:{required:'Please enter your email address to be eligible for the competition'}});

				contactMobileElementInput.rules('add', {
					requiredOneContactNumber:true,
					messages:{
						requiredOneContactNumber:'Please enter your phone number to be eligible for the competition'
					}
				});
		}
		else {
			<c:if test="${empty callCentre}">$('#${contactName}').rules('remove', 'required');</c:if>
			<c:if test="${not empty callCentre}">$('#${contactName}').rules('add', {required:true, messages:{required:'Please enter name'}});</c:if>
			contactEmailElement.rules('remove', 'required');
					contactMobileElementInput.rules('remove', 'requiredOneContactNumber');

			$('#${contactName}').valid();
			contactEmailElement.valid();
			contactMobileElementInput.valid();
			contactOtherElementInput.valid();
		}
	});
	<%-- COMPETITION END --%>
</go:script>



<%-- VALIDATION --%>
<go:validate selector="${name}_optin" rule="required" parm="true" message="Please agree to the Terms &amp; Conditions" />