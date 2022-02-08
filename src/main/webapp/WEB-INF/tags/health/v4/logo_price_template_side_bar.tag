<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- PRICE TEMPLATE FOR SIDE BAR ON APPLICATION AND PAYMENT PAGES V4 --%>
<script id="logo-price-template-side-bar" type="text/html">
	{{ var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true; }}
	{{ var isSinglePricingMode = typeof obj.displayLogo === 'undefined' || obj.displayLogo == true; }}
	{{ var showAltPremium = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true; }}
	{{ var showNewPriceNotYetReleased = ((!obj.hasOwnProperty('priceBreakdown') || (obj.hasOwnProperty('priceBreakdown') && !obj.priceBreakdown)) || window.meerkat.modules.journeyEngine.getCurrentStep().navigationId !=='payment' ); }}
	{{ var comingSoonClass = ''; }}
	{{ if (!_.isUndefined(obj.altPremium[obj._selectedFrequency])) { }}
		{{ var productPremium = obj.altPremium[obj._selectedFrequency] }}
		{{ comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon' }}
	{{ } }}
	{{ var property = premium; }}
	{{ if (showAltPremium) { property = altPremium; } }}
	{{ var showFromDate = false; }}
	{{ function showPriceAndFrequency(premium) { return ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)); } }}
	{{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
		{{ if(typeof property[freq] !== "undefined") { }}
			{{ var premium = property[freq]; }}
			{{ if (showPriceAndFrequency(premium)) { }}
				{{ showFromDate = true; }}
			{{ } }}
		{{ } }}
	{{ }); }}

	{{ var formatCurrency = meerkat.modules.currencyField.formatCurrency }}
	{{ var isPaymentPage = meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment'; }}
	{{ var showRoundingMessage = typeof showRoundingText !== 'undefined' && showRoundingText === true; }}

	<div class="{{= showAltPremium ? !showPriceAndFrequency(property[obj._selectedFrequency]) ? 'raterisemonth-pricing altPriceContainer-with-padding' : 'raterisemonth-pricing' : 'current-pricing' }}">

	{{ if(showAltPremium) { }}
		<div class="price-rise-banner-side-bar {{= showPriceAndFrequency(property[obj._selectedFrequency]) ? '' : 'grey-background'}} hidden-xs">
			<health_v4_results:price_rise_banner showHelpIcon="false" textType="rateRiseBannerSideBar"/>
		</div>
	{{ } }}

	<div class="{{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }} {{= comingSoonClass }}">
	<div class="background-wrapper {{= (showAltPremium && showFromDate && !showPriceAndFrequency(premium) ? 'blue-background' : 'grey-background') }}">
			<div class="altPriceContainer">
				{{ if (!obj.hasOwnProperty('premium')) {return;} }}
				<%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
				{{ var property = premium; if (showAltPremium) { property = altPremium; } }}
				{{ var frequencyAndLHCData = []; }}
				<div class="price-wrapper">
					{{ if(typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true) { }}
					<div class="dual-pricing-before-after-text">
						<span class="text-bold">
							{{ if (showAltPremium) { }}
								{{ if (showFromDate) { }} From April 1 {{ } }}
							{{ } else { }}
								Current price
							{{ } }}
						</span>
					</div>
					{{ } }}

					<div class="price premium {{= (!isSinglePricingMode && !showFromDate ? 'full-width' : '') }}">

						{{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
							{{ if (typeof property[freq] !== "undefined") { }}
								{{ var premium = property[freq] }}
								{{ var availablePremiums = showAltPremium ? obj.altPremium : obj.premium; }}
								{{ var priceText = premium.text ? premium.text : formatCurrency(premium.payableAmount) }}
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
									{{ if (showPriceAndFrequency(premium)) { }}
										<span class="frequencyAmount">
														{{ var premiumSplit = (typeof mode === "undefined" || mode != "lhcInc" ? priceLhcfreetext : priceText) }}
														{{ premiumSplit = premiumSplit.split(".") }}
														<span class="dollarSign">$</span>{{=  premiumSplit[0].replace('$', '') }}<span class="cents">.{{= premiumSplit[1] }}</span>
														</span>
									{{ } else { }}
										<div class="new-price-not-yet-released">
											<div class="frequencyAmount comingSoon-results">New price not yet released</div>
											<div class="comingSoon-dash">&#8211;</div> <%-- long dash--%>
										</div>
									{{ } }}
									{{ if (showRoundingMessage) { }}
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
					{{ if (showPriceAndFrequency(data.premium)) { }}
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
								<div class="lhcText">
									{{ if (isDualPricingActive) { }}
										<span>{{= data.textLhcFreeDualPricing}}</span>
									{{ } else { }}
										<span>{{= data.textLhcFreePricing.split(".<br>")[0] }}</span>
									{{ } }}
								</div>
						</div>
					{{ } }}
					{{ if (showRoundingMessage) { }}
						<div class="rounding">Premium may vary slightly due to rounding</div>
					{{ } }}
				</div>
			{{ }); }}
		</div>
	</div>
	{{ if(showAltPremium && showFromDate) { }}
			<div class="price-breakdown-wrapper hidden-xs">
				<health_v4:price_breakdown_accordion id="price-breakdown-accordion-dual" hidden="{{= showAltPremium && !showPriceAndFrequency(property[obj._selectedFrequency]) }}" title="April price breakdown"/>
			</div>
	{{ } else { }}
		{{ if(!showPriceAndFrequency(premium[obj._selectedFrequency]) || !showAltPremium) { }}
			<div class="price-breakdown-wrapper hidden-xs">
				<health_v4:price_breakdown_accordion id="price-breakdown-accordion-single" hidden="false" title="Current price breakdown"/>
			</div>
		{{ } }}
	{{ } }}
	</div>
</script>
