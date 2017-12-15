<%@ tag description="Dual Pricing learn more modal"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>

<core_v1:js_template id="dual-pricing-modal-template">
    <div class="row">
        <div class="col-xs-12 text-center">
            <h2><span class="icon-arrow-thick-up"></span> Premiums are rising</h2>
        </div>
    </div>

    <div class="row">
        <div class="col-xs-12 text-center">
            Health funds adjust their premiums on April 1st every year. The amounts you see reflect the premiums <span class="text-bold">before</span> and <span class="text-bold">after</span> April 1st, 2018.
        </div>
    </div>

    <div class="row">
        <div class="col-xs-12 text-center">
            <span class="dual-pricing-highlight">To lock-in the cheaper premium for the full year you must:</span>
        </div>
    </div>

    <div class="row text-center">
        <div class="col-sm-3 col-sm-offset-2">
            Start your <br class="hidden-xs"/>cover before
            <br>
            <span class="dual-pricing-highlight dual-pricing-date">
                <span class="dual-pricing-date-month">{{= obj.dddMonth }}</span>
                <span class="dual-pricing-date-day">{{= obj.dddDay }}<sup>{{= obj.dddSuffix }}</sup></span>
            </span>
        </div>

        <div class="col-sm-2">
            <span class="rounded-gray-bg">&amp;</span>
        </div>

        <div class="col-sm-3">
            Pay your annual  <br class="hidden-xs"/>premium in full by
            <br>
            <span class="dual-pricing-highlight dual-pricing-date">
                <span class="dual-pricing-date-month">April</span>
                <span class="dual-pricing-date-day">1<sup>st</sup></span>
            </span>
        </div>
    </div>

    <hr />

    <div class="row">
        <div class="col-xs-12 text-center">
            <small>Alternatively, if you elect to pay your premium weekly, monthly, fortnightly, quarterly or half-yearly before {{= obj.dropDeadDate }}, <span class="text-bold">only payments made by 1st April will be at the current amount.</span> Thereafter the new premium will apply.</small>
        </div>
    </div>

    <div class="row dual-pricing-frequency-row hidden-xs">
        <div class="col-xs-12 col-sm-6 col-sm-offset-3">
            <div class="text-center text-bold">Change payment frequency</div>
            <div class="dual-pricing-modal-frequency" data-dont-toggle-update="true">
                <div class="btn-group btn-group-justified " data-toggle="radio">
                    {{ _.each(frequency, function(object) { }}
                    {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                    {{ var active = object.selected ? ' active' : ''; }}
                    <label class="btn btn-form-inverse {{= active }}" <field_v1:analytics_attr analVal="filter payment freq" quoteChar="\"" />>
                        <input type="radio" name="health_dual_pricing_frequency" id="health_dual_pricing_frequency_{{= object.value }}" value="{{= object.value }}" {{=checked }}
                               title="{{= object.label }}" /> {{= object.label }}</label>
                    {{ }) }}
                </div>
            </div>
            <a href="javascript:;" class="btn btn-lg dual-pricing-update-frequency-btn">
                <span class="dual-pricing-frequency-ok-text">OK, got it</span>
                <span class="dual-pricing-frequency-updated-text">Update Frequency</span>
            </a>
        </div>
    </div>

    <div class="row text-center">
        <div class="col-xs-12">
            Need to review your cover? <span class="text-bold">Call our experts on </span><a href="tel: ${callCentreNumber}">${callCentreNumber}</a>
        </div>
    </div>
</core_v1:js_template>