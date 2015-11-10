<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="simplesService" class="com.ctm.web.simples.services.SimplesMessageService" scope="page" />

<settings:setVertical verticalCode="SIMPLES" />
<session:getAuthenticated />

<c:set var="simplesUid" value="${authenticatedData['login/user/simplesUid']}" />
<c:set var="messageId" value="${param.messageId}" />
<c:set var="statusId" value="${param.statusId}" />
<c:set var="reasonStatusId" value="${param.reasonStatusId}" />
<c:set var="postponeDate" value="${param.postponeDate}" />
<c:set var="postponeTime" value="${param.postponeTime}" />
<c:set var="postponeAMPM" value="${param.postponeAMPM}" />
<c:set var="comment" value="${param.comment}" />
<c:set var="assignToUser" value="${param.assignToUser}" />

<c:out value="${ simplesService.postponeMessage(simplesUid, messageId, statusId, reasonStatusId, postponeDate, postponeTime, postponeAMPM, comment, assignToUser) }" escapeXml="false" />
