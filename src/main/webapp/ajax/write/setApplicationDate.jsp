<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.write.setApplicationDate')}" />

<c:import var="manifestContent" url="/META-INF/MANIFEST.MF"/>
<c:set var="remoteAddr" value="${pageContext.request.remoteAddr}" />

<c:if test="${ remoteAddr == '127.0.0.1' or remoteAddr == '0.0.0.0' or remoteAddr == '0:0:0:0:0:0:0:1' or fn:startsWith(remoteAddr, '192.168.') or (not empty(param.bucket) and param.bucket == '1') or (not empty(param.preload) and param.preload == '2') }">

	<jsp:useBean id="applicationService" class="com.ctm.services.ApplicationService" scope="page" />

	<c:set var="setResult" value="${applicationService.setApplicationDateOnSession(pageContext.getRequest(), param.applicationDateOverrideValue)}" />

	<c:set var="retrieveDate" value="${applicationService.getApplicationDateIfSet(pageContext.getRequest())}" />
	${logger.debug('APPLICATION DATE CHANGED. {}',log:kv('retrieveDate',retrieveDate ) )}
	${retrieveDate}
</c:if>