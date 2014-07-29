<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_new:fieldset legend="Your Contact Details" id="${name}FieldSet">

	<form_new:row label="First name" id="firstName">
		<field:person_name xpath="quote/drivers/regular/firstname"
			required="false" title="the policy holder's first name" />
	</form_new:row>

	<form_new:row label="Last name" id="firstName">
		<field:person_name xpath="quote/drivers/regular/surname"
			required="false" title="the policy holder's last name" />
	</form_new:row>

	<form_new:row label="Contact number" id="contactNoRow">
		<field:contact_telno xpath="${xpath}/phone" required="false" id="bestNumber"
			className="bestNumber"
			labelName="best number"
			title="The best number for the insurance provider to contact you on (You will only be contacted by phone if you answer 'Yes' to the 'OK to call' question on this screen)" />
	</form_new:row>

	<form_new:row label="Email Address">
		<field_new:email xpath="${xpath}/email" required="false" title="the policy holder's email address" />
	</form_new:row>

</form_new:fieldset>