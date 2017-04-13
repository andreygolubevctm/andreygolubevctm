;(function ($, undefined) {

    var meerkat = window.meerkat,
    meerkatEvents = meerkat.modules.events,
    selectedProduct = {},
    $elements = {},
    isActive = null;

    function initPyrrCampaign(isSimples) {
        if (!isPyrrActive(isSimples)) {
            return false;
        }

        _setupElements();
        _applyEventListeners();
    }

    function isPyrrActive(isSimples) {
        if (isActive === null) {
            isActive = typeof meerkat.site.isPyrrActive !== 'undefined' && meerkat.site.isPyrrActive;
            var currentCoupon = meerkat.modules.coupon.getCurrentCoupon();
            // If this is simples, we ignore the fact that we don't have a valid pyrr coupon.
            if (currentCoupon !== false || typeof currentCoupon !== 'undefined' && isActive !== false) {
                if (currentCoupon.couponCode != 'pyrr' && isSimples !== true) {
                    isActive = false;
                }
            }
        }
        return isActive;
    }

    function _setupElements() {
        $elements = {
            logoPriceTemplate: $('#logo-price-template'),
            template: {
                results: {
                    default: $('#pyrr-campaign-results-template')
                },
                moreinfo: {
                    default: $('#pyrr-campaign-moreinfo-template'),
                    xs : $('#pyrr-campaign-moreinfo-xs-template')
                }
            },
            sideBarFrequency: $('.sidebarFrequency'),
            paymentDetailsSelection: $('#health_payment_details-selection'),
            paymentDetailsFrequency: $('#health_payment_details-selection').find('#health_payment_details_frequency'),
            frequencyWarning: $('#health_payment_details-selection').find('.frequencyWarning'),
            quoterefTemplate: $('#quoteref-template')
        };

        $elements.sideBarFrequency.hide();
    }

    function _applyEventListeners() {
        $(document).on('click', 'a.live-chat', function() {
            $('.LPMcontainer').trigger('click');
        });
    }

    function renderTemplate(target, product, returnTemplate, isForSidebar, page) {
        selectedProduct = product;

        if(!_.isObject(product)) {
            return "";
        }

        product._selectedFrequency = typeof product._selectedFrequency === 'undefined' ? Results.getFrequency() : product._selectedFrequency;
        product.mode = product.mode !== '' ? product.mode : '';

        if (meerkat.site.isCallCentreUser === true) {
            product.mode = "lhcInc";
        }

        product.showAltPremium = false;
        product.displayLogo = isForSidebar;
        product.showRoundingText = false;
        product.coupon = meerkat.modules.coupon.getCurrentCoupon();
        var htmlTemplate = _.template($elements.logoPriceTemplate.html());
        product.renderedPriceTemplate = htmlTemplate(product);

        htmlTemplate = _.template($elements.logoPriceTemplate.html());
        product.renderedAltPriceTemplate = htmlTemplate(product);
        $elements.mainPyrrTemplate = _getTemplate(isForSidebar, page);
        var pyrrTemplate = _.template($elements.mainPyrrTemplate.html());
        if (returnTemplate === true) {
            return pyrrTemplate(product);
        } else {
            $(target).html(pyrrTemplate(product));

            if (isForSidebar && $elements.quoterefTemplate.length > 0) {
                var quoterefTemplate = _.template($elements.quoterefTemplate.html());
                $(target).parent().find('.quoterefTemplateHolder').html(quoterefTemplate());
            }
        }

    }

    function _getTemplate(isForSidebar, page) {

        page  = page || 'moreinfo';
        var deviceMediaState = meerkat.modules.deviceMediaState.get();

        return $elements.template[page][deviceMediaState] || $elements.template[page]['default'];
    }

    meerkat.modules.register('healthPyrrCampaign', {
        initPyrrCampaign: initPyrrCampaign,
        isPyrrActive: isPyrrActive,
        renderTemplate: renderTemplate
    });

})(jQuery);