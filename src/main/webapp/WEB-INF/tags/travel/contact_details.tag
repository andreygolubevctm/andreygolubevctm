 <%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>

<%-- HTML --%>

<c:set var="fieldXpath" value="travel/firstName" />
<c:set var="required" value="false" />
<c:if test="${data.travel.currentJourney != null && data.travel.currentJourney == 7}">
	<c:set var="required" value="true" />
</c:if>
<form_v2:row label="First Name" fieldXpath="${fieldXpath}" className="clear">
	<field_v1:person_name xpath="${fieldXpath}" title="first name" required="${required}" />
</form_v2:row>

<c:set var="fieldXpath" value="travel/surname" />
<form_v2:row fieldXpath="${fieldXpath}" label="Last Name" className="clear" >
	<field_v1:person_name xpath="${fieldXpath}" required="${required}" title="${title} last name" className="contactField" />
</form_v2:row>

<c:set var="fieldXpath" value="travel/email" />
<form_v2:row label="Email Address" fieldXpath="${fieldXpath}" className="clear" id="travel_email_note" legend="For confirming your email quote.">
	<field_v2:email xpath="${fieldXpath}" title="your email address" required="true" />
	<field_v1:hidden xpath="travel/emailsecondary" />
	<field_v1:hidden xpath="travel/emailhistory" />
</form_v2:row>

<c:if test="${data.travel.currentJourney != null && (data.travel.currentJourney == 5 or data.travel.currentJourney == 6)}">
	<c:set var="postcodeRequired">
		<c:if test="${data.travel.currentJourney == 5}">false</c:if>
		<c:if test="${data.travel.currentJourney == 6}">true</c:if>
	</c:set>

	<form_v2:row label="Postcode / Suburb" className="postcodeDetails">
		<field_v2:lookup_suburb_postcode xpath="travel/location" required="${postcodeRequired}" placeholder="Postcode / Suburb" />
		<field_v1:hidden xpath="travel/suburb" />
		<field_v1:hidden xpath="travel/postcode" />
		<field_v1:hidden xpath="travel/state" />
	</form_v2:row>
</c:if>

<ad_containers:custom customId="contact-details" />

 <form_v2:row className="travel-contact-details-optin-sgroup">
	<%-- Mandatory agreement to privacy policy --%>
	<c:set var="brandedName"><content:optin key="brandDisplayName" useSpan="true"/></c:set>
	<c:set var="optinCopy">
		I understand and accept the <a href="${pageSettings.getSetting('websiteTermsUrl')}" target="_blank" data-title="Website Terms of Use" class="termsLink showDoc">Website Terms of Use</a>, <a href="${pageSettings.getSetting('fsgUrl')}" target="_blank">Financial Services Guide</a> and <form_v1:link_privacy_statement />. I agree that ${brandedName} may contact me about the services it provides.
	</c:set>
	<field_v2:checkbox
			xpath="travel/marketing"
			value="Y"
			required="true"
			label="true"
			title="${optinCopy}"
			errorMsg="Please agree to the Terms &amp; Conditions" />
	<field_v1:hidden
		xpath="travel/privacyoptin"
		required="true" />
</form_v2:row>