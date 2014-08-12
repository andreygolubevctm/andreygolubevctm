<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>

<%-- HTML --%>

<c:set var="fieldXpath" value="travel/firstName" />
<form_new:row label="First Name" fieldXpath="${fieldXpath}" className="clear">
	<field:person_name xpath="${fieldXpath}" title="firstname" required="true" className="sessioncamexclude" />
</form_new:row>

<c:set var="fieldXpath" value="travel/surname" />
<form_new:row fieldXpath="${fieldXpath}" label="Last Name" className="halfrow right" >
	<field:person_name xpath="${fieldXpath}" required="true" title="${title} last name" className="contactField sessioncamexclude" />
</form_new:row>

<c:set var="fieldXpath" value="travel/email" />
<form_new:row label="Email Address" fieldXpath="${fieldXpath}" className="clear" id="travel_email_note" legend="For confirming quote and transaction details.">
	<field_new:email xpath="${fieldXpath}" title="your email address" required="true" className="sessioncamexclude" />
	<field:hidden xpath="travel/emailsecondary" />
	<field:hidden xpath="travel/emailhistory" />
</form_new:row>

<form_new:row className="travel-contact-details-optin-sgroup" hideHelpIconCol="true">
	<%-- Mandatory agreement to privacy policy --%>
	<field_new:checkbox xpath="travel/marketing" value="Y" required="false" label="true" title="I agree to receive news &amp; offer emails from <strong>Compare</strong>the<strong>market</strong>.com.au" />
</form_new:row>

<%-- Mandatory agreement to privacy policy --%>
<form_new:privacy_optin vertical="travel" />