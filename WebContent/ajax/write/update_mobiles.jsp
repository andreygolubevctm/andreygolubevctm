<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="sourceDB" value = "aggregator_staging" />

<sql:setDataSource dataSource="jdbc/aggregator"/>
 
<sql:query var="getDetails">
	SELECT td.transactionId, td.sequenceNo, td.textValue 
	FROM ${sourceDB}.transaction_details AS td 
	RIGHT JOIN ${sourceDB}.transaction_header AS th ON td.transactionId = th.TransactionId
	WHERE th.ProductType LIKE 'health' AND 
		(td.xpath LIKE '%contactNumber' OR td.xpath LIKE '%mobile%')
		AND (td.textValue LIKE ('%(%') OR td.textValue LIKE ('% %') OR td.textValue LIKE ('%-%'));
</sql:query>

<c:if test="${not empty getDetails and getDetails.rowCount > 0}">
	<c:forEach var="row" items="${getDetails.rows}" varStatus="status">
		<c:set var="newVal" value="${fn:replace(row.textValue, '(', '')}" />
		<c:set var="newVal" value="${fn:replace(newVal, ')', '')}" />
		<c:set var="newVal" value="${fn:replace(newVal, '-', '')}" />
		<c:set var="newVal" value="${fn:replace(newVal, ' ', '')}" />
		<sql:update var="getDetails">
			UPDATE ${sourceDB}.transaction_details
			SET textValue = '${newVal}'
			WHERE transactionId = '${row.transactionId}' AND sequenceNo = '${row.sequenceNo}';
		</sql:update>
	</c:forEach>
</c:if>