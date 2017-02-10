<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup variables needed for dual pricing --%>
<health_v1:dual_pricing_settings />

<c:if test="${isDualPriceActive eq true}">
    <div class="row hidden-xs">
        <div class="col-sm-2">
            <div class="companyLogo {{= info.provider }}"></div>
        </div>
        <div class="col-sm-10">
            {{= renderedDualPricing }}
        </div>
    </div>
</c:if>