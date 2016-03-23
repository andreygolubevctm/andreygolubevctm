;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    var $component; //Stores the jQuery object for the component group
    var initialised = false;

    function initLifeResults(){
        if(!initialised) {
            initialised = true;
            $component = $("#resultsPage");
            meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, meerkat.modules.resultsTracking.trackQuoteResultsList);
            _initResults();
            _initEventListeners();
        }
    }

    function _initResults() {
        try {

            var quoteResultsUrl = "ajax/json/life_quote_results.jsp?vertical=life";
            if (meerkat.modules.splitTest.isActive(40)) {
                quoteResultsUrl = "ajax/json/life_quote_results_ws.jsp";
            }

            // Init the main Results object
            Results.init({
                url: quoteResultsUrl,
                runShowResultsPage: false, // Don't let Results.view do it's normal thing.
                paths: {
                    results: {
                        list: "results.client.premium",
                    }
                },
                sort: {
                    sortBy: 'value'
                },
                displayMode: 'price', // features, price
                animation: {},
                rankings: {
                    triggers : ['RESULTS_DATA_READY'],
                    callback : rankingCallback,
                    forceIdNumeric : false,
                    filterUnavailableProducts : true
                }
            });
        }
        catch(e) {
            Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.lifeResults._initResults(); '+e.message, e);
        }
    }

    function rankingCallback(product, position) {
        var data = {};

        // If the is the first time sorting, send the prm as well
        data["rank_premium" + position] = product.value;
        data["rank_productId" + position] = product.product_id;
        data["rank_premium" + position] = product.service_provider;

        return data;
    }

    function _initEventListeners() {

    }

    function get() {
        Results.updateAggregatorEnvironment();
        Results.get();
    }

    meerkat.modules.register("lifeResults", {
        initLifeResults: initLifeResults,
        events: events,
        get: get
    });
})(jQuery);