<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- MANDATORY CONTACT FIELDS --%>
<c:set var="mandatoryContactFieldsSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}" />

<%-- ADDRESS FORM --%>
<c:set var="addressFormSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 32)}" />

<%-- REGO LOOKUP --%>
<jsp:useBean id="regoLookupService" class="com.ctm.web.car.services.RegoLookupService" />
<c:set var="showRegoLookupContent" scope="request">
    <c:choose>
        <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 13)}">
            <c:choose>
                <c:when test="${regoLookupService.serviceAvailableSilent(pageContext.getRequest())}">${true}</c:when>
                <c:otherwise>${false}</c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>${false}</c:otherwise>
    </c:choose>
</c:set>