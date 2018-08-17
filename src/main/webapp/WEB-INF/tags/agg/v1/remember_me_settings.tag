<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="rememberMeService" class="com.ctm.web.core.rememberme.services.RememberMeService" />

<c:set var="hasRememberMeToken">${rememberMeService.hasRememberMe(pageContext.request, vertical)}</c:set>
<c:set var="hasUserVisitedInLast30Minutes" scope="application">${rememberMeService.hasUserVisitedInLast30Minutes(pageContext.request, vertical)}</c:set>
<c:set var="rememberMeTransactionId" scope="application">${rememberMeService.retrieveTransactionId(pageContext.request, vertical)}</c:set>

<%@ attribute name="vertical" required="true" rtexprvalue="true" description="The vertical this Remember Me is for"%>

<c:set var="isRememberMe" scope="application">
    <c:choose>
        <c:when test="${hasRememberMeToken and
                        (empty pageContext.request.queryString or fn:length(param.action) == 0) and
                        empty param.preload and
                        empty param.skipRemember and
                        pageSettings.getBrandCode() eq 'ctm' and
                        empty authenticatedData.login.user.uid and
                        rememberMeService.hasPersonalInfoAndLoadData(pageContext.request, pageContext.response, vertical)}">
            true
        </c:when>
        <c:otherwise>
            false
        </c:otherwise>
    </c:choose>
</c:set>