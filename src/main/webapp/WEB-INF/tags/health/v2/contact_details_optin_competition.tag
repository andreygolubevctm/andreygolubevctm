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

<c:set var="val_optout"				value="N" />

<%-- HTML --%>
	<form_v2:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<%-- Please check the database for this content --%>
			<c:if test="${competitionEnabled == true}">
				<content:get key="healthCompetitionRightColumnPromo"/>
			</c:if>

			<health_v2_content:sidebar />
		</jsp:attribute>

		<jsp:body>

			<div id="worryFreePromoContainer">
				<div class="row competition-details">
					<div class="col-xs-12 col-md-8">
						<h4><content:get key="worryFreePromoCopy_Title" /></h4>
						<h5 class="custom-copy S"><content:get key="worryFreePromoCopyIntro_S" /></h5>
						<h5 class="custom-copy S"><content:get key="worryFreePromoCopyOutro_S" /></h5>
						<h5 class="custom-copy C"><content:get key="worryFreePromoCopyIntro_C" /></h5>
						<h5 class="custom-copy C"><content:get key="worryFreePromoCopyOutro_C" /></h5>
						<h5 class="custom-copy SPF"><content:get key="worryFreePromoCopyIntro_SPF" /></h5>
						<h5 class="custom-copy SPF"><content:get key="worryFreePromoCopyOutro_SPF" /></h5>
						<h5 class="custom-copy F"><content:get key="worryFreePromoCopyIntro_F" /></h5>
						<h5 class="custom-copy F"><content:get key="worryFreePromoCopyOutro_F" /></h5>
					</div>
					<div id="health-contact-fieldset" class="col-xs-12 col-sm-6 col-md-4">
						<div class="badge"><!-- image --></div>

						<c:set var="firstNamePlaceHolder">
							<content:get key="firstNamePlaceHolder"/>
						</c:set>

						<c:set var="emailPlaceHolder">
							<content:get key="emailPlaceHolder"/>
						</c:set>

						<c:set var="fieldXpath" value="${xpath}/name" />
						<c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}" />
						<div class="fieldrow clear required_input">
							<label for="${fieldXpathName}" class="required_input">Name</label>
							<div class="row-content">
								<field_v1:person_name xpath="${fieldXpath}" title="name" required="true" />
							</div>
						</div>

						<c:set var="fieldXpath" value="${xpath}/flexiContactNumber" />
						<c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}" />
						<div class="fieldrow clear required_input">
							<label for="${fieldXpathName}">Phone number</label>
							<div class="row-content">
								<field_v1:flexi_contact_number xpath="${fieldXpath}" required="true" maxLength="20"/>
							</div>
						</div>

						<c:set var="fieldXpath" value="${xpath}/email" />
						<c:set var="fieldXpathName" value="${go:nameFromXpath(fieldXpath)}" />
						<div class="fieldrow clear required_input">
							<label for="${fieldXpathName}" class="required_input">Email address</label>
							<div class="row-content">
								<field_v2:email xpath="${fieldXpath}" title="your email address" required="true"  />
								<field_v1:hidden xpath="${xpath}/emailsecondary" />
								<field_v1:hidden xpath="${xpath}/emailhistory" />
							</div>
						</div>

						<c:set var="termsAndConditions">
							I agree to the competition <a href='/static/competitions/1608_Terms_Conditions_$20K_Health_Promotion.pdf' target='_blank'>terms and conditions</a>.
						</c:set>
						<div class="health-competition-optin-group">
							<field_v2:checkbox
									xpath="${xpath}/competition/optin"
									value="Y"
									className="validate"
									required="false"
									label="${true}"
									title="${termsAndConditions}"
									errorMsg="Please agree to the competition Terms &amp; Conditions" />
							<field_v1:hidden xpath="${xpath}/competition/previous" />
						</div>

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

						<c:if test="${!pageSettings.getSetting('inInEnabled')}">
							<simples:referral_tracking vertical="health" />
						</c:if>

						<div class="rowAction">
							<a class="btn btn-next btn-block nav-next-btn show-loading journeyNavButton" data-slide-control="next" href="javascript:;">Get Prices <span class="icon icon-arrow-right"></span></a>
						</div>
					</div>
				</div>
				<c:if test="${not empty worryFreePromo36}">
					<div class="row no-thanks">
						<a href="javascript:;">No thanks, just show me my quotes</a>
						<p>(You won't go into the draw to win $10,000)</p>
					</div>
				</c:if>
			</div>

		</jsp:body>

	</form_v2:fieldset_columns>

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
			$('#${contactName}').setRequired(true, 'Please enter name');
			contactEmailElement.setRequired(true, 'Please enter your email address');
			contactMobileElementInput.addRule('requireOneContactNumber', true, 'Please include at least one phone number');
		}
	});
	<%-- COMPETITION END --%>
</go:script>