<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core:js_template id="promotion-offer-template">
{{ obj.promotionText = (typeof obj.headline !== 'undefined' && typeof obj.headline.feature !== 'undefined' && obj.headline.feature.length > 0) ? obj.headline.feature : ''; }}
{{ obj.offerTermsContent = (typeof obj.headline !== 'undefined' && typeof obj.headline.terms !== 'undefined' && obj.headline.terms.length > 0) ? obj.headline.terms : ''; }}

{{ if (promotionText.length > 0) { }}
	<h2 class="text-primary">Special Online Offer</h2>
	<div class="promotion">
		<span class="icon icon-trophy"></span> {{= promotionText }}
		{{ if (offerTermsContent.length > 0) { }}
			<a class="small offerTerms" href="javascript:;">Offer terms</a>
			<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
		{{ } }}
	</div>
{{ } }}

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
	<h5>Disclaimer</h5>
	<p>{{= obj.disclaimer }}</p>
	</div>
</core:js_template>

<core:js_template id="call-apply-template">
	<div class="col-xs-12 col-sm-6 col-md-12 push-top-15">
		{{ if(obj.isOnlineAvailable === true) { }}
			<a href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply" data-productId="{{= obj.productId }}">Apply Online</a>
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
			<div class="col-xs-12 push-top-15">
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
	{{ if($('input[name=quote_vehicle_modifications]:checked').val() == 'Y') { }}
		{{ 	obj.isOnlineAvailable = obj.onlineAvailableWithModifications == "Y" }}
		{{ 	obj.isOfflineAvailable = obj.offlineAvailableWithModifications == "Y" }}
		{{ 	obj.isCallbackAvailable = obj.callbackAvailableWithModifications == "Y" }}
	{{ } else { }}
		{{ 	obj.isOnlineAvailable = obj.onlineAvailable == "Y" }}
		{{ 	obj.isOfflineAvailable = obj.offlineAvailable == "Y" }}
		{{ 	obj.isCallbackAvailable = obj.callbackAvailable == "Y" }}
	{{ } }}

	<%-- Set up Reusable Templates --%>
	{{ var template = $("#promotion-offer-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.promotionOfferHtml = htmlTemplate(obj); }}

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

	<div class="displayNone more-info-content">
		<div class="row">
			<div class="col-xs-12 col-md-8 paragraphedContent">

				<div class="row">
					<div class="col-xs-4 col-sm-2">
						{{= logoTemplate }}
					</div>
					<div class="col-xs-8 col-sm-7 col-md-9">
						<h2 class="productName">{{= headline.name }}</h2>
					</div>
					<div class="visible-sm col-sm-3 text-right">
						<a href="javascript:;" class="btn btn-sm btn-close-more-info btn-back"><span class="icon icon-arrow-left"></span> <span>Back to Product List</span></a>
					</div>
				</div>

				<div class="row">
					<div class="visible-sm col-sm-6 hidden-md hidden-lg">
						{{= promotionOfferHtml }}
					</div>
					<div class="visible-xs col-xs-4">
						{{= annualPriceTemplate }}
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
					<div class="col-xs-3 col-sm-1 hidden-md hidden-lg text-right no-padding">
						<div class="excessAmount">\${{= excess.total }}</div>
						<div class="excessTitle">Excess</div>
					</div>
					<div class="hidden-xs col-sm-3 col-md-5 col-lg-4 text-right">
						<div class="quoteNumber">{{= leadNo }}</div>
						<div class="quoteNumberTitle">{{ if(leadNo != '') { }} Quote Number {{ } }}</div>
					</div>
				</div>

				<!-- Application Buttons Columns -->
				<div class="row hidden-md hidden-lg">{{= callApplyHtml }}</div>

				<div class="row contentRow">
					<div class="visible-xs col-xs-12">
						{{= promotionOfferHtml }}
					</div>
					<div class="col-xs-12 col-sm-6">
						<div id="inclusions"></div>
						<div id="benefits"></div>
					</div>
					<div class="col-xs-12 col-sm-6">
						{{ if(typeof conditions != 'undefined' && typeof conditions.condition != 'undefined' && conditions.condition.length > 0) { }}
						<div id="car-special-conditions">
							<h5>Special Conditions</h5>
							<ul>
								{{ if(conditions.condition instanceof Array) { }}
									{{ for(var i = 0; i < conditions.condition.length; i++) { }}
										<li>{{= conditions.condition[i] }}</li>
										{{ if(conditions.condition[i].indexOf('years old') != -1) { }}
											{{ window.meerkat.modules.carMoreInfo.setSpecialConditionDetail(true, conditions.condition[i]); }}
										{{ } }}
									{{ } }}
								{{ } else if(conditions.condition != '') { }}
									<li>{{= conditions.condition }}</li>
									{{ if(conditions.condition.indexOf('years old') != -1) { }}
											{{ window.meerkat.modules.carMoreInfo.setSpecialConditionDetail(true, conditions.condition); }}
										{{ } }}
								{{ } }}
							</ul>
						</div>
						{{ }  else { }}
							{{ window.meerkat.modules.carMoreInfo.setSpecialConditionDetail(false, ''); }}
						{{ } }}
						{{ if(typeof excess != 'undefined' && typeof excess.excess != 'undefined' && excess.excess.length > 0) { }}
						<div id="car-additional-excess-conditions">
							<h5>Additional Excess</h5>
							<ul>
								{{ for(var i = 0; i < excess.excess.length; i++) { }}
								<li>{{= excess.excess[i].description }} {{= excess.excess[i].amount }}</li> {{ } }}
							</ul>
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
					<div class="excessAmount">\${{= excess.total }}</div>
					<div class="excessTitle">Excess</div>

				</div>

				<a href="javascript:;" class="btn btn-sm btn-close-more-info btn-back"><span class="icon icon-arrow-left"></span> <span>Back to Product List</span></a>
				<div class="promotionOffer">
					{{= promotionOfferHtml }}
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

<car:call_modal />

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
		<a class="btn btn-next btn-block btn-proceed-to-insurer" href="javascript:;">Proceed to insurer</a>
	</div>
</div>
</core:js_template>