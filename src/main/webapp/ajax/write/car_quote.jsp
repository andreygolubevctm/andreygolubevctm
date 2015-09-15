<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}" />
${logger.debug('Writing Quote Data')}

<%-- Return the transaction Id --%>
<c:out value="${data['current/transactionId']}" />