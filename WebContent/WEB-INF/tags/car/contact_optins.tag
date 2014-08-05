<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_new:fieldset legend="Terms and Conditions" id="${name}FieldSet">

<c:set var="okToCall">
	I give permission for the insurance provider that represents the lowest price to call me within
	the next 2 business days to discuss my car insurance needs.
</c:set>

	<form_new:row label="OK to email" className="">
		<field_new:array_radio xpath="quote/contact/marketing"
			required="true"
			items="Y=Yes,N=No"
			title="if OK to email" />

		<p class="small" style="margin-top:0.5em">By providing your contact details you agree that comparethemarket.com.au may contact you about the services that they provide.</p>
	</form_new:row>

	<form_new:row label="OK to call" className="">
		<field_new:array_radio xpath="quote/contact/oktocall"
			required="true"
			items="Y=Yes,N=No"
			title="if OK to call" />

		<p class="small" style="margin-top:0.5em">${okToCall}</p>
	</form_new:row>


<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
<%--
<form_new:row className="" hideHelpIconCol="true">
	<field_new:checkbox
			xpath="quote/contact/oktocall"
		value="Y"
		className="validate"
		required="false"
		label="${true}"
		title="${okToCall}"
	/>
</form_new:row>
	--%>

	<c:set var="genericOptin">
		<p>Please confirm you have read, understood and accept the
			<a href="${pageSettings.getSetting('websiteTermsUrl')}" target="_blank" data-title="Website Terms of Use" class="termsLink showDoc">Website Terms of Use</a>,
			the <a href="${pageSettings.getSetting('fsgUrl')}" target="_blank" data-title="Financial Services Guide" class="termsLink showDoc">Financial Services Guide</a>
			and the <a data-toggle="dialog" data-content="legal/privacy_statement.jsp" data-cache="true" data-dialog-hash-id="privacystatement" href="legal/privacy_statement.jsp" target="_blank">Privacy Statement</a>.

			You confirm that you are accessing this service to obtain an insurance quote as (or on the behalf of) a genuine customer, and not for commercial or competitive purposes (as further detailed in the <a href="${pageSettings.getSetting('websiteTermsUrl')}" target="_blank" data-title="Website Terms of Use" class="termsLink showDoc">Website Terms of Use</a>).
	</p>
</c:set>

<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
	<form_new:row className="" hideHelpIconCol="true">
	<field_new:checkbox
			xpath="quote/privacyoptin"
		value="Y"
		className="validate"
		required="true"
		label="${true}"
			title="${genericOptin}"
		errorMsg="Please agree to the Terms &amp; Conditions" />

		<field:hidden xpath="quote/terms" defaultValue="N" />
		<field:hidden xpath="quote/fsg" defaultValue="N" />
</form_new:row>

</form_new:fieldset>

<go:script marker="js-head">
$.validator.addMethod('validateOkToCall', function(value, element) {
	var optin = ($("#quote_termsAndConditionsFieldSet input[name='quote_contact_oktocall']:checked").val() === 'Y');
	var phone = $('#quote_contact_phone').val();
	if(optin === true && _.isEmpty(phone)) {
		return false;
	}
	return true;
});

$.validator.addMethod('validateOkToEmail', function(value, element) {
	var optin = ($("#quote_termsAndConditionsFieldSet input[name='quote_contact_marketing']:checked").val() === 'Y');
	var email = $('#quote_contact_email').val();
	if(optin === true && _.isEmpty(email)) {
		return false;
	}
	return true;
});
</go:script>

<go:validate selector="quote_contact_phoneinput" rule="validateOkToCall" parm="true" message="Please enter a contact number" />
<go:validate selector="quote_contact_email" rule="validateOkToEmail" parm="true" message="Please enter your email address" />