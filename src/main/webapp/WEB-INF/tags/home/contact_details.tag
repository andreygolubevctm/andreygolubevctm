<%@ tag description="Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_v2:fieldset legend="Contact Details" id="${name}_FieldSet">

	<%-- Email Address --%>
	<c:set var="fieldXPath" value="${xpath}/email" />
	<form_v2:row fieldXpath="${fieldXPath}" label="Email Address">
		<field_v2:email xpath="${fieldXPath}"
			required="false"
			title="the policy holder's email address"
			additionalAttributes=" data-rule-validateOkToEmail='true' " />
	</form_v2:row>

	<%-- Marketing --%>
	<c:choose>
		<c:when test="${singleOptinSplitTest eq true}">
			<field_v1:hidden xpath="${xpath}/marketing" defaultValue="N" />
		</c:when>
		<c:otherwise>
			<c:set var="fieldXPath" value="${xpath}/marketing" />
			<form_v2:row fieldXpath="${fieldXPath}" label="OK to email">
				<field_v2:array_radio xpath="${fieldXPath}"
									  required="true"
									  items="Y=Yes,N=No"
									  className="pretty_buttons"
									  id="marketing"
									  title="if you would like to be informed via email of news and other offers"
									  additionalAttributes=" data-rule-validateOkToEmailRadio='true' " />
				<content:optin key="okToEmail"/>
			</form_v2:row>
		</c:otherwise>
	</c:choose>

	<%-- Best Contact Number --%>
	<c:set var="fieldXPath" value="${xpath}/phone" />
	<form_v2:row fieldXpath="${fieldXPath}" label="Best contact number" className="clear" helpId="524">
		<field_v1:flexi_contact_number xpath="${fieldXPath}"
										maxLength="20"
										required="false"
										labelName="best number for the insurance provider to contact you to discuss your insurance needs"
										validationAttribute=" data-rule-validateOkToCall='true' "/>
	</form_v2:row>

	<%-- OK to call --%>
	<c:choose>
		<c:when test="${singleOptinSplitTest eq true}">
			<field_v1:hidden xpath="${xpath}/oktocall" defaultValue="N" />
		</c:when>
		<c:otherwise>
			<c:set var="fieldXPath" value="${xpath}/oktocall" />
			<form_v2:row fieldXpath="${fieldXPath}" label="OK to call">
				<field_v2:array_radio xpath="${fieldXPath}"
					required="true"
					items="Y=Yes,N=No"
					className="pretty_buttons"
					id="oktocall"
					title="if it's OK to call the policy holder regarding the lowest price quote"
				    additionalAttributes=" data-rule-validateOkToCallRadio='true' " />
				<p class="optinText">I give permission for the insurance provider that presents the lowest price to call me within the next 4 business days to discuss my home &amp; contents insurance needs.</p>
			</form_v2:row>
		</c:otherwise>
	</c:choose>

	<%-- Mandatory agreement to privacy policy --%>
	<c:choose>
		<c:when test="${singleOptinSplitTest eq true}">
			<field_v1:hidden xpath="home/privacyoptin" defaultValue="N" />
		</c:when>
		<c:otherwise>
			<form_v2:privacy_optin vertical="home" />
		</c:otherwise>
	</c:choose>

</form_v2:fieldset>