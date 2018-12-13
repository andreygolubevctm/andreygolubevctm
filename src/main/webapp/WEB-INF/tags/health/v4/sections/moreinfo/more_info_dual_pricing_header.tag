<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup variables needed for dual pricing --%>
<health_v1:dual_pricing_settings />

<c:if test="${isDualPriceActive eq true}">
    {{= renderedDualPricing }}
</c:if>
