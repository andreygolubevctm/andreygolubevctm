<%@ tag description="The Health Product Header template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ var hasCustomHeaderContent = custom.info && custom.info.content && custom.info.content.results && custom.info.content.results.header; }}
{{ var headerVars = meerkat.modules.healthDualPricing.getPriceTemplateResultCardVarsSimplesHeader(obj); }}
<div class="result">
    <div class="resultInsert v3-product-header-template-tag">
        {{ if((Results.getFrequency() && obj.premium[Results.getFrequency()].discountPercentage > 0) || (!_.isEmpty(obj.promo) && !_.isEmpty(obj.promo.discountText))) { }}
            {{ var panelClass = ''; }}
            {{ if (!_.isEmpty(obj.promo) && _.isEmpty(obj.promo.discountText)) { }}
                {{ panelClass = 'noDiscount'; }}
            {{ } }}
            <div class="discountPanel {{= panelClass}}">
                <span class="text">Discount<br />Available</span>
            </div>
        {{ } }}
        <div class="result-header-utility-bar">
            {{ if( info.restrictedFund === 'Y' ) { }}
            <div class="restrictedFund" data-title="This is a Restricted Fund" data-toggle="popover" data-adjust-y="5" data-trigger="mouseenter click" data-my="top center"
                 data-at="bottom center" data-content="#restrictedFundText" data-class="restrictedTooltips">Restricted Fund (?)
            </div>
            {{ } else if( hasCustomHeaderContent && (!_.isEmpty(custom.info.content.results.header.label) || !_.isEmpty(custom.info.content.results.header.text))) { }}
            <div class="customHeaderContent" data-toggle="popover" data-adjust-y="5" data-trigger="mouseenter click" data-my="top center"
                 data-at="bottom center" data-content="{{= custom.info.content.results.header.text}}" data-class="resultHeaderTooltips"><div class="customHeaderContentText">{{= custom.info.content.results.header.label}} (?)</div>
            </div>
            {{ } else { }}
            <div class="utility-bar-blank">&nbsp;</div>
            {{ } }}
            <div class="filter-component remove-result hidden-xs {{= hasCustomHeaderContent ? 'hasCustomHeaderContent' : ''}}" data-productId="{{= obj.productId }}">
                <span class="icon icon-cross" title="Remove this product" <field_v1:analytics_attr analVal="remove {{= obj.info.provider }}" quoteChar="\"" />></span>
            </div>
        </div>
        {{ var comingSoonClass = ''; }}
        {{ if (headerVars.isDualPricingActive) { }}
            {{ if (!_.isUndefined(obj.altPremium[Results.getFrequency()])) { }}
                {{ var productPremium = obj.altPremium[Results.getFrequency()] }}
                {{ comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon' }}
            {{ } }}
        {{ } }}
        <div class="results-header-inner-container {{= comingSoonClass }}">
            <div class="productSummary vertical results {{= headerVars.hasDualPricing }}">
                <%-- If dual pricing is enabled, update the template --%>
                {{ var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template")); }}
                {{= logoTemplate(obj) }}

                {{ if (headerVars.isDualPricingActive) { }}
                    {{ var productTitleTemplate = meerkat.modules.templateCache.getTemplate($("#product-title-template")); }}
                    {{= productTitleTemplate(obj) }}
                    {{= meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false, 'results') }}
                {{ } else { }}
                    {{ var productTitleTemplate = meerkat.modules.templateCache.getTemplate($("#product-title-template")); }}
                    {{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template")); }}
                    {{ obj._selectedFrequency = Results.getFrequency(); obj.showAltPremium = false; }}
                    {{= productTitleTemplate(obj) }}
                    {{= priceTemplate(obj) }}
                {{ } }}
            </div>


            <div class="results-header-info-container">

            <c:set var="simplesHealthReformMessaging" scope="request"><content:get key="simplesHealthReformMessaging" /></c:set>
            
            <c:choose>
            <c:when test="${simplesHealthReformMessaging eq 'Y'}">
                {{ var newName = meerkat.modules.healthResultsTemplate.getNewProductName(obj); }}
                {{ if (!_.isNull(newName) && !_.isUndefined(newName) && newName !== '') { }}
                    <div class="productTitle hidden">
                        {{= newName }}
                    </div>
                {{ } }}

                {{ var classification = meerkat.modules.healthResultsTemplate.getClassification(obj); }}
                {{ var isExtrasOnly = obj.info.ProductType === 'Ancillary' || obj.info.ProductType === 'GeneralHealth'; }}
                {{ var icon = isExtrasOnly ? 'small-height' : classification.icon; }}
                {{ var classificationDate = ''; }}

                {{ if(classification.date && classification.icon !== 'gov-unclassified') { }}
                    {{ classificationDate = 'As of ' + classification.date; }}
                {{ } }}

                {{ if(!isExtrasOnly) { }}
                <div class="results-header-classification">
                    <div class="results-header-classification-icon {{= icon}}"></div>
                </div>
                {{ } }}
            </c:when>
            </c:choose>

            <a class="btn btn-cta btn-block btn-more-info more-info-showapply" href="javascript:;" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>
                <div class="more-info-text">View more details<span class="icon icon-arrow-right"></span></div>
            </a>

            {{ var result = meerkat.modules.healthResultsTemplate.getSpecialOffer(obj); }}
            {{ var additionalFeatures = meerkat.modules.healthResultsTemplate.getAdditionalFeatures(obj); }}

            <div class="hide-on-affix result-special-offer {{ if (!result.pathValue) { }}invisible{{ } }}">
                Special Offer - {{= result.displayValue }}
            </div>
            <div class="hide-on-affix result-special-offer {{ if (!additionalFeatures.displayValue) { }}invisible{{ } }}">
                Additional Features - {{= additionalFeatures.displayValue }}
            </div>
            </div>
        </div>
    </div>
</div>
