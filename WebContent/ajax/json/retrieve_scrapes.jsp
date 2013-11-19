<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="group">${fn:trim(param.group)}</c:set>

<sql:setDataSource dataSource="jdbc/ctm"/>

<sql:query var="result">
	SELECT *
	FROM `ctm`.`scrapes`
	WHERE `group` = ?
	<sql:param value="${group}" />
</sql:query>

<c:catch>
	<c:choose>
		<c:when test="${result.rowCount > 0}">{"results":{"success":true,"data":[<c:forEach var="row" items="${result.rows}" varStatus="status">{"id":"${row.id}","group":"${row.group}","url":"${row.url}","path":"${row.path}","html":"${row.html}"}<c:if test="${not status.last}">,</c:if></c:forEach>]}}</c:when>
		<c:otherwise>{"results":{"success":false,"data":[]}}</c:otherwise>
	</c:choose>
</c:catch>