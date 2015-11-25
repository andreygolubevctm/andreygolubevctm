<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="simplesUserService" class="com.ctm.web.simples.services.SimplesUserService" scope="page" />

<settings:setVertical verticalCode="SIMPLES" />
<session:getAuthenticated />

<c:set var="simplesUid" value="${authenticatedData['login/user/simplesUid']}" />

<c:set var="outcome" value="${ simplesUserService.logoutUser(simplesUid) }" />



<% session.invalidate(); %>
<c:redirect url="/simples.jsp" />
