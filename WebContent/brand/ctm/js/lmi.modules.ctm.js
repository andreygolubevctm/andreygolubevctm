/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var moduleEvents = {
        lmi: {},
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    }, steps = null;
    function initLmi() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "carlmi" && meerkat.site.vertical !== "homelmi") {
                return false;
            }
            initJourneyEngine();
            if (meerkat.site.pageAction === "confirmation") {
                return false;
            }
            eventDelegates();
            if (meerkat.site.pageAction === "amend" || meerkat.site.pageAction === "latest" || meerkat.site.pageAction === "load" || meerkat.site.pageAction === "start-again") {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
        });
    }
    function eventDelegates() {}
    function initJourneyEngine() {
        initProgressBar(false);
        var startStepId = null;
        if (meerkat.site.isFromBrochureSite === true) {
            startStepId = steps.startStep.navigationId;
        } else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === "latest") {
            startStepId = steps.resultsStep.navigationId;
        } else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === "amend") {
            startStepId = steps.startStep.navigationId;
        }
        $(document).ready(function() {
            meerkat.modules.journeyEngine.configure({
                startStepId: startStepId,
                steps: _.toArray(steps)
            });
            var transaction_id = meerkat.modules.transactionId.get();
            if (meerkat.site.isNewQuote === false) {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "trackQuoteEvent",
                    object: {
                        action: "Retrieve",
                        transactionID: parseInt(transaction_id, 10),
                        vertical: meerkat.site.vertical
                    }
                });
            } else {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "trackQuoteEvent",
                    object: {
                        action: "Start",
                        transactionID: parseInt(transaction_id, 10),
                        vertical: meerkat.site.vertical
                    }
                });
            }
        });
    }
    function initProgressBar(render) {
        setJourneyEngineSteps();
        configureProgressBar();
        if (render) {
            meerkat.modules.journeyProgressBar.render(true);
        }
    }
    function setJourneyEngineSteps() {
        var startStep = {
            title: "Select Brands",
            navigationId: "start",
            slideIndex: 0,
            onInitialise: function() {
                if (meerkat.site.brands.length) {
                    var brands = meerkat.site.brands.split(",");
                    for (var i = 0; i < brands.length; i++) {
                        $("input[id=product" + brands[i] + "_check]").prop("checked", true);
                    }
                }
            },
            validation: {
                validate: true,
                customValidation: function(callback) {
                    var count = 0;
                    $("input[name=" + meerkat.site.vertical + "_brand]").each(function() {
                        if ($(this).prop("checked")) {
                            count++;
                        }
                    });
                    callback(count > 0);
                }
            }
        };
        var resultsStep = {
            title: "Compare Features",
            navigationId: "results",
            slideIndex: 1,
            onInitialise: function onResultsInit(event) {
                meerkat.modules.lmiResults.initPage();
            },
            onBeforeEnter: function enterResultsStep(event) {
                if (event.isForward === true) {
                    meerkat.modules.resultsTracking.setResultsEventMode("Load");
                    $("#resultsPage").addClass("hidden");
                }
            },
            onAfterEnter: function afterEnterResults(event) {
                if (event.isForward === true) {
                    meerkat.modules.lmiResults.get();
                }
            }
        };
        steps = {
            startStep: startStep,
            resultsStep: resultsStep
        };
    }
    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([ {
            label: "Select Brands",
            navigationId: steps.startStep.navigationId
        }, {
            label: "Compare Features",
            navigationId: steps.resultsStep.navigationId
        } ]);
    }
    meerkat.modules.register("lmi", {
        init: initLmi,
        events: moduleEvents,
        initProgressBar: initProgressBar
    });
})(jQuery);

(function($, undefined) {
    var $checkboxes;
    function initLmiForm() {
        $(document).ready(function() {
            $checkboxes = $("#startForm input[type='checkbox']");
            _registerEventListeners();
        });
    }
    function _registerEventListeners() {
        $(document).on("change", "#startForm input[type='checkbox']", _onClickCheckbox);
    }
    function _onClickCheckbox(e) {
        var $unchecked = $checkboxes.filter(":not(:checked)"), $checked = $checkboxes.filter(":checked");
        if ($checked.length >= 12) $unchecked.attr("disabled", "disabled"); else $checkboxes.removeAttr("disabled");
        $checkboxes.removeClass("has-error");
    }
    meerkat.modules.register("lmiForm", {
        init: initLmiForm,
        events: {}
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        RESULTS_ERROR: "RESULTS_ERROR"
    };
    meerkatEvents.lmiResults = {
        FEATURES_CALL_ACTION: "FEATURES_CALL_ACTION",
        FEATURES_CALL_ACTION_MODAL: "FEATURES_CALL_ACTION_MODAL",
        FEATURES_SUBMIT_CALLBACK: "FEATURES_SUBMIT_CALLBACK"
    };
    var $component;
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
            Results.init({
                url: "ajax/json/features/results.jsp?vertical=" + meerkat.site.vertical,
                runShowResultsPage: false,
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
                    nonAvailablePrices: true,
                    nonAvailableProducts: false,
                    unavailableCombined: false
                },
                availability: {
                    product: [ "equals", "Y" ]
                },
                render: {
                    templateEngine: "_",
                    features: {
                        mode: "populate",
                        headers: false,
                        numberOfXSColumns: 1
                    },
                    dockCompareBar: false
                },
                displayMode: "features",
                pagination: {
                    mode: "page",
                    touchEnabled: Modernizr.touch
                },
                sort: {
                    sortBy: "policyName"
                },
                animation: {
                    results: {
                        individual: {
                            active: false
                        },
                        delay: 500,
                        options: {
                            easing: "swing",
                            duration: 1e3
                        }
                    },
                    shuffle: {
                        active: true,
                        options: {
                            easing: "swing",
                            duration: 1e3
                        }
                    },
                    filter: {
                        reposition: {
                            options: {
                                easing: "swing"
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
                        pageText: "Product {{=currentPage}} of {{=totalPages}}"
                    }
                },
                dictionary: {
                    valueMap: [ {
                        key: "Y",
                        value: "<span class='icon icon-tick'></span>"
                    }, {
                        key: "N",
                        value: "<span class='icon icon-cross'></span>"
                    }, {
                        key: "R",
                        value: "Restricted / Conditional"
                    }, {
                        key: "AI",
                        value: "Additional Information"
                    }, {
                        key: "O",
                        value: "Optional"
                    }, {
                        key: "L",
                        value: "Limited"
                    }, {
                        key: "SCH",
                        value: "As shown in schedule"
                    }, {
                        key: "NA",
                        value: "Non Applicable"
                    }, {
                        key: "E",
                        value: "Excluded"
                    }, {
                        key: "NE",
                        value: "No Exclusion"
                    }, {
                        key: "NS",
                        value: "No Sub Limit"
                    }, {
                        key: "OTH",
                        value: ""
                    } ]
                },
                rankings: {
                    paths: {
                        rank_productId: "productId"
                    },
                    filterUnavailableProducts: false
                },
                incrementTransactionId: false
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred initialising page", "results.tag", "meerkat.modules.lmiResults.initResults(); " + e.message, e);
        }
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            $("#resultsPage").css("margin-top", "35px");
        });
        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            $("#resultsPage").css("margin-top", "0");
        });
        meerkat.messaging.subscribe(events.RESULTS_ERROR, function() {
            _.delay(function() {
                meerkat.modules.journeyEngine.gotoPath("previous");
            }, 1e3);
        });
        $(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function() {
            Features.buildHtml();
        });
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
            Results.view.show();
        });
        $(document).on("resultsLoaded", onResultsLoaded);
        $(document).on("resultsReturned", function() {
            meerkat.modules.utils.scrollPageTo($("header"));
            $(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");
        });
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.modules.journeyEngine.loadingShow("getting your quotes");
            $("#resultsPage").removeClass("hidden");
            Results.pagination.hide();
        });
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            $(Results.settings.elements.page).show();
            meerkat.modules.journeyEngine.loadingHide();
            Results.pagination.show();
        });
        $(document).on("populateFeaturesStart", function onPopulateFeaturesStart() {
            meerkat.modules.performanceProfiling.startTest("results");
            Features.featuresIds = [];
            $(".featuresTemplateComponent > .cell > .h.content").each(function() {
                var fid = $(this).attr("data-featureid");
                if ($.inArray(fid, Features.featuresIds) == -1) {
                    Features.featuresIds.push(fid);
                }
            });
        });
        $(Results.settings.elements.resultsContainer).on("populateFeaturesEnd", function onPopulateFeaturesEnd() {
            var time = meerkat.modules.performanceProfiling.endTest("results");
            var score;
            if (time < 800) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.HIGH;
            } else if (time < 8e3 && meerkat.modules.performanceProfiling.isIE8() === false) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.MEDIUM;
            } else {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.LOW;
            }
            Results.setPerformanceMode(score);
        });
        $(document).on("resultPageChange", function(event) {
            var pageData = event.pageData;
            if (pageData.measurements === null) return false;
            var items = Results.getFilteredResults().length;
            var columnsPerPage = pageData.measurements.columnsPerPage;
        });
        $(document).on("FeaturesRendered", function() {
            Features.removeEmptyDropdowns();
            $(Features.target + " .expandable > " + Results.settings.elements.features.values).off("mouseenter mouseleave").on("mouseenter", function() {
                var featureId = $(this).attr("data-featureId");
                var $hoverRow = $(Features.target + ' [data-featureId="' + featureId + '"]');
                $hoverRow.addClass(Results.settings.elements.features.expandableHover.replace(/[#\.]/g, ""));
            }).on("mouseleave", function() {
                var featureId = $(this).attr("data-featureId");
                var $hoverRow = $(Features.target + ' [data-featureId="' + featureId + '"]');
                $hoverRow.removeClass(Results.settings.elements.features.expandableHover.replace(/[#\.]/g, ""));
            });
        });
    }
    function breakpointTracking() {
        startColumnWidthTracking();
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter() {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results") {
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
        if (meerkat.modules.deviceMediaState.get() === "xs" && Results.getDisplayMode() === "features") {
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
    function get() {
        Results.get();
    }
    function onResultsLoaded() {
        startColumnWidthTracking();
        switchToFeaturesMode(false);
    }
    function showNoResults() {}
    function publishExtraSuperTagEvents() {
        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: {},
            onAfterEventMode: "Load"
        });
    }
    function switchToFeaturesMode(doTracking) {
        if (typeof doTracking == "undefined") {
            doTracking = true;
        }
        if (Results.getDisplayMode() === null) return;
        if (Results.getDisplayMode() !== "features") {
            var forceRefresh = needToBuildFeatures === true;
            Results.setDisplayMode("features", forceRefresh);
            startColumnWidthTracking();
            _.defer(function() {
                Results.pagination.gotoPage(1);
                if (meerkat.modules.deviceMediaState.get() === "xs") {
                    Results.view.setColumnWidth($(window), Results.settings.render.features.numberOfXSColumns, false);
                }
                Results.pagination.setupNativeScroll();
            });
            Results.pagination.show(true);
            $("header .xs-results-pagination").removeClass("hidden");
            needToBuildFeatures = false;
            $(document.body).removeClass("priceMode");
            $(window).scrollTop(0);
            if (doTracking) {
                meerkat.modules.resultsTracking.setResultsEventMode("Refresh");
                publishExtraSuperTagEvents();
            }
        }
    }
    function init() {
        $component = $("#resultsPage");
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
    }
    meerkat.modules.register("lmiResults", {
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