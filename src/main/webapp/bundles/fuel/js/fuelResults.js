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
                        city: "cityId"
                    }
                },
                show: {
                    resultsAsRows: false,
                    nonAvailableProducts: false, // This will apply the availability.product rule
                    unavailableCombined: true    // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
                },
                availability: {},
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
                        active: false
                    },
                    filter: {
                        active: false
                    },
                    features: {
                        active: false
                    }
                },
                templates: {
                    pagination: {
                        pageText: 'Product {{=currentPage}} of {{=totalPages}}'
                    }
                },
                rankings: {},
                incrementTransactionId: false
            });
        }
        catch (e) {
            Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.fuel.initResults(); ' + e.message, e);
        }
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

        // Start fetching results
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            $('#resultsPage, .loadingDisclaimerText').removeClass('hidden');
        });

        // Fetching done
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            $('.loadingDisclaimerText').addClass('hidden');

            $(document.body).addClass('priceMode');

            // Normal results
            meerkat.modules.fuelMap.plotMarkers(Results.model.returnedProducts);

            // If no providers opted to show results, display the no results modal.
            var mapHasMarkers = meerkat.modules.fuelMap.getMarkers().length > 0;

            // You've been blocked!
            if (!mapHasMarkers && !Results.model.hasValidationErrors && Results.model.isBlockedQuote) {
                showBlockedResults();
                updatePriceBand(false);
                return;
            }

            // Check products length in case the reason for no results is an error e.g. 500
            if (!mapHasMarkers && _.isArray(Results.model.returnedProducts)) {
                updatePriceBand(false);
                return;
            }
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