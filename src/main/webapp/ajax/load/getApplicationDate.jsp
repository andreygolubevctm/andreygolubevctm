<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" scope="application" />

<c:import var="manifestContent" url="/META-INF/MANIFEST.MF"/>

<c:if test="${ipAddressHandler.isLocalRequest(pageContext.request) or (not empty(param.bucket) and param.bucket == '1') or (not empty(param.preload) and param.preload == '2') }">

	<jsp:useBean id="applicationService" class="com.ctm.web.core.services.ApplicationService" scope="page" />

	<c:set var="retrieveDate" value="${applicationService.getApplicationDateIfSet(pageContext.getRequest())}" />
	${retrieveDate}
</c:if>
