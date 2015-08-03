<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Record fatal error in database."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="failedData" required="true" rtexprvalue="true" description="Failed Data" %>
<%@ attribute name="fatal" required="true" rtexprvalue="true" description="0 or 1" %>
<%@ attribute name="page" required="true" rtexprvalue="true" description="Source page" %>
<%@ attribute name="message" required="true" rtexprvalue="true" description="Error message" %>
<%@ attribute name="description" required="true" rtexprvalue="true" description="Error description" %>
<%@ attribute name="transactionId" required="true" rtexprvalue="true" description="Transaction ID" %>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="property" value="${pageSettings.getBrandCode()}" />
<c:set var="session_id" value="${pageContext.session.id}" />

<c:choose>
	<c:when test="${fatal == 'false' || fatal == '0'}">
		<c:set var="fatal" value="0" />
	</c:when>
	<c:otherwise>
		<c:set var="fatal" value="1" />
	</c:otherwise>
</c:choose>

<%-- TODO: move this to Java --%>
<c:if test="${transactionId == '' and not empty param.transactionId}">
	<c:set var="transactionId" value="${fn:escapeXml(param.transactionId)}" />
</c:if>


<%-- Ensure the TransactionId isn't an empty string because it will violate integrity constraints on the DB --%>
<c:if test="${transactionId == ''}">
	<c:set var="transactionId" value="${null}" />
</c:if>

<%-- Ensure message length will fit into database field --%>
<c:if test="${fn:length(message) > 255}">
	<c:set var="message" value="${fn:substring(message, 0, 255)}" />
</c:if>

<%-- Ensure data length will fit into database field --%>
<c:if test="${fn:length(failedData) > 65535}">
	<c:set var="failedData" value="${fn:substring(failedData, 0, 65535)}" />
</c:if>

<%-- Ensure description length will fit into database field --%>
<c:if test="${fn:length(description) > 65535}">
	<c:set var="description" value="${fn:substring(description, 0, 65535)}" />
</c:if>

<c:if test="${empty page}">
	<c:set var="page" value="${pageContext.request.servletPath}" />
</c:if>

<c:if test="${fn:length(page) > 45}">
	<c:set var="page" value="${fn:substring(page, 0, 45)}" />
</c:if>

<c:if test="${fn:length(session_id) > 64}">
	<c:set var="session_id" value="${fn:substring(session_id, 0, 64)}" />
</c:if>

<%--Commented out because the data var was changed in commit 8407 (AMS-143)
	and this code snippet didn't seem to do anything... --%>
<%--
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
--%>

<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- Add log entry --%>
<sql:update var="addlog">
	INSERT INTO aggregator.fatal_error_log (styleCodeId, property, page, message, description, data, datetime, session_id, transaction_id, isFatal)
	VALUES (?,?,?,?,?,?,Now(),?,?,?);
	<sql:param value="${styleCodeId}" />
	<sql:param value="${property}" />
	<sql:param value="${page}" />
	<sql:param value="${message}" />
	<sql:param value="${description}" />
	<sql:param value="${failedData}" />
	<sql:param value="${session_id}" />
	<sql:param value="${transactionId}" />
	<sql:param value="${fatal}" />
</sql:update>