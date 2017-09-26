<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="rememberMeService" class="com.ctm.web.core.rememberme.services.RememberMeService" />

<%@ attribute name="vertical" required="true" rtexprvalue="true" description="The vertical this Remember Me is for"%>

<c:set var="isRememberMe" scope="application">
    <c:choose>
        <c:when test="${rememberMeService.hasRememberMe(pageContext.request, vertical) and
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