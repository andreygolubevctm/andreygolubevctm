<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="transactionid">
	<c:if test="${not empty param.transactionid}">${param.transactionid}</c:if>
</c:set>

<c:if test="${not empty transactionid}">	
	<sql:setDataSource dataSource="jdbc/aggregator"/>			    
	<c:catch var="error">
		<sql:query var="getCode">
			SELECT textValue 
			FROM aggregator.transaction_details 
			WHERE transactionId = '${transactionid}' AND 
				  xpath = 'health/confirmationEmailCode';
		</sql:query>
	</c:catch>
</c:if>

<c:set var="confirmationCode">
	<results>
		<confirmationCode>
	<c:choose>
		<c:when test="${not empty getCode and getCode.rowCount > 0}">${getCode.rows[0].textValue}</c:when>
		<c:otherwise>${0}</c:otherwise>
	</c:choose>
		</confirmationCode>
	</results>
</c:set>

<%-- Return the results as json --%>
${confirmationCode}