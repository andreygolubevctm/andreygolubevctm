<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE --%>
<script id="logo-price-template" type="text/html">
	<%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
	{{ var property = premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = altPremium; } }}

	{{ if(typeof obj.displayLogo === 'undefined' || obj.displayLogo == true) { }}
	<div class="companyLogo {{= info.provider ? info.provider : info.fundCode }}"></div>
	{{ } }}
	<div class="price premium">
		{{ var formatCurrency = meerkat.modules.currencyField.formatCurrency }}
		{{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
			{{ if (typeof property[freq] !== "undefined") { }}
				{{ var premium = property[freq] }}
				{{ var priceText = premium.text ? premium.text : formatCurrency(premium.payableAmount) }}
				{{ var priceLhcfreetext = premium.lhcfreetext ? premium.lhcfreetext : formatCurrency(premium.lhcFreeAmount) }}
				{{ var textLhcFreePricing = premium.lhcfreepricing ? premium.lhcfreepricing : '+ ' + formatCurrency(premium.lhcAmount) + ' LHC inc ' + formatCurrency(premium.rebateAmount) + ' Government Rebate' }}
				{{ var textPricing = premium.pricing ? premium.pricing : 'Includes rebate of ' + formatCurrency(premium.rebateAmount) + ' & LHC loading of ' + formatCurrency(premium.lhcAmount) }}
				<div class="frequency {{=freq}} {{= obj._selectedFrequency === freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= priceText }}" data-lhcfreetext="{{= priceLhcfreetext }}">
					{{ if ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)) { }}
					<div class="frequencyAmount">
						{{= typeof mode === "undefined" || mode != "lhcInc" ? priceLhcfreetext : priceText }}
						<span class="frequencyTitle">
							{{= freq === 'annually' ? 'PER YEAR' : '' }}
							{{= freq.toLowerCase() === 'halfyearly' ? 'PER HALF YEAR' : '' }}
							{{= freq === 'quarterly' ? 'PER QUARTER' : '' }}
							{{= freq === 'monthly' ? 'PER MONTH' : '' }}
							{{= freq === 'fortnightly' ? 'PER F/NIGHT' : '' }}
							{{= freq === 'weekly' ? 'PER WEEK' : '' }}
						</span>
					</div>
					<div class="lhcText">{{= typeof mode === "undefined" || mode != "lhcInc" ? textLhcFreePricing : textPricing }}</div>
					{{ } else { }}
					<div class="frequencyAmount comingSoon">Coming Soon*</div>
					<div class="note">*Private Health insurance premiums are expecgted to increase on average by [6.18%]</div>
					{{ } }}
					{{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
					<div class="rounding">Premium may vary slightly due to rounding</div>
					{{ } }}
				</div>
			{{ } }}
		{{ }) }}
	</div>
</script>