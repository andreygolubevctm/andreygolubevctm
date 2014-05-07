<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="GENERIC" />

<%-- #WHITELABEL styleCodeID --%>
<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%--
	forgotten_password.jsp

	Calls the iSeries program NTAGGPRS which will send an email to the client containing a link that
	allows then to reset their password.
	The link is only active for around 30 minutes (or whatever the timeout is set to)

	@param email - The client's email address
--%>
<c:choose>
	<c:when test="${not empty param.email}">

		<%-- Check email on iSeries --%>
		<c:set var="pgmData" value="<data><email>${param.email}</email></data>" />
		<go:call pageId="AGGPRS"   wait="TRUE" xmlVar="pgmData"  resultVar="result" style="CTM"/>

		<%-- Check email on MySQL --%>
		<sql:setDataSource dataSource="jdbc/aggregator"/>
		<sql:query var="testEmail">
			SELECT emailId
			    FROM aggregator.email_master
			    WHERE emailAddress = ?
			    AND styleCodeId = ?
			    LIMIT 1;
			<sql:param><c:out value="${param.email}" escapeXml="true" /></sql:param>
			<sql:param value="${styleCodeId}" />
		</sql:query>
		<c:choose>
			<c:when test="${not empty(testEmail) and testEmail.rowCount == 1}">
				OK
			</c:when>
			<c:when test="${result=='true'}" >
				OK
			</c:when>
			<c:otherwise>
				That email address was not found on file
			</c:otherwise>
		</c:choose>

	</c:when>
	<c:otherwise>
		Email address is empty
	</c:otherwise>
</c:choose>
