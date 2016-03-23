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
            meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
            _initResults();
            _initEventListeners();
        }
    }

    function _initResults() {
        try {

            var quoteResultsUrl = "ajax/json/life_quote_results.jsp";
            if (meerkat.modules.splitTest.isActive(40) || meerkat.site.isDefaultToEnergyQuote) {
                quoteResultsUrl = "ajax/json/life_quote_results_ws.jsp";
            }

            // Init the main Results object
            Results.init({
                url: quoteResultsUrl,
                runShowResultsPage: false, // Don't let Results.view do it's normal thing.
                paths: {
                    results: {
                        list: "results.plans",
                        general: "results.uniqueCustomerId"
                    },
                    productId: "productId",
                    productName: "planName",
                    productBrandCode: "retailerName",
                    contractPeriodValue: "contractPeriodValue",
                    totalDiscountValue: "totalDiscountValue",
                    yearlySavingsValue: "yearlySavingsValue",
                    estimatedCostValue: "estimatedCostValue",
                    availability: {
                        product: "productAvailable"
                    }
                },
                show: {
                    nonAvailableProducts: false, // This will apply the availability.product rule
                    unavailableCombined: true    // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
                },
                availability: {
                    product: ["equals", "Y"]
                },
                render: {
                    templateEngine: '_',
                    dockCompareBar: false
                },
                displayMode: 'price', // features, price
                pagination: {
                    touchEnabled: false
                },
                sort: {
                    sortBy: 'totalDiscountValue',
                    sortByMethod: meerkat.modules.utilitiesSorting.sortDiscounts,
                    sortDir: 'desc'
                },
                //frequency: "premium",
                animation: {
                    results: {
                        individual: {
                            active: false
                        },
                        delay: 500,
                        options: {
                            easing: "swing", // animation easing type
                            duration: 1000
                        }
                    },
                    shuffle: {
                        active: true,
                        options: {
                            easing: "swing", // animation easing type
                            duration: 1000
                        }
                    },
                    filter: {
                        reposition: {
                            options: {
                                easing: "swing" // animation easing type
                            }
                        }
                    }
                },
                rankings: {
                    triggers : ['RESULTS_DATA_READY'],
                    callback : rankingCallback,
                    forceIdNumeric : false,
                    filterUnavailableProducts : true
                }
            });
        }
        catch(e) {
            Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.utilitiesResults.initResults(); '+e.message, e);
        }
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