<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" />

<%-- Adding Basic IP blocking as this will be called at a 'server' level, and should not be publically --%>
<c:set var="remoteaddr" value="${ipAddressHandler.getIPAddress(pageContext.request)}" />
<c:choose>
	<c:when test="${ipAddressHandler.isLocalRequest(pageContext.request)}">
<session:core />
<c:set var="success" value="${applicationService.clearCache()}" scope="request"  />
		<p>Application settings cache cleared...</p>
	</c:when>
	<c:otherwise>
		<%  response.sendError(401, "Unauthorized" ); if(true) return; %>
	</c:otherwise>
</c:choose>