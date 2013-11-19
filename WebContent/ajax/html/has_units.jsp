<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
    
<sql:setDataSource dataSource="jdbc/test"/>

<c:set var="houseNumber" value="${param.houseNo}" />
<c:if test="${empty param.houseNo}">
	<c:set var="houseNumber" value="0" />
</c:if>

<sql:query var="result">
	SELECT unitNo 
	FROM street_number 
	WHERE streetId = ?
	AND houseNo = ?
	AND unitNo > 0
	LIMIT 1
	<sql:param value="${param.streetId}" />
	<sql:param value="${houseNumber}" />
</sql:query>

<sql:query var="resultEmptyUnits">
	SELECT unitNo , dpId
	FROM street_number
	WHERE streetId = ?
	AND houseNo = ?
	AND unitNo = 0
	LIMIT 1
	<sql:param value="${param.streetId}" />
	<sql:param value="${houseNumber}" />
</sql:query>

<c:choose>
	<c:when test="${result.rowCount == 1}">
		<c:set var="hasUnits" value="true" />
	</c:when>
	<c:otherwise>
		<c:set var="hasUnits" value="false" />
	</c:otherwise>
</c:choose>
<c:choose>
	<c:when test="${resultEmptyUnits.rowCount == 1}">
		<c:set var="hasEmptyUnits" value="true" />
		<c:set var="dpId" value="${resultEmptyUnits.rows[0].dpId}" />
	</c:when>
	<c:otherwise>
		<c:set var="hasEmptyUnits" value="false" />
	</c:otherwise>
</c:choose>

{
	"hasUnits" : ${hasUnits} ,
	"hasEmptyUnits" : ${hasUnits},
	"dpId" : "${dpId}"
}