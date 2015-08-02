<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:core />

<c:if test="${empty authenticatedData}">
	<c:set var="authenticatedData" value="${sessionDataService.getAuthenticatedSessionData(pageContext.getRequest())}" scope="request"  />
</c:if>
