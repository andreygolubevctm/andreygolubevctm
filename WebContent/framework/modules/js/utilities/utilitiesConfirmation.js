//
// Confirmation Module
//
;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    function init() {

        $(document).ready(function ($) {

            if (typeof meerkat.site === 'undefined') {
                return;
            }
            if (meerkat.site.pageAction !== 'confirmation') {
                return;
            }


            // Handle error display
            // 'confirmationData' is a global object added by slide_confirmation.tag
            if (confirmationData.hasOwnProperty('confirmation') === false || confirmationData.confirmation.hasOwnProperty('uniquePurchaseId') === false) {
                var message = 'Trying to load the confirmation page failed';
                if (confirmationData.hasOwnProperty('confirmation') && confirmationData.confirmation.hasOwnProperty('message')) {
                    message = confirmationData.confirmation.message;
                }

                meerkat.modules.errorHandling.error({
                    message: message,
                    page: "utilitiesConfirmation.js:init",
                    description: "Invalid data",
                    data: confirmationData,
                    errorLevel: "warning"
                });

                // Handle normal display
            } else {
                var data = confirmationData.confirmation;
                if (!data.product) {
                    data.product = {};
                }
                fillTemplate(data);

                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: 'completedApplication',
                    object: {
                        productID: data.product.id || null,
                        productBrandCode: data.product.retailerName || null,
                        productName: data.product.planName || null,
                        quoteReferenceNumber: data.uniquePurchaseId,
                        verticalFilter: (data.hasOwnProperty('whatToCompare') ? data.whatToCompare : null),
                        transactionID: confirmationTranId || null
                    }
                });

            }

        });

    }

    function fillTemplate(obj) {
        var confirmationTemplate = $("#confirmation-template");
        if (confirmationTemplate.length) {
            var htmlTemplate = _.template(confirmationTemplate.html());
            var htmlString = htmlTemplate(obj);
            $("#confirmation").html(htmlString);
        }
    }

    meerkat.modules.register('homeloanConfirmation', {
        init: init
    });

})(jQuery);