<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Dual pricing templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<c:set var="thisYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>

<core_v1:js_template id="price-frequency-template">
	If you elect to pay your premium {{= frequency }}, only payments made by {{= pricingDateFormatted }} will be at the current amount, thereafter the new premium will apply.
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
<c:set var="april1Header">from April 1<sup>st</sup></c:set>
<c:set var="april1HeaderNoSup">from April 1st</c:set>

<%-- RESULTS TEMPLATES --%>
<core_v1:js_template id="dual-pricing-results-template">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="april-pricing">
			<div class="altPriceContainer">
				{{= renderedAltPriceTemplate }}
			</div>
			<div class="altPriceDetailsContainer">
				<span class="deadline">${april1Header}</span>
				<a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">learn more</a>
			</div>
		</div>
		<div class="current-pricing">
			{{= renderedPriceTemplate }}
		</div>
	</div>
</core_v1:js_template>

<%-- MORE INFO TEMPLATES --%>
<core_v1:js_template id="dual-pricing-moreinfo-template">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }} ">
		<div class="april-pricing">
			<h3>${april1HeaderNoSup}</h3>
			{{= renderedAltPriceTemplate }}
			<span class="premiumsRising">Premiums are rising</span>
			<a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">learn more</a>
		</div>
		<div class="current-pricing">
			<h3>Current {{= obj._selectedFrequency }} Pricing</h3>
			{{= renderedPriceTemplate }}
			<span class="applyBy">Apply by {{= obj.dropDeadDateFormatted }}</span>
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-moreinfo-xs-template">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="april-pricing">
			<div class="row">
				<div class="col-xs-6 priceContainer">
					<span class="heading">${april1HeaderNoSup}</span>
					{{= renderedAltPriceTemplate }}
				</div>
				<div class="col-xs-6 detailsContainer">
					<span class="premiumsRising">Premiums are rising</span>
					<a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">learn more</a>
				</div>
			</div>
		</div>
		<div class="current-pricing">
			<div class="row">
				<div class="col-xs-6 priceContainer">
					<span class="heading">Current Price</span>
					{{= renderedPriceTemplate }}
				</div>
				<div class="col-xs-6 detailsContainer">
					<span class="applyBy">Apply by {{= obj.dropDeadDateFormatted }}</span>
				</div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-template-sidebar">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="current-pricing">
			{{= renderedPriceTemplate }}
		</div>
		<div class="down-arrow"></div>
		<div class="april-pricing">
			<p>Premiums are rising</p>
			{{= renderedAltPriceTemplate }}
			<p>from {{= pricingDateFormatted }}</p>
		</div>
	</div>
</core_v1:js_template>