;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = window.meerkat.logging.info;

    var events = {
            RESULTS_RANKING_READY: 'RESULTS_RANKING_READY',
            // Defined here because it's published in Results.js
            RESULTS_INITIALISED: 'RESULTS_INITIALISED',
            // Defined here because it's published in ResultsModel.js
            RESULTS_DATA_READY: 'RESULTS_DATA_READY',
            // Defined here because it's published in ResultsView.js
            RESULTS_SORTED: 'RESULTS_SORTED'
        },
        moduleEvents = events;

    var defaultRankingTriggers = ['RESULTS_DATA_READY', 'RESULTS_SORTED'],
        trackingProductObject = [];

    /**
     * Perform the write rank ajax call
     * Publish RESULTS_RANKING_READY
     * @param {String} trigger
     */
    function write(trigger) {

        // If we don't have a Results rankings property (see {vertical}Results.js), do nothing.
        if (!Results.settings.hasOwnProperty('rankings')) {
            return;
        }

        var config = Results.settings.rankings;

        // If we do not want to record rankings,
        // we can set the config to null in verticalResults.js
        if (!_.isObject(config)) {
            return;
        }

        var sortedAndFiltered = fetchProductsToRank(config.filterUnavailableProducts),
            rankingData = getWriteRankData(config, sortedAndFiltered);

        if (!rankingData) {
            return;
        }

        buildTrackingDataObject(config, sortedAndFiltered);

        sendQuoteRanking(trigger, rankingData);

        // Publish event for verticalResults.js to perform tracking events
        meerkat.messaging.publish(meerkatEvents.RESULTS_RANKING_READY);
    }

    function sendQuoteRanking(trigger, rankingData) {

        log("[resultsRankings] sendWriteRank", {
            trigger: trigger,
            data: rankingData
        });

        if (Results.getFilteredResults().length) {
            meerkat.modules.comms.post({
                url: "ajax/write/quote_ranking.jsp",
                data: rankingData,
                cache: false,
                errorLevel: "silent",
                onError: function onWriteRankingsError(jqXHR, textStatus, errorThrown, settings, resultData) {
                    meerkat.modules.errorHandling.error({
                        message: "Failed to write ranking results.",
                        page: "core:resultsRankings.js:runWriteRank()",
                        errorLevel: "silent",
                        description: "Failed to write ranking results: " + errorThrown,
                        data: {settings: settings, resultsData: resultData}
                    });
                }
            });
        }

        savePropensityScore(trigger, rankingData);
    }

    /**
     * send an api call to backend with product rank. Backend will get the propensity score for given
     * transaction, and store in database.
     * @See CarQuoteController.storePropensityScore()
     *
     * @param trigger
     * @param rankingData
     */
    function savePropensityScore(trigger, rankingData) {

        log("[resultsRankingsPropensityScores] savePropensityScore", {
            trigger: trigger,
            data: rankingData
        });

        if (Results.getFilteredResults().length) {
            meerkat.modules.comms.post({
                url: "ajax/json/car_propensity_score.jsp",
                data: rankingData,
                cache: false,
                errorLevel: "silent",
                onError: function onWriteRankingsError(jqXHR, textStatus, errorThrown, settings, resultData) {
                    log("[resultsRankingsPropensityScores] Failed to savePropensityScore");
                }
            });
        }
    }

    /**
     * Return an array of products from the ResultsModel.
     * If you want to only rank visible products, set includeOnlyFilteredResults to true.
     * If you want to rank all products, including ones filtered OUT (e.g. unavailable products, cover level tabs),
     * then set includeOnlyFilteredResults to false.
     * @param {Bool} includeOnlyFilteredResults
     */
    function fetchProductsToRank(includeOnlyFilteredResults) {
        var sortedAndFiltered = [],
            sorted = Results.getSortedResults(),
            filtered = Results.getFilteredResults();

        if (includeOnlyFilteredResults === true) {
            for (var i = 0; i < sorted.length; i++) {
                for (var j = 0; j < filtered.length; j++) {
                    if (sorted[i] == filtered[j]) {
                        sortedAndFiltered[sortedAndFiltered.length] = sorted[i];
                    }
                }
            }
        }
        else {
            sortedAndFiltered = sorted;
        }
        return sortedAndFiltered;
    }

    /**
     * Separated logic for building the data for write rank and the data for tracking purposes.
     * @param {POJO} config The Results.settings.rankings object
     * @param {POJO} sortedAndFiltered sorted and filtered (unavailable, cover level tabs etc) results.
     * @return {POJO|null} null to stop the call if no method is specified (i.e. "turns off ranking")
     * or object of data to send in rank call.
     */
    function getWriteRankData(config, sortedAndFiltered) {

        var rankingData = {
            rootPath: meerkat.site.vertical,
            rankBy: Results.getSortBy() + "-" + Results.getSortDir(),
            rank_count: sortedAndFiltered.length,
            transactionId: meerkat.modules.transactionId.get()
        };

        var method = null;
        if (config.hasOwnProperty('paths') && _.isObject(config.paths)) {
            method = "paths";
        } else if (config.hasOwnProperty('callback') && _.isFunction(config.callback)) {
            method = "callback";
        }

        if (method === null) {
            return null;
        }

        for (var i = 0; i < sortedAndFiltered.length; i++) {

            var productObj = sortedAndFiltered[i];

            switch (method) {
                case 'paths':
                    for (var p in config.paths) {
                        if (config.paths.hasOwnProperty(p)) {
                            var item = Object.byString(productObj, config.paths[p]);
                            rankingData[p + i] = item;
                        }
                    }
                    break;
                case 'callback':
                    var response = config.callback(productObj, i);
                    if (_.isObject(response) && !_.isEmpty(response)) {
                        _.extend(rankingData, response);
                    }
                    break;
            }

        }

        return rankingData;
    }

    /**
     * Build the product list required for the "products" param in
     * trackQuoteResultsList tracking calls. This can be called by write(), but
     * also externally by other modules such as cover level tabs.
     * @param {POJO} config Results.settings.rankings
     * @param {POJO} sortedAndFiltered sorted and filtered (unavailable, cover level tabs etc) results.
     */
    function buildTrackingDataObject(config, sortedAndFiltered) {

        trackingProductObject = [];
        var forceNumber = false;
        if (config.hasOwnProperty('forceIdNumeric') && _.isBoolean(config.forceIdNumeric)) {
            forceNumber = config.forceIdNumeric;
        }

        for (var rank = 0,
                 i = 0; i < sortedAndFiltered.length; i++) {

            rank++;
            var productObj = sortedAndFiltered[i];
            if (typeof productObj !== 'object') {
                continue;
            }

            var productId = productObj.productId;
            if (forceNumber) {
                productId = String(productId).replace(/\D/g, '');
            }

            data = {
                productID: productId,
                productName: Object.byString(productObj, Results.settings.paths.productName) || null,
                productBrandCode: Object.byString(productObj, Results.settings.paths.productBrandCode) || null,
                ranking: rank,
                available: Object.byString(productObj, Results.settings.paths.availability.product) || "N"
            };
            trackingProductObject.push(data);
        }
    }

    /**
     * Getter for trackingProductObject array.
     */
    function getTrackingProductObject() {
        return trackingProductObject;
    }

    /**
     * The object sent to external tracking.
     * It may need to be reset if you are filtering without going back to the server
     * or using cover level tabs.
     */
    function resetTrackingProductObject() {
        var config = Results.settings.rankings;
        if (!_.isObject(config)) {
            return;
        }
        var sortedAndFiltered = fetchProductsToRank(true);
        buildTrackingDataObject(config, sortedAndFiltered);
    }

    function registerSubscriptions() {

        var config = Results.settings.rankings;

        if (_.isObject(config)) {

            if ((config.hasOwnProperty('paths') && !_.isEmpty(config.paths)) || (config.hasOwnProperty('callback') && _.isFunction(config.callback))) {

                var triggers = defaultRankingTriggers;
                if (config.hasOwnProperty('triggers') && _.isArray(config.triggers)) {
                    triggers = config.triggers;
                }

                for (var i = 0; i < triggers.length; i++) {
                    if (meerkatEvents.hasOwnProperty(triggers[i])) {
                        meerkat.messaging.subscribe(meerkatEvents[triggers[i]], _.bind(write, this, triggers[i]));
                    }
                }
            }
        }
    }

    function initResultsRankings() {

        var self = this;

        $(document).ready(function () {
            // We need to wait until results object is initialised before setting up rank event listeners
            meerkat.messaging.subscribe(meerkatEvents.RESULTS_INITIALISED, registerSubscriptions);
        });

    }

    meerkat.modules.register("resultsRankings", {
        init: initResultsRankings,
        events: moduleEvents,
        write: write,
        getTrackingProductObject: getTrackingProductObject,
        resetTrackingProductObject: resetTrackingProductObject,
        sendQuoteRanking: sendQuoteRanking,
        fetchProductsToRank: fetchProductsToRank,
        getWriteRankData: getWriteRankData
    });

})(jQuery);