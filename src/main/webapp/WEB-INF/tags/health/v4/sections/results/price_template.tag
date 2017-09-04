<%@ tag description="The Health Logo template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
{{ if (!obj.hasOwnProperty('premium')) {return;} }}
{{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
{{ var healthResultsTemplate = meerkat.modules.healthResultsTemplate; }}
{{ var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies(); }}
{{ var discountText = healthResultsTemplate.getDiscountText(obj); }}
<div class="price premium">
    {{ _.each(availableFrequencies, function(freqObj) { }}
    {{ var frequency = freqObj.key; }}
    {{ if (typeof availablePremiums[frequency] === "undefined") { return; } }}
    {{ var result = healthResultsTemplate.getPricePremium(frequency, availablePremiums, obj.mode); }}
    {{ var discountPercentage = healthResultsTemplate.getDiscountPercentage(obj.info.FundCode, result); }}

    <div class="frequency {{= result.frequency }} {{= obj._selectedFrequency === result.frequency ? '' : 'displayNone' }}">
        {{ if (!result.hasValidPrice) { }}
        {{ var frequencyLabel = frequency; }}
        {{ if (frequencyLabel == 'annually') { }}
            {{ frequencyLabel = 'Annual'; }}
        {{ } }}
        <%-- Convert to title case --%>
        {{ frequencyLabel = frequencyLabel.replace(/(\b[a-z](?!\s))/g, function(x){ return x.toUpperCase();}); }}
        <div class="frequencyAmount comingSoon">{{= frequencyLabel }} payments not available</div>
    </div>
    <%-- Close the opened tags and return, to reduce complexity of nesting --%>
    {{ return; } }}
    <div class="frequencyAmount">
        {{ var dollarPriceResult = healthResultsTemplate.getPrice(result); }}
        <span class="dollarSign">$</span>{{= dollarPriceResult.dollarPrice }}<span class="cents">.{{= dollarPriceResult.cents }}</span>
        <span class="frequencyTitle">{{= freqObj.label }}</span>
    </div>

    {{ if (!obj.hasOwnProperty('priceBreakdown')) { }}
    <div class="lhcText hide-on-affix">
        <span>
            {{= result.lhcFreePriceMode ? result.textLhcFreePricing : result.textPricing }}
        </span>
        {{ if (result.discounted) { }}
            <span class="discountText">
                inc {{= discountPercentage }}% Discount
                <a href="javascript:;" class="discount-tool-tip" data-toggle="popover" data-content="{{= discountText }}">?</a>
            </span>
        {{ } }}
    </div>
    {{ } else { }}
    <div class="price-breakdown">
        {{ var showLHCRow = availablePremiums[frequency].lhcPercentage > 0; }}
        {{ var showRebateRow = availablePremiums[frequency].rebate > 0; }}
        {{ var showDiscountRow = availablePremiums[frequency].discounted === 'Y'; }}

        {{ if (showLHCRow || showRebateRow || showDiscountRow) { }}
            <p>How your premium is calculated:</p>
            <hr />
            <div class="row">
                <div class="col-xs-12 col-md-8">Premium:</div>
                <div class="col-xs-12 col-md-4 text-right">{{= availablePremiums[frequency].grossPremium }}</div>
            </div>
        {{ } }}

        {{ if (showLHCRow) { }}
            <div class="row">
                <div class="col-xs-12 col-md-8">LHC Loading: <span class="icon icon-info lhc-loading-help"></span></div>
                <div class="col-xs-12 col-md-4 text-right">+{{= availablePremiums[frequency].lhc }}</div>
            </div>
        {{ } }}

        {{ if (showRebateRow) { }}
            <div class="row">
                <div class="col-xs-12 col-md-8">Australian Government Rebate {{= availablePremiums[frequency].rebate }}%:</div>
                <div class="col-xs-12 col-md-4 text-right">-{{= availablePremiums[frequency].rebateValue }}</div>
            </div>
        {{ } }}

        {{ if (showDiscountRow) { }}
        <div class="row">
            <div class="col-xs-12 col-md-8">Fund discount {{= availablePremiums[frequency].discountPercentage }}% {{= frequency }}:</div>
            <div class="col-xs-12 col-md-4 text-right">-{{= availablePremiums[frequency].discountAmount }}</div>
        </div>
        {{ } }}

        <div class="price-breakdown-copy-panel">
            <c:set var="priceBreakdownCopy" scope="request"><content:get key="priceBreakdownCopy"/></c:set>
            ${priceBreakdownCopy}
        </div>
    </div>
    {{ } }}
</div>

{{ }); }}
</div>