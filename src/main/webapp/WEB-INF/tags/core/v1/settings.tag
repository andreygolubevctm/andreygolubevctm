<%@ tag description="Loading of the Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- BEANS --%>
<jsp:useBean id="ipChkSvc" class="com.ctm.web.core.services.IPCheckService" scope="page" />

<%-- VARIABLES --%>
<c:set var="localIP">
	<c:choose>
		<c:when test="${ipChkSvc.isLocalIPAddress(pageContext.getRequest()) eq true}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>
<c:set var="isPreload">
	<c:choose>
		<c:when test="${not empty param.preload}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>
<c:set var="isGtmInternalUser">
	<c:choose>
		<c:when test="${not empty param.gtmInternaluser}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>

<%-- JS OBJECT --%>
,gtmInternalUser : <c:choose><c:when test="${localIP eq true or isPreload or isGtmInternalUser eq true}">true</c:when><c:otherwise>false</c:otherwise></c:choose>
