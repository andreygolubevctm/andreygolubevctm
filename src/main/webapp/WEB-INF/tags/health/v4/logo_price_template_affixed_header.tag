<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE --%>
<script id="affixed-header-logo-price-template" type="text/html">
    {{ if (!obj.hasOwnProperty('premium')) {return;} }}
    <%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
    {{ var property = premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = altPremium; } }}

    {{ if(typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true) { }}
    <div class="dual-pricing-before-after-text">
		<span>
		{{ if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { }}Price after April 1{{ } else { }}Now{{ } }}
		</span></div>
    {{ } }}

    <div class="price premium">
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
            <span class="frequencyAmount">
                            {{ var premiumSplit = (typeof mode === "undefined" || mode != "lhcInc" ? priceLhcfreetext : priceText) }}
                            {{ premiumSplit = premiumSplit.split(".") }}
                            <span class="dollarSign">$</span>{{=  premiumSplit[0].replace('$', '') }}<span class="cents">.{{= premiumSplit[1] }}{{ if (obj.showAltPremium === true) { }}&#42;{{ } }}</span>
                        </span>
            <div class="frequencyTitle">
                {{= freq === 'halfyearly' ? 'Half yearly' : freq.charAt(0).toUpperCase() + freq.slice(1) }}
            </div>
            {{ if (!obj.hasOwnProperty('priceBreakdown') || (obj.hasOwnProperty('priceBreakdown') && !obj.priceBreakdown)) { }}
            <div class="lhcText">{{= typeof mode === "undefined" || mode != "lhcInc" ? textLhcFreePricing : textPricing }}</div>
            {{ } else { }}
            {{= meerkat.modules.healthPriceBreakdown.renderTemplate(property, freq, false) }}
            {{ } }}
            {{ } else { }}
            <div class="frequencyAmount comingSoon">New price not yet released</div>
            {{ } }}
            {{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
            <div class="rounding">Premium may vary slightly due to rounding</div>
            {{ } }}
        </div>
        {{ } }}
        {{ }) }}
    </div>
</script>
