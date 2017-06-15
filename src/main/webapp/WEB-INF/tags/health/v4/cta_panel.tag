<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="CTA Panel, shows contact number during centre opening hours or schedule a call outside opening hours"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Get cta-panel call centre open copy --%>
<c:set var="callCentreOpenCopy" scope="request"><content:get key="ctaPanelCallCentreOpenCopy"/></c:set>

<%-- Get cta-panel call centre closed copy --%>
<c:set var="callCentreClosedCopy" scope="request"><content:get key="ctaPanelCallCentreClosedCopy"/></c:set>

<%-- Check and set call centre open status --%>
<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />
<c:set var="verticalId" value="${pageSettings.getVertical().getId()}"/>
<c:set var="callCentreOpen" scope="request">${openingHoursService.isCallCentreOpenNow(verticalId, pageContext.getRequest())}</c:set>
<c:set var="ctaCopy">
    <c:choose>
        <c:when test="${callCentreOpen eq true}">${callCentreOpenCopy}</c:when>
        <c:otherwise>${callCentreClosedCopy}</c:otherwise>
    </c:choose>
</c:set>

<%-- Get call centre number --%>
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>

<div class="cta-panel hidden">
    <span class="copy">
        ${ctaCopy}
    </span>
    <c:if test="${callCentreOpen eq true}">
        <a href="tel:${callCentreNumber}" class="hidden-callcentreclosed call-centre-number">${callCentreNumber}</a>
    </c:if>
    <a href="javascript:;" class="schedule-a-call" data-toggle="dialog" data-content="#view_all_hours_cb" title="Schedule a Call" data-cache="true">
        <c:if test="${callCentreOpen eq true}">or </c:if>Schedule a Call <span class="icon-angle-right"></span>
    </a>
</div>