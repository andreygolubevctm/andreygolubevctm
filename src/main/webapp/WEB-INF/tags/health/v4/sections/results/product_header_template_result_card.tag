<%@ tag description="The Health Product Header template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- THE NEW RESULT CARD TEMPLATE - FROM THE TOP TO THE "VIEW MORE DEATILS" BUTTON (OLD ONE IS product_header_template.tag) --%>

{{ var restrictedClass = obj.info.restrictedFund === "Y" ? "restricted" : ""; }}

<%-- class=product-header-template-result-card-tag  - to check in the UI which template was used --%>
<div class="result product-header-template-result-card-tag">
    <div class="resultInsert v4-product-header-template-result-card-tag">
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
        {{ if (!obj.hasOwnProperty('premium')) {return;} }}
        {{ var dualPricingVars = meerkat.modules.healthDualPricing.getDualPricingVarsForProductHeaderTemplateResultCard(obj); }}
        <div class="results-header-inner-container">
            <div class="productSummary vertical results {{= dualPricingVars.productSummaryClass }} link-more-info" data-productId="{{= obj.productId }}" title="View policy details">
                <%-- company logo section --%>
                <div class="hide-on-affix logo-full-width">{{= dualPricingVars.logoHtml }}</div>
                <%-- logo_price_template_result_card.tag for single price group--%>
                {{= dualPricingVars.priceTemplate(obj) }}
                <%-- dual pricing group--%>
                {{ if (dualPricingVars.isDualPricingActive && !_.isNull(dualPricingVars.dualPricingDate)) { }}
                    {{= meerkat.modules.healthDualPricing.renderTemplate('', obj, true, false, 'results', false, true) }}
                {{ } }}
            </div>

            {{= dualPricingVars.priceBreakDownTemplate }}

            <%-- LHC and/or ABD    BEGIN --%>
            {{ if (dualPricingVars.isDualPricingActive  && !_.isNull(dualPricingVars.dualPricingDate)) { }}
                <div class="lhc-and-abd-container">
                    {{ if(obj.custom.reform.yad !== "N" && dualPricingVars.frequencyPremium.abd > 0 && dualPricingVars.isDualPricingActive  && !_.isNull(dualPricingVars.dualPricingDate)) { }}
                        <health_v4:abd_badge_with_link />
                    {{ } else { }}
                        {{ if(Results.isAnyResultContainsABD(dualPricingVars.isDualPricingActive, obj._selectedFrequency)) { }}
                            <div class="empty-abd-badge dual-price v4-product-header-template-result-card-tag"></div>
                        {{ } }}
                    {{ } }}
                    <div class="lhs-text-container">
                        <div class="premium-LHC-text lhcText">
                            {{ if (dualPricingVars.textLhcFreePricing !== '') { }}
                            <span>{{= dualPricingVars.textLhcFreePricing }} </span>
                            {{ } }}
                        </div>
                    </div>
                </div>
            {{ } }}

            <c:set var="onlineHealthReformMessaging" scope="request"><content:get key="onlineHealthReformMessaging" /></c:set>
            <div class="results-classification-abd">
                <div class="lhc-and-abd-container">
                    {{ if(dualPricingVars.showAbdBadge) { }}
                        <health_v4:abd_badge_with_link />
                    {{ } else { }}
                        {{ if(Results.isAnyResultContainsABD(dualPricingVars.isDualPricingActive, obj._selectedFrequency) && _.isNull(dualPricingVars.dualPricingDate)) { }}
                            <div class="empty-abd-badge dual-price v4-product-header-template-result-card-tag-2"></div>
                        {{ } }}
                    {{ } }}
                    {{ if (!(dualPricingVars.isDualPricingActive && !_.isNull(dualPricingVars.dualPricingDate))) { }}
                    <div class="lhs-text-container">
                        <div class="premium-LHC-text lhcText {{= dualPricingVars.productSummaryClass }}">
                            {{ if (dualPricingVars.textLhcFreePricing !== '' && !(dualPricingVars.isDualPricingActive && !_.isNull(dualPricingVars.dualPricingDate))) { }}
                            <span>{{= dualPricingVars.textLhcFreePricing }} </span>
                            {{ } }}
                        </div>
                    </div>
                    {{ } }}
                </div>
            </div>
            <%-- LHC and/or ABD    END --%>

            <c:choose>
                <c:when test="${onlineHealthReformMessaging eq 'Y'}">
                    {{ if(!dualPricingVars.isExtrasOnly) { }}
                    <div class="results-header-classification">
                        <div class="results-header-classification-icon {{= dualPricingVars.icon}}"></div>
                    </div>
                    {{ } }}
                </c:when>
            </c:choose>

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
