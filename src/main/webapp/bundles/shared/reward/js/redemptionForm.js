;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var modalId = false;

    function initRedemptionForm(modalIdParam, baseURL) {
        modalId = modalIdParam;

        if (modalId) {
            meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($('#redemptionForm'));
            meerkat.modules.elasticAddress.setupElasticAddressPlugin(baseURL);
            meerkat.modules.autocomplete.setBaseURL(baseURL);
            meerkat.modules.autocomplete.setTypeahead();
            meerkat.modules.address_lookup.setBaseURL(baseURL);
        }
    }

    meerkat.modules.register("redemptionForm", {
        initRedemptionForm: initRedemptionForm
    });

})(jQuery);