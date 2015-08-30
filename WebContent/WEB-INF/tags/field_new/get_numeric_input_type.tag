<%@ tag import="org.slf4j.LoggerFactory" %>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<% pageContext.setAttribute("logger" , LoggerFactory.getLogger("field_new\\get_numeric_type.tag"));%>

<c:if test="${empty numberFieldInputType}">
    ${logger.debug('TESTING NUMERIC INPUT TYPE')}
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