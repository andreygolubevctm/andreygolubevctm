<%@ tag description="The Health Logo template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
{{ if (!obj.hasOwnProperty('premium')) {return;} }}
{{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
{{ var healthResultsTemplate = meerkat.modules.healthResultsTemplate; }}
{{ var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies(); }}
<div class="price premium">
    {{ _.each(availableFrequencies, function(freqObj) { }}
    {{ var frequency = freqObj.key; }}
    {{ if (typeof availablePremiums[frequency] === "undefined") { return; } }}
    <c:if test="${callCentre}">
        {{ obj.mode = "lhcInc"; }}
    </c:if>
    {{ var result = healthResultsTemplate.getPricePremium(frequency, availablePremiums, obj.mode); }}

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

    <div class="lhcText hide-on-affix">{{= result.lhcFreePriceMode ? result.textLhcFreePricing : result.textPricing }}</div>

    {{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
    <div class="rounding">Premium may vary slightly due to rounding</div>
    {{ } }}
</div>

{{ }); }}
</div>