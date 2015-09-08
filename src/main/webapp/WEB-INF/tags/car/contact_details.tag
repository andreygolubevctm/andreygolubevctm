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
<form_new:fieldset legend="Contact Details" id="${name}FieldSet">

	<form_new:row label="First Name" id="firstName">
		<field:person_name xpath="quote/drivers/regular/firstname"
			required="${mandatoryContactFieldsSplitTest}" title="the policy holder's first name" />
	</form_new:row>

	<form_new:row label="Last Name" id="lastName">
		<field:person_name xpath="quote/drivers/regular/surname"
			required="${mandatoryContactFieldsSplitTest}" title="the policy holder's last name" />
	</form_new:row>

	<form_new:row label="Email Address" id="contactEmailRow">
		<c:choose>
			<c:when test="${emailHelperSplitTest eq true}">
				<field_new:email_assisted xpath="${xpath}/email" required="${mandatoryContactFieldsSplitTest}" title="the policy holder's email address" className="sessioncamexclude" additionalAttributes=" data-rule-validateOkToEmail='true' " />
			</c:when>
			<c:otherwise>
				<field_new:email xpath="${xpath}/email" required="${mandatoryContactFieldsSplitTest}" title="the policy holder's email address" additionalAttributes=" data-rule-validateOkToEmail='true' " />
			</c:otherwise>
		</c:choose>
	</form_new:row>

	<form_new:row label="Contact Number" id="contactNoRow">
		<field:contact_telno xpath="${xpath}/phone" required="false" id="bestNumber"
			className="bestNumber"
			labelName="best number" validationAttribute=" data-rule-validateOkToCall='true' " />
	</form_new:row>



	<c:set var="okToCall">
		I give permission for the insurance provider that represents the lowest price to call me within
		the next 2 business days to discuss my car insurance needs.
	</c:set>

	<form_new:row label="OK to email" className="">
		<field_new:array_radio xpath="quote/contact/marketing"
			required="false"
			items="Y=Yes,N=No"
			title="if OK to email" additionalAttributes=" data-rule-validateOkToEmailRadio='true' " />
		<content:optin key="okToEmail" />
	</form_new:row>

	<form_new:row label="OK to call" className="">
		<field_new:array_radio xpath="quote/contact/oktocall"
			required="false"
			items="Y=Yes,N=No"
			title="if OK to call" additionalAttributes=" data-rule-validateOkToCallRadio='true' " />

		<p class="optinText">${okToCall}</p>
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