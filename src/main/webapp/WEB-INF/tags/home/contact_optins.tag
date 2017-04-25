<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Get Opt-in text from db and replace placeholders as required --%>
<c:set var="optInText"><content:get key="optInText" /></c:set>

<c:set var="websiteTermConfigToUse">
	<content:get key="websiteTermsUrlConfig"/>
</c:set>

<c:set var="websiteTermConfigPlaceHolder">${pageSettings.getSetting(websiteTermConfigToUse)}</c:set>
<c:set var="privacyStmtPlaceHolder"><form_v1:link_privacy_statement overrideLabel="Privacy Policy<span class='sr-only'>Opens in new window</span>" /></c:set>
<c:set var="fsgPlaceHolder">${pageSettings.getSetting('fsgUrl')}</c:set>
<c:set var="companyNamePlaceHolder"><content:optin key="brandDisplayName" useSpan="true"/></c:set>

<c:set var="optInText" value="${fn:replace(
									fn:replace(
										fn:replace(
											fn:replace(optInText,
												'%FinancialServicesGuidePlaceHolder%', fsgPlaceHolder),
												'%privacyStmtPlaceHolder%', privacyStmtPlaceHolder),
												'%websiteTermConfigPlaceHolder%', websiteTermConfigPlaceHolder),
												'%companyNamePlaceHolder%', companyNamePlaceHolder)}" />

<%-- HTML --%>
<form_v2:fieldset legend="Terms and Conditions" id="${name}FieldSet">
	<c:set var="genericOptin">${optInText}</c:set>

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