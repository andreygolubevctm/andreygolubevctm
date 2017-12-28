<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="price-breakdown-lhc-template">
    {{ if (meerkat.modules.healthPriceBreakdown.showLHC(obj, obj._selectedFrequency)) { }}
        <content:get key="priceBreakdownLHCCopy" />
    {{ } }}
</core_v1:js_template>

<core_v1:js_template id="price-breakdown-template">
    <div class="price-breakdown">
        {{ var showLHCRow = meerkat.modules.healthPriceBreakdown.showLHC(obj, obj.frequency); }}
        {{ var showRebateRow = obj.premium[obj.frequency].rebate > 0; }}
        {{ var showDiscountRow = obj.premium[obj.frequency].discounted === 'Y'; }}

        {{ if (showLHCRow || showRebateRow || showDiscountRow) { }}
        <p>How your premium is calculated:</p>
        <hr />
        <div class="row">
            <div class="col-xs-12 col-md-7">Cost of policy:</div>
            <div class="col-xs-12 col-md-5 text-right">{{= obj.premium[obj.frequency].grossPremium }}</div>
        </div>
        {{ } }}

        {{ if (showLHCRow) { }}
        <div class="row">
            <div class="col-xs-12 col-md-8 col-lg-7">LHC Loading based on {{= obj.premium[obj.frequency].lhcPercentage }}%: <span class="icon icon-info lhc-loading-help"></span></div>
            <div class="col-xs-12 col-md-4 col-lg-5 text-right">+{{= obj.premium[obj.frequency].lhc }}</div>
        </div>
        {{ } }}

        {{ if (showRebateRow) { }}
        <div class="row">
            <div class="col-xs-12 col-md-7">Australian Government Rebate {{= obj.premium[obj.frequency].rebate }}%:</div>
            <div class="col-xs-12 col-md-5 text-right">-{{= obj.premium[obj.frequency].rebateValue }}</div>
        </div>
        {{ } }}

        {{ if (showDiscountRow) { }}
        <div class="row">
            <div class="col-xs-12 col-md-8">Fund discount {{= obj.premium[obj.frequency].discountPercentage }}% {{= obj.frequency }}:</div>
            <div class="col-xs-12 col-md-4 text-right">-{{= obj.premium[obj.frequency].discountAmount }}</div>
        </div>
        {{ } }}

        {{ if (obj.showCopyPanel) { }}
        <div class="price-breakdown-copy-panel">
            <content:get key="priceBreakdownCopy"/>
        </div>
        {{ } }}
    </div>
</core_v1:js_template>