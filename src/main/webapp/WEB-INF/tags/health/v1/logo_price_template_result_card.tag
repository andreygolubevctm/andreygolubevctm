<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE --%>
<script id="logo-price-template-result-card" type="text/html">
    {{ if (!obj.hasOwnProperty('premium')) {return;} }}
    <%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
    {{ var property = premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = altPremium; } }}

    {{ var showFromDate = false; }}
    {{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
        {{ if (typeof property[freq] !== "undefined") { }}
            {{ var premium = property[freq] }}
            {{ if ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)) { }}
                {{ showFromDate = true; }}
            {{ } }}
        {{ } }}
    {{ }); }}

<%--    {{ if(showFromDate === true) { }}--%>
<%--    <div class="dual-price-date">--%>
<%--        From April 1--%>
<%--    </div>--%>
<%--    {{ } }}--%>

    {{ if(typeof obj.displayLogo === 'undefined' || obj.displayLogo == true) { }}
    <div class="companyLogo {{= info.provider ? info.provider : info.fundCode }}"></div>
    {{ } }}

    {{ if(!meerkat.site.isCallCentreUser && (typeof obj.showRisingTag === 'undefined' || obj.showRisingTag == true)) { }}
    <div class="premium-rising-tag">
        <span class="icon-arrow-thick-up"></span> Premiums are rising from April 1st<br/>
        <a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a>
    </div>
    {{ } }}

    {{ if(typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true) { }}
       <div class="dual-pricing-before-after-text">
            <span class="text-bold">
              {{ if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { }}After{{ } else { }}Before{{ } }}
            </span> April 1st
        </div>
    {{ } }}

    {{ var pyrrClass = meerkat.modules.healthPyrrCampaign.isPyrrActive(true) ? " pyrrMoreInfoInline" : ""; }}
    {{ var frequencyAndLHCData = []; }}
    <div class="price premium{{= pyrrClass}}">
        {{ var formatCurrency = meerkat.modules.currencyField.formatCurrency }}
        {{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
        {{ if (typeof property[freq] !== "undefined") { }}
        {{ var premium = property[freq] }}
        {{ var priceText = premium.text ? premium.text : formatCurrency(premium.payableAmount) }}
        {{ var priceLhcfreetext = premium.lhcfreetext ? premium.lhcfreetext : formatCurrency(premium.lhcFreeAmount) }}
        {{ var textLhcFreePricing = premium.lhcfreepricing ? premium.lhcfreepricing : '+ ' + formatCurrency(premium.lhcAmount) + ' LHC inc ' + formatCurrency(premium.rebateAmount) + ' Government Rebate' }}
        {{ if (premium.pricing) { }}
            {{ var textPricing = premium.pricing.indexOf('&') > 0 ? premium.pricing.split('&')[0] + ' &' : premium.pricing }}
            {{ var textPricingLHC = premium.pricing.indexOf('&') > 0 ? premium.pricing.split('&')[1] : '' }}
        {{ } else { }}
            {{ var textPricing = 'Includes of ' + formatCurrency(premium.rebateAmount) + ' &'}}
            {{ var textPricingLHC = 'LHC loading of ' + formatCurrency(premium.lhcAmount) }}
        {{ } }}


        <%-- grab data for "frequency / lhc text" display as we need to render it in a separate line now --%>
        {{ frequencyAndLHCData.push({freq: freq, selectedFrequency: obj._selectedFrequency, priceText: priceText, priceLhcfreetext: priceLhcfreetext, premium: premium, textLhcFreePricing: textLhcFreePricing, textPricing: textPricing, textPricingLHC: textPricingLHC}); }}

        <div class="frequency {{=freq}} {{= obj._selectedFrequency === freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= priceText }}" data-lhcfreetext="{{= priceLhcfreetext }}">
            {{ if ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)) { }}
                        <div class="frequencyAmount">
                            {{ var premiumSplit = (typeof mode === "undefined" || mode != "lhcInc" ? priceLhcfreetext : priceText) }}
                            {{ premiumSplit = premiumSplit.split(".") }}
                            <span class="dollarSign">$</span>{{=  premiumSplit[0].replace('$', '') }}<span class="cents">.{{= premiumSplit[1] }}</span>
                        </div>
            {{ } else { }}
            <div class="frequencyAmount comingSoon-results">New price not yet released</div>
            <div class="comingSoon-dash">&#8211;</div> <%-- long dash--%>
            {{ } }}
        </div>
        {{ } }}
        {{ }); }}
    </div>

    {{ if(showFromDate) { }}
    <div class="line-break"></div>
    <div class="price premium{{= pyrrClass}}">
        {{ _.each(frequencyAndLHCData, function(data){ }}
            <div class="frequency {{=data.freq}} {{= data.selectedFrequency === data.freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= data.priceText }}" data-lhcfreetext="{{= data.priceLhcfreetext }}">
                {{ if ((data.premium.value && data.premium.value > 0) || (data.premium.text && data.premium.text.indexOf('$0.') < 0) || (data.premium.payableAmount && data.premium.payableAmount > 0)) { }}
                    <div class="line-break"></div>
                    <div class="hide-on-affix">
                        <span class="frequencyTitle">
                            {{= data.freq === 'annually' ? 'annually' : '' }}
                            {{= data.freq.toLowerCase() === 'halfyearly' ? 'per half year' : '' }}
                            {{= data.freq === 'quarterly' ? 'per quarter' : '' }}
                            {{= data.freq === 'monthly' ? 'monthly' : '' }}
                            {{= data.freq === 'fortnightly' ? 'fortnightly' : '' }}
                            {{= data.freq === 'weekly' ? 'per week' : '' }}
                        </span>
<%--                        {{ if((typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true)) { }}--%>
<%--                            <span class="text-pricing-in-frequency-title changed-1"> / {{= data.textPricing}}</span>--%>
<%--                        {{ } }}--%>
                    </div>
<%--                {{ } else { }}--%>
<%--                    <div class="frequencyAmount comingSoon">New price not yet released</div>--%>
                {{ } }}
                {{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
                    <div class="rounding">Premium may vary slightly due to rounding</div>
                {{ } }}

            </div>
        {{ }); }}
    </div>
    {{ } }}
</script>