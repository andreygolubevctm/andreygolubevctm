<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="moreInfoAffixedHeaderTemplate">
    <div class="container">
        {{ if (!meerkat.modules.healthDualPricing.isDualPricingActive()) { }}
            <div class="col-xs-1">
                <div class="companyLogo {{= info.provider }}"></div>
            </div>
            <div class="col-xs-3">
                <div class="quote-reference-number">Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></div>
                <div class="productNames">{{= info.productTitle }}</div>
            </div>
            <div class="col-xs-3 vertical-divider">
                {{= renderedNormalAffixedHeaderPriceTemplate }}
            </div>
            <div class="col-xs-2 lhcTextAndABD">
                <health_v4:lhcText />
                <health_v4:abd_badge_with_link />
            </div>
            <div class="col-xs-2">
                <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Join Now<span class="icon-arrow-right" /></a>
            </div>
        {{ } else { }}
            <div class="col-xs-2">
                <div class="companyLogo {{= info.provider }}"></div>
            </div>
            <div class="col-xs-3">
                <h3 class="noTopMargin productNames">{{= info.productTitle }}</h3>
            </div>
            <div class="col-xs-3 text-center vertical-divider">
                {{= renderedAffixedHeaderPriceTemplate }}
            </div>
            <div class="col-xs-2 text-center">
                <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Join Now<span class="icon-arrow-right" /></a>
                <div class="quote-reference-number"><h3>Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></h3></div>
            </div>
        {{ } }}
    </div>
</core_v1:js_template>
