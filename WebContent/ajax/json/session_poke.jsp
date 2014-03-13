<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_new:no_cache_header/>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
 
<c:set var="timeStamp"><c:out escapeXml="true" value="${fn:trim(param['ts'])}" /></c:set>

<%-- Session can be set or requested to keep users journey alive --%>
<c:choose>
	<c:when test="${timeStamp < data['session/Poke']}">
		<c:set var="timeStamp" value="${data['session/Poke']}" />
	</c:when>
	<c:otherwise>
		<go:setData dataVar="data" xpath="session/Poke" value="${timeStamp}" />
	</c:otherwise>
</c:choose>
{"result":"true", "timestamp":"${timeStamp}"}