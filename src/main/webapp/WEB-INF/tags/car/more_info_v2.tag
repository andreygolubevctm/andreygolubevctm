<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- VARIABLES --%>
<c:set var="navBtnAnalAttribute"><field_v1:analytics_attr analVal="nav button" quoteChar="\"" /></c:set>

<core_v1:js_template id="promotion-offer-template">
{{ obj.promotionText = (!_.isUndefined(obj.discountOffer) && !_.isNull(obj.discountOffer) && obj.discountOffer.length > 0) ? obj.discountOffer : ''; }}
{{ obj.offerTermsContent = (!_.isUndefined(obj.discountOfferTerms) && !_.isNull(obj.discountOfferTerms) && obj.discountOfferTerms.length > 0) ? obj.discountOfferTerms : ''; }}

{{ if (promotionText.length > 0) { }}
    <div class="promoHeading">Special offer</div>
    <div class="promoText">
        <span class="icon icon-tag"></span> {{= promotionText }}
        {{ if (offerTermsContent.length > 0) { }}
        <a class="small offerTerms" href="javascript:;" ${navBtnAnalAttribute}>Offer terms</a>
        <div class="offerTerms-content hidden">{{= offerTermsContent }}</div>
        {{ } }}
    </div>
{{ } }}

</core_v1:js_template>

<core_v1:js_template id="pds-template">
	<h5>Product Disclosure Statement</h5>
    <p>Download the PDS documents below for a full guide on policy limits, inclusions &amp; exclusions.</p>
	{{ if (obj.productDisclosures != null) { }}
        <div class="row">
		{{ if (obj.productDisclosures.hasOwnProperty('pdsb') === false) { }}
            <div class="col-xs-12 col-md-6">
			    <a href="{{= obj.productDisclosures.pdsa.url }}" target="_blank" class="showDoc btn btn-download" ${navBtnAnalAttribute}>Product Disclosure Statement</a>
            </div>
		{{ } else { }}
            <div class="col-xs-12 col-sm-6">
			    <a href="{{= obj.productDisclosures.pdsa.url }}" target="_blank" class="showDoc btn btn-download" ${navBtnAnalAttribute}>Product Disclosure A</a>
                </div>
            <div class="col-xs-12 col-sm-6">
			    <a href="{{= obj.productDisclosures.pdsb.url }}" target="_blank" class="showDoc btn btn-download" ${navBtnAnalAttribute}>Product Disclosure B</a>
            </div>
		{{ } }}
        </div>
	{{ } }}
</core_v1:js_template>

<core_v1:js_template id="call-apply-template">
    {{ var template = $("#call-direct-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ obj.callDirectHTML = htmlTemplate(obj); }}

    {{ var template = $("#call-me-back-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ obj.callMeBackHTML = htmlTemplate(obj); }}

    <div class="row call-apply-xs-only">
        {{ if(obj.availableOnline === true) { }}
        <div class="col-xs-12">
            <a target="_blank" href="javascript:;" class="btn btn-cta btn-lg btn-block btn-more-info-apply" data-productId="{{= obj.productId }}" ${navBtnAnalAttribute}>
                Go to Insurer
                <span class="icon icon-arrow-right"></span>
            </a>
        </div>
        {{ } }}

        {{ if(obj.contact.allowCallDirect === true) { }}
            {{ if(obj.contact.allowCallMeBack === true) { }}
            <div class="col-xs-6">
                <a class="btn btn-block btn-call btn-call-actions" data-callback-toggle="calldirect" data-productId="{{= obj.productId }}" href="javascript:;" ${navBtnAnalAttribute}>Call Insurer Direct</a>
            </div>
            <div class="col-xs-6">
                <a class="btn btn-block btn-call btn-call-actions" data-callback-toggle="callback" data-productId="{{= obj.productId }}" href="javascript:;" ${navBtnAnalAttribute}>Get a Call Back</a>
            </div>
            {{ } else { }}
            <div class="col-xs-12">
                <a class="btn btn-block btn-call btn-call-actions" data-callback-toggle="calldirect" data-productId="{{= obj.productId }}" href="javascript:;" ${navBtnAnalAttribute}>Call Insurer Direct</a>
            </div>
            {{ } }}
        {{ } }}
    </div>

    {{= callDirectHTML }}
    {{= callMeBackHTML }}
</core_v1:js_template>

<core_v1:js_template id="call-direct-template">
    <div class="callDirect row">
        <div class="callDirectDetails col-xs-12 col-md-9">
            You may contact the insurer on <span class="contactPhoneNumber">{{= obj.contact.phoneNumber }}</span>
            <span class="callCentreHours">{{= obj.contact.callCentreHours }}</span>
        </div>
        <div class="referenceNo col-xs-12 col-md-3">
            Quote number: <span>{{= quoteNumber }}</span>
        </div>
    </div>
</core_v1:js_template>

<core_v1:js_template id="call-me-back-template">
    <c:set var="xpath" value="quote" />
    <div class="callMeBack row">
        <div class="col-xs-12 col-md-4">
            <h2>Enter your details and we'll get someone to call you</h2>
            <div class="callCentreHours">{{= obj.contact.callCentreHours }}</div>
        </div>
        <div class="col-xs-12 col-md-8">
            <div class="row">
                <form id="getcallback" method="post">
                    <div class="col-xs-12 col-sm-6 col-md-4 row-content">
                        <c:set var="fieldXPath" value="${xpath}/CrClientName" />
                        <field_v1:person_name xpath="${fieldXPath}" required="true" title="Your name" className="contactField" placeholder="Name" />
                        <div class="error-field"></div>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-4 row-content">
                        <c:set var="fieldXPath" value="${xpath}/CrClientTel" />
                        <field_v1:flexi_contact_number xpath="${fieldXPath}"
                                                       maxLength="20"
                                                       required="${true}"
                                                       className="contactField"
                                                       labelName="contact number"
                                                       placeHolder="Phone number"/>
                        <div class="error-field"></div>
                    </div>
                    <div class="col-xs-12 col-md-4">
                        <a href="javascript:;" class="btn btn-form btn-block btn-submit-callback" data-productId="{{= obj.productId }}" ${navBtnAnalAttribute}>Submit</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</core_v1:js_template>

<core_v1:js_template id="more-info-template">
	<%-- Set up Reusable Templates --%>
	{{ var template = $("#promotion-offer-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.promotionOfferHtml = htmlTemplate(obj); }}

	{{ template = $("#pds-template").html(); }}
	{{ htmlTemplate = _.template(template); }}
	{{ obj.PdsHtml = htmlTemplate(obj); }}

	{{ template = $("#call-apply-template").html(); }}
	{{ htmlTemplate = _.template(template); }}
	{{ obj.callApplyHtml = htmlTemplate(obj); }}

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var htmlTemplate = _.template(template); }}
	{{ obj.logoTemplate = htmlTemplate(obj); }}

	<div class="displayNone more-info-content more-info-v2 {{= brandCode }}">
        <div class="modal-closebar">
            <a href="javascript:;" class="btn btn-close-dialog btn-close-more-info"><span class="icon icon-cross"></span></a>
        </div>
		<div class="fieldset-card price-card">
			<div class="row">
				<div class="col-xs-4 col-sm-3">
                    <div class="companyLogoWrapper">
					    {{= logoTemplate }}
                    </div>
                    <div class="referenceNo">Quote number: <span>{{= quoteNumber }}</span></div>
				</div>
				<div class="col-xs-8 col-sm-9">
                    <div class="row">
                        <div class="col-sm-6 col-md-7">
                            <h1 class="productName">{{= productName }}</h1>
                            <div class="promo hidden-xs">
                                {{= promotionOfferHtml }}
                            </div>
                        </div>
                        <div class="col-sm-6 col-md-5">
                            <div class="frequency">
                                <div class="frequencyAmount" data-productId="{{= obj.productId }}">
                                    <span class="dollarSign">$</span><span class="dollars"></span><span class="cents"></span>
                                    <select class="frequency-toggle dontSend" name="frequency_toggle" data-productId="{{= obj.productId }}">
                                        <option value="annual">Annual</option>
                                        <option value="monthly">Monthly</option>
                                    </select>
                                    <div class="monthlyBreakdown">
                                        1st month \${{= obj.price.monthlyFirstMonth.toFixed(2) }} Total: \${{= obj.price.annualisedMonthlyPremium.toFixed(2) }}
                                    </div>
                                    <div>
                                        <span class="excessAmount">\${{= excess }}</span> <span class="excessTitle">EXCESS</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row hidden-xs">
                        {{ if(obj.availableOnline === true) { }}
                        <div class="col-sm-4 col-sm-push-8 col-lg-3 col-lg-push-9">
                            <a target="_blank" href="javascript:;" class="btn btn-cta btn-lg btn-block btn-more-info-apply" data-productId="{{= obj.productId }}" ${navBtnAnalAttribute}>
                                Go to Insurer
                                <span class="icon icon-arrow-right"></span>
                            </a>
                        </div>
                        {{ } }}

                        {{ if(obj.contact.allowCallDirect === true) { }}
                        {{ if(obj.contact.allowCallMeBack === true) { }}
                        <div class="col-sm-4 col-sm-pull-4 col-lg-3 col-lg-pull-0">
                            <a class="btn btn-block btn-call btn-call-actions" data-callback-toggle="calldirect" data-productId="{{= obj.productId }}" href="javascript:;">Call Insurer Direct</a>
                        </div>
                        <div class="col-sm-4 col-sm-pull-4 col-lg-3 col-lg-pull-0">
                            <a class="btn btn-block btn-call btn-call-actions" data-callback-toggle="callback" data-productId="{{= obj.productId }}" href="javascript:;">Get a Call Back</a>
                        </div>
                        {{ } else { }}
                        <div class="col-sm-4 col-lg-3 col-lg-push-3">
                            <a class="btn btn-block btn-call btn-call-actions" data-callback-toggle="calldirect" data-productId="{{= obj.productId }}" href="javascript:;">Call Insurer Direct</a>
                        </div>
                        {{ } }}
                        {{ } }}
                    </div>
				</div>
			</div>

			<div class="promo">
                {{= promotionOfferHtml }}
			</div>

            {{= callApplyHtml }}
		</div>

        <div class="fieldset-card contentRow">
            <div class="row">
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
                        <h5>Excesses</h5>
                        <ul>
                            {{ for(var i = 0; i < additionalExcesses.list.length; i++) { }}
                            <li>{{= additionalExcesses.list[i].description }} {{= additionalExcesses.list[i].amount }}</li> {{ } }}
                        </ul>
                    </div>
                    {{ } }}
                    <h5>Optional Extras</h5>
                    <div id="extras"></div>
                </div>
            </div>
        </div>

        <div class="pds-price-promise row">
            <div class="col-sm-6">
                {{= PdsHtml }}
            </div>
        </div>

        <div class="disclaimer">
            <h5>Disclaimer</h5>
            <p>{{= obj.disclaimer }}</p>
        </div>

        <div class="underwriter">
            <p>Underwriter: {{= underwriter.name }} AFS Licence No: {{= underwriter.afsLicenceNo }}</p>
        </div>
	</div>
</core_v1:js_template>

<car:call_modal />
