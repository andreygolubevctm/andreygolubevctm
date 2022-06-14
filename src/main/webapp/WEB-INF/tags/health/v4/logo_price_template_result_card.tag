<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- PRICE TYPE, VALUE AND FREQUENCY TEMPLATE FOR RESULT CARD- --%>
<script id="logo-price-template-result-card" type="text/html">
	{{ var priceTemplateVars = meerkat.modules.healthDualPricing.getDualPricingVarsForLogoPriceTemplateResultCard(obj, premium, altPremium); }}
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }} {{= priceTemplateVars.comingSoonClass }}">
		<div class="raterisemonth-pricing {{= (priceTemplateVars.showFromDate === true ? 'blue-background' : 'grey-background') }}">
			{{ if(priceTemplateVars.showFromDate === true && obj.isForResultPage === true) { }}
			<div class="dual-pricing-before-after-text">
				From {{= priceTemplateVars.dualPricingDateFormatted }}
			</div>
			{{ } }}
			<div class="altPriceContainer">
				{{ if (!obj.hasOwnProperty('premium')) {return;} }}
				<%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
				{{ var property = premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true && !_.isNull(priceTemplateVars.dualPricingDate)) { property = altPremium; } }}
				{{ var frequencyAndLHCData = []; }}
				{{ if(typeof obj.displayLogo === 'undefined' || obj.displayLogo == true) { }}
					<div class="companyLogo {{= info.provider ? info.provider : info.fundCode }}"></div>
				{{ } }}
				<div class="price-wrapper">
					{{ if(typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true && !_.isNull(priceTemplateVars.dualPricingDate)) { }}
						<div class="dual-pricing-before-after-text">
							<span class="text-bold">
								{{ priceTemplateVars.currentPriceOrFromApril }}
							</span>
						</div>
					{{ } }}
					<div class="price premium">
						{{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
							{{ if (typeof property[freq] !== "undefined") { }}
								{{ freqVars = meerkat.modules.healthDualPricing.getDualPricingVarsForLogoPriceTemplateResultCardForFrequency(obj, freq, property, mode); }}
								<%-- grab data for "frequency / lhc text" display as we need to render it in a separate line now --%>
								{{ frequencyAndLHCData.push({freq: freq, selectedFrequency: obj._selectedFrequency, priceText: freqVars.priceText, priceLhcfreetext: freqVars.priceLhcfreetext, premium: freqVars.premium, lhtText: freqVars.lhtText, textLhcFreeDualPricing: freqVars.textLhcFreeDualPricing, textLhcFreePricing: freqVars.textLhcFreePricing}); }}
								<div class="frequency {{=freq}} {{= obj._selectedFrequency === freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= freqVars.priceText }}" data-lhcfreetext="{{= freqVars.priceLhcfreetext }}">
									{{ if (freqVars.showPriceOrComingSoon && !_.isNull(priceTemplateVars.dualPricingDate)) { }}
										<span class="frequencyAmount">
											<span class="dollarSign">$</span>{{=  freqVars.premiumSplitDollars }}<span class="cents">.{{= freqVars.premiumSplitCents }}</span>
										</span>
										{{ if (freqVars.renderPriceBreakdown) { }}
											{{= meerkat.modules.healthPriceBreakdown.renderTemplate(freqVars.availablePremiums, freq, obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) }}
										{{ } }}
									{{ } else { }}
										<div class="frequencyAmount comingSoon-results">New price not yet released</div>
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
							{{= meerkat.modules.healthDualPricing.getFrequencyName(data.freq, " / ") }}
						</span>
						{{ if ((!obj.hasOwnProperty('priceBreakdown') || (obj.hasOwnProperty('priceBreakdown') && !obj.priceBreakdown)) || window.meerkat.modules.journeyEngine.getCurrentStep().navigationId !=='payment' ) { }}
							<div class="lhcText">
								{{ if (priceTemplateVars.isDualPricingActive && !_.isNull(priceTemplateVars.dualPricingDate)) { }}
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
