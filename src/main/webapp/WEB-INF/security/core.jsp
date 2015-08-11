<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:getAuthenticated  />

<c:choose>
	<c:when test="${ not empty(pageContext.request.remoteUser) and not empty(sessionScope) and empty(sessionScope.isLoggedIn) }">
		<%@ page import="com.disc_au.web.LDAPDetails, java.util.Hashtable" %>
<%
		LDAPDetails userObj = new LDAPDetails(request.getRemoteUser());
		Hashtable<String, String> userDetails = userObj.getDetails();

		if ( userDetails != null ) {
			session.setAttribute("userDetails", userDetails);
			session.setAttribute("isLoggedIn", true);
		}
%>
	</c:when>
	<c:when test="${ empty(pageContext.request.remoteUser) and ( empty(sessionScope) or not empty(sessionScope.isLoggedIn) ) }">
		<c:remove scope="session" var="isLoggedIn" />
		<c:remove scope="session" var="userDetails" />

		<c:set var="loginUrlString" value="${pageContext.servletContext.contextPath}/security/simples_login.jsp" />
		<c:set var="logoutUrlString" value="${pageContext.servletContext.contextPath}/security/simples_logout.jsp" />
		<c:if test="${ pageContext.request.requestURI != loginUrlString and pageContext.request.requestURI != logoutUrlString }">
			<c:redirect url="${pageSettings.getBaseUrl()}security/simples_logout.jsp" />
		</c:if>
	</c:when>
</c:choose>

