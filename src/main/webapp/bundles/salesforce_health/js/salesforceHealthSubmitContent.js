;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    function initSalesforceHealthSubmitContent() {
        $(document).on('click', '.submit-payment-information', submitContent);
    }

    function submitContent() {
        var $mainForm = $('#mainForm'),
            values = $mainForm.serializeArray().filter(function(val) {
                return val.value !== '';
            });
        console.log(values);
    }

    meerkat.modules.register("salesforceHealthSubmitContent", {
        init: initSalesforceHealthSubmitContent,
        events: events
    });

})(jQuery);