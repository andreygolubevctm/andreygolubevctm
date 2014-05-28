<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_new:no_cache_header/>

<c:choose>
	<c:when test="${not empty param.transactionId}">
		<session:get settings="true" />
	</c:when>
	<c:otherwise>
		<settings:setVertical verticalCode="GENERIC" />
		<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />
	</c:otherwise>
</c:choose>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<c:set var="transaction_id" value="${data.current.transactionId }" />
<c:set var="page" value="${param.page}" />
<c:set var="message" value="${param.message}" />
<c:set var="description" value="${param.description}" />
<c:set var="data2" value="${param.data}" />
<c:set var="session_id" value="${pageContext.session.id}" />


<c:set var="property" value="${pageSettings.getBrandCode()}" />


<c:choose>
	<c:when test="${param.fatal == 'false'}">
		<c:set var="fatal" value="0" />
	</c:when>
	<c:otherwise>
		<c:set var="fatal" value="1" />
	</c:otherwise>
</c:choose>

<%-- Ensure message length will fit into database field --%>
<c:if test="${fn:length(message) > 255}">
	<c:set var="message" value="${fn:substring(message, 0, 255)}" />
</c:if>


<c:if test="${empty page}"><c:set var="page" value="${pageContext.request.servletPath}" /></c:if>

<c:set var="ignore">
	<c:set var="strippedSB" value="${go:getStringBuilder()}" />
	<c:forTokens items="${data}" delims="&" var="field">
		<c:if test="${!field.contains('credit') && !field.contains('bank')}">
			${go:appendString(strippedSB , amp)}
			${go:appendString(strippedSB , field)}
			<c:set var="amp">&</c:set>
		</c:if>
	</c:forTokens>
	<c:set var="data" value="${strippedSB.toString()}" />
</c:set>

<sql:setDataSource dataSource="jdbc/test"/>

<%-- Add log entry --%>
<c:catch var="error">
	<sql:update var="addlog">
		INSERT INTO test.fatal_error_log (styleCodeId, property, page, message, description, data, datetime, session_id, transaction_id, isFatal)
		VALUES
		(?,?,?,?,?,?,Now(),?,?,?);
		<sql:param value="${styleCodeId}" />
		<sql:param value="${property}" />
		<sql:param value="${page}" />
		<sql:param value="${message}" />
		<sql:param value="${description}" />
		<sql:param value="${data2}" />
		<sql:param value="${session_id}" />
		<sql:param value="${transaction_id}" />
		<sql:param value="${fatal}" />
	</sql:update>
</c:catch>

<%-- Test for DB issue and handle - otherwise move on --%>
<c:choose>
	<c:when test="${not empty error}">
		<go:log level="ERROR" error="${error}" source="register_fatal_error_jsp">error: ${error}</go:log>
	</c:when>
	<c:otherwise>
		<%-- Important keep this as debug as there may be credit card details in the params--%>
		<go:log level="DEBUG" source="register_fatal_error_jsp">param: ${param}</go:log>
	</c:otherwise>
</c:choose>