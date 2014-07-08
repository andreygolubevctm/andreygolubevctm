<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="simplesService" class="com.ctm.services.SimplesService" scope="page" />

<settings:setVertical verticalCode="SIMPLES" />
<session:getAuthenticated />

<c:set var="simplesUid" value="${authenticatedData['login/user/simplesUid']}" />

<c:set var="outcome" value="${ simplesService.logoutUser(simplesUid) }" />



<% session.invalidate(); %>
<c:redirect url="${pageSettings.getBaseUrl()}simples.jsp" />
