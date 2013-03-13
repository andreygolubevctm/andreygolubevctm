<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<c:choose>
	<c:when test="${ sessionScope != null and not empty(sessionScope.isLoggedIn) and sessionScope.isLoggedIn == 'true' and not empty(sessionScope.userDetails) }">
		<c:redirect url="/security/simples_userDetails.jsp" />
	</c:when>
	<c:otherwise>
		<c:set var="pageTitle" value="Log In" />
		<c:set var="welcomeText" value="Enter your details below to log in." />
		<%@ include file="/WEB-INF/security/loginForm.jsp" %>
	</c:otherwise>
</c:choose>
