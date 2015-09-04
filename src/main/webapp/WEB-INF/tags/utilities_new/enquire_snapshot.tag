<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="brandedName"><content:get key="boldedBrandDisplayName"/></c:set>

<div class="hidden-xs">
    <form_new:fieldset legend="Snapshot of Your Details" className="quoteSnapshot ">
        <div class="row snapshot">
            <div class="col-sm-3">
                <div class="icon icon-energy"></div>
            </div>
            <div class="col-sm-9">
                <div class="row">
                    <div class="col-sm-12 snapshot-title">
                        <!-- SessionCam:Hide -->
                        <span data-source="#utilities_application_details_firstName"
                              data-alternate-source="#utilities_resultsDisplayed_firstName"></span>
                        <span data-source="#utilities_application_details_lastName"></span>
                        <!-- /SessionCam:Hide -->
                    </div>

                    <div class="col-sm-12 snapshotSituation"></div>
                </div>
            </div>
        </div>
    </form_new:fieldset>
    <div class="product-snapshot">
    </div>
    <div class="comparison-rate-disclaimer">
        <h5 class="small">Disclaimer</h5>

        <p class="small">${brandedName} is an online comparison website. Energy product information is provided by our
            trusted affiliate, Thought World.</p>
    </div>
</div>
<core:js_template id="enquire-snapshot-template">

    {{ var template = $("#provider-logo-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ var logoTemplate = htmlTemplate(obj); }}

    {{ var providerData = meerkat.modules.moreInfo.getDataResult(); }}
    <form_new:fieldset legend="Your Energy Plan">
        <%-- Header --%>
        <div class="row snapshot-product-header">
            <div class="col-sm-5 col-md-4 col=lg-3 logoContainer">{{= logoTemplate }}</div>
            <div class="col-xs-7 col-md-8 col=lg-9">
                <h4>{{= obj.retailerName}}</h4>
                {{= obj.planName}}
            </div>
        </div>
        <%-- Benefits --%>
        <div class="row push-top-15">
            <div class="col-xs-12">
                {{ if (typeof obj.discountDetails !== 'undefined' && obj.discountDetails.length > 0) { }}
                <div class="promotion">
                    <h5>Discounts:</h5>

                    <div>{{= obj.discountDetails }}</div>
                </div>
                {{ } }}
            </div>
            <div class="col-xs-12 snapshot-rates">

                <h5 class="push-top-15">Plan Features</h5>

                <div>{{= providerData.contractDetails }}</div>
                <div>{{= providerData.billingOptions }}</div>

                <h5 class="push-top-15">Payment Options</h5>

                <div>{{= providerData.paymentDetails }}</div>
            </div>
        </div>
    </form_new:fieldset>
</core:js_template>