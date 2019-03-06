;(function ($) {
    var meerkat = window.meerkat,
        $resultsPagination,
        filteredOutResults = [],  // this is used for removing the results when clicking the "x";
        fundDiscounts = null;

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

        // if (!availableBenefits.length) {
        //     if (numberOfSelectedExtras() === 0) {
        //         $('.featuresListExtrasOtherList').addClass('hidden');
        //     } else if (numberOfSelectedHospitals() === 0) {
        //         $('.featuresListHospitalOtherList').addClass('hidden');
        //     }
        // }
        return availableBenefits;
    }

    /**
     * Get the list of available extras.
     * @param obj The Result object for that product.
     * @returns {string}
     */
    function getAvailableExtrasAsList(obj) {
        var feature = Features.getPageStructure(obj.featuresStructureIndexToUse)[0];
        var availableExtras = [],
            output = "";
        _.each(feature.children, function (ft) {
            if (ft.doNotRender === true) {
                return;
            }
            var hasResult = ft.resultPath !== null && ft.resultPath !== '';
            var pathValue = hasResult ? Object.byString(obj, ft.resultPath) : false;
            //Also check the first value in the case of april 1 products
            if (pathValue && (pathValue == "Y" || (pathValue.length > 1 && pathValue[0] === 'Y'))) {
                availableExtras.push(ft);
            }
        });
        if (!availableExtras.length) {
            //4 = Hospital Cover
            output = 'No other benefits available';
        } else {
            _.each(availableExtras, function (ft, i) {
                var separator = '';
                if (i == (availableExtras.length - 2)) {
                    separator = ' and ';
                } else if (i !== availableExtras.length - 1) {
                    separator = ', ';
                }
                output += ft.safeName + separator;
            });
        }

        return output;
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
     * Generate the display value with title before or after, extra text, etc.
     * Logic may not work as expected compared to the old way
     * @param pathValue
     * @param ft
     * @returns {*}
     */
    function buildDisplayValue(pathValue, ft, obj) {
        var displayValue = Features.parseFeatureValue(pathValue, true);

        if(!_.isEmpty(displayValue)) {
            return displayValue + _getHelpTooltip(ft);
        }
        return 'None';
    }

    /**
     *
     * @param ft
     * @returns {string}
     * @private
     */
    function _getHelpTooltip(ft) {
        var attribute = '';
        var analytics = {
            "300" : "no COP",
            "301" : "waiting period",
            "303" : "excess waivers"
        };
        if(_.has(analytics, ft.helpId)) {
            attribute = meerkat.modules.dataAnalyticsHelper.get(analytics[ft.helpId],'"');
        }
        return ft.helpId !== '' && ft.helpId != '0' ? '<a href="javascript:void(0);" class="help-icon icon-info" data-content="helpid:' + ft.helpId + '" data-toggle="popover" ' + attribute + '><span class="text-hide">Need Help?</span></a>' : '';
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
        if(window.meerkat.site.isHealthReformMessaging === 'Y') {
            if(ft.pathValue) {
                getNowAndAprilCover(ft, ft.pathValue);
            }else{
                ft.hideCategoryApril = true;
            }
        }else{
            if(ft.pathValue) {
                ft.isRestricted = ft.pathValue[0] == "R";
                ft.isNotCovered = ft.pathValue[0] == "N";
            }
            ft.hideCategoryApril = true;
        }

        ft.hasChildFeatures = typeof ft.children !== 'undefined' && ft.children.length;

        // Additional attributes for category's only.
        if (ft.type == 'category') {
            var isSelectedBenefit = obj.featuresStructureIndexToUse === "2";
            var afterChangeDate = false;
            var changeDate = parseChangeDate(obj.custom.reform ? obj.custom.reform.changeDate : null);

            if(changeDate) {
                var timeToCheck = getApplicationDateTime();

                afterChangeDate = changeDate.getTime() < timeToCheck; 
            }
    
            ft.displayItem = ft.type != 'section';
            ft.isBenefit = obj.featuresStructureIndexToUse === "4";
            ft.beforeChangeDate = !isSelectedBenefit && !afterChangeDate;

            ft.classStringForInlineLabelCover = "";

            if (ft.name === '') {
                ft.classStringForInlineLabel += " noLabel";
            }
            if (ft.isNotCovered) {
                ft.labelInColumnContentClass = ' noCover';
            } else if (ft.isRestricted) {
                ft.labelInColumnContentClass = ' restrictedCover';
            } else {
                ft.labelInColumnContentClass = '';
            }

            if(ft.isNotCoveredApril) {
                ft.labelInColumnContentClassApril =  ft.hideCategoryApril ? ' hidden' : '' + ' noCover';
            } else if (ft.isRestrictedApril) {
                ft.labelInColumnContentClassApril = ft.hideCategoryApril ? ' hidden' : '' + ' restrictedCover';
            } else if(ft.isTbaApril) {
                ft.labelInColumnContentClassApril = ft.hideCategoryApril ? ' hidden' : 'tbaCover';
            } else if(ft.hideCategoryApril) {
                ft.labelInColumnContentClassApril = 'hidden';
            }else {
                ft.labelInColumnContentClassApril = '';
            }

            if(ft.isNotCoveredApril && ft.isNotCovered) {
                ft.classStringForInlineLabelCover = "noCover";
            }

        } else if (ft.type == 'feature') {
            ft.displayValue = buildDisplayValue(ft.pathValue, ft, obj);
        }

        // For sub-category feature detail
        var isSelectionHolder = ft.classString && ft.classString.indexOf('selectionHolder') != -1;
        ft.displayChildren = ft.hasChildFeatures || isSelectionHolder;
        if (ft.displayChildren) {
            ft.hideChildrenClass = ft.isNotCovered ? ' hideChildren' : '';
        }

        return ft;
    }

    function getNowAndAprilCover(ft, val) {
        if(val.length > 2) {
            return;
        }

        var nowVal = val[0];
        var aprilVal = val.length > 1 ? val[1] : '';    

        ft.isRestricted = false;
        ft.isNotCovered = false;

        switch(nowVal) {
            case 'R' :
                ft.isRestricted = true;
            break;
            case 'N' :
            ft.isNotCovered = true;
            break;
        }

        ft.isRestrictedApril = false;
        ft.isNotCoveredApril = false;
        ft.isTbaApril = false;
        ft.hideCategoryApril = aprilVal ? false : true;

        switch(aprilVal){
            case 'N':
                ft.isNotCoveredApril = true;
            break;
            case 'R':
                ft.isRestrictedApril = true;
            break;
            case 'X':
                //ft.isNotCoveredApril = true;
                ft.isTbaApril = true;
            break;
            case 'Q':
                ft.isTbaApril = true;
            break;
            case 'P':
                ft.isTbaApril = true;
            break;
            case 'F':
                //ft.isRestrictedApril = true;
                ft.isTbaApril = true;
            break;
        }
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
        result.textLhcFreePricing = prem.lhcfreepricing ? prem.lhcfreepricing.replace('<span/>', '<br>') : 'price excl ' + formatCurrency(prem.lhcAmount) +
            'LHC<br>Inc. ' +
            formatCurrency(prem.rebateAmount) + ' Govt Rebate';
        result.textPricing = prem.pricing ? prem.pricing : 'Includes rebate of ' + formatCurrency(prem.rebateAmount) +
            ' & LHC loading of ' + formatCurrency(prem.lhcAmount);
        result.hasValidPrice = (prem.value && prem.value > 0) || (prem.text && prem.text.indexOf('$0.') < 0) ||
            (prem.payableAmount && prem.payableAmount > 0);
        result.lhcFreePriceMode = typeof mode === "undefined" || (mode !== "lhcInc" || prem.lhcfreepricing.indexOf('The premium may be affected by LHC') === 0 && meerkat.modules.healthLHC.getNewLHC() === null);
        result.discounted = prem.discounted === 'Y';
        result.discountPercentage = prem.discountPercentage;
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

    function getClassification(obj) {
        var classification = {};
        classification.icon = getClassificationIcon(obj.custom.reform ? obj.custom.reform.tier : null);
        classification.date = getClassificationDate(obj);

        return classification;
    }

    function parseChangeDate(date) {
        if(!date || date.toLowerCase() === 'unknown') {
            return null;
        }

        var day = date.split(' ')[0];
        var dayNumbers = day.match(/\d+/g).join([]);

        var month = date.split(' ')[1];
        var year = date.split(' ')[2] ? date.split(' ')[2] : '2019';
        
        return new Date(Date.parse(dayNumbers + ' ' + month + ' ' + year));
    }

    function getApplicationDateTime() {
        var applicationDate = $('#health_searchDate').val();
        var applicationDateString = ''; 

        if(applicationDate) {
            var dateSplit = applicationDate.split('/');
            var year = dateSplit[2];
            var month = dateSplit[1];
            var day = dateSplit[0];
            applicationDateString = year + '-' + month + '-' + day;
        }

        return timeToCheck = applicationDate ? new Date(applicationDateString).getTime() :  meerkat.site.serverDate.getTime();
    }

    function getClassificationDate(obj) {
        var dateParsed = obj.custom.reform ? parseChangeDate(obj.custom.reform.changeDate) : null;
        var curDateTime = getApplicationDateTime();

        if(!dateParsed || curDateTime > dateParsed.getTime()) {
            return '';
        }

        var year = dateParsed.getFullYear();
        var day = dateParsed.getDate();
        var month = dateParsed.toLocaleString('en-au', { month: "long" });

        switch(month) {
            case 'January':
                return day + ' Jan ' + year;
            case 'February': 
                return day + ' Feb ' + year;
            case 'March':
                return day + ' Mar ' + year;
            case 'April':
                return day + ' Apr ' + year;
            case 'May':
                return day + ' May ' + year;
            case 'June':
                return day + ' Jun ' + year;
            case 'July':
                return day + ' Jul ' + year;
            case 'August':
                return day + ' Aug ' + year;
            case 'September':
                return day + ' Sep ' + year;
            case 'October':
                return day + ' Oct ' + year;
            case 'November':
                return day + ' Nov ' + year;
            case 'December':
                return day + ' Dec ' + year;
            default :
                return '';
        }
    }

    function getCoverDate(obj) {
        var dateParsed = obj.custom.reform ? parseChangeDate(obj.custom.reform.changeDate) : null;
        var curDate = window.meerkat.site.serverDate;

        if(!dateParsed || curDate.getTime() > dateParsed.getTime()) {
            return '';
        }

        var day = dateParsed.getDate();
        var month = dateParsed.toLocaleString('en-au', { month: "long" });

        switch(month) {
            case 'January':
                return 'From Jan ' + day;
            case 'February': 
                return 'From Feb ' + day;
            case 'March':
                return 'From March ' + day;
            case 'April':
                return 'From April ' + day;
            case 'May':
                return 'From May ' + day;
            case 'June':
                return 'From June ' + day;
            case 'July':
                return 'From July ' + day;
            case 'August':
                return 'From August ' + day;
            case 'September':
                return 'From Sept ' + day;
            case 'October':
                return 'From Oct ' + day;
            case 'November':
                return 'From Nov ' + day;
            case 'December':
                return 'From Dec ' + day;
            default :
                return '';
        }
    }

    function getClassificationIcon(tier) {
        if(!tier) {
            return 'gov-unclassified';
        }

        if(tier.toLowerCase().indexOf('bronze') > -1) {
            if(tier.toLowerCase().indexOf('+') > -1) {
                return 'gov-bronze-plus';
            }else{
                return 'gov-bronze';
            }
        }else if(tier.toLowerCase().indexOf('silver') > -1) {
            if(tier.toLowerCase().indexOf('+') > -1) {
                return 'gov-silver-plus';
            }else{
                return 'gov-silver';
            }
        }else if(tier.toLowerCase().indexOf('gold') > -1){

            return 'gov-gold';

        }else if(tier.toLowerCase().indexOf('basic') > -1) {
            if(tier.toLowerCase().indexOf('+') > -1) {
                return 'gov-basic-plus';
            }else{
                return 'gov-basic';
            }
        }else
        {
            return 'gov-unclassified';
        }
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
                id: 'restrictedFund',
                title: "This is a Restricted Fund",
                className: "icon-no-symbol",
                text: "Restricted Fund",
                active: product.info.restrictedFund === 'Y',
                productId: product.productId
            },
            {
                id: 'marketingOffer',
                title: "Rewards",
                className: "icon-" + meerkat.modules.rewardCampaign.getCampaignContentHtml().find('.reward-icon-code').html(),
                text: meerkat.modules.rewardCampaign.getCampaignContentHtml().find('.reward-result-text').html(),
                active: meerkat.modules.rewardCampaign.isCurrentCampaignValid(),
                productId: product.productId
            },
            {
                id: 'specialOffer',
                title: "Special Offer",
                className: "icon-ribbon",
                text: specialOffer.displayValue,
                active: specialOffer.displayValue !== false,
                productId: product.productId
            },
            {
                id: 'discount',
                title: "Discount",
                className: "icon-percentage-tag",
                text: product.promo.discountText,
                active: !_.isEmpty(product.promo) && !_.isEmpty(product.promo.discountText),
                productId: product.productId
            },
            {
                id: 'customisedCover',
                title: Object.byString(product, 'custom.info.content.results.header.label'),
                className: 'icon-customise',
                text: Object.byString(product, 'custom.info.content.results.header.text'),
                active: !!Object.byString(product, 'custom.info.content.results.header'),
                productId: product.productId
            },
            {
                id: 'awardScheme',
                title: "Award Scheme",
                className: "icon-ribbon",
                text: Object.byString(product, 'awardScheme.text'),
                active: _.has(product, 'awardScheme') && _.has(product.awardScheme, 'text') && !_.isEmpty(product.awardScheme.text),
                productId: product.productId
            }
        ];
    }

    /**

     * @param {Object} product
     * @param {Number} number of features to render.
     */
    /**
     * RELEASED LOGIC:
     * Due to the design not catering for long special offers etc, we needed to change this completely.
     * Scenario 1: you just have 2 features
     * Scenario 2: you just have 1 feature.
     * ORIGINAL LOGIC:
     * The health results requires a more dynamic display of the content in this features bar.
     * Scenario 1: 4 features, so 4 icons with popovers
     * Scenario 2: 3 features, so 3 icons with popovers
     * Scenario 3: 2 features, so 2 icons with inline text
     * Scenario 4: 1 feature, so 1 icon with inline text.
     * @param product
     * @param specialFeatureStructure
     * @param numberToRender
     * @returns {string}
     */
    function getSpecialFeaturesContent(product, specialFeatureStructure, numberToRender) {

        var featureCount = getAvailableFeatureCount(specialFeatureStructure);

        var templateToUse = '#results-product-special-features-inline-template';
        if (featureCount >= 3 && numberToRender >= 3) {
            templateToUse = '#results-product-special-features-popover-template';
        }
        return _templateIterator(specialFeatureStructure, templateToUse, numberToRender).slice(0,2).join('');
    }

    /**
     * Helper method
     * @param specialFeatureStructure
     * @param {string} template
     * @param {number} numberToRender
     * @returns {Array}
     * @private
     */
    function _templateIterator(specialFeatureStructure, template, numberToRender) {
        var htmlTemplate = meerkat.modules.templateCache.getTemplate($(template));
        for (var i = 0, output = []; i < specialFeatureStructure.length; i++) {
            if (specialFeatureStructure[i].active === true) {
                output.push(htmlTemplate(specialFeatureStructure[i]));
            }
        }
        return output;
    }

    function init() {
        $(document).ready(function () {
            $resultsPagination = $('.results-pagination');
            if(fundDiscounts === null && meerkat.site.hasOwnProperty("fundDiscounts") && !_.isEmpty(meerkat.site.fundDiscounts)) {
                fundDiscounts = meerkat.site.fundDiscounts;
            }
        });
    }

    function postRenderFeatures() {
        eventSubscriptions();

        if(numberOfSelectedHospitals() === 0) {
            $('.featuresListHospitalSelections .children').each(function(){
                if ($.trim($(this).html()) === '') {
                    $(this).html('<div class="cell category collapsed"><div class="labelInColumn no-selections"><div class="content" data-featureid="9996"><div class="contentInner">No hospital benefits selected</div></div></div></div>');
                }
            });
        }

        var excessWaiverHeight = 0;

        $('.content.excess-wavier').each(function() {
            if($(this).height() > excessWaiverHeight) {
                excessWaiverHeight = $(this).height();
            }
        });


        $('.content.excess-wavier').each(function() {
            $(this).height(excessWaiverHeight);
        });
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

        }).off('click', '.reset-show-hide-filters').on('click', '.reset-show-hide-filters', function (e) {
            e.preventDefault();
            Results.unfilterBy('productId', "value", true);
            unhideFilteredProducts();
        }).off('click', '.featuresListExtrasOtherList').on('click', '.featuresListExtrasOtherList', function () {
            $('.featuresListExtrasOtherList').addClass('hidden');
            $('.featuresListExtrasFullList > .collapsed').removeClass('collapsed');
            $('.featuresListExtrasFullList').removeClass('hidden');
            $('.otherExtrasBenefits .coverTitle .featuresViewAll').removeClass('hidden');
            $('.featuresListExtrasFullList .children').children('.cell .category').each(function(i) { 
                var element = $(this).first();
                var selectedBenefits = window.meerkat.modules.healthResults.getSelectedBenefitsList();
                var featureId = element.context.children[0].children[0].getAttribute('data-featureid');
                var alreadySelected = selectedBenefits.indexOf(featureId) > -1;
                if(!$(this).hasClass('hidden') && alreadySelected) {
                    $(this).addClass('hidden');
                }
            });
        }).off('click', '.featuresListHospitalOtherList').on('click', '.featuresListHospitalOtherList', function () {
            $('.featuresListHospitalOtherList').addClass('hidden');
            $('.featuresListHospitalFullList > .collapsed').removeClass('collapsed');
            $('.featuresListHospitalFullList').removeClass('hidden');
            $('.otherHospitalBenefits .coverTitle .featuresViewAll').removeClass('hidden');

            $('.featuresListHospitalFullList .children').children('.cell .category').each(function(i) { 
                var element = $(this).first();
                var selectedBenefits = window.meerkat.modules.healthResults.getSelectedBenefitsList();
                var featureId = element.context.children[0].children[0].getAttribute('data-featureid');
                var alreadySelected = selectedBenefits.indexOf(featureId.toString()) > -1;
                if(!$(this).hasClass('hidden') && alreadySelected) {
                    $(this).addClass('hidden');
                }
            });
        }).off('click', '.otherHospitalBenefits .coverTitle').on('click', '.otherHospitalBenefits .coverTitle', function () {
            $('.featuresListHospitalOtherList').removeClass('hidden');
            $('.featuresListHospitalFullList').addClass('hidden');
            $('.otherHospitalBenefits .coverTitle .featuresViewAll').addClass('hidden');
        }).off('click', '.otherExtrasBenefits .coverTitle').on('click', '.otherExtrasBenefits .coverTitle', function () {
            $('.featuresListExtrasOtherList').removeClass('hidden');
            $('.featuresListExtrasFullList').addClass('hidden');
            $('.otherExtrasBenefits .coverTitle .featuresViewAll').addClass('hidden');
        });
    }

    function unhideFilteredProducts() {
        filteredOutResults = [];
        updateHiddenProductsTemplate();
        _.defer(toggleRemoveResultPagination);
    }

    function toggleRemoveResultPagination() {
        var pageMeasurements = Results.pagination.calculatePageMeasurements();
        if (!pageMeasurements || pageMeasurements && pageMeasurements.numberOfPages <= 1) {
            $resultsPagination.addClass('invisible');
        } else {
            $resultsPagination.removeClass('invisible');
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

    function fundDiscountExists(fundCode) {
    	return fundDiscounts !== null && fundDiscounts.hasOwnProperty(fundCode) && !_.isEmpty(fundDiscounts[fundCode]) && fundDiscounts[fundCode] === "Y";
    }

    function getDiscountText(result) {
        var discountText = result.hasOwnProperty('promo') && result.promo.hasOwnProperty('discountText') ? result.promo.discountText : '';

        if (result.info.FundCode === 'AUF') {
        	var discount = getDiscountPercentage(result.info.FundCode);
            discountText = _.isEmpty(discount) || !fundDiscountExists(result.info.FundCode) ? '' : discountText.replace('%%discountPercentage%%', discount+'%');
        }

        return discountText;
    }

    function getDiscountPercentage(fundCode, result) {
        var discountPercentage = !_.isUndefined(result) && result.hasOwnProperty('discountPercentage') ? result.discountPercentage : '';

        if (fundCode === 'AUF') {
        	if(!fundDiscountExists(fundCode)) {
		        discountPercentage = '';
	        } else {
		        if (meerkat.modules.healthPrimary.getCurrentlyHaveAnyKindOfCoverPreResults() === 'N' ||
			        (meerkat.modules.healthChoices.hasPartner() && meerkat.modules.healthPartner.getCurrentlyHaveAnyKindOfCoverPreResults() === 'N')) {
			        discountPercentage = '7.5';
		        } else {
			        discountPercentage = '4';
		        }
	        }
        }

        return discountPercentage;
    }

    meerkat.modules.register('healthResultsTemplate', {
        init: init,
        getAvailableBenefits: getAvailableBenefits,
        getAvailableExtrasAsList: getAvailableExtrasAsList,
        getPopOverContent: getPopOverContent,
        getPricePremium: getPricePremium,
        getExcessPrices: getExcessPrices,
        getPrice: getPrice,
        getSpecialOffer: getSpecialOffer,
        getClassification: getClassification,
        getItem: getItem,
        getExcessItem: getExcessItem,
        postRenderFeatures: postRenderFeatures,
        numberOfSelectedExtras: numberOfSelectedExtras,
        toggleRemoveResultPagination: toggleRemoveResultPagination,
        getSpecialFeaturesContent: getSpecialFeaturesContent,
        getAvailableFeatureCount: getAvailableFeatureCount,
        parseSpecialFeatures: parseSpecialFeatures,
        unhideFilteredProducts: unhideFilteredProducts,
        getDiscountText: getDiscountText,
        getDiscountPercentage: getDiscountPercentage,
        fundDiscountExists: fundDiscountExists,
        getCoverDate: getCoverDate,
        parseChangeDate: parseChangeDate
    });

})(jQuery);
