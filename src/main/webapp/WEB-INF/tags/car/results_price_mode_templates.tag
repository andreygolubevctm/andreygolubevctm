<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Car price mode templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="excess-price-template">
    <div class="excess-container">
        <div class="excess">
            <div class="excessAmount">{{= '$' }}{{= obj.excess }}</div>
            <div class="excessTitle">Excess</div>
        </div>

        <a href="javascript:;" class="link-more-info" data-productId="{{= obj.productId }}">Additional Excesses Applicable</a>
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
            <li class=""><a href="javascript:void(0);" class="compare-list enter-compare-mode">Compare Products <span class="icon icon-arrow-right"></span></a></li>
        </ul>
        {{ } }}
    {{ } }}
</core_v1:js_template>