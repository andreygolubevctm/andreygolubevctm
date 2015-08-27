<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:if test="${empty numberFieldInputType}">
    <go:log>@@@@@@ TESTING NUMERIC INPUT TYPE @@@@@</go:log>
    <jsp:useBean id="userAgentSniffer" class="com.ctm.services.UserAgentSniffer" />
    <c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />
    <c:set var="numberFieldInputType" scope="request">
        <c:choose>
            <c:when test='${deviceType eq "MOBILE" or deviceType eq "TABLET"}'>tel</c:when>
            <c:otherwise>text</c:otherwise>
        </c:choose>
    </c:set>
</c:if>

<c:out value="${numberFieldInputType}" />