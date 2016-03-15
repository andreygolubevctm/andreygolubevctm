<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>


<c:if test="${not empty param.travel_policyType}">
    <c:set var="param_tripType">
        <c:out value="${param.travel_policyType}" escapeXml="true"/>
    </c:set>
</c:if>
<c:if test="${not empty param.travel_party}">
    <c:set var="param_party">
        <c:out value="${param.travel_party}" escapeXml="true"/>
    </c:set>
    <div id="partyType" data-type="<c:out value="${param.travel_party}" escapeXml="true"/>"></div>
</c:if>
<go:setData dataVar="data" xpath="travel/policyType" value="${param_tripType}"/>
<go:setData dataVar="data" xpath="travel/party" value="${param_party}"/>

