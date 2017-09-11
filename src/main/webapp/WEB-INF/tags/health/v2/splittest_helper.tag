<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- Set whether to  default optin to slide 1 or force to slide 3 --%>
<c:if test="${empty showOptInOnSlide3}">
    <c:set var="forceOptinOnSlide3"><content:get key="forceOptinOnSlide3"/></c:set>
    <c:set var="showOptInOnSlide3" value="${not empty forceOptinOnSlide3 and forceOptinOnSlide3 eq 'Y'}" scope="session" />
</c:if>


<%-- HLT-3174 AB Test for More Info Layout change --%>

<%-- Apply defaults --%>
<c:set var="moreinfolayout_splittest_default" value="${true}" scope="request" />
<c:set var="moreinfolayout_splittest_variant1" value="${false}" scope="request" />


<%-- Apply split test value --%>
<c:choose>
    <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 23)}">
        <c:set var="moreinfolayout_splittest_variant1" value="${true}" scope="request" />
        <c:set var="moreinfolayout_splittest_default" value="${false}" scope="request" />
    </c:when>
</c:choose>

<%-- End HLT-3174 --%>



<%-- New elastic search for health --%>
<c:set var="useElasticSearch" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 18)}" scope="request" />
<%-- End HLT-2931 --%>

<%-- HLT-3273 && HLT-3433 --%>
<c:set var="isTaxTime"><content:get key="taxTime"/></c:set>
<c:set var="taxTimeSplitTest" value="${isTaxTime eq 'Y' && (splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 30) or splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 31) or splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 32))}" scope="request" />
<%-- END HLT-3273 && HLT-3433  --%>

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

<%-- HLT-4680 Split Test J=5 test --%>
<c:set var="navBarSplitTest" scope="request">
    <c:choose>
        <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 5)}">${true}</c:when>
        <c:otherwise>${false}</c:otherwise>
    </c:choose>
</c:set>