<%@ tag description="Dual Pricing learn more modal"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>

<core_v1:js_template id="dual-pricing-modal-template">
    <div class="row">
        <div class="col-xs-12 col-sm-4"><h2>Premiums are rising</h2></div>
        <div class="col-sm-8 hidden-xs need-to-review-cover">
            Need to review your cover? Our experts are ready to <a href="javascript:;" data-toggle="dialog" data-content="#view_all_hours" data-dialog-hash-id="view_all_hours" data-title="Call Centre Hours" data-cache="true">talk</a><a href="javascript:;" class="live-chat"> or chat</a>.
        </div>
    </div>

    <hr />

    <div class="row">
        <div class="col-xs-12">
            Health funds adjust their premiums on April 1st every year. The prices we've shown you reflect premiums before and after April 1st 2017.
        </div>
    </div>

    <div class="row">
        <div class="col-xs-12 text-center">
            <span class="dual-pricing-highlight">In order to lock-in the cheaper premium for the full year, you must:</span>
        </div>
    </div>

    <div class="row text-center">
        <div class="col-sm-5">
            Start your cover before
            <br>
            <span class="dual-pricing-highlight dual-pricing-date">April 1st</span>
        </div>

        <div class="col-sm-2">
            <span class="rounded-gray-bg">and</span>
        </div>

        <div class="col-sm-5">
            Pay your <b>annual premium in full</b> by
            <br>
            <span class="dual-pricing-highlight dual-pricing-date">{{= obj.dropDeadDate }}</span>
        </div>
    </div>

    <hr />

    <div class="row">
        <div class="col-xs-12">
            <small>Alternatively, if you elect to pay your premium weekly, fortnightly, quarterly or half-yearly before {{= obj.dropDeadDate }}, <b>only the first payment will be at the current amount. Thereafter, the new premium will apply.</b></small>
        </div>
    </div>

    <div class="row hidden-sm hidden-md hidden-lg text-center">
        <div class="col-xs-12">
            <hr />
            Need to review your cover? Talk to our experts on:
            <h1><a href="tel: ${callCentreNumber}">${callCentreNumber}</a></h1>
        </div>
    </div>
</core_v1:js_template>