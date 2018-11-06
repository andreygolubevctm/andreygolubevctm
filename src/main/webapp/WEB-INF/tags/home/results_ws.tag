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
	<div id="results_v5" class="resultsContainer v2 v6 results-columns-sm-2 results-columns-md-3 results-columns-lg-3">
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

		<agg_v1:inclusive_gst className="visible-xs" />

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

	{{ var template = $("#title-download-special-template-pds").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var titleDownloadSpecialTemplate = htmlTemplate(obj); }}

	{{ var template = $("#call-action-buttons-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var callActionButtonsPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $("#promotion-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var promotionPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $('#excess-price-template').html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var excessPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var logo = _.template(template); }}
	{{ logo = logo(obj); }}

	{{ var template = $("#monthly-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var monthlyPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $("#annual-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var annualPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $("#compare-toggle-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var compareTogglePriceTemplate = htmlTemplate(obj); }}

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

	{{ var template = $("#call-action-buttons-features-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var callActionButtonsFeaturesTemplate = htmlTemplate(obj); }}

	{{ var template = $("#excess-features-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var excessFeaturesTemplate = htmlTemplate(obj); }}

	{{ var template = $("#home-offline-discount-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.offlineDiscountTemplate = htmlTemplate(obj); }}
	{{ if(meerkat.site.isLandlord) { }}
		{{ var filters = {} }}
		{{ filters.lossrent = obj.features.lossrent && obj.features.lossrent.value === "Y" ? true : false }}
		{{ filters.malt = obj.features.malt && obj.features.malt.value === "Y" ? true : false }}
		{{ filters.rdef = obj.features.rdef && obj.features.rdef.value === "Y" ? true : false }}
		{{ var lossrent = filters.lossrent ? '<span><i class="icon-skinny-tick"></i> Loss of rent</span>' : '<span class="not-active"><i class="icon-cross"></i>  Loss of rent</span>' }}
		{{ var malt = filters.malt ? '<span><i class="icon-skinny-tick"></i> Malicious damage</span>' : '<span class="not-active"><i class="icon-cross"></i> Malicious damage</span>'}}
		{{ var rdef = filters.rdef ? '<span><i class="icon-skinny-tick"></i> Tenant default</span>' : '<span class="not-active"><i class="icon-cross"></i> Tenant default</span>'}}
		{{ var lossrentMobile = filters.lossrent ? '<span><i class="icon-skinny-tick"></i> Loss of<br />rent</span>' : '<span class="not-active"><i class="icon-cross"></i> Loss of<br />rent</span>' }}
		{{ var maltMobile = filters.malt ? '<span><i class="icon-skinny-tick"></i> Malicious<br />damage</span>' : '<span class="not-active"><i class="icon-cross"></i> Malicious<br />damage</span>'}}
		{{ var rdefMobile = filters.rdef ? '<span><i class="icon-skinny-tick"></i> Tenant<br />default</span>' : '<span class="not-active"><i class="icon-cross"></i> Tenant<br />default</span>'}}
	{{ } }}

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

					{{= callActionButtonsFeaturesTemplate }}

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
					<div class="col-xs-3 col-sm-2 col-md-1">
						{{= logo }}
						<div class="hidden-md hidden-lg">
							{{= callActionButtonsPriceTemplate }}
						</div>

						{{= compareTogglePriceTemplate }}
					</div>

					<div class="col-xs-9 col-sm-10 col-md-11 right-col">
						<div class="row">
							<div class="col-xs-12 col-sm-7 col-md-4 col-lg-5">
								{{= titleDownloadSpecialTemplate }}
							</div>

							<div class="col-xs-12 col-sm-5 col-md-8 col-lg-7">
								<div class="excess-price-container">
									{{= excessPriceTemplate }}

									<div class="price-container">
										{{= annualPriceTemplate }}

										{{= monthlyPriceTemplate }}

										<div class="excessAndPrice hidden priceNotAvailable">
											<span class="frequencyName">Monthly</span> payment is not available for this product.
										</div>
									</div>
								</div>

								<div class="cta-container hidden-xs hidden-sm">
									{{= mainCallToActionButton }}
								</div>
							</div>
						</div>
						{{ if (meerkat.site.isLandlord) { }}
							<div class="landlord-filters clearfix">
								{{= lossrent }}
								{{= malt }}
								{{= rdef }}
								<field_v2:help_icon helpId="575" showText="" />
							</div>
							<div class="landlord-filters-mobile clearfix">
								{{= lossrentMobile }}
								{{= maltMobile }}
								{{= rdefMobile }}
								<field_v2:help_icon helpId="575" showText="" />
							</div>
						{{ } }}
						<div class="clearfix">
							{{= callActionButtonsPriceTemplate }}

							<div class="promotion-cta-container hidden-xs">
								<div class="promotion-container">
									{{= promotionPriceTemplate }}
								</div>

								<div class="cta-container hidden-md hidden-lg">
									{{= mainCallToActionButton }}
								</div>
							</div>
						</div>
					</div>
				</div><%-- /row --%>

				<div class="promotion-cta-container visible-xs">
					<div class="promotion-container">
						{{= promotionPriceTemplate }}
					</div>

					<div class="cta-container">
						{{= mainCallToActionButton }}
					</div>
				</div>
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
			{{ if (Results.model.availableCounts == 0) { }}
				<agg_v2:no_quotes id="no-results-content"/>
			{{ } else { }}
			<div class="resultInsert priceMode clearfix">
				<h2>We're sorry but these providers chose not to quote:</h2>
				<div class="logos">{{= logos }}</div>
			</div>
			{{ } }}
			{{ if (Results.model.availableCounts > 0) { }}
			<div class="resultInsert featuresMode">
				<div class="productSummary results clearfix">
					<h2>We're sorry but these providers chose not to quote:</h2>
					<div class="logos">{{= logos }}</div>
				</div>
			</div>
			{{ } }}
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

<%-- Include call button templates --%>
<agg_v1:results_call_button_templates />

<%-- Include shared priceMode templates --%>
<agg_v1:results_price_mode_templates />

<%-- Include shared featuresMode templates --%>
<agg_v1:results_features_mode_templates />

<%-- Price template priceMode --%>
<home:results_price_mode_templates />

<%-- Features template featuresMode --%>
<home:results_features_mode_templates />

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
