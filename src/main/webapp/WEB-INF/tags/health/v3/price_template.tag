<%@ tag description="The Health Logo template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
{{ if (!obj.hasOwnProperty('premium')) {return;} }}
{{ var isConfirmation = false; }}
{{ try{ }}
{{ isConfirmation = _.isNumber(meerkat.modules.healthConfirmation.getPremium()); }}
{{ } catch(e){} }}
{{ var availablePremiums = (!meerkat.site.isCallCentreUser || !isConfirmation) && _.has(meerkat.site,"alternatePricing") && meerkat.site.alternatePricing.isActive && _.has(obj,"altPremium") ? obj.altPremium : obj.premium; }}
{{ var healthResultsTemplate = meerkat.modules.healthResultsTemplate; }}
{{ var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies(); }}
{{ var discountText = healthResultsTemplate.getDiscountText(obj); }}
<div class="price premium">
    {{ _.each(availableFrequencies, function(freqObj) { }}
    {{ var frequency = freqObj.key; }}
    {{ if (typeof availablePremiums[frequency] === "undefined") { return; } }}
    <c:if test="${callCentre}">
        {{ obj.mode = "lhcInc"; }}
    </c:if>
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

    {{ if (!obj.hasOwnProperty('priceBreakdown') || meerkat.site.isCallCentreUser) { }}
    <div class="lhcText">
        <span>
            {{= result.lhcFreePriceMode ? result.textLhcFreePricing : result.textPricing }}
        </span>
        {{ if (result.discounted && !meerkat.site.isCallCentreUser) { }}
        <span class="discountText">
                inc {{= discountPercentage }}% Discount
                <a href="javascript:;" class="discount-tool-tip" data-toggle="popover" data-content="{{= discountText }}">?</a>
            </span>
        {{ } }}
    </div>

    {{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
    <div class="rounding">Premium may vary slightly due to rounding</div>
    {{ } }}
    {{ } else { }}
    <div class="price-breakdown">
        {{ var showLHCRow = availablePremiums[frequency].lhcPercentage > 0; }}
        {{ var showRebateRow = availablePremiums[frequency].rebate > 0; }}
        {{ var showDiscountRow = availablePremiums[frequency].discounted === 'Y'; }}

        {{ if (showLHCRow || showRebateRow || showDiscountRow) { }}
        <p>How your premium is calculated:</p>
        <hr />
        <div class="row">
            <div class="col-xs-12 col-md-7">Cost of policy:</div>
            <div class="col-xs-12 col-md-5 text-right">{{= availablePremiums[frequency].grossPremium }}</div>
        </div>
        {{ } }}

        {{ if (showLHCRow) { }}
        <div class="row">
            <div class="col-xs-12 col-md-8 col-lg-7">LHC Loading based on {{= availablePremiums[frequency].lhcPercentage}}%: <span class="icon icon-info lhc-loading-help"></span></div>
            <div class="col-xs-12 col-md-4 col-lg-5 text-right">+{{= availablePremiums[frequency].lhc }}</div>
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