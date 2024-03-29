<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Using numeric inputs for mobile and tablet so they get the proper keyboards."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:if test="${empty numberFieldInputType}">
    <jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
    <c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />
    <c:set var="numberFieldInputType" scope="request">
        <c:choose>
            <c:when test='${deviceType eq "MOBILE" or deviceType eq "TABLET"}'>tel</c:when>
            <c:otherwise>text</c:otherwise>
        </c:choose>
    </c:set>
</c:if>

<c:out value="${numberFieldInputType}" />