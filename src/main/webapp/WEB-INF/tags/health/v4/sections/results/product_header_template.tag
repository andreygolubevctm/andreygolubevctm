<%@ tag description="The Health Product Header template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="result">
    <div class="resultInsert">
        <div class="result-header-utility-bar">
            <div class="hide-on-affix filter-component display-on-hover small remove-result hidden-xs hidden-sm hidden-md" data-productId="{{= obj.productId }}">
                <a href="javascript:;" title="Hide this product" <field_v1:analytics_attr analVal="remove {{= obj.info.provider }}" quoteChar="\"" />>Hide product</a>
            </div>
            <div class="hide-on-affix filter-component small pin-result pin-result-label hidden-xs hidden-sm hidden-md" data-productId="{{= obj.productId }}">
                <a href="javascript:;" title="Pin this result" <field_v1:analytics_attr analVal="pin {{= obj.info.provider }}" quoteChar="\"" />>Pin as favourite</a>
            </div>
            <div class="hide-on-affix filter-component small pin-result pin-result-icon hidden-xs hidden-sm hidden-md" data-productId="{{= obj.productId }}">
                <span class="icon icon-pin" title="Pin this result" <field_v1:analytics_attr analVal="pin {{= obj.info.provider }}" quoteChar="\"" />></span>
            </div>
        </div>
        {{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }}
            <div class="result-premium-rising-tag visible-lg"><span class="text-bold">Premiums Rise</span> from April 1st <a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a></div>
        {{ } }}
        <div class="results-header-inner-container">
            <div class="productSummary vertical results{{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }} hasDualPricing{{ } }}">
                {{ var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template")); var logoHtml = logoTemplate(obj); }}
                {{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}
                {{ obj._selectedFrequency = Results.getFrequency(); obj.showAltPremium = false; }}
                <div class="open-more-info more-info-showapply" data-productId='{{= obj.productId }}' data-available='{{= obj.available }}'>
                    {{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }}
                        <div class="dual-pricing-before-after-text"><span class="text-bold">Before</span> April 1st</div>
                    {{ } }}
                    {{= priceTemplate(obj) }}
                </div>

                {{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }}
                    <div class="result-premium-rising-tag hidden-lg"><span class="text-bold">Premiums Rise</span> from April 1st <a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a></div>
                    <div class="dual-pricing-before-after-text"><span class="text-bold">After</span> April 1st</div>
                    {{= meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false, 'results') }}
                {{ } }}

                <div class="hide-on-affix">{{= logoHtml }}</div>
            </div>
            <div class="clearfix show-on-affix"></div>
            <a class="btn btn-cta btn-block btn-more-info more-info-showapply hide-on-affix" href="javascript:;" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>
                <div class="more-info-text">View Product <span class="icon icon-angle-right"></span></div>
            </a>
            {{ if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) { }}
                {{= meerkat.modules.healthPyrrCampaign.renderTemplate('', obj, true, false, 'results') }}
            {{ } }}

        </div>
    </div>
</div>
