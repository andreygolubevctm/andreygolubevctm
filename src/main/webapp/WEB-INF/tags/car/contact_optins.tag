<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_new:fieldset legend="Terms and Conditions" id="${name}FieldSet">

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
			and the <form:link_privacy_statement overrideLabel="Privacy Statement" />.

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
		errorMsg="Please agree to the Terms &amp; Conditions" customAttribute=" data-rule-validateOkToCall='true' data-rule-validateOkToEmail='true' " />

		<field:hidden xpath="quote/terms" defaultValue="N" />
		<field:hidden xpath="quote/fsg" defaultValue="N" />
</form_new:row>

</form_new:fieldset>

<%--<go:validate selector="quote_contact_phoneinput" rule="validateOkToCall" parm="true" message="Please enter a contact number" />--%>
<%--
<go:validate selector="quote_contact_email" rule="validateOkToEmail" parm="true" message="Please enter your email address" />--%>
