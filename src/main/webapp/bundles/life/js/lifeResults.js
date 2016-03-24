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
                    },
                    productName: "planName",
                    productBrandCode: "retailerName",
                    availability: {
                        product: "productAvailable"
                    }
                },
                elements: {
                    templates: {
                        unavailable: false,
                        unavailableCombined: false
                    }
                },
                show: {
                    nonAvailableProducts: false, // This will apply the availability.product rule
                    unavailableCombined: true    // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
                },
                sort: {
                    sortBy: 'value'
                },
                displayMode: 'price', // features, price
                animation: {},
                rankings: {
                    triggers : ['RESULTS_DATA_READY'],
                    callback : _rankingCallback,
                    forceIdNumeric : false,
                    filterUnavailableProducts : true
                }
            });

    }

    function _rankingCallback(product, position) {
        var data = {};

        // If the is the first time sorting, send the prm as well
        data["rank_premium" + position] = product.value;
        data["rank_productId" + position] = product.product_id;
        data["rank_company" + position] = product.company;
        data["rank_provider" + position] = product.service_provider;

        return data;
    }

    function _initEventListeners() {
        // Model updated, make changes before rendering
        meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
            // Populating sorted products is a trick for HML due to setting sortBy:false
            Results.model.sortedProducts = Results.model.returnedProducts;
        });

        // When the navar docks/undocks
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            $component.css('margin-top', '8px');
        });

        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            $component.css('margin-top', '0');
        });

        // Run the show method even when there are no available products
        // This will render the unavailable combined template
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function () {
            console.log('wat');
            Results.view.show();
        });

        // If error occurs, go back in the journey
        meerkat.messaging.subscribe(events.RESULTS_ERROR, function resultsError() {
            // Delayed to allow journey engine to unlock
            _.delay(function () {
                meerkat.modules.journeyEngine.gotoPath('previous');
            }, 1000);
        });

        // Scroll to the top when results come back
        $(document).on("resultsReturned", function () {
            meerkat.modules.utils.scrollPageTo($("header"));
            console.log('results returned');
        });

        // Start fetching results
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.modules.journeyEngine.loadingShow('...getting your quotes...');
            $component.removeClass('hidden');

            // Hide pagination
            Results.pagination.hide();
            console.log('r u even starting');
        });

        // Fetching done
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {

            // Results are hidden in the CSS so we don't see the scaffolding after #benefits
            $(Results.settings.elements.page).show();

            meerkat.modules.journeyEngine.loadingHide();

            $(document.body).addClass('priceMode');

            console.log('y u do this? finish!');
        });

        $(Results.settings.elements.resultsContainer).on("noResults", function onResultsNone() {
            showNoResults();
        });
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