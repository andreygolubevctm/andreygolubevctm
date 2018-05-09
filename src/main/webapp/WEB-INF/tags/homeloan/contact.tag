<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Homeloan Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />

<c:set var="optInText"><content:get key="optInText" /></c:set>

<%-- Get current  --%>
<c:set var="websiteTermConfigToUse">
	<content:get key="websiteTermsUrlConfig"/>
</c:set>

<c:choose>
	<c:when test="${africaComp}">
		<c:set var="optInText"><content:get key="africaCompOptInText" /></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="optInText"><content:get key="optInText" /></c:set>
	</c:otherwise>
</c:choose>

<c:set var="websiteTermConfigPlaceHolder">${pageSettings.getSetting(websiteTermConfigToUse)}</c:set>
<c:set var="privacyStmtPlaceHolder"><form_v1:link_privacy_statement /></c:set>
<c:set var="creditGuidePlaceHolder"	value="/static/legal/CreditGuide.pdf" />

<c:set var="optInText" value="${fn:replace(optInText, '%creditGuidePlaceHolder%', creditGuidePlaceHolder)}" />
<c:set var="optInText" value="${fn:replace(optInText, '%privacyStmtPlaceHolder%', privacyStmtPlaceHolder)}" />
<c:set var="optInText" value="${fn:replace(optInText, '%websiteTermConfigPlaceHolder%', websiteTermConfigPlaceHolder)}" />

<%-- HTML --%>
<div id="${name}-selection" class="${name}">

	<form_v2:fieldset legend="Your Contact Details">

		<form_v2:row label="First name" className="halfrow">
			<field_v1:person_name xpath="${xpath}/firstName" title="first name" required="true" />
		</form_v2:row>

		<form_v2:row label="Last name" className="halfrow">
			<field_v1:person_name xpath="${xpath}/lastName" title="last name" required="true" />
		</form_v2:row>

		<form_v2:row label="Your email address" className="clear email-row">
			<field_v2:email xpath="${xpath}/email" title="your email address" required="true" size="40"/>
		</form_v2:row>

		<c:set var="fieldXPath" value="${xpath}/contactNumber"/>

		<form_v2:row label="Your contact number" className="clear">
			<field_v1:flexi_contact_number xpath="${fieldXPath}"
										maxLength="20"
										required="${true}"
										labelName="your contact number"/>
		</form_v2:row>

		<ad_containers:custom customId="contact-details" />

		<form_v2:row label="" className="email-optin-row clear closer">
			<%-- Mandatory agreement to OptIn to email  --%>
			<field_v1:hidden xpath="${xpath}/optIn" defaultValue="Y" constantValue="Y" />

		</form_v2:row>

		<%-- Mandatory agreement to privacy policy --%>
		<%--<c:choose>--%>
			<%-- Only render a hidden field when the checkbox has already been selected --%>
		<%--	<c:when test="${data['homeloan/privacyoptin'] eq 'Y'}">
				<field_v1:hidden xpath="homeloan/privacyoptin" defaultValue="Y" constantValue="Y" />
			</c:when>
			<c:otherwise>--%>
				<form_v2:row hideHelpIconCol="true">
					<c:set var="label">
						${optInText}
					</c:set>
					<field_v2:checkbox
						xpath="homeloan/privacyoptin"
						value="Y"
						className="validate"
						required="true"
						label="${true}"
						title="${label}"
						errorMsg="Please confirm you have read the Privacy Policy and credit guide" />
				</form_v2:row>
		<%--	</c:otherwise>
		</c:choose>--%>

	</form_v2:fieldset>

</div>
