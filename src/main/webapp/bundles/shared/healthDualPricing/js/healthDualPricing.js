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
        _startMonthFirst = null;

    function initDualPricing() {
        if (!isDualPricingActive()) {
            return true;
        }

        _startMonthFirst = getStartMonthFirst('01/04/');

        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();
    }

	function getStartMonthFirst(datePrefix) {
		var now = new Date();
		var rateRiseDate = meerkat.modules.dateUtils.parse(datePrefix + now.getFullYear(), 'DD/MM/YYYY');
		var utc = now.getTime() + (now.getTimezoneOffset() * 60000);
		now = new Date(utc + (3600000*10));
		rateRiseDate.setFullYear(now.getFullYear() + (now > rateRiseDate ? 1 : 0));
		return rateRiseDate;
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
        	var coverStartDateTime = meerkat.modules.dateUtils.parse($("#health_payment_details_start").val(), 'DD/MM/YYYY').getTime(),
                startMonthFirstTime = _startMonthFirst.getTime(),
                frequency = $(this).val().toLowerCase(),
                selectedProduct = meerkat.modules.healthResults.getSelectedProduct(),
                selectedPayment = meerkat.modules.healthPaymentStep.getPaymentMethodNode(),
                pricingDate = new Date(selectedProduct.pricingDate),
                pricingDateFormatted = meerkat.modules.dateUtils.format(pricingDate, "Do MMMM"),
                template = null,
                obj = null;

            if (_.isEmpty($(this).val())) return;

            $elements.frequencyWarning.text('If you elect to pay your premium ${frequency}, only payments made by ${pricingDateFormatted} will be at the current amount, thereafter the new premium will apply.');

            // hide if cover start date after or on 1st of start month or altPremium price is $0 on online journey
            if (coverStartDateTime >= startMonthFirstTime || (!meerkat.site.isCallCentreUser && selectedProduct.altPremium[frequency].value === 0)) {
                $elements.frequencyWarning.slideUp();
                return;
            }

            if (frequency === 'annually') {
                if ($elements.priceCongratsTemplate.length === 1) {
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
                    altPremium: selectedProduct.paymentTypeAltPremiums[selectedPayment][frequency].text
                };
            }
            $elements.frequencyWarning.html(template(obj)).removeClass("hidden").slideDown();
        });

        $(document).on('click', '.price-rise-banner-learn-more', function(e) {
            _showBannerModal();
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

        if (!isNaN(dropDeadDate.getTime()) && !isNaN(pricingDate.getTime())) {
            $('.pricingDateText').text(meerkat.modules.dateUtils.format(pricingDate, "Do MMMM"));
            $('.dropDeadDateText').text(meerkat.modules.dateUtils.format(dropDeadDate, "Do MMMM"));
        }
    }

    function renderTemplate(target, product, returnTemplate, isForSidebar, page, isForAffixedHeader, isForResultPage) {
        var deviceMediaState = meerkat.modules.deviceMediaState.get();

        selectedProduct = product;

        if(!_.isObject(product)) {
            return "";
        }

        product.priceBreakdownLHCCopy = '';
        product.isForResultPage = isForResultPage;

        if ($elements.priceBreakdownLHCCopyTemplate.length && meerkat.modules.healthPriceBreakdown.showBreakdown()) {
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
        product.showBeforeAfterText = (isForSidebar) || isForAffixedHeader;
        product.priceBreakdown = meerkat.modules.healthPriceBreakdown.showBreakdown();

        var pricingDate = new Date(selectedProduct.pricingDate);
        // named pricingDateFormatted because inside _updatePricingDate function it throws an invalid date when creating a new Date object with pricingDate,
        // for some reason Results.getSelectedProduct().pricingDate gets updated
        product.pricingDateFormatted = meerkat.modules.dateUtils.format(pricingDate, "MMMM Do, YYYY");

        var htmlTemplate = _.template($elements.logoPriceTemplate.html());
        var htmlTemplateResultCard = _.template($elements.logoPriceTemplateResultCard.html());
        var htmlTemplateMoreInfo = meerkat.modules.templateCache.getTemplate($("#price-template-more-info"));

        var affixedHeaderTemplate = '';
        product.renderedPriceTemplate = htmlTemplate(product);
        product.renderedPriceTemplateResultCard = htmlTemplateResultCard(product);
        product.renderedMoreInfoDualPricing = htmlTemplateMoreInfo(product);

        var htmlTemplateSideBar = !meerkat.site.isCallCentreUser ? _.template($elements.logoPriceTemplateSideBar.html()) : undefined;
        product.renderedPriceTemplateSideBar = !htmlTemplateSideBar ? undefined : htmlTemplateSideBar(product);

        if($elements.affixedHeaderLogoPriceTemplate.html()) {
            affixedHeaderTemplate = _.template($elements.affixedHeaderLogoPriceTemplate.html());
            product.renderedAffixedHeaderPriceTemplate = affixedHeaderTemplate(product);
        }

        product.showAltPremium = _.has(product, 'altPremium');
        product.displayLogo = false;
        product.showCurrPremText = false;
        product.showRisingTag = false;

        htmlTemplate = _.template($elements.logoPriceTemplate.html());

        if($elements.affixedHeaderLogoPriceTemplate.html()) {
            product.renderedAltAffixedHeaderPriceTemplate = affixedHeaderTemplate(product);
        }

        htmlTemplateResultCard =  _.template($elements.logoPriceTemplateResultCard.html());
        product.renderedAltPriceTemplateResultCard = htmlTemplateResultCard(product);
        product.renderedAltMoreInfoDualPricing = htmlTemplateMoreInfo(product);

        htmlTemplateSideBar = !meerkat.site.isCallCentreUser ? _.template($elements.logoPriceTemplateSideBar.html()) : undefined;
        product.renderedAltPriceTemplateSideBar = !htmlTemplateSideBar ? undefined : htmlTemplateSideBar(product);

        product.renderedAltPriceTemplate = htmlTemplate(product);
        product.dropDeadDate = meerkat.modules.dropDeadDate.getDropDeadDate(product);
        product.dropDatePassed = meerkat.modules.dropDeadDate.getDropDatePassed(product);
        $elements.mainDualPricingTemplate = _getTemplate(isForSidebar, isForAffixedHeader, page);

        var dualPriceTemplate = _.template($elements.mainDualPricingTemplate.html());

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

    function initAccordionsEvents() {
         _.defer(function() {
             meerkat.modules.Accordion.initClickEventBySelector('#applicationDetailsForm .row .fieldset-column-side .policySummary-sidebar #price-breakdown-accordion-single'); 
             meerkat.modules.Accordion.initClickEventBySelector('#applicationDetailsForm .row .fieldset-column-side .policySummary-sidebar #price-breakdown-accordion-dual'); 
             meerkat.modules.Accordion.initClickEventBySelector('#applicationDetailsForm .row .policySummary-sidebar #price-breakdown-accordion-mobile'); 

             meerkat.modules.Accordion.initClickEventBySelector('#applicationDetailsForm .row .policySummary-sidebar #policy_details_accordion'); 

             meerkat.modules.Accordion.initClickEventBySelector('#paymentDetailsForm .row .fieldset-column-side .policySummary-sidebar #price-breakdown-accordion-single'); 
             meerkat.modules.Accordion.initClickEventBySelector('#paymentDetailsForm .row .fieldset-column-side .policySummary-sidebar #price-breakdown-accordion-dual'); 
             meerkat.modules.Accordion.initClickEventBySelector('#paymentDetailsForm .row .policySummary-sidebar #price-breakdown-accordion-mobile'); 
             meerkat.modules.Accordion.initClickEventBySelector('#paymentDetailsForm .row .policySummary-sidebar #policy_details_accordion'); 

             meerkat.modules.Accordion.initClickEventBySelector('#applicationDetailsForm .fieldset-column-side .dual-pricing-off-container .price-boxes-wrapper .current-pricing .price-breakdown-wrapper.hidden-xs #price-breakdown-accordion-single-price'); 
             meerkat.modules.Accordion.initClickEventBySelector('#paymentDetailsForm #price-breakdown-accordion-single-price'); 

             meerkat.modules.Accordion.initClickEventBySelectorForWrappedAccordions('#applicationDetailsForm .price-breakdown-accordions-wrapper #price-breakdown-accordion-single-combined'); 
             meerkat.modules.Accordion.initClickEventBySelectorForWrappedAccordions('#applicationDetailsForm .price-breakdown-accordions-wrapper #price-breakdown-accordion-dual-combined'); 
             meerkat.modules.Accordion.initClickEventBySelectorForWrappedAccordions('#paymentDetailsForm .price-breakdown-accordions-wrapper #price-breakdown-accordion-single-combined'); 
             meerkat.modules.Accordion.initClickEventBySelectorForWrappedAccordions('#paymentDetailsForm .price-breakdown-accordions-wrapper #price-breakdown-accordion-dual-combined'); 
             });
    }

    meerkat.modules.register('healthDualPricing', {
        initDualPricing: initDualPricing,
        isDualPricingActive: isDualPricingActive,
        renderTemplate: renderTemplate,
        initAccordionsEvents: initAccordionsEvents
    });

})(jQuery);
