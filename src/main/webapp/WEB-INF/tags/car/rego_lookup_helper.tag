<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Rego Lookup Query Param"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="quote_rego_lookup"><c:out value="${param.quote_rego_lookup}" escapeXml="true" /></c:set>
<c:set var="isRegoLookup" scope="request" value="${false}" />
<c:if test="${not empty quote_rego_lookup}">
    <c:set var="isRegoLookup" scope="request" value="${true}" />
</c:if>
