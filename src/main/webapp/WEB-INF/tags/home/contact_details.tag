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
	<c:set var="fieldXpath" value="${xpath}/email" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Email Address">
		<field_v2:email xpath="${fieldXpath}"
			required="${mandatoryFieldsSplitTest}"
			title="the policy holder's email address" additionalAttributes=" data-rule-validateOkToEmail='true' " />
	</form_v2:row>

	<%-- Marketing --%>
	<c:set var="fieldXpath" value="${xpath}/marketing" />
	<form_v2:row fieldXpath="${fieldXpath}" label="OK to email">
		<field_v2:array_radio xpath="${fieldXpath}"
			required="true"
			items="Y=Yes,N=No"
			className="pretty_buttons"
			id="marketing"
			title="if you would like to be informed via email of news and other offers" />
		<content:optin key="okToEmail"/>
	</form_v2:row>

	<%-- Best Contact Number --%>
	<c:set var="fieldXpath" value="${xpath}/phone" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Best contact number" helpId="524">
		<field_v1:contact_telno xpath="${fieldXpath}"
			required="false"
			title="best number for the insurance provider to contact you on (You will only be contacted by phone if you answer 'Yes' to the 'OK to call' question on this screen)" validationAttribute=" data-rule-validateOkToCall='true' " />
	</form_v2:row>

	<%-- OK to call --%>
	<c:set var="fieldXpath" value="${xpath}/oktocall" />
	<form_v2:row fieldXpath="${fieldXpath}" label="OK to call">
		<field_v2:array_radio xpath="${fieldXpath}"
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