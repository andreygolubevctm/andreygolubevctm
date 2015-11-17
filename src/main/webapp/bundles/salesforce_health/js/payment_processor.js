;
(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    var basePostData = {
        cache: false,
        salesForce: true
    };

    function initSalesforceHealthPaymentProcessor() {
        $(document).ready(function() {
            meerkat.modules.healthPaymentIPP.initHealthPaymentIPP();

            basePostData.transactionId = meerkat.modules.transactionId.get();

            // Set dummy selected product
            meerkat.modules.healthResults.setSelectedProduct({
                info: {}
            });

            var fundCode = meerkat.site.provider;
            getFundInfo(fundCode).then(function () {
                window['healthFunds_' + fundCode].set();

                var $launcherButton = $('button[data-gateway="launcher"]');
                if(meerkat.site.provider !== 'BUP')
                    $launcherButton.trigger('click');
                else
                    $launcherButton.hide();

                hideFields();
            });
        });
    }

    function hideFields() {
        var provider = meerkat.site.provider;

        if(provider === 'BUP') {
            var hideableFields = ['health_payment_credit_number', 'health_payment_credit_ccv', 'health_payment_credit_day', 'health_payment_credit_paymentDay', 'health_payment_credit_policyDay'];

            for(var i = 0; i < hideableFields.length; i++) {
                $('#' + hideableFields[i]).closest('.form-group').hide();
            }
        } else if(typeof $._data($('[data-provide="paymentGateway"]')[0], 'events') !== "undefined") {
            // Hiding fields here because using "div[class*="health_credit-card"]:not(.provider-BUP div)" in the CSS randomly doesn't work for some providers
            $('div[class*="health_credit-card"]').hide();
        } else {
            $('[data-gateway="launcher"]').hide();
        }
    }

    function getFundInfo(fund) {
        var data = basePostData;

        return meerkat.modules.comms.get({
            errorLevel: 'silent',
            url: '/' + meerkat.site.urls.context + 'common/js/health/healthFunds_' + fund + '.jsp',
            dataType: 'script',
            data: data
        });
    }

    meerkat.modules.register('salesforce_health_payment_processor', {
        init: initSalesforceHealthPaymentProcessor,
        events: events
    });
})(jQuery);