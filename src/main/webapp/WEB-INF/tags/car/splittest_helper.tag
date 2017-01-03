<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- CAR-1294 Split Test J=8 test --%>
<c:set var="moreInfoSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 8)}" />

<c:set var="tempSkipNewCoverTypeCarJourney"><content:get key="skipNewCoverTypeCarJourney" /></c:set>

<c:set var="skipNewCoverTypeCarJourney" scope="request">
    <c:choose>
        <c:when test="${not empty tempSkipNewCoverTypeCarJourney and tempSkipNewCoverTypeCarJourney eq 'Y'}">${true}</c:when>
        <c:otherwise>${false}</c:otherwise>
    </c:choose>
</c:set>