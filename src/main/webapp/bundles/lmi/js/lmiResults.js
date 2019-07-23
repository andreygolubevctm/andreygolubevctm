;(function ($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        log = meerkat.logging.info;

    var events = {
        // Defined here because it's published in Results.js
        RESULTS_ERROR: 'RESULTS_ERROR'
    };

    meerkatEvents.lmiResults = {
        FEATURES_CALL_ACTION: 'FEATURES_CALL_ACTION',
        FEATURES_CALL_ACTION_MODAL: 'FEATURES_CALL_ACTION_MODAL',
        FEATURES_SUBMIT_CALLBACK: 'FEATURES_SUBMIT_CALLBACK'
    };

    var $component; //Stores the jQuery object for the component group
    var previousBreakpoint;
    var needToBuildFeatures = false;

    function initPage() {

        initResults();
        Features.init();
        meerkat.modules.compare.initCompare();
        eventSubscriptions();
        breakpointTracking();
    }

    function onReturnToPage() {
        breakpointTracking();
        if (previousBreakpoint !== meerkat.modules.deviceMediaState.get()) {
            Results.view.calculateResultsContainerWidth();
            Features.clearSetHeights();
            Features.balanceVisibleRowsHeight();
        }
        Results.pagination.refresh();
    }

    function initResults() {

        try {

            // Init the main Results object
            Results.init({
                url: "ajax/json/features/results.jsp?vertical=" + meerkat.site.vertical,
                runShowResultsPage: false, // Don't let Results.view do it's normal thing.
                paths: {
                    results: {
                        list: "results.products.product"
                    },
                    productId: "productId",
                    productName: "policyName",
                    productBrandCode: "brandCode",
                    availability: {
                        product: "productAvailable"
                    }
                },
                show: {
                    savings: false,
                    featuresCategories: false,
                    nonAvailablePrices: true,     // This will apply the availability.price rule
                    nonAvailableProducts: false,  // This will apply the availability.product rule
                    unavailableCombined: false     // Whether or not to render a 'fake' product which is a placeholder for all unavailable products.
                },
                availability: {
                    product: ["equals", "Y"]
                },
                render: {
                    templateEngine: '_',
                    features: {
                        mode: 'populate',
                        headers: false,
                        numberOfXSColumns: 1
                    },
                    dockCompareBar: false
                },
                displayMode: "features", // features, price
                pagination: {
                    mode: 'page',
                    touchEnabled: Modernizr.touch
                },
                sort: {
                    sortBy: 'policyName'
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
                dictionary: {
                    valueMap: [
                        {
                            key: 'Y',
                            value: "<span class='icon icon-tick'></span>"
                        },
                        {
                            key: 'N',
                            value: "<span class='icon icon-cross'></span>"
                        },
                        {
                            key: 'R',
                            value: "Restricted / Conditional"
                        },
                        {
                            key: 'AI',
                            value: "Additional Information"
                        },
                        {
                            key: 'O',
                            value: "Optional"
                        },
                        {
                            key: 'L',
                            value: "Limited"
                        },
                        {
                            key: 'SCH',
                            value: "As shown in schedule"
                        },
                        {
                            key: 'NA',
                            value: "Non Applicable"
                        },
                        {
                            key: 'E',
                            value: "Excluded"
                        },
                        {
                            key: 'NE',
                            value: "No Exclusion"
                        },
                        {
                            key: 'NS',
                            value: "No Sub Limit"
                        },
                        {
                            key: 'OTH',
                            value: ""
                        }
                    ]
                },
                rankings: {
                    paths: {
                        rank_productId: "productId"
                    },
                    filterUnavailableProducts: false
                },
                incrementTransactionId: false
            });
        }
        catch (e) {
            Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'meerkat.modules.lmiResults.initResults(); ' + e.message, e);
        }

    }


    function eventSubscriptions() {

        // When the navar docks/undocks
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            $('#resultsPage').css('margin-top', '35px');
        });

        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            $('#resultsPage').css('margin-top', '0');
        });

        // If error occurs, go back in the journey
        meerkat.messaging.subscribe(events.RESULTS_ERROR, function () {
            // Delayed to allow journey engine to unlock
            _.delay(function () {
                meerkat.modules.journeyEngine.gotoPath('previous');
            }, 1000);
        });

        $(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function () {
            Features.buildHtml();
        });

        // Run the show method even when there are no available products
        // This will render the unavailable combined template
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function () {
            Results.view.show();
        });

        $(document).on("resultsLoaded", onResultsLoaded);

        // Scroll to the top when results come back
        $(document).on("resultsReturned", function () {
            meerkat.modules.utils.scrollPageTo($("header"));

            // Reset the feature header to match the new column content.
            $(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");


        });

        meerkat.messaging.subscribe(meerkatEvents.FEATURE_TOGGLED, function updateDisclaimerPosition(featureObject){
            meerkat.modules.showMoreQuotesPrompt.updateBarPosition(featureObject.element, featureObject.isOpening);
        });


        // Start fetching results
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.modules.journeyEngine.loadingShow('getting your quotes');
            $('#resultsPage').removeClass('hidden');
            // Hide pagination
            Results.pagination.hide();
        });

        // Fetching done
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {

            // Results are hidden in the CSS so we don't see the scaffolding after #benefits
            $(Results.settings.elements.page).show();

            meerkat.modules.journeyEngine.loadingHide();
            Results.pagination.show();

            /*// If no providers opted to show results, display the no results modal.
             var availableCounts = 0;
             $.each(Results.model.returnedProducts, function() {
             if (this.available === 'Y' && this.productId !== 'CURR') {
             availableCounts++;
             }
             });
             // Check products length in case the reason for no results is an error e.g. 500
             if (availableCounts === 0 && _.isArray(Results.model.returnedProducts) && Results.model.returnedProducts.length > 0) {
             showNoResults();
             }
             */

        });

        $(document).on("populateFeaturesStart", function onPopulateFeaturesStart() {
            meerkat.modules.performanceProfiling.startTest('results');
            // Create the featureIds here as new framework doesn't use populateHeader
            Features.featuresIds = [];
            $('.featuresTemplateComponent > .cell > .h.content').each(function () {
                var fid = $(this).attr('data-featureid');
                if ($.inArray(fid, Features.featuresIds) == -1) {
                    Features.featuresIds.push(fid);
                }
            });
        });

        $(Results.settings.elements.resultsContainer).on("populateFeaturesEnd", function onPopulateFeaturesEnd() {

            var time = meerkat.modules.performanceProfiling.endTest('results');

            var score;
            if (time < 1000) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.HIGH;
            } else if (time < 2000 && meerkat.modules.performanceProfiling.isIE8() === false) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.MEDIUM;
            } else {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.LOW;
            }

            Results.setPerformanceMode(score);

        });

        $(document).on("resultPageChange", function (event) {
            var pageData = event.pageData;
            if (pageData.measurements === null) return false;

            var items = Results.getFilteredResults().length;
            var columnsPerPage = pageData.measurements.columnsPerPage;
            //var freeColumns = (columnsPerPage*pageData.measurements.numberOfPages)-items;
        });

        // Hovering a row cell adds a class to the whole row to make it highlightable
        $(document).on("FeaturesRendered", function () {

            Features.removeEmptyDropdowns();
            $(Features.target + " .expandable > " + Results.settings.elements.features.values).off('mouseenter mouseleave').on("mouseenter", function () {
                var featureId = $(this).attr("data-featureId");
                var $hoverRow = $(Features.target + ' [data-featureId="' + featureId + '"]');

                $hoverRow.addClass(Results.settings.elements.features.expandableHover.replace(/[#\.]/g, ''));
            }).on("mouseleave", function () {
                var featureId = $(this).attr("data-featureId");
                var $hoverRow = $(Features.target + ' [data-featureId="' + featureId + '"]');

                $hoverRow.removeClass(Results.settings.elements.features.expandableHover.replace(/[#\.]/g, ''));
            });
        });

        //meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, publishExtraSuperTagEvents);
        //meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, publishExtraSuperTagEvents);
    }

    function breakpointTracking() {

        startColumnWidthTracking();

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter() {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results') {
                startColumnWidthTracking();
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function resultsXsBreakpointLeave() {
            stopColumnWidthTracking();
            Results.pagination.setCurrentPageNumber(1);
            Results.pagination.resync();
        });

    }

    function startColumnWidthTracking() {
        if (meerkat.modules.deviceMediaState.get() === 'xs' && Results.getDisplayMode() === 'features') {
            Results.view.startColumnWidthTracking($(window), Results.settings.render.features.numberOfXSColumns, false);
            Results.pagination.setCurrentPageNumber(1);
            Results.pagination.resync();
        }
    }

    function stopColumnWidthTracking() {
        Results.view.stopColumnWidthTracking();
    }

    function recordPreviousBreakpoint() {
        previousBreakpoint = meerkat.modules.deviceMediaState.get();
    }

    // Wrapper around results component, load results data
    function get() {
        meerkat.modules.resultsFeatures.fetchStructure(meerkat.site.vertical).then(function() {
            Results.get();
        })
        .catch(function onError(obj, txt, errorThrown) {
			exception(txt + ': ' + errorThrown);
		})
    }

    function onResultsLoaded() {
        startColumnWidthTracking();
        switchToFeaturesMode(false);
    }

    function showNoResults() {
        //TODO
    }

    /**
     * This function has been refactored into calling a core resultsTracking module.
     * It has remained here so verticals can run their own unique calls.
     */
    function publishExtraSuperTagEvents() {


        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: {},
            onAfterEventMode: 'Load'
        });
    }

    /**
     * DOM cleanup/display to swap to features mode
     * @param {Boolean} doTracking: whether to run tracking or not
     * The doTracking parameter is used to ensure tracking is not performed when
     * loading the page with a pre-set default display mode e.g. ?display=features
     */
    function switchToFeaturesMode(doTracking) {
        if (typeof doTracking == 'undefined') {
            doTracking = true;
        }
        // Confirm results is inited
        if (Results.getDisplayMode() === null) return;

        if (Results.getDisplayMode() !== 'features') {

            // On XS this will make the columns fit into the viewport. Necessary to do before pagination calculations.
            startColumnWidthTracking();

            // Double check that features mode fits into viewport

            _.defer(function () {
                Results.pagination.gotoPage(1);
                if (meerkat.modules.deviceMediaState.get() === 'xs') {
                    Results.view.setColumnWidth($(window), Results.settings.render.features.numberOfXSColumns, false);
                }
                Results.pagination.setupNativeScroll();
            });

            // Refresh XS pagination
            Results.pagination.show(true);
            $('header .xs-results-pagination').removeClass('hidden');
            $(document.body).removeClass('priceMode');
            $(window).scrollTop(0);
            if (doTracking) {
                meerkat.modules.resultsTracking.setResultsEventMode('Refresh');
                publishExtraSuperTagEvents();
            }
        }
    }

    function init() {

        $component = $("#resultsPage");

        meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);

    }

    meerkat.modules.register('lmiResults', {
        init: init,
        initPage: initPage,
        onReturnToPage: onReturnToPage,
        get: get,
        stopColumnWidthTracking: stopColumnWidthTracking,
        recordPreviousBreakpoint: recordPreviousBreakpoint,
        switchToFeaturesMode: switchToFeaturesMode,
        showNoResults: showNoResults,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents
    });

})(jQuery);
