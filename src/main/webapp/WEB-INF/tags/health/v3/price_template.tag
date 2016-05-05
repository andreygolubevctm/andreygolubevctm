<%@ tag description="The Health Logo template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
{{ var formatCurrency = meerkat.modules.currencyField.formatCurrency; }}
{{ var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies(); }}
<div class="price premium">
    {{ _.each(availableFrequencies, function(freqObj) { }}
    {{ var frequency = freqObj.key; }}
    {{ if (typeof availablePremiums[frequency] === "undefined") { return; } }}

    <%-- Is it possible to move these variables out to the model previously? --%>
    {{ var prem = availablePremiums[frequency] }}

    {{ frequency = frequency.toLowerCase(); }}
    {{ var priceText = prem.text ? prem.text : formatCurrency(prem.payableAmount) }}
    {{ var priceLhcfreetext = prem.lhcfreetext ? prem.lhcfreetext : formatCurrency(prem.lhcFreeAmount) }}
    {{ var textLhcFreePricing = prem.lhcfreepricing ? prem.lhcfreepricing : '+ ' + formatCurrency(prem.lhcAmount) + ' LHC inc ' + formatCurrency(prem.rebateAmount) + 'Government Rebate' }}
    {{ var textPricing = prem.pricing ? prem.pricing : 'Includes rebate of ' + formatCurrency(prem.rebateAmount) + ' & LHC loading of ' + formatCurrency(prem.lhcAmount) }}
    {{ var hasValidPrice = (prem.value && prem.value > 0) || (prem.text && prem.text.indexOf('$0.') < 0) || (prem.payableAmount && prem.payableAmount > 0); }}
    {{ var lhcFreePriceMode = typeof mode === "undefined" || mode != "lhcInc"; }}

    <div class="frequency {{= frequency }} {{= obj._selectedFrequency === frequency ? '' : 'displayNone' }}">

        {{ if (!hasValidPrice) { }}
        <div class="frequencyAmount comingSoon">Coming Soon^</div>
    </div>
    <%-- Close the opened tags and return, to reduce complexity of nesting --%>
    {{ return; } }}
    <div class="frequencyAmount">
        {{ var premiumSplit = lhcFreePriceMode ? priceLhcfreetext : priceText }}
        {{ premiumSplit = premiumSplit.split(".") }}
        {{ var dollarPrice = premiumSplit[0].replace('$', ''); }}
        {{ dollarPrice = dollarPrice.replace(',','<span class="comma">,</span>'); }}
        <span class="dollarSign">$</span>{{= dollarPrice }}<span class="cents">.{{= premiumSplit[1] }}</span>
        <span class="frequencyTitle">{{= freqObj.label }}</span>
    </div>

    <div class="lhcText">{{= lhcFreePriceMode ? textLhcFreePricing : textPricing }}</div>

    {{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
    <div class="rounding">Premium may vary slightly due to rounding</div>
    {{ } }}
</div>

{{ }); }}
</div>