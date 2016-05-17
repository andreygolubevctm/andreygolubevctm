<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="simplesService" class="com.ctm.web.simples.services.SimplesMessageService" scope="page" />

<settings:setVertical verticalCode="SIMPLES" />
<session:getAuthenticated />

<c:set var="simplesUid" value="${authenticatedData['login/user/simplesUid']}" />
<c:set var="messageId" value="${param.messageId}" />

<c:choose>
    <c:when test="${pageSettings.getSetting('inInEnabled')}">
        {}
    </c:when>
    <c:otherwise>
        <c:out value="${ simplesService.setMessageToInProgress(simplesUid, messageId) }" escapeXml="false" />
    </c:otherwise>
</c:choose>
