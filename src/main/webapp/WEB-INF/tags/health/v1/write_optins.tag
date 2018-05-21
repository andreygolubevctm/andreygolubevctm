<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('tag.health.write_optins')}" />

<jsp:useBean id="now" class="java.util.Date" scope="request" />

<%-- Attributes --%>
<%@ attribute name="userDetails"	 type="com.ctm.web.health.model.request.UserDetails" required="false" rtexprvalue="true"	 description="Users first name from either questionset or application" %>

<c:set var="brand" value="${pageSettings.getBrandCode()}"/>
<%-- 1st step - optout emails in the history. Done first just in case an email in the history in questionset
	is added again in the application phase --%>
<c:if test="${not empty userDetails.questionSet.optOutEmailHistory}">
	<c:forTokens items="${userDetails.questionSet.optOutEmailHistory}" delims="," var="email">
		<agg_v1:write_email
				brand="${brand}"
				vertical="${userDetails.rootPath}"
				source="QUOTE"
				emailAddress="${email}"
				firstName="${userDetails.firstname}"
				lastName="${userDetails.lastname}"
				items="marketing=N" />
	</c:forTokens>
</c:if>
<c:if test="${not empty userDetails.application.optOutEmailHistory}">
	<c:forTokens items="${userDetails.application.optOutEmailHistory}" delims="," var="email">
			<agg_v1:write_email
				brand="${brand}"
				vertical="${userDetails.rootPath}"
				source="QUOTE"
				emailAddress="${email}"
				firstName="${userDetails.firstname}"
				lastName="${userDetails.lastname}"
				items="marketing=N" />
	</c:forTokens>
</c:if>

<%-- 2nd step - Add optins for secondary email fields --%>
<c:if test="${not empty userDetails.questionSet.emailAddressSecondary}">
	<agg_v1:write_email
			brand="${brand}"
			vertical="${userDetails.rootPath}"
			source="QUOTE"
			emailAddress="${userDetails.questionSet.emailAddressSecondary}"
			firstName="${userDetails.firstname}"
			lastName="${userDetails.lastname}"
			items="marketing=Y" />
</c:if>
<c:if test="${not empty userDetails.application.emailAddressSecondary}">
	<agg_v1:write_email
			brand="${brand}"
			vertical="${userDetails.rootPath}"
			source="APPLICATION"
			emailAddress="${userDetails.application.emailAddressSecondary}"
			firstName="${userDetails.firstname}"
			lastName="${userDetails.lastname}"
			items="marketing=Y" />
</c:if>

<%-- 3rd step - Add primary email fields --%>
<c:if test="${not empty userDetails.questionSet.emailAddress}">
		<agg_v1:write_email
			brand="${brand}"
			vertical="${userDetails.rootPath}"
			source="QUOTE"
			emailAddress="${userDetails.questionSet.emailAddress}"
			firstName="${userDetails.firstname}"
			lastName="${userDetails.lastname}"
			items="marketing=${userDetails.questionSet.optinEmailAddress},okToCall=${userDetails.questionSet.okToCall}" />
</c:if>
<c:if test="${not empty userDetails.application.emailAddress}">
	<agg_v1:write_email
			brand="${brand}"
			vertical="${userDetails.rootPath}"
			source="APPLICATION"
			emailAddress="${userDetails.application.emailAddress}"
			firstName="${userDetails.firstname}"
			lastName="${userDetails.lastname}"
			items="marketing=${userDetails.application.optinEmailAddress},okToCall=${userDetails.application.okToCall}" />
</c:if>

<%-- 4th step - Write phone optins to stamping table --%>
<c:set var="userDetails.questionSet.okToCall">
	<c:choose>
		<c:when test="${userDetails.questionSet.okToCall eq 'Y'}">on</c:when>
		<c:otherwise>off</c:otherwise>
	</c:choose>
</c:set>
<c:if test="${not empty userDetails.questionSet.phoneOther}">
	<agg_v1:write_stamp
		action="toggle_okToCall"
		vertical="${fn:toLowerCase(userDetails.rootPath)}"
		target="${userDetails.questionSet.phoneOther}"
		value="${userDetails.questionSet.okToCall}"
		comment="QUOTE"
	/>
</c:if>
<c:if test="${not empty userDetails.questionSet.phoneMobile}">
	<agg_v1:write_stamp
		action="toggle_okToCall"
		vertical="${fn:toLowerCase(userDetails.rootPath)}"
		target="${userDetails.questionSet.phoneMobile}"
		value="${userDetails.questionSet.okToCall}"
		comment="QUOTE"
	/>

</c:if>

<c:set var="userDetails.application.okToCall">
	<c:choose>
		<c:when test="${userDetails.application.okToCall eq 'Y'}">on</c:when>
		<c:otherwise>off</c:otherwise>
	</c:choose>
</c:set>
<c:if test="${not empty userDetails.application.phoneOther}">
	<agg_v1:write_stamp
		action="toggle_okToCall"
		vertical="${fn:toLowerCase(userDetails.rootPath)}"
		target="${userDetails.application.phoneOther}"
		value="${userDetails.application.okToCall}"
		comment="APPLICATION"
	/>
</c:if>
<c:if test="${not empty userDetails.application.phoneMobile}">
	<agg_v1:write_stamp
		action="toggle_okToCall"
		vertical="${fn:toLowerCase(userDetails.rootPath)}"
		target="${userDetails.application.phoneMobile}"
		value="${userDetails.application.okToCall}"
		comment="APPLICATION"
	/>

</c:if>

${logger.debug('Completed write opt ins. {}', log:kv('userDetails',userDetails ))}