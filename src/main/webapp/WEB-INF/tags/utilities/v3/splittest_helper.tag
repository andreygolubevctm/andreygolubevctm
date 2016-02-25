<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Split test Code"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<c:set var="splitTestEnabled"  scope="session">
    <content:get key="utilitiesRedesign" />
</c:set>
<%-- Set whether to default optin to slide 2 or force to slide 1 --%>
<c:set var="optinOnSlide1" scope="session"><content:get key="optinOnSlide1"/></c:set>
<c:set var="showOptInOnSlide1" scope="session">
    <c:choose>
        <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 42)}">${true}</c:when>
        <c:when test="${not splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 42) and optinOnSlide1 == 'Y'}">${true}</c:when>
        <c:otherwise>${false}</c:otherwise>
    </c:choose>
</c:set>

