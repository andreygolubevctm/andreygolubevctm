<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="moreInfoAffixedHeaderTemplate">
    <div class="container">
        {{ if (!meerkat.modules.healthDualPricing.validateAndGetDualPricingDate(obj)) { }}
            <div class="col logo-col">
                <div class="companyLogo {{= info.provider }}"></div>
            </div>
            <div class="col">
                <div class="quote-reference-number">Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></div>
                <div class="productNames">{{= info.productTitle }}</div>
            </div>
            <div class="col vertical-divider">
                {{= renderedAffixedHeaderSinglePriceTemplate }}
            </div>
            <div class="col hidden-lg hidden-md">
                <div class="vertical-center-items vertical-center-items-gap">
                    <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Join Now<span class="icon-arrow-right" /></a>
                    <div class="lhcTextAndABD">
                        <health_v4:abd_badge_with_link />
                        <health_v4:lhcText />
                    </div>
                </div>
            </div>
            <div class="col hidden-sm">
                <health_v4:abd_badge_with_link />
                <health_v4:lhcText />
            </div>
            <div class="col hidden-sm">
                <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Join Now<span class="icon-arrow-right" /></a>
            </div>
        {{ } else { }}
            <div class="col hidden-sm">
                <div class="companyLogo {{= info.provider }}"></div>
            </div>
            <div class="col hidden-sm">
                <div class="quote-reference-number">Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></div>
                <div class="productNames">{{= info.productTitle }}</div>
            </div>
            <div class="col hidden-lg hidden-md center-text-align">
                <div class="companyLogo {{= info.provider }}"></div>
                <div class="quote-reference-number">Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></div>
                <div class="productNames">{{= info.productTitle }}</div>
            </div>
            <div class="col vertical-divider">
                {{= renderedAffixedHeaderDualPriceTemplate }}
            </div>
            <div class="col hidden-lg hidden-md">
                <div class="vertical-center-items vertical-center-items-gap">
                    <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Join Now<span class="icon-arrow-right" /></a>
                    <div class="lhcTextAndABD">
                        <health_v4:abd_badge_with_link />
                        <health_v4:lhcText />
                    </div>
                </div>
            </div>
            <div class="col hidden-sm">
                <health_v4:abd_badge_with_link />
                <health_v4:lhcText />
            </div>
            <div class="col hidden-sm">
                <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Join Now<span class="icon-arrow-right" /></a>
            </div>
        {{ } }}
    </div>
</core_v1:js_template>
