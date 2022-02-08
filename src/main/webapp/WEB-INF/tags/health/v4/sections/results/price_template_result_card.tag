<%@ tag description="The Health Logo template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- PRICE TEMPLATE FOR RESULT CARD V4 --%>
{{ var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;}}
{{ if (!obj.hasOwnProperty('premium')) {return;} }}
{{ var isConfirmation = false; }}
{{ try{ }}
    {{ isConfirmation = _.isNumber(meerkat.modules.healthConfirmation.getPremium()); }}
{{ } catch(err){ console.warn('Bad premium number', err); } }}
{{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
{{ var healthResultsTemplate = meerkat.modules.healthResultsTemplate; }}
{{ var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies(); }}
{{ var discountText = healthResultsTemplate.getDiscountText(obj); }}
{{ var frequencyAndLHCData = []; }}
    <div class="price-row">
        {{ if (isDualPricingActive) { }}
            <div class="dual-pricing-before-after-text"><div>Current price</div></div>
        {{ } }}
        <div class="more-info-showapply" data-productId='{{= obj.productId }}' data-available='{{= obj.available }}'>
            <div class="price premium">
                {{ _.each(availableFrequencies, function(freqObj) { }}
                    {{ var formatCurrency = meerkat.modules.currencyField.formatCurrency; }}
                    {{ var frequency = freqObj.key; }}
                    {{ if (typeof availablePremiums[frequency] === "undefined") { return; } }}
                    {{ var result = healthResultsTemplate.getPricePremium(frequency, availablePremiums, obj.mode); }}
                    {{ var discountPercentage = healthResultsTemplate.getDiscountPercentage(obj.info.FundCode, result); }}
                    {{ var property = obj.premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = obj.altPremium; } }}
                    {{ var prem = obj.premium[frequency]; }}
                    {{ var textLhcFreePricing = 'LHC loading may increase the premium.'; }}
                    {{ if (prem.lhcfreepricing.indexOf('premium') === -1) { textLhcFreePricing = ''; } }}
                    {{ var textLhcFreeDualPricing= 'inc ' + formatCurrency(prem.rebateValue) + ' Govt Rebate';}}

                    <div class="frequency {{= result.frequency }} {{= obj._selectedFrequency === result.frequency ? '' : 'displayNone' }}">
                        {{ if (!result.hasValidPrice) { }}
                            {{ var comingSoonLabel = frequency; }}
                            {{ if (comingSoonLabel == 'annually') { }}
                                {{ comingSoonLabel = 'Annual'; }}
                            {{ } }}
                            <%-- Convert to title case --%>
                            {{ comingSoonLabel = comingSoonLabel.replace(/(\b[a-z](?!\s))/g, function(x){ return x.toUpperCase(); }); }}
                            <div class="frequencyAmount comingSoon">{{= comingSoonLabel }} payments not available</div>
                    </div>

                    <%-- Close the opened tags and return, to reduce complexity of nesting --%>
                    {{ return; } }}

                    <div class="frequencyAmount">
                        {{ var dollarPriceResult = healthResultsTemplate.getPrice(result); }}
                        <span class="dollarSign">$</span>{{= dollarPriceResult.dollarPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") }}<span class="cents">.{{= dollarPriceResult.cents }}</span>
                    </div>

                <%-- grab data for "frequency / lhc text" display as we need to render it in a separate line now --%>
                {{ frequencyAndLHCData.push({frequency: result.frequency, selectedFrequency: obj._selectedFrequency, textLhcFreePricing: textLhcFreePricing, frequencyTitle: freqObj.key, textLhcFreeDualPricing: textLhcFreeDualPricing}); }}

                {{ if (frequency === obj._selectedFrequency && (obj.hasOwnProperty('priceBreakdown') || (!obj.hasOwnProperty('priceBreakdown') && obj.priceBreakdown)) && window.meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment') { }}
                    {{= meerkat.modules.healthPriceBreakdown.renderTemplate(property, frequency, false) }}
                {{ } }}
            </div>
            {{ }); }}
        </div>
    </div>

</div>

<%-- the same loop as above, just over the collected data --%>
{{ _.each(frequencyAndLHCData, function(data) { }}
    <div class="frequency {{= data.frequency }} {{= data.selectedFrequency === data.frequency ? '' : 'displayNone' }} {{= ((!isDualPricingActive) && data.textLhcFreePricing !== '') ? 'hasLhcFreePricingText' : '' }}">
        <div class="hide-on-affix">
            <span class="frequencyTitle">{{= data.frequencyTitle }} / </span>
            <span class="lhcText">{{= data.textLhcFreeDualPricing}}</span>
        </div>
    </div>
{{ }); }}