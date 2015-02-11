<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>

<%-- HTML --%>

<c:set var="fieldXpath" value="travel/firstName" />
<form_new:row label="First Name" fieldXpath="${fieldXpath}" className="clear">
	<field:person_name xpath="${fieldXpath}" title="firstname" required="false" className="sessioncamexclude" />
</form_new:row>

<c:set var="fieldXpath" value="travel/surname" />
<form_new:row fieldXpath="${fieldXpath}" label="Last Name" className="clear" >
	<field:person_name xpath="${fieldXpath}" required="false" title="${title} last name" className="contactField sessioncamexclude" />
</form_new:row>

<c:set var="fieldXpath" value="travel/email" />
<form_new:row label="Email Address" fieldXpath="${fieldXpath}" className="clear" id="travel_email_note" legend="For confirming quote and transaction details.">
	<field_new:email xpath="${fieldXpath}" title="your email address" required="true" className="sessioncamexclude" />
	<field:hidden xpath="travel/emailsecondary" />
	<field:hidden xpath="travel/emailhistory" />
</form_new:row>

<c:if test="${data.travel.currentJourney != null && (data.travel.currentJourney == 5 or data.travel.currentJourney == 6)}">
	<c:set var="postcodeRequired">
		<c:if test="${data.travel.currentJourney == 5}">false</c:if>
		<c:if test="${data.travel.currentJourney == 6}">true</c:if>
	</c:set>

	<form_new:row label="Postcode / Suburb" className="postcodeDetails">
		<field_new:lookup_suburb_postcode xpath="travel/location" required="${postcodeRequired}" placeholder="Postcode / Suburb" />
		<field:hidden xpath="travel/suburb" />
		<field:hidden xpath="travel/postcode" />
		<field:hidden xpath="travel/state" />
	</form_new:row>
</c:if>

<form_new:row className="travel-contact-details-optin-sgroup">
	<%-- Mandatory agreement to privacy policy --%>
	<c:set var="brandedName"><content:get key="boldedBrandDisplayName" /></c:set>
	<field_new:checkbox xpath="travel/marketing" value="Y" required="false" label="true" title="I agree to receive news &amp; offer emails from ${brandedName}" />
</form_new:row>

<%-- Mandatory agreement to privacy policy --%>
<form_new:privacy_optin vertical="travel" />