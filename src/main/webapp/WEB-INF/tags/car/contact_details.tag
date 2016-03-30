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
<form_v2:fieldset legend="Contact Details" id="${name}FieldSet">

	<form_v2:row label="First Name" id="firstName">
		<field_v1:person_name xpath="quote/drivers/regular/firstname"
			required="false" title="the policy holder's first name" />
	</form_v2:row>

	<form_v2:row label="Last Name" id="lastName">
		<field_v1:person_name xpath="quote/drivers/regular/surname"
			required="false" title="the policy holder's last name" />
	</form_v2:row>

	<form_v2:row label="Email Address" id="contactEmailRow">
		<field_v2:email xpath="${xpath}/email" required="false" title="the policy holder's email address" additionalAttributes=" data-rule-validateOkToEmail='true' " />
	</form_v2:row>

	<c:set var="fieldXPath" value="${xpath}/phone" />
	<form_v2:row label="Contact Number" id="contactNoRow">
		<field_v1:flexi_contact_number xpath="${fieldXPath}"
			maxLength="20"
			id="bestNumber"
			required="false"
			className="bestNumber"
			labelName="best number"
			validationAttribute=" data-rule-validateOkToCall='true' "/>
	</form_v2:row>

	<field_v1:hidden xpath="quote/contact/marketing" defaultValue="N" />
	<field_v1:hidden xpath="quote/contact/oktocall" defaultValue="N" />

	<%-- COMPETITION START --%>
	<c:if test="${competitionEnabled == true}">
		<form_v2:row className="car-competition-optin-group" hideHelpIconCol="true">
			<content:get key="competitionPreCheckboxContainer"/>
		</form_v2:row>
		<form_v2:row className="car-competition-optin-group" hideHelpIconCol="true">
			<c:set var="competitionLabel">
				<content:get key="competitionCheckboxText"/>
			</c:set>
			<field_v2:checkbox xpath="${xpath}/competition/optin" value="Y" required="false" label="${true}" title="${competitionLabel}" errorMsg="Please tick" />
			<field_v1:hidden xpath="${xpath}/competition/previous" />
		</form_v2:row>
	</c:if>
	<%-- COMPETITION END --%>

</form_v2:fieldset>
