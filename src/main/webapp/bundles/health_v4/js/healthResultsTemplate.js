;(function ($) {
    var meerkat = window.meerkat,
        $resultsPagination,
        filteredOutResults = []; // this is used for removing the results when clicking the "x";

    /**
     * Get the list of available extras.
     * @param obj The Result object for that product.
     * @returns {Array}
     */
    function getAvailableBenefits(obj) {
        var feature = Features.getPageStructure(obj.featuresStructureIndexToUse)[0];
        var availableBenefits = [];
        _.each(feature.children, function (ft) {
            if (ft.doNotRender === true) {
                return;
            }
            var hasResult = ft.resultPath !== null && ft.resultPath !== '';
            var pathValue = hasResult ? Object.byString(obj, ft.resultPath) : false;
            if (pathValue == "Y") {
                availableBenefits.push(ft);
            }
        });

        if (!availableBenefits.length) {
            if (numberOfSelectedExtras() === 0) {
                $('.featuresListExtrasOtherList').addClass('hidden');
            } else if (numberOfSelectedHospitals() === 0) {
                $('.featuresListHospitalOtherList').addClass('hidden');
            }
        }
        return availableBenefits;
    }

    function getPopOverContent(obj, availableBenefits) {
        var output = '';
        _.each(availableBenefits, function (ft) {
            output += '<div>' + ft.safeName + '</div>';
        });
        output += "<div class='text-center'><a href='javascript:;' class='open-more-info' data-productId='" + obj.productId + "' data-available='" + obj.available + "'>View Product</a> for more details</div>";
        return output;
    }

    /**
     * Helper function
     * @param ft
     * @returns {boolean}
     * @private
     */
    function _hasResult(ft) {
        return ft.resultPath !== null && ft.resultPath !== '';
    }

    /**
     * Helper function - pathValue is the value at the features resultPath when looking at the Results object.
     * @param obj
     * @param ft
     * @returns {boolean}
     * @private
     */
    function _getPathValue(obj, ft) {
        return _hasResult(ft) ? Object.byString(obj, ft.resultPath) : false;
    }

    /**
     * resultsItemTemplate helper to remove logic out of the template.
     * @param obj
     * @param ft
     * @returns {*}
     */
    function getItem(obj, ft) {
        //NOTE: Not sure if we need to extend the feature object each time to clone it.
        // If you don't, the last row's data ends up on Features.getPageStructure. Is that a problem? Not sure...
        // If data isn't displaying properly after a refresh/reset of results uncomment this line:
        //ft = $.extend(true, {}, ft);

        ft.displayItem = ft.type != 'section';
        // section headers are not displayed anymore but we need the section container
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
                ft.labelInColumnContentClass = ' noCover';
            } else {
                ft.labelInColumnContentClass = '';
            }
        } else if (ft.type == 'feature') {
            ft.displayValue = Features.parseFeatureValue(ft.pathValue, true) || 'None';
        }

        // For sub-category feature detail
        var isSelectionHolder = ft.classString && ft.classString.indexOf('selectionHolder') != -1;
        ft.displayChildren = ft.hasChildFeatures || isSelectionHolder;
        if (ft.displayChildren) {
            ft.hideChildrenClass = ft.isNotCovered ? ' hideChildren' : '';
        }

        return ft;
    }

    function getExcessItem(obj, ft) {
        ft.pathValue = _getPathValue(obj, ft);
        ft.displayValue = Features.parseFeatureValue(ft.pathValue, true) || 'None';
        return ft;
    }

    /**
     * Pre-processing function for price_template.tag
     * @param frequency
     * @param availablePremiums
     * @param mode
     * @returns {{}}
     */
    function getPricePremium(frequency, availablePremiums, mode) {
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

    function getExcessPrices(obj) {
        var data = {},
            excessData = Object.byString(obj, "hospital.inclusions.excesses");
        data.hasExcesses = _.isObject(excessData);
        if (data.hasExcesses) {
            data.perAdmission = _formatExcess(excessData.perAdmission);
            data.perPerson = _formatExcess(excessData.perPerson);
            data.perPolicy = _formatExcess(excessData.perPolicy);
        }
        return data;
    }

    function _formatExcess(price) {
        return _.isNull(price) ? "$0" : meerkat.modules.currencyField.formatCurrency(price, { roundToDecimalPlace: 0 });
    }

    function getPrice(result) {
        var priceResult = {};
        var premiumSplit = result.lhcFreePriceMode ? result.priceLhcfreetext : result.priceText;
        premiumSplit = premiumSplit.split(".");
        priceResult.dollarPrice = premiumSplit[0]
            .replace('$', '')
            .replace(',', '');
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

    /**
     * @returns {number}
     */
    function getAvailableFeatureCount(specialFeatureStructure) {
        for (var i = 0, featureCount = 0; i < specialFeatureStructure.length; i++) {
            if (specialFeatureStructure[i].active === true) {
                featureCount++;
            }
        }
        return featureCount || 0;
    }

    function parseSpecialFeatures(product) {
        var specialOffer = getSpecialOffer(product);
        return [
            {
                id: 'discount',
                title: "Discount",
                className: "icon-percentage-tag",
                text: product.promo.discountText,
                active: !_.isEmpty(product.promo) && !_.isEmpty(product.promo.discountText)
            },
            {
                id: 'restrictedFund',
                title: "This is a Restricted Fund",
                className: "icon-no-symbol",
                text: "<p>Restricted funds provide private health insurance cover to members of a specific industry or group.</p> <p>In some cases, family members and extended family are also eligible.</p>",
                active: product.info.restrictedFund === 'Y'
            },
            {
                id: 'customisedCover',
                title: Object.byString(product, 'custom.info.content.results.header.label'),
                className: 'icon-customise',
                text: Object.byString(product, 'custom.info.content.results.header.text'),
                active: !!Object.byString(product, 'custom.info.content.results.header')
            },
            {
                id: 'specialOffer',
                title: "Special Offer",
                className: "icon-ribbon",
                text: specialOffer.displayValue,
                active: specialOffer.displayValue !== false
            },
            {
                id: 'marketingOffer',
                title: "Marketing",
                className: "icon-life",
                text: "Get insured online to redeem meerkat toy",
                active: true
            }
        ];
    }

    /**
     * The health results requires a more dynamic display of the content in this features bar.
     * Scenario 1: 4 features, so 4 icons with popovers
     * Scenario 2: 3 features, so 3 icons with popovers
     * Scenario 3: 2 features, so 2 icons with inline text
     * Scenario 4: 1 feature, so 1 icon with inline text.
     * @param {Object} product
     */
    function getSpecialFeaturesContent(product, specialFeatureStructure) {

        var featureCount = getAvailableFeatureCount(specialFeatureStructure);

        var output = '';
        if (featureCount >= 3) {
            output += _templateIterator(specialFeatureStructure, '#results-product-special-features-popover-template');
        } else {
            output += _templateIterator(specialFeatureStructure, '#results-product-special-features-inline-template');
        }
        return output;
    }

    /**
     * Helper function
     * @param specialFeatureStructure
     * @param template
     * @returns {string}
     * @private
     */
    function _templateIterator(specialFeatureStructure, template) {
        var htmlTemplate = meerkat.modules.templateCache.getTemplate($(template));
        for (var i = 0, output = ''; i < specialFeatureStructure.length; i++) {
            if (specialFeatureStructure[i].active === true) {
                output += htmlTemplate(specialFeatureStructure[i]);
            }
        }
        return output;
    }

    function init() {
        $(document).ready(function () {
            $resultsPagination = $('.results-pagination');
        });
    }

    function postRenderFeatures() {

        eventSubscriptions();

        $('.featuresListHospitalOther > .collapsed').removeClass('collapsed');

        // For each result, check if there are restricted benefits. If there are, display the restricted benefit text.
        $('.hospitalCoverSection', $('.result-row')).each(function () {
            var $el = $(this);
            if ($el.find('sup').length) {
                $el.find('.restrictedBenefit').removeClass('hidden');
            }
        });

        // populate extras selections list with empty div
        if (numberOfSelectedExtras() === 0) {
            $('.featuresListExtrasSelections .children').html('<div class="cell category collapsed"><div class="labelInColumn no-selections"><div class="content" data-featureid="9997"><div class="contentInner">No extras benefits selected</div></div></div></div>');
        }

        if (numberOfSelectedHospitals() === 0) {
            $('.featuresListHospitalSelections .children').each(function () {
                if ($.trim($(this).html()) === '') {
                    $(this).html('<div class="cell category collapsed"><div class="labelInColumn no-selections"><div class="content" data-featureid="9996"><div class="contentInner">No hospital benefits selected</div></div></div></div>');
                }
            });
        }

    }

    function numberOfSelectedExtras() {
        var pageStructure = Features.getPageStructure(3);
        return pageStructure && pageStructure.length ? pageStructure[0].children.length : 0;
    }

    function numberOfSelectedHospitals() {
        var pageStructure = Features.getPageStructure(2);
        return pageStructure && pageStructure.length ? pageStructure[0].children.length : 0;
    }

    function eventSubscriptions() {

        $(document).off('click', '.remove-result').on('click', '.remove-result', function () {
            var $el = $(this);
            if (!$el.hasClass('disabled')) {
                // prevent multi clicking
                $el.addClass('disabled');
                filteredOutResults.push($el.attr('data-productId'));
                Results.filterBy("productId", "value", { "notInArray": filteredOutResults }, true, true);
                toggleRemoveResultPagination();
                updateHiddenProductsTemplate();
            }
            // reset the disable so they can click again when reset
            _.delay(function () {
                $el.removeClass('disabled');
            }, 1000);

        }).off('click', '.reset-filters').on('click', '.reset-filters', function (e) {
            e.preventDefault();
            filteredOutResults = [];
            Results.unfilterBy('productId', "value", true);
            updateHiddenProductsTemplate();
            _.defer(function () {
                toggleRemoveResultPagination();
            });
        });
    }

    function toggleRemoveResultPagination() {
        var pageMeasurements = Results.pagination.calculatePageMeasurements();
        if (!pageMeasurements || pageMeasurements && pageMeasurements.numberOfPages <= 1) {
            $resultsPagination.find('.navbar-collapse').addClass('hidden');
        } else {
            $resultsPagination.find('.navbar-collapse').removeClass('hidden');
        }
    }

    function updateHiddenProductsTemplate() {
        var message = "";
        if (filteredOutResults.length > 0) {
            var template = meerkat.modules.templateCache.getTemplate($("#filter-results-hidden-products"));
            message = template({
                count: filteredOutResults.length
            });
        }
        $('.filter-results-hidden-products').html(message);
    }

    meerkat.modules.register('healthResultsTemplate', {
        init: init,
        getAvailableBenefits: getAvailableBenefits,
        getPopOverContent: getPopOverContent,
        getPricePremium: getPricePremium,
        getExcessPrices: getExcessPrices,
        getPrice: getPrice,
        getSpecialOffer: getSpecialOffer,
        getItem: getItem,
        getExcessItem: getExcessItem,
        postRenderFeatures: postRenderFeatures,
        numberOfSelectedExtras: numberOfSelectedExtras,
        toggleRemoveResultPagination: toggleRemoveResultPagination,
        getSpecialFeaturesContent: getSpecialFeaturesContent,
        getAvailableFeatureCount: getAvailableFeatureCount,
        parseSpecialFeatures: parseSpecialFeatures
    });

})(jQuery);
