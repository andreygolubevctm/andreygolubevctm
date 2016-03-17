<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- Set whether to  default optin to slide 1 or force to slide 3 --%>
<c:if test="${empty showOptInOnSlide3}">
    <c:set var="forceOptinOnSlide3"><content:get key="forceOptinOnSlide3"/></c:set>
    <c:set var="showOptInOnSlide3" value="${not empty forceOptinOnSlide3 and forceOptinOnSlide3 eq 'Y'}" scope="session" />
</c:if>

<c:set var="newBenefitsLayoutSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 13)}" />

<%-- HLT-3028 ABC Test for More Info Buy Button --%>
<c:set var="moreinfo_splittest_default" value="${true}" />
<c:set var="moreinfo_splittest_variation1" value="${false}" />
<c:set var="moreinfo_splittest_variation2" value="${false}" />
<c:set var="moreinfo_splittest_variation3" value="${false}" />
<c:choose>
    <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 15)}">
        <c:set var="moreinfo_splittest_variation1" value="${true}" />
        <c:set var="moreinfo_splittest_default" value="${false}" />
    </c:when>
    <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 16)}">
        <c:set var="moreinfo_splittest_variation2" value="${true}" />
        <c:set var="moreinfo_splittest_default" value="${false}" />
    </c:when>
    <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 17)}">
        <c:set var="moreinfo_splittest_variation3" value="${true}" />
        <c:set var="moreinfo_splittest_default" value="${false}" />
    </c:when>
</c:choose>