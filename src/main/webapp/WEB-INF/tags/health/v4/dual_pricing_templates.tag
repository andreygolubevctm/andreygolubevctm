<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Dual pricing templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<c:set var="thisYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>

<core_v1:js_template id="price-frequency-template">
	If you elect to pay your premium {{= frequency }}, only payments made by {{= pricingDateFormatted }} will be at the current amount, thereafter the new premium will apply.
</core_v1:js_template>

<core_v1:js_template id="price-congratulations-template">
	<div class="price-congratulations-copy">
		<h4>Congratulations</h4>
		<p>Paying annually means you will save <span class="priceSaved">{{= priceSaved }}!</span> You must choose a payment date before <span class="text-bold">{{= pricingDateFormatted }}</span> to lock in this premium.</p>
	</div>
</core_v1:js_template>

<core_v1:js_template id="sideBarFrequency">
	{{ if (obj.frequency !== 'annually') { }}
	<h5 class="heading">If you pay {{= obj.frequency }} before {{= obj.dropDeadDateFormatted }}:</h5>
	<p><span class="title">First Premium:</span> {{= obj.firstPremium}}</p>
	<p><span class="title">Remaining Premiums:</span> {{= obj.remainingPremium}}</p>
	{{ } else { }}
	<h5 class="heading">If you pay your annual premium before {{= obj.dropDeadDateFormatted }}:</h5>
	<p><span class="title">Premium:</span> {{= obj.firstPremium}}</p>
	{{ } }}
</core_v1:js_template>

<c:set var="heading">Premiums are rising April 1</c:set>
<c:set var="april1Header">from April 1st</c:set>

<%-- RESULTS TEMPLATES --%>
<core_v1:js_template id="dual-pricing-results-template">
	{{ var comingSoonClass = ''; }}
	{{ if (!_.isUndefined(obj.altPremium[obj._selectedFrequency])) { }}
		{{ var productPremium = obj.altPremium[obj._selectedFrequency] }}
		{{ comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon' }}
	{{ } }}
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }} {{= comingSoonClass }}">
		<div class="april-pricing">
			<div class="altPriceContainer">
				{{= renderedAltPriceTemplate }}
			</div>
		</div>
	</div>
</core_v1:js_template>

<%-- MORE INFO TEMPLATES --%>
<core_v1:js_template id="dual-pricing-moreinfo-template">
	{{ var comingSoonClass = ''; }}
	{{ var alternatePremium = obj.altPremium[obj._selectedFrequency]; }}
	{{ var currFreq = obj._selectedFrequency === 'annually' ? 'annual' : obj._selectedFrequency; }}

	{{ if (!_.isUndefined(alternatePremium)) { }}
		{{ var productPremium = alternatePremium }}
		{{ comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon' }}
	{{ } }}
	<div class="dual-pricing-container">
		<div class="hidden-xs moreInfoPricingDual">
			<div class="moreInfoPriceWrapper">
				<div class="moreInfoPriceContainer">
					<div class="moreInfoPriceHeading">NOW</div>
					<div class="moreInfoPrice">
						{{= renderedPriceTemplate }}
					</div>
				</div>
			</div>
			<div class="moreInfoPriceWrapper">
				<div class="moreInfoPriceContainer">
					<div class="moreInfoPriceHeading">PRICE FROM April 1</div>
					<div class="moreInfoPrice">
						{{= renderedAltPriceTemplate }}
					</div>
				</div>
				{{ if (obj.showAltPremium === true) { }}
				<div class="rateRiseDisclaimer">*Prices are changing due to the Government rate rise</div>
				{{ } }}
			</div>
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-moreinfo-affixed-header-template">
	<div class="row">
		<div class="col-xs-6">
			{{= renderedAffixedHeaderPriceTemplate }}
		</div>
		<div class="col-xs-6">
			{{= renderedAltAffixedHeaderPriceTemplate }}
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-moreinfo-xs-template">
	{{ var comingSoonClass = ''; }}
	{{ var lhcText = meerkat.site.isCallCentreUser ? 'pricing' : 'lhcfreepricing'; }}
	{{ var currFreq = obj._selectedFrequency === 'annually' ? 'annual' : obj._selectedFrequency; }}

	{{ if (!_.isUndefined(obj.altPremium[obj._selectedFrequency])) { }}
		{{ var productPremium = obj.altPremium[obj._selectedFrequency] }}
		{{ comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon' }}
	{{ } }}
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }} {{= comingSoonClass }}">
		<div class="row">
			<div class="col-xs-6 current-container">
				<div class="current-pricing">
					<div class="dual-pricing-before-after-text">Now</div>
					{{= renderedPriceTemplate }}

					<div><span class="current-frequency">{{= currFreq }}</span></div>
				</div>
			</div>
			<div class="col-xs-6 april-container">
				<div class="april-pricing">
					<div class="dual-pricing-before-after-text">Price after April 1</div>
					{{= renderedAltPriceTemplate }}
					<div><span class="current-frequency">{{= currFreq }}</span></div>
				</div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-template-sidebar">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="current-pricing">
			{{= priceBreakdownLHCCopy }}
			{{= renderedPriceTemplate }}
		</div>
		<hr />
		<div class="april-pricing">
			{{= renderedAltPriceTemplate }}
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-application-xs-template">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="current-pricing">
			{{= renderedPriceTemplate }}
		</div>
		<div class="premium-rising-tag">Premiums are rising from April 1st, 2017 <a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a></div>
	</div>
</core_v1:js_template>
