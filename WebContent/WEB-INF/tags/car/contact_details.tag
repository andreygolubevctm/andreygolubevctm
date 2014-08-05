<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Vars for competition --%>
<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
<c:set var="competitionEnabled" value="${false}" />
<c:if test="${competitionEnabledSetting == 'Y'}">
	<c:set var="competitionEnabled" value="${true}" />
</c:if>

<%-- HTML --%>
<form_new:fieldset legend="Your Contact Details" id="${name}FieldSet">

	<form_new:row label="First Name" id="firstName">
		<field:person_name xpath="quote/drivers/regular/firstname"
			required="false" title="the policy holder's first name" />
	</form_new:row>

	<form_new:row label="Last Name" id="lastName">
		<field:person_name xpath="quote/drivers/regular/surname"
			required="false" title="the policy holder's last name" />
	</form_new:row>

	<form_new:row label="Contact Number" id="contactNoRow">
		<field:contact_telno xpath="${xpath}/phone" required="false" id="bestNumber"
			className="bestNumber"
			labelName="best number" />
	</form_new:row>

	<form_new:row label="Email Address" id="contactEmailRow">
		<field_new:email xpath="${xpath}/email" required="false" title="the policy holder's email address" />
	</form_new:row>

	<%-- COMPETITION START --%>
	<c:if test="${competitionEnabled == true}">
		<form_new:row className="car-competition-optin-group" hideHelpIconCol="true">
			<content:get key="competitionPreCheckboxContainer"/>
		</form_new:row>
		<form_new:row className="car-competition-optin-group" hideHelpIconCol="true">
			<c:set var="competitionLabel">
				<content:get key="competitionCheckboxText"/>
			</c:set>
			<field_new:checkbox xpath="${xpath}/competition/optin" value="Y" required="false" label="${true}" title="${competitionLabel}" errorMsg="Please tick" />
			<field:hidden xpath="${xpath}/competition/previous" />
		</form_new:row>
	</c:if>
	<%-- COMPETITION END --%>

</form_new:fieldset>