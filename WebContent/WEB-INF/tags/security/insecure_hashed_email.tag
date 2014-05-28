<%--
	TODO: DELETE ME WHEN WE ARE OFF DISC
--%>

<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Returns the unhashed email address or false"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%@ attribute name="email" 			required="true"	 	rtexprvalue="true"	 description="plain text email coming from an unsubscribe link" %>
<%@ attribute name="unsubscribe"	type="com.ctm.model.Unsubscribe"	required="true"		rtexprvalue="true"  %>

<sql:query var="results">
		SELECT emailid, firstName , lastName, emailAddress, hashedEmail
		FROM aggregator.email_master
		WHERE emailAddress=?
		AND styleCodeId=?
		LIMIT 1;
	<sql:param value="${fn:substring(email, 0, 256)}" />
	<sql:param value="${styleCodeId}" />
</sql:query>
<c:choose>
	<c:when test="${results.rowCount > 0}">
		<c:set var="ignore" value="${unsubscribe.getEmailDetails().setEmailAddress(email)}" />
		<c:set var="ignore" value="${unsubscribe.getEmailDetails().setEmailId(results.rows[0].emailid)}" />
		<c:set var="ignore" value="${unsubscribe.getEmailDetails().setHashedEmail(results.rows[0].hashedEmail)}" />
		<c:set var="ignore" value="${unsubscribe.getEmailDetails().setFirstName(results.rows[0].firstName)}" />
		<c:set var="ignore" value="${unsubscribe.getEmailDetails().setLastName(results.rows[0].lastName)}" />
		<c:set var="ignore" value="${unsubscribe.getEmailDetails().setValid(true)}" />
	</c:when>
	<c:otherwise>
		<c:set var="ignore" value="${unsubscribe.getEmailDetails().setValid(false)}" />
	</c:otherwise>
</c:choose>