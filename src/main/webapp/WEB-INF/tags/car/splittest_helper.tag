<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- SINGLE OPTIN TEST - 1 & 2 default and 3 is the test --%>
<c:set var="singleOptinSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 3)}" />

<%-- CAR-1206 Split Test J=4 test --%>
<c:set var="regoLookupSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 4)}" />
<c:if test="${regoLookupSplitTest eq true}">
    <c:set var="quote_vehicle_searchRego"><c:out value="${param.quote_vehicle_searchRego}" escapeXml="true" /></c:set>
    <c:set var="quote_vehicle_searchState"><c:out value="${param.quote_vehicle_searchState}" escapeXml="true" /></c:set>
    <c:if test="${not empty param.quote_vehicle_searchRego}">
        <go:setData dataVar="data" value="${quote_vehicle_searchRego}" xpath="quote/vehicle/searchRego" />

    </c:if>
    <c:if test="${not empty param.quote_vehicle_searchState}">
        <go:setData dataVar="data" value="${quote_vehicle_searchState}" xpath="quote/vehicle/searchState" />
    </c:if>
</c:if>