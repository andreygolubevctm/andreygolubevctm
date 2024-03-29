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
        <span class="icon-arrow-thick-up"></span> Premiums are rising from {{= obj.dualPricingDateFormatted}}<br/>
        <a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a>
    </div>
    {{ } }}

    {{ if(typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true) { }}
    <div class="dual-pricing-before-after-text">
            <span class="text-bold">
              {{ if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { }}After{{ } else { }}Before{{ } }}
            </span> {{= obj.dualPricingDateFormatted}}
    </div>
    {{ } }}

    {{ var pyrrClass = meerkat.modules.healthPyrrCampaign.isPyrrActive(true) ? " pyrrMoreInfoInline" : ""; }}
    <div class="price premium{{= pyrrClass}} v1-logo-price-template-tag">
        {{ var formatCurrency = meerkat.modules.currencyField.formatCurrency }}
        {{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
        {{ if (typeof property[freq] !== "undefined") { }}
        {{ var premium = property[freq] }}
        {{ var priceText = premium.text ? premium.text : formatCurrency(premium.payableAmount) }}
        {{ var priceLhcfreetext = premium.lhcfreetext ? premium.lhcfreetext : formatCurrency(premium.lhcFreeAmount) }}
        {{ var textLhcFreePricing = premium.lhcfreepricing ? premium.lhcfreepricing : '+ ' + formatCurrency(premium.lhcAmount) + ' LHC inc ' + formatCurrency(premium.rebateAmount) + ' Government Rebate' }}
        {{ var textPricing = premium.pricing ? premium.pricing : 'Includes rebate of ' + formatCurrency(premium.rebateAmount) + ' & LHC loading of ' + formatCurrency(premium.lhcAmount) }}
        {{ var isConfirmation = false; }}
        {{ try { }}
        {{ isConfirmation = _.isNumber(meerkat.modules.healthConfirmation.getPremium()); }}
        {{ } catch(err) { console.warn('Bad premium number', err); } }}

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
            {{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
                <div class="rounding">Premium may vary slightly due to rounding</div>
            {{ } }}
            {{ if(obj.custom.reform.yad !== "N" && premium.abd > 0) { }}
                {{ if(obj.info.abdRequestFlag === 'A' || (!isConfirmation && meerkat.modules.healthRABD.isABD())) { }}
                    <health_v4:abd_badge abd="true" />
                {{ } else { }}
                    <health_v4:abd_badge abd="false" />
                {{ } }}
            {{ } }}
            <div class="lhcText">
                <span>
					{{= textPricing}}
                </span>
            </div>
            {{ } else if (obj.hasValidDualPricingDate){ }}
            <div class="frequencyAmount comingSoon">New price not yet released</div>
            {{ } }}

        </div>
        {{ } }}
        {{ }) }}
    </div>
</script>