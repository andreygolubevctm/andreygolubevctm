<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.write.setApplicationDate')}" />

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" scope="application" />

<c:import var="manifestContent" url="/META-INF/MANIFEST.MF"/>
<c:set var="remoteAddr" value="${ipAddressHandler.getIPAddress(pageContext.request)}" />

<c:if test="${environmentService.getEnvironmentAsString() == 'NXS' or ipAddressHandler.isLocalRequest(pageContext.request) or (not empty(param.bucket) and param.bucket == '1') or (not empty(param.preload) and param.preload == '2') }">

	<jsp:useBean id="applicationService" class="com.ctm.web.core.services.ApplicationService" scope="page" />

	<c:set var="setResult" value="${applicationService.setApplicationDateOnSession(pageContext.getRequest(), param.applicationDateOverrideValue)}" />

	<c:set var="retrieveDate" value="${applicationService.getApplicationDateIfSet(pageContext.getRequest())}" />
	${logger.debug('APPLICATION DATE CHANGED. {}',log:kv('retrieveDate',retrieveDate ) )}
{"activeApplicationDate":"${retrieveDate}"}
</c:if>