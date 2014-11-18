<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- The following are hidden fields used by filters --%>
<field:hidden xpath="quote/paymentType" defaultValue="annual" />
<field:array_select
	items="annual=Annual,monthly=Monthly"
	xpath="filter/paymentType"
	title=""
	required=""
	className="hidden" />

<field:hidden xpath="quote/excess" />
<field:hidden xpath="quote/baseExcess" constantValue="${contentService.getContentValue(pageContext.getRequest(), 'defaultExcess')}" />
<field:additional_excess
	increment="100"
	minVal="400"
	xpath="filter/excessOptions"
	maxCount="17"
	title=""
	required=""
	omitPleaseChoose="N"
	className="hidden" />

<car:results_filterbar_xs />



<%-- Get data to build sections/categories/features --%>
<jsp:useBean id="resultsService" class="com.ctm.services.results.ResultsService" scope="request" />
<c:set var="resultTemplateItems" value="${resultsService.getResultsPageStructure('car_')}" scope="request"  />
<c:set var="jsonString" value="${resultsService.getResultItemsAsJsonString('car_', 'category')}" scope="request"  />
<script>
	var resultLabels = ${jsonString};
</script>



<div class="resultsHeadersBg">
</div>

<agg_new_results:results vertical="${pageSettings.getVerticalCode()}">

	<car:more_info />

<%-- RESULTS TABLE --%>
	<div class="bridgingContainer"></div>
	<div class="resultsContainer v2 results-columns-sm-3 results-columns-md-3 results-columns-lg-5">
		<div class="featuresHeaders featuresElements">
			<div class="result headers">

				<div class="resultInsert controlContainer">
					<div class="expand-collapse-toggle small hidden-xs">
						<a href="javascript:;" class="expandAllFeatures">Expand All</a> / <a href="javascript:;" class="collapseAllFeatures active">Collapse All</a>
					</div>
				</div>

			</div>

			<%-- Feature headers --%>
			<div class="featuresList featuresTemplateComponent">
				<c:forEach items="${resultTemplateItems}" var="selectedValue" varStatus="status">
					<features:resultsItem item="${selectedValue}" labelMode="true" index="${status.index}" />
				</c:forEach>
			</div>
		</div>

		<div class="resultsOverflow">
			<div class="results-table"></div>
		</div>

		<core:clear />

		<div class="featuresFooterPusher"></div>
	</div>

<%-- DEFAULT RESULT ROW --%>
<core:js_template id="result-template">
	{{ var productTitle = (typeof obj.headline !== 'undefined' && typeof obj.headline.name !== 'undefined') ? obj.headline.name : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.headline !== 'undefined' && typeof obj.headline.des !== 'undefined') ? obj.headline.des : 'Unknown product name'; }}
	{{ var promotionText = (typeof obj.headline !== 'undefined' && typeof obj.headline.feature !== 'undefined' && obj.headline.feature.length > 0) ? obj.headline.feature : ''; }}
	{{ var offerTermsContent = (typeof obj.headline !== 'undefined' && typeof obj.headline.terms !== 'undefined' && obj.headline.terms.length > 0) ? obj.headline.terms : ''; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}

	{{ var template = $("#monthly-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var monthlyPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $("#annual-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var annualPriceTemplate = htmlTemplate(obj); }}

	<div class="result-row result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="Y">
		<div class="result">

			<div class="resultInsert featuresMode">
				<div class="productSummary results hidden-xs">
					<div class="compare-toggle-wrapper">
						<input type="checkbox" class="compare-tick" data-productId="{{= obj.productId }}" id="features_compareTick_{{= obj.productId }}" />
						<label for="features_compareTick_{{= obj.productId }}"></label>
						<label for="features_compareTick_{{= obj.productId }}" class="compare-label"></label>
					</div>
					{{= logo }}
					{{= annualPriceTemplate }}
					{{= monthlyPriceTemplate }}
					<a class="btn btn-primary btn-cta btn-block btn-more-info" href="javascript:;" data-productId="{{= obj.productId }}">More Info & Apply <span class="icon icon-arrow-right" /></a>
				</div>
				<div class="productSummary results visible-xs">
					{{= logo }}
					<h2 class="productTitle">{{= productTitle }}</h2>
					<a class="btn btn-primary btn-cta btn-block btn-more-info" href="javascript:;" data-productId="{{= obj.productId }}">More Info <span class="icon icon-arrow-right" /></a>
				</div>
			</div>

			<div class="resultInsert priceMode">
				<div class="row">
					<div class="col-xs-3 col-sm-7 col-md-6">
						{{= logo }}
						<div class="compare-toggle-wrapper">
							<input type="checkbox" class="compare-tick" data-productId="{{= obj.productId }}" id="price_compareTick_{{= obj.productId }}" />
							<label for="price_compareTick_{{= obj.productId }}"></label>
							<label for="price_compareTick_{{= obj.productId }}" class="compare-label"></label>
						</div>
						<h2 class="hidden-xs productTitle">{{= productTitle }}</h2>

						<p class="description hidden-xs hidden-sm">{{= productDescription }}</p>

						{{ if (promotionText.length > 0) { }}
						<div class="promotion visible-sm">
							<span class="icon icon-trophy"></span> {{= promotionText }}
							{{ if (offerTermsContent.length > 0) { }}
								<a class="small offerTerms" href="javascript:;">Offer terms</a>
								<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
							{{ } }}
						</div>
						{{ } }}

						{{ if (typeof obj.features !== 'undefined' && typeof obj.features.conditions !== 'undefined' && obj.features.conditions.value.length > 0) { }}
							<p class="specialConditions hidden-xs"><small>Special conditions: {{= obj.features.conditions.value }}</small></p>
						{{ } }}
					</div>
					<div class="col-xs-9 col-sm-4 col-sm-offset-1 col-md-offset-0 col-md-6">
						<div class="row">
							<div class="col-xs-6 col-xs-push-6 col-sm-push-0 col-md-3 excess">
								<div class="excessAmount">{{= '$' }}{{= obj.excess.total }}</div>
								<div class="excessTitle">Excess</div>
							</div>
							<div class="col-xs-6 col-xs-pull-6 col-sm-pull-0 col-md-4 col-lg-5 price">
								{{= annualPriceTemplate }}

								{{= monthlyPriceTemplate }}

								<div class="excessAndPrice hidden priceNotAvailable">
									<span class="frequencyName">Monthly</span> payment is not available for this product.
								</div>
							</div>
							<div class="col-xs-12 col-md-5 col-lg-4 hidden-xs">
								<a class="btn btn-primary btn-cta btn-block btn-more-info" href="javascript:;" data-productId="{{= obj.productId }}">More Info & Apply <span class="icon icon-arrow-right" /></a>
							</div>
						</div>
						{{ if (promotionText.length > 0) { }}
						<div class="promotion hidden-sm">
							<span class="icon icon-trophy"></span> {{= promotionText }}
							{{ if (offerTermsContent.length > 0) { }}
								<a class="small hidden-xs offerTerms" href="javascript:;">Offer terms</a>
								<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
							{{ } }}
						</div>
						{{ } }}

						{{ if (typeof obj.conditions !== 'undefined' && typeof obj.conditions.condition !== 'undefined' && obj.conditions.condition.length > 0) { }}
						<div class="specialConditions visible-xs">
							<small class="visible-xs">Special conditions apply</small>
						</div>
						{{ } }}
					</div>
				</div><%-- /row --%>
			</div><%-- /resultInsert --%>

		</div>

		<%-- The following block is some hacks for XS --%>
		<div class="fakeFeatures featuresMode featuresElements hidden-sm hidden-md hidden-lg">
			<div class="cell feature collapsed">
				<div class="labelInColumn feature">
					<div class="content">Pricing</div>
				</div>
				<div class="c content">
					{{= annualPriceTemplate }}
					{{= monthlyPriceTemplate }}
				</div>
			</div>

			<div class="cell category expandable inverseRow collapsed">
				<div class="labelInColumn category expandable collapsed inverseRow">
					<div class="content" data-featureid="10001">
						<div class="contentInner">Special Feature / Offer<span class="icon expander"></span></div>
					</div>
				</div>
				<div class="c content isMultiRow" data-featureid="10001">
					{{= (obj.features.hasOwnProperty('speFea') && obj.features.speFea.hasOwnProperty('value')) ? obj.features.speFea.value : '' }}
				</div>
				<div class="children" data-fid="10001">
					<div class="cell feature collapsed">
						<div class="labelInColumn feature collapsed noLabel">
							<div class="content" data-featureid="10002">
								<div class="contentInner"></div>
							</div>
						</div>
						<div class="c content isMultiRow" data-featureid="10002">
							{{= (obj.features.hasOwnProperty('speFea') && obj.features.speFea.hasOwnProperty('extra')) ? obj.features.speFea.extra : '' }}
						</div>
					</div>
				</div>
			</div>

			<div class="cell feature collapsed">
				<div class="labelInColumn feature collapsed excessFeature">
					<div class="content">
						<div class="contentInner">Excess</div>
					</div>
				</div>
				<div class="c content height0" data-featureid="10003">{{= obj.features.excess.value }}</div>
			</div>

			<div class="cell feature collapsed">
				<div class="labelInColumn feature collapsed excessFeature">
					<div class="content">
						<div class="contentInner">Features</div>
					</div>
				</div>
			</div>
		</div>

		<%-- Feature list, defaults to a spinner --%>
		<div class="featuresList featuresElements">
			<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/><%-- #WHITELABEL CX --%>
		</div>

	</div>
</core:js_template>

<%-- FEATURE TEMPLATE --%>
	<div id="feature-template" style="display:none;" class="featuresTemplateComponent">
		<c:forEach items="${resultTemplateItems}" var="selectedValue" varStatus="status">
			<features:resultsItem item="${selectedValue}" labelMode="false" index="${status.index}"/>
		</c:forEach>
	</div>

<%-- UNAVAILABLE ROW --%>
<core:js_template id="unavailable-template">
	{{ var productTitle = (typeof obj.headline !== 'undefined' && typeof obj.headline.name !== 'undefined') ? obj.headline.name : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.headline !== 'undefined' && typeof obj.headline.des !== 'undefined') ? obj.headline.des : 'Unknown product name'; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}

	<div class="result-row result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="N">
		<div class="result">
			<div class="resultInsert featuresMode">
				<div class="productSummary results">
					{{= logo }}
					<p>We're sorry but this provider chose not to quote.</p>
				</div>
			</div>

			<div class="resultInsert priceMode">
				<div class="row">
					<div class="col-xs-2 col-sm-8 col-md-6">
						{{= logo }}

						<h2 class="hidden-xs productTitle">{{= productTitle }}</h2>

						<p class="description hidden-xs">{{= productDescription }}</p>
					</div>
					<div class="col-xs-10 col-sm-4 col-md-6">
						<p class="specialConditions">We're sorry but this provider chose not to quote.</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</core:js_template>

<%-- UNAVAILABLE COMBINED ROW --%>
<core:js_template id="unavailable-combined-template">
{{ var template = $("#provider-logo-template").html(); }}
{{ var logo = _.template(template); }}
{{ var logos = ''; }}
{{ _.each(obj, function(result) { }}
{{	if (result.available !== 'Y') { }}
{{		logos += logo(result); }}
{{	} }}
{{ }) }}
	<div class="result-row result_unavailable_combined notfiltered" data-available="N" style="display:block" data-position="{{= obj.length }}" data-sort="{{= obj.length }}">
		<div class="result">
			<div class="resultInsert featuresMode">
				<div class="productSummary results clearfix">
					<h2>We're sorry but these providers chose not to quote:</h2>
					<div class="logos">{{= logos }}</div>
				</div>
			</div>

			<div class="resultInsert priceMode clearfix">
				<h2>We're sorry but these providers chose not to quote:</h2>
				<div class="logos">{{= logos }}</div>
			</div>
		</div>
	</div>
</core:js_template>

<%-- ERROR ROW --%>
<core:js_template id="error-template">
	{{ var productTitle = (typeof obj.headline !== 'undefined' && typeof obj.headline.name !== 'undefined') ? obj.headline.name : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.headline !== 'undefined' && typeof obj.headline.des !== 'undefined') ? obj.headline.des : 'Unknown product name'; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}

	<div class="result-row result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="E">
		<div class="result">
			<div class="resultInsert featuresMode">
				<div class="productSummary results">
					{{= logo }}
					<p>We're sorry but this provider chose not to quote.</p>
				</div>
			</div>

			<div class="resultInsert priceMode">
				<div class="row">
					<div class="col-xs-2 col-sm-8 col-md-6">
						<div class="companyLogo"><img src="common/images/logos/results/{{= obj.productId }}_w.png" /></div>

						<h2 class="hidden-xs productTitle">{{= productTitle }}</h2>

						<p class="description hidden-xs">{{= productDescription }}</p>
					</div>
					<div class="col-xs-10 col-sm-4 col-md-6">
						<p class="specialConditions">We're sorry but this provider chose not to quote.</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</core:js_template>

<%-- NO RESULTS --%>
<div class="hidden">
	<agg_new_results:results_none />
</div>

<%-- FETCH ERROR --%>
<div class="resultsFetchError displayNone">
	Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later</a>.
</div>

<%-- Logo template --%>
<core:js_template id="provider-logo-template">
	{{ var img = 'default_w'; }}
	{{ if (obj.hasOwnProperty('productId') && obj.productId.length > 1) img = obj.productId.substring(0, obj.productId.indexOf('-')); }}
	<div class="companyLogo logo_{{= img }}"></div>
</core:js_template>

</agg_new_results:results>

<%-- Price template --%>
<core:js_template id="monthly-price-template">
	<div class="frequency monthly clearfix" data-availability="{{= obj.available }}">
		<div class="frequencyAmount">{{= '$' }}{{= obj.headline.instalmentPayment.toFixed(2) }}</div>
		<div class="frequencyTitle">Monthly Price</div>
		<div class="monthlyBreakdown">
			<span class="nowrap"><span class="firstPayment">1st Month: {{= '$' }}{{= obj.headline.instalmentFirst.toFixed(2) }}</span></span>
			<span class="nowrap"><span class="totalPayment">Total: {{= '$' }}{{= obj.headline.instalmentTotal.toFixed(2) }}</span></span>
		</div>
	</div>
</core:js_template>

<%-- Price template --%>
<core:js_template id="annual-price-template">
	<div class="frequency annual clearfix" data-availability="{{= obj.available }}">
		<div class="frequencyAmount">{{= '$' }}{{= obj.headline.lumpSumTotal }}</div>
		<div class="frequencyTitle">Annual Price</div>
	</div>
</core:js_template>



<%-- Template for CAR results list. --%>
<core:js_template id="compare-basket-features-item-template">
{{ var tFrequency = Results.getFrequency(); }}
{{ var monthlyHidden = tFrequency == 'monthly' ? '' : 'displayNone'; }}
{{ var annualHidden = tFrequency == 'annual' ? '' : 'displayNone'; }}

{{ for(var i = 0; i < products.length; i++) { }}
	<li>
		<span class="active-product">
			<input type="checkbox" class="compare-tick checked" data-productId="{{= products[i].productId }}" checked />
			<label for="features_compareTick_{{= products[i].productId }}"></label>
		</span>

		<span class="name">
			{{= products[i].headline.name }}
		</span>
		<span class="price">
			<span class="frequency annual annually {{= annualHidden }}">
				{{= '$' }}{{= products[i].headline.lumpSumTotal }}
			</span>
			<span class="frequency monthly {{= monthlyHidden }}">
				{{= '$' }}{{= products[i].headline.instalmentPayment.toFixed(2) }}
			</span>
		</span>
	</li>
{{ } }}
</core:js_template>

<core:js_template id="compare-basket-price-item-template">
{{ var tFrequency = Results.getFrequency(); }}
{{ var tDisplayMode = Results.getDisplayMode(); }}
{{ var monthlyHidden = tFrequency == 'monthly' ? '' : 'displayNone'; }}
{{ var annualHidden = tFrequency == 'annual' ? '' : 'displayNone'; }}

{{ for(var i = 0; i < products.length; i++) { }}
{{ var img = products[i].brandCode; }}
{{ if ((typeof img === 'undefined' || img === '') && products[i].hasOwnProperty('productId') && products[i].productId.length > 1) img = products[i].productId.substring(0, products[i].productId.indexOf('-')); }}

	<li class="compare-item">
		<span class="carCompanyLogo logo_{{= img }}" title="{{= products[i].headline.name }}"></span>
		<span class="price">
			<span class="frequency annual annually {{= annualHidden }}">
				{{= '$' }}{{= products[i].headline.lumpSumTotal }} <span class="small hidden-sm">annually</span>
			</span>
			<span class="frequency monthly {{= monthlyHidden }}">
				{{= '$' }}{{= products[i].headline.instalmentPayment.toFixed(2) }} <span class="small hidden-sm">monthly</span>
			</span>
		</span>
		<span class="icon icon-cross remove-compare" data-productId="{{= products[i].productId }}" title="Remove from shortlist"></span>
	</li>
{{ } }}
</core:js_template>
<core:js_template id="compare-basket-features-template">
<div class="compare-basket">
<h2>Compare Products</h2>
{{ if(comparedResultsCount === 0) { }}
	<p>
		Click the <input type="checkbox" class="compare-tick"><label></label> to add up to <span class="compare-max-count-label">{{= maxAllowable }} products</span> to your shortlist.
		We've found <span class="products-returned-count">{{= resultsCount }} products</span> matching your needs.
	</p>
{{ }  else { }}

	{{ var template = $("#compare-basket-features-item-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var comparedItems = htmlTemplate(obj); }}


<ul class="compared-products-list">

	{{= comparedItems }}

	{{ if(comparedResultsCount < maxAllowable && isCompareOpen === false) { }}
		{{ for(var m = 0; m < maxAllowable-comparedResultsCount; m++) { }}
			<li>
			<span class="compare-placeholder">
				<input type="checkbox" class="compare-tick" disabled />
				<label></label>
				<span class="placeholderLabel">Add another product</span>
			</span>
			</li>
		{{ } }}
	{{ } }}
	</ul>
	{{ if (comparedResultsCount > 1) { }}
		{{ if(meerkat.modules.compare.isCompareOpen() === true) { }}
			<a class="btn btn-features-compare clear-compare btn-block" href="javascript:;">Clear Products<span class="icon icon-arrow-right"></span></a>
		{{ } else { }}
			<a class="btn btn-features-compare enter-compare-mode btn-block" href="javascript:;">Compare Products<span class="icon icon-arrow-right"></span></a>
		{{ } }}
	{{ } }}
{{ } }}
</div>
</core:js_template>
<core:js_template id="compare-basket-price-template">
	{{ if(comparedResultsCount > 0) { }}
		{{ var template = $("#compare-basket-price-item-template").html(); }}
		{{ var htmlTemplate = _.template(template); }}
		{{ var comparedItems = htmlTemplate(obj); }}

		<ul class="nav navbar-nav">
			<li class="navbar-text">Add up to <span class="compare-max-count-label">{{= maxAllowable }} products</span> to your shortlist</li>
			{{= comparedItems }}
		</ul>
		{{ if(comparedResultsCount > 1) { }}
			<ul class="nav navbar-nav navbar-right">
				<li class=""><a href="javascript:void(0);" class="compare-list enter-compare-mode">Compare Products <span class="icon icon-arrow-right"></span></a></li>
			</ul>
		{{ } }}
	{{ } }}
</core:js_template>
