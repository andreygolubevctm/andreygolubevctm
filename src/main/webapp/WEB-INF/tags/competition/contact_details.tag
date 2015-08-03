<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Competition Details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true"	 rtexprvalue="true"	 description="data xpath" %>
<%@ attribute name="reference" required="false"	 rtexprvalue="true"	 description="competition reference" %>
<%@ attribute name="cid" required="true"	 rtexprvalue="true"	 description="campaign id" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />
<c:set var="optIn"	value="${go:nameFromXpath(xpath)}_call" />

<c:set var="reference"><content:get key="competitionCode"/></c:set>

<c:set var="promocode">${sessionDataService.getCookieByName(pageContext.request, "promocode")}</c:set>

<c:set var="competition_valid">
	<sql:setDataSource dataSource="jdbc/ctm"/>
	<sql:query var="results">
		SELECT *
			FROM ctm.competition
			WHERE reference = ?
			AND effectiveStart < NOW() AND effectiveEnd > NOW()
			LIMIT 1;
		<sql:param value="${reference}" />
	</sql:query>

	<c:choose>
		<c:when test="${results.rowCount > 0}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>

	<c:choose>
		<c:when test="${competition_valid eq false}">

		</c:when>
		<c:otherwise>

	<%-- HTML --%>
	<div id="${name}-selection" class="${name}">

	    <div class="competition-header">
			<img src="brand/ctm/meerkat/spy_kit_banner.jpg" class="banner" />
			<img src="brand/ctm/meerkat/spy_kit_banner_mobile.jpg" class="mobile-banner" />
		</div>

<div class="col-md-6 col-lg-4">
	<p style="font-size:16px;line-height:22px;">Spy kit includes many devices Sergei used during mission, which can now be yours. Including:</p>
	<ul class="items">
		<li>One-of-a-kind decoy Sergei toy</li>
		<li>Walkie talkies</li>
		<li>Stethoscopamajig</li>
		<li>“World’s greatest spykat” mug</li>
		<li>Spy bow tie</li>
		<li>Fancy video recording pen</li>
		<li>Tiny safe, for safe keeping</li>
	</ul>
	<p style="font-size:16px;line-height:22px;padding-bottom:20px;">If you would like to win Sergei’s old spy kit, please fill in forms.</p>

</div>
<div class="col-md-6 col-lg-8">

	<form_new:fieldset legend="">
		<field:hidden xpath="${xpath}/cId" constantValue="${cid}" />
		<field:hidden xpath="${xpath}/reference" constantValue="${reference}" />
		<field:hidden xpath="${xpath}/promocode" constantValue="${promocode}" />
		<field:hidden xpath="${xpath}/competitionId" constantValue="${results.rows[0].competitionId}" />
		<field:hidden xpath="${xpath}/returnUrl" constantValue="${results.rows[0].returnUrl}" />

		<form_new:row label="First names" className="halfrow">
			<field:person_name xpath="${xpath}/firstName" title="first name" required="true" />
		</form_new:row>

		<form_new:row label="Last names" className="halfrow">
			<field:person_name xpath="${xpath}/lastName" title="last name" required="true" />
		</form_new:row>

		<form_new:row label="Email" className="clear email-row">
			<field_new:email xpath="${xpath}/email" title="your email address" required="true" size="40"/>
		</form_new:row>

		<form_new:row label="Post codings" className="halfrow">
			<field:post_code xpath="${xpath}/postcode" title="postcode" required="true" />
		</form_new:row>

		<form_new:row label="Date of births">
			<field_new:person_dob xpath="${xpath}/dob" title="your" required="true" ageMin="16" ageMax="120" />
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
				 I agrees to <a href="${contentService.getContentValue(pageContext.getRequest(), 'competitionTermsUrl')}" target="_blank" />T&Cs</a> and <a href="${pageSettings.getSetting('privacyPolicyUrl')}" target="_blank" >Privacy Policy</a>.
			</c:set>
			<field_new:checkbox
				xpath="competition/privacyoptin"
				value="Y"
				className="validate"
				required="true"
				label="${true}"
				title="${label}"
				errorMsg="Please confirm you have read the T&Cs and privacy policy" />
		</form_new:row>
		<%--	</c:otherwise>
		</c:choose>--%>

	</form_new:fieldset>
	</div>
</div>


</c:otherwise>
</c:choose>
