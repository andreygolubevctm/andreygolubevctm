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
	{{ var lhcText = meerkat.site.isCallCentreUser ? 'pricing' : 'lhcfreepricing'; }}
	{{ var currFreq = obj._selectedFrequency === 'annually' ? 'annual' : obj._selectedFrequency; }}

	{{ if (!_.isUndefined(alternatePremium)) { }}
		{{ var productPremium = alternatePremium }}
		{{ comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0))  ? '' : 'comingsoon' }}
	{{ } }}
	<div class="dual-pricing-container {{ if (obj.dropDatePassed === true) { }}dropDatePassed{{ } }} {{= comingSoonClass }}">
		<div class="row current-pricing">
			<div class="col-sm-4">
				<h3>Current <span class="current-frequency">{{= currFreq }}</span> price</h3>
				<span class="applyBy">Must apply by <span class="text-bold">{{= obj.dropDeadDateFormatted }}</span></span>
			</div>
			<div class="col-sm-5">
				{{= renderedPriceTemplate }}
				{{ if (!_.isUndefined(obj.premium[obj._selectedFrequency][lhcText])) { }}
				<div class="lhcText">{{= obj.premium[obj._selectedFrequency][lhcText] }}</div>
				{{ } }}
			</div>
			<div class="col-sm-3 btn-container">
				<a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Apply Online<span class="icon-arrow-right" /></a>
			</div>
		</div>

		<div class="row april-pricing premium-rising-tag">
			<div class="premium-rising"><span class="icon-arrow-thick-up"></span> Premiums are rising from April 1st, 2017</div>
			{{= renderedAltPriceTemplate }}
			{{ if (comingSoonClass === '' && !_.isUndefined(obj.altPremium[obj._selectedFrequency]) && !_.isUndefined(obj.altPremium[obj._selectedFrequency][lhcText])) { }}
			<div class="lhcText">{{= obj.altPremium[obj._selectedFrequency][lhcText] }}</div>
			{{ } }}
			<a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a>
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
					<div class="dual-pricing-before-after-text"><span class="text-bold">Before</span> April 1st</div>
					{{= renderedPriceTemplate }}

					<div>Current <span class="current-frequency">{{= currFreq }}</span> price</div>
					<span class="applyBy">Must apply by <span class="text-bold">{{= obj.dropDeadDateFormatted }}</span></span>
				</div>
				<div class="current-pricing-details">
					{{ if (!_.isUndefined(obj.premium[obj._selectedFrequency][lhcText])) { }}
					<span>{{= obj.premium[obj._selectedFrequency][lhcText] }}</span>
					{{ } }}
				</div>
			</div>
			<div class="col-xs-6 april-container">
				<div class="april-pricing">
					<div class="dual-pricing-before-after-text"><span class="text-bold">After</span> April 1st</div>
					{{= renderedAltPriceTemplate }}
					<span class="premiumsRising">Premiums are rising<br/> from April 1st</span>
					<a href="javascript:;" class="dual-pricing-learn-more" data-dropDeadDate="{{= obj.dropDeadDate }}">Learn more</a>
				</div>
				<div class="april-pricing-details">
					{{ if (comingSoonClass === '') { }}
						<span>{{= obj.altPremium[obj._selectedFrequency][lhcText] }}</span>
					{{ } }}
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