<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<settings:setVertical verticalCode="SIMPLES" />

<c:set var="pageTitle" value="Login Timeout" />
<c:set var="welcomeText" value="Your login timed out due to inactivity. Please try again." />

<%@ include file="/WEB-INF/security/loginForm.jsp" %>
