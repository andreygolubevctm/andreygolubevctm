<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Set whether to  default optin to slide 1 or force to slide 3 --%>
<c:if test="${empty showOptInOnSlide3}">
    <c:set var="forceOptinOnSlide3"><content:get key="forceOptinOnSlide3"/></c:set>
    <c:set var="showOptInOnSlide3" value="${not empty forceOptinOnSlide3 and forceOptinOnSlide3 eq 'Y'}" scope="session" />
</c:if>

<%-- HLT-3540 - Competition --%>
<c:set var="worryFreePromo35" value="" scope="request" />
<c:set var="worryFreePromo36" value="" scope="request" />
<c:set var="worryFreePromo" scope="request"><content:get key="worryFreePromo" /></c:set>
<c:if test="${not empty worryFreePromo and worryFreePromo eq 35}">
    <c:choose>
        <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 35)}">
            <c:set var="worryFreePromo35" value="${true}" scope="request" />
            <%-- For the comp we need to ensure this is never true --%>
            <c:set var="showOptInOnSlide3" value="${false}" scope="session" />
        </c:when>
        <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 36)}">
            <c:set var="worryFreePromo36" value="${true}" scope="request" />
            <%-- For the comp we need to ensure this is never true --%>
            <c:set var="showOptInOnSlide3" value="${false}" scope="session" />
        </c:when>
        <c:otherwise>
            <%-- ignore and proceed with defaults as set above --%>
        </c:otherwise>
    </c:choose>

</c:if>
<%-- END HLT-3540 - Competition --%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- HLT-4069 Split Test J=2 test --%>
<c:set var="benefitsSwitchSplitTest" scope="request">
    <c:choose>
        <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}">${true}</c:when>
        <c:otherwise>${false}</c:otherwise>
    </c:choose>
</c:set>

<%-- HLT-4566 Split Test J=3 test --%>
<c:set var="resultsSplitTest" scope="request">
    <c:choose>
        <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 3)}">${true}</c:when>
        <c:otherwise>${false}</c:otherwise>
    </c:choose>
</c:set>