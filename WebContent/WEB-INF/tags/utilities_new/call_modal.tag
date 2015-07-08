<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="utilities-call-header-template">

    {{ var template = $("#provider-logo-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ obj.logoTemplate = htmlTemplate(obj); }}
    {{ var leadNo = meerkat.modules.utilitiesResults.getThoughtWorldReferenceNumber(); }}

    <div class="row">
        <div class="col-xs-4 col-sm-2">
            {{= logoTemplate }}
        </div>
        <div class="col-xs-8 col-sm-6">
            <h2 class="productName">{{= obj.planName }}</h2>
        </div>
        <div class="hidden-xs col-sm-4">
            <div class="quoteNumberTitle">{{ if(leadNo != '') { }} Quote Your Reference Number {{ } }}</div>
            <div class="quoteNumber">{{= leadNo }}</div>
        </div>
    </div>
</core:js_template>

<core:js_template id="utilities-call-direct-template">
    <!-- text center mobile -->
    {{ var telNo = '${callCentreNumber}'; }}
    {{ var noWhitespaceNum = typeof telNo == 'string' ? telNo.replace(/\s/g, '') : telNo; }}

    <h4>Call Thought World Direct</h4>

    <div class="row push-top-10">
        <div class="col-xs-8 hidden-xs call-ph-num">
            <span class="icon icon-phone"></span> <a href="tel:{{= noWhitespaceNum }}">{{= telNo }}</a>
        </div>
        <div class="col-sm-12 hidden-xs">
            <h5>Call Centre Hours</h5>

            <div><content:get key="utilitiesOpeningHours"/></div>
        </div>
        <div class="col-xs-12 visible-xs push-top-15">
            <a class="needsclick btn btn-call btn-block btn-call-actions btn-calldirect"
               data-productId="{{= obj.productId }}" href="tel:{{= noWhitespaceNum }}">{{= telNo }}</a>
        </div>
        <div class="col-xs-12 visible-xs">
            <h5>Call Centre Hours</h5>

            <div><content:get key="utilitiesOpeningHours"/></div>
        </div>
    </div>
</core:js_template>
<core:js_template id="utilities-call-modal-template">
    <%-- Set up Reusable Templates --%>
    {{ var template = $("#utilities-call-header-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ obj.headerTemplate = htmlTemplate(obj); }}

    {{ var template = $("#utilities-call-direct-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ obj.callDirectTemplate = htmlTemplate(obj); }}

    {{= headerTemplate }}
    {{ var template = $("#promotion-offer-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ obj.promotionOfferHtml = htmlTemplate(obj); }}

    <div class="row">
        <div class="col-xs-12 col-sm-8 paragraphedContent border-top calldirect" style="display:none;">
            {{= callDirectTemplate }}
        </div>
        <div class="col-xs-12 col-sm-4 sidebar sidebar-right">
            <div class="row">
                <div class="col-xs-12 text-center promotion">
                    {{= obj.promotionOfferHtml }}
                </div>
            </div>
        </div>
    </div>
</core:js_template>