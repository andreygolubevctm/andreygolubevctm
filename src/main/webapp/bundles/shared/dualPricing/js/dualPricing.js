;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        selectedProduct = {},
        modalId = null,
        freqTextMapping = {
            'halfyealy': 'per half year',
            'quarterly': 'per quarter',
            'monthly': 'per month',
            'fortnightly': 'per fortnight',
            'weekly': 'per week'
        };

    function initDualPricing() {
        if (meerkat.site.healthAlternatePricingActive !== true) {
            return false;
        }

        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();
    }

    function _setupElements() {
        $elements = {
            logoPriceTemplate: meerkat.modules.templateCache.getTemplate($("#logo-price-template")),
            template: {
                default: $('#dual-pricing-template'),
                xs: $('#dual-pricing-template-xs'),
                sm: $('#dual-pricing-template-sm')
            },
            displayedFrequency: $('#health_payment_details_frequency'),
            modalTemplate: $('#dual-pricing-modal-template'),
            sideBarFrequency: $('.sidebarFrequency'),
            sideBarFrequencyTemplate: $('#sideBarFrequency'),
            paymentDetailsSelection: $('#health_payment_details-selection'),
            paymentDetailsFrequency: $('#health_payment_details-selection').find('#health_payment_details_frequency'),
            priceFrequencyTemplate: $('#price-frequency-template'),
            frequencyWarning: $('#health_payment_details-selection').find('.frequencyWarning')
        };

        $elements.sideBarFrequency.hide();
    }

    function _applyEventListeners() {
        $elements.paymentDetailsFrequency.on('change', function updateWarningLabel() {
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

        $elements.displayedFrequency.on('change', function updatePaymentSidebar() {
            var $this = $(this),
                obj = {},
                selectedProduct = Results.getSelectedProduct(),
                now = new Date();

            if ($this.val() !== '' && now.getTime() < selectedProduct.dropDeadDate.getTime()) {
                obj.dropDeadDateFormatted = selectedProduct.dropDeadDateFormatted;
                obj.frequency = $this.val();
                obj.firstPremium = (selectedProduct.mode === '' ? selectedProduct.premium[obj.frequency].lhcfreetext : selectedProduct.premium[obj.frequency].text) + " " + (selectedProduct.mode === '' ? selectedProduct.premium[obj.frequency].lhcfreepricing : selectedProduct.premium[obj.frequency].pricing);

                if (obj.frequency !== 'annually') {
                    if ((selectedProduct.premium[obj.frequency].value && selectedProduct.premium[obj.frequency].value > 0) || (selectedProduct.premium[obj.frequency].text && selectedProduct.premium[obj.frequency].text.indexOf('$0.') < 0) || (selectedProduct.premium[obj.frequency].payableAmount && selectedProduct.premium[obj.frequency].payableAmount > 0)) {
                        obj.remainingPremium = (selectedProduct.mode === '' ? selectedProduct.altPremium[obj.frequency].lhcfreetext : selectedProduct.altPremium[obj.frequency].text) + " " + (selectedProduct.mode === '' ? selectedProduct.altPremium[obj.frequency].lhcfreepricing : selectedProduct.altPremium[obj.frequency].pricing);
                    } else {
                        obj.remainingPremium = 'Coming Soon';
                    }
                }

                // render the template
                var htmlTemplate = _.template($elements.sideBarFrequencyTemplate.html()),
                    htmlString = htmlTemplate(obj);
                $elements.sideBarFrequency.html(htmlString).show();
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

    function renderTemplate(target, product, returnTemplate, isForSidebar) {
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
        product.showAltPremium = false;
        product.displayLogo = false;
        product.showRoundingText = false;

        var htmlTemplate = $elements.logoPriceTemplate;
        product.renderedPriceTemplate = htmlTemplate(product);

        product.showAltPremium = true;
        htmlTemplate = $elements.logoPriceTemplate;
        product.renderedAltPriceTemplate = htmlTemplate(product);
        product.dropDeadDate = meerkat.modules.dropDeadDate.getDropDeadDate(product);
        product.dropDatePassed = meerkat.modules.dropDeadDate.getDropDatePassed(product);
        $elements.mainDualPricingTemplate = _getTemplate(isForSidebar);

        var dualPriceTemplate = _.template($elements.mainDualPricingTemplate.html());

        if (returnTemplate === true) {
            return dualPriceTemplate(product);
        } else {
            $(target).html(dualPriceTemplate(product));
        }
    }

    function _getTemplate(isForSidebar) {
        if (isForSidebar) {
            return $elements.template.default;
        }

        var deviceMediaState = meerkat.modules.deviceMediaState.get();

        return $elements.template[_.indexOf(['xs', 'sm'], deviceMediaState) > -1 ? deviceMediaState : 'default'];
    }

    meerkat.modules.register('dualPricing', {
        initDualPricing: initDualPricing,
        renderTemplate: renderTemplate
    });

})(jQuery);