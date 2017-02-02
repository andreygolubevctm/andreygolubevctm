;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        selectedProduct = {},
        modalId = null;

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
            logoPriceTemplate: $('#logo-price-template'),
            template: {
                results: {
                    default: $('#dual-pricing-results-template')
                },
                moreinfo: {
                    default: $('#dual-pricing-moreinfo-template'),
                    xs : $('#dual-pricing-moreinfo-xs-template')
                }
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
        $elements.paymentDetailsFrequency.on('change', function updateWarningLabel(){
            if ($(this).val().toLowerCase() == 'annually') {
                $elements.frequencyWarning.slideUp().html("");
            } else {
                var template = _.template($elements.priceFrequencyTemplate.html()),
                    selectedProduct = Results.getSelectedProduct();
                $elements.frequencyWarning.html(template(selectedProduct)).removeClass("hidden").slideDown();
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
        product.displayLogo = false;
        product.showRoundingText = false;

        var htmlTemplate = _.template($elements.logoPriceTemplate.html());
        product.renderedPriceTemplate = htmlTemplate(product);

        product.showAltPremium = true;
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
        }
    }

    function _getTemplate(isForSidebar, page) {
        if (isForSidebar) {
            return $elements.template.default;
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