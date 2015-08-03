<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="brandedName"><content:get key="boldedBrandDisplayName"/></c:set>

<core:js_template id="promotion-offer-template">
    {{ var promotionText = (typeof obj.discountDetails !== 'undefined' && obj.discountDetails.length > 0) ? obj.discountDetails : ''; }}

    {{ if (promotionText.length > 0) { }}
    <h2>Discount Details</h2>

    <div class="promotion">
        <span class="icon icon-tag"></span> {{= promotionText }}
    </div>
    {{ } }}
</core:js_template>

<core:js_template id="terms-disclaimer-template">
    <h5>Terms</h5>
    <a href="javascript:void(0)" target="_blank" class="showDoc btn btn-sm btn-download termsUrl">Terms &amp; Conditions</a>
    <a href="javascript:void(0)" target="_blank" class="showDoc btn btn-sm btn-download privacyPolicyUrl">Privacy
        Policy</a>

    <div class="push-top-15">
        <h5>Disclaimer</h5>

        <p>${brandedName} is an online comparison website. Energy product information is provided by our trusted
            affiliate, Thought World.</p>
    </div>
</core:js_template>

<core:js_template id="call-apply-template">
    <div class="col-xs-12 col-sm-6 col-md-12 push-top-15">
        <a target="_blank" href="javascript:;" class="btn btn-cta btn-block btn-more-info-apply" data-productId="{{= obj.productId }}">Apply Now</a>
    </div>
    <div class="col-xs-12 col-sm-6 col-md-12 push-top-15">
        <a class="btn btn-call btn-block btn-call-actions btn-calldirect" data-productId="{{= obj.productId }}" data-callback-toggle="calldirect" href="javascript:;">Call Us Now</a>
    </div>
</core:js_template>

<core:js_template id="more-info-template">

    {{ var template = $("#promotion-offer-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ var promotionOfferHtml = htmlTemplate(obj); }}

    {{ template = $("#terms-disclaimer-template").html(); }}
    {{ htmlTemplate = _.template(template); }}
    {{ var termsDisclaimerHtml = htmlTemplate(obj); }}

    {{ template = $("#call-apply-template").html(); }}
    {{ htmlTemplate = _.template(template); }}
    {{ var callApplyHtml = htmlTemplate(obj); }}

    {{ obj.addNoShrinkClass = true; }}
    {{ var template = $("#provider-logo-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ var logoTemplate = htmlTemplate(obj); }}

    {{ var leadNo = meerkat.modules.utilitiesResults.getThoughtWorldReferenceNumber(); }}

    <div class="displayNone more-info-content">
        <div class="modal-closebar">
            <a href="javascript:;" class="btn btn-close-dialog btn-close-more-info"><span
                    class="icon icon-cross"></span></a>
        </div>
        <div class="row">
            <div class="col-xs-12 col-md-8 paragraphedContent">

                <div class="row moreInfoHeader">
                    <div class="col-xs-4 col-sm-2">
                        {{= logoTemplate }}
                    </div>
                    <div class="col-xs-8 col-sm-7 col-md-9">
                        <h2 class="productName">{{= obj.planName }}</h2>
                    </div>
                </div>

                <%-- Small discount + reference No row above call --%>
                <div class="row">
                    <div class="col-sm-6 visible-sm">
                        <div class="promotionOffer">
                            {{= promotionOfferHtml }}
                        </div>
                    </div>
                    <div class="col-sm-3 col-sm-offset-3 col-md-offset-0 col-md-5 col-lg-4 push-top-15 text-right hidden-xs">
                        <div class="quoteNumber">{{= leadNo }}</div>
                        <div class="quoteNumberTitle">{{ if(leadNo != '') { }} Reference no. {{ } }}</div>
                    </div>
                </div>
                <!-- Application Buttons Columns -->
                <div class="row hidden-md hidden-lg">{{= callApplyHtml }}</div>

                <div class="row contentRow">
                    <div class="visible-xs col-xs-12">
                        {{= promotionOfferHtml }}
                    </div>
                    <div class="col-xs-12 push-top-15">
                        <h5>Plan Features</h5>
                        <div id="contractDetails"></div>
                        <div id="billingOptions"></div>

                        <h5>Payment Options</h5>
                        <div id="paymentDetails"></div>

                        <h5>Pricing Information</h5>
                        <div id="pricingInformation"></div>
                    </div>
                    <div class="col-xs-12">
                        <div class="hidden-md hidden-lg">{{= termsDisclaimerHtml }}</div>
                    </div>

                </div>
            </div>

            <div class="hidden-xs hidden-sm col-md-4 moreInfoRightColumn sidebar sidebar-right">

                <div class="promotionOffer">
                    {{= promotionOfferHtml }}
                </div>
                <!-- Application Buttons Row -->
                <div class="row">{{= callApplyHtml }}</div>

                <!-- Terms & Disclaimer Row/Content -->
                <div class="row push-top-15">
                    <div class="col-xs-12">{{= termsDisclaimerHtml }}</div>
                </div>

            </div>

        </div>
    </div>
</core:js_template>

<utilities_new:call_modal />