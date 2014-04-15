<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:getAuthenticated  />

<sql:setDataSource dataSource="jdbc/ctm"/>
<go:log>Diary Entries for: ${authenticatedData['login/user/uid']}</go:log>

<sql:query var="result">
	SELECT *
	FROM ctm.diary_entries
	WHERE `owner` = ?
	<sql:param value="${authenticatedData.login.user.uid}" />
</sql:query>
[
<%-- JSON --%>
<c:forEach var="row" items="${result.rows}" varStatus="status">
<%--
<go:log>
EVENT: ${row.title}
START TIME = ORIGINAL: ${row.startTime} NEW: '${fn:replace(row.startTime,' 00:00:00.0', '')} to ${fn:replace(row.endTime,' 00:00:00.0', '')}'</go:log>
--%>
	{
		"id": "${row.commsId}",
		"title": "${row.title}",
		"author": "${row.author}",
		"start": "${row.startTime}",
		"end": "${row.endTime}",
		"url": "",	
		"backgroundColor": "#86C65E",
		"textColor":"white",
		"borderColor":"#4E9733",			
		<c:choose>
			<c:when test="${row.allDay == 'Y'}">
		"allDay": true				
			</c:when>
			<c:otherwise>
		"allDay": false
			</c:otherwise>
		</c:choose>
	}<c:if test="${not status.last}">,</c:if>
</c:forEach>
]