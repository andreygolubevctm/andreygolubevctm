<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup variables needed for dual pricing --%>
<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />

<c:if test="${healthAlternatePricingActive eq true}">
    <div class="row">
        <div class="col-sm-4">
            <div class="companyLogo {{= info.provider }}"></div>
        </div>
        <div class="col-sm-8">
            {{= renderedDualPricing }}
        </div>
    </div>
</c:if>