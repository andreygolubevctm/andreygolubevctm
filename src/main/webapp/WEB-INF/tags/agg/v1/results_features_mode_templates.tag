<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Features mode templates"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="monthly-price-features-template">
    {{ var monthlyPremiumSplit = obj.price.monthlyPremiumFormatted.toString().split('.'); }}
    {{ var dollars = monthlyPremiumSplit[0]; }}
    {{ var cents = monthlyPremiumSplit[1] ? '.' + monthlyPremiumSplit[1] : ''; }}
    {{ if (cents.length === 2) cents += '0'; }}

    <div class="frequency monthly" data-availability="{{= obj.available }}">
        <div class="frequencyAmount">
            <span class="dollarSign">{{= '$' }}</span><span class="dollars">{{= dollars }}</span><span class="cents">{{= cents }}</span></div>
        <div class="frequencyTitle">Monthly</div>
        <div class="monthlyBreakdown">
            <span class="nowrap"><span class="firstPayment">1st Month: {{= '$' }}{{= obj.price.monthlyFirstMonthFormatted }}</span></span>
            <span class="nowrap"><span class="totalPayment">Total: {{= '$' }}{{= obj.price.annualisedMonthlyPremiumFormatted }}</span></span>
        </div>
    </div>
</core_v1:js_template>

<core_v1:js_template id="annual-price-features-template">
    <div class="frequency annual" data-availability="{{= obj.available }}">
        <div class="frequencyAmount">
            <span class="dollarSign">{{= '$' }}</span><span class="dollars">{{= obj.price.annualPremiumFormatted }}</span>
        </div>
        <div class="frequencyTitle">Annual</div>
    </div>
</core_v1:js_template>

<core_v1:js_template id="call-action-buttons-features-template">
    {{ var template = $("#call-direct-button-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ var callInsurerDirectActionButton = htmlTemplate(obj); }}

    {{ var template = $("#call-back-button-template").html(); }}
    {{ var htmlTemplate = _.template(template); }}
    {{ var callMeBackActionButton = htmlTemplate(obj); }}

    {{ var colClass = 'col-xs-12'; }}

    {{ if (obj.contact.allowCallDirect === true && obj.contact.allowCallMeBack === true) { }}
    {{ colClass = 'col-xs-6'; }}
    {{ } }}

    <div class="call-actions-buttons row">
        {{ if (obj.contact.allowCallDirect === true) { }}
        <div class="{{= colClass }}">
            {{= callInsurerDirectActionButton }}
        </div>
        {{ } }}
        {{ if (obj.contact.allowCallMeBack === true) { }}
        <div class="{{= colClass }}">
            {{= callMeBackActionButton }}
        </div>
        {{ } }}
    </div>
</core_v1:js_template>