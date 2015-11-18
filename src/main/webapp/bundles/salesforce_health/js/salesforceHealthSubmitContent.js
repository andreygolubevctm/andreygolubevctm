;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    function initSalesforceHealthSubmitContent() {
        $(document).on('click', '.submit-payment-information', submitContent);
    }

    function submitContent() {
        var $mainForm = $('#mainForm');

        if($mainForm.valid()) {
            parent.meerkatPaymentInfo = $mainForm.serializeArray().filter(function(entry) {
                return entry.value !== "";
            });
        }
    }

    meerkat.modules.register("salesforceHealthSubmitContent", {
        init: initSalesforceHealthSubmitContent,
        events: events
    });

})(jQuery);