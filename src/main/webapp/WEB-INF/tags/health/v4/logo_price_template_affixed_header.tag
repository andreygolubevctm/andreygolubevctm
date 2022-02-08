<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- DUAL PRICE BOX FOR AFFIXED HEADER ON MORE IN PAGE --%>
<script id="affixed-header-logo-price-template" type="text/html">
    {{ if (!obj.hasOwnProperty('premium')) {return;} }}
    {{ var isConfirmation = false; }}
    {{ try{ }}
    {{ isConfirmation = _.isNumber(meerkat.modules.healthConfirmation.getPremium()); }}
    {{ } catch(err){ console.warn('Bad premium number', err); } }}
    {{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
    {{ var healthResultsTemplate = meerkat.modules.healthResultsTemplate; }}
    {{ var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies(); }}
    {{ var dualPriceText = 'Current price'; }}
    {{ var backgroundColor = ''; }}
    {{ if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { dualPriceText = 'From April 1'; backgroundColor = 'blue-background';} }}
    <div class="price premium">
        {{ _.each(availableFrequencies, function(freqObj) { }}
        {{ var formatCurrency = meerkat.modules.currencyField.formatCurrency; }}
        {{ var frequency = freqObj.key; }}
        {{ if (typeof availablePremiums[frequency] === "undefined") { return; } }}
        {{ var result = healthResultsTemplate.getPricePremium(frequency, availablePremiums, obj.mode); }}
        {{ var discountPercentage = healthResultsTemplate.getDiscountPercentage(obj.info.FundCode, result); }}
        {{ var property = obj.premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = obj.altPremium; } }}
        {{ var prem = obj.premium[frequency]; }}
        {{ var textLhcFreePricing = 'LHC loading may increase the premium.'; }}
        {{ if (prem.lhcfreepricing.indexOf('premium') === -1) { textLhcFreePricing = ''; } }}
        {{ var textLhcFreeDualPricing= 'inc ' + formatCurrency(prem.rebateValue) + ' Govt Rebate';}}
        {{ var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;}}
        {{ if (!result.hasValidPrice) { }}
        <div class="frequency grey-background center-align-items {{= result.frequency }} {{= obj._selectedFrequency === result.frequency ? 'vertical-center-lines' : 'displayNone' }}">
            <div class="frequencyAmount comingSoon">
                <div>New price not yet released</div>
                <div class="comingSoon-dash">&#8211;</div>
            </div>
        </div>
        <%-- Close the opened tags and return, to reduce complexity of nesting --%>
        {{ return; } }}
        <div class="frequency {{= backgroundColor}} {{= result.frequency }} {{= obj._selectedFrequency === result.frequency ? 'vertical-center-lines' : 'displayNone' }}">
            <div class="dual-pricing-container">
                <div class="dual-pricing-before-after-text">
                    {{= dualPriceText}}
                </div>
                <div class="frequencyAmount">
                    {{ var dollarPriceResult = healthResultsTemplate.getPrice(result); }}
                    <span class="dollarSign">$</span>{{= dollarPriceResult.dollarPrice }}<span class="cents">.{{= dollarPriceResult.cents }}</span>
                </div>
            </div>
            <div class="dual-pricing-container">
                <div class="frequencyTitle">{{= freqObj.key }} / </div>
                <div class="lhcText">{{= textLhcFreeDualPricing}}</div>
            </div>
        </div>
    {{ }); }}
    </div>
</script>
