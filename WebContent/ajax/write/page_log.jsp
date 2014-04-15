<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%--
	page_log.jsp

	Used to write page log records on the iSeries
--%>
<session:get settings="true"/>

<go:log level="DEBUG" source="write:page_log">Writing Page Log</go:log>

<%-- DISC call 'AGGPAG' requires pageId and sessionId --%>
<go:setData dataVar="data" xpath="log/pageId" value="${param.pageId}" />
<go:setData dataVar="data" xpath="log/sessionId" value="${pageContext.session.id}" />

<%-- Also store the log data in mysql --%>
	<sql:setDataSource dataSource="jdbc/aggregator"/>

	<%-- Get the next sequenceNo to be stored --%>
	<c:set var="sequenceNo">
		<sql:query var="existing">
			SELECT MAX(sequenceNo) + 1 AS sequenceNo FROM aggregator.transaction_page_log WHERE transactionId = ?;
			<sql:param value="${data.current.transactionId}" />
		</sql:query>
		<c:choose>
			<c:when test="${not empty existing and existing.rowCount > 0}">${existing.rows[0].sequenceNo}</c:when>
			<c:otherwise>${1}</c:otherwise>
		</c:choose>
	</c:set>

	<c:if test="${sequenceNo == ''}">
		<c:set var="sequenceNo" value="1" />
	</c:if>

	<%-- Store the new log record --%>
	<c:catch var="error">
		<sql:update var="result">
			INSERT INTO aggregator.transaction_page_log (transactionId, sequenceNo, pageId, tranDate, tranTime, tranType, status)
			VALUES (?, ?, ?, NOW(), NOW(), null, null);
			<sql:param value="${data.current.transactionId}" />
			<sql:param value="${sequenceNo}" />
			<sql:param value="${data.log.pageId}" />
		</sql:update>
	</c:catch>

	<c:if test="${not empty error}">
		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="transactionId" value="${data.current.transactionId}" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="ajax/write/page_log.jsp" />
			<c:param name="description" value="${error}" />
			<c:param name="data" value="transactionId=${data.current.transactionId} vertical=${data.current.verticalCode}" />
		</c:import>
	</c:if>

	<%--TODO: remove this once we are off DISC --%>
	<c:if test="${'CAR' == fn:toUpperCase(data.current.verticalCode)}">
		<go:call pageId="AGGPAG" transactionId="${data.text['current/transactionId']}" wait="FALSE" xmlVar="${data.xml['log']}" />
	</c:if>