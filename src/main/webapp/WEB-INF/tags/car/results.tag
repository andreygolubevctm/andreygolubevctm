<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- VARIABLES --%>
<c:set var="navBtnAnalAttribute"><field_v1:analytics_attr analVal="nav button" quoteChar="\"" /></c:set>

<%-- The following are hidden fields used by filters --%>
<field_v1:hidden xpath="quote/paymentType" defaultValue="annual" />
<field_v1:array_select
		items="annual=Annual,monthly=Monthly"
		xpath="filter/paymentType"
		title=""
		required=""
		className="hidden" />

<field_v1:hidden xpath="quote/excess" />
<field_v1:hidden xpath="quote/baseExcess" constantValue="${contentService.getContentValue(pageContext.getRequest(), 'defaultExcess')}" />
<field_v1:additional_excess
		defaultVal="800"
		increment="100"
		minVal="400"
		xpath="filter/excessOptions"
		maxCount="17"
		title=""
		required=""
		omitPleaseChoose="Y"
		className="hidden" />

<field_v1:hidden xpath="quote/typeOfCover" />

<c:set var="coverTypeOptions">
    <c:choose>
        <c:when test="${skipNewCoverTypeCarJourney eq true or pageSettings.getBrandCode() ne 'ctm'}">COMPREHENSIVE=Comprehensive</c:when>
        <c:otherwise>COMPREHENSIVE=Comprehensive,TPFT=Third party property&#44; fire and theft,TPPD=Third party property</c:otherwise>
    </c:choose>
</c:set>

<field_v1:array_select
		items="${coverTypeOptions}"
		xpath="filter/coverTypeOptions"
		title=""
		required=""
		className="hidden type_of_cover" />

<car:results_filterbar_xs />

<%-- Get data to build sections/categories/features --%>
<jsp:useBean id="resultsDisplayService" class="com.ctm.web.core.results.services.ResultsDisplayService" scope="request" />
<c:set var="jsonString" value="${resultsDisplayService.getResultItemsAsJsonString('carws_', 'category')}" scope="request"  />
<script>
	var resultLabels = ${jsonString};
</script>

<c:set var="brandCode" value="${pageSettings.getBrandCode()}" />

<jsp:useBean id="environmentService" class="com.ctm.web.core.services.EnvironmentService" scope="request" />
<c:set var="environmentCode" value="${environmentService.getEnvironmentAsString()}" />

<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />
<div id="deviceType" data-deviceType="${deviceType}"></div>

<div class="resultsHeadersBg">
</div>

<agg_v2_results:results vertical="${pageSettings.getVerticalCode()}">

	<c:choose>
		<c:when test="${not empty moreInfoSplitTest and moreInfoSplitTest eq true}"><car:more_info_v2 /></c:when>
		<c:otherwise><car:more_info /></c:otherwise>
	</c:choose>

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
		{{ var productTitle = !_.isUndefined(obj.productName) ? obj.productName : 'Unknown product name'; }}
		{{ var productDescription = !_.isUndefined(obj.productDescription) ? obj.productDescription : 'Unknown product name'; }}
		{{ var promotionText = (!_.isUndefined(obj.discountOffer) && !_.isNull(obj.discountOffer) && obj.discountOffer.length > 0) ? obj.discountOffer : ''; }}
		{{ var offerTermsContent = (!_.isUndefined(obj.discountOfferTerms) && !_.isNull(obj.discountOfferTerms) && obj.discountOfferTerms.length > 0) ? obj.discountOfferTerms : ''; }}

		{{ var template = $("#title-download-special-template").html(); }}
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

		{{ var ctaBtnText = 'Go to Insurer'; }}
		{{ var ctaBtnClass = ''; }}

		{{ if (meerkat.modules.splitTest.isActive(64)) { }}
			{{ ctaBtnText = 'Continue to Insurer'; }}
			{{ ctaBtnClass = 'ctaBtnExpanded'; }}
		{{ } }}

		<%-- Main call to action button. --%>
		{{ var mainCallToActionButton = '' }}
		{{ if (obj.availableOnline == true) { }}
			{{ mainCallToActionButton = '<a target="_blank" href="javascript:;" class="btn btn-lg btn-primary btn-cta btn-block btn-more-info-apply '+ctaBtnClass+'" data-productId="'+obj.productId+'" ${navBtnAnalAttribute}>'+ctaBtnText+'<span class="icon-arrow-right"></span></a>' }}
		{{ } else { }}
			{{ mainCallToActionButton = '<div class="btnContainer"><a class="btn btn-lg btn-cta btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;" data-productId="'+obj.productId+'" ${navBtnAnalAttribute}>Call Insurer Direct</a></div>' }}
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
							<c:set
									var="analAttribute"><field_v1:analytics_attr analVal="Short List - {{= obj.brandCode }}|{{= obj.productId }}"
																				 quoteChar="\"" /></c:set>
							<input type="checkbox" class="compare-tick" data-productId="{{= obj.productId }}" id="features_compareTick_{{= obj.productId }}" ${analAttribute} />
							<label for="features_compareTick_{{= obj.productId }}" ${analAttribute}></label>
						</div>

						<div class="clearfix">
							{{= logo }}
							{{= annualPriceFeaturesTemplate }}
							{{= monthlyPriceFeaturesTemplate }}

							<div class="excess">
								<div class="excessAmount">{{= '$' }}{{= obj.excess }}</div>
								<div class="excessTitle">Excess</div>
							</div>
						</div>

						<h2 class="productTitle">{{= productTitle }}</h2>

						<div class="headerButtonWrapper">
							{{= mainCallToActionButton }}
						</div>

						{{= callActionButtonsFeaturesTemplate }}

						{{ if (promotionText.length > 0) { }}
						<fieldset class="result-special-offer">
							<legend>Special Offer</legend>
							{{= promotionText }}
							{{ if (offerTermsContent.length > 0) { }}
							<a class="small offerTerms" href="javascript:;" ${navBtnAnalAttribute}>Conditions</a>
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
                                <div class="col-xs-12 col-sm-7 col-md-6">
                                    {{= titleDownloadSpecialTemplate }}
                                </div>

                                <div class="col-xs-12 col-sm-5 col-md-6">
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
				<img src="brand/ctm/images/icons/spinning_orange_arrows.gif" class="featuresLoading"/><%-- #WHITELABEL CX --%>
			</div>

		</div>
	</core_v1:js_template>

	<%-- FEATURE TEMPLATE --%>
	<features:resultsItemTemplate />

	<%-- UNAVAILABLE COMBINED ROW --%>
	<core_v1:js_template id="unavailable-combined-template">
		{{ var template = $("#provider-logo-template").html(); }}
		{{ var logo = _.template(template); }}
		{{ var logos = ''; }}
		{{ var brandsKnockedOut = 0; }}
		{{ var $featuresMode = $('.featuresMode'); }}
		{{ _.each(obj, function(result) { }}
			{{ if (result.available !== 'Y') { }}
				{{ brandsKnockedOut++; }}
				{{ logos += logo(result); }}
			{{ } }}
		{{ }) }}
		<div class="result-row result_unavailable_combined notfiltered" data-available="N" style="display:block" data-position="{{= obj.length }}" data-sort="{{= obj.length }}">
			<div class="result">
				{{ if (Results.model.availableCounts == 0) { }}
				<c:choose>
					<c:when test="${brandCode eq 'ctm' && not(environmentCode eq 'NXS')}">
						<agg_v2:no_quotes id="no-results-content"/>
					</c:when>
					<c:otherwise>
						<div class="resultInsert priceMode clearfix">
							<h2>We're sorry but these providers chose not to quote:</h2>
							<div class="logos">{{= logos }}</div>
						</div>
					</c:otherwise>
				</c:choose>
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
							<div class="companyLogo"><img src="assets/graphics/logos/results/{{= obj.productId }}_w.png" /></div>

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

	<%-- FAMOUS --%>
	<div class="hidden famous-results-page">
		<car:famous_results />
	</div>

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
		{{ var img = 'default_w'; }}
		{{ if (obj.hasOwnProperty('productId') && obj.productId.length > 1) img = obj.productId.substring(0, obj.productId.indexOf('-')); }}
		<div class="companyLogo logo_{{= img }}"></div>
	</core_v1:js_template>

</agg_v2_results:results>

<%-- Include call button templates --%>
<agg_v1:results_call_button_templates />

<%-- Include shared priceMode templates --%>
<agg_v1:results_price_mode_templates />

<%-- Include shared featuresMode templates --%>
<agg_v1:results_features_mode_templates />

<%-- Include Price Mode templates --%>
<car:results_price_mode_templates />

<%-- Include Features Mode templates --%>
<car:results_features_mode_templates />
