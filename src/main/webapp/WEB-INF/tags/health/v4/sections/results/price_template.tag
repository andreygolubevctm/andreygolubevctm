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
        <%-- Setup the frequency label for the coming soon text --%>
        {{ if (!result.hasValidPrice) { }}
        {{ var comingSoonLabel = frequency; }}
        {{ if (comingSoonLabel == 'annually') { }}
        {{     comingSoonLabel = 'Annual'; }}
        {{ } }}
        <%-- Convert to title case --%>
        {{ comingSoonLabel = comingSoonLabel.replace(/(\b[a-z](?!\s))/g, function(x){ return x.toUpperCase();}); }}

        <div class="frequencyAmount comingSoon">{{= comingSoonLabel }} payments not available</div>
    </div>
    <%-- Close the opened tags and return, to reduce complexity of nesting --%>
    {{ return; } }}
    <span class="frequencyAmount">
        <%-- Setup the frequency label to be displayed --%>
        {{ var frequencyDisplayLabel = frequency === 'halfyearly' ? 'Half yearly' : frequency.charAt(0).toUpperCase() + frequency.slice(1) }}
        {{ var dollarPriceResult = healthResultsTemplate.getPrice(result); }}
        <span class="dollarSign">$</span>{{= dollarPriceResult.dollarPrice }}<span class="cents">.{{= dollarPriceResult.cents }}</span>
    </span>
    <div class="frequencyTitle">{{= frequencyDisplayLabel }}</div>
{{ }); }}
</div>
