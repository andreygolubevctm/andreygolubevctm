/**
 * Description:
 * External documentation:
 */

;(function($, undefined){

    var meerkat = window.meerkat,
        log = meerkat.logging.info;

    var events = {
            resultsFeatures: {
                    STRUCTURE_FETCHED: "STRUCTURE_FETCHED"
            }
        };

    var fetchingFeatures;

    /**
     * Fetch the page structure separately.
     * @param vertical
     * @returns {*}
     */
    function fetchStructure(vertical) {

        // If it already exists
        if(Features.getPageStructure().length || (typeof fetchingFeatures != 'undefined' && fetchingFeatures.state() == 'pending')) {
            log("Page Structure Exists or request is pending");
            return $.Deferred().resolve().promise();
        }

        fetchingFeatures = meerkat.modules.comms.get({
            url: "features/getStructure.json",
            cache: true,
            errorLevel: "silent",
            numberOfAttempts: 3,
            dataType: "json",
            data: {vertical: vertical}
        });



        fetchingFeatures.then(function onSuccess(json) {
            Features.pageStructure = json;
            meerkat.messaging.publish(events.resultsFeatures.STRUCTURE_FETCHED);
        }).catch(function onError(obj, textStatus, errorThrown) {
            var transactionId = meerkat.modules.transactionId.get();
            meerkat.modules.errorHandling.error({
                errorLevel: "fatal",
                message: "An error occurred fetching product features. Please check your connection or try again later.",
                page: "resultsFeatures.js:resultsPage",
                description: "fetch() AJAX request(s) returned an error: " + textStatus + ' ' + errorThrown + " for "+meerkat.site.vertical+". Original transactionId: " + transactionId,
                data: obj
            });
        });

        return fetchingFeatures;
    }

    meerkat.modules.register("resultsFeatures", {
        events: events,
        fetchStructure: fetchStructure
    });

})(jQuery);
