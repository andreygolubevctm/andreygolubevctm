(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var moduleEvents = {
            creditcard: {}
        },
        product;


    function initCreditCard() {

        $(document).ready(function () {

            // Only init if creditcard
            if (meerkat.site.vertical !== "creditcard")
                return false;

            product = meerkat.site.product;

            if (product === null) {
                return false;
            }

            // Always run, as in journeys where we collect details, they may not continue.
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackQuoteForms',
                object: {
                    actionStep: "creditcard transfer ONLINE",
                    productID: product.code,
                    productBrandCode: product.provider.code,
                    productName: product.shortDescription,
                    type: "ONLINE"
                }
            });

            trackTransfer();

            setTimeout(function () {
                redirectTo(product, "justRedirect");
            }, 200);

        });

    }

    function redirectTo(product, methodName) {
        if (typeof product.handoverUrl == 'string' && product.handoverUrl.length > 1) {
            window.location.replace(product.handoverUrl);
        } else {
            meerkat.modules.errorHandling.error({
                errorLevel: 'warning',
                message: "An error occurred. Sorry about that!<br /><br />Please go back and try again.",
                page: 'creditcard.js:' + methodName,
                description: "No handoverUrl in results object.",
                data: product
            });
            return false;
        }
    }

    function trackTransfer() {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackQuoteHandoverClick',
            object: {
                actionStep: "creditcard transfer ONLINE",
                productID: product.code,
                productBrandCode: product.provider.code,
                productName: product.shortDescription,
                type: "ONLINE"
            }
        });
    }

    meerkat.modules.register("creditcard", {
        init: initCreditCard,
        events: moduleEvents
    });

})(jQuery);