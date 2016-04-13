<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- Set whether to  default optin to slide 1 or force to slide 3 --%>
<c:if test="${empty showOptInOnSlide3}">
    <c:set var="forceOptinOnSlide3"><content:get key="forceOptinOnSlide3"/></c:set>
    <c:set var="showOptInOnSlide3" value="${not empty forceOptinOnSlide3 and forceOptinOnSlide3 eq 'Y'}" scope="session" />
</c:if>

<%-- HLT-3028 ABC Test for More Info Buy Button --%>

<%-- Apply defaults --%>
<c:set var="moreinfo_splittest_default" value="${true}" scope="request" />
<c:set var="moreinfo_splittest_variant1" value="${false}" scope="request" />
<c:set var="moreinfo_splittest_variant2" value="${false}" scope="request" />
<c:set var="moreinfo_splittest_variant3" value="${false}" scope="request" />

<%-- Check for override in content_control --%>
<c:set var="buttonOverride"><content:get key="forceButtonVariant" /></c:set>

<%-- Apply override or apply split test value --%>
<c:choose>
    <c:when test="${(not empty buttonOverride and buttonOverride eq '1') or splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 22)}">
        <c:set var="moreinfo_splittest_variant1" value="${true}" scope="request" />
        <c:set var="moreinfo_splittest_default" value="${false}" scope="request" />
    </c:when>
    <c:when test="${(not empty buttonOverride and buttonOverride eq '2') or splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 21)}">
        <c:set var="moreinfo_splittest_variant2" value="${true}" scope="request" />
        <c:set var="moreinfo_splittest_default" value="${false}" scope="request" />
    </c:when>
    <c:when test="${(not empty buttonOverride and buttonOverride eq '3') or splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 20)}">
        <c:set var="moreinfo_splittest_variant3" value="${true}" scope="request" />
        <c:set var="moreinfo_splittest_default" value="${false}" scope="request" />
    </c:when>
</c:choose>

<%-- End HLT-3028 --%>

<%-- New elastic search for health --%>
<c:set var="useElasticSearch" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 18)}" />
<%-- End HLT-2931 --%>
