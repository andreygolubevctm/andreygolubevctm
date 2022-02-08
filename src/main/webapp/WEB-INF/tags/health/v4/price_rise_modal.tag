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
        </div>
    </div>

    <hr />

    <div class="row">
        <div class="col-xs-12">
            <h3>What else contributes to premiums changing?</h3>
            <h4>Australian Government Rebate</h4>
            <p>To assist in making private health insurance more affordable, the government provides many Australians with a rebate, known as the Australian Government Rebate on Private Health Insurance (AGR).</p>
            <h4>The rebate can be used to:</h4>
            <ol>
                <li>Reduce your premiums <span class="text-bold">OR</span></li>
                <li>Claimed when you lodge your tax return with the Australian Taxation Office</li>
            </ol>
            <h4>Rebate adjustment factor</h4>
            <p>Each year the Government provides health funds with a rebate adjustment factor which will be applied to each member’s premium (after any applicable discounts) and determine by their income tier and age. The adjusted rebate will automatically apply to any premium payments made on or after 1 April each year.</p>
        </div>
    </div>

    <div class="row text-center">
        <div class="col-xs-12 vertical-center-items">
            <a href="javascript:;" class="btn btn-lg price-rise-banner-close-btn">
                <span class="dual-pricing-frequency-ok-text">OK, got it</span>
            </a>
            <div>Need to review your cover? <span class="text-bold">Call our experts on </span><a href="tel: ${callCentreNumber}"><span class="icon icon-phone-hollow"/>${callCentreNumber}</a></div>
        </div>
    </div>
</core_v1:js_template>
