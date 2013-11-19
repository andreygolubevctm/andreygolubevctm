<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator" />

<c:set var="type">${fn:trim(param.type)}</c:set>
<c:set var="callback">${fn:trim(param.callback)}</c:set>
<c:set var="callback_start"></c:set>
<c:set var="callback_end"></c:set>
<c:if test="${not empty callback}">
	<c:set var="callback_start"></c:set>
	<c:set var="callback_end"></c:set>
</c:if>

<c:choose>
	<c:when test="${empty type}">
		<c:set var="result" value="" />
	</c:when>
	
	<c:otherwise>
		<%-- Grab the SQL for the result --%>
		<sql:query var="result">
			SELECT code, description FROM `test`.`general` WHERE type = ? ORDER BY orderSeq;
			<sql:param value="${type}" />
		</sql:query>		
		
	</c:otherwise>	

</c:choose>

<c:catch>
	<%-- Export the results, even an empty JSON --%>
	<c:choose>
		<c:when test="${(empty result) || (result.rowCount == 0) }">[{"label":"Error display benefits","value":""}]</c:when>
		<%-- Build the JSON data for each row --%>
		<c:otherwise>${callback_start}[ <c:forEach var="row" varStatus="status" items="${result.rows}">{key:"<c:out value='${row.code}' />",value:"<c:out value='${row.description}' />"}<c:if test="${!status.last}">, </c:if></c:forEach> ]${callback_end}</c:otherwise>
	</c:choose>
</c:catch>