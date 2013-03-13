<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<c:set var="pageTitle" value="Login Timeout" />
<c:set var="welcomeText" value="Your login timed out due to inactivity. Please try again." />

<%@ include file="/WEB-INF/security/loginForm.jsp" %>
