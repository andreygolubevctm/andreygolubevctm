<%@ tag description="Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />
<c:set var="mandatoryFieldsSplitTest" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 35)}" />

<form_v2:fieldset legend="Contact Details" id="${name}_FieldSet">


	<%-- Email Address --%>
	<c:set var="fieldXPath" value="${xpath}/email" />
	<form_v2:row fieldXpath="${fieldXPath}" label="Email Address">
		<field_v2:email xpath="${fieldXPath}"
			required="${mandatoryFieldsSplitTest}"
			title="the policy holder's email address" additionalAttributes=" data-rule-validateOkToEmail='true' " />
	</form_v2:row>

	<%-- Marketing --%>
	<c:set var="fieldXPath" value="${xpath}/marketing" />
	<form_v2:row fieldXpath="${fieldXPath}" label="OK to email">
		<field_v2:array_radio xpath="${fieldXPath}"
			required="true"
			items="Y=Yes,N=No"
			className="pretty_buttons"
			id="marketing"
			title="if you would like to be informed via email of news and other offers" />
		<content:optin key="okToEmail"/>
	</form_v2:row>

	<%-- Best Contact Number --%>
	<c:set var="fieldXPath" value="${xpath}/phone" />
	<form_v2:row fieldXpath="${fieldXPath}" label="Best contact number" className="clear" helpId="524">
		<field_v1:flexi_contact_number xpath="${fieldXPath}"
									maxLength="20"
									required="${false}"
									labelName="best number for the insurance provider to contact you to discuss your insurance needs"
									validationAttribute=" data-rule-validateOkToCall='true' "/>
	</form_v2:row>

	<%-- OK to call --%>
	<c:set var="fieldXPath" value="${xpath}/oktocall" />
	<form_v2:row fieldXpath="${fieldXPath}" label="OK to call">
		<field_v2:array_radio xpath="${fieldXPath}"
			required="true"
			items="Y=Yes,N=No"
			className="pretty_buttons"
			id="oktocall"
			title="if it's OK to call the policy holder regarding the lowest price quote" />
		<p class="optinText">I give permission for the insurance provider that presents the lowest price to call me within the next 4 business days to discuss my home &amp; contents insurance needs.</p>
	</form_v2:row>

	<%-- Mandatory agreement to privacy policy --%>
	<form_v2:privacy_optin vertical="home" />

</form_v2:fieldset>