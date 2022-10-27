;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        selectedProduct = {},
        bannerModalId = null,
        freqTextMapping = {
            'halfyearly': 'half yearly',
            'quarterly': 'quarterly',
            'monthly': 'monthly',
            'fortnightly': 'fortnightly',
            'weekly': 'weekly'
        },
        isActive = null,
        _trackModalClose = true,
        dualPricingVarsProductHeaderTemplate = {};
        dualPricingVarsProductHeaderTemplateResultCard = {};

    function initDualPricing() {
        if (!isDualPricingActive() && meerkat.site.pageAction !== 'confirmation') {
            return true;
        }

        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();
    }

    function isDualPricingActive() {
        if(isActive === null) {
            isActive = typeof meerkat.site.isDualPricingActive !== 'undefined' && meerkat.site.isDualPricingActive;
        }
        return isActive;
    }

    function _setupElements() {
        $elements = {
            logoPriceTemplateResultCard: $('#logo-price-template-result-card'),
            logoPriceTemplateSideBar: $('#logo-price-template-side-bar'),
            logoPriceTemplateSinglePriceSideBar: $('#logo-price-template-single-price-side-bar'),
            logoPriceTemplate: $('#logo-price-template'),
            affixedHeaderLogoPriceTemplate: $('#affixed-header-logo-price-template'),
            template: {
                results: {
                    default: $('#dual-pricing-results-template')
                },
                moreinfo: {
                    default: $('#dual-pricing-moreinfo-template'),
                    xs : $('#dual-pricing-moreinfo-xs-template'),
                    affixedHeader: $('#dual-pricing-moreinfo-affixed-header-template')
                },
                sidebar: $('#dual-pricing-template-sidebar'),
                applicationXS: $('#dual-pricing-application-xs-template')
            },
            bannerModalTemplate: $('#price-rise-banner-template'),
            sideBarFrequency: $('.sidebarFrequency'),
            priceRiseBanner: $('.price-rise-tag'),
            sideBarFrequencyTemplate: $('#sideBarFrequency'),
            paymentDetailsSelection: $('#health_payment_details-selection'),
            paymentDetailsFrequency: $('#health_payment_details-selection').find('#health_payment_details_frequency'),
            priceFrequencyTemplate: $('#price-frequency-template'),
            frequencyWarning: $('#health_payment_details-selection').find('.frequencyWarning'),
            quoterefTemplate: $('#quoteref-template'),
            priceCongratsTemplate: $('#price-congratulations-template'),
            priceBreakdownLHCCopyTemplate: $('#price-breakdown-lhc-template')
        };

        $elements.sideBarFrequency.hide();
        $elements.priceRiseBanner.removeClass("hidden");
    }

    function _applyEventListeners() {
        $elements.paymentDetailsFrequency.on('change.healthDualPricing', function updateWarningLabel() {
            if (_.isEmpty($(this).val())) return;

        	var coverStartDate = getCoverStartDate(),
                frequency = $(this).val().toLowerCase(),
                selectedProduct = meerkat.modules.healthResults.getSelectedProduct(),
                selectedPayment = meerkat.modules.healthPaymentStep.getPaymentMethodNode(),
                pricingDate = new Date(selectedProduct.pricingDate),
                pricingDateFormatted = meerkat.modules.dateUtils.format(pricingDate, "Do MMMM"),
                dropDeadDate = new Date(selectedProduct.dropDeadDate),
                dropDeadDateFormatted = meerkat.modules.dateUtils.format(dropDeadDate, "Do MMMM"),
                template = null,
                obj = null;

            $elements.frequencyWarning.text('If your premiums are increasing on {{= pricingDateFormatted}} and you elect to pay ${frequency}, only payments made by the ${dropDeadDateFormatted} will be at the current amount, thereafter the new premium will apply.');

            // This script should only appear when there is a valid drop dead date entered.
            if (typeof selectedProduct.dropDeadDate === 'undefined' || !meerkat.modules.dateUtils.isValidDate(selectedProduct.dropDeadDate)) {
                $elements.frequencyWarning.slideUp();
                return;
            }

            if (frequency === 'annually') {
                if ($elements.priceCongratsTemplate.length === 1
                        && selectedProduct.paymentTypeAltPremiums[selectedPayment][frequency].value > 0) {
                    template = _.template($elements.priceCongratsTemplate.html());
                    var priceCalc = (parseFloat(selectedProduct.paymentTypeAltPremiums[selectedPayment][frequency].value - selectedProduct.paymentTypePremiums[selectedPayment][frequency].value)).toFixed(2);
                    obj = {
                        priceSaved: '$' + Math.abs(priceCalc),
                        beforeAfterText: priceCalc < 0 ? 'after' : 'before',
                        pricingDateFormatted: pricingDateFormatted
                    };
                } else {
                    $elements.frequencyWarning.slideUp().html("");
                    return;
                }
            } else {
                template = _.template($elements.priceFrequencyTemplate.html());
                obj = {
                    frequency: freqTextMapping[frequency],
                    pricingDateFormatted: pricingDateFormatted,
                    premium: selectedProduct.paymentTypePremiums[selectedPayment][frequency].text,
                    altPremium: selectedProduct.paymentTypeAltPremiums[selectedPayment][frequency].text,
                    hasValidDualPricingDate: (validateAndGetDualPricingDate(selectedProduct) !== null),
                    dropDeadDateFormatted: dropDeadDateFormatted
                };
            }
            $elements.frequencyWarning.html(template(obj)).removeClass("hidden").slideDown();
        });

        $(document).on('click', '.price-rise-tag .price-rise-banner-learn-more', function(e) {
            e.preventDefault();
            e.stopPropagation();
            var isCoverStartDateButtonEnabled = $("#health_payment_details_startInputD").length <= 0 || $("#health_payment_details_startInputD").prop("disabled") == false;
            // First condition below had to be added since it duplicates modal when opened at the end of journey.
            // The other condition is to make sure that the whole has been loaded fully - cover start date already enabled.
            // Solution below can be improved.
            if ($(".modal-dialog.dual-pricing-modal").length <= 0 && isCoverStartDateButtonEnabled) {
                _showBannerModal();
            }
        });
        $(document).on('click', '.price-rise-banner-close-btn', function() {
            _trackModalClose = false;
            _hideBannerModal();
        });

        $(document).on('click', 'a.live-chat', function() {
            $('.LPMcontainer').trigger('click');
        });

        $(document).on('change', 'input[name=health_dual_pricing_frequency]', function() {
            $('.dual-pricing-update-frequency-btn').toggleClass('dual-pricing-frequency-updated', $(this).val() !== $('#health_filter_frequency').val());
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_CHANGED, function hideSidebarFrequency(){
            $elements.sideBarFrequency.hide();
            $elements.frequencyWarning.hide();

            // update pricing date
            _updatePricingDate();
        });

        meerkat.messaging.subscribe(meerkatEvents.device.DEVICE_MEDIA_STATE_CHANGE, function editDetailsEnterXsState() {
            _hideBannerModal();
        });
    }
    function _showBannerModal() {

        _trackModalClose = true;

        bannerModalId = meerkat.modules.dialogs.show({
            className: 'dual-pricing-modal',
            htmlContent: $elements.bannerModalTemplate.html(),
            onOpen : function() {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: 'trackRateRise',
                    object: {
                        category: 'Health Rate Rise Modal',
                        action: 'Learn More Selected'
                    }
                });
            },
            onClose: function () {
                if (_trackModalClose) {
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: 'trackRateRise',
                        object: {
                            category: 'Health Rate Rise Modal',
                            action: 'Learn More Closed'
                        }
                    });
                }
            }
        });

        return bannerModalId;
    }

    function _hideBannerModal() {
        if (bannerModalId !== null) {
            meerkat.modules.dialogs.close(bannerModalId);
        }
    }

    function _updatePricingDate() {
        var product = Results.getSelectedProduct(),
            dropDeadDate = new Date(product.dropDeadDate),
            pricingDate = new Date(product.pricingDate);
        var coverStartDate = getCoverStartDate();

        if (!meerkat.modules.dateUtils.isValidDate(dropDeadDate)) {
            $('.hidden-if-drop-dead-date-invalid').hide();
        } else {
            $('.hidden-if-drop-dead-date-invalid').show();
        }

        if (!isNaN(dropDeadDate.getTime()) && !isNaN(pricingDate.getTime())) {
            $('.pricingDateText').text(meerkat.modules.dateUtils.format(pricingDate, "Do MMMM"));
            $('.dropDeadDateText').text(meerkat.modules.dateUtils.format(dropDeadDate, "Do MMMM"));
        }
    }

    function renderTemplate(target, product, returnTemplate, isForSidebar, page, isForAffixedHeader, isForResultPage) {
        if (typeof isForAffixedHeader === 'undefined') {
            isForAffixedHeader = false;
        }
        var deviceMediaState = meerkat.modules.deviceMediaState.get();

        selectedProduct = product;

        if(!_.isObject(product)) {
            return "";
        }

        product.priceBreakdownLHCCopy = '';
        product.isForResultPage = isForResultPage;

        if ($elements.priceBreakdownLHCCopyTemplate && $elements.priceBreakdownLHCCopyTemplate.length && meerkat.modules.healthPriceBreakdown.showBreakdown()) {
            var LHCCopy = _.template($elements.priceBreakdownLHCCopyTemplate.html());
            product.priceBreakdownLHCCopy = LHCCopy(product);
        }

        if (typeof product.dropDeadDate === 'undefined') {
            selectedProduct = Results.getSelectedProduct();
            product.dropDeadDate = selectedProduct.dropDeadDate;
            product.dropDeadDateFormatted = selectedProduct.dropDeadDateFormatted;
            product.dropDeadDatePassed = selectedProduct.dropDeadDatePassed;
        }

        product._selectedFrequency = typeof product._selectedFrequency === 'undefined' ? Results.getFrequency() : product._selectedFrequency;
        product.mode = product.mode !== '' ? product.mode : '';

        // this is only for simples users and regardless of what season we're in
        if (meerkat.site.isCallCentreUser === true) {
            product.mode = "lhcInc";
            product.showCurrPremText = isForSidebar;
        }

        product.showAltPremium = false;
        product.displayLogo = isForSidebar;
        product.showRoundingText = false;
        product.showRisingTag = (isForSidebar && deviceMediaState !== 'xs') || (meerkat.site.pageAction === 'confirmation');
        product.showFromDate = false;
        if (_.has(product, 'altPremium') && product.altPremium !== null) {
            var selectedAltPremium = meerkat.modules.healthResultsTemplate.getPricePremium(product._selectedFrequency, product.altPremium, product.mode);
            if (selectedAltPremium.hasValidPrice !== undefined) {
                product.showFromDate = selectedAltPremium.hasValidPrice;
            }
        }
        product.hasValidDualPricingDate = (validateAndGetDualPricingDate(product) !== null);
        product.showBeforeAfterText = (isForSidebar && product.hasValidDualPricingDate) || isForAffixedHeader;
        product.priceBreakdown = meerkat.modules.healthPriceBreakdown.showBreakdown();

        var pricingDate = new Date(selectedProduct.pricingDate);
        // named pricingDateFormatted because inside _updatePricingDate function it throws an invalid date when creating a new Date object with pricingDate,
        // for some reason Results.getSelectedProduct().pricingDate gets updated
        product.pricingDateFormatted = meerkat.modules.dateUtils.format(pricingDate, "MMMM Do, YYYY");
        if (product.hasValidDualPricingDate) {
            product.dualPricingDateFormatted = meerkat.modules.dateUtils.dateValueShortFormat(product.dualPricingDate, true);
            product.dualPricingDateOnlyMonth = meerkat.modules.dateUtils.monthOfDateValue(product.dualPricingDate);
            product.dualPricingDateWithYear = meerkat.modules.dateUtils.dateValueMediumFormat(product.dualPricingDate);
        }

        var htmlTemplate = '';
        if ($elements.logoPriceTemplate.html()) {
            htmlTemplate= _.template($elements.logoPriceTemplate.html());
        }
        var htmlTemplateResultCard = '';
        if ($elements.logoPriceTemplateResultCard.html()) {
            htmlTemplateResultCard = _.template($elements.logoPriceTemplateResultCard.html());
        }
        var htmlTemplateMoreInfo = $("#price-template-more-info").length ? meerkat.modules.templateCache.getTemplate($("#price-template-more-info")) : undefined;

        product.renderedPriceTemplate = !htmlTemplate ? undefined : htmlTemplate(product);
        product.renderedPriceTemplateResultCard = !htmlTemplateResultCard ? undefined : htmlTemplateResultCard(product);
        product.renderedMoreInfoDualPricing = !htmlTemplateMoreInfo ? undefined : htmlTemplateMoreInfo(product);

        var htmlTemplateSideBar = $elements.logoPriceTemplateSideBar.html() ? _.template($elements.logoPriceTemplateSideBar.html()) : undefined;

        product.renderedPriceTemplateSideBar = !htmlTemplateSideBar ? undefined : htmlTemplateSideBar(product);

        var affixedHeaderTemplate = '';
        if($elements.affixedHeaderLogoPriceTemplate.html()) {
            affixedHeaderTemplate = _.template($elements.affixedHeaderLogoPriceTemplate.html());
            product.renderedAffixedHeaderPriceTemplate = affixedHeaderTemplate(product);
        }

        product.showAltPremium = _.has(product, 'altPremium') && product.altPremium !== null;
        if (product.showAltPremium) {
            product.displayLogo = false;
            product.showCurrPremText = false;
            product.showRisingTag = false;

            if ($elements.logoPriceTemplate.html()) {
                htmlTemplate = _.template($elements.logoPriceTemplate.html());
            }

            if($elements.affixedHeaderLogoPriceTemplate.html()) {
                product.renderedAltAffixedHeaderPriceTemplate = affixedHeaderTemplate(product);
            }
            if ($elements.logoPriceTemplateResultCard.html()) {
                htmlTemplateResultCard = _.template($elements.logoPriceTemplateResultCard.html());
            }
            product.renderedAltPriceTemplateResultCard = !htmlTemplateResultCard ? undefined : htmlTemplateResultCard(product);
            product.renderedAltMoreInfoDualPricing = !htmlTemplateMoreInfo ? undefined : htmlTemplateMoreInfo(product);
            htmlTemplateSideBar = $elements.logoPriceTemplateSideBar.html() ? _.template($elements.logoPriceTemplateSideBar.html()) : undefined;

            product.renderedAltPriceTemplateSideBar = !htmlTemplateSideBar ? undefined : htmlTemplateSideBar(product);

            product.renderedAltPriceTemplate = !htmlTemplate ? undefined : htmlTemplate(product);
        }
        product.dropDeadDate = meerkat.modules.dropDeadDate.getDropDeadDate(product);
        product.dropDatePassed = meerkat.modules.dropDeadDate.getDropDatePassed(product);
        $elements.mainDualPricingTemplate = _getTemplate(isForSidebar, isForAffixedHeader, page);
        var dualPriceTemplate = '';
        if ($elements.mainDualPricingTemplate.html()) {
            dualPriceTemplate = _.template($elements.mainDualPricingTemplate.html());
        }

        if (returnTemplate === true) {
            return dualPriceTemplate(product);
        } else {
            $(target).html(dualPriceTemplate(product));

            if (isForSidebar && $elements.quoterefTemplate.length > 0) {
                var quoterefTemplate = _.template($elements.quoterefTemplate.html());
                $(target).parent().find('.quoterefTemplateHolder').html(quoterefTemplate());
            }
        }
    }

    function _getTemplate(isForSidebar, isForAffixedHeader, page) {
        var deviceMediaState = meerkat.modules.deviceMediaState.get();

        if (isForAffixedHeader) {
            return $elements.template.moreinfo.affixedHeader;
        }

        if (isForSidebar) {
            return $elements.template.sidebar;
        }

        page = page || 'moreinfo';

        return $elements.template[page][deviceMediaState] || $elements.template[page]['default'];
    }

    function getDualPricingVarsForProductHeaderTemplate(obj) {
        var output = {};
        
        var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template"));
        var logoHtml = logoTemplate(obj);
        var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template"));
        obj._selectedFrequency = Results.getFrequency(); obj.showAltPremium = false;
        var frequency = obj._selectedFrequency;
        var frequencyPremium = obj.premium[frequency];
        var lhtText = getLhcText(frequencyPremium);
        
        output.isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;
        output.logoHtml = logoHtml;
        output.priceTemplate = priceTemplate;
        output.lhtText = lhtText;

        return output;
    }

    function getDualPricingVarsForProductHeaderTemplateResultCard(obj) {
        var output = {};
        
        var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template"));
        var logoHtml = logoTemplate(obj);
        var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template-result-card"));
        obj._selectedFrequency = Results.getFrequency(); obj.showAltPremium = false;
        var frequency = obj._selectedFrequency;
        var frequencyPremium = obj.premium[frequency];
        var lhtText = getLhcText(frequencyPremium);
        var abdRequestFlag = obj.info.abdRequestFlag;
        var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;
        var isConfirmation = false;

        try{
            isConfirmation = _.isNumber(meerkat.modules.healthConfirmation.getPremium());
            } catch(e) {}

        var availablePremiums = getProperty(obj, obj.premium, obj.altPremium);
        var healthResultsTemplate = meerkat.modules.healthResultsTemplate;
        var discountText = healthResultsTemplate.getDiscountText(obj);
        var result = healthResultsTemplate.getPricePremium(obj._selectedFrequency, availablePremiums, obj.mode);
        var discountPercentage = healthResultsTemplate.getDiscountPercentage(obj.info.FundCode, result);

        if (!obj.hasOwnProperty('premium')) {return;}
        var prem = obj.premium[frequency];
        var textLhcFreePricing = 'The premium may be affected by LHC';
        if (prem.lhcfreepricing.indexOf('premium') === -1) { textLhcFreePricing = ''; }

        var classification = meerkat.modules.healthResultsTemplate.getClassification(obj);
        var isExtrasOnly = obj.info.ProductType === 'Ancillary' || obj.info.ProductType === 'GeneralHealth';
        var icon = isExtrasOnly ? 'small-height' : classification.icon;

        output.isDualPricingActive = isDualPricingActive;
        output.logoHtml = logoHtml;
        output.priceTemplate = priceTemplate;
        output.lhtText = lhtText;
        output.frequencyPremium = frequencyPremium;
        output.availablePremiums = availablePremiums;
        output.result = result;
        output.textLhcFreePricing = textLhcFreePricing;
        output.isExtrasOnly = isExtrasOnly;
        output.icon = icon;

        if (obj.hasOwnProperty('premium')) {
            if (obj.hasOwnProperty('priceBreakdown') && obj.priceBreakdown && window.meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment') {
                output.priceBreakDownTemplate = meerkat.modules.healthPriceBreakdown.renderTemplate(availablePremiums, result.frequency, true);
            }
        }

        output.dualPricingDate = validateAndGetDualPricingDate(obj);
        output.productSummaryClass = getProductSummaryClass(output.dualPricingDate, " hasDualPricing ");
        output.showAbdBadge = obj.custom.reform.yad !== "N" && frequencyPremium.abd > 0 && !obj.isForResultPage && !(isDualPricingActive && !_.isNull(output.dualPricingDate));

        return output;
    }

    function getDualPricingVarsForLogoPriceTemplateResultCard(obj, premium, altPremium) {
        var output = {};
        var comingSoonClass = getComingSoonClass(obj);
        var property = getProperty(obj, premium, altPremium);
        var showFromDate = getShowFromDate(property);

        output.dualPricingDate = validateAndGetDualPricingDate(obj);

        if(output.dualPricingDate) {
            output.dualPricingDateFormatted = meerkat.modules.dateUtils.dateValueShortFormat(output.dualPricingDate);
        }

        output.showFromDate = showFromDate;
        output.comingSoonClass = comingSoonClass;
        output.currentPriceOrFromApril = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? 'From April 1' : 'Current price';

         return output;
    }

    function getDualPricingVarsForLogoPriceTemplateResultCardForFrequency(obj, freq, property, mode) {
         var output = {};
         var premium = property[freq];
         var availablePremiums = getProperty(obj, obj.premium, obj.altPremium);
         var priceText = premium.text ? premium.text : formatCurrency(premium.payableAmount);
         var isPaymentPage = meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment'; 
         if(!isPaymentPage) { 
             priceText = premium.lhcfreetext; 
             }
         var formatCurrency = meerkat.modules.currencyField.formatCurrency;
         var priceLhcfreetext = premium.lhcfreetext ? premium.lhcfreetext : formatCurrency(premium.lhcFreeAmount);
         var textLhcFreeDualPricing = 'inc ' + formatCurrency(premium.rebateValue) + ' Govt Rebate'; 
         var textPricing = premium.pricing ? premium.pricing : 'Includes rebate of ' + formatCurrency(premium.rebateAmount) + ' & LHC loading of ' + formatCurrency(premium.lhcAmount);
         var showABDToolTip = premium.abd > 0; 
         var lhtText = getLhcText(premium);
         var textLhcFreePricing = premium.lhcfreepricing ? premium.lhcfreepricing : '+ ' + formatCurrency(premium.lhcAmount) + ' LHC inc ' + formatCurrency(premium.rebateAmount) + ' Government Rebate';
         var showPriceOrComingSoon = (premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0);
         if(showPriceOrComingSoon) {
             var premiumSplit = ((typeof mode === "undefined" || mode != "lhcInc" ? priceLhcfreetext : priceText)).split(".");
             output.premiumSplitDollars = premiumSplit[0].replace('$', '');
             output.premiumSplitCents = premiumSplit[1];
         }

        output.availablePremiums = availablePremiums;
        output.priceText = priceText;
        output.priceLhcfreetext = priceLhcfreetext;
        output.premium = premium;
        output.lhtText = lhtText;
        output.textLhcFreeDualPricing = textLhcFreeDualPricing;
        output.textLhcFreePricing = textLhcFreePricing;
        output.showPriceOrComingSoon = showPriceOrComingSoon;
        output.renderPriceBreakdown = !((!obj.hasOwnProperty('priceBreakdown') || (obj.hasOwnProperty('priceBreakdown') && !obj.priceBreakdown)) || window.meerkat.modules.journeyEngine.getCurrentStep().navigationId !=='payment' );

        return output;
    }
    
    function getDualPricingVarsForTemplateResultCard(obj) {
        var output = {};
        var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;
        if (!obj.hasOwnProperty('premium')) {return;}
        var isConfirmation = false;
        try{
            isConfirmation = _.isNumber(meerkat.modules.healthConfirmation.getPremium());
            } catch(err){ console.warn('Bad premium number', err); }
        var availablePremiums = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true ? obj.altPremium : obj.premium;
        var healthResultsTemplate = meerkat.modules.healthResultsTemplate;
        var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies();
        var discountText = healthResultsTemplate.getDiscountText(obj);

        output.isDualPricingActive = isDualPricingActive;
        output.availableFrequencies = availableFrequencies;
        output.availablePremiums = availablePremiums;
        output.healthResultsTemplate = healthResultsTemplate;
        output.dualPricingDate = validateAndGetDualPricingDate(obj);
        output.productSummaryClass = getProductSummaryClass(output.dualPricingDate, " ");
        
        return output;
    }

    function getDualPricingVarsForTemplateResultCardForFrequency(obj, freqObj, availablePremiums, healthResultsTemplate) {
        var output = {};
        var formatCurrency = meerkat.modules.currencyField.formatCurrency;
        var frequency = freqObj.key;
        if (typeof availablePremiums[frequency] === "undefined") { return; }
        var result = healthResultsTemplate.getPricePremium(frequency, availablePremiums, obj.mode);
        var discountPercentage = healthResultsTemplate.getDiscountPercentage(obj.info.FundCode, result);
        var property = getProperty(obj, obj.premium, obj.altPremium);
        var prem = obj.premium[frequency];
        var textLhcFreePricing = 'LHC loading may increase the premium.';
        if (prem.lhcfreepricing.indexOf('premium') === -1) { textLhcFreePricing = ''; }
        var textLhcFreeDualPricing= 'inc ' + formatCurrency(prem.rebateValue) + ' Govt Rebate';

        var comingSoonLabel = frequency;
        if (comingSoonLabel === 'annually') {
            comingSoonLabel = 'Annual';
        }
        // <%-- Convert to title case --%>
        comingSoonLabel = comingSoonLabel.replace(/(\b[a-z](?!\s))/g, function(x){ return x.toUpperCase(); });

        output.result = result;
        output.comingSoonLabel = comingSoonLabel;
        output.textLhcFreePricing = textLhcFreePricing;
        output.textLhcFreeDualPricing = textLhcFreeDualPricing;
        output.property = property;
        output.frequency = frequency;
        output.availablePremiums = availablePremiums;

        return output;
    }

    function getDualPricingVarsForSideBar(obj, premium, altPremium) {
        var output = {};
        var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;
        var isSinglePricingMode = typeof obj.displayLogo === 'undefined' || obj.displayLogo == true;
        var showAltPremium = obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true;
        var comingSoonClass = getComingSoonClass(obj);
        var property = premium;
        if (showAltPremium) {
            property = altPremium;
        }

        function showPriceAndFrequency(premium) {
            return ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0));
        }

        var formatCurrency = meerkat.modules.currencyField.formatCurrency;
        var isPaymentPageOrConfirmation = (meerkat.modules.journeyEngine.getCurrentStep() === null || meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment');
        var showRoundingMessage = typeof showRoundingText !== 'undefined' && showRoundingText === true;

        output.isDualPricingActive = isDualPricingActive;
        output.showAltPremium = showAltPremium;
        output.showPriceAndFrequency = showPriceAndFrequency;
        output.comingSoonClass = comingSoonClass;
        output.isSinglePricingMode = isSinglePricingMode;
        output.formatCurrency = formatCurrency;
        output.isPaymentPageOrConfirmation = isPaymentPageOrConfirmation;
        output.showRoundingMessage = showRoundingMessage;
        output.property = property;

        return output;
    }


    function getDualPricingVarsForSideBarForFreq(obj, freq, isPaymentOrConfirmationPage, property, showAltPremium) {
        var output = {};
        var premium = property[freq];
        var availablePremiums = showAltPremium ? obj.altPremium : obj.premium;
        var priceText = premium.text ? premium.text : meerkat.modules.currencyField.formatCurrency(premium.payableAmount);
        if(!isPaymentOrConfirmationPage) {
            priceText = premium.lhcfreetext;
        }
        var priceLhcfreetext = premium.lhcfreetext ? premium.lhcfreetext : meerkat.modules.currencyField.formatCurrency(premium.lhcFreeAmount);
        var textLhcFreeDualPricing = 'inc ' + meerkat.modules.currencyField.formatCurrency(premium.rebateValue) + ' Govt Rebate';
        var textPricing = premium.pricing ? premium.pricing : 'Includes rebate of ' + meerkat.modules.currencyField.formatCurrency(premium.rebateAmount) + ' & LHC loading of ' + meerkat.modules.currencyField.formatCurrency(premium.lhcAmount);
        var showABDToolTip = premium.abd > 0;
        var lhtText = getLhcText(premium);
        var textLhcFreePricing = premium.lhcfreepricing ? premium.lhcfreepricing : '+ ' + meerkat.modules.currencyField.formatCurrency(premium.lhcAmount) + ' LHC inc ' + meerkat.modules.currencyField.formatCurrency(premium.rebateAmount) + ' Government Rebate';

        output.premium = premium;
        output.availablePremiums = availablePremiums;
        output.priceText = priceText;
        output.priceLhcfreetext = priceLhcfreetext;
        output.textLhcFreeDualPricing = textLhcFreeDualPricing;
        output.textPricing = textPricing;
        output.showABDToolTip = showABDToolTip;
        output.lhtText = lhtText;
        output.textLhcFreePricing = textLhcFreePricing;

        return output;
    }

    function getPriceTemplateResultCardVarsSimples(obj) {
        var output = {};
        try{
            isConfirmation = _.isNumber(meerkat.modules.healthConfirmation.getPremium());
        } catch(e){}
        var isConfirmation = (!meerkat.site.isCallCentreUser || !isConfirmation) && _.has(meerkat.site,"alternatePricing") && meerkat.site.alternatePricing.isActive && _.has(obj,"altPremium") ? obj.altPremium : obj.premium;
        var healthResultsTemplate = meerkat.modules.healthResultsTemplate;
        var availableFrequencies = meerkat.modules.healthResults.getPaymentFrequencies();
        var discountText = healthResultsTemplate.getDiscountText(obj);

        output.isConfirmation = isConfirmation;
        output.healthResultsTemplate = healthResultsTemplate;
        output.availableFrequencies = availableFrequencies;
        output.discountText = discountText;
        output.dualPriceAvailable = meerkat.modules.healthDualPricing.isDualPricingActive() === true && validateAndGetDualPricingDate(obj);

        return output;
    }

    function getPriceTemplateResultCardVarsSimplesHeader(obj) {
        var output = {};
        output.isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive();
        output.dualPriceAvailable = meerkat.modules.healthDualPricing.isDualPricingActive() === true && validateAndGetDualPricingDate(obj);
        output.hasDualPricing = meerkat.modules.healthDualPricing.isDualPricingActive() === true ? " hasDualPricing " : " ";
        return output;
    }
// ===========================================================================================
    function getDualPricingTemplateVarsSimples(obj, premium, altPremium) {
        var output = {};
        var formatCurrency = meerkat.modules.currencyField.formatCurrency;
        var prem = obj.premium[obj._selectedFrequency];
        var textLhcFreePricing = prem.lhcfreepricing ? prem.lhcfreepricing : '+ ' + formatCurrency(prem.lhcAmount) + ' LHC inc ' + formatCurrency(prem.rebateAmount) + ' Government Rebate';
        var textPricing = prem.pricing ? prem.pricing : 'Includes HH rebate of ' + formatCurrency(prem.rebateAmount) + ' & LHC loading of ' + formatCurrency(prem.lhcAmount);
        var property = getProperty(obj, premium, altPremium);
        var showFromDate = getShowFromDate(property);

        output.formatCurrency = formatCurrency;
        output.prem = prem;
        output.textLhcFreePricing = textLhcFreePricing;
        output.textPricing = textPricing;
        output.property = property;
        output.showFromDate = showFromDate;
        output.dualPriceAvailable = isDualPriceAvailable(obj, showFromDate);
        output.dualPricingDate = validateAndGetDualPricingDate(obj);
        output.productSummaryClass = !output.dualPricingDate ? " doesntHaveDualPricing " : " ";

        if(output.dualPricingDate) {
            output.dualPricingDateFormatted = meerkat.modules.dateUtils.dateValueShortFormat(output.dualPricingDate);
        }
        output.background = output.showFromDate === true ? ' blue-background ' : ' grey-background ';
        output.showCurrentPriceWording = getResultType(obj) !== 'SINGLE_PRICE';
        return output;
    }

    function getLogoPriceTemplateResultCardVarsSimples(obj, premium, altPremium) {
        var output = {};

        var property = getProperty(obj, premium, altPremium);
        var showFromDate = getShowFromDate(property);

        output.property = property;
        output.showFromDate = showFromDate;
        output.dualPricingDate = validateAndGetDualPricingDate(obj);
        output.dualPriceAvailable = isDualPriceAvailable(obj, showFromDate);
        output.priceType = getResultType(obj);
        switch (output.priceType) {
            case 'SINGLE_PRICE': output.productSummaryClass = " doesntHaveDualPricingSimples "; break;
            case 'DUAL_PRICE_NOT_YET_RELEASED': output.productSummaryClass = " dual-price-released-simples "; break;
            case 'DUAL_PRICE': output.productSummaryClass = " dual-price-released-simples "; break;
            default: output.productSummaryClass = " ";
        }
        output.productSummaryClass2 = output.test;
        return output;
    }

    function getResultType(obj) {
        // the logic is described in SML-2331
        var dualPricingDate = validateAndGetDualPricingDate(obj);
        if(!dualPricingDate) return 'SINGLE_PRICE';
        var property = obj.altPremium[obj._selectedFrequency];
        if(!property) return null;
        var hasValidAltPremium = (
            (property.hasOwnProperty('value') && property.value > 0) ||
            (property.hasOwnProperty('text') && property.text.indexOf('$0.') < 0) ||
            (property.hasOwnProperty('payableAmount') && property.payableAmount > 0)
        );
        if (dualPricingDate && !hasValidAltPremium) return 'DUAL_PRICE_NOT_YET_RELEASED';
        if (dualPricingDate && hasValidAltPremium) return 'DUAL_PRICE';
        return null;
    }
// ========================================================================================================
    function getLogoPriceTemplateResultCardVarsSimplesForFreq(freq, priceVarsSimples) {
        var output = {};

        var formatCurrency = meerkat.modules.currencyField.formatCurrency;
        var textPricing;
        var textPricingLHC;
        var premium = priceVarsSimples.property[freq];
        var priceText = premium.text ? premium.text : formatCurrency(premium.payableAmount);
        var priceLhcfreetext = premium.lhcfreetext ? premium.lhcfreetext : formatCurrency(premium.lhcFreeAmount);
        var textLhcFreePricing = premium.lhcfreepricing ? premium.lhcfreepricing : '+ ' + formatCurrency(premium.lhcAmount) + ' LHC inc ' + formatCurrency(premium.rebateAmount) + ' Government Rebate';
        if (premium.pricing) {
            textPricing = premium.pricing.indexOf('&') > 0 ? premium.pricing.split('&')[0] + ' &' : premium.pricing;
            textPricingLHC = premium.pricing.indexOf('&') > 0 ? premium.pricing.split('&')[1] : '';
        } else {
            textPricing = 'Includes of ' + formatCurrency(premium.rebateAmount) + ' &';
            textPricingLHC = 'LHC loading of ' + formatCurrency(premium.lhcAmount);
        }

        output.premium = premium;
        output.priceText = priceText;
        output.priceLhcfreetext = priceLhcfreetext;
        output.textLhcFreePricing = textLhcFreePricing;
        output.textPricing = textPricing;
        output.textPricingLHC = textPricingLHC;

        return output;
    }

    function validateAndGetDualPricingDate(obj) {
        var result = null;
        if (obj.dualPricingDate) {
            var dualPricingDate = meerkat.modules.dateUtils.parse(obj.dualPricingDate, "YYYY-MM-DD");
            var coverStartDate = getCoverStartDate(obj);
            if (isDualPricingActive() && dualPricingDate && meerkat.modules.dateUtils.compareTwoDate(dualPricingDate, coverStartDate) > 0) {
                result = obj.dualPricingDate;
            }
        }
        return result;
    }

    function isApplicationOrPaymentPage() {
        return (meerkat.modules.journeyEngine.getCurrentStep() !== null
            && (meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'payment'
            || meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'apply'));
    }
    function isConfirmationPage() {
        return meerkat.modules.journeyEngine.getCurrentStep() === null;
    }

    function getCoverStartDate(obj) {
        var coverStartDate = new Date();
        if (isApplicationOrPaymentPage() && $("#health_payment_details_start").val() !== undefined && $("#health_payment_details_start").val() !== ''){
            coverStartDate = meerkat.modules.dateUtils.parse($("#health_payment_details_start").val(), 'DD/MM/YYYY');
        } else if (isConfirmationPage()) {
            if (typeof obj !== 'undefined') {
                coverStartDate = meerkat.modules.dateUtils.parse(obj.startDate, 'DD/MM/YYYY');
            } else {
                coverStartDate = null;
            }
        } else if (!isApplicationOrPaymentPage() && $("#health_searchDate").val() !== undefined && $("#health_searchDate").val() !== '') {
            coverStartDate = meerkat.modules.dateUtils.parse($("#health_searchDate").val(), 'DD/MM/YYYY');
        }
        return coverStartDate;
    }

    function getProperty(obj, premium, altPremium) {
        var property = premium;
        if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = altPremium; }
        return property;
    }

    function isDualPriceAvailable(obj, showFromDate) {
        return meerkat.modules.healthDualPricing.isDualPricingActive() === true && validateAndGetDualPricingDate(obj) && showFromDate;
    }

    function getShowFromDate(property) {
        var showFromDate = false;
        _.each(['annually','halfyearly','halfYearly','quarterly','monthly','fortnightly','weekly'], function(freq){
            if(typeof property[freq] !== "undefined") {
                var premium = property[freq];
                if ((premium.value && premium.value > 0) || (premium.text && premium.text.indexOf('$0.') < 0) || (premium.payableAmount && premium.payableAmount > 0)) {
                    showFromDate = true;
                }
            }
        });
        return showFromDate;
    }

    function getComingSoonClass(obj) {
        var comingSoonClass = '';
        if (obj.altPremium !== null && !_.isUndefined(obj.altPremium[obj._selectedFrequency])) {
            var productPremium = obj.altPremium[obj._selectedFrequency];
            comingSoonClass = ((productPremium.value && productPremium.value > 0) || (productPremium.text && productPremium.text.indexOf('$0.') < 0) || (productPremium.payableAmount && productPremium.payableAmount > 0)) ? '' : 'comingsoon';
        }
        return comingSoonClass;
    }

    function getFrequencyName(frequency, postfix) {
        if (!postfix) postfix = "";
        var result;
        switch (frequency.toLowerCase()) {
            case 'annually': result = 'annually' + postfix; break;
            case 'halfyearly': result = 'per half year' + postfix; break;
            case 'quarterly': result = 'per quarter' + postfix; break;
            case 'monthly': result = 'monthly' + postfix; break;
            case 'fortnightly': result = 'fortnightly' + postfix; break;
            case 'weekly': result = 'per week' + postfix; break;
            default: result = '';
        }
        return result;
    }
    
    function getLhcText(premium) {
        return premium.lhcfreepricing ? premium.lhcfreepricing.split("<br>")[0] : '';
    }
    
    function getProductSummaryClass(dualPricingDate, defaultClass) {
        if (!defaultClass) defaultClass = " ";
        var productSummaryClass = " ";
        if (meerkat.modules.healthDualPricing.isDualPricingActive() === true) {
            productSummaryClass = _.isNull(dualPricingDate) ? " doesntHaveDualPricing " : defaultClass;
        }
        return productSummaryClass;
    }

    function initAccordionsEvents() {
         _.defer(function() {
             if (meerkat.site.pageAction !== 'confirmation') {
                 meerkat.modules.Accordion.initClickEventBySelector('#applicationDetailsForm .row .fieldset-column-side .policySummary-sidebar #price-breakdown-accordion-single');
                 meerkat.modules.Accordion.initClickEventBySelector('#applicationDetailsForm .row .fieldset-column-side .policySummary-sidebar #price-breakdown-accordion-dual');
                 meerkat.modules.Accordion.initClickEventBySelector('#applicationDetailsForm .row .policySummary-sidebar #price-breakdown-accordion-mobile');
                 meerkat.modules.Accordion.initClickEventBySelector('#applicationDetailsForm .row .policySummary-sidebar #policy_details_accordion');
                 meerkat.modules.Accordion.initClickEventBySelector('#applicationDetailsForm .fieldset-column-side .dual-pricing-off-container .price-boxes-wrapper .current-pricing .price-breakdown-wrapper.hidden-xs #price-breakdown-accordion-single-price');
                 meerkat.modules.Accordion.initClickEventBySelectorForWrappedAccordions('#applicationDetailsForm .price-breakdown-accordions-wrapper #price-breakdown-accordion-single-combined');
                 meerkat.modules.Accordion.initClickEventBySelectorForWrappedAccordions('#applicationDetailsForm .price-breakdown-accordions-wrapper #price-breakdown-accordion-dual-combined');

                 meerkat.modules.Accordion.initClickEventBySelector('#paymentDetailsForm .row .fieldset-column-side .policySummary-sidebar #price-breakdown-accordion-single');
                 meerkat.modules.Accordion.initClickEventBySelector('#paymentDetailsForm .row .fieldset-column-side .policySummary-sidebar #price-breakdown-accordion-dual');
                 meerkat.modules.Accordion.initClickEventBySelector('#paymentDetailsForm .row .policySummary-sidebar #price-breakdown-accordion-mobile');
                 meerkat.modules.Accordion.initClickEventBySelector('#paymentDetailsForm .row .policySummary-sidebar #policy_details_accordion');
                 meerkat.modules.Accordion.initClickEventBySelector('#paymentDetailsForm #price-breakdown-accordion-single-price');
                 meerkat.modules.Accordion.initClickEventBySelectorForWrappedAccordions('#paymentDetailsForm .price-breakdown-accordions-wrapper #price-breakdown-accordion-single-combined');
                 meerkat.modules.Accordion.initClickEventBySelectorForWrappedAccordions('#paymentDetailsForm .price-breakdown-accordions-wrapper #price-breakdown-accordion-dual-combined');
             } else {
                 meerkat.modules.Accordion.initClickEventBySelector('#confirmationForm .row .fieldset-column-side .policySummary-sidebar #price-breakdown-accordion-single');
                 meerkat.modules.Accordion.initClickEventBySelector('#confirmationForm .row .fieldset-column-side .policySummary-sidebar #price-breakdown-accordion-dual');
                 meerkat.modules.Accordion.initClickEventBySelector('#confirmationForm .row .policySummary-sidebar #price-breakdown-accordion-mobile');
                 meerkat.modules.Accordion.initClickEventBySelector('#confirmationForm .row .policySummary-sidebar #policy_details_accordion');
                 //meerkat.modules.Accordion.initClickEventBySelector('#confirmationForm #price-breakdown-accordion-single-price');
                 meerkat.modules.Accordion.initClickEventBySelectorForWrappedAccordions('#confirmationForm .price-breakdown-accordions-wrapper #price-breakdown-accordion-single-combined');
                 meerkat.modules.Accordion.initClickEventBySelectorForWrappedAccordions('#confirmationForm .price-breakdown-accordions-wrapper #price-breakdown-accordion-dual-combined');
             }
         });
    }

    function initMoreInfoPriceTemplate(product) {
        if (meerkat.modules.healthDualPricing.validateAndGetDualPricingDate(product)) {
            product.renderedDualPricing = meerkat.modules.healthDualPricing.renderTemplate('', product, true, false);
            if (meerkat.modules.deviceMediaState.get() !== 'xs' ) {
                product.renderedAffixedHeaderDualPriceTemplate = meerkat.modules.healthDualPricing.renderTemplate('', product, true, false, null, true);
            }
        } else if (meerkat.modules.healthPyrrCampaign.isPyrrActive() === true) {
            product.renderedPyrrCampaign = meerkat.modules.healthPyrrCampaign.renderTemplate('', product, true, false);
        } else {
            product.showAltPremium = false;
            product.priceBreakdown = false;
            var logoTemplate = meerkat.modules.templateCache.getTemplate($("#logo-template"));
            var priceTemplate = meerkat.modules.templateCache.getTemplate($("#price-template"));
            product.renderedAffixedHeaderSinglePriceTemplate = logoTemplate(product) + priceTemplate(product);

            var priceTemplateMoreInfo = meerkat.modules.templateCache.getTemplate($("#price-template-more-info"));
            product.renderedMoreInfoSinglePriceTemplate = logoTemplate(product) + priceTemplateMoreInfo(product);
        }
    }

    meerkat.modules.register('healthDualPricing', {
        initDualPricing: initDualPricing,
        isDualPricingActive: isDualPricingActive,
        renderTemplate: renderTemplate,
        initAccordionsEvents: initAccordionsEvents,
        initMoreInfoPriceTemplate: initMoreInfoPriceTemplate,
        getDualPricingVarsForProductHeaderTemplate: getDualPricingVarsForProductHeaderTemplate,
        getDualPricingVarsForProductHeaderTemplateResultCard: getDualPricingVarsForProductHeaderTemplateResultCard,
        getDualPricingVarsForLogoPriceTemplateResultCard: getDualPricingVarsForLogoPriceTemplateResultCard,
        getDualPricingVarsForLogoPriceTemplateResultCardForFrequency: getDualPricingVarsForLogoPriceTemplateResultCardForFrequency,
        getFrequencyName: getFrequencyName,
        getDualPricingVarsForTemplateResultCard: getDualPricingVarsForTemplateResultCard,
        getDualPricingVarsForTemplateResultCardForFrequency: getDualPricingVarsForTemplateResultCardForFrequency,
        getDualPricingVarsForSideBar: getDualPricingVarsForSideBar,
        getDualPricingVarsForSideBarForFreq: getDualPricingVarsForSideBarForFreq,
        validateAndGetDualPricingDate: validateAndGetDualPricingDate,
        getPricetemplateResultCardVarsSimples: getPriceTemplateResultCardVarsSimples,
        getPriceTemplateResultCardVarsSimplesHeader: getPriceTemplateResultCardVarsSimplesHeader,
        getDualPricingTemplateVarsSimples: getDualPricingTemplateVarsSimples,
        getLogoPriceTemplateResultCardVarsSimples: getLogoPriceTemplateResultCardVarsSimples,
        getLogoPriceTemplateResultCardVarsSimplesForFreq: getLogoPriceTemplateResultCardVarsSimplesForFreq
    });

})(jQuery);
