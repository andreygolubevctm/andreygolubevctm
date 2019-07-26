;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    var basePostData = {
        cache: false,
        salesForce: true
    };

    function initSalesforceHealthToggleFields() {
        $(document).ready(function() {
            meerkat.modules.healthPaymentDate.initPaymentDate();
            meerkat.modules.healthPaymentIPP.initHealthPaymentIPP();

            basePostData.transactionId = meerkat.modules.transactionId.get();

            // Set dummy selected product
            meerkat.modules.healthResults.setSelectedProduct({
                info: {}
            });

            var fundCode = meerkat.site.provider.toUpperCase();
            if(typeof fundCode === 'string' && fundCode.length === 3) {
                getFundInfo(fundCode)
                    .then(function () {
                        window['healthFunds_' + fundCode].set();
                        $('button[data-gateway="launcher"]').trigger('click');
                    })
                    .catch(function() {
                        alert('Could not credit card form for fund');
                    });
            } else {
                alert('No fund code provided. Please reopen the credit card collection window');
            }
        });
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

    meerkat.modules.register('salesforceHealthToggleFields', {
        init: initSalesforceHealthToggleFields,
        events: events
    });
})(jQuery);