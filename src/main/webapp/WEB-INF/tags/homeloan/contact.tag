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

	<form_v2:fieldset legend="Your Contact Details">

		<form_v2:row label="First name" className="halfrow">
			<field:person_name xpath="${xpath}/firstName" title="first name" required="false" />
		</form_v2:row>

		<form_v2:row label="Last name" className="halfrow">
			<field:person_name xpath="${xpath}/lastName" title="last name" required="false" />
		</form_v2:row>

		<form_v2:row label="Your email address" className="clear email-row">
			<field_new:email xpath="${xpath}/email" title="your email address" required="false" size="40"/>
		</form_v2:row>

		<c:set var="brandName">
			<content:optin key="brandDisplayName" useSpan="true"/>
		</c:set>

		<form_v2:row label="Your contact number" className="clear">
			<field:contact_telno xpath="${xpath}/contactNumber" title="your contact number" required="false" size="40"/>
			<p class="optinText">By entering my telephone number I agree that an authorised broker from AFG, ${brandName}'s approved supplier of home loans, may contact me to further assist with my home loan needs.</p>
		</form_v2:row>

		<form_v2:row label="" className="email-optin-row clear closer">
			<field_new:checkbox
					xpath="${xpath}/optIn"
					value="Y"
					title="Yes, keep me updated about news, discounts and special offers from ${brandName}"
					required="false"
					label="true"/>
		</form_v2:row>

		<%-- Mandatory agreement to privacy policy --%>
		<%--<c:choose>--%>
			<%-- Only render a hidden field when the checkbox has already been selected --%>
		<%--	<c:when test="${data['homeloan/privacyoptin'] eq 'Y'}">
				<field:hidden xpath="homeloan/privacyoptin" defaultValue="Y" constantValue="Y" />
			</c:when>
			<c:otherwise>--%>
				<form_v2:row hideHelpIconCol="true">
					<c:set var="label">
						* I have read the <form_v1:link_privacy_statement /> and <a href="legal/CreditGuide.pdf" target="_blank">credit guide</a>.
					</c:set>
					<field_new:checkbox
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
