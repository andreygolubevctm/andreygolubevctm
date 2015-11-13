<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="xpath" value="quote" />

<%-- Smaller Templates to reduce duplicate code --%>
<core:js_template id="car-offline-discount-template">
	<%-- Flag to identify Auto and General product (via the service property) --%>
	{{ obj.isAutoAndGeneral = obj.serviceName.search(/agis_/i) === 0 }}
	<!-- This flag is for specific A&G brands which only feature online products - the balance of
	brands only have a generic offer which is online/offline agnostic -->
	{{ obj.isAutoAndGeneralSpecialCase = obj.isAutoAndGeneral && _.indexOf(['BUDD','VIRG','EXPO','EXDD'], obj.brandCode) >= 0 }}

	{{ obj.offlinePromotionText = ''; }}
	{{ if(typeof obj.discountOffer !== 'undefined' && obj.discountOffer.length > 0)  { }}
	{{ 	obj.offlinePromotionText = obj.discountOffer; }}
	{{ } }}

	{{ obj.offerTermsContent = (typeof obj.discountOfferTerms !== 'undefined' && obj.discountOfferTerms !== null && obj.discountOfferTerms.length > 0) ? obj.discountOfferTerms : ''; }}

	<%-- If not availableOnline (meaning you can't continue online), it should show "Call Centre" offer --%>
	<%-- This copy if bypassed if there's no copy above or it's a flagged A&G product --%>
	{{ if (offlinePromotionText.length > 0 && !obj.isAutoAndGeneralSpecialCase) { }}
	<h5>
		{{ if(!availableOnline) { }}
		Call Centre Offer
		{{ } else { }}
		Special Offer
		{{ } }}
	</h5>

	<div class="promotion">
		<span class="icon icon-tag"></span> {{= offlinePromotionText }}
		{{ if (offerTermsContent.length > 0) { }}
		<a class="small offerTerms" href="javascript:;">Offer terms</a>
		<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
		{{ } }}
	</div>
	{{ } }}
</core:js_template>

<core:js_template id="car-online-discount-template">
	{{ obj.onlinePromotionText = ''; }}
	{{ if(typeof obj.discountOffer !== 'undefined' && obj.discountOffer.length > 0)  { }}
	{{ obj.onlinePromotionText = obj.discountOffer; }}
	{{ } }}

	<%-- Copy bypassed if not online or there's no copy above and only show if it's an
        A&G special case or the online/offline discount is different. --%>
	{{ if (obj.availableOnline == true && obj.onlinePromotionText.length > 0 && (obj.isAutoAndGeneralSpecialCase || obj.onlinePromotionText != obj.offlinePromotionText)) { }}
	<h5>
		Special Online Offer
	</h5>
	<div class="promotion">
		<span class="icon icon-tag"></span> {{= onlinePromotionText }}
		{{ if (offerTermsContent.length > 0) { }}
		<a class="small offerTerms" href="javascript:;">Offer terms</a>
		<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
		{{ } }}
	</div>
	{{ } }}
</core:js_template>

<core:js_template id="car-call-header-template">

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

<core:js_template id="car-call-right-template">

	<div class="text-center">
		<h4>Continue Online</h4>
		<a target="_blank" href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply push-top-10" data-productId="{{= obj.productId }}">Go to Insurer</a>
	</div>
	<div class="row">
		<div class="col-xs-12 text-center">
			{{= onlineDiscountTemplate }}
		</div>
	</div>
</core:js_template>

<core:js_template id="car-call-back-template">
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
					<c:set var="fieldXpath" value="${xpath}/CrClientName" />
					<label for="quote_CrClientName" class="col-lg-4 col-sm-4 col-xs-12 control-label">Your Name</label>
					<div class="col-lg-8 col-sm-8 col-xs-12  row-content">
						<field:person_name xpath="${fieldXpath}" required="true" title="Your name" className="contactField " />
						<div class="fieldrow_legend" id="_row_legend"></div>
					</div>
				</div>
				<div class=" form-group row fieldrow">
					<c:set var="fieldXpath" value="${xpath}/CrClientTel" />
					<label for="quote_CrClientTelinput" class="col-lg-4 col-sm-4 col-xs-12 control-label">Your Contact Number</label>
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
						<a href="javascript:;" class="btn btn-form btn-block btn-submit-callback" data-productId="{{= obj.productId }}">Submit</a><br />
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
			<a class="btn btn-call-inverse btn-block btn-call-actions btn-calldirect" data-productId="{{= obj.productId }}" data-callback-toggle="calldirect" href="javascript:;">Call Insurer Direct</a>
		</div>
	</div>
</core:js_template>

<core:js_template id="car-call-direct-template">
	<!--  text center mobile -->
	{{ var noWhitespaceNum = typeof obj.contact.phoneNumber == 'string' ? obj.contact.phoneNumber.replace(/\s/g, '') : obj.contact.phoneNumber; }}
	<h4>Call Insurer Direct</h4>
	<div class="row push-top-10">
		<div class="col-xs-8 hidden-xs call-ph-num">
			<span class="icon icon-phone"></span> <a href="tel:{{= noWhitespaceNum }}">{{= contact.phoneNumber }}</a>
		</div>
		<div class="col-sm-12 hidden-xs">
			<h5>Call Centre Hours</h5>
			<div>{{= contact.callCentreHours }}</div>
		</div>
		<div class="col-xs-12 visible-xs offlineDiscount">
			{{= offlineDiscountTemplate }}
		</div>
		<div class="col-xs-12 visible-xs push-top-15">
			<a class="needsclick btn btn-call btn-block btn-call-actions btn-calldirect" data-productId="{{= obj.productId }}" href="tel:{{= contact.phoneNumber }}">{{= contact.phoneNumber }}</a>
		</div>
		<div class="col-xs-12 visible-xs">
			<h5>Call Centre Hours</h5>
			<div>{{= contact.callCentreHours }}</div>
		</div>
		<div class="col-sm-12 hidden-xs push-top-10 offlineDiscount">
			{{= offlineDiscountTemplate }}
		</div>
	</div>
	{{ if(obj.contact.allowCallMeBack === true) { }}
	<div class="row push-top-15">
		<div class="col-xs-12 col-sm-6 prefer-callback-text">
			Would you prefer to have the insurer call you?
		</div>
		<div class="col-xs-12 col-sm-6">
			<a class="btn btn-call-inverse btn-block btn-call-actions btn-callback" data-productId="{{= obj.productId }}" href="javascript:;" data-callback-toggle="callback">Get a Call Back</a>
		</div>
	</div>
	{{ } }}
</core:js_template>
<core:js_template id="car-call-modal-template">
	<%-- Set up Reusable Templates --%>
	{{ var template = $("#car-call-header-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.headerTemplate = htmlTemplate(obj); }}

	{{ var template = $("#car-offline-discount-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.offlineDiscountTemplate = htmlTemplate(obj); }}

	{{ var template = $("#car-online-discount-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.onlineDiscountTemplate = htmlTemplate(obj); }}

	{{ var template = $("#car-call-right-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.rightTemplate = htmlTemplate(obj); }}

	<%-- Render it so we have the elements for callDirect --%>
	{{ var template = $("#car-call-back-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.callBackTemplate = htmlTemplate(obj); }}

	{{ var template = $("#car-call-direct-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.callDirectTemplate = htmlTemplate(obj); }}

	{{ var offlineOnly = !availableOnline ? true : false; }}
	{{ var paragraphedContentCols = offlineOnly ? 'col-sm-12' : 'col-sm-8'; }}


	{{= headerTemplate }}

	<div class="row">
		<div class="col-xs-12 {{= paragraphedContentCols}} paragraphedContent border-top callback" style="display:none;">
			{{= callBackTemplate }}
		</div>
		<div class="col-xs-12 {{= paragraphedContentCols}} paragraphedContent border-top calldirect" style="display:none;">
			{{= callDirectTemplate }}
		</div>

		{{ if(!offlineOnly) { }}
		<div class="col-xs-12 col-sm-4 sidebar sidebar-right">
			{{= rightTemplate }}
		</div>
		{{ } }}
	</div>
</core:js_template>