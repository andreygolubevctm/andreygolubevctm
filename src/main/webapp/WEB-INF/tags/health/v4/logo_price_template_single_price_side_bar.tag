<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE FOR SIDE BAR ON APPLICATION AND PAYMENT PAGES WHEN DUAL PRICING IS OFF--%>
<script id="logo-price-template-single-price-side-bar" type="text/html">
	{{ var showAltPremium = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true; }}
	{{ var property = premium; }}
	{{ if (showAltPremium) { property = altPremium; } }}
	{{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
		{{ if(typeof property[freq] !== "undefined") { }}
			{{ var premium = property[freq]; }}
		{{ } }}
	{{ }); }}
	{{ var formatCurrency = meerkat.modules.currencyField.formatCurrency }}
	{{ var isPaymentPageOrConfirmation = (meerkat.modules.journeyEngine.getCurrentStep() === null || meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment'); }}
	{{ var showRoundingMessage = typeof showRoundingText !== 'undefined' && showRoundingText === true; }}
	{{ function showPriceAndFrequency(premium) { return ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)); } }}



	<div class="single-price-side-bar-header">
		<h1>Your quote details</h1>
		<health_v4_results:quoteref_template />
	</div>
	<div class="dual-pricing-container dual-pricing-off-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="companyLogo {{= info.provider ? info.provider : info.fundCode }}"></div>
		<h5 class="name">{{= ((obj.info.providerName ? obj.info.providerName : obj.info.fundName) + " " + obj.info.name) }}</h5>
		<div class="resultInsert">
			<health_v4:abd_badge_with_link_and_lhc />
		</div>
		<div class="price-boxes-wrapper">
			<div class="current-pricing">
				<div class="comingsoon">
					<div class="background-wrapper grey-background v4-logo-price-template-single-price-side-bar-tag">
							<div class="altPriceContainer">
								{{ if (!obj.hasOwnProperty('premium')) {return;} }}
								<%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
								{{ var property = premium; if (showAltPremium) { property = altPremium; } }}
								{{ var frequencyAndLHCData = []; }}
								<div class="price-wrapper">
									<div class="price premium">
										{{ _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){ }}
											{{ if (typeof property[freq] !== "undefined") { }}
												{{ var premium = property[freq] }}
												{{ var availablePremiums = showAltPremium ? obj.altPremium : obj.premium; }}
												{{ var priceText = premium.text ? premium.text : formatCurrency(premium.payableAmount) }}
												{{ if(!isPaymentPageOrConfirmation) { }}
													{{ priceText = premium.lhcfreetext; }}
												{{ } }}
												{{ var priceLhcfreetext = premium.lhcfreetext ? premium.lhcfreetext : formatCurrency(premium.lhcFreeAmount) }}
												{{ var textLhcFreeDualPricing = 'inc ' + formatCurrency(premium.rebateValue) + ' Govt Rebate'; }}
												{{ var textPricing = premium.pricing ? premium.pricing : 'Includes rebate of ' + formatCurrency(premium.rebateAmount) + ' & LHC loading of ' + formatCurrency(premium.lhcAmount) }}
												{{ var showABDToolTip = premium.abd > 0; }}
												{{ var lhtText = premium.lhcfreepricing ? premium.lhcfreepricing.split("<br>")[0] : ''; }}
												{{ var textLhcFreePricing = premium.lhcfreepricing ? premium.lhcfreepricing : '+ ' + formatCurrency(premium.lhcAmount) + ' LHC inc ' + formatCurrency(premium.rebateAmount) + ' Government Rebate' }}

												<%-- grab data for "frequency / lhc text" display as we need to render it in a separate line now --%>
												{{ frequencyAndLHCData.push({freq: freq, selectedFrequency: obj._selectedFrequency, priceText: priceText, priceLhcfreetext: priceLhcfreetext, premium: premium, lhtText: lhtText, textLhcFreeDualPricing: textLhcFreeDualPricing, textLhcFreePricing: textLhcFreePricing}); }}
												<div class="frequency {{=freq}} {{= obj._selectedFrequency === freq.toLowerCase() ? '' : 'displayNone' }}" data-text="{{= priceText }}" data-lhcfreetext="{{= priceLhcfreetext }}">
														<span class="frequencyAmount">
																		{{ var premiumSplit = (typeof mode === "undefined" || mode != "lhcInc" ? priceLhcfreetext : priceText) }}
																		{{ premiumSplit = premiumSplit.split(".") }}
																		<span class="dollarSign">$</span>{{=  premiumSplit[0].replace('$', '') }}<span class="cents">.{{= premiumSplit[1] }}</span>
																		</span>
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
													{{= meerkat.modules.healthDualPricing.getFrequencyName(data.freq, " / ") }}
												</span>
												<div class="lhcText">
													<span>{{= data.textLhcFreePricing.split(".<br>")[0] }}</span>
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
				<div class="price-breakdown-wrapper hidden-xs">
					<health_v4:price_breakdown_accordion id="price-breakdown-accordion-single-price" hidden="false" title="Price breakdown"/>
				</div>
			</div>
		</div>
		<health_v4:price_details_side_bar_single_price/>
		<div class="about-this-product-link hidden-md hidden-sm hidden-xs">
			<a href="javascript:;" class="about-this-fund">About this fund</a>
		</div>
	</div>
</script>
