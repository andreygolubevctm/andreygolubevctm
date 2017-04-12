<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- VARIABLES --%>
<c:set var="navBtnAnalyticsAttr"><field_v1:analytics_attr analVal="nav button" quoteChar="\"" /></c:set>

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
	<div id="results_v5" class="resultsContainer v2 results-columns-sm-2 results-columns-md-3 results-columns-lg-3">
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

		<agg_v1:results_pagination_floated_arrows />

		<agg_v1:payment_frequency_buttons xpath="filter/paymentFrequency" />

		<div class="resultsOverflow">
			<div class="results-table"></div>
		</div>

		<core_v1:clear />

		<div class="featuresFooterPusher"></div>

		<agg_v1:results_mobile_display_mode_toggle />
	</div>

<%-- DEFAULT RESULT ROW --%>
<core_v1:js_template id="result-template">

	{{ var productTitle = (typeof obj.productName !== 'undefined') ? obj.productName : 'Unknown product name'; }}
	{{ var productDescription = (typeof obj.productDescription !== 'undefined') ? obj.productDescription : 'Unknown product name'; }}
	{{ var promotionText = (typeof obj.discountOffer !== 'undefined' && obj.discountOffer.length > 0) ? obj.discountOffer : ''; }}
	{{ var offerTermsContent = (typeof obj.discountOfferTerms !== 'undefined' && obj.discountOfferTerms.length > 0) ? obj.discountOfferTerms : ''; }}
	{{ var priceDisclaimer = (!_.isUndefined(obj.price.priceDisclaimer) && !_.isNull(obj.price.priceDisclaimer) && obj.price.priceDisclaimer.length > 0) ? obj.price.priceDisclaimer : ''; }}

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

	<%-- Main call to action button. --%>
	{{ var mainCallToActionButton = '' }}
	{{ if (obj.availableOnline == true) { }}
		{{ mainCallToActionButton = '<a target="_blank" href="javascript:;" class="btn btn-lg btn-primary btn-cta btn-block btn-more-info-apply" data-productId="'+obj.productId+'">Go to Insurer<span class="icon-arrow-right"></span></a>' }}
	{{ } else { }}
		{{ mainCallToActionButton = '<div class="btnContainer"><a class="btn btn-lg btn-cta btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;" data-productId="'+obj.productId+'">Call Insurer Direct</a></div>' }}
	{{ } }}

	<%-- FEATURES MODE Templates --%>
	{{ var template = $("#monthly-price-features-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var monthlyPriceFeaturesTemplate = htmlTemplate(obj); }}

	{{ var template = $("#annual-price-features-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var annualPriceFeaturesTemplate = htmlTemplate(obj); }}

	{{ var template = $("#call-action-buttons-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var callActionButtonsTemplate = htmlTemplate(obj); }}

	{{ var template = $("#excess-features-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var excessFeaturesTemplate = htmlTemplate(obj); }}

	{{ var template = $("#home-offline-discount-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.offlineDiscountTemplate = htmlTemplate(obj); }}

	<div class="result-row result_{{= obj.productId }}" data-productId="{{= obj.productId }}" data-available="Y">

		<div class="result featuresDockedHeader">
			<div class="resultInsert featuresMode">
				{{= logo }}
				{{= annualPriceFeaturesTemplate }}
				{{= monthlyPriceFeaturesTemplate }}
				<div class="headerButtonWrapper">
					{{= mainCallToActionButton }}
				</div>
			</div>
		</div>

		<div class="result featuresNormalHeader headers">
			<div class="resultInsert featuresMode">
				<div class="productSummary results">
					<div class="compare-toggle-wrapper">
						<input type="checkbox" class="compare-tick" data-productId="{{= obj.productId }}" id="features_compareTick_{{= obj.productId }}" />
						<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Short List - {{= obj.brandCode }} | {{= obj.productId }}" quoteChar="\"" /></c:set>
						<label for="features_compareTick_{{= obj.productId }}" ${analyticsAttr}></label>
					</div>
					<div class="clearfix">
						{{= logo }}
						{{= annualPriceFeaturesTemplate }}
						{{= monthlyPriceFeaturesTemplate }}
					</div>

					{{= excessFeaturesTemplate }}

					<h2 class="productTitle">{{= productTitle }}</h2>
					{{ if (priceDisclaimer.length > 0) { }}
					<div class="row priceDisclaimerRow">
						<div class="col-xs-12 text-center">
							<a class="small priceDisclaimer" href="javascript:;">{{= priceDisclaimer }}</a>
							<div class="priceDisclaimer-content hidden"><p class="priceDisclaimer-para">{{= obj.disclaimer }}</p></div>
						</div>
					</div>
					{{ } }}

					<div class="headerButtonWrapper">
						{{= mainCallToActionButton }}
					</div>

					{{= callActionButtonsTemplate }}

					{{ if (promotionText.length > 0) { }}
					<fieldset class="result-special-offer">
						<legend>Special Offer</legend>
						{{= promotionText.replace('<b>SPECIAL OFFER:</b>', '') }}
						{{ if (offerTermsContent.length > 0) { }}
							<a class="small offerTerms" href="javascript:;" ${navBtnAnalyticsAttr}>Conditions</a>
							<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
						{{ } }}
					</fieldset>
					{{ } }}
				</div>
			</div>

			<div class="resultInsert priceMode">
				<div class="row">
					<div class="col-xs-3 col-sm-7 col-md-6 col-lg-5">
						{{= logo }}
						<div class="compare-toggle-wrapper">
							<input type="checkbox" class="compare-tick" data-productId="{{= obj.productId }}" id="price_compareTick_{{= obj.productId }}" />
							<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Short List - {{= obj.brandCode }} | {{= obj.productId }}" quoteChar="\"" /></c:set>
							<label for="price_compareTick_{{= obj.productId }}" ${analyticsAttr}></label>
							<label for="price_compareTick_{{= obj.productId }}" class="compare-label" ${analyticsAttr}></label>
						</div>
						<h2 class="hidden-xs productTitle">{{= productTitle }}</h2>
						{{ if (priceDisclaimer.length > 0) { }}
						<a class="hidden-xs small priceDisclaimer" href="javascript:;">{{= priceDisclaimer }}</a>
						<div class="priceDisclaimer-content hidden"><p class="priceDisclaimer-para">{{= obj.disclaimer }}</p></div>
						{{ } }}

						<p class="description hidden-xs hidden-sm">{{= productDescription }}</p>

						{{ if (promotionText.length > 0) { }}
						<div class="promotion small visible-sm">
							<span class="icon icon-tag"></span>{{= specialOfferPrefix}}{{= promotionText }}
							{{ if (offerTermsContent.length > 0) { }}
								<a class="small offerTerms" href="javascript:;" ${navBtnAnalyticsAttr}>Offer terms</a>
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

								<a class="btn btn-cta btn-block btn-more-info hidden-xs hidden-md hidden-lg" href="javascript:;" data-productId="{{= obj.productId }}" ${navBtnAnalyticsAttr}>More Info & Apply <span class="icon icon-arrow-right" /></a>
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
								<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="nav button" quoteChar="\"" /></c:set>
								<a class="btn btn-cta btn-block btn-more-info" href="javascript:;" data-productId="{{= obj.productId }}" ${analyticsAttr}>More Info & Apply <span class="icon icon-arrow-right" /></a>
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
											<a class="small hidden-xs offerTerms" href="javascript:;" ${navBtnAnalyticsAttr}>Offer terms</a>
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
	<agg_v2:no_quotes id="no-results-content"/>
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

<%-- Price template priceMode --%>
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
		<div class="frequencyAmount"><span class="dollarSign">{{= '$' }}</span>{{= obj.price.annualPremiumFormatted }}</div>
		<div class="frequencyTitle">Annual Price</div>
	</div>
</core_v1:js_template>

<%-- Price template featuresMode --%>
<core_v1:js_template id="monthly-price-features-template">
	{{ var dollars = 0; }}
	{{ var cents = 0; }}
	{{ if (obj.price.monthlyPremium !== null && obj.price.monthlyPremium != '' && typeof(obj.price.monthlyPremium) != 'undefined') { }}
		{{ var monthlyPremiumSplit = obj.price.monthlyPremium.toString().split('.'); }}
		{{ dollars = monthlyPremiumSplit[0]; }}
		{{ cents = monthlyPremiumSplit[1] ? '.' + monthlyPremiumSplit[1] : ''; }}
		{{ if (cents.length === 2) cents += '0'; }}
	{{ } }}

	{{ var firstMonthPrice = 0; }}
	{{ var annualPrice = 0; }}

	{{ if (obj.price.monthlyFirstMonth !== null && obj.price.monthlyFirstMonth != '' && typeof(obj.price.monthlyFirstMonth) != 'undefined') { }}
		{{ firstMonthPrice = obj.price.monthlyFirstMonth.toFixed(2); }}
	{{ } }}
	{{ if (obj.price.annualisedMonthlyPremium !== null && obj.price.annualisedMonthlyPremium != '' && typeof(obj.price.annualisedMonthlyPremium) != 'undefined') { }}
		{{ annualPrice = obj.price.annualisedMonthlyPremium.toFixed(2); }}
	{{ } }}

	<div class="frequency monthly" data-availability="{{= obj.available }}">
		<div class="frequencyAmount">
			<span class="dollarSign">{{= '$' }}</span><span class="dollars">{{= dollars }}</span><span class="cents">{{= cents }}</span></div>
		<div class="frequencyTitle">Monthly</div>
		<div class="monthlyBreakdown">
			<span class="nowrap"><span class="firstPayment">1st Month: &#36;{{= firstMonthPrice }}</span></span>
			<span class="nowrap"><span class="totalPayment">Total: &#36;{{= annualPrice }}</span></span>
		</div>
	</div>
</core_v1:js_template>

<core_v1:js_template id="annual-price-features-template">
	<div class="frequency annual" data-availability="{{= obj.available }}">
		<div class="frequencyAmount">
			<span class="dollarSign">{{= '$' }}</span><span class="dollars">{{= obj.price.annualPremiumFormatted }}</span>
		</div>
		<div class="frequencyTitle">Annual</div>
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
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Short List - {{= obj.brandCode }} | {{= obj.productId }}" quoteChar="\"" /></c:set>
			<label for="features_compareTick_{{= products[i].productId }}" ${analyticsAttr}></label>
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
				<span class="dollarSign">{{= '$' }}</span>{{= products[i].price.annualPremiumFormatted }} <span class="small hidden-sm">annually</span>
			</span>
			<span class="frequency monthly {{= monthlyHidden }}">
				<span class="dollarSign">{{= '$' }}</span>{{= products[i].price.monthlyPremiumFormatted }} <span class="small hidden-sm">monthly</span>
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
		We've found <span class="products-returned-count">{{= resultsCount }} products</span> matching your needs.
		<br>
		Click the <input type="checkbox" class="compare-tick"><label></label> to compare up to <span class="compare-max-count-label">{{= maxAllowable }} products</span>.
		<br>
        <br>
		<small>All prices are inclusive of GST &amp; Gov Charges</small>
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
				<a class="btn btn-features-compare enter-compare-mode btn-block" href="javascript:;" ${navBtnAnalyticsAttr}>Compare Products<span class="icon icon-arrow-right"></span></a>
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
				<li class=""><a href="javascript:void(0);" class="compare-list enter-compare-mode" ${navBtnAnalyticsAttr}>Compare Products <span class="icon icon-arrow-right"></span></a></li>
			</ul>
		{{ } }}
	{{ } }}
</core_v1:js_template>

<!-- Call action buttons. -->
<core_v1:js_template id="call-action-buttons-template">
	<%-- Call Insurer Direct action button. --%>
	{{ var callInsurerDirectActionButton = '<div class="btnContainer"><a class="btn btn-sm btn-call btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;" data-productId="'+obj.productId+'">Call Direct</a></div>' }}

	<%-- Call Me Back action button. --%>
	{{ var callMeBackActionButton = '<div class="btnContainer"><a class="btn btn-sm btn-back btn-block btn-call-actions btn-callback" data-callback-toggle="callback" href="javascript:;" data-productId="'+obj.productId+'">Get a Call Back</a></div>' }}

	{{ var colClass = 'col-xs-12'; }}

	{{ if(obj.contact.allowCallMeBack === true) { }}
		{{ colClass = 'col-xs-6'; }}
	{{ } }}

	<div class="call-actions-buttons row">
		{{ if(obj.contact.allowCallDirect === true) { }}
			<div class="{{= colClass }}">
				{{= callInsurerDirectActionButton }}
			</div>
		{{ } }}

		{{ if(obj.contact.allowCallMeBack === true) { }}
			<div class="{{= colClass }}">
				{{= callMeBackActionButton }}
			</div>
		{{ } }}
	</div>
</core_v1:js_template>

<!-- Excess template featuresMode -->
<core_v1:js_template id="excess-features-template">
<div class="excess row">
	{{ var contentsExcessAmount = (obj.contentsExcess !== null && obj.contentsExcess.amount != '') ? obj.contentsExcess.amount : null; }}
	{{ var homeExcessAmount = (obj.homeExcess !== null && obj.homeExcess.amount != '') ? obj.homeExcess.amount : null; }}

	{{ if (contentsExcessAmount !== null && homeExcessAmount !== null && contentsExcessAmount === homeExcessAmount) { }}
		<div class="col-xs-12 text-right">
			<div class="excessAmount">{{= obj.homeExcess.amountFormatted }}</div>
			<div class="excessTitle">Excess</div>
		</div>
	{{ } else { }}
		{{ if (homeExcessAmount !== null) { }}
			{{ var homeExcessCol = (contentsExcessAmount !== null && homeExcessAmount !== null) ? '6' : '12'; }}
			<div class="col-xs-{{= homeExcessCol }}">
				<div class="excessAmount">{{= obj.homeExcess.amountFormatted }}</div>
				<div class="excessTitle">Home excess</div>
			</div>
		{{ } else { }}
			<div class="col-xs-12">
				<div class="excessAmount excessContents">{{= obj.contentsExcess.amountFormatted }}</div>
				<div class="excessTitle">Contents excess</div>
			</div>
		{{ } }}

		{{ if (contentsExcessAmount !== null && homeExcessAmount !== null) { }}
			<div class="col-xs-6">
				<div class="excessAmount excessContents">{{= obj.contentsExcess.amountFormatted }}</div>
				<div class="excessTitle">Contents excess</div>
			</div>
		{{ } }}
	{{ } }}
</div>
</core_v1:js_template>


<%-- Smaller Templates to reduce duplicate code --%>
<core_v1:js_template id="home-offline-discount-template">
	<%-- If there's a discount.offline e.g. of "10", display the static text of x% Discount included in price shown, otherwise use headline feature. --%>
	{{ obj.offlinePromotionText = ''; }}

	{{ if(typeof discount !== 'undefined' && typeof discount.offline !== 'undefined' && discount.offline > 0 && discount.offline !== discount.online) { }}
		{{ obj.offlinePromotionText = discount.offline + "% discount offered when you call direct. "; }}
	{{ } else if(typeof obj.discountOffer !== 'undefined' && obj.discountOffer > 0)  { }}
		{{ obj.offlinePromotionText = obj.discountOffer; }}
	{{ } }}

	{{ obj.offerTermsContent = (typeof obj.discountOfferTerms !== 'undefined' && obj.discountOfferTerms.length > 0) ? obj.discountOfferTerms : ''; }}

	<%-- If the headlineOffer is "OFFLINE" (meaning you can't continue online), it should show "Call Centre" offer --%>
	{{ if (offlinePromotionText.length > 0) { }}
		<h2>
			{{ if (discount.offline > 0) { }}
				Call Centre Offer
			{{ } else { }}
				Special Offer
			{{ } }}
		</h2>

		<div class="promotion">
			<span class="icon icon-phone-hollow"></span> {{= offlinePromotionText }}
			{{ if (offerTermsContent.length > 0) { }}
				<a class="small offerTerms" href="javascript:;" ${navBtnAnalyticsAttr}>Offer terms</a>
				<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
			{{ } }}
		</div>
	{{ } }}
</core_v1:js_template>