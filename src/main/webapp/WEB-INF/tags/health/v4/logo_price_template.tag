<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE --%>
<script id="logo-price-template" type="text/html">
    {{ if (!obj.hasOwnProperty('premium')) {return;} }}
	<%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
	{{ var property = obj.premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = obj.altPremium; } }}

	{{ if(typeof obj.displayLogo === 'undefined' || obj.displayLogo == true) { }}
	<div class="companyLogo {{= info.provider ? info.provider : info.fundCode }}"></div>
	{{ } }}

	{{ if (!obj.hasOwnProperty('showAltPremium') || !obj.showAltPremium) { }}
		<a href="javascript:;" class="about-this-fund hidden-xs">About this fund</a>
	{{ } }}

	{{ if(typeof obj.showRisingTag === 'undefined' || obj.showRisingTag == true) { }}
	<div class="premium-rising-tag">
		<span class="icon-arrow-thick-up"></span> Premiums are rising from April 1st
		<br/>
		<a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a>
	</div>
	{{ } }}

	{{ if(typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true) { }}
	<div class="dual-pricing-before-after-text">
		<span class="text-bold">
		{{ if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { }}After{{ } else { }}Before{{ } }}
		</span> April 1st</div>
	{{ } }}

	<div class="price premium">
		{{ var formatCurrency = meerkat.modules.currencyField.formatCurrency }}
		{{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
			{{ if (typeof property[freq] !== "undefined") { }}
				{{ var premium = property[freq] }}
				{{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
				{{ var priceText = premium.text ? premium.text : formatCurrency(premium.payableAmount) }}
				{{ var isPaymentPage = meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment'; }}
        		{{ if(!isPaymentPage) { }}
        		    {{ priceText = premium.lhcfreetext; }}
        		{{ } }}
				{{ var priceLhcfreetext = premium.lhcfreetext ? premium.lhcfreetext : formatCurrency(premium.lhcFreeAmount) }}
				{{ var textLhcFreeDualPricing = 'inc ' + formatCurrency(premium.rebateValue) + ' Govt Rebate'; }}
				{{ var textPricing = premium.pricing ? premium.pricing : 'Includes rebate of ' + formatCurrency(premium.rebateAmount) + ' & LHC loading of ' + formatCurrency(premium.lhcAmount) }}
				{{ var showABDToolTip = premium.abd > 0; }}
				{{ var lhtText = premium.lhcfreepricing.split("<br>")[0]; }}
				{{ var textLhcFreePricing = premium.lhcfreepricing ? premium.lhcfreepricing : '+ ' + formatCurrency(premium.lhcAmount) + ' LHC inc ' + formatCurrency(premium.rebateAmount) + ' Government Rebate' }}
				{{ var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;}}

				<div class="frequency {{=freq}} {{= obj._selectedFrequency === freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= priceText }}" data-lhcfreetext="{{= priceLhcfreetext }}">
					{{ if ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)) { }}
					{{= freq === 'annually' ? 'Annually' : '' }}
					{{= freq.toLowerCase() === 'halfyearly' ? 'Half-yearly' : '' }}
					{{= freq === 'quarterly' ? 'Quarterly' : '' }}
					{{= freq === 'monthly' ? 'Monthly' : '' }}
					{{= freq === 'fortnightly' ? 'Fortnightly' : '' }}
                        <span class="frequencyAmount">
                            {{ var premiumSplit = (typeof mode === "undefined" || mode != "lhcInc" ? priceLhcfreetext : priceText) }}
                            {{ premiumSplit = premiumSplit.split(".") }}
                            <span class="dollarSign">$</span>{{=  premiumSplit[0].replace('$', '') }}<span class="cents">.{{= premiumSplit[1] }}</span>
						    <span class="frequencyTitle">/ {{= freq }}</span>
						</span>
            			{{ if ((!obj.hasOwnProperty('priceBreakdown') || (obj.hasOwnProperty('priceBreakdown') && !obj.priceBreakdown)) || window.meerkat.modules.journeyEngine.getCurrentStep().navigationId !=='payment' ) { }}
                    	<div class="lhcText hide-on-affix">
							{{ if (isDualPricingActive) { }}
								{{ if (lhtText && !obj.isForResultPage) { }}
								<span>
									{{= 'The premiums may be affected by LHC.' }}
								</span>
								<br/>
								{{ } }}
								<span>
									{{= textLhcFreeDualPricing}}
								</span>
							{{ } else { }}
							<span>
								{{= textLhcFreePricing}}
                    	    </span>
							{{ } }}
                    	</div>
					{{ } else { }}
                		    {{= meerkat.modules.healthPriceBreakdown.renderTemplate(availablePremiums, freq, obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) }}
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
