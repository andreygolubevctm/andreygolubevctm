<%@ tag description="The Health Logo template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
{{ if (!obj.hasOwnProperty('premium')) {return;} }}
{{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
{{ var healthResultsTemplate = meerkat.modules.healthResultsTemplate; }}
{{ var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies(); }}
{{ var discountText = healthResultsTemplate.getDiscountText(obj); }}
<div class="price premium">
    {{ _.each(availableFrequencies, function(freqObj) { }}
    {{ var frequency = freqObj.key; }}
    {{ if (typeof availablePremiums[frequency] === "undefined") { return; } }}
    {{ var result = healthResultsTemplate.getPricePremium(frequency, availablePremiums, obj.mode); }}
    {{ var discountPercentage = healthResultsTemplate.getDiscountPercentage(obj.info.FundCode, result); }}
    {{ var property = obj.premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = obj.altPremium; } }}
	{{ var prem = obj.premium[frequency]; }}
	{{ var textLhcFreePricing = prem.lhcfreepricing ? prem.lhcfreepricing : '+ ' + formatCurrency(prem.lhcAmount) + ' LHC inc ' + formatCurrency(prem.rebateAmount) + ' Government Rebate' }}
    {{ var showABDToolTip = prem.abd > 0; }}

    <div class="frequency {{= result.frequency }} {{= obj._selectedFrequency === result.frequency ? '' : 'displayNone' }}">
        {{ if (!result.hasValidPrice) { }}
        {{ var comingSoonLabel = frequency; }}
        {{ if (comingSoonLabel == 'annually') { }}
            {{ comingSoonLabel = 'Annual'; }}
        {{ } }}
        <%-- Convert to title case --%>
        {{ comingSoonLabel = comingSoonLabel.replace(/(\b[a-z](?!\s))/g, function(x){ return x.toUpperCase();}); }}
        <div class="frequencyAmount comingSoon">{{= comingSoonLabel }} payments not available</div>
    </div>
    <%-- Close the opened tags and return, to reduce complexity of nesting --%>
    {{ return; } }}
    <div class="frequencyAmount">
        {{ var dollarPriceResult = healthResultsTemplate.getPrice(result); }}
        <span class="dollarSign">$</span>{{= dollarPriceResult.dollarPrice }}<span class="cents">.{{= dollarPriceResult.cents }}</span>
        <div class="frequencyTitle">{{= freqObj.label }}</div>
    </div>
    <div class="lhcText hide-on-affix">
        <span>
			{{= textLhcFreePricing}}
            {{ if(showABDToolTip) { }}
                <field_v2:help_icon helpId="643" showText="false" />
            {{ } }}
        </span>
    </div>

        {{ if (frequency === obj._selectedFrequency && (obj.hasOwnProperty('priceBreakdown') || (!obj.hasOwnProperty('priceBreakdown') && obj.priceBreakdown)) && window.meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment') { }}
            {{= meerkat.modules.healthPriceBreakdown.renderTemplate(property, frequency, false) }}
        {{ } }}
</div>
{{ }); }}
</div>