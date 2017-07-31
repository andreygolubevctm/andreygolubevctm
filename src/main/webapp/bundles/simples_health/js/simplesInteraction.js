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
                meerkat.modules.errorHandling.error({
                    errorLevel: "silent",
                    message: "Store call Id error",
                    description: "An error occurred while storing the callId : " + txt + ' ' + errorThrown,
                    data: {
                        status: txt,
                        error: errorThrown,
                        transactionId:transactionId
                    },
                    id: transactionId
                });

            }
        });
    }

    meerkat.modules.register('simplesInteraction', {
        storeCallId: storeCallId
    });
})(jQuery);
