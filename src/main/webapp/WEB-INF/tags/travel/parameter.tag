<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:if test="${not empty param.travel_policyType}">
    <c:set var="param_tripType">
        <c:out value="${param.travel_policyType}" escapeXml="true"/>
    </c:set>
</c:if>
<go:setData dataVar="data" xpath="travel/policyType" value="${param_tripType}"/>