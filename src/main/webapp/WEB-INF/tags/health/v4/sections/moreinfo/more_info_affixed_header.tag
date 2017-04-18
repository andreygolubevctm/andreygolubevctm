<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="moreInfoAffixedHeaderTemplate">
    {{ if (!meerkat.modules.healthDualPricing.isDualPricingActive()) { }}
        {{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}
        {{ obj.showAltPremium = false; obj.renderedPriceTemplate = priceTemplate(obj); }}
        <div class="col-xs-2">
            <div class="companyLogo {{= info.provider }}"></div>
        </div>
        <div class="col-xs-4 text-center">
            <h3 class="noTopMargin productNames">{{= info.productTitle }}</h3>
        </div>
        <div class="col-xs-3 text-center">
            {{= renderedPriceTemplate }}
        </div>
        <div class="col-xs-3 text-center">
            <div class="quote-reference-number"><h3>Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></h3></div>
            <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online<span class="icon-arrow-right" /></a>
        </div>
    {{ } else { }}
        <div class="more-info-left-header-col">
            <div class="row">
                <div class="col-xs-6">
                    <div class="companyLogo {{= info.provider }}"></div>
                </div>
                <div class="col-xs-6 text-center dualPricingAffixedHeader">
                </div>
            </div>
        </div>
        <div class="more-info-right-header-col">
            <div class="row">
                <div class="col-xs-12 text-center">
                    <div class="quote-reference-number"><h3>Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></h3></div>
                    <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online<span class="icon-arrow-right" /></a>
                </div>
            </div>
        </div>



    {{ } }}
</core_v1:js_template>