<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<settings:setVertical verticalCode="SIMPLES" />

<c:choose>
	<c:when test="${ sessionScope != null and not empty(sessionScope.isLoggedIn) and sessionScope.isLoggedIn == 'true' and not empty(sessionScope.userDetails) }">
		<c:redirect url="${pageSettings.getBaseUrl()}security/simples_userDetails.jsp" />
	</c:when>
	<c:otherwise>
		<c:set var="pageTitle" value="Log In" />
		<c:set var="welcomeText" value="Enter your details to log in." />
		<%@ include file="/WEB-INF/security/loginForm.jsp" %>
	</c:otherwise>
</c:choose>
