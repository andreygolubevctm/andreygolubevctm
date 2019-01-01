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
            <div class="premium-rising-tag visible-lg"><span class="text-bold">Premiums Rise</span> from April 1st <a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a></div>
        {{ } }}
        <div class="results-header-inner-container">
            <div class="productSummary vertical results{{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }} hasDualPricing{{ } }}">
                {{ var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template")); var logoHtml = logoTemplate(obj); }}
                {{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}
                {{ obj._selectedFrequency = Results.getFrequency(); obj.showAltPremium = false; }}

                <div class="hide-on-affix logo-full-width">{{= logoHtml }}</div>

                <div class="open-more-info more-info-showapply" data-productId='{{= obj.productId }}' data-available='{{= obj.available }}'>
                    {{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }}
                        <div class="dual-pricing-before-after-text">Now</div>
                    {{ } }}
                    {{= priceTemplate(obj) }}
                </div>

                {{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }}
                    {{= meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false, 'results') }}
                {{ } }}
            </div>

            {{ if (obj.hasOwnProperty('premium')) { }}
                {{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
                {{ var healthResultsTemplate = meerkat.modules.healthResultsTemplate; }}
                {{ var discountText = healthResultsTemplate.getDiscountText(obj); }}
                {{ var result = healthResultsTemplate.getPricePremium(obj._selectedFrequency, availablePremiums, obj.mode); }}
                {{ var discountPercentage = healthResultsTemplate.getDiscountPercentage(obj.info.FundCode, result); }}

                {{ if (!obj.hasOwnProperty('priceBreakdown') || (obj.hasOwnProperty('priceBreakdown') && !obj.priceBreakdown)) { }}
                    <div class="lhcText hide-on-affix">
                        <span>
                            {{= result.lhcFreePriceMode ? result.textLhcFreePricing : result.textPricing }}
                        </span>
                    </div>
                {{ } else { }}
                    {{= meerkat.modules.healthPriceBreakdown.renderTemplate(availablePremiums, result.frequency, true) }}
                {{ } }}
            {{ } }}


            <c:set var="onlineHealthReformMessaging" scope="request"><content:get key="onlineHealthReformMessaging" /></c:set>
            
            <c:choose>
            <c:when test="${onlineHealthReformMessaging eq 'Y'}">
                {{ var classification = meerkat.modules.healthResultsTemplate.getClassification(obj); }}
                <div class="results-header-classification">
                    <div class="results-header-classification-icon {{= classification.icon}}" />
                </div>
            </c:when>
            </c:choose>

            <div class="clearfix show-on-affix"></div>
            <a class="btn btn-cta btn-block btn-more-info more-info-showapply hide-on-affix" href="javascript:;" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>
                <div class="more-info-text">Review product and join <span class="icon icon-angle-right"></span></div>
            </a>

            <c:if test="${not empty resultsBrochuresSplitTest and resultsBrochuresSplitTest eq true}">
                <a href="javascript:;" class="btn btn-secondary getPrintableBrochures" data-productId="{{= productId }}">Email <span class="hidden-xs">myself </span>brochures</a>
            </c:if>


            {{ if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) { }}
                {{= meerkat.modules.healthPyrrCampaign.renderTemplate('', obj, true, false, 'results') }}
            {{ } }}

        </div>
    </div>
</div>
