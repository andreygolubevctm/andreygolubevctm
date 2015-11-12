<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Homeloan Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />
<c:set var="optIn"	value="${go:nameFromXpath(xpath)}_call" />

<%-- HTML --%>
<div id="${name}-selection" class="${name}">

	<form_new:fieldset legend="Your Contact Details">

		<form_new:row label="First name" className="halfrow">
			<field:person_name xpath="${xpath}/firstName" title="first name" required="false" />
		</form_new:row>

		<form_new:row label="Last name" className="halfrow">
			<field:person_name xpath="${xpath}/lastName" title="last name" required="false" />
		</form_new:row>

		<form_new:row label="Your email address" className="clear email-row">
			<field_new:email xpath="${xpath}/email" title="your email address" required="false" size="40"/>
		</form_new:row>

		<c:set var="fieldXPath" value="${xpath}/contactNumber"/>
		<form_new:row label="Your contact number" className="clear">
			<field:flexi_contact_number xpath="${fieldXPath}"
										maxLength="20"
										required="${false}"
										labelName="your contact number"/>
			<p class="optinText">By entering my telephone number I agree that an authorised broker from AFG, <content:optin key="brandDisplayName" useSpan="true"/>'s approved supplier of home loans, may contact me to further assist with my home loan needs.</p>
		</form_new:row>

		<form_new:row label="" className="email-optin-row clear closer">
			<field_new:checkbox xpath="${xpath}/optIn" value="Y" title="Stay up to date with news and offers direct to your inbox" required="false" label="true"/>
		</form_new:row>

		<%-- Mandatory agreement to privacy policy --%>
		<%--<c:choose>--%>
			<%-- Only render a hidden field when the checkbox has already been selected --%>
		<%--	<c:when test="${data['homeloan/privacyoptin'] eq 'Y'}">
				<field:hidden xpath="homeloan/privacyoptin" defaultValue="Y" constantValue="Y" />
			</c:when>
			<c:otherwise>--%>
				<form_new:row hideHelpIconCol="true">
					<c:set var="label">
						I have read the <form:link_privacy_statement /> and <a href="legal/CreditGuide.pdf" target="_blank">credit guide</a>.
					</c:set>
					<field_new:checkbox
						xpath="homeloan/privacyoptin"
						value="Y"
						className="validate"
						required="true"
						label="${true}"
						title="${label}"
						errorMsg="Please confirm you have read the privacy statement and credit guide" />
				</form_new:row>
		<%--	</c:otherwise>
		</c:choose>--%>

	</form_new:fieldset>

</div>
