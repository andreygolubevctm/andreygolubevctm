<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_v2:fieldset legend="Terms and Conditions" id="${name}FieldSet">

	<c:set var="genericOptin"><p>
		<c:choose>
			<c:when test="${singleOptinSplitTest eq true}">
				I understand and accept the
				<a href="${pageSettings.getSetting('websiteTermsUrl')}" target="_blank" data-title="Website Terms of Use" class="termsLink showDoc">Website Terms of Use</a>,
				<a href="${pageSettings.getSetting('fsgUrl')}" target="_blank" data-title="Financial Services Guide" class="termsLink showDoc">Financial Services Guide</a> and
				<form_v1:link_privacy_statement overrideLabel="Privacy Policy" />. I agree that comparethemarket.com.au may contact me about the services it provides, and that the insurance provider that represents the lowest price may call or email me to discuss my home and contents insurance needs.
			</c:when>
			<c:otherwise>
				Please confirm you have read, understood and accept the
				<a href="${pageSettings.getSetting('websiteTermsUrl')}" target="_blank" data-title="Website Terms of Use" class="termsLink showDoc">Website Terms of Use</a>,
				the <a href="${pageSettings.getSetting('fsgUrl')}" target="_blank" data-title="Financial Services Guide" class="termsLink showDoc">Financial Services Guide</a>.

				You confirm that you are accessing this service to obtain an insurance quote as (or on the behalf of) a genuine customer, and not for commercial or competitive purposes (as further detailed in the <a href="${pageSettings.getSetting('websiteTermsUrl')}" target="_blank" data-title="Website Terms of Use" class="termsLink showDoc">Website Terms of Use</a>).
			</c:otherwise>
		</c:choose>
	</p></c:set>

	<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
	<%-- Previous Insurance --%>
	<c:set var="fieldXpath" value="${xpath}/termsAccepted" />
	<form_v2:row className="" hideHelpIconCol="true">
		<field_v2:checkbox
			xpath="${fieldXpath}"
			value="Y"
			className="validate"
			required="true"
			label="${true}"
			title="${genericOptin}"
			errorMsg="Please agree to the Terms &amp; Conditions" />

		<field_v1:hidden xpath="${xpath}/terms" defaultValue="N" />
		<field_v1:hidden xpath="${xpath}/fsg" defaultValue="N" />
	</form_v2:row>

</form_v2:fieldset>