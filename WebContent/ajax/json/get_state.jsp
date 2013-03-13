<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator" />

<c:set var="postCode">${fn:trim(param.postCode)}</c:set>

<%-- SQL CALL --%>
<sql:query var="result">
	SELECT state FROM `suburb_search` WHERE postCode = ? GROUP BY state ORDER BY state;
	<sql:param value="${postCode}" />
</sql:query>


<%-- Export the JSON Results --%>
<c:choose>
	<c:when test="${(empty result) || (result.rowCount == 0) }">
		[{"count":0}]
	</c:when>
	<c:otherwise>
		[{
			"count":"${result.rowCount}",
			"state":"<c:forEach var="row" varStatus="status" items="${result.rows}"><c:out value='${row.state}' /><c:if test="${!status.last}">, </c:if></c:forEach>"
		}]
	</c:otherwise>
</c:choose>