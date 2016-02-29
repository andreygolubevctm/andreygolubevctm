<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Dual pricing templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup variables needed for dual pricing --%>
<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />

<jsp:useBean id="now" class="java.util.Date" />
<c:set var="thisYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>

<core_v1:js_template id="price-frequency-template">
	<content:get key="frequencyWarning"/>
</core_v1:js_template>

<%-- Working on the assumption there's going to be text changes so put this in the db --%>
<core_v1:js_template id="more-info-why-price-rise-template">
	<content:get key="moreInfoWhyPricesRising"/>
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

<c:set var="note">You must purchase before {{= obj.dropDeadDateFormatted }}.</c:set>
<c:set var="heading">Premiums are rising April 1</c:set>
<c:set var="whyPremiumsRising"><a href="javascript:;" class="why-rising-premiums">Why are premiums rising?</a></c:set>
<c:set var="april1Header">Pricing on 1 April ${thisYear}</c:set>

<core_v1:js_template id="dual-pricing-template">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="current-pricing">
			<h2>${heading}</h2>
			${whyPremiumsRising}
			<h3>Current Pricing</h3>
			{{= renderedPriceTemplate }}
			<div class="note hidden-xs">${note}</div>
		</div>
		<div class="dual-pricing-border"></div>
		<div class="april-pricing">
			<h3>${april1Header}</h3>
			{{= renderedAltPriceTemplate }}
		</div>
		<div class="why-rising-premiums-container hidden-md hidden-lg">${whyPremiumsRising}</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-template-sm">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="heading-row">
			<h2>${heading}</h2>
			${whyPremiumsRising}
		</div>
		<div class="pricing-row">
			<div class="current-pricing">
				<h3>Current Pricing</h3>
				{{= renderedPriceTemplate }}
			</div>
			<div class="icon icon-arrow-thick-right"></div>
			<div class="april-pricing">
				<h3>${april1Header}</h3>
				{{= renderedAltPriceTemplate }}
			</div>
		</div>
		<div class="note">${note}</div>
	</div>
	<div class="col-sm-12 insureNowContainer">
		<div class="insureNow">
			<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}">Get Insured Now<span class="icon-arrow-right" /></a>
		</div>
		<h3 class="text-dark">Need help? Call <span class="text-secondary">${callCentreNumber}</span></h3>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-template-xs">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="current-pricing">
			<h3>Current Pricing</h3>
			{{= renderedPriceTemplate }}
		</div>
		<div class="promo">
			{{ if (promo.promoText !== ''){ }}
			<h2>Buy now and benefit from these promotions</h2>
			<p>{{= promo.promoText }}</p>
			{{ } }}
		</div>
		<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}">Get Insured Now<span class="icon-arrow-right" /></a>
		<h3>Need help? Call <span class="text-secondary">${callCentreNumber}</span></h3>
		<hr />
		<h2>${heading}</h2>
		<div class="april-pricing">
			<h3>${april1Header} will be</h3>
			{{= renderedAltPriceTemplate }}
		</div>
		<div class="note">${note}</div>
		${whyPremiumsRising}
	</div>
</core_v1:js_template>