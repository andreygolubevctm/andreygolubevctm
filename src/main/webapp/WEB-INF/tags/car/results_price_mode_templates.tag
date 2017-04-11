<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Car price mode templates"%>
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

        <a href="javascript:;" class="link-more-info" data-productId="{{= obj.productId }}" ${navBtnAnalAttribute}>View product details and download disclosure statements</a>

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
        <a class="small offerTerms" href="javascript:;" ${navBtnAnalAttribute}>Offer terms</a>
        <div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
        {{ } }}
    </div>
    {{ } }}
</core_v1:js_template>

<core_v1:js_template id="excess-price-template">
    <div class="excess-container">
        <div class="excess">
            <div class="excessAmount">{{= '$' }}{{= obj.excess }}</div>
            <div class="excessTitle">Excess</div>
        </div>

        <a href="javascript:;" class="link-more-info" data-productId="{{= obj.productId }}" ${navBtnAnalAttribute}>Additional Excesses Applicable</a>
    </div>
</core_v1:js_template>

<core_v1:js_template id="compare-basket-price-item-template">
    {{ var tFrequency = Results.getFrequency(); }}
    {{ var tDisplayMode = Results.getDisplayMode(); }}
    {{ var monthlyHidden = tFrequency == 'monthly' ? '' : 'displayNone'; }}
    {{ var annualHidden = tFrequency == 'annual' ? '' : 'displayNone'; }}

    {{ for(var i = 0; i < products.length; i++) { }}
    {{ var img = products[i].brandCode; }}
    {{ if ((typeof img === 'undefined' || img === '') && products[i].hasOwnProperty('productId') && products[i].productId.length > 1) img = products[i].productId.substring(0, products[i].productId.indexOf('-')); }}

    <li class="compare-item">
        <span class="carCompanyLogo logo_{{= img }}" title="{{= products[i].name }}"></span>
        <span class="price">
					<span class="frequency annual annually {{= annualHidden }}">
						{{= '$' }}{{= products[i].price.annualPremiumFormatted }} <span class="small hidden-sm">annually</span>
					</span>
					<span class="frequency monthly {{= monthlyHidden }}">
						{{= '$' }}{{= products[i].price.monthlyPremium.toFixed(2) }} <span class="small hidden-sm">monthly</span>
					</span>
				</span>
        <span class="icon icon-cross remove-compare" data-productId="{{= products[i].productId }}" title="Remove from shortlist"></span>
    </li>
    {{ } }}
</core_v1:js_template>

<!-- Compare view from quick price view. -->
<core_v1:js_template id="compare-basket-price-template">
    {{ if (comparedResultsCount > 0) { }}
        {{ var template = $("#compare-basket-price-item-template").html(); }}
        {{ var htmlTemplate = _.template(template); }}
        {{ var comparedItems = htmlTemplate(obj); }}

        <ul class="nav navbar-nav">
            <li class="navbar-text">Add up to <span class="compare-max-count-label">{{= maxAllowable }} products</span> to your shortlist</li>
            {{= comparedItems }}
        </ul>
        {{ if(comparedResultsCount > 1) { }}
        <ul class="nav navbar-nav navbar-right">
            <li class=""><a href="javascript:void(0);" class="compare-list enter-compare-mode" ${navBtnAnalAttribute}>Compare Products <span class="icon icon-arrow-right"></span></a></li>
        </ul>
        {{ } }}
    {{ } }}
</core_v1:js_template>