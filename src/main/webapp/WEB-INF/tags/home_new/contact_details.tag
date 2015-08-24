<%@ tag description="Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />
<c:set var="mandatoryFieldsSplitTest" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 35)}" />

<form_new:fieldset legend="Contact Details" id="${name}_FieldSet">


	<%-- Email Address --%>
	<c:set var="fieldXpath" value="${xpath}/email" />
	<form_new:row fieldXpath="${fieldXpath}" label="Email Address">
		<field_new:email xpath="${fieldXpath}"
			required="${mandatoryFieldsSplitTest}"
			title="the policy holder's email address" />
	</form_new:row>

	<%-- Marketing --%>
	<c:set var="fieldXpath" value="${xpath}/marketing" />
	<form_new:row fieldXpath="${fieldXpath}" label="OK to email">
		<field_new:array_radio xpath="${fieldXpath}"
			required="true"
			items="Y=Yes,N=No"
			className="pretty_buttons"
			id="marketing"
			title="if you would like to be informed via email of news and other offers" />
		<content:optin key="okToEmail"/>
	</form_new:row>

	<%-- Best Contact Number --%>
	<c:set var="fieldXpath" value="${xpath}/phone" />
	<form_new:row fieldXpath="${fieldXpath}" label="Best contact number" helpId="524">
		<field:contact_telno xpath="${fieldXpath}"
			required="false"
			title="best number for the insurance provider to contact you on (You will only be contacted by phone if you answer 'Yes' to the 'OK to call' question on this screen)"/>
	</form_new:row>

	<%-- OK to call --%>
	<c:set var="fieldXpath" value="${xpath}/oktocall" />
	<form_new:row fieldXpath="${fieldXpath}" label="OK to call">
		<field_new:array_radio xpath="${fieldXpath}"
			required="true"
			items="Y=Yes,N=No"
			className="pretty_buttons"
			id="oktocall"
			title="if it's OK to call the policy holder regarding the lowest price quote" />
		<p class="optinText">I give permission for the insurance provider that presents the lowest price to call me within the next 2 business days to discuss my home &amp; contents insurance needs.</p>
	</form_new:row>

	<%-- Mandatory agreement to privacy policy --%>
	<form_new:privacy_optin vertical="home" />

</form_new:fieldset>
<go:validate selector="${name}_phoneinput" rule="validateOkToCall" parm="true" message="Please enter a contact number" />
<go:validate selector="${name}_email" rule="validateOkToEmail" parm="true" message="Please enter your email address" />