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
		<c:set var="analAttribute"><field_v1:analytics_attr analVal="First Name" quoteChar="\"" /></c:set>
		<field_v1:person_name xpath="quote/drivers/regular/firstname"
			required="false" title="the policy holder's first name"
			additionalAttributes="${analAttribute}" />
	</form_v2:row>

	<form_v2:row label="Last Name" id="lastName">
		<c:set var="analAttribute"><field_v1:analytics_attr analVal="Last Name" quoteChar="\"" /></c:set>
		<field_v1:person_name xpath="quote/drivers/regular/surname"
			required="false" title="the policy holder's last name"
			additionalAttributes="${analAttribute}" />
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
	<field_v1:hidden xpath="quote/quoteReferenceNumber" defaultValue="${meerkat.site.IBOXquoteNumber}"/>

	<form_v2:row label="Preferred method of contact" id="preferredContactMethodRow" className="hidden">
		<field_v2:array_radio xpath="${xpath}/preferred" required="true" items="Email=Email,Phone=Phone"
							  title="the preferred method of contact" />
	</form_v2:row>

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

	<ad_containers:custom customId="contact-details" />

</form_v2:fieldset>
