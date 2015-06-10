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

<%-- Var for mandatory fields --%>
<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />
<c:set var="mandatoryFieldsSplitTest" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}" />

<%-- HTML --%>
<form_new:fieldset legend="Contact Details" id="${name}FieldSet">

	<form_new:row label="First Name" id="firstName">
		<field:person_name xpath="quote/drivers/regular/firstname"
			required="${mandatoryFieldsSplitTest}" title="the policy holder's first name" />
	</form_new:row>

	<form_new:row label="Last Name" id="lastName">
		<field:person_name xpath="quote/drivers/regular/surname"
			required="${mandatoryFieldsSplitTest}" title="the policy holder's last name" />
	</form_new:row>

	<form_new:row label="Email Address" id="contactEmailRow">
		<c:choose>
			<c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 21)}">
				<field_new:email_assisted xpath="${xpath}/email" required="${mandatoryFieldsSplitTest}" title="the policy holder's email address" className="sessioncamexclude" />
			</c:when>
			<c:otherwise>
				<field_new:email xpath="${xpath}/email" required="${mandatoryFieldsSplitTest}" title="the policy holder's email address" />
			</c:otherwise>
		</c:choose>
	</form_new:row>

	<form_new:row label="Contact Number" id="contactNoRow">
		<field:contact_telno xpath="${xpath}/phone" required="false" id="bestNumber"
			className="bestNumber"
			labelName="best number" />
	</form_new:row>



	<c:set var="okToCall">
		I give permission for the insurance provider that represents the lowest price to call me within
		the next 2 business days to discuss my car insurance needs.
	</c:set>

	<form_new:row label="OK to email" className="">
		<field_new:array_radio xpath="quote/contact/marketing"
			required="false"
			items="Y=Yes,N=No"
			title="if OK to email" />

		<p class="optinText"><content:get key="okToEmail" /></p>
	</form_new:row>

	<form_new:row label="OK to call" className="">
		<field_new:array_radio xpath="quote/contact/oktocall"
			required="false"
			items="Y=Yes,N=No"
			title="if OK to call" />

		<p class="optinText">${okToCall}</p>
	</form_new:row>

<go:script marker="js-head">
$.validator.addMethod('validateOkToCall', function(value, element) {
	var optin = ($("#quote_contactFieldSet input[name='quote_contact_oktocall']:checked").val() === 'Y');
	var phone = $('#quote_contact_phone').val();
	if(optin === true && _.isEmpty(phone)) {
		return false;
	}
	return true;
});

$.validator.addMethod('validateOkToEmail', function(value, element) {
	var optin = ($("#quote_contactFieldSet input[name='quote_contact_marketing']:checked").val() === 'Y');
	var email = $('#quote_contact_email').val();
	if(optin === true && _.isEmpty(email)) {
		return false;
	}
	return true;
});

$.validator.addMethod('validateOkToCallRadio', function(value, element) {
	var $optin	= $("#quote_contactFieldSet input[name='quote_contact_oktocall']:checked");
	var noOptin = $optin.length == 0;
	var phone = $('#quote_contact_phone').val();
	if(!_.isEmpty(phone) && noOptin == true) {
		return false;
	}
	return true;
});

$.validator.addMethod('validateOkToEmailRadio', function(value, element) {
	var $optin = $("#quote_contactFieldSet input[name='quote_contact_marketing']:checked");
	var noOptin = $optin.length == 0;
	var email = $('#quote_contact_email').val();
	if(!_.isEmpty(email) && noOptin == true) {
		return false;
	}
	return true;
});
</go:script>

	<go:validate selector="quote_contact_oktocall" rule="validateOkToCallRadio" parm="true"
				message="Please choose if OK to call"/>
	<go:validate selector="quote_contact_marketing" rule="validateOkToEmailRadio" parm="true"
				message="Please choose if OK to email"/>


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