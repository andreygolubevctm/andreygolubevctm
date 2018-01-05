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

    {{ if (!obj.hasOwnProperty('priceBreakdown') || (obj.hasOwnProperty('priceBreakdown') && !obj.priceBreakdown)) { }}
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
        {{= meerkat.modules.healthPriceBreakdown.renderTemplate(availablePremiums, frequency, true) }}
    {{ } }}
</div>

{{ }); }}
</div>