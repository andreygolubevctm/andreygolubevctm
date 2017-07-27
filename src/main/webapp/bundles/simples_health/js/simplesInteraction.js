;(function () {
    // meerkat namespace
    meerkat = window.meerkat = window.meerkat || {};
    meerkat.simplesInteraction = {};

    function storeCallId(transactionId) {
        var ajaxURL = "spring/rest/simples/storeCallDetail.json";
        return meerkat.modules.comms.post({
            url: ajaxURL,
            dataType: "json",
            data: {
                transactionId: transactionId
            },
            onSuccess: function onStorecallIdSuccess(data) {

            },
            useDefaultErrorHandling: false,
            errorLevel: "silent",
            onError: function onStoreCallIdError(obj, txt, errorThrown) {
                console.log("on error in store call id");

            }
        });
    }

    meerkat.modules.register('simplesInteraction', {
        storeCallId: storeCallId
    });
})(jQuery);
