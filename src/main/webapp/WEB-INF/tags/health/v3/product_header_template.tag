<%@ tag description="The Health Product Header template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<health_v1:dual_pricing_settings />
<health_v1:pyrr_campaign_settings />

{{ var hasCustomHeaderContent = custom.info && custom.info.content && custom.info.content.results && custom.info.content.results.header; }}

<div class="result">
    <div class="resultInsert">
        {{ if (!_.isEmpty(obj.promo) && !_.isEmpty(obj.promo.discountText)) { }}
        <div class="discountPanel">
            <span class="text">Discount<br />Available</span>
        </div>
        {{ } }}
        <div class="result-header-utility-bar">
            {{ if( info.restrictedFund === 'Y' ) { }}
            <div class="restrictedFund" data-title="This is a Restricted Fund" data-toggle="popover" data-adjust-y="5" data-trigger="mouseenter click" data-my="top center"
                 data-at="bottom center" data-content="#restrictedFundText" data-class="restrictedTooltips">Restricted Fund (?)
            </div>
            {{ } else if( hasCustomHeaderContent ) { }}
            <div class="customHeaderContent" data-toggle="popover" data-adjust-y="5" data-trigger="mouseenter click" data-my="top center"
                 data-at="bottom center" data-content="{{= custom.info.content.results.header.text}}" data-class="resultHeaderTooltips">{{= custom.info.content.results.header.label}} (?)
            </div>
            {{ } else { }}
            <div class="utility-bar-blank">&nbsp;</div>
            {{ } }}
            <div class="filter-component remove-result hidden-xs {{= hasCustomHeaderContent ? 'hasCustomHeaderContent' : ''}}" data-productId="{{= obj.productId }}">
                <span class="icon icon-cross" title="Remove this product" <field_v1:analytics_attr analVal="remove {{= obj.info.provider }}" quoteChar="\"" />></span>
            </div>
        </div>
        {{ var comingSoonClass = ''; }}
        {{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }}
            {{ if (!_.isUndefined(obj.altPremium[Results.getFrequency()])) { }}
                {{ var productPremium = obj.altPremium[Results.getFrequency()] }}
                {{ comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon' }}
            {{ } }}
        {{ } }}
        <div class="results-header-inner-container {{= comingSoonClass }}">
            <div class="productSummary vertical results <c:if test="${isDualPriceActive eq true}">hasDualPricing</c:if>">
                <%-- If dual pricing is enabled, update the template --%>
                {{ var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template")); }}
                {{= logoTemplate(obj) }}

                {{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }}
                    {{= meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false, 'results') }}

                {{ } else if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) { }}
                    {{= meerkat.modules.healthPyrrCampaign.renderTemplate('', obj, true, false, 'results') }}
                {{ } else { }}
                    {{ var productTitleTemplate = meerkat.modules.templateCache.getTemplate($("#product-title-template")); }}
                    {{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}
                    {{ obj._selectedFrequency = Results.getFrequency(); obj.showAltPremium = false; }}
                    {{= productTitleTemplate(obj) }}
                    {{= priceTemplate(obj) }}
                {{ } }}
            </div>

            <a class="btn btn-cta btn-block btn-more-info more-info-showapply" href="javascript:;" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>
                <div class="more-info-text">View Product<span class="icon icon-arrow-right"></span></div>
            </a>
            {{ var brochureTemplate = meerkat.modules.templateCache.getTemplate($("#brochure-download-template")); }}
            {{= brochureTemplate(obj) }}

            {{ var result = meerkat.modules.healthResultsTemplate.getSpecialOffer(obj); }}

            <fieldset class="hide-on-affix result-special-offer {{ if (!result.pathValue) { }}invisible{{ } }}">
                <legend>Special Offer</legend>
                {{= result.displayValue }}
            </fieldset>
        </div>
    </div>
</div>
