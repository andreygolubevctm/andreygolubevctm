;(function ($) {
    var meerkat = window.meerkat;

    /**
     * Get the list of available extras.
     */
    function getAvailableExtrasAsList(obj) {
        var feature = Features.getPageStructure(obj.featuresStructureIndexToUse)[0];
        var availableExtras = [], output = "";
        _.each(feature.children, function (ft) {
            var hasResult = ft.resultPath !== null && ft.resultPath !== '';
            var pathValue = hasResult ? Object.byString(obj, ft.resultPath) : false;
            if (pathValue == "Y") {
                availableExtras.push(ft);
            }
        });
        _.each(availableExtras, function (ft, i) {
            var separator = '';
            if (i !== availableExtras.length - 1) {
                separator = ', ';
            } else if (i == (availableExtras.length - 2)) {
                separator = ' and ';
            }
            output += ft.safeName + separator;
        });

    }


    function getExcessChildTemplate(obj, ft) {
        var hasResult = ft.resultPath !== null && ft.resultPath !== '';
        var pathValue = hasResult ? Object.byString(obj, ft.resultPath) : false;
        if (hasResult) {
            var displayValue = Features.parseFeatureValue(pathValue, true);
            if (pathValue) {
                return "<div>" + displayValue + "</div>";
            }
        }
        return "-";
    }

    function getPricePremium(frequency, availablePremiums) {
        var formatCurrency = meerkat.modules.currencyField.formatCurrency;
        var result = {};
        var prem = availablePremiums[frequency];
        result.frequency = frequency.toLowerCase();
        result.priceText = prem.text ? prem.text : formatCurrency(prem.payableAmount);
        result.priceLhcfreetext = prem.lhcfreetext ? prem.lhcfreetext : formatCurrency(prem.lhcFreeAmount);
        result.textLhcFreePricing = prem.lhcfreepricing ? prem.lhcfreepricing : '+ ' + formatCurrency(prem.lhcAmount) +
        ' LHC inc ' +
        formatCurrency(prem.rebateAmount) + 'Government Rebate';
        result.textPricing = prem.pricing ? prem.pricing : 'Includes rebate of ' + formatCurrency(prem.rebateAmount) +
        ' & LHC loading of ' + formatCurrency(prem.lhcAmount);
        result.hasValidPrice = (prem.value && prem.value > 0) || (prem.text && prem.text.indexOf('$0.') < 0) ||
            (prem.payableAmount && prem.payableAmount > 0);
        result.lhcFreePriceMode = typeof mode === "undefined" || mode !== "lhcInc";
        return result;
    }


    function getPrice(result) {
        var priceResult = {};
        var premiumSplit = result.lhcFreePriceMode ? result.priceLhcfreetext : result.priceText;
        premiumSplit = premiumSplit.split(".");
        priceResult.dollarPrice = premiumSplit[0]
            .replace('$', '')
            .replace(',', '<span class="comma">,</span>');
        priceResult.cents = premiumSplit[1];
        return priceResult;
    }

    function getSpecialOffer(obj) {
        var result = {};
        var specialOffer = Features.getPageStructure()[0];
        result.pathValue = Object.byString(obj, specialOffer.resultPath);
        result.displayValue = Features.parseFeatureValue(result.pathValue, true);
        return result;
    }


    meerkat.modules.register('healthResultsTemplate', {
        getAvailableExtrasAsList: getAvailableExtrasAsList,
        getExcessChildTemplate: getExcessChildTemplate,
        getPricePremium: getPricePremium,
        getPrice: getPrice,
        getSpecialOffer: getSpecialOffer
    });

})(jQuery);
