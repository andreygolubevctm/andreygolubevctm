<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Home Loan Enquiry Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="displayBestContact"><c:out value="${data[bestcontact]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<div id="${name}-selection" class="${name}">

	<form_new:fieldset legend="Your Details">

		<form_new:row label="First name" className="hidden">
			<field:person_name xpath="${xpath}/firstName" title="first name" required="true" />
		</form_new:row>

		<form_new:row label="Last name" className="hidden">
			<field:person_name xpath="${xpath}/lastName" title="last name" required="true" />
		</form_new:row>

		<form_new:row label="Best contact" className="clear">
			<field_new:array_select items="=Please choose...,P=Phone,E=Email" xpath="${xpath}/bestContact" title="best contact method" required="true" />
		</form_new:row>

		<c:set var="fieldXPath" value="${xpath}/contactNumber"/>
		<form_new:row label="Your contact number" className="clear">
			<field:flexi_contact_number xpath="${fieldXPath}"
										maxLength="20"
										required="${false}"
										labelName="your contact number"/>
		</form_new:row>

		<div id="${name}_bestcontactToggleArea" class="${name}_bestcontactToggleArea show_${displayBestContact}">
		<form_new:row label="What is the best time for someone to call you?" className="clear">
			<field_new:array_select items="=Please choose...,M=Morning,A=Afternoon,E=Evening,ANY=Anytime" xpath="${xpath}/bestTime" title="when is the best time for someone to call you" required="true" />
		</form_new:row>
		</div>

		<form_new:row label="Your email address" className="clear email-row">
			<field_new:email xpath="${xpath}/email" title="your email address" required="true" size="40"/>
		</form_new:row>
	</form_new:fieldset>

</div>
