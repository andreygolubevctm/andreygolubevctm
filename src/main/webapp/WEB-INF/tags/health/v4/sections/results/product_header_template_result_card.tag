<%@ tag description="The Health Product Header template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ var restrictedClass = obj.info.restrictedFund === "Y" ? "restricted" : ""; }}

<div class="result">
    <div class="resultInsert">
        <div class="result-header-utility-bar {{= restrictedClass }}">
            {{ if(obj.info.restrictedFund === "Y") { }}
            <health_v4_content:restricted_fund />
            {{ } }}
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

        <div class="results-header-inner-container">
            <div class="productSummary vertical results{{ if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) { }} hasDualPricing{{ } }} link-more-info" data-productId="{{= obj.productId }}" title="View policy details">
                {{ var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template")); var logoHtml = logoTemplate(obj); }}
                {{ var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template-result-card")); }}
                {{ obj._selectedFrequency = Results.getFrequency(); obj.showAltPremium = false; }}
                {{ var frequency = obj._selectedFrequency; }}
                {{ var frequencyPremium = obj.premium[frequency]; }}
                {{ var lhtText = frequencyPremium.lhcfreepricing.split("<br>")[0]; }}
                {{ var abdRequestFlag = obj.info.abdRequestFlag; }}
                {{ var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;}}
                {{ var isConfirmation = false; console.log('obj: ', obj); }}
                {{ try{ }}
                    {{ isConfirmation = _.isNumber(meerkat.modules.healthConfirmation.getPremium()); }}
                {{ } catch(e){} }}

                <div class="hide-on-affix logo-full-width">{{= logoHtml }}</div>
                    {{= priceTemplate(obj) }}
                    {{ if (isDualPricingActive) { }}
                        {{= meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false, 'results', false, true) }}
                    {{ } }}
            </div>

            {{ if (obj.hasOwnProperty('premium')) { }}
                {{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
                {{ var healthResultsTemplate = meerkat.modules.healthResultsTemplate; }}
                {{ var discountText = healthResultsTemplate.getDiscountText(obj); }}
                {{ var result = healthResultsTemplate.getPricePremium(obj._selectedFrequency, availablePremiums, obj.mode); }}
                {{ var discountPercentage = healthResultsTemplate.getDiscountPercentage(obj.info.FundCode, result); }}

                {{ if (obj.hasOwnProperty('priceBreakdown') && obj.priceBreakdown && window.meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment') { }}
                    {{= meerkat.modules.healthPriceBreakdown.renderTemplate(availablePremiums, result.frequency, true) }}
                {{ } }}
            {{ } }}

            {{ if (isDualPricingActive) { }}
                <div class="lhc-and-abd-container">
                    {{ if(obj.custom.reform.yad !== "N" && frequencyPremium.abd > 0 && isDualPricingActive ) { }}
                        <health_v4:abd_badge_with_link />
                    {{ } else { }}
                        <div class="lhs-text-container">
                            <div class="premium-LHC-text lhcText">
                                {{ if (lhtText && isDualPricingActive) { }}
                                <span>
                                    {{= 'The premium may be affected by LHC' }}
                                </span>
                                {{ } else { }}
                                    {{ if(Results.isAnyResultContainsLHCText(isDualPricingActive, obj._selectedFrequency)) { }}
                                        {{= '' }}
                                    {{ } }}
                                {{ } }}
                            </div>
                        </div>
                        {{ if(Results.isAnyResultContainsABD(isDualPricingActive, obj._selectedFrequency)) { }}
                            <div class="empty-abd-badge"></div>
                        {{ } }}
                    {{ } }}
                </div>
            {{ } }}

            <c:set var="onlineHealthReformMessaging" scope="request"><content:get key="onlineHealthReformMessaging" /></c:set>
            <div class="results-classification-abd">
                <c:choose>
                <c:when test="${onlineHealthReformMessaging eq 'Y'}">
                    {{ var classification = meerkat.modules.healthResultsTemplate.getClassification(obj); }}
                    {{ var isExtrasOnly = obj.info.ProductType === 'Ancillary' || obj.info.ProductType === 'GeneralHealth'; }}
                    {{ var icon = isExtrasOnly ? 'small-height' : classification.icon; }}

                    {{ if(!isExtrasOnly) { }}
                    <div class="results-header-classification">
                        <div class="results-header-classification-icon {{= icon}}"></div>
                    </div>
                    {{ } }}
                </c:when>
                </c:choose>

                <div class="lhc-and-abd-container">
                    <div class="lhs-text-container">
                        <div class="premium-LHC-text lhcText">
                            {{ if (lhtText && !isDualPricingActive) { }}
                                <span>{{= 'The premium may be affected by LHC' }} </span>
                            {{ } else { }}
                                {{ if(Results.isAnyResultContainsLHCTextSinglePrice(isDualPricingActive, obj._selectedFrequency)) { }}
                                    {{= '' }}
                                {{ } }}
                            {{ } }}
                        </div>
                    </div>

                    {{ if(obj.custom.reform.yad !== "N" && frequencyPremium.abd > 0 && !obj.isForResultPage && !isDualPricingActive ) { }}
                        <health_v4:abd_badge_with_link />
                    {{ } else { }}
                        {{ if(Results.isAnyResultContainsABDSinglePrice(isDualPricingActive, obj._selectedFrequency)) { }}
                            <div class="empty-abd-badge"></div>
                        {{ } }}
                    {{ } }}
                </div>

            </div>
            {{ if(obj.promo.providerPhoneNumber) { }}
            <div class="callCentreNumber">
                <span class="icon icon-phone icon-results"></span><a href="tel:{{= obj.promo.providerPhoneNumber }}">{{= obj.promo.providerPhoneNumber }}</a>
            </div>
            {{ } }}

            <div class="clearfix show-on-affix"></div>
            <a class="btn btn-cta btn-block btn-more-info more-info-showapply hide-on-affix" href="javascript:;" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>
                <div class="more-info-text">View more details <span class="icon icon-angle-right"></span></div>
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