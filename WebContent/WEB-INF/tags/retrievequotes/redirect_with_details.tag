<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Redirects back to unsubscribe.jsp with details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<go:setData dataVar="authenticatedData" xpath="userData/authentication/validCredentials" value="${userData.validCredentials}"/>
<go:setData dataVar="authenticatedData" xpath="userData/authentication/emailAddress" value="${userData.emailAddress}"/>
<go:setData dataVar="authenticatedData" xpath="userData/emailAddress" value="${userData.emailAddress}"/>
<c:if test="${not empty userData && userData.validCredentials}">
    <c:redirect url="${pageSettings.getBaseUrl()}retrieve_quotes.jsp"/>
</c:if>