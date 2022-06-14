<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE FOR RESULT CARD IN SIMPLES --%>
<script id="logo-price-template-result-card" type="text/html">
    {{ if (!obj.hasOwnProperty('premium')) {return;} }}
    <%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
    {{ var priceVarsSimples = meerkat.modules.healthDualPricing.getLogoPriceTemplateResultCardVarsSimples(obj, premium, altPremium); }}

    {{ if(typeof obj.displayLogo === 'undefined' || obj.displayLogo == true) { }}
    <div class="companyLogo {{= info.provider ? info.provider : info.fundCode }}"></div>
    {{ } }}

    {{ if(!meerkat.site.isCallCentreUser && (typeof obj.showRisingTag === 'undefined' || obj.showRisingTag == true)) { }}
    <div class="premium-rising-tag">
        <span class="icon-arrow-thick-up"></span> Premiums are rising from {{= priceVarsSimples.dualPricingDate }}<br/>
        <a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a>
    </div>
    {{ } }}

    {{ if(typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true) { }}
       <div class="dual-pricing-before-after-text">
            <span class="text-bold">
              {{ if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { }}After{{ } else { }}Before{{ } }}
            </span> {{= priceVarsSimples.dualPricingDate }}
        </div>
    {{ } }}

    {{ var pyrrClass = meerkat.modules.healthPyrrCampaign.isPyrrActive(true) ? " pyrrMoreInfoInline" : ""; }}
    {{ var frequencyAndLHCData = []; }}
    <div class="price premium{{= pyrrClass}} {{= priceVarsSimples.productSummaryClass }} {{= priceVarsSimples.productSummaryClass2 }} v1-logo-price-template-result-card-tag">
        {{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
        {{ if (typeof priceVarsSimples.property[freq] !== "undefined") { }}
            {{ var priceVarsSimplesFreq = meerkat.modules.healthDualPricing.getLogoPriceTemplateResultCardVarsSimplesForFreq(freq, priceVarsSimples); }}

            <%-- grab data for "frequency / lhc text" display as we need to render it in a separate line now --%>
            {{ frequencyAndLHCData.push({freq: freq, selectedFrequency: obj._selectedFrequency, priceText: priceVarsSimplesFreq.priceText, priceLhcfreetext: priceVarsSimplesFreq.priceLhcfreetext, premium: priceVarsSimplesFreq.premium, textLhcFreePricing: priceVarsSimplesFreq.textLhcFreePricing, textPricing: priceVarsSimplesFreq.textPricing, textPricingLHC: priceVarsSimplesFreq.textPricingLHC}); }}

            <div class="frequency {{=freq}} {{= obj._selectedFrequency === freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= priceVarsSimplesFreq.priceText }}" data-lhcfreetext="{{= priceVarsSimplesFreq.priceLhcfreetext }}">
                {{ if ((priceVarsSimplesFreq.premium.value && priceVarsSimplesFreq.premium.value > 0) || (priceVarsSimplesFreq.premium.text && priceVarsSimplesFreq.premium.text.indexOf('$0.') < 0) || (priceVarsSimplesFreq.premium.payableAmount && priceVarsSimplesFreq.premium.payableAmount > 0)) { }}
                            <div class="frequencyAmount {{= priceVarsSimples.productSummaryClass }}">
                                {{ var premiumSplit = (typeof mode === "undefined" || mode != "lhcInc" ? priceVarsSimplesFreq.priceLhcfreetext : priceVarsSimplesFreq.priceText) }}
                                {{ premiumSplit = premiumSplit.split(".") }}
                                <span class="dollarSign">$</span>{{=  premiumSplit[0].replace('$', '') }}<span class="cents">.{{= premiumSplit[1] }}</span>
                            </div>
                {{ } else { }}
                    <div class="frequencyAmount comingSoon-results">New price not yet released</div>
                {{ } }}
            </div>
            {{ } }}
        {{ }); }}
    </div>

    {{ if(priceVarsSimples.showFromDate) { }}
    <div class="line-break"></div>
    <div class="price premium{{= pyrrClass}}">
        {{ _.each(frequencyAndLHCData, function(data){ }}
            <div class="frequency {{=data.freq}} {{= data.selectedFrequency === data.freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= data.priceText }}" data-lhcfreetext="{{= data.priceLhcfreetext }}">
                {{ if ((data.premium.value && data.premium.value > 0) || (data.premium.text && data.premium.text.indexOf('$0.') < 0) || (data.premium.payableAmount && data.premium.payableAmount > 0)) { }}
                    <div class="line-break"></div>
                    <div class="hide-on-affix">
                        <span class="frequencyTitle {{= priceVarsSimples.productSummaryClass }}">
                            {{= meerkat.modules.healthDualPricing.getFrequencyName(data.freq, '') }}
                        </span>
                    </div>
                {{ } }}
                {{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
                    <div class="rounding">Premium may vary slightly due to rounding</div>
                {{ } }}

            </div>
        {{ }); }}
    </div>
    {{ } }}
</script>