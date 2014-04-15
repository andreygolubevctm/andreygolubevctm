<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Adding Basic IP blocking as this will be called at a 'server' level, and should not be publically --%>
<c:choose>
	<c:when test="${fn:startsWith(pageContext.request.remoteAddr,'192.168.') or fn:startsWith(pageContext.request.remoteAddr,'0:0:0:')}">
		<session:core />
		<c:set var="success" value="${applicationService.clearCache(pageContext)}" scope="request" />
		<p>Application settings cache cleared...</p>
	</c:when>
	<c:otherwise>
		<%  response.sendError(401, "Unauthorized" ); if(true) return; %>
	</c:otherwise>
</c:choose>
