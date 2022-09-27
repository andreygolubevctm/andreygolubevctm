<%@ tag description="Dual Pricing learn more modal"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>

<core_v1:js_template id="price-rise-banner-template">
    <div class="row">
        <div class="col-xs-12 vertical-center-items">
            <div class="price-up-img"/>
            <h2>Some premiums are rising</h2>
        </div>
    </div>

    <div class="row">
        <div class="col-xs-12">
            <h3>Why are health insurance premiums reviewed annually?</h3>
            <p>Each year, all health funds review their premiums to balance the growing costs of healthcare and to support the rising demand for health services, the increase in chronic health concerns, and the beneficial but costly advances in technology for better health outcomes.</p>
            <p>Some funds updated their premiums on 1 April. However, this year many funds have chosen to delay their rate rises to later in the year. For those funds the premiums will remain the same for now and you will receive confirmation from the fund closer to the time the premiums will change. We’ll also show you the new pricing for a fund up to one month before it takes effect.</p>
            <p>If you find a great deal today, you can pay up to 12 months in advance to enjoy today’s price for longer. Even if you pay in advance, you can switch at any time if you find a better deal.</p>
            <p>You can learn more about the 2022 rate rise <a target='_new' href="https://www.comparethemarket.com.au/2022-rate-rise-guide/">here</a>.</p>
        </div>
    </div>

    <div class="row text-center">
        <div class="col-xs-12 vertical-center-items">
            <a href="javascript:;" class="btn btn-lg price-rise-banner-close-btn">
                <span class="dual-pricing-frequency-ok-text">OK, got it</span>
            </a>
            <div>Need more information? <span class="text-bold">Call our experts on </span><a href="tel: ${callCentreNumber}"><span class="icon icon-phone-hollow"/>${callCentreNumber}</a></div>
        </div>
    </div>
</core_v1:js_template>
