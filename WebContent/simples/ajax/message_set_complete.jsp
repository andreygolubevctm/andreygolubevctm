<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="simplesService" class="com.ctm.services.simples.SimplesMessageService" scope="page" />

<settings:setVertical verticalCode="SIMPLES" />
<session:getAuthenticated />

<c:set var="simplesUid" value="${authenticatedData['login/user/simplesUid']}" />
<c:set var="messageId" value="${param.messageId}" />
<c:set var="reasonStatusId" value="${param.reasonStatusId}" />

<c:out value="${ simplesService.setMessageToComplete(pageContext.getRequest(), simplesUid, messageId, reasonStatusId) }" escapeXml="false" />
