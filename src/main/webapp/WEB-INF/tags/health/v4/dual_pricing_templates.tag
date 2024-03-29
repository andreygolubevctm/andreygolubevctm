<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Dual pricing templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<c:set var="thisYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>

<core_v1:js_template id="price-frequency-template">
	If your premiums are increasing on {{= pricingDateFormatted}} and you elect to pay {{= frequency }}, only payments made by the {{= dropDeadDateFormatted}} will be at the current amount, thereafter the new premium will apply.
</core_v1:js_template>

<core_v1:js_template id="price-congratulations-template">
	<div class="price-congratulations-copy">
		<h4>Congratulations</h4>
		<p>Paying annually means you will save <span class="priceSaved">{{= priceSaved }}!</span> You must choose a payment date <span class="text-bold">{{= beforeAfterText }} {{= pricingDateFormatted }}</span> to lock in this premium.</p>
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

<%-- RESULTS TEMPLATES --%>
<core_v1:js_template id="dual-pricing-results-template">
	{{= renderedAltPriceTemplateResultCard }}
</core_v1:js_template>

<%-- MORE INFO TEMPLATES --%>
<core_v1:js_template id="dual-pricing-moreinfo-template">
	{{ var comingSoon = false; }}
	{{ var alternatePremium = obj.altPremium[obj._selectedFrequency]; }}
	{{ if (!_.isUndefined(alternatePremium)) { }}
		{{ var productPremium = alternatePremium }}
		{{ comingSoon = (productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0); }}
	{{ } }}
	<div class="dual-pricing-container">
		<div class="hidden-xs moreInfoPricingDual">
			<div class="moreInfoPriceWrapper current-price">
				<div class="moreInfoPriceContainer">
					<div class="moreInfoPriceHeading">Current price</div>
					<div class="moreInfoPrice">
						{{= renderedMoreInfoDualPricing }}
						<health_v4:abd_badge_with_link />
						<health_v4:lhcText />
					</div>
				</div>
			</div>
			<div class="moreInfoPriceWrapper">
				<div class="moreInfoPriceContainer future-price">
					<div class="moreInfoPriceHeading">Price from {{= obj.dualPricingDateWithYear}}</div>
					<div class="moreInfoPrice">
						{{= renderedAltMoreInfoDualPricing }}
						{{ if (comingSoon) {}}
							<health_v4:abd_badge_with_link />
							<health_v4:lhcText />
						{{ } }}
					</div>
				</div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-moreinfo-affixed-header-template">
	<div class="even-space-row">
		<div class="col-half">
			{{= renderedAffixedHeaderPriceTemplate }}
		</div>
		<div class="col-half">
			{{= renderedAltAffixedHeaderPriceTemplate }}
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-moreinfo-xs-template">
	{{ var comingSoon = false; }}
	{{ var alternatePremium = obj.altPremium[obj._selectedFrequency]; }}
	{{ if (!_.isUndefined(alternatePremium)) { }}
	{{ var productPremium = alternatePremium }}
	{{ comingSoon = (productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0); }}
	{{ } }}
	<div class="dual-pricing-container">
		<div class="moreInfoPricingDualMobile">
			<div class="row moreInfoPriceWrapper">
				<div class="moreInfoPriceContainer current-price">
					<div class="moreInfoPriceHeading">Current price</div>
					<div class="moreInfoPrice">
						{{= renderedMoreInfoDualPricing }}
						<health_v4:abd_badge_with_link />
						<health_v4:lhcText />
					</div>
				</div>
			</div>
			<div class="row moreInfoPriceWrapper">
				<div class="moreInfoPriceContainer future-price">
					<div class="moreInfoPriceHeading">Price from {{= obj.dualPricingDateWithYear}}</div>
					<div class="moreInfoPrice">
						{{= renderedAltMoreInfoDualPricing }}
						{{ if (comingSoon) {}}
						<health_v4:abd_badge_with_link />
						<health_v4:lhcText />
						{{ } }}
					</div>
				</div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-template-sidebar">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="logo-name-lhc-abd-container">
			<div class="companyLogo {{= info.provider ? info.provider : info.fundCode }}"></div>
			<h5 class="name">{{= ((obj.info.providerName ? obj.info.providerName : obj.info.fundName) + " " + obj.info.name) }}</h5>
			<div class="resultInsert">
				<health_v4:abd_badge_with_link_and_lhc />
			</div>
		</div>
		<div class="price-boxes-wrapper">
			{{= renderedPriceTemplateSideBar }}
			{{ if (meerkat.modules.healthDualPricing.validateAndGetDualPricingDate(obj)) { }}
				{{= renderedAltPriceTemplateSideBar }}
			{{ } }}
		</div>
			<health_v4:price_details_side_bar/>
		<div class="about-this-product-link hidden-xs">
			<a href="javascript:;" class="about-this-fund">About this fund</a>
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-application-xs-template">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="current-pricing">
			{{= renderedPriceTemplate }}
		</div>
		<div class="raterisemonth-pricing">
			{{= renderedAltPriceTemplate }}
		</div>
	</div>
</core_v1:js_template>
