<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<health_v1:dual_pricing_settings />

<!-- Product Summary. Logo, price, LHC etc... -->
<div class="row priceRow productSummary hidden-xs">
    <div class="col-xs-8">
        {{ if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) { }}
            {{= renderedPyrrCampaign }}
        {{ } }}
        <c:if test="${!isDualPriceActive eq true}">
            <div class="companyLogo {{= info.provider }}"></div>
        </c:if>
        <h2 class="noTopMargin productName hidden-xs">{{= info.productTitle }}</h2>
    </div>
    <div class="col-xs-4 text-center printableBrochuresLink">
        <c:if test="${!isDualPriceActive eq true}">
        {{= renderedPriceTemplate }}
        </c:if>
        <a href="javascript:;" class="btn btn-secondary btn-sm btn-block narrowMarginTop getPrintableBrochures">Email myself brochures</a>
        <a href="javascript:;" class="btn btn-cta btn-sm btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online<span class="icon-arrow-right" /></a>
    </div>
    <div class="col-xs-12 about-this-fund-row">
        <a href="javascript:;" class="about-this-fund">About this fund</a>
    </div>
</div>
