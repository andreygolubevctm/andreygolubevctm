;
(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    var basePostData = {
        cache: false,
        salesForce: true,
        transactionId: meerkat.modules.transactionId.get()
    };

    var selectedProduct = {};

    function initSalesforceHealthPaymentProcessor() {
        $(document).ready(function() {
            basePostData.transactionId = meerkat.modules.transactionId.get();

            getProductInfo().then(function (productResponse) {
                selectedProduct = productResponse.results.price;
                var fundCode = selectedProduct.info.FundCode;

                meerkat.modules.healthResults.setSelectedProduct(selectedProduct);

                getFundInfo(fundCode).then(function () {
                    window['healthFunds_' + fundCode].set();

                    $('.btn-open-modal').trigger('click');
                });
            });
        });
    }

    function getProductInfo() {
        var data = basePostData;

        $.extend(data, meerkat.site.requestData);

        // Necessary Overrides
        data.transcheck = '1';
        data.health_showAll = 'N';
        data.health_onResultsPage = 'N';
        data.health_incrementTransactionId = 'N';

        return meerkat.modules.comms.post({
            errorLevel: 'silent',
            url: '/' + meerkat.site.urls.context + 'ajax/json/health_quote_results.jsp',
            data: data
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

    meerkat.modules.register('salesforce_health_payment_processor', {
        init: initSalesforceHealthPaymentProcessor,
        events: events
    });
})(jQuery);