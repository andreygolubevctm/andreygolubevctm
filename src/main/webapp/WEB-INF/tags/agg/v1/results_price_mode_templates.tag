<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Price mode templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="monthly-price-template">
    <div class="frequency monthly clearfix" data-availability="{{= obj.available }}">
        <div class="frequencyAmount">{{= '$' }}{{= obj.price.monthlyPremium.toFixed(2) }}</div>
        <div class="frequencyTitle">Monthly Price</div>
        <div class="monthlyBreakdown">
            <span class="nowrap"><span class="firstPayment"><b>1st Month:</b> {{= '$' }}{{= obj.price.monthlyFirstMonth.toFixed(2) }}</span></span>
            <span class="nowrap"><span class="totalPayment"><b>Total:</b> {{= '$' }}{{= obj.price.annualisedMonthlyPremium.toFixed(2) }}</span></span>
        </div>
    </div>
</core_v1:js_template>

<core_v1:js_template id="annual-price-template">
    <div class="frequency annual clearfix" data-availability="{{= obj.available }}">
        <div class="frequencyAmount">{{= '$' }}{{= obj.price.annualPremiumFormatted }}</div>
        <div class="frequencyTitle">Annual Price</div>
    </div>
</core_v1:js_template>

<core_v1:js_template id="title-download-special-template">
    {{ var productTitle = !_.isUndefined(obj.productName) ? obj.productName : 'Unknown product name'; }}

    <div class="title-download-special-container">
        <h2 class="productTitle">{{= productTitle }}</h2>

        <a href="javascript:;" class="link-more-info" data-productId="{{= obj.productId }}">View product details and download disclosure statements</a>

        {{ if (obj.specialConditions != null && typeof obj.specialConditions !== 'undefined' && obj.specialConditions.description != null && typeof obj.specialConditions.description !== 'undefined' &&  obj.specialConditions.description.length > 0) { }}
        <p class="specialConditions">
            <small>Special conditions: {{= obj.specialConditions.description }}</small>
        </p>
        {{ } }}
    </div>
</core_v1:js_template>

<core_v1:js_template id="call-action-buttons-price-template">
    {{ var template = $("#call-direct-button-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ var callInsurerDirectActionButton = htmlTemplate(obj); }}

    {{ var template = $("#call-back-button-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ var callMeBackActionButton = htmlTemplate(obj); }}

    <div class="call-actions-buttons">
        {{ if (obj.contact.allowCallDirect === true) { }}
            {{= callInsurerDirectActionButton }}
        {{ } }}

        {{ if (obj.contact.allowCallMeBack === true) { }}
            {{= callMeBackActionButton }}
        {{ } }}
    </div>
</core_v1:js_template>

<core_v1:js_template id="promotion-price-template">
    {{ var promotionText = (!_.isUndefined(obj.discountOffer) && !_.isNull(obj.discountOffer) && obj.discountOffer.length > 0) ? obj.discountOffer : ''; }}
    {{ var offerTermsContent = (!_.isUndefined(obj.discountOfferTerms) && !_.isNull(obj.discountOfferTerms) && obj.discountOfferTerms.length > 0) ? obj.discountOfferTerms : ''; }}

    {{ if (promotionText.length > 0) { }}
    <div class="promotion">
        {{= promotionText }}
        {{ if (offerTermsContent.length > 0) { }}
            <a class="small offerTerms" href="javascript:;">Offer terms</a>
            <div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
        {{ } }}
    </div>
    {{ } }}
</core_v1:js_template>

<core_v1:js_template id="compare-toggle-price-template">
    <div class="compare-toggle-wrapper">
        <input type="checkbox" class="compare-tick" data-productId="{{= obj.productId }}" id="price_compareTick_{{= obj.productId }}" />
        <c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Short List - {{= obj.brandCode }} | {{= obj.productId }}" quoteChar="\"" /></c:set>
        <label for="price_compareTick_{{= obj.productId }}" ${analyticsAttr}></label>
        <label for="price_compareTick_{{= obj.productId }}" class="compare-label" ${analyticsAttr}></label>
    </div>
</core_v1:js_template>