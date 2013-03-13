<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:import var="confirmTransactionId" url="../json/get_transactionid.jsp?id_handler=preserve_tranId" />
<c:set var="transaction_id" value="${data.current.transactionId }" />
<c:set var="property" value="${param.property}" />
<c:set var="page" value="${param.page}" />
<c:set var="message" value="${param.message}" />
<c:set var="description" value="${param.description}" />
<c:set var="data" value="${param.data}" />
<c:set var="session_id" value="${pageContext.session.id}" />

<%-- Ensure message length will fit into database field --%>
<c:if test="${fn:length(message) > 255}">
	<c:set var="message" value="${fn:substring(message, 0, 255)}" />
</c:if>

<sql:setDataSource dataSource="jdbc/test"/>

<%-- Add log entry --%>	
<c:catch var="error">	
	<sql:update var="addlog">
		INSERT INTO test.fatal_error_log (property, page, message, description, data, datetime, session_id, transaction_id)
		VALUES
		(?,?,?,?,?,Now(),?,?);
		<sql:param value="${property}" />
		<sql:param value="${page}" />
		<sql:param value="${message}" />	
		<sql:param value="${description}" />			
		<sql:param value="${data}" />
		<sql:param value="${session_id}" />
		<sql:param value="${transaction_id}" />
	</sql:update>
</c:catch>
					 
 <%-- Test for DB issue and handle - otherwise move on --%>
<c:choose>
	<c:when test="${not empty error}">
		<go:log>[ERROR] Fatal Error Log: ${error}</go:log>
	</c:when>
	<c:otherwise>
		<go:log>Fatal Error Log: ${param}</go:log>
	</c:otherwise>
</c:choose>