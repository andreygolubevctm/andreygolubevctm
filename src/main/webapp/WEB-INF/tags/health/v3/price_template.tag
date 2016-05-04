<%@ tag description="The Health Logo template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="price-template">

    {{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
    {{ var formatCurrency = meerkat.modules.currencyField.formatCurrency; }}
    {{ var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies(); }}
    <div class="price premium">
    {{ _.each(availableFrequencies, function(freqObj) { }}
    {{ var frequency = freqObj.key; }}
    {{ if (typeof availablePremiums[frequency] === "undefined") { return; } }}

            <%-- Is it possible to move these variables out to the model previously? --%>
        {{ var premiumObj = availablePremiums[frequency] }}

        {{ frequency = frequency.toLowerCase(); }}
        {{ var priceText = premiumObj.text ? premiumObj.text : formatCurrency(premiumObj.payableAmount) }}
        {{ var priceLhcfreetext = premiumObj.lhcfreetext ? premiumObj.lhcfreetext : formatCurrency(premiumObj.lhcFreeAmount) }}
        {{ var textLhcFreePricing = premiumObj.lhcfreepricing ? premiumObj.lhcfreepricing : '+ ' + formatCurrency(premiumObj.lhcAmount) + ' LHC inc ' + formatCurrency(premiumObj.rebateAmount) + 'Government Rebate' }}
        {{ var textPricing = premiumObj.pricing ? premiumObj.pricing : 'Includes rebate of ' + formatCurrency(premiumObj.rebateAmount) + ' & LHC loading of ' + formatCurrency(premiumObj.lhcAmount) }}
        {{ var hasValidPrice = (premiumObj.value && premiumObj.value > 0) || (premiumObj.text && premiumObj.text.indexOf('$0.') < 0) || (premiumObj.payableAmount && premiumObj.payableAmount > 0); }}
        {{ var lhcFreePriceMode = typeof mode === "undefined" || mode != "lhcInc"; }}

        <div class="frequency {{= frequency }} {{= obj._selectedFrequency === frequency ? '' : 'displayNone' }}">

            {{ if (!hasValidPrice) { }}
            <div class="frequencyAmount comingSoon">Coming Soon^</div>
            </div> <%-- Close the opened tags and return, to reduce complexity of nesting --%>
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

</core_v1:js_template>