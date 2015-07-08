;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatModules = meerkat.modules,
        meerkatEvents = meerkatModules.events,
        log = meerkat.logging.info;

    var events = {};

    function initPage(){
        _initResults();
        _registerEventListeners();
    }

    function _initResults() {
        try {
            var displayMode = 'price';

            // Init the main Results object
            Results.init({
                url: "ajax/json/fuel_price_results.jsp",
                runShowResultsPage: false, // Don't let Results.view do it's normal thing.
                paths: {
                    results: {
                        list: "results.price",
                        general:  "results.general"
                    },
                    productId: "productId",
                    productName: "name",
                    productBrandCode: "provider",
                    price: {
                        premium: "priceText"
                    },
                    availability: {
                        product: "available"
                    },
                    sort: {
                        city: "city"
                    }
                },
                show: {
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
                    features:{
                        values: ".content",
                        extras: ".children"
                    }
                },
                templates:{
                    pagination:{
                        pageText: 'Product {{=currentPage}} of {{=totalPages}}'
                    }
                },
                rankings: {
                    triggers : ['RESULTS_DATA_READY'],
                    callback : _rankingCallback,
                    forceIdNumeric : false,
                    filterUnavailableProducts : true
                },
                incrementTransactionId : false
            });
        }
        catch(e) {
            Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.fuel.initResults(); ' + e.message, e);
        }
    }

    function _rankingCallback(product, position) {
        var data = {};

        // If the is the first time sorting, send the prm as well
        data["rank_premium" + position] = product.price;
        data["rank_productId" + position] = product.productId;

        return data;
    }

    function _registerEventListeners() {
        // When the navar docks/undocks
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            $('#resultsPage').css('margin-top', '35px');
        });

        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            $('#resultsPage').css('margin-top', '0');
        });

        // If error occurs, go back in the journey
        meerkat.messaging.subscribe(events.RESULTS_ERROR, function() {
            // Delayed to allow journey engine to unlock
            _.delay(function() {
                meerkat.modules.journeyEngine.gotoPath('previous');
            }, 1000);
        });

        // Run the show method even when there are no available products
        // This will render the unavailable combined template
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
            Results.view.show();
        });

        // Scroll to the top when results come back
        $(document).on("resultsReturned", function() {
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

            $(document.body).removeClass('priceMode').addClass('priceMode');

            // If no providers opted to show results, display the no results modal.
            var availableCounts = 0;
            $.each(Results.model.returnedProducts, function(){
                if (this.available === 'Y' && this.productId !== 'CURR') {
                    availableCounts++;
                }
            });

            // You've been blocked!
            if (availableCounts === 0 && !Results.model.hasValidationErrors && Results.model.isBlockedQuote) {
                showBlockedResults();
                return;
            }

            // Check products length in case the reason for no results is an error e.g. 500
            if (availableCounts === 0 && _.isArray(Results.model.returnedProducts)) {
                showNoResults();
                _.delay(function() {
                    meerkat.modules.journeyEngine.gotoPath('previous');
                }, 1000);
                return;
            }

            if(Results.getReturnedGeneral().source == "regional") {
                Results.view.showNoResults();
                _openRegionalModal();
                return;
            }

            // Results are hidden in the CSS so we don't see the scaffolding after #benefits
            $(Results.settings.elements.page).show();
        });

        $(Results.settings.elements.resultsContainer).on('click', '.result-row', _onResultRowClick);
    }

    function _onResultRowClick(event) {
        // Ensure only in XS price mode
        if ($(Results.settings.elements.resultsContainer).hasClass('priceMode') === false || meerkat.modules.deviceMediaState.get() !== 'xs') return;

        var $resultrow = $(event.target);
        if ($resultrow.hasClass('result-row') === false) {
            $resultrow = $resultrow.parents('.result-row');
        }

        var $mapButton = $resultrow.find(".map-open");
        meerkat.modules.fuelResultsMap.openMap($mapButton);
    }

    function get() {
        Results.get();
        _updateSnapshot();
    }

    function _updateDisclaimer() {
        var general = Results.getReturnedGeneral();
        if(typeof general.timeDiff !== "undefined") {
            $("#provider-disclaimer .time").text(general.timeDiff);
        }
    }

    function _updateSnapshot() {
        var fuelTypeArray = [];

        $("#checkboxes-all :checked").each(function() {
            var pushValue = "<strong>" + $.trim($(this).next("label").text()) + "</strong>";
            fuelTypeArray.push(pushValue);
        });

        var fuelTypes = fuelTypeArray.join(" &amp; "),
            location = $("#fuel_location").val(),
            data = {
                fuelTypes: fuelTypes,
                location: location
            },
            template = _.template($("#snapshot-template").html(), data, { variable: "data" });
        $("#resultsSummaryPlaceholder").html(template);
    }

    function init() {

    }

    function _openRegionalModal() {

        var $tpl = $('#regional-results-template'),
            htmlString = "";
        if ($tpl.length > 0) {
            var htmlTemplate = _.template($tpl.html());
            Results.sortBy(Results.settings.sort.city, "asc");
            htmlString = htmlTemplate(Results.getSortedResults());
        }
        if(htmlString.length) {
            meerkat.modules.dialogs.show({
                title: "Regional Price Average",
                htmlContent: htmlString
            });
        } else {
            showNoResults();
        }
        _.delay(function() {
            meerkat.modules.journeyEngine.gotoPath('previous');
        }, 1000);

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

    /**
     * This function has been refactored into calling a core resultsTracking module.
     * It has remained here so verticals can run their own unique calls.
     */
    function publishExtraSuperTagEvents(additionalData) {
        additionalData = typeof additionalData === 'undefined' ? {} : additionalData;
        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: $.extend({
                sortBy: Results.getSortBy() + '-' + Results.getSortDir()
            }, additionalData),
            onAfterEventMode: 'Refresh'
        });
    }

    meerkat.modules.register("fuelResults", {
        init: init,
        initPage: initPage,
        events: events,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents,
        get: get,
        getFormattedTimeAgo: getFormattedTimeAgo
    });
})(jQuery);