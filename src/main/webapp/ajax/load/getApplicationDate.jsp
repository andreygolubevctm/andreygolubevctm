<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" scope="application" />

<c:import var="manifestContent" url="/META-INF/MANIFEST.MF"/>
<c:set var="remoteAddr" value="${ipAddressHandler.getIPAddress(pageContext.request)}" />

<c:if test="${ remoteAddr == '127.0.0.1' or remoteAddr == '0.0.0.0' or remoteAddr == '0:0:0:0:0:0:0:1' or fn:startsWith(remoteAddr, '192.168.') or fn:startsWith(remoteAddr, '10.4') or (not empty(param.bucket) and param.bucket == '1') or (not empty(param.preload) and param.preload == '2') }">

	<jsp:useBean id="applicationService" class="com.ctm.web.core.services.ApplicationService" scope="page" />

	<c:set var="retrieveDate" value="${applicationService.getApplicationDateIfSet(pageContext.getRequest())}" />
	${retrieveDate}
</c:if>
