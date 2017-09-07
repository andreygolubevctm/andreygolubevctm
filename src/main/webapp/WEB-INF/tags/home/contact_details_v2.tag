<%@ tag description="Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Email Address --%>
<c:set var="fieldXPath" value="${xpath}/email" />
<form_v2:row fieldXpath="${fieldXPath}" label="Email Address">
	<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Email Address" quoteChar="\"" /></c:set>
	<field_v2:email xpath="${fieldXPath}"
		required="false"
		title="the policy holder's email address"
		additionalAttributes=" data-rule-validateOkToEmail='true' ${analyticsAttr}" />
</form_v2:row>

<%-- Marketing --%>
<field_v1:hidden xpath="${xpath}/marketing" defaultValue="N" />

<%-- Best Contact Number --%>
<c:set var="fieldXPath" value="${xpath}/phone" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Phone Number - Tool Tip" quoteChar="\"" /></c:set>
<form_v2:row fieldXpath="${fieldXPath}" label="Best contact number" className="clear" helpId="524" tooltipAttributes="${analyticsAttr}">
	<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Phone Number" quoteChar="\"" /></c:set>
	<field_v1:flexi_contact_number xpath="${fieldXPath}"
									maxLength="20"
									required="false"
									labelName="best number for the insurance provider to contact you to discuss your insurance needs"
									validationAttribute=" data-rule-validateOkToCall='true' "
									additionalAttributes="${analyticsAttr}" />
</form_v2:row>

<%-- OK to call --%>
<field_v1:hidden xpath="${xpath}/oktocall" defaultValue="N" />

<%-- Mandatory agreement to privacy policy --%>
<field_v1:hidden xpath="home/privacyoptin" defaultValue="N" />