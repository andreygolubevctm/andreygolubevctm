<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
    
<sql:setDataSource dataSource="jdbc/test"/>

<c:set var="houseNumber" value="${param.houseNo}" />

<sql:query var="result">
	SELECT unitNo 
	FROM street_number 
 	WHERE streetId = ${param.streetId}
	AND houseNo = "${houseNumber}"
	AND unitNo > 0
	LIMIT 1
</sql:query>
<go:log>Row Count: ${result.rowCount}</go:log>
<c:choose>
	<c:when test="${result.rowCount == 1}">
		<go:log>TRUE</go:log>
		<c:out value="true" />
	</c:when>
	<c:otherwise>
		<go:log>FALSE</go:log>
		<c:out value="false" />
	</c:otherwise>
</c:choose>