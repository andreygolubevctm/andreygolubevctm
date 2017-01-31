<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />


<!-- Product Summary. Logo, price, LHC etc... -->
<div class="row priceRow productSummary hidden-xs">
    <div class="col-xs-8">
        <c:if test="${!healthAlternatePricingActive eq true}">
        <div class="companyLogo {{= info.provider }}"></div>
        </c:if>
        <h2 class="noTopMargin productName hidden-xs">{{= info.productTitle }}</h2>
    </div>
    <div class="col-xs-4 text-center printableBrochuresLink">
        <c:if test="${!healthAlternatePricingActive eq true}">
        {{= renderedPriceTemplate }}
        </c:if>
        <a href="javascript:;" class="getPrintableBrochures">Get printable brochures in your email inbox</a>
    </div>
</div>