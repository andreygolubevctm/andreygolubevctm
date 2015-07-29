<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core:js_template id="promotion-offer-template">
{{ obj.promotionText = (typeof obj.discountOffer !== 'undefined' && obj.discountOffer.length > 0) ? obj.discountOffer : ''; }}
{{ obj.offerTermsContent = (typeof obj.discountOfferTerms !== 'undefined' && obj.discountOfferTerms != null && obj.discountOfferTerms.length > 0) ? obj.discountOfferTerms : ''; }}

{{ if (promotionText.length > 0) { }}
	<h2>Special Online Offer</h2>
	<div class="promotion">
		<span class="icon icon-tag"></span> {{= promotionText }}
		{{ if (offerTermsContent.length > 0) { }}
			<a class="small offerTerms" href="javascript:;">Offer terms</a>
			<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
		{{ } }}
	</div>
{{ } }}

</core:js_template>

<core:js_template id="pds-disclaimer-template">
	<h5>Product Disclosure Statement</h5>
	{{ if (obj.productDisclosures != null) { }}
		{{ if (obj.productDisclosures.hasOwnProperty('pdsb') === false) { }}
			<a href="{{= obj.productDisclosures.pdsa.url }}" target="_blank" class="showDoc btn btn-sm btn-download">Product Disclosure Statement</a>
		{{ } else { }}
			<a href="{{= obj.productDisclosures.pdsa.url }}" target="_blank" class="showDoc btn btn-sm btn-download">Product Disclosure A</a>
			<a href="{{= obj.productDisclosures.pdsb.url }}" target="_blank" class="showDoc btn btn-sm btn-download">Product Disclosure B</a>
			{{ if(obj.productDisclosures.hasOwnProperty('pdsc')) { }}
				<a href="{{= obj.productDisclosures.pdsc.url }}" target="_blank" class="showDoc btn btn-sm btn-download btn-download-pds-c">Product Disclosure C</a>
			{{ } }}
		{{ } }}
	{{ } }}
	<div class="push-top-15">
	<h5>Disclaimer</h5>
	<p>{{= obj.disclaimer }}</p>
	</div>
</core:js_template>

<core:js_template id="call-apply-template">
	<div class="col-xs-12 col-sm-6 col-md-12 push-top-15">
		{{ if(obj.availableOnline === true) { }}
			<a target="_blank" href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply" data-productId="{{= obj.productId }}">Go to Insurer</a>
		{{ } }}
	</div>
	{{ if(obj.contact.allowCallDirect === true) { }}
		{{ if(obj.contact.allowCallMeBack === true) { }}
			<div class="col-xs-12 col-sm-3 col-md-6 push-top-15">
				<a class="btn btn-call btn-block btn-call-actions btn-calldirect" data-productId="{{= obj.productId }}" data-callback-toggle="calldirect" href="javascript:;">Call Insurer Direct</a>
			</div>
			<div class="col-xs-12 col-sm-3 col-md-6 push-top-15">
				<a class="btn btn-call btn-block btn-call-actions btn-callback" data-productId="{{= obj.productId }}" data-callback-toggle="callback" href="javascript:;">Get a Call Back</a>
			</div>
		{{ } else { }}
			<div class="col-xs-12 col-sm-6 col-md-12 push-top-15">
				<a class="btn btn-call btn-block btn-call-actions btn-calldirect" data-productId="{{= obj.productId }}" data-callback-toggle="calldirect" href="javascript:;">Call Insurer Direct</a>
			</div>
		{{ } }}
	{{ } }}
</core:js_template>

<core:js_template id="more-info-template">

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
						<h2 class="productName">{{= productName }}</h2>
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
						<div class="excessAmount">\${{= excess }}</div>
						<div class="excessTitle">Excess</div>
					</div>
					<div class="hidden-xs col-sm-3 col-md-5 col-lg-4 text-right">
						<div class="quoteNumber">{{= quoteNumber }}</div>
						<div class="quoteNumberTitle">{{ if(quoteNumber != '') { }} Quote Number {{ } }}</div>
					</div>
				</div>

				<!-- Application Buttons Columns -->
				<div class="row hidden-md hidden-lg">{{= callApplyHtml }}</div>

				<div class="row contentRow">
					<div class="visible-xs col-xs-12">
						{{= promotionOfferHtml }}
					</div>
					<div class="col-xs-12 col-sm-6">
						<h5>What's Included</h5>
						<div id="inclusions"></div>
						<h5>Further Benefits</h5>
						<div id="benefits"></div>
					</div>
					<div class="col-xs-12 col-sm-6">
						{{ if(specialConditions != null && typeof specialConditions != 'undefined' && typeof specialConditions.list != 'undefined' && specialConditions.list.length > 0) { }}
						<div id="car-special-conditions">
							<h5>Special Conditions</h5>
							<ul>
								{{ if(specialConditions.list instanceof Array) { }}
									{{ var ageBasedConditions = 0; }}
									{{ for(var i = 0; i < specialConditions.list.length; i++) { }}
										<li>{{= specialConditions.list[i] }}</li>
										<%-- If they have special conditions that contain "years old"... --%>
										{{ if(specialConditions.list[i].indexOf('years old') != -1) { }}
											{{ window.meerkat.modules.carMoreInfo.setSpecialConditionDetail(true, specialConditions.list[i]); }}
											{{ ageBasedConditions++; }}
										{{ } }}
									{{ } }}
									{{ if(ageBasedConditions === 0) { }}
										{{ window.meerkat.modules.carMoreInfo.setSpecialConditionDetail(false, ''); }}
									{{ } }}
								{{ } }}
							</ul>
						</div>
						{{ }  else { }}
							{{ window.meerkat.modules.carMoreInfo.setSpecialConditionDetail(false, ''); }}
						{{ } }}
						{{ if(additionalExcesses != null && typeof additionalExcesses != 'undefined' && typeof additionalExcesses.list != 'undefined' && additionalExcesses.list.length > 0) { }}
						<div id="car-additional-excess-conditions">
							<h5>Additional Excess</h5>
							<ul>
								{{ for(var i = 0; i < additionalExcesses.list.length; i++) { }}
								<li>{{= additionalExcesses.list[i].description }} {{= additionalExcesses.list[i].amount }}</li> {{ } }}
							</ul>
						</div>
						{{ } }}
						<h5>Optional Extras</h5>
						<div id="extras"></div>
						<div class="hidden-md hidden-lg">{{= PdsDisclaimerHtml }}</div>
						<div class="hidden-md hidden-lg">
							<h4>&nbsp;</h4>
							<p>Underwriter: {{= underwriter.name }}</p>
							<p>AFS Licence No: {{= underwriter.afsLicenceNo }}</p>
							<car:price_promise className="inverted" />
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
					<div class="excessAmount">\${{= excess }}</div>
					<div class="excessTitle">Excess</div>

				</div>

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
					<p>Underwriter: {{= underwriter.name }}</p>
					<p>AFS Licence No: {{= underwriter.afsLicenceNo }}</p>
				</div>

				<car:price_promise />
			</div>

		</div>
	</div>
</core:js_template>

<car:call_modal_ws />

<core:js_template id="special-conditions-template">
<div class="row">
	<div class="col-xs-12 text-center">
		<p>Please be aware that {{= obj.specialConditionsRule }}</p>
		<p><strong>Would you like to  with your purchase?</strong></p>
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