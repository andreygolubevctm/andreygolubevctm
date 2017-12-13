;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        selectedProduct = {},
        modalId = null,
        freqTextMapping = {
            'halfyearly': 'half yearly',
            'quarterly': 'quarterly',
            'monthly': 'monthly',
            'fortnightly': 'fortnightly',
            'weekly': 'weekly'
        },
        isActive = null;

    function initDualPricing() {
        if (!isDualPricingActive()) {
            return false;
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
                    template = _.template($elements.priceFrequencyTemplate.html()),
                    pricingDate = new Date(selectedProduct.pricingDate),
                    obj = {
                        frequency: freqTextMapping[frequency],
                        pricingDateFormatted: meerkat.modules.dateUtils.format(pricingDate, "Do MMMM")
                    };

                $elements.frequencyWarning.html(template(obj)).removeClass("hidden").slideDown();
            }
        });

        $(document).on('click', '.dual-pricing-learn-more', function(e) {
            _showModal($(e.target).attr('data-dropDeadDate'));
        });

        $(document).on('click', 'a.live-chat', function() {
            $('.LPMcontainer').trigger('click');
        });

        $(document).on('change', 'input[name=health_dual_pricing_frequency]', function() {
            $('.dual-pricing-update-frequency-btn').toggleClass('dual-pricing-frequency-updated', $(this).val() !== $('#health_filter_frequency').val());
        });

        $(document).on('click', '.dual-pricing-update-frequency-btn', function() {
            if ($(this).hasClass('dual-pricing-frequency-updated')) {
                var newFrequency = $('input[name=health_dual_pricing_frequency]').filter(':checked').val();
                $('input[name=health_filterBar_frequency]').filter('[value='+newFrequency+']').trigger('click');
            }

            _hideModal();
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
            _hideModal();
        });
    }

    function _showModal(dropDeadDate) {
        var template = _.template($elements.modalTemplate.html()),
            hiddenFreqVal = $('#health_filter_frequency').val(),
            ddd = new Date(dropDeadDate),
            dddDay = meerkat.modules.dateUtils.format(ddd, "D"),
            dddSuffix = meerkat.modules.dateUtils.format(ddd, "Do").replace(dddDay, '');

        modalId = meerkat.modules.dialogs.show({
            className: 'dual-pricing-modal',
            htmlContent: template({
                dddMonth: meerkat.modules.dateUtils.format(ddd, "MMMM"),
                dddDay: dddDay,
                dddSuffix: dddSuffix,
                frequency: [
                    {
                        value: 'F',
                        label: 'Fortnightly',
                        selected: hiddenFreqVal === 'F'
                    },
                    {
                        value: 'M',
                        label: 'Monthly',
                        selected: hiddenFreqVal === 'M'
                    },
                    {
                        value: 'A',
                        label: 'Annually',
                        selected: hiddenFreqVal === 'A'
                    }
                ]
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

    function _updatePricingDate() {
        var product = Results.getSelectedProduct(),
            pricingDate = new Date(product.pricingDate);

        $('.pricingDate').text(meerkat.modules.dateUtils.format(pricingDate, "Do MMMM"));
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
        product.showRisingTag = isForSidebar;
        product.showBeforeAfterText = isForSidebar;

        var pricingDate = new Date(selectedProduct.pricingDate);
        // named pricingDateFormatted because inside _updatePricingDate function it throws an invalid date when creating a new Date object with pricingDate,
        // for some reason Results.getSelectedProduct().pricingDate gets updated
        product.pricingDateFormatted = meerkat.modules.dateUtils.format(pricingDate, "MMMM Do, YYYY");

        var htmlTemplate = _.template($elements.logoPriceTemplate.html());
        product.renderedPriceTemplate = htmlTemplate(product);

        product.showAltPremium = true;
        product.displayLogo = false;
        product.showRisingTag = false;
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
        isDualPricingActive: isDualPricingActive,
        renderTemplate: renderTemplate
    });

})(jQuery);