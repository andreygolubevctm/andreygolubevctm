;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        selectedProduct = {},
        modalId = null,
        freqTextMapping = {
            'annually': 'per annum',
            'halfyealy': 'per half year',
            'quarterly': 'per quarter',
            'monthly': 'per month',
            'fortnightly': 'per fortnight',
            'weekly': 'per week'
        };

    function initDualPricing() {
        if (meerkat.site.isDualPricingActive !== true) {
            return false;
        }

        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();
    }

    function _setupElements() {
        $elements = {
            logoPriceTemplate: $('#logo-price-template'),
            template: {
                results: {
                    default: $('#dual-pricing-results-template')
                },
                moreinfo: {
                    default: $('#dual-pricing-moreinfo-template'),
                    xs : $('#dual-pricing-moreinfo-xs-template')
                },
                sidebar: $('#dual-pricing-template-sidebar')
            },
            modalTemplate: $('#dual-pricing-modal-template'),
            sideBarFrequency: $('.sidebarFrequency'),
            sideBarFrequencyTemplate: $('#sideBarFrequency'),
            paymentDetailsSelection: $('#health_payment_details-selection'),
            paymentDetailsFrequency: $('#health_payment_details-selection').find('#health_payment_details_frequency'),
            priceFrequencyTemplate: $('#price-frequency-template'),
            frequencyWarning: $('#health_payment_details-selection').find('.frequencyWarning'),
            quoterefTemplate: $('#quoteref-template')
        };

        $elements.sideBarFrequency.hide();
    }

    function _applyEventListeners() {
        $elements.paymentDetailsFrequency.on('change.healthDualPricing', function updateWarningLabel() {
            if (_.isEmpty($(this).val())) return;

            var frequency = $(this).val().toLowerCase();

            if (frequency === 'annually') {
                $elements.frequencyWarning.slideUp().html("");
            } else {
                var selectedProduct = Results.getSelectedProduct(),
                    remainingPremium = selectedProduct.altPremium[frequency];

                if ((remainingPremium.value && remainingPremium.value > 0) || (remainingPremium.text && remainingPremium.text.indexOf('$0.') < 0) || (remainingPremium.payableAmount && remainingPremium.payableAmount > 0)) {
                    var template = _.template($elements.priceFrequencyTemplate.html()),
                        obj = {
                            frequency: freqTextMapping[frequency],
                            firstPremium: selectedProduct.premium[frequency].text,
                            remainingPremium: remainingPremium.text
                        };

                    $elements.frequencyWarning.html(template(obj)).removeClass("hidden").slideDown();
                }
            }
        });

        $(document).on('click', '.dual-pricing-learn-more', function() {
            _showModal();
        });

        $(document).on('click', 'a.live-chat', function() {
            $('.LPMcontainer').trigger('click');
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_CHANGED, function hideSidebarFrequency(){
            $elements.sideBarFrequency.hide();
            $elements.frequencyWarning.hide();
        });

        meerkat.messaging.subscribe(meerkatEvents.device.DEVICE_MEDIA_STATE_CHANGE, function editDetailsEnterXsState() {
            _hideModal();
        });
    }

    function _showModal() {
        var template = _.template($elements.modalTemplate.html()),
            product = Results.getSelectedProduct();

        modalId = meerkat.modules.dialogs.show({
            className: 'dual-pricing-modal',
            htmlContent: template({
                dropDeadDate: meerkat.modules.dateUtils.format(product.dropDeadDate, "MMMM Do")
            }),
            onOpen : function() {
                $('a.live-chat').toggleClass('hidden', $('.LPMcontainer').length === 0);
            }
        });

        return modalId;
    }

    function _hideModal() {
        if (modalId !== null) {
            $('#' + modalId).modal('hide');
        }
    }

    function renderTemplate(target, product, returnTemplate, isForSidebar, page) {

        selectedProduct = product;

        if(!_.isObject(product)) {
            return "";
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
        }

        product.showAltPremium = false;
        product.displayLogo = isForSidebar;
        product.showRoundingText = false;

        var htmlTemplate = _.template($elements.logoPriceTemplate.html());
        product.renderedPriceTemplate = htmlTemplate(product);

        product.showAltPremium = true;
        product.displayLogo = false;
        htmlTemplate = _.template($elements.logoPriceTemplate.html());
        product.renderedAltPriceTemplate = htmlTemplate(product);
        product.dropDeadDate = meerkat.modules.dropDeadDate.getDropDeadDate(product);
        product.dropDatePassed = meerkat.modules.dropDeadDate.getDropDatePassed(product);
        $elements.mainDualPricingTemplate = _getTemplate(isForSidebar, page);

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

    function _getTemplate(isForSidebar, page) {
        if (isForSidebar) {
            return $elements.template.sidebar;
        }

        page  = page || 'moreinfo';

        var deviceMediaState = meerkat.modules.deviceMediaState.get();

        return $elements.template[page][deviceMediaState] || $elements.template[page]['default'];
    }

    meerkat.modules.register('healthDualPricing', {
        initDualPricing: initDualPricing,
        renderTemplate: renderTemplate
    });

})(jQuery);