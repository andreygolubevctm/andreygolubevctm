;(function ($) {
    var meerkat = window.meerkat,
        LABEL_ON_LEFT = 2,
        HIDE_LABEL = 1;

    /**
     * Get the list of available extras.
     */
    function getAvailableExtrasAsList(obj) {
        var feature = Features.getPageStructure(obj.featuresStructureIndexToUse)[0];
        var availableExtras = [],
            output = "";
        _.each(feature.children, function (ft) {
            var hasResult = ft.resultPath !== null && ft.resultPath !== '';
            var pathValue = hasResult ? Object.byString(obj, ft.resultPath) : false;
            if (pathValue == "Y") {
                availableExtras.push(ft);
            }
        });
        if (!availableExtras.length) {
            $('.featuresListExtrasOtherList, .featuresListExtrasFullList').addClass('hidden');
        } else {
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

        return output;
    }

    /**
     * Flag column in aggregator.features_details
     * Flag of 2 indicates label to display on the left with a colon
     * Currently does not hide label if its also set on the left
     * Default is label on the right.
     * @param ft
     * @returns {string}
     */
    function getTitleBefore(ft) {
        return ft.flag & LABEL_ON_LEFT ? ft.safeName + ": " : "";
    }

    /**
     * If the flag is hidden or on the left, don't show anything.
     * Otherwise display the label in lowercase.
     * @param ft
     * @returns {string}
     */
    function getTitleAfter(ft) {
        return ft.flag & (HIDE_LABEL | LABEL_ON_LEFT) ? "" : " " + ft.safeName.toLowerCase();
    }

    /**
     * Remap the class string to just get the HLTicon- part of it.
     * @param ft
     * @returns {string}
     */
    function _getIconClass(ft) {
        var iconClassSet = ft.classString.match(/(HLTicon-[^\s]+)/);
        return iconClassSet && iconClassSet.length && iconClassSet[0].indexOf('HLTicon') != -1 ? iconClassSet[0] : "";
    }

    /**
     *
     * @param ft
     * @returns {string}
     * @private
     */
    function _getHelpTooltip(ft) {
        return ft.helpId !== '' && ft.helpId != '0' ? '<a href="javascript:void(0);" class="help-icon icon-info" data-content="helpid:' + ft.helpId + '" data-toggle="popover" data-my="right center" data-at="left center"><span class="text-hide">Need Help?</span></a>' : '';
    }

    function _hasResult(ft) {
        return ft.resultPath !== null && ft.resultPath !== '';
    }

    function _getPathValue(obj, ft) {
        return _hasResult(ft) ? Object.byString(obj, ft.resultPath) : false;
    }

    function _getExtraText(ft) {
        var text = '';
        if (ft.extraText != null && ft.extraText != '') {
            return ft.extraText;
        }
        return text;
    }

    /**
     * Generate the display value logic.
     *
     * @param pathValue
     * @param ft
     * @param useDefaultReturn
     * @returns {*}
     */
    function buildDisplayValue(pathValue, ft, useDefaultReturn) {
        if (pathValue || pathValue === "") {
            var displayValue = Features.parseFeatureValue(pathValue, true);
            if (pathValue) {
                return getTitleBefore(ft) + '<strong>' + displayValue + '</strong> ' + _getExtraText(ft) + getTitleAfter(ft) + _getHelpTooltip(ft);
            } else if (useDefaultReturn) {
                return "-";
            }
        } else {
            return "-";
        }
    }

    function getItem(obj, ft) {
        ft.displayItem = ft.type != 'section';
        // section headers are not displayed anymore but we need the section container
        //if (ft.displayItem) {
        ft.pathValue = _getPathValue(obj, ft);
        ft.isRestricted = ft.pathValue == "R";
        ft.isNotCovered = ft.pathValue == "N";
        ft.hasChildFeatures = typeof ft.children !== 'undefined' && ft.children.length;

        // Additional attributes for category's only.
        if (ft.type == 'category') {
            if (ft.name === '') {
                ft.classStringForInlineLabel += " noLabel";
            }
            if (ft.isNotCovered) {
                ft.labelInColumnTitle = ' title="Not Covered"';
                ft.labelInColumnContentClass = ' noCover';
            } else {
                ft.labelInColumnTitle = '';
                ft.labelInColumnContentClass = '';
            }
            ft.iconClass = _getIconClass(ft);
        } else if (ft.type == 'feature') {
            ft.displayValue = buildDisplayValue(ft.pathValue, ft, true);
        }

        // For sub-category feature detail
        var isSelectionHolder = ft.classString && ft.classString.indexOf('selectionHolder') != -1;
        ft.displayChildren = ft.hasChildFeatures || isSelectionHolder;
        if (ft.displayChildren) {
            ft.hideChildrenClass = ft.isNotCovered ? ' hideChildren' : '';
        }

        //}
        return ft;
    }

    /**
     * Used for excess_template.tag
     * @param obj
     * @param ft
     * @returns {*}
     */
    function getExcessChildDisplayValue(obj, ft) {
        var pathValue = _getPathValue(obj, ft);
        var displayValue = buildDisplayValue(pathValue, ft, false);
        if (displayValue == "-") {
            return getTitleBefore(ft) + " None";
        }
        return displayValue;
    }

    /**
     * Pre-processing function for price_template.tag
     * @param frequency
     * @param availablePremiums
     * @returns {{}}
     */
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
        getExcessChildDisplayValue: getExcessChildDisplayValue,
        getPricePremium: getPricePremium,
        getPrice: getPrice,
        getSpecialOffer: getSpecialOffer,
        getItem: getItem
    });

})(jQuery);
