<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.write.register_fatal_error')}" />

<core_v2:no_cache_header/>

<c:set var="page"><c:out value="${param.page}" escapeXml="true" /></c:set>
<c:set var="message"><c:out value="${param.message}" escapeXml="true" /></c:set>
<c:set var="description"><c:out value="${param.description}" escapeXml="true" /></c:set>
<c:set var="failedData"><c:out value="${param.data}" escapeXml="true" /></c:set>
<c:set var="isFatal"><c:out value="${param.fatal}" escapeXml="true" /></c:set>

<c:choose>
	<c:when test="${not empty param.transactionId}">
		<session:get settings="true" />
	</c:when>
	<c:otherwise>
		<settings:setVertical verticalCode="GENERIC" />
		<jsp:useBean id="data" class="com.ctm.web.core.web.go.Data" scope="request" />
	</c:otherwise>
</c:choose>

<%-- Add log entry --%>
<c:catch var="error">
	<error:fatal_error
		page="${page}"
		message="${message}"
		description="${description}"
		failedData="${failedData}"
		fatal="${isFatal}"
		transactionId="${transactionId}"
	/>
</c:catch>

<%-- Test for DB issue and handle - otherwise move on --%>
<c:choose>
	<c:when test="${not empty error}">
		${logger.error('Fatal Error Log failed. {},{}' ,log:kv('page', page),log:kv('message', message), error)}
	</c:when>
	<c:otherwise>
		<%-- Important keep this as debug as there may be credit card details in the params--%>
		${logger.debug('Fatal Error Log complete. {}' , log:kv('param',param))}
	</c:otherwise>
</c:choose>