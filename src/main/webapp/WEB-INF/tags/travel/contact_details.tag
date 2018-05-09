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

 <c:set var="websiteTermConfigToUse">
	 <content:get key="websiteTermsUrlConfig"/>
 </c:set>

<c:choose>
	<c:when test="${africaComp}">
		<c:set var="optInText"><content:get key="africaCompOptInText" /></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="optInText"><content:get key="optInText" /></c:set>
	</c:otherwise>
</c:choose>

<c:set var="websiteTermConfigPlaceHolder">${pageSettings.getSetting(websiteTermConfigToUse)}</c:set>
<c:set var="fsgPlaceHolder">${pageSettings.getSetting('fsgUrl')}</c:set>
<c:set var="privacyStmtPlaceHolder"><form_v1:link_privacy_statement /></c:set>
<c:set var="brandedName"><content:optin key="brandDisplayName" useSpan="true"/></c:set>

<c:set var="optInText" value="${fn:replace(optInText, '%FinancialServicesGuidePlaceHolder%', fsgPlaceHolder)}" />
<c:set var="optInText" value="${fn:replace(optInText, '%privacyStmtPlaceHolder%', privacyStmtPlaceHolder)}" />
<c:set var="optInText" value="${fn:replace(optInText, '%websiteTermConfigPlaceHolder%', websiteTermConfigPlaceHolder)}" />
<c:set var="optInText" value="${fn:replace(optInText, '%brandedName%', brandedName)}" />


 <form_v2:row className="travel-contact-details-optin-sgroup">
	<field_v2:checkbox
			xpath="travel/marketing"
			value="Y"
			required="true"
			label="true"
			title="${optInText}"
			errorMsg="Please agree to the Terms &amp; Conditions" />
	<field_v1:hidden
		xpath="travel/privacyoptin"
		required="true" />
</form_v2:row>