<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="xpath" value="quote" />

<%-- Smaller Templates to reduce duplicate code --%>
<core:js_template id="car-offline-discount-template">
<%-- If there's a discount.offline e.g. of "10", display the static text of x% Discount included in price shown, otherwise use headline feature. --%>
{{ obj.offlinePromotionText = ''; }}
{{ if(typeof discount !== 'undefined' && typeof discount.offline !== 'undefined' && discount.offline > 0) { }}
	{{ 	obj.offlinePromotionText = discount.offline + "% Discount included in price shown"; }}
{{ } else if(typeof obj.headline !== 'undefined' && typeof obj.headline.feature !== 'undefined' && obj.headline.feature.length > 0)  { }}
	{{ 	obj.offlinePromotionText = obj.headline.feature; }}
{{ } }}

{{ obj.offerTermsContent = (typeof obj.headline !== 'undefined' && typeof obj.headline.terms !== 'undefined' && obj.headline.terms.length > 0) ? obj.headline.terms : ''; }}

<%-- If the headlineOffer is "OFFLINE" (meaning you can't continue online), it should show "Call Centre" offer --%>
{{ obj.isANGProduct = obj.underwriter.indexOf("Auto & General") >= 0}}
{{ if (((obj.isANGProduct && obj.headlineOffer == "ONLINE") || !obj.isANGProduct) && offlinePromotionText.length > 0) { }}
	<h5>
	{{ if(headlineOffer == "OFFLINE" || discount.offline > 0) { }}
		Call Centre Offer
	{{ } else { }}
		Special Offer
	{{ } }}
	</h5>

	<div class="promotion">
		<span class="icon icon-trophy"></span> {{= offlinePromotionText }}
		{{ if (offerTermsContent.length > 0) { }}
			<a class="small offerTerms" href="javascript:;">Offer terms</a>
			<div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
		{{ } }}
	</div>
{{ } }}
</core:js_template>

<core:js_template id="car-online-discount-template">
<%-- If there's a discount.online of e.g. 10 or 20, show x% discount included in price shown. If not, show headline.feature --%>
{{ obj.onlinePromotionText = ''; }}
{{ if(typeof discount !== 'undefined' && typeof discount.online !== 'undefined' && discount.online > 0) { }}
	{{ obj.onlinePromotionText = discount.online + "% Discount included in price shown"; }}
{{ } else if(typeof obj.headline !== 'undefined' && typeof obj.headline.feature !== 'undefined' && obj.headline.feature.length > 0)  { }}
	{{ obj.onlinePromotionText = obj.headline.feature; }}
{{ } }}

<%-- If the online/offline discount is the same, or if the headline.feature is the same, don't show the online offer. --%>
{{ if (obj.onlineAvailable == "Y" && onlinePromotionText.length > 0 && onlinePromotionText != offlinePromotionText) { }}
	<h5>
	Special Online Offer
	</h5>
	<div class="promotion">
		<span class="icon icon-trophy"></span> {{= onlinePromotionText }}
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
			<h2 class="productName">{{= headline.name }}</h2>
		</div>
		<div class="hidden-xs col-sm-4">
			<div class="quoteNumberTitle">{{ if(leadNo != '') { }} Quote Your Reference Number {{ } }}</div>
			<div class="quoteNumber">{{= leadNo }}</div>
		</div>
	</div>
</core:js_template>

<core:js_template id="car-call-right-template">

	<div class="text-center">
		<h4>Continue Online</h4>
		<a target="_blank" href="/${pageSettings.getContextFolder()}{{= meerkat.modules.carMoreInfo.getTransferUrl(obj) }}" class="btn btn-cta btn-block btn-more-info-apply push-top-10" data-productId="{{= obj.productId }}">Go to Insurer</a>
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
		<div class="col-xs-12">
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
						<field:person_name xpath="${fieldXpath}" required="true" title="Your name" className="contactField sessioncamexclude" />
						<div class="fieldrow_legend" id="_row_legend"></div>
					</div>
				</div>
				<div class=" form-group row fieldrow">
					<c:set var="fieldXpath" value="${xpath}/CrClientTel" />
					<label for="quote_CrClientTelinput" class="col-lg-4 col-sm-4 col-xs-12 control-label">Your Contact Number</label>
					<div class="col-lg-8 col-sm-8 col-xs-12  row-content">
						<field:contact_telno xpath="${fieldXpath}" required="true" title="Your contact number" className="contactField sessioncamexclude" />
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
			<a class="btn btn-call btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;">Call Insurer Direct</a>
		</div>
	</div>
</core:js_template>

<core:js_template id="car-call-direct-template">
	<!--  text center mobile -->
	{{ var noWhitespaceNum = typeof obj.telNo == 'string' ? obj.telNo.replace(/\s/g, '') : obj.telNo; }}
	<h4>Call Insurer Direct</h4>
	<div class="row push-top-10">
		<div class="col-xs-8 hidden-xs call-ph-num">
			<span class="icon icon-phone"></span> <a href="tel:{{= noWhitespaceNum }}">{{= telNo }}</a>
		</div>
		<div class="col-xs-12 visible-xs">
			{{= offlineDiscountTemplate }}
		</div>
		<div class="col-xs-12 visible-xs push-top-15">
			<a class="btn btn-call btn-block btn-call-actions btn-calldirect" href="tel:{{= noWhitespaceNum }}">{{= telNo }}</a>
		</div>
		<div class="col-sm-12 hidden-xs push-top-10">
			{{= offlineDiscountTemplate }}
		</div>
	</div>
	{{ if(obj.isCallbackAvailable === true) { }}
		<div class="row push-top-15">
			<div class="col-xs-12 col-sm-6 prefer-callback-text">
				Would you prefer to have the insurer call you?
			</div>
			<div class="col-xs-12 col-sm-6">
				<a class="btn btn-call btn-block btn-call-actions btn-callback" href="javascript:;" data-callback-toggle="callback">Get a Call Back</a>
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

	{{ var offlineOnly = headlineOffer == 'OFFLINE' ? true : false; }}
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