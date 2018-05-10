<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" />

<%-- Adding Basic IP blocking as this will be called at a 'server' level, and should not be publically --%>
<c:set var="remoteaddr" value="${ipAddressHandler.getIPAddress(pageContext.request)}" />
<c:choose>
	<c:when test="${ipAddressHandler.isLocalRequest(pageContext.request)}">

		<% Thread.sleep(75000); %>
		<p>Slept for 75000</p>

	</c:when>
	<c:otherwise>
		<% response.sendError(401, "Unauthorized"); %>
	</c:otherwise>
</c:choose>