;(function ($, undefined) {
    var meerkat = window.meerkat,
        meerkatModules = meerkat.modules,
        meerkatEvents = meerkatModules.events,
        log = meerkat.logging.info;

    var events = {};

    var priceBandTemplate;

    function initPage() {
        _initResults();
        _registerEventListeners();
    }

    function _initResults() {
        try {
            var displayMode = 'price';

            // Init the main Results object
            Results.init({
                url: "ajax/json/fuel_price_results_ws.jsp",
                runShowResultsPage: false, // Don't let Results.view do it's normal thing.
                paths: {
                    results: {
                        list: "results.sites",
                        general: "results.info"
                    },
                    productId: "id",
                    productName: "name",
                    productBrandCode: "brandId",
                    price: {
                        premium: "bandId"
                    },
                    availability: {
                        product: "available"
                    },
                    sort: {
                        city: "cityName"
                    }
                },
                show: {
                    resultsAsRows: false,
                    nonAvailableProducts: false, // This will apply the availability.product rule
                    unavailableCombined: true    // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
                },
                availability: {
                    product: ["equals", "Y"],
                    price: ["notEquals", -1] // As a filter this should never match, but is here due to inconsistent Car data model and work-around for Results.setFrequency
                },
                render: {
                    templateEngine: '_',
                    dockCompareBar: false
                },
                displayMode: displayMode, // features, price
                pagination: {
                    mode: 'page',
                    touchEnabled: Modernizr.touch
                },
                sort: {
                    sortBy: 'price.premium',
                    city: "sort.city"
                },
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
                elements: {
                    features: {
                        values: ".content",
                        extras: ".children"
                    }
                },
                templates: {
                    pagination: {
                        pageText: 'Product {{=currentPage}} of {{=totalPages}}'
                    }
                },
                rankings: {
                    triggers: ['RESULTS_DATA_READY'],
                    callback: _rankingCallback,
                    forceIdNumeric: false,
                    filterUnavailableProducts: true
                },
                incrementTransactionId: false
            });
        }
        catch (e) {
            Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.fuel.initResults(); ' + e.message, e);
        }
    }

    function _rankingCallback(product, position) {
        var data = {};
        if (position < 21 && product.hasOwnProperty('bandId')) {
            data["rank_premium" + position] = product.bandId;
            data["rank_productId" + position] = product.id;
        }
        return data;
    }

    function _registerEventListeners() {

        // Run the show method even when there are no available products
        // This will render the unavailable combined template
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function () {
            Results.view.show();
        });

        // Scroll to the top when results come back
        $(document).on("resultsReturned", function () {
            meerkat.modules.utils.scrollPageTo($("header"));
            _updateDisclaimer();
        });

        // Plot all the markers for the current result set.
        $(document).on("resultsLoaded", function () {
            //var results = Results.getFilteredResults();
            //meerkat.modules.fuelMap.plotMarkers(results);
        });
        
        // Start fetching results
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            $('#resultsPage, .loadingDisclaimerText').removeClass('hidden');
        });

        // Fetching done
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            $('.loadingDisclaimerText').addClass('hidden');

            $(document.body).removeClass('priceMode').addClass('priceMode');

            // If no providers opted to show results, display the no results modal.
            var availableCounts = 0;
            $.each(Results.model.returnedProducts, function () {
                if (this.hasOwnProperty('bandId')) {
                    availableCounts++;
                }
            });

            // You've been blocked!
            if (availableCounts === 0 && !Results.model.hasValidationErrors && Results.model.isBlockedQuote) {
                showBlockedResults();
                updatePriceBand(false);
                return;
            }

            // Check products length in case the reason for no results is an error e.g. 500
            if (availableCounts === 0 && _.isArray(Results.model.returnedProducts)) {
                showNoResults();
                updatePriceBand(false);
                return;
            }

            // Normal results
            meerkat.modules.fuelMap.plotMarkers(Results.model.returnedProducts);

            // Update price band
            updatePriceBand(true);
        });

    }

    function get() {
        Results.updateAggregatorEnvironment();
        Results.get();
        _updateSnapshot();
    }

    function _updateDisclaimer() {
        var general = Results.getReturnedGeneral();
        if (typeof general.timeDiff !== "undefined") {
            $("#provider-disclaimer .time").text(general.timeDiff);
        }
    }

    function _updateSnapshot() {
        try {
            var fuelTypeArray = [];

            $("#checkboxes-all :checked").each(function () {
                var pushValue = "<strong>" + $.trim($(this).next("label").text()) + "</strong>";
                fuelTypeArray.push(pushValue);
            });

            var fuelTypes = fuelTypeArray.join(" &amp; "),
                location = $("#fuel_location").val(),
                data = {
                    fuelTypes: fuelTypes,
                    location: location
                };

            var htmlTemplate = _.template($("#snapshot-template").html(), {variable: "data"});
            $("#resultsSummaryPlaceholder").html(htmlTemplate(data));
        } catch (e) {

        }
    }

    function init() {
        $(document).ready(function () {
            priceBandTemplate = _.template($('#price-band-template').html());
        });
    }

    function showNoResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $('#no-results-content')[0].outerHTML
        });
    }

    function showBlockedResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $('#blocked-ip-address')[0].outerHTML
        });
    }

    function getFormattedTimeAgo(date) {
        return "Last updated " + meerkat.modules.utils.getTimeAgo(date) + " ago";
    }

    function getBand(bandId) {
        return Results.getReturnedGeneral().bands.filter(function (band) {
            return band.id === bandId;
        })[0];
    }

    function updatePriceBand(hasSite) {
        var info = hasSite === true ? Results.getReturnedGeneral() : {error: true};
        $('#price-band-container').html(priceBandTemplate(info));
    }

    meerkat.modules.register("fuelResults", {
        init: init,
        initPage: initPage,
        events: events,
        get: get,
        getFormattedTimeAgo: getFormattedTimeAgo,
        getBand: getBand
    });
})(jQuery);