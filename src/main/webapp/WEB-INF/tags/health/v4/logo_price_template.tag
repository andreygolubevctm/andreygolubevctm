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

	{{ if (!obj.hasOwnProperty('showAltPremium') || !obj.showAltPremium) { }}
		<a href="javascript:;" class="about-this-fund hidden-xs">About this fund</a>
	{{ } }}

	{{ if(typeof obj.showRisingTag === 'undefined' || obj.showRisingTag == true) { }}
	<div class="premium-rising-tag">
		<span class="icon-arrow-thick-up"></span> Premiums are rising from April 1st, 2019<br/>
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
				{{ var textLhcFreePricing = premium.lhcfreepricing ? premium.lhcfreepricing : '+ ' + formatCurrency(premium.lhcAmount) + ' LHC inc ' + formatCurrency(premium.rebateAmount) + ' Government Rebate' }}
				{{ var textPricing = premium.pricing ? premium.pricing : 'Includes rebate of ' + formatCurrency(premium.rebateAmount) + ' & LHC loading of ' + formatCurrency(premium.lhcAmount) }}
				<div class="frequency {{=freq}} {{= obj._selectedFrequency === freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= priceText }}" data-lhcfreetext="{{= priceLhcfreetext }}">
					{{ if ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)) { }}
                        <span class="frequencyAmount">
                            {{ var premiumSplit = (typeof mode === "undefined" || mode != "lhcInc" ? priceLhcfreetext : priceText) }}
                            {{ premiumSplit = premiumSplit.split(".") }}
                            <span class="dollarSign">$</span>{{=  premiumSplit[0].replace('$', '') }}<span class="cents">.{{= premiumSplit[1] }}{{ if (obj.showAltPremium === true) { }}&#42;{{ } }}</span>
													    <div class="frequencyTitle">
                                {{= freq === 'annually' ? 'per year' : '' }}
                                {{= freq.toLowerCase() === 'halfyearly' ? 'per half year' : '' }}
                                {{= freq === 'quarterly' ? 'per quarter' : '' }}
                                {{= freq === 'monthly' ? 'per month' : '' }}
                                {{= freq === 'fortnightly' ? 'per f/night' : '' }}
                                {{= freq === 'weekly' ? 'per week' : '' }}
                            </div>
							</span>
            			{{ if ((!obj.hasOwnProperty('priceBreakdown') || (obj.hasOwnProperty('priceBreakdown') && !obj.priceBreakdown)) || window.meerkat.modules.journeyEngine.getCurrentStep().navigationId !=='payment' ) { }}
                    	<div class="lhcText hide-on-affix">
                    	    <span>
								{{= textLhcFreePricing}}
                    	    </span>
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
