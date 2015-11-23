<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="xpath" value="home" />



<core:js_template id="home-promotion-offer-template">
{{ obj.promotionText = (typeof obj.discountOffer !== 'undefined' && obj.discountOffer.length > 0) ? obj.discountOffer : ''; }}
{{ obj.offerTermsContent = (typeof obj.discountOfferTerms !== 'undefined' && obj.discountOfferTerms.length > 0) ? obj.discountOfferTerms : ''; }}

{{ if (promotionText.length > 0) { }}
	<h2>Special Offer</h2>
	<div class="promotion">
		<span class="hidden-xs icon icon-tag"></span> {{= promotionText }}
		{{ if (offerTermsContent.length > 0) { }}
			<a class="small offerTerms" href="javascript:;">Offer terms</a>
			<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
		{{ } }}
	</div>
{{ } }}

</core:js_template>

<core:js_template id="home-online-discount-template">
<%-- If there's a discount.online of e.g. 10 or 20, show x% discount included in price shown. If not, show headline.feature --%>
{{ obj.onlinePromotionText = ''; }}
{{ obj.onlineText = (typeof obj.discount !== 'undefined' &&	typeof obj.discount.offline !== 'undefined' && typeof obj.discount.online !== 'undefined' && obj.discount.online > 0 && obj.discount.offline > 0 && parseInt(obj.discount.online,10) > parseInt(obj.discount.offline,10)) ? obj.discount.online : ''; }}
{{ obj.offerTermsContent = (typeof obj.discountOffer !== 'undefined' && obj.discountOffer.length > 0) ? obj.discountOffer : ''; }}

<%-- If the online/offline discount is the same, or if the headline.feature is the same, don't show the online offer. --%>
{{ if (onlineText == 'undefined' || onlineText === '') { onlineText = ''; } else { onlineText = 'ONLINE OFFER: Continue online for a '+onlineText+'% discount.'; } }}
{{ if (obj.availableOnline) { }}
	<div class="promotion hidden-xs">
		<span class="onlineOfferText">{{= onlineText }}</span>
		{{ if (offerTermsContent.length > 0 && onlineText !== '') { }}
			<a class="small offerTerms" href="javascript:;">Offer terms</a>
			<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
		{{ } }}
	</div>
	<div class="promotion visible-xs">
		<span class="onlineOfferText">Continue Online</span>
	</div>
{{ } }}
</core:js_template>

<core:js_template id="home-call-header-template">

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.logoTemplate = htmlTemplate(obj); }}

	<div class="row">
		<div class="col-xs-4 col-sm-2">
			{{= logoTemplate }}
		</div>
		<div class="col-xs-8 col-sm-6">
			<h2 class="productName">{{= productName }}</h2>
		</div>
		<div class="hidden-xs col-sm-4">
			<div class="quoteNumberTitle">{{ if(quoteNumber != '') { }} Quote Your Reference Number {{ } }}</div>
			<div class="quoteNumber">{{= quoteNumber }}</div>
		</div>
	</div>
</core:js_template>

<core:js_template id="home-call-bottom-template">

	{{ if($.trim(obj.onlineDiscountTemplate) !== '' && obj.transferURL !== ""){ }}
		<div class="col-xs-12 col-sm-6 text-right">
			{{= obj.onlineDiscountTemplate }}
		</div>
		<div class="col-xs-12 col-sm-6 insurerBtn">
			<a target="_blank" href="javascript:;" class="btn btn-fat btn-cta btn-more-info-apply" data-productId="{{= obj.productId }}">Go to Insurer</a>
		</div>
	{{ } }}
	<div class="col-xs-4 visible-xs text-right push-top-15">
		{{ if (Results.getFrequency() == 'annual' || Results.getFrequency() == 'annually') { }}
			{{= obj.annualPriceTemplate }}
		{{ } else { }}
			{{= obj.monthlyPriceTemplate }}
		{{ } }}
	</div>
	<div class="col-xs-8 visible-xs push-top-15">
		{{= promotionOfferTemplate }}
	</div>
</core:js_template>

<core:js_template id="home-call-back-template">
	<!--  text center mobile -->
	<h4>Get a Call Back</h4>
	<div class="row">
		<div class="col-xs-12 offlineDiscount">
			{{= offlineDiscountTemplate }}
		</div>
	</div>

	<h6 class="callback-details-title push-top-15">Enter your details below and we'll get someone to call you.</h6>
	<div class="row push-top-15">
		<div class="col-xs-12">
			<form id="getcallback" method="post" class="form-horizontal">

				<div class=" form-group row fieldrow">
					<c:set var="fieldXPath" value="${xpath}/CrClientName" />
					<label for="${fieldXPath}" class="col-lg-4 col-sm-4 col-xs-12 control-label">Your Name</label>
					<div class="col-lg-8 col-sm-8 col-xs-12  row-content">
						<field:person_name xpath="${fieldXPath}" required="true" title="Your name" className="contactField" />
						<div class="fieldrow_legend" id="_row_legend"></div>
					</div>
				</div>
				<div class=" form-group row fieldrow">
					<c:set var="fieldXPath" value="${xpath}/CrClientTel" />
					<label for="${fieldXPath}input" class="col-lg-4 col-sm-4 col-xs-12 control-label">Your Contact Number</label>
					<div class="col-lg-8 col-sm-8 col-xs-12  row-content">
						<field:flexi_contact_number xpath="${fieldXPath}"
													maxLength="20"
													required="${true}"
													className="contactField"
													labelName="contact number"/>
						<div class="fieldrow_legend" id="_row_legend"></div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12 col-sm-6 col-sm-offset-6">
						<a href="javascript:;" class="btn btn-form btn-block btn-submit-callback">Submit</a><br />
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="row push-top-15">
		<div class="col-xs-12 col-sm-6 text-right prefer-callback-text">
			Would you prefer to call direct?
		</div>
		<div class="col-xs-12 col-sm-6">
			<a class="btn btn-call-inverse btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;">Call Insurer Direct</a>
		</div>
	</div>
</core:js_template>

<core:js_template id="home-call-direct-template">
	<!--  text center mobile -->
	{{ var noWhitespaceNum = typeof obj.contact.phoneNumber == 'string' ? obj.contact.phoneNumber.replace(/\s/g, '') : obj.contact.phoneNumber; }}
	<div class="row push-top-10">
		<div class="col-xs-12 col-sm-6">
			<div class="visible-xs col-xs-12">
				<h2>Call Insurer Direct</h2>
			</div>
			<div class="hidden-xs call-ph-num">
				<span class="icon icon-phone-hollow"></span> <a href="tel:{{= noWhitespaceNum }}">{{= contact.phoneNumber }}</a>
			</div>
			<div class="col-xs-4 visible-xs text-right push-top-15">
				{{ if (Results.getFrequency() == 'annual' || Results.getFrequency() == 'annually') { }}
					{{= obj.annualPriceTemplate }}
				{{ } else { }}
					{{= obj.monthlyPriceTemplate }}
				{{ } }}
			</div>
			<div class="col-xs-8 visible-xs push-top-15">
				{{= promotionOfferTemplate }}
			</div>
			<div class="col-xs-12 visible-xs push-top-15">
				<a class="needsclick btn btn-call btn-block btn-call-actions btn-calldirect" href="tel:{{= contact.phoneNumber }}">{{= contact.phoneNumber }}</a>
			</div>
			<div class="hidden-xs">
				<h2>Call Centre Opening Hours</h2>
				<div>{{= contact.callCentreHours }}</div>
			</div>
		</div>
		<div class="col-xs-12 col-sm-6">
			<div class="hidden-xs">
				{{= promotionOfferTemplate }}
			</div>
			<div class="hidden-xs push-top-10 offlineDiscount">
				{{= offlineDiscountTemplate }}
			</div>
			{{ if(obj.contact.allowCallMeBack === true) { }}
				<div class="prefer-callback-text">
					Would you prefer to have the insurer call you?
				</div>
				<div class="">
					<a class="btn btn-call-inverse btn-block btn-call-actions btn-callback" href="javascript:;" data-callback-toggle="callback">Get a Call Back</a>
				</div>
			{{ } }}
		</div>
	</div>
</core:js_template>
<core:js_template id="home-call-modal-template">
	<%-- Set up Reusable Templates --%>
	{{ var template = $("#home-call-header-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.headerTemplate = htmlTemplate(obj); }}

	{{ var template = $("#home-promotion-offer-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.promotionOfferTemplate = htmlTemplate(obj); }}

	{{ var template = $("#home-online-discount-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.onlineDiscountTemplate = htmlTemplate(obj); }}

	{{ var template = $("#home-call-bottom-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.bottomTemplate = htmlTemplate(obj); }}

	<%-- Render it so we have the elements for callDirect --%>
	{{ var template = $("#home-call-back-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.callBackTemplate = htmlTemplate(obj); }}

	{{ var template = $("#home-call-direct-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.callDirectTemplate = htmlTemplate(obj); }}

	{{ var offlineOnly = !availableOnline ? true : false; }}
	{{ var paragraphedContentCols = offlineOnly ? 'col-sm-12' : 'col-sm-12'; }}

	{{= headerTemplate }}

	<div class="row">
		<div class="col-xs-12 {{= paragraphedContentCols}} paragraphedContent border-top callback" style="display:none;">
			{{= callBackTemplate }}
		</div>
		<div class="col-xs-12 {{= paragraphedContentCols}} paragraphedContent border-top calldirect" style="display:none;">
			{{= callDirectTemplate }}
		</div>

		{{ if(!offlineOnly) { }}
			<div class="col-xs-12 bottombar">
				{{ if($.trim(bottomTemplate) !== '') { }}
					{{= bottomTemplate }}
				{{ } else { }}
					{{= promotionOfferTemplate }}
				{{ } }}
			</div>
		{{ } }}
	</div>
</core:js_template>