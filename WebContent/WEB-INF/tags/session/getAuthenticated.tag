<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:core />

<c:if test="${empty authenticatedData}">
	<jsp:useBean id="authenticatedData" class="com.disc_au.web.go.Data" scope="request" />
	<c:set var="authenticatedData" value="${sessionDataService.getAuthenticatedSessionData(pageContext)}" scope="request"  />
</c:if>
	