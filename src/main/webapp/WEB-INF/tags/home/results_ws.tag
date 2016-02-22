<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- The following are hidden fields used by filters --%>
<field_v1:hidden xpath="home/paymentType" defaultValue="annual" />
<field_v1:array_select
	items="annual=Annual,monthly=Monthly"
	xpath="filter/paymentType"
	title=""
	required=""
	className="hidden" />

<field_v1:hidden xpath="home/homeExcess" />
<field_v1:hidden xpath="home/contentsExcess" />
<field_v1:hidden xpath="home/baseHomeExcess" constantValue="500" />
<field_v1:hidden xpath="home/baseContentsExcess" constantValue="500" />

<field_v1:additional_excess
		defaultVal="500"
		increment="100"
		minVal="100"
		xpath="filter/homeExcessOptions"
		maxCount="5"
		title=""
		required=""
		omitPleaseChoose="Y"
		className="hidden"
		additionalValues="750,1000,1500,2000,3000,4000,5000"/>
<field_v1:additional_excess
		defaultVal="500"
		increment="100"
		minVal="100"
		xpath="filter/contentsExcessOptions"
		maxCount="5"
		title=""
		required=""
		omitPleaseChoose="Y"
		className="hidden"
		additionalValues="750,1000,1500,2000,3000,4000,5000"/>

<home:results_filterbar_xs />

<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />
<div id="deviceType" data-deviceType="${deviceType}"></div>

<div class="resultsHeadersBg">
</div>

<agg_v2_results:results vertical="${pageSettings.getVerticalCode()}">

	<home:more_info_ws />

<%-- RESULTS TABLE --%>
	<div class="bridgingContainer"></div>
	<div id="results_v3" class="resultsContainer v2 results-columns-sm-3 results-columns-md-3 results-columns-lg-5">
		<div class="featuresHeaders featuresElements">

			<div class="result fixedDockedHeader">
				<div class="expand-collapse-toggle small hidden-xs">
					<a href="javascript:;" class="expandAllFeatures">Expand All</a> / <a href="javascript:;" class="collapseAllFeatures active">Collapse All</a>
				</div>
			</div>

			<div class="result headers featuresNormalHeader">
				<div class="resultInsert controlContainer">
				</div>
			</div>

			<%-- Feature headers --%>
			<features:resultsItemTemplate_labels />
			<div class="featuresList featuresTemplateComponent"></div>
		</div>

		<div class="resultsOverflow">
			<div class="results-table"></div>
		</div>

		<core_v1:clear />

		<div class="featuresFooterPusher"></div>
	</div>

<%-- DEFAULT RESULT ROW --%>
<core_v1:js_template id="result-template">

	{{ var productTitle = (typeof obj.productName !== 'undefined') ? obj.productName : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.productDescription !== 'undefined') ? obj.productDescription : 'Unknown product name'; }}
	{{ var promotionText = (typeof obj.discountOffer !== 'undefined' && obj.discountOffer.length > 0) ? obj.discountOffer : ''; }}
	{{ var offerTermsContent = (typeof obj.discountOfferTerms !== 'undefined' && obj.discountOfferTerms.length > 0) ? obj.discountOfferTerms : ''; }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}

	{{ var template = $("#monthly-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.monthlyPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $("#annual-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.annualPriceTemplate = htmlTemplate(obj); }}

	{{ var specialOfferPrefix = _.indexOf(["REIN","WOOL"], obj.serviceName) >= 0 ? "<strong>Special offer:</strong> " : ""; }}

	<div class="result-row result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="Y">

		<div class="result featuresDockedHeader">
			<div class="resultInsert featuresMode">
				{{= logo }}
				{{= annualPriceTemplate }}
				{{= monthlyPriceTemplate }}
				<div class="headerButtonWrapper">
					<a class="btn btn-primary btn-cta btn-block btn-more-info" href="javascript:;" data-productId="{{= obj.productId }}">More Info & Apply <span class="icon icon-arrow-right" /></a>
				</div>
			</div>
			<div class="productSummary results visible-xs">
				{{= logo }}
				<div class="headerButtonWrapper">
					<a class="btn btn-primary btn-cta btn-block btn-more-info" href="javascript:;" data-productId="{{= obj.productId }}">More Info <span class="icon icon-arrow-right" /></a>
				</div>
			</div>
		</div>

		<div class="result featuresNormalHeader headers">
			<div class="resultInsert featuresMode">
				<div class="productSummary results hidden-xs homeSpecific">
					<div class="compare-toggle-wrapper">
						<input type="checkbox" class="compare-tick" data-productId="{{= obj.productId }}" id="features_compareTick_{{= obj.productId }}" />
						<label for="features_compareTick_{{= obj.productId }}"></label>
					</div>
					{{= logo }}
					{{= annualPriceTemplate }}
					{{= monthlyPriceTemplate }}
					<div class="headerButtonWrapper">
						<a class="btn btn-primary btn-cta btn-block btn-more-info" href="javascript:;" data-productId="{{= obj.productId }}">More Info & Apply <span class="icon icon-arrow-right" /></a>
					</div>
				</div>
				<div class="productSummary results visible-xs">
					{{= logo }}
					<div class="headerButtonWrapper">
						<a class="btn btn-primary btn-cta btn-block btn-more-info" href="javascript:;" data-productId="{{= obj.productId }}">More Info & Apply <span class="icon icon-arrow-right" /></a>
					</div>
				</div>
			</div>

			<div class="resultInsert priceMode">
				<div class="row">
					<div class="col-xs-3 col-sm-7 col-md-6 col-lg-5">
						{{= logo }}
						<div class="compare-toggle-wrapper">
							<input type="checkbox" class="compare-tick" data-productId="{{= obj.productId }}" id="price_compareTick_{{= obj.productId }}" />
							<label for="price_compareTick_{{= obj.productId }}"></label>
							<label for="price_compareTick_{{= obj.productId }}" class="compare-label"></label>
						</div>
						<h2 class="hidden-xs productTitle">{{= productTitle }}</h2>

						<p class="description hidden-xs hidden-sm">{{= productDescription }}</p>

						{{ if (promotionText.length > 0) { }}
						<div class="promotion small visible-sm">
							<span class="icon icon-tag"></span>{{= specialOfferPrefix}}{{= promotionText }}
							{{ if (offerTermsContent.length > 0) { }}
								<a class="small offerTerms" href="javascript:;">Offer terms</a>
								<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
							{{ } }}
						</div>
						{{ } }}
					</div>
					<div class="col-xs-9 col-sm-5 col-md-6 col-lg-7">
						<div class="row">
							<div class="col-xs-12 col-sm-7 col-sm-push-5 col-md-4 col-md-push-3 col-lg-push-4 price">
								{{= annualPriceTemplate }}

								{{= monthlyPriceTemplate }}

								<div class="excessAndPrice hidden priceNotAvailable">
									<span class="frequencyName">Monthly</span> payment is not available for this product.
								</div>

								<a class="btn btn-cta btn-block btn-more-info hidden-xs hidden-md hidden-lg" href="javascript:;" data-productId="{{= obj.productId }}">More Info & Apply <span class="icon icon-arrow-right" /></a>
							</div>

							<div class="col-xs-12 col-sm-5 col-sm-pull-7 col-md-3 col-md-pull-4 col-lg-4 col-lg-pull-4 excess excessHome">
								{{ if (obj.homeExcess !== null && obj.homeExcess.amount !== '') { }}
									<div class="excessAmount">{{= obj.homeExcess.amountFormatted }}</div>
									<div class="excessTitle">Home excess</div>
								{{ } else { }}
									<div class="excessAmount excessContents">{{= obj.contentsExcess.amountFormatted }}</div>
									<div class="excessTitle">Contents excess</div>
								{{ } }}
								{{ if (obj.contentsExcess !== null && obj.contentsExcess.amount !== '' && obj.homeExcess !== null && obj.homeExcess.amount !== '') { }}
									<div class="excessAmount hidden-md hidden-lg excessContents">{{= obj.contentsExcess.amountFormatted }}</div>
									<div class="excessTitle hidden-md hidden-lg">Contents excess</div>
								{{ } }}
							</div>

							<div class="col-xs-12 col-md-5 col-lg-4 hidden-xs hidden-sm">
								<a class="btn btn-cta btn-block btn-more-info" href="javascript:;" data-productId="{{= obj.productId }}">More Info & Apply <span class="icon icon-arrow-right" /></a>
							</div>
						</div>
						<div class="row">
							<div class="col-xs-6 col-xs-push-6 col-sm-push-0 col-md-3 col-lg-4 excess excessContents hidden-xs hidden-sm">
								{{ if (obj.contentsExcess !== null && obj.contentsExcess.amount !== '' && obj.homeExcess !== null && obj.homeExcess.amount !== '') { }}
									<div class="excessAmount">{{= obj.contentsExcess.amountFormatted }}</div>
									<div class="excessTitle">Contents excess</div>
								{{ } }}
							</div>
							{{ if (promotionText.length > 0) { }}
								<div class="col-xs-12 col-md-9 col-lg-8">
									<div class="promotion small hidden-sm">
										<span class="icon icon-tag"></span>{{=specialOfferPrefix}}{{= promotionText }}
										{{ if (offerTermsContent.length > 0) { }}
											<a class="small hidden-xs offerTerms" href="javascript:;">Offer terms</a>
											<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
										{{ } }}
									</div>
								</div>
							{{ } }}
						</div>
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
						<div class="contentInner">Features</div>
					</div>
				</div>
			</div>
		</div>

		<%-- Feature list, defaults to a spinner --%>
		<div class="featuresList featuresElements">
		</div>

	</div>
</core_v1:js_template>

<%-- FEATURE TEMPLATE --%>
	<features:resultsItemTemplate />

<%-- UNAVAILABLE ROW --%>
<core_v1:js_template id="unavailable-template">
	{{ var productTitle = (typeof obj.productName !== 'undefined') ? obj.productName : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.productDescription !== 'undefined') ? obj.productDescription : 'Unknown product name'; }}

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
</core_v1:js_template>

<%-- UNAVAILABLE COMBINED ROW --%>
<core_v1:js_template id="unavailable-combined-template">
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
					<h2>Sorry, some of our providers were unable to get you a quote</h2>
					<div class="logos">{{= logos }}</div>
				</div>
			</div>

			<div class="resultInsert priceMode clearfix">
				<h2>Sorry, some of our providers were unable to get you a quote</h2>
				<div class="logos">{{= logos }}</div>
			</div>
		</div>
	</div>
</core_v1:js_template>

<%-- ERROR ROW --%>
<core_v1:js_template id="error-template">
	{{ var productTitle = (typeof obj.productName !== 'undefined') ? obj.productName : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.productDescription !== 'undefined') ? obj.productDescription : 'Unknown product name'; }}

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
</core_v1:js_template>

<%-- NO RESULTS --%>
<div class="hidden">
	<c:set var="heading"><content:get key="noQuoteTitle"/></c:set>
	<c:set var="blurb"><content:get key="noQuoteBody"/></c:set>
	<confirmation:other_products heading="${heading}" copy="${blurb}" id="no-results-content"/>
</div>

<%-- FETCH ERROR --%>
<div class="resultsFetchError displayNone">
	Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later</a>.
</div>

<%-- Logo template --%>
<core_v1:js_template id="provider-logo-template">
	{{ var img = obj.brandCode; }}
	{{ if ((typeof img === 'undefined' || img === '' || img === null) && obj.hasOwnProperty('productId') && obj.productId.length > 1) img = obj.productId.substring(0, obj.productId.indexOf('-')); }}
	<div class="companyLogo logo_{{= img }}"></div>
</core_v1:js_template>

</agg_v2_results:results>

<%-- Price template --%>
<core_v1:js_template id="monthly-price-template">
	<div class="frequency monthly clearfix" data-availability="{{= obj.available }}">
		<div class="frequencyAmount">{{= obj.price.monthlyPremiumFormatted }}</div>
		<div class="frequencyTitle">Monthly Price</div>
		<div class="monthlyBreakdown">
			<span class="nowrap"><span class="firstPayment">1st Month: {{= obj.price.monthlyFirstMonthFormatted }}</span></span>
			<span class="nowrap"><span class="firstPayment">Total: {{= obj.price.annualisedMonthlyPremiumFormatted }}</span></span>
		</div>
	</div>
</core_v1:js_template>

<%-- Price template --%>
<core_v1:js_template id="annual-price-template">
	<div class="frequency annual clearfix" data-availability="{{= obj.available }}">
		<div class="frequencyAmount">{{= obj.price.annualPremiumFormatted }}</div>
		<div class="frequencyTitle">Annual Price</div>
	</div>
</core_v1:js_template>

<%-- Template for H&C results list. --%>
<core_v1:js_template id="compare-basket-features-item-template">
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
			{{= products[i].productName }}
		</span>
		<span class="price">
			<span class="frequency annual annually {{= annualHidden }}">
				{{= products[i].price.annualPremiumFormatted }}
			</span>
			<span class="frequency monthly {{= monthlyHidden }}">
				{{= products[i].price.monthlyPremiumFormatted }}
			</span>
		</span>
	</li>
{{ } }}
</core_v1:js_template>

<core_v1:js_template id="compare-basket-price-item-template">
{{ var tFrequency = Results.getFrequency(); }}
{{ var tDisplayMode = Results.getDisplayMode(); }}
{{ var monthlyHidden = tFrequency == 'monthly' ? '' : 'displayNone'; }}
{{ var annualHidden = tFrequency == 'annual' ? '' : 'displayNone'; }}

{{ for(var i = 0; i < products.length; i++) { }}
{{ var img = products[i].brandCode; }}
{{ if ((typeof img === 'undefined' || img === '') && products[i].hasOwnProperty('productId') && products[i].productId.length > 1) img = products[i].productId.substring(0, products[i].productId.indexOf('-')); }}

	<li class="compare-item">
		<span class="companyLogo logo_{{= img }}" title="{{= products[i].productName }}"></span>
		<span class="price">
			<span class="frequency annual annually {{= annualHidden }}">
				{{= products[i].price.annualPremiumFormatted }} <span class="small hidden-sm">annually</span>
			</span>
			<span class="frequency monthly {{= monthlyHidden }}">
				{{= products[i].price.monthlyPremiumFormatted }} <span class="small hidden-sm">monthly</span>
			</span>
		</span>
		<span class="icon icon-cross remove-compare" data-productId="{{= products[i].productId }}" title="Remove from shortlist"></span>
	</li>
{{ } }}
</core_v1:js_template>
<core_v1:js_template id="compare-basket-features-template">
<div class="compare-basket">
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
		<div class="compareButtonsContainer">
			{{ if(meerkat.modules.compare.isCompareOpen() === true) { }}
				<a class="btn btn-compare-clear clear-compare btn-block" href="javascript:;">Clear Products<span class="icon icon-arrow-right"></span></a>
			{{ } else { }}
				<a class="btn btn-features-compare enter-compare-mode btn-block" href="javascript:;">Compare Products<span class="icon icon-arrow-right"></span></a>
			{{ } }}
		</div>
	{{ } }}
{{ } }}
</div>
<div class="expand-collapse-toggle small hidden-xs">
	<a href="javascript:;" class="expandAllFeatures">Expand All</a> / <a href="javascript:;" class="collapseAllFeatures active">Collapse All</a>
</div>
</core_v1:js_template>
<core_v1:js_template id="compare-basket-price-template">
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
</core_v1:js_template>