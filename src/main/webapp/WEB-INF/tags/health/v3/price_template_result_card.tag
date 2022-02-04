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
{{ var frequencyAndLHCData = []; }}
<div class="price premium">
    {{ _.each(availableFrequencies, function(freqObj) { }}
        {{ var frequency = freqObj.key; }}
        {{ if (typeof availablePremiums[frequency] === "undefined") { return; } }}
        <c:if test="${callCentre}">
            {{ obj.mode = "lhcInc"; }}
        </c:if>
        {{ var result = healthResultsTemplate.getPricePremium(frequency, availablePremiums, obj.mode); }}
        {{ var discountPercentage = healthResultsTemplate.getDiscountPercentage(obj.info.FundCode, result); }}

        {{ frequencyAndLHCData.push({ freqObj: freqObj, result: result }); }}

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
<%--        <div class="frequencyTitle">{{= freqObj.label }}</div>--%>
    </div>


</div>

{{ }); }}
</div>



<div class="price premium">
    {{ _.each(frequencyAndLHCData, function(data){ }}
        {{ var lhcText = data.result.lhcFreePriceMode ? data.result.textLhcFreePricing : data.result.textPricing; }}
        {{ var textPricing = ''; var textPricingLHC = ''; }}
        {{ if (lhcText) { }}
            {{ var textPricing = lhcText.indexOf('&') > 0 ? lhcText.split('&')[0] + ' &' : lhcText }}
            {{ var textPricingLHC = lhcText.indexOf('&') > 0 ? lhcText.split('&')[1] : '' }}
        {{ } }}
        <div class="frequency {{= data.result.frequency }} {{= obj._selectedFrequency === data.result.frequency ? '' : 'displayNone' }}">
            <div>
                <span class="frequencyTitle">
                    {{= data.freqObj.label === 'per year' ? 'annually /' : '' }}
                    {{= data.freqObj.label === 'per half year' ? 'halfyearly' : '' }}
                    {{= data.freqObj.label === 'per quarter' ? 'quarterly' : '' }}
                    {{= data.freqObj.label === 'per month' ? 'monthly /' : '' }}
                    {{= data.freqObj.label.indexOf('fortnight') > 0 ? 'fortnightly /' : '' }}
                    {{= data.freqObj.label === 'pre week' ? 'weekly' : '' }}
                </span>
                <span class="text-pricing-in-frequency-title">{{= textPricing.split('&')[0]}}</span>
            </div>

            <div class="lhc-and-abd-container">
                <div class="lhs-text-container">
                    <div class="premium-LHC-text lhcText">
                        <span>The premium may be affected by LHC</span>
                    </div>
                </div>
                <health_v4:abd_badge_with_link />
            </div>

            {{ if (typeof showRoundingText !== 'undefined' && showRoundingText === true) { }}
                <div class="rounding">Premium may vary slightly due to rounding</div>
            {{ } }}
        </div>
    {{ }); }}
</div>
