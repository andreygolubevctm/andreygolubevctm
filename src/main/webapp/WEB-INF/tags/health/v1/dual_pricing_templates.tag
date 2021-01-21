<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Dual pricing templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<c:set var="thisYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>

<core_v1:js_template id="price-frequency-template">
	<c:set var="dialogueText">
		{{ var altPremiumText = altPremium === '$0.00' ? 'at the higher premium' : altPremium; }}
		You've chosen to pay {{= frequency }}, which means premiums paid before April 1st will be {{= premium }} and then your ongoing premiums will be {{= altPremiumText }}
	</c:set>
	<field_v2:checkbox
			xpath="health/simples/dialogue-checkbox-dual-pricing-frequency"
			value="Y"
			required="true"
			label="true"
			errorMsg="Please confirm each mandatory dialog has been read to the client"
			className="checkbox-custom simples_dialogue-checkbox-dual-pricing-frequency"
			title="${dialogueText}" />
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
<c:set var="rateRiseDay1Header">from April 1</c:set>
<c:set var="rateRiseDay1HeaderNoSup">from April 1st</c:set>

<%-- RESULTS TEMPLATES --%>
<core_v1:js_template id="dual-pricing-results-template">
	{{ var formatCurrency = meerkat.modules.currencyField.formatCurrency }}
	{{ var prem = obj.premium[obj._selectedFrequency] }}
	{{ var textLhcFreePricing = prem.lhcfreepricing ? prem.lhcfreepricing : '+ ' + formatCurrency(prem.lhcAmount) + ' LHC inc ' + formatCurrency(prem.rebateAmount) + ' Government Rebate' }}
	{{ var textPricing = prem.pricing ? prem.pricing : 'Includes rebate of ' + formatCurrency(prem.rebateAmount) + ' & LHC loading of ' + formatCurrency(prem.lhcAmount) }}

	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="current-pricing">
			<div>
				Now
			</div>
			{{= renderedPriceTemplate }}
		</div>
		<div class="raterisemonth-pricing">
			<div>
				${rateRiseDay1Header}
			</div>
			{{= renderedAltPriceTemplate }}
		</div>
	</div>
</core_v1:js_template>

<%-- MORE INFO TEMPLATES --%>
<core_v1:js_template id="dual-pricing-moreinfo-template">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }} ">
		<div class="current-pricing">
			{{ var currFreq = obj._selectedFrequency === 'annually' ? 'annual' : obj._selectedFrequency; }}
			<h3>Now</h3>
			{{= renderedPriceTemplate }}
		</div>
		<div class="raterisemonth-pricing">
			<h3>From April 1</h3>
			{{= renderedAltPriceTemplate }}
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-moreinfo-xs-template">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
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
		<div class="raterisemonth-pricing">
			<div class="row">
				<div class="col-xs-6 priceContainer">
					<span class="heading">{{= obj._selectedFrequency }} premium<br/>${rateRiseDay1HeaderNoSup}</span>
					{{= renderedAltPriceTemplate }}
				</div>
				<div class="col-xs-6 detailsContainer">
					<span class="premiumsRising">Premiums are rising</span>
					<a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">learn more</a>
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
		<hr />
		{{ if (showAltPremium) { }}
		<div class="raterisemonth-pricing">
			{{= renderedAltPriceTemplate }}
		</div>
		{{ } }}
	</div>
</core_v1:js_template>

<core_v1:js_template id="dual-pricing-application-xs-template">
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }}">
		<div class="current-pricing">
			{{= renderedPriceTemplate }}
		</div>
		<hr />
		{{ if (showAltPremium) { }}
		<div class="raterisemonth-pricing">
			{{= renderedAltPriceTemplate }}
		</div>
		{{ } }}
	</div>
</core_v1:js_template>
