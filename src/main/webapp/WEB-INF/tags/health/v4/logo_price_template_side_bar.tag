<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- PRICE TEMPLATE FOR SIDE BAR ON APPLICATION AND PAYMENT PAGES WHEN DUAL PRICING IS ON AND PROVUDER HAS DUAL PRICING DATE V4 --%>
<script id="logo-price-template-side-bar" type="text/html">
	{{ var sideBarVars = meerkat.modules.healthDualPricing.getDualPricingVarsForSideBar(obj, premium, altPremium); }}
	{{ var showTextBeforePrice = (typeof obj.hasOwnProperty('showBeforeAfterText') && obj.showBeforeAfterText === true && (!sideBarVars.showAltPremium || obj.showFromDate)); }}
	<div class="{{= sideBarVars.showAltPremium ? !sideBarVars.showPriceAndFrequency(sideBarVars.property[obj._selectedFrequency]) ? 'raterisemonth-pricing altPriceContainer-with-padding centralized-single-item' : 'raterisemonth-pricing' : 'current-pricing' }}">
		{{ if(sideBarVars.showAltPremium && sideBarVars.showPriceAndFrequency(sideBarVars.property[obj._selectedFrequency])) { }}
		<div class="price-rise-banner-side-bar {{= sideBarVars.showPriceAndFrequency(sideBarVars.property[obj._selectedFrequency]) ? '' : 'grey-background'}} hidden-xs">
			<health_v4_results:price_rise_banner showHelpIcon="false" textType="rateRiseBannerSideBar" isHiddenByDefault="false"/>
		</div>
		{{ } }}

		<div class="{{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }} {{= sideBarVars.comingSoonClass }}">
			<div class="background-wrapper {{= (sideBarVars.showAltPremium && sideBarVars.showPriceAndFrequency(sideBarVars.property[obj._selectedFrequency]))? 'blue-background' : 'grey-background' }}">
				<div class="altPriceContainer">
					{{ if (!obj.hasOwnProperty('premium')) {return;} }}
					<%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
					{{ var property = premium; if (sideBarVars.showAltPremium) { property = altPremium; } }}
					{{ var frequencyAndLHCData = []; }}
					<div class="price-wrapper {{= (!showTextBeforePrice ? 'center-content' : '') }}">
						{{ if(showTextBeforePrice) { }}
						<div class="dual-pricing-before-after-text">
						<span class="text-bold">
							{{ if (sideBarVars.showAltPremium) { }}
								From {{=obj.dualPricingDateFormatted}}
							{{ } else { }}
								Current price
							{{ } }}
						</span>
						</div>
						{{ } }}

						<div class="price premium {{= (showTextBeforePrice ? '' : 'full-width') }}">

							{{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
							{{ if (typeof property[freq] !== "undefined") { }}
							{{ var sideBarVarsFreq = meerkat.modules.healthDualPricing.getDualPricingVarsForSideBarForFreq(obj, freq, sideBarVars.isPaymentPageOrConfirmation, property, sideBarVars.showAltPremium); }}
							<%-- grab data for "frequency / lhc text" display as we need to render it in a separate line now --%>
							{{ frequencyAndLHCData.push({freq: freq, selectedFrequency: obj._selectedFrequency, priceText: sideBarVarsFreq.priceText, priceLhcfreetext: sideBarVarsFreq.priceLhcfreetext, premium: sideBarVarsFreq.premium, lhtText: sideBarVarsFreq.lhtText, textLhcFreeDualPricing: sideBarVarsFreq.textLhcFreeDualPricing, textLhcFreePricing: sideBarVarsFreq.textLhcFreePricing}); }}
							<div class="frequency {{=freq}} {{= obj._selectedFrequency === freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= sideBarVarsFreq.priceText }}" data-lhcfreetext="{{= sideBarVarsFreq.priceLhcfreetext }}">
								{{ if (sideBarVars.showPriceAndFrequency(sideBarVarsFreq.premium)) { }}
								<span class="frequencyAmount">
														{{ var premiumSplit = (typeof mode === "undefined" || mode != "lhcInc" ? sideBarVarsFreq.priceLhcfreetext : sideBarVarsFreq.priceText) }}
														{{ premiumSplit = premiumSplit.split(".") }}
														<span class="dollarSign">$</span>{{=  premiumSplit[0].replace('$', '') }}<span class="cents">.{{= premiumSplit[1] }}</span>
														</span>
								{{ } else { }}
								<div class="new-price-not-yet-released">
									<div class="frequencyAmount comingSoon-results">New price not yet released</div>
								</div>
								{{ } }}
								{{ if (sideBarVars.showRoundingMessage) { }}
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
					{{ if (sideBarVars.showPriceAndFrequency(data.premium)) { }}
					<div class="line-break"></div>
					<div class="hide-on-affix">
								<span class="frequencyTitle">
									{{= meerkat.modules.healthDualPricing.getFrequencyName(data.freq, " / ") }}
								</span>
						<div class="lhcText">
							{{ if (sideBarVars.isDualPricingActive) { }}
							<span>{{= data.textLhcFreeDualPricing}}</span>
							{{ } else { }}
							<span>{{= data.textLhcFreePricing.split(".<br>")[0] }}</span>
							{{ } }}
						</div>
					</div>
					{{ } }}
					{{ if (sideBarVars.showRoundingMessage) { }}
					<div class="rounding">Premium may vary slightly due to rounding</div>
					{{ } }}
				</div>
				{{ }); }}
			</div>
		</div>
		{{ if(sideBarVars.showAltPremium && sideBarVars.showPriceAndFrequency(sideBarVars.property[obj._selectedFrequency])) { }}
		<div class="price-breakdown-wrapper hidden-xs">
			<health_v4:price_breakdown_accordion id="price-breakdown-accordion-dual" hidden="{{= sideBarVars.showAltPremium && !sideBarVars.showPriceAndFrequency(sideBarVars.property[obj._selectedFrequency]) }}" title="{{= obj.dualPricingDateOnlyMonth}} price breakdown"/>
		</div>
		{{ } else if(!sideBarVars.showAltPremium && showTextBeforePrice ){ }}
		<div class="price-breakdown-wrapper hidden-xs">
			<health_v4:price_breakdown_accordion id="price-breakdown-accordion-single" hidden="false" title="Current price breakdown"/>
		</div>
		{{ } else if(!sideBarVars.showAltPremium && !showTextBeforePrice){ }}
		<div class="price-breakdown-wrapper hidden-xs">
			<health_v4:price_breakdown_accordion id="price-breakdown-accordion-single" hidden="false" title="Price breakdown"/>
		</div>
		{{ } }}
	</div>
</script>
