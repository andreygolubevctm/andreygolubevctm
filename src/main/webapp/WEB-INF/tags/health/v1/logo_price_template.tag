<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE --%>
<script id="logo-price-template" type="text/html">
    {{ if (!obj.hasOwnProperty('premium')) {return;} }}
    <%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
    {{ var property = premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = altPremium; } }}

    {{ if(typeof obj.displayLogo === 'undefined' || obj.displayLogo == true) { }}
    <div class="companyLogo {{= info.provider ? info.provider : info.fundCode }}"></div>
    {{ } }}

    {{ if(!meerkat.site.isCallCentreUser && (typeof obj.showRisingTag === 'undefined' || obj.showRisingTag == true)) { }}
    <div class="premium-rising-tag">
        <span class="icon-arrow-thick-up"></span> Premiums are rising from April 1st, 2019<br/>
        <a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a>
    </div>
    {{ } }}

    {{ if(meerkat.site.isCallCentreUser) { }}
        {{ if(typeof obj.hasOwnProperty('showCurrPremText') && obj.showCurrPremText === true) { }}
        <p>Current premium</p>
        {{ } }}
    {{ } else { }}
        {{ if(typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true) { }}
        <div class="dual-pricing-before-after-text">
            <span class="text-bold">
            {{ if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { }}After{{ } else { }}Before{{ } }}
            </span> April 1st</div>
        {{ } }}
    {{ } }}

    {{ var pyrrClass = meerkat.modules.healthPyrrCampaign.isPyrrActive(true) ? " pyrrMoreInfoInline" : ""; }}
    <div class="price premium{{= pyrrClass}}">
        {{ var formatCurrency = meerkat.modules.currencyField.formatCurrency }}
        {{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
        {{ if (typeof property[freq] !== "undefined") { }}
        {{ var premium = property[freq] }}
        {{ var priceText = premium.text ? premium.text : formatCurrency(premium.payableAmount) }}
        {{ var priceLhcfreetext = premium.lhcfreetext ? premium.lhcfreetext : formatCurrency(premium.lhcFreeAmount) }}
        {{ var textLhcFreePricing = premium.lhcfreepricing ? premium.lhcfreepricing : '+ ' + formatCurrency(premium.lhcAmount) + ' LHC inc ' + formatCurrency(premium.rebateAmount) + ' Government Rebate' }}
        {{ var textPricing = premium.pricing ? premium.pricing : 'Includes rebate of ' + formatCurrency(premium.rebateAmount) + ' & LHC loading of ' + formatCurrency(premium.lhcAmount) }}
        <div class="frequency {{=freq}} {{= obj._selectedFrequency === freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= priceText }}" data-lhcfreetext="{{= priceLhcfreetext }}">
            {{ if ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)) { }}
                        <div class="frequencyAmount">
                            {{ var premiumSplit = (typeof mode === "undefined" || mode != "lhcInc" ? priceLhcfreetext : priceText) }}
                            {{ premiumSplit = premiumSplit.split(".") }}
                            <span class="dollarSign">$</span>{{=  premiumSplit[0].replace('$', '') }}<span class="cents">.{{= premiumSplit[1] }}</span>
                            <div class="frequencyTitle">
                                {{= freq === 'annually' ? 'per year' : '' }}
                                {{= freq.toLowerCase() === 'halfyearly' ? 'per half year' : '' }}
                                {{= freq === 'quarterly' ? 'per quarter' : '' }}
                                {{= freq === 'monthly' ? 'per month' : '' }}
                                {{= freq === 'fortnightly' ? 'per f/night' : '' }}
                                {{= freq === 'weekly' ? 'per week' : '' }}
                            </div>
                        </div>
            {{ } else { }}
            <div class="frequencyAmount comingSoon">New price not yet released</div>
            {{ } }}
            {{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
            <div class="rounding">Premium may vary slightly due to rounding</div>
            {{ } }}
            <div class="lhcText">
                <span>
					{{= textPricing}}
                </span>
            </div>
        </div>
        {{ } }}
        {{ }) }}
    </div>
</script>