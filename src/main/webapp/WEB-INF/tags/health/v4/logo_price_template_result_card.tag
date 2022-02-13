<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- PRICE TEMPLATE FOR RESULT CARD- --%>
<script id="logo-price-template-result-card" type="text/html">

	{{ var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;}}
	{{ var comingSoonClass = ''; }}
	{{ if (!_.isUndefined(obj.altPremium[obj._selectedFrequency])) { }}
		{{ var productPremium = obj.altPremium[obj._selectedFrequency] }}
		{{ comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon' }}
	{{ } }}
	{{ var property = premium; }}
	{{ if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = altPremium; } }}
	{{ var showFromDate = false; }}
	{{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
		{{ if(typeof property[freq] !== "undefined") { }}
			{{ var premium = property[freq]; }}
			{{ if ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)) { }}
				{{ showFromDate = true; }}
			{{ } }}
		{{ } }}
	{{ }); }}

	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }} {{= comingSoonClass }}">
		<div class="raterisemonth-pricing {{= (showFromDate === true ? 'blue-background' : 'grey-background') }}">
			{{ if(showFromDate === true && obj.isForResultPage === true) { }}
			<div class="dual-pricing-before-after-text">
				From April 1
			</div>
			{{ } }}


			<div class="altPriceContainer">
				{{ if (!obj.hasOwnProperty('premium')) {return;} }}
				<%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
				{{ var property = premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = altPremium; } }}
				{{ var frequencyAndLHCData = []; }}

				{{ if(typeof obj.displayLogo === 'undefined' || obj.displayLogo == true) { }}
				<div class="companyLogo {{= info.provider ? info.provider : info.fundCode }}"></div>
				{{ } }}

				<div class="price-wrapper">
					{{ if(typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true) { }}
					<div class="dual-pricing-before-after-text">
						<span class="text-bold">
						{{ if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { }}From April 1{{ } else { }}Current price{{ } }}
						</span>
					</div>
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

								<%-- grab data for "frequency / lhc text" display as we need to render it in a separate line now --%>
								{{ frequencyAndLHCData.push({freq: freq, selectedFrequency: obj._selectedFrequency, priceText: priceText, priceLhcfreetext: priceLhcfreetext, premium: premium, lhtText: lhtText, textLhcFreeDualPricing: textLhcFreeDualPricing, textLhcFreePricing: textLhcFreePricing}); }}

								<div class="frequency {{=freq}} {{= obj._selectedFrequency === freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= priceText }}" data-lhcfreetext="{{= priceLhcfreetext }}">
									{{ if ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)) { }}
										<span class="frequencyAmount">
											{{ var premiumSplit = (typeof mode === "undefined" || mode != "lhcInc" ? priceLhcfreetext : priceText) }}
											{{ premiumSplit = premiumSplit.split(".") }}
											<span class="dollarSign">$</span>{{=  premiumSplit[0].replace('$', '') }}<span class="cents">.{{= premiumSplit[1] }}</span>
											</span>
										{{ if (!((!obj.hasOwnProperty('priceBreakdown') || (obj.hasOwnProperty('priceBreakdown') && !obj.priceBreakdown)) || window.meerkat.modules.journeyEngine.getCurrentStep().navigationId !=='payment' )) { }}
											{{= meerkat.modules.healthPriceBreakdown.renderTemplate(availablePremiums, freq, obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) }}
										{{ } }}
									{{ } else { }}
										<div class="frequencyAmount comingSoon-results">New price not yet released</div>
										<div class="comingSoon-dash">&#8211;</div> <%-- long dash--%>
									{{ } }}
									{{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
										<div class="rounding">Premium may vary slightly due to rounding</div>
									{{ } }}
								</div>
							{{ } }}
						{{ }); }}
					</div>
				</div>
			</div>


			<%-- the same loop as above, just over the collected data --%>
			{{ _.each(frequencyAndLHCData, function(data){ }}
				<div class="frequency {{=data.freq}} {{= data.selectedFrequency === data.freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= data.priceText }}" data-lhcfreetext="{{= data.priceLhcfreetext }}">
					{{ if ((data.premium.value && data.premium.value > 0) || (data.premium.text && data.premium.text.indexOf('$0.') < 0) || (data.premium.payableAmount && data.premium.payableAmount > 0)) { }}
					<div class="line-break"></div>
					<div class="hide-on-affix">
						<span class="frequencyTitle">
							{{= data.freq === 'annually' ? 'annually / ' : '' }}
							{{= data.freq.toLowerCase() === 'halfyearly' ? 'per half year / ' : '' }}
							{{= data.freq === 'quarterly' ? 'per quarter / ' : '' }}
							{{= data.freq === 'monthly' ? 'monthly / ' : '' }}
							{{= data.freq === 'fortnightly' ? 'fortnightly / ' : '' }}
							{{= data.freq === 'weekly' ? 'per week / ' : '' }}
						</span>
						{{ if ((!obj.hasOwnProperty('priceBreakdown') || (obj.hasOwnProperty('priceBreakdown') && !obj.priceBreakdown)) || window.meerkat.modules.journeyEngine.getCurrentStep().navigationId !=='payment' ) { }}
							<div class="lhcText">
								{{ if (isDualPricingActive) { }}
									<span>{{= data.textLhcFreeDualPricing}}</span>
								{{ } else { }}
									<span>{{= data.textLhcFreePricing.split(".<br>")[0] }}</span>
								{{ } }}
							</div>
					</div>
						{{ } else { }}
							{{= meerkat.modules.healthPriceBreakdown.renderTemplate(obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium, data.freq, obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) }}
						{{ } }}
					{{ } }}
					{{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
						<div class="rounding">Premium may vary slightly due to rounding</div>
					{{ } }}
				</div>
			{{ }); }}
		</div>
	</div>
</script>
