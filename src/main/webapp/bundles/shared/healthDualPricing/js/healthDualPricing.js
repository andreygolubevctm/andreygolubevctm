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
        freqValuesMapping = {
            'F': 'fortnightly',
            'M': 'monthly',
            'A': 'annual'
        },
        isActive = null,
        _aprilFirst = '04/01/2019',
        _trackModalClose = true;

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
            modalTemplate: $('#dual-pricing-modal-template'),
            sideBarFrequency: $('.sidebarFrequency'),
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
    }

    function _applyEventListeners() {
        $elements.paymentDetailsFrequency.on('change.healthDualPricing', function updateWarningLabel() {
            var coverStartDateTime = meerkat.modules.dateUtils.parse($("#health_payment_details_start").val(), 'DD/MM/YYYY').getTime(),
                aprilFirstTime = new Date(_aprilFirst).getTime(),
                frequency = $(this).val().toLowerCase(),
                selectedProduct = Results.getSelectedProduct(),
                pricingDate = new Date(selectedProduct.pricingDate),
                pricingDateFormatted = meerkat.modules.dateUtils.format(pricingDate, "Do MMMM"),
                template = null,
                obj = null;

            if (_.isEmpty($(this).val())) return;

            // hide if cover start date after or on April 1st or altPremium price is $0 on online journey
            if (coverStartDateTime >= aprilFirstTime || (!meerkat.site.isCallCentreUser && selectedProduct.altPremium[frequency].value === 0)) {
                $elements.frequencyWarning.slideUp();
                return;
            }

            if (frequency !== 'annually') {
                template = _.template($elements.priceFrequencyTemplate.html());
                obj = {
                    frequency: freqTextMapping[frequency],
                    pricingDateFormatted: pricingDateFormatted,
                    premium: selectedProduct.premium[frequency].text,
                    altPremium: selectedProduct.altPremium[frequency].text
                };
    
                $elements.frequencyWarning.html(template(obj)).removeClass("hidden").slideDown();
            }else{
                $elements.frequencyWarning.slideUp().html("");
            }

            // if (frequency === 'annually') {
            //     if ($elements.priceCongratsTemplate.length === 1) {
            //         template = _.template($elements.priceCongratsTemplate.html());
            //         obj = {
            //             priceSaved: '$' + (parseFloat(selectedProduct.altPremium[frequency].value - selectedProduct.premium[frequency].value)).toFixed(2),
            //             pricingDateFormatted: pricingDateFormatted
            //         };
            //     } else {
            //         $elements.frequencyWarning.slideUp().html("");
            //         return;
            //     }
            // } else {
            //     template = _.template($elements.priceFrequencyTemplate.html());
            //     obj = {
            //         frequency: freqTextMapping[frequency],
            //         pricingDateFormatted: pricingDateFormatted,
            //         premium: selectedProduct.premium[frequency].text,
            //         altPremium: selectedProduct.altPremium[frequency].text
            //     };
            // }
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
            var $filterBarFrequency = $('input[name=health_filterBar_frequency]'),
                currFrequency = $filterBarFrequency.filter(':checked').val(),
                newFrequency = currFrequency;

            if ($(this).hasClass('dual-pricing-frequency-updated')) {
                newFrequency = $('input[name=health_dual_pricing_frequency]').filter(':checked').val();

                $filterBarFrequency.filter('[value='+newFrequency+']').trigger('click');
                $('.current-frequency').text(freqValuesMapping[newFrequency]);
            }

            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackRateRise',
                object: {
                    category: 'Health Rate Rise Modal',
                    action: 'Learn More Engaged',
                    label: freqValuesMapping[currFrequency] + ':' + freqValuesMapping[newFrequency]
                }
            });

            _trackModalClose = false;
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

        _trackModalClose = true;

        modalId = meerkat.modules.dialogs.show({
            className: 'dual-pricing-modal',
            htmlContent: template({
                dropDeadDate: meerkat.modules.dateUtils.format(ddd, "Do MMMM"),
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

        return modalId;
    }

    function _hideModal() {
        if (modalId !== null) {
            meerkat.modules.dialogs.close(modalId);
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

    function renderTemplate(target, product, returnTemplate, isForSidebar, page, isForAffixedHeader) {
        var deviceMediaState = meerkat.modules.deviceMediaState.get();

        selectedProduct = product;

        if(!_.isObject(product)) {
            return "";
        }

        product.priceBreakdownLHCCopy = '';
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
        var affixedHeaderTemplate = '';
        product.renderedPriceTemplate = htmlTemplate(product);
        if($elements.affixedHeaderLogoPriceTemplate.html()) {
            affixedHeaderTemplate = _.template($elements.affixedHeaderLogoPriceTemplate.html());
            product.renderedAffixedHeaderPriceTemplate = affixedHeaderTemplate(product);
            product.renderedAltAffixedHeaderPriceTemplate = affixedHeaderTemplate(product);
        }
        
        product.showAltPremium = _.has(product, 'altPremium');
        product.displayLogo = false;
        product.showCurrPremText = false;
        product.showRisingTag = false;

        htmlTemplate = _.template($elements.logoPriceTemplate.html());

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
            return deviceMediaState !== 'xs' ? $elements.template.sidebar : $elements.template.applicationXS;
        }

        page = page || 'moreinfo';

        return $elements.template[page][deviceMediaState] || $elements.template[page]['default'];
    }

    meerkat.modules.register('healthDualPricing', {
        initDualPricing: initDualPricing,
        isDualPricingActive: isDualPricingActive,
        renderTemplate: renderTemplate
    });

})(jQuery);
