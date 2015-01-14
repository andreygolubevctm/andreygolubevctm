<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Smaller Templates to reduce duplicate code --%>
<core:js_template id="home-offline-discount-template">
<%-- If there's a discount.offline e.g. of "10", display the static text of x% Discount included in price shown, otherwise use headline feature. --%>
{{ obj.offlinePromotionText = ''; }}
{{ if(typeof discount !== 'undefined' && typeof discount.offline !== 'undefined' && discount.offline > 0 && discount.offline !== discount.online) { }}
	{{ 	obj.offlinePromotionText = discount.offline + "% discount offered when you call direct. "; }}
{{ } else if(typeof obj.headline !== 'undefined' && typeof obj.headline.feature !== 'undefined' && obj.headline.feature.length > 0)  { }}
	{{ 	obj.offlinePromotionText = obj.headline.feature; }}
{{ } }}

{{ obj.offerTermsContent = (typeof obj.headline !== 'undefined' && typeof obj.headline.terms !== 'undefined' && obj.headline.terms.length > 0) ? obj.headline.terms : ''; }}

<%-- If the headlineOffer is "OFFLINE" (meaning you can't continue online), it should show "Call Centre" offer --%>
{{ obj.isANGProduct = obj.underwriter.indexOf("Auto & General") >= 0}}
{{ if (((obj.isANGProduct && obj.headlineOffer == "ONLINE") || !obj.isANGProduct) && offlinePromotionText.length > 0) { }}
	<h2>
	{{ if(headlineOffer == "OFFLINE" || discount.offline > 0) { }}
		Call Centre Offer
	{{ } else { }}
		Special Offer
	{{ } }}
	</h2>

	<div class="promotion">
		<span class="icon icon-phone-hollow"></span> {{= offlinePromotionText }}
		{{ if (offerTermsContent.length > 0) { }}
			<a class="small offerTerms" href="javascript:;">Offer terms</a>
			<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
		{{ } }}
	</div>
{{ } }}
</core:js_template>


<core:js_template id="promotion-offer-template">
{{ obj.promotionText = (typeof obj.headline !== 'undefined' && typeof obj.headline.offer !== 'undefined' && obj.headline.offer.length > 0) ? obj.headline.offer : ''; }}
{{ obj.offerTermsContent = (typeof obj.headline !== 'undefined' && typeof obj.headline.terms !== 'undefined' && obj.headline.terms.length > 0) ? obj.headline.terms : ''; }}

{{ if (promotionText.length > 0) { }}
	<h2>Special Offer</h2>
	<div class="promotion">
		<span class="icon icon-tag"></span> {{= promotionText }}
		{{ if (offerTermsContent.length > 0) { }}
			<a class="small offerTerms" href="javascript:;">Offer terms</a>
			<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
		{{ } }}
	</div>
{{ } }}

</core:js_template>

<core:js_template id="online-offer-template">
{{ obj.onlineText = (typeof obj.discount !== 'undefined' &&	typeof obj.discount.offline !== 'undefined' && typeof obj.discount.online !== 'undefined' && obj.discount.online > 0 && obj.discount.offline > 0 && parseInt(obj.discount.online,10) > parseInt(obj.discount.offline,10)) ? obj.discount.online : ''; }}
{{ obj.offerTermsContent = (typeof obj.headline !== 'undefined' && typeof obj.headline.terms !== 'undefined' && obj.headline.terms.length > 0) ? obj.headline.terms : ''; }}

{{ if (onlineText !== 'undefined' && onlineText !== '') { }}
	<h2>Online Offer</h2>
	<div class="online-offer">
		<span class="icon icon-computer"></span> Continue online for a {{= onlineText }}% discount.
		{{ if (offerTermsContent.length) { }}
			<a class="small offerTerms" href="javascript:;">Offer terms</a>
			<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
		{{ } }}
	</div>
{{ } }}

</core:js_template>

<core:js_template id="quote-summary-template">
	<table class="quote-summary-table">
		<thead>
			<tr>
				<th>Cover Type</th>
				<th>Insured Amount</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>

</core:js_template>

<core:js_template id="pds-disclaimer-template">
	<h5>Product Disclosure Statement</h5>
	{{ if (obj.hasOwnProperty('pdsbUrl') === false || obj.pdsbUrl === '') { }}
		<a href="{{= obj.pdsaUrl }}" target="_blank" class="showDoc btn btn-sm btn-download">Product Disclosure Statement</a>
	{{ } else { }}
		<a href="{{= obj.pdsaUrl }}" target="_blank" class="showDoc btn btn-sm btn-download">Product Disclosure A</a>
	<a href="{{= obj.pdsbUrl }}" target="_blank" class="showDoc btn btn-sm btn-download">Product Disclosure B</a>
		{{ if(typeof pdscUrl != 'undefined' && pdscUrl != '') { }}
			<a href="{{= obj.pdscUrl }}" target="_blank" class="showDoc btn btn-sm btn-download btn-download-pds-c">Product Disclosure C</a>
		{{ } }}
	{{ } }}
	<div class="push-top-15">
	<p class="keyFactSheets">By going to the insurer’s site you agree you have accessed the Key Facts Sheets for <a href="{{= obj.hbkfsUrl }}" target="_blank">Home Insurance</a> and <a href="{{= obj.hckfsUrl }}" target="_blank">Contents Insurance</a>.</p>
	<h5>Disclaimer</h5>
	<p>{{= obj.disclaimer }}</p>
	</div>
</core:js_template>

<core:js_template id="call-apply-template">
	<div class="col-xs-12 col-sm-6 col-md-12 push-top-15">
		{{ if(obj.isOnlineAvailable === true) { }}
			<a target="_blank" href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply" data-productId="{{= obj.productId }}">Go to Insurer</a>
		{{ } }}
	</div>
	{{ if(obj.isOfflineAvailable === true) { }}
		{{ if(obj.isCallbackAvailable === true) { }}
			<div class="col-xs-12 col-sm-3 col-md-6 push-top-15">
				<a class="btn btn-call btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;">Call Insurer Direct</a>
			</div>
			<div class="col-xs-12 col-sm-3 col-md-6 push-top-15">
				<a class="btn btn-call btn-block btn-call-actions btn-callback" data-callback-toggle="callback" href="javascript:;">Get a Call Back</a>
			</div>
		{{ } else { }}
			<div class="col-xs-12 col-sm-6 col-md-12 push-top-15">
				<a class="btn btn-call btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;">Call Insurer Direct</a>
			</div>
		{{ } }}
	{{ } }}
</core:js_template>

<core:js_template id="more-info-template">

	<%-- Setup variables --%>
	{{ obj.isOnlineAvailable  = false; }}
	{{ obj.isOfflineAvailable  = false; }}
	{{ obj.isCallbackAvailable  = false; }}
	{{ obj.isOnlineAvailable = obj.onlineAvailable == "Y" }}
	{{ obj.isOfflineAvailable = obj.offlineAvailable == "Y" }}
	{{ obj.isCallbackAvailable = obj.callbackAvailable == "Y" }}

	<%-- Set up Reusable Templates --%>
	{{ var template = $("#promotion-offer-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.promotionOfferHtml = htmlTemplate(obj); }}

	{{ var template = $("#online-offer-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.onlineOfferHtml = htmlTemplate(obj); }}

	{{ template = $("#pds-disclaimer-template").html(); }}
	{{ htmlTemplate = _.template(template); }}
	{{ obj.PdsDisclaimerHtml = htmlTemplate(obj); }}

	{{ template = $("#call-apply-template").html(); }}
	{{ htmlTemplate = _.template(template); }}
	{{ obj.callApplyHtml = htmlTemplate(obj); }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.logoTemplate = htmlTemplate(obj); }}

	{{ var template = $("#monthly-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var monthlyPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $("#annual-price-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var annualPriceTemplate = htmlTemplate(obj); }}

	{{ var template = $("#quote-summary-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ var quoteSummaryHTML = htmlTemplate(obj); }}

	{{ var template = $("#home-offline-discount-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.offlineDiscountTemplate = htmlTemplate(obj); }}

	{{ var homeExcessState = HHB.excess.amount ? '' : 'hidden'; }}
	{{ var contentsExcessState = HHC.excess.amount ? '' : 'hidden'; }}
	{{ if (HHB.excess.amount && HHC.excess.amount) { var excessAlign = ''; } else {var excessAlign = 'right'; } }}



	<div class="displayNone more-info-content {{= brandCode }}">
		<div class="modal-closebar">
			<a href="javascript:;" class="btn btn-close-dialog btn-close-more-info"><span class="icon icon-cross"></span></a>
		</div>
		<div class="row">
			<div class="col-xs-12 col-md-8 paragraphedContent">

				<div class="row moreInfoHeader">
					<div class="col-xs-4 col-sm-2">
						{{= logoTemplate }}
					</div>
					<div class="col-xs-8 col-sm-7 col-md-9">
						<h2 class="productName">{{= headline.name }}</h2>
					</div>
				</div>

				<div class="row detailRow">
					<div class="visible-sm col-sm-6 hidden-md hidden-lg">
						{{= promotionOfferHtml }}
					</div>
					<div class="visible-xs col-xs-4">
						{{= annualPriceTemplate }}
					</div>
					<div class="hidden-xs col-sm-6 col-md-5 col-lg-4 text-right">
						<div class="quoteNumberTitle">{{ if(leadNo != '') { }} Quote Number {{ } }}</div>
						<div class="quoteNumber">{{= leadNo }}</div>
					</div>
					<div class="hidden-xs col-sm-2 hidden-md hidden-lg text-right">
						{{ if (Results.getFrequency() == 'annual' || Results.getFrequency() == 'annually') { }}
							{{= annualPriceTemplate }}
						{{ } else { }}
							{{= monthlyPriceTemplate }}
						{{ } }}
					</div>
					<div class="visible-xs col-xs-4">
						{{= monthlyPriceTemplate }}
					</div>

					<div class="col-xs-3 col-sm-4 hidden-md hidden-lg">
						<div class="col-sm-6 {{= homeExcessState}} {{= excessAlign }} homeExcessContainer">
							<div class="homeExcessAmount">\${{= HHB.excess.amount }}</div>
							<div class="homeExcessTitle">Home Excess</div>
						</div>
						<div class="col-sm-6 {{= contentsExcessState}} {{= excessAlign }} contentsExcessContainer">
							<div class="contentsExcessAmount">\${{= HHC.excess.amount }}</div>
							<div class="contentsExcessTitle">Contents Excess</div>
						</div>
					</div>
					<div class="visible-sm col-sm-6 hidden-md hidden-lg">
						{{= offlineDiscountTemplate }}
					</div>
				</div>

				<!-- Application Buttons Columns -->
				<div class="row hidden-md hidden-lg">{{= callApplyHtml }}</div>

				<div class="row contentRow">

					<div class="quoteSummary">
						{{= quoteSummaryHTML }}
					</div>
					<div class="visible-xs col-xs-12">
						{{= promotionOfferHtml }}
					</div>
					<div class="visible-xs col-xs-12">
						{{= offlineDiscountTemplate }}
					</div>
					<div class="col-xs-12 col-sm-6">
						<div id="inclusions"></div>
						<div id="benefits"></div>
					</div>
					<div class="col-xs-12 col-sm-6">
						{{ if(typeof conditions != 'undefined' && typeof conditions.condition != 'undefined' && conditions.condition.length > 0) { }}
						<div id="home-special-conditions">
							<h5>Special Conditions</h5>
							<ul>
								{{ if(conditions.condition instanceof Array) { }}
									{{ for(var i = 0; i < conditions.condition.length; i++) { }}
										<li>{{= conditions.condition[i] }}</li>
										<%-- If they have special conditions that contain "years old"... --%>
										{{ if(conditions.condition[i].indexOf('years old') != -1) { }}
											{{ window.meerkat.modules.homeMoreInfo.setSpecialConditionDetail(true, conditions.condition[i]); }}
										{{ } }}
									{{ } }}
								{{ } else if(conditions.condition != '') { }}
									<li>{{= conditions.condition }}</li>
									{{ if(conditions.condition.indexOf('years old') != -1) { }}
											{{ window.meerkat.modules.homeMoreInfo.setSpecialConditionDetail(true, conditions.condition); }}
										{{ } else { }}
											{{ window.meerkat.modules.homeMoreInfo.setSpecialConditionDetail(false, ''); }}
										{{ } }}
								{{ } }}
							</ul>
						</div>
						{{ }  else { }}
							{{ window.meerkat.modules.homeMoreInfo.setSpecialConditionDetail(false, ''); }}
						{{ } }}
						{{ if(typeof additionalExcess != 'undefined' && additionalExcess.length > 0) { }}
						<div id="home-additional-excess-conditions">
							<h5>Additional Excess</h5>
							{{= additionalExcess}}
						</div>
						{{ } }}
						<div id="extras"></div>
						<div class="hidden-md hidden-lg">{{= PdsDisclaimerHtml }}</div>
						<div class="hidden-md hidden-lg">
							<h4>&nbsp;</h4>
							<p>Underwriter: {{= underwriter }}</p>
							<p>AFS Licence No: {{= afsLicenceNo }}</p>
						</div>
					</div>
				</div>
			</div>

			<div class="hidden-xs hidden-sm col-md-4 moreInfoRightColumn sidebar sidebar-right">

				<div class="premiumContainer">
					{{ if (Results.getFrequency() == 'annual' || Results.getFrequency() == 'annually') { }}
						{{= annualPriceTemplate }}
					{{ } else { }}
						{{= monthlyPriceTemplate }}
					{{ } }}
				</div>
				<div class="{{= homeExcessState}} homeExcessContainer">
					<div class="homeExcessAmount">\${{= HHB.excess.amount }}</div>
					<div class="homeExcessTitle">Home Excess</div>
				</div>
				<div class="{{= contentsExcessState}} contentsExcessContainer">
					<div class="contentsExcessAmount">\${{= HHC.excess.amount }}</div>
					<div class="contentsExcessTitle">Contents Excess</div>
				</div>

				<div class="promotionOffer">
					{{= promotionOfferHtml }}
				</div>
				<div class="onlineOffer">
					{{= onlineOfferHtml }}
				</div>
				<div class="offlineDiscount">
					{{= offlineDiscountTemplate }}
				</div>
				<!-- Application Buttons Row -->
				<div class="row">{{= callApplyHtml }}</div>

				<!-- PDS & Disclaimer Row/Content -->
				<div class="row">
					<div class="col-xs-12">{{= PdsDisclaimerHtml }}</div>
				</div>

				<div class="push-top-15">
					<p>Underwriter: {{= underwriter }}</p>
					<p>AFS Licence No: {{= afsLicenceNo }}</p>
				</div>
			</div>

		</div>
	</div>
</core:js_template>

<home_new:call_modal />

<core:js_template id="special-conditions-template">
<div class="row">
	<div class="col-xs-12 text-center">
		<p>Please be aware that {{= obj.specialConditionsRule }}</p>
		<p><strong>Would you like to proceed with your purchase?</strong></p>
		<p>&nbsp;</p>
	</div>
	<div class="col-xs-12 col-sm-6 push-top-15">
		<a href="javascript:;" class="btn btn-block btn-back">Select a Different Product</a>
	</div>
		<div class="col-xs-12 col-sm-6 push-top-15">
		<a class="btn btn-next btn-block btn-proceed-to-insurer" href="javascript:;" target="_blank">Proceed to Insurer</a>
		</div>
</div>
</core:js_template>