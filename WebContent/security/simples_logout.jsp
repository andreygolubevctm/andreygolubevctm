<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="GENERIC" />

<% session.invalidate(); %>
<c:redirect url="${pageSettings.getBaseUrl()}simples.jsp" />
