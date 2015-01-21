<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_new:no_cache_header/>

<c:set var="page"><c:out value="${param.page}" escapeXml="true" /></c:set>
<c:set var="message"><c:out value="${param.message}" escapeXml="true" /></c:set>
<c:set var="description"><c:out value="${param.description}" escapeXml="true" /></c:set>
<c:set var="failedData"><c:out value="${param.data}" escapeXml="true" /></c:set>
<c:set var="isFatal"><c:out value="${param.fatal}" escapeXml="true" /></c:set>

<c:choose>
	<c:when test="${not empty param.transactionId}">
		<session:get settings="true" />
	</c:when>
	<c:otherwise>
		<settings:setVertical verticalCode="GENERIC" />
		<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />
	</c:otherwise>
</c:choose>

<%-- Add log entry --%>
<c:catch var="error">
	<error:fatal_error
		page="${page}"
		message="${message}"
		description="${description}"
		failedData="${failedData}"
		fatal="${isFatal}"
		transactionId="${transactionId}"
	/>
</c:catch>

<%-- Test for DB issue and handle - otherwise move on --%>
<c:choose>
	<c:when test="${not empty error}">
		<go:log level="ERROR">[ERROR] Fatal Error Log: ${error}</go:log>
	</c:when>
	<c:otherwise>
		<%-- Important keep this as debug as there may be credit card details in the params--%>
		<go:log level="DEBUG">Fatal Error Log: ${param}</go:log>
	</c:otherwise>
</c:choose>