<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Home Loan Enquiry Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="${name}">

	<form_v2:fieldset legend="Your Details">

		<form_v2:row label="First name" className="hidden">
			<field_v1:person_name xpath="${xpath}/firstName" title="first name" required="true" />
		</form_v2:row>

		<form_v2:row label="Last name" className="hidden">
			<field_v1:person_name xpath="${xpath}/lastName" title="last name" required="true" />
		</form_v2:row>

		<c:set var="fieldXPath" value="${xpath}/contactNumber"/>
		<form_v2:row label="Your contact number" className="clear">
			<field_v1:flexi_contact_number xpath="${fieldXPath}"
										maxLength="20"
										required="${false}"
										labelName="your contact number"/>
		</form_v2:row>

		<div id="${name}_bestcontactToggleArea">
		<form_v2:row label="What is the best time for someone to call you?" className="clear">
			<field_v2:array_select items="=Please choose...,M=Morning,A=Afternoon,E=Evening,ANY=Anytime" xpath="${xpath}/bestTime" title="when is the best time for someone to call you" required="true" />
		</form_v2:row>
		</div>

		<form_v2:row label="Your email address" className="clear email-row">
			<field_v2:email xpath="${xpath}/email" title="your email address" required="true" size="40"/>
		</form_v2:row>
	</form_v2:fieldset>

</div>
