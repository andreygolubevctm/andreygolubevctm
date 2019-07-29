;(function ($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        log = meerkat.logging.info;

    var events = {
        // Defined here because it's published in Results.js
        RESULTS_ERROR: 'RESULTS_ERROR'
    };
    var $component; //Stores the jQuery object for the component group

    function initPage() {

        initResults();
        eventSubscriptions();
    }

    function initResults() {

        try {

            // Init the main Results object
            Results.init({
                url: "ajax/json/sar_quote_results.jsp",
                runShowResultsPage: false, // Don't let Results.view do it's normal thing.
                paths: {
                    results: {
                        list: "results.price"
                    },
                    productId: "productId",
                    productName: "des",
                    productBrandCode: "provider",
                    price: {
                        premium: "price"
                    },
                    availability: {
                        product: "available"
                    },
                    info: {
                        keyService: "info.keyService.value",
                        roadCall: "info.roadCall.value"
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
                    sortBy: 'price.premium',
                    sortDir: 'asc'
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
                rankings: {
                    triggers: ['RESULTS_DATA_READY'],
                    callback: rankingCallback,
                    forceIdNumeric: false,
                    filterUnavailableProducts: true
                }
            });
        }
        catch (e) {
            Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.utilitiesResults.initResults(); ' + e.message, e);
        }
    }


    /**
     * Pre-filter the results object to add another parameter. This will be unnecessary when the field comes back from Java.
     */
    function massageResultsObject(products) {

        if (_.isArray(products) && products.length > 0 && _.isArray(products[0])) {
            products = [{
                productAvailable: 'N'
            }];
            return products;
        }
        _.each(products, function massageJson(result, index) {

            // Add properties
            //result.productAvailable = 'Y';
            result.brandCode = result.provider;
        });
        return products;
    }

    function rankingCallback(product, position) {
        var data = {};

        // If the is the first time sorting, send the prm as well
        //data["rank_premium" + position] = product.price;
        data["rank_productId" + position] = product.productId;

        return data;
    }

    function eventSubscriptions() {

        // Model updated, make changes before rendering
        meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
            Results.model.returnedProducts = massageResultsObject(Results.model.returnedProducts);

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

        });

        // Start fetching results
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.modules.journeyEngine.loadingShow('...getting your quotes...');
            $component.removeClass('hidden');

            // Hide pagination
            Results.pagination.hide();
        });

        // Fetching done
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {

            // Results are hidden in the CSS so we don't see the scaffolding after #benefits
            $(Results.settings.elements.page).show();

            meerkat.modules.journeyEngine.loadingHide();

            $(document.body).addClass('priceMode');

            // If no providers opted to show results, display the no results modal.
            var availableCounts = 0;
            $.each(Results.model.returnedProducts, function () {
                if (this.available === 'Y') {
                    availableCounts++;
                }
            });

            if (availableCounts === 0 && !Results.model.hasValidationErrors) {
                showNoResults();
            }

        });

        $(Results.settings.elements.resultsContainer).on("noResults", function onResultsNone() {
            showNoResults();
        });

        // Handle result row click
        $(Results.settings.elements.resultsContainer).on('click', '.result-row', resultRowClick);

        $(document.body).on('click', '.btn-apply', enquireNowClick);
    }

    function enquireNowClick(event) {

        event.preventDefault();

        var $resultrow = $(event.target);
        if ($resultrow.hasClass('result-row') === false) {
            $resultrow = $resultrow.parents('.result-row');
        }
        // Row must be available to click it.
        if (typeof $resultrow.attr('data-available') === 'undefined' || $resultrow.attr('data-available') !== 'Y') return;

        if ($resultrow.attr("data-productId")) {
            Results.setSelectedProduct($resultrow.attr("data-productId"));
        }

        meerkat.modules.roadside.trackHandover();
        meerkat.modules.moreInfo.setProduct(Results.getResult('productId', $resultrow.attr('data-productId')));
        meerkat.modules.roadsideMoreInfo.retrieveExternalCopy(Results.getSelectedProduct()).then(function () {
            meerkat.modules.journeyEngine.gotoPath('next', $resultrow.find('.btn-apply'));
        })
        .catch(function onError(obj, txt, errorThrown) {
			exception(txt + ': ' + errorThrown);
		});

    }

    function resultRowClick(event) {
        // Ensure only in XS price mode
        if ($(Results.settings.elements.resultsContainer).hasClass('priceMode') === false) return;
        if (meerkat.modules.deviceMediaState.get() !== 'xs') return;

        var $resultrow = $(event.target);
        if ($resultrow.hasClass('result-row') === false) {
            $resultrow = $resultrow.parents('.result-row');
        }

        // Row must be available to click it.
        if (typeof $resultrow.attr('data-available') === 'undefined' || $resultrow.attr('data-available') !== 'Y') return;

        // Set product and launch bridging
        meerkat.modules.moreInfo.setProduct(Results.getResult('productId', $resultrow.attr('data-productId')));
        meerkat.modules.roadsideMoreInfo.runDisplayMethod();
    }

    // Wrapper around results component, load results data
    function get() {
        Results.get();
    }

    function showNoResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $('#no-results-content')[0].outerHTML
        });
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

    function init() {
        $(document).ready(function () {
            $component = $("#resultsPage");
            meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
        });
    }

    meerkat.modules.register('roadsideResults', {
        init: init,
        initPage: initPage,
        get: get,
        showNoResults: showNoResults,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents
    });

})(jQuery);
