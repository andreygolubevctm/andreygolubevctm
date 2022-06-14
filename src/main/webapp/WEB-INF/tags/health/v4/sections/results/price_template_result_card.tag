<%@ tag description="The Health Logo template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- PRICE TEMPLATE FOR RESULT CARD V4 MAIN (OR SINGLE) PRICE GROUP --%>
{{ if (!obj.hasOwnProperty('premium')) {return;} }}
{{ var priceVars = meerkat.modules.healthDualPricing.getDualPricingVarsForTemplateResultCard(obj); }}
{{ var frequencyAndLHCData = []; }}
    <div class="price-row price_template-result-card-tag">
        {{ if (priceVars.isDualPricingActive && priceVars.dualPricingDate) { }}
            <div class="dual-pricing-before-after-text"><div>Current price</div></div>
        {{ } }}
        <div class="more-info-showapply" data-productId='{{= obj.productId }}' data-available='{{= obj.available }}'>
            <div class="price premium">
                {{ _.each(priceVars.availableFrequencies, function(freqObj) { }}
                    {{ var priceVarsFreq = meerkat.modules.healthDualPricing.getDualPricingVarsForTemplateResultCardForFrequency(obj, freqObj, priceVars.availablePremiums, priceVars.healthResultsTemplate); }}

                    <div class="frequency {{= priceVarsFreq.result.frequency }} {{= obj._selectedFrequency === priceVarsFreq.result.frequency ? '' : 'displayNone' }}">
                        {{ if (!priceVarsFreq.result.hasValidPrice) { }}
                            <div class="frequencyAmount comingSoon">{{= priceVarsFreq.comingSoonLabel }} payments not available</div>
                    </div>
                        <%-- Close the opened tags and return, to reduce complexity of nesting --%>
                            {{ return; }}
                        {{ } }}

                    <div class="frequencyAmount">
                        {{ var dollarPriceResult = priceVars.healthResultsTemplate.getPrice(priceVarsFreq.result); }}
                        <span class="dollarSign">$</span>{{= dollarPriceResult.dollarPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") }}<span class="cents">.{{= dollarPriceResult.cents }}</span>
                    </div>

                <%-- grab data for "frequency / lhc text" display as we need to render it in a separate line now --%>
                {{ frequencyAndLHCData.push({frequency: priceVarsFreq.result.frequency, selectedFrequency: obj._selectedFrequency, textLhcFreePricing: priceVarsFreq.textLhcFreePricing, frequencyTitle: freqObj.key, textLhcFreeDualPricing: priceVarsFreq.textLhcFreeDualPricing}); }}

                {{ if (priceVarsFreq.frequency === obj._selectedFrequency && (obj.hasOwnProperty('priceBreakdown') || (!obj.hasOwnProperty('priceBreakdown') && obj.priceBreakdown)) && window.meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment') { }}
                    {{= meerkat.modules.healthPriceBreakdown.renderTemplate(priceVarsFreq.property, priceVarsFreq.frequency, false) }}
                {{ } }}
            </div>
            {{ }); }}
        </div>
    </div>

</div>

<%-- the same loop as above, just over the collected data --%>
{{ _.each(frequencyAndLHCData, function(data) { }}
    <div class="frequency {{= data.frequency }} {{= data.selectedFrequency === data.frequency ? '' : 'displayNone' }} {{= ((!(priceVars.isDualPricingActive && priceVars.dualPricingDate)) && data.textLhcFreePricing !== '') ? 'hasLhcFreePricingText' : '' }}">
        <div class="hide-on-affix  {{= priceVars.productSummaryClass }}">
            <span class="frequencyTitle">{{= data.frequencyTitle }} / </span>
            <span class="lhcText">{{= data.textLhcFreeDualPricing}}</span>
        </div>
    </div>
{{ }); }}