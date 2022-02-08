<%@ tag description="The Health Logo template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
{{ if (!obj.hasOwnProperty('premium')) {return;} }}
{{ var isConfirmation = false; }}
{{ try{ }}
{{ isConfirmation = _.isNumber(meerkat.modules.healthConfirmation.getPremium()); }}
{{ } catch(err){ console.warn('Bad premium number', err); } }}
{{ var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium; }}
{{ var healthResultsTemplate = meerkat.modules.healthResultsTemplate; }}
{{ var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies(); }}
{{ var textLhcFreePricing = 'LHC loading may increase the premium.'; }}
<div class="price premium">
    {{ _.each(availableFrequencies, function(freqObj) { }}
    {{ var formatCurrency = meerkat.modules.currencyField.formatCurrency; }}
    {{ var frequency = freqObj.key; }}
    {{ if (typeof availablePremiums[frequency] === "undefined") { return; } }}
    {{ var result = healthResultsTemplate.getPricePremium(frequency, availablePremiums, obj.mode); }}
    {{ var discountPercentage = healthResultsTemplate.getDiscountPercentage(obj.info.FundCode, result); }}
    {{ var property = obj.premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = obj.altPremium; } }}
	{{ var prem = obj.premium[frequency]; }}
    {{ if (prem.lhcfreepricing.indexOf('premium') === -1) { textLhcFreePricing = ''; } }}
	{{ var textLhcFreeDualPricing= 'inc ' + formatCurrency(prem.rebateValue) + ' Govt Rebate';}}
    {{ var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;}}

    <div class="more-info-frequency frequency {{= result.frequency }} {{= obj._selectedFrequency === result.frequency ? '' : 'displayNone' }}">
        {{ if (!result.hasValidPrice) { }}
        {{ var comingSoonLabel = frequency; }}
        {{ if (comingSoonLabel == 'annually') { }}
            {{ comingSoonLabel = 'Annual'; }}
        {{ } }}
        <%-- Convert to title case --%>
        {{ comingSoonLabel = comingSoonLabel.replace(/(\b[a-z](?!\s))/g, function(x){ return x.toUpperCase();}); }}
        <div class="frequencyAmount comingSoon">
            <div class="comingSoon-text">New price not yet released</div>
            <div class="comingSoon-dash">&#8211;</div>
        </div>
    </div>
    <%-- Close the opened tags and return, to reduce complexity of nesting --%>
    {{ return; } }}
    <div class="frequencyAndAmount">
        <div class="frequencyAmount">
            {{ var dollarPriceResult = healthResultsTemplate.getPrice(result); }}
            <span class="dollarSign">$</span>{{= dollarPriceResult.dollarPrice }}<span class="cents">.{{= dollarPriceResult.cents }}</span>
        </div>
        <div class="hide-on-affix">
            <span class="select-frequency">
                <span class=" input-group-addon" data-target="${freq}">
                    <i class="icon-angle-down"></i>
                </span>
                <select name="more-info-payment-frequency-current" id="more-info-payment-frequency-current" title=""
                        class="more-info-payment-frequency data-hj-suppress" data-freq="{{= frequency}}" data-attach="true" data-validation-position='append'>
                    <option value="fortnightly" {{= frequency === 'fortnightly' ? 'selected' : '' }}>Fortnightly</option>
                    <option value="monthly" {{= frequency === 'monthly' ? 'selected' : '' }}>Monthly</option>
                    <option value="annually" {{= frequency === 'annually' ? 'selected' : '' }}>Annually</option>
                </select>
                /
            </span>
        </div>
    </div>
    <div class="lhcText">{{= textLhcFreeDualPricing}}</div>
    {{ if (textLhcFreePricing !== '') { }}
    <div class="lhcStaticText">{{= textLhcFreePricing}}</div>
    {{ } }}

</div>
{{ }); }}
</div>
