/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {
        roadside: {},
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    }, steps = null;
    function initRoadside() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "roadside") return false;
            initJourneyEngine();
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
        }
        $(document).ready(function() {
            meerkat.modules.journeyEngine.configure({
                startStepId: startStepId,
                steps: _.toArray(steps)
            });
            if (meerkat.site.isNewQuote === false) {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "trackQuoteEvent",
                    object: {
                        action: "Retrieve",
                        vertical: meerkat.site.vertical
                    }
                });
            } else {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "trackQuoteEvent",
                    object: {
                        action: "Start",
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
            title: "Your Car",
            navigationId: "start",
            slideIndex: 0,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.roadside.getTrackingFieldsObject
            },
            onInitialise: function onStartInit(event) {}
        };
        var results = {
            title: "Roadside Quotes",
            navigationId: "results",
            slideIndex: 1,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.roadside.getTrackingFieldsObject
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.roadsideResults.initPage();
                meerkat.modules.roadsideMoreInfo.initMoreInfo();
                meerkat.modules.roadsideSorting.initSorting();
                meerkat.modules.partnerTransfer.initTransfer();
            },
            onBeforeEnter: function enterResultsStep(event) {
                Results.removeSelectedProduct();
                meerkat.modules.resultsTracking.setResultsEventMode("Load");
                $("#resultsPage").addClass("hidden");
                meerkat.modules.roadsideSorting.resetToDefaultSort();
            },
            onAfterEnter: function afterEnterResults(event) {
                if (event.isForward === true) {
                    meerkat.modules.roadsideResults.get();
                }
            },
            onAfterLeave: function(event) {}
        };
        steps = {
            startStep: startStep,
            results: results
        };
    }
    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([ {
            label: "Your Car",
            navigationId: steps.startStep.navigationId
        }, {
            label: "Roadside Quotes",
            navigationId: steps.results.navigationId
        } ]);
    }
    function trackHandover() {
        var product = Results.getSelectedProduct();
        var transaction_id = meerkat.modules.transactionId.get();
        meerkat.modules.partnerTransfer.trackHandoverEvent({
            product: product,
            type: "ONLINE",
            quoteReferenceNumber: transaction_id,
            productID: product.productId,
            productName: product.provider,
            productBrandCode: product.brandCode
        }, {
            type: "A",
            productId: product.productId
        });
    }
    function getTrackingFieldsObject(special_case) {
        try {
            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furthest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();
            var state = $("#roadside_riskAddress_state").val(), yearOfManufacture = $("#roadside_vehicle_year").val(), makeOfCar = $("#roadside_vehicle_makeDes").val(), actionStep = "";
            switch (current_step) {
              case 0:
                actionStep = "roadside your car";
                break;

              case 1:
                if (special_case === true) {
                    actionStep = "roadside more info";
                } else {
                    actionStep = "roadside results";
                }
                break;
            }
            var response = {
                actionStep: actionStep,
                quoteReferenceNumber: meerkat.modules.transactionId.get(),
                email: null,
                emailID: null,
                yearOfManufacture: null,
                makeOfCar: null,
                state: null,
                marketOptIn: null,
                okToCall: null
            };
            if (furthest_step > meerkat.modules.journeyEngine.getStepIndex("start")) {
                _.extend(response, {
                    yearOfManufacture: yearOfManufacture,
                    makeOfCar: makeOfCar,
                    state: state,
                    marketOptIn: null,
                    okToCall: null
                });
            }
            return response;
        } catch (e) {
            return {};
        }
    }
    meerkat.modules.register("roadside", {
        init: initRoadside,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject,
        trackHandover: trackHandover
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var events = {
        roadsideMoreInfo: {}
    }, moduleEvents = events.roadsideMoreInfo;
    var $bridgingContainer = $(".bridgingContainer"), callbackModalId, scrollPosition;
    function initMoreInfo() {
        var options = {
            container: $bridgingContainer,
            hideAction: "fadeOut",
            showAction: "fadeIn",
            modalOptions: {
                className: "modal-breakpoint-wide modal-tight bridgingContainer",
                openOnHashChange: false,
                leftBtn: {
                    label: "All Products",
                    icon: '<span class="icon icon-arrow-left"></span>',
                    callback: function(eventObject) {
                        $(eventObject.currentTarget).closest(".modal").modal("hide");
                    }
                }
            },
            runDisplayMethod: runDisplayMethod,
            onBeforeShowBridgingPage: null,
            onBeforeShowTemplate: null,
            onBeforeShowModal: onBeforeShowModal,
            onAfterShowModal: trackProductView,
            onAfterShowTemplate: null,
            onBeforeHideTemplate: null,
            onAfterHideTemplate: null,
            onClickApplyNow: onClickApplyNow,
            onBeforeApply: null,
            onApplySuccess: null,
            retrieveExternalCopy: retrieveExternalCopy,
            additionalTrackingData: {
                productName: null
            }
        };
        meerkat.modules.moreInfo.initMoreInfo(options);
    }
    function setScrollPosition() {
        scrollPosition = $(window).scrollTop();
    }
    function runDisplayMethod(productId) {
        meerkat.modules.moreInfo.showModal();
        meerkat.modules.address.appendToHash("moreinfo");
    }
    function retrieveExternalCopy(product) {
        return $.Deferred(function(dfd) {
            product.termsLink = $(product.subTitle).attr("href");
            var array = [];
            for (var key in product.info) {
                array.push([ product.info[key].desc, key ]);
            }
            product.sortOrder = array.sort();
            meerkat.modules.moreInfo.setDataResult(product);
            return dfd.resolveWith(this, [ product ]).promise();
        });
    }
    function onClickApplyNow(product, applyNowCallback) {
        Results.model.setSelectedProduct($(".btn-more-info-apply").attr("data-productId"));
        meerkat.modules.roadside.trackHandover();
        meerkat.modules.journeyEngine.gotoPath("next");
    }
    function trackProductView() {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteForms",
            object: _.bind(meerkat.modules.roadside.getTrackingFieldsObject, this, true)
        });
    }
    function onBeforeShowModal(product) {
        var settings = {
            additionalTrackingData: {
                productName: product.des
            }
        };
        meerkat.modules.moreInfo.updateSettings(settings);
    }
    meerkat.modules.register("roadsideMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        runDisplayMethod: runDisplayMethod,
        setScrollPosition: setScrollPosition,
        retrieveExternalCopy: retrieveExternalCopy
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        RESULTS_ERROR: "RESULTS_ERROR"
    };
    var $component;
    function initPage() {
        initResults();
        eventSubscriptions();
    }
    function initResults() {
        try {
            Results.init({
                url: "ajax/json/sar_quote_results.jsp",
                runShowResultsPage: false,
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
                    nonAvailableProducts: false,
                    unavailableCombined: true
                },
                availability: {
                    product: [ "equals", "Y" ]
                },
                render: {
                    templateEngine: "_",
                    dockCompareBar: false
                },
                displayMode: "price",
                pagination: {
                    touchEnabled: false
                },
                sort: {
                    sortBy: "price.premium",
                    sortDir: "asc"
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
                rankings: {
                    triggers: [ "RESULTS_DATA_READY" ],
                    callback: rankingCallback,
                    forceIdNumeric: false,
                    filterUnavailableProducts: true
                }
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred initialising page", "results.tag", "meerkat.modules.utilitiesResults.initResults(); " + e.message, e);
        }
    }
    function massageResultsObject(products) {
        if (_.isArray(products) && products.length > 0 && _.isArray(products[0])) {
            products = [ {
                productAvailable: "N"
            } ];
            return products;
        }
        _.each(products, function massageJson(result, index) {
            result.brandCode = result.provider;
        });
        return products;
    }
    function rankingCallback(product, position) {
        var data = {};
        data["rank_productId" + position] = product.productId;
        return data;
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
            Results.model.returnedProducts = massageResultsObject(Results.model.returnedProducts);
            Results.model.sortedProducts = Results.model.returnedProducts;
        });
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            $component.css("margin-top", "8px");
        });
        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            $component.css("margin-top", "0");
        });
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
            Results.view.show();
        });
        meerkat.messaging.subscribe(events.RESULTS_ERROR, function resultsError() {
            _.delay(function() {
                meerkat.modules.journeyEngine.gotoPath("previous");
            }, 1e3);
        });
        $(document).on("resultsReturned", function() {
            meerkat.modules.utils.scrollPageTo($("header"));
        });
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.modules.journeyEngine.loadingShow("...getting your quotes...");
            $component.removeClass("hidden");
            Results.pagination.hide();
        });
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            $(Results.settings.elements.page).show();
            meerkat.modules.journeyEngine.loadingHide();
            $(document.body).addClass("priceMode");
            var availableCounts = 0;
            $.each(Results.model.returnedProducts, function() {
                if (this.available === "Y") {
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
        $(Results.settings.elements.resultsContainer).on("click", ".result-row", resultRowClick);
        $(document.body).on("click", ".btn-apply", enquireNowClick);
    }
    function enquireNowClick(event) {
        event.preventDefault();
        var $resultrow = $(event.target);
        if ($resultrow.hasClass("result-row") === false) {
            $resultrow = $resultrow.parents(".result-row");
        }
        if (typeof $resultrow.attr("data-available") === "undefined" || $resultrow.attr("data-available") !== "Y") return;
        if ($resultrow.attr("data-productId")) {
            Results.setSelectedProduct($resultrow.attr("data-productId"));
        }
        meerkat.modules.roadside.trackHandover();
        meerkat.modules.moreInfo.setProduct(Results.getResult("productId", $resultrow.attr("data-productId")));
        meerkat.modules.roadsideMoreInfo.retrieveExternalCopy(Results.getSelectedProduct()).done(function() {
            meerkat.modules.journeyEngine.gotoPath("next", $resultrow.find(".btn-apply"));
        });
    }
    function resultRowClick(event) {
        if ($(Results.settings.elements.resultsContainer).hasClass("priceMode") === false) return;
        if (meerkat.modules.deviceMediaState.get() !== "xs") return;
        var $resultrow = $(event.target);
        if ($resultrow.hasClass("result-row") === false) {
            $resultrow = $resultrow.parents(".result-row");
        }
        if (typeof $resultrow.attr("data-available") === "undefined" || $resultrow.attr("data-available") !== "Y") return;
        meerkat.modules.moreInfo.setProduct(Results.getResult("productId", $resultrow.attr("data-productId")));
        meerkat.modules.roadsideMoreInfo.runDisplayMethod();
    }
    function get() {
        Results.get();
    }
    function showNoResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $("#no-results-content")[0].outerHTML
        });
    }
    function publishExtraSuperTagEvents(additionalData) {
        additionalData = typeof additionalData === "undefined" ? {} : additionalData;
        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: $.extend({
                sortBy: Results.getSortBy() + "-" + Results.getSortDir()
            }, additionalData),
            onAfterEventMode: "Refresh"
        });
    }
    function init() {
        $(document).ready(function() {
            $component = $("#resultsPage");
            meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
        });
    }
    meerkat.modules.register("roadsideResults", {
        init: init,
        initPage: initPage,
        get: get,
        showNoResults: showNoResults,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, error = meerkat.logging.error, $sortElements, defaultSortStates = {
        "price.premium": "asc",
        "info.roadCall": "desc",
        "info.keyService": "desc"
    }, sortByMethods = {
        "price.premium": null,
        "info.roadCall": null,
        "info.keyService": null
    };
    var events = {
        roadsideSorting: {
            CHANGED: "ROADSIDE_SORTING_CHANGED"
        }
    }, moduleEvents = events.roadsideSorting;
    function setSortFromTarget($elem) {
        var sortType = $elem.attr("data-sort-type");
        var sortDir = $elem.attr("data-sort-dir");
        if (typeof sortType !== "undefined" && typeof sortDir !== "undefined") {
            if (sortType === Results.getSortBy() && sortDir === Results.getSortDir()) {
                sortDir = sortDir === "asc" ? "desc" : "asc";
                $elem.attr("data-sort-dir", sortDir);
            }
            Results.setSortByMethod(sortByMethods[sortType]);
            var sortByResult = Results.sortBy(sortType, sortDir);
            if (sortByResult) {
                $sortElements.parent("li").removeClass("active");
                $elem.parent("li").addClass("active");
                meerkat.modules.resultsTracking.setResultsEventMode("Refresh");
                meerkat.modules.roadsideResults.publishExtraSuperTagEvents({
                    products: [],
                    recordRanking: "N"
                });
            } else {
                error("[roadsideSorting]", "The sortBy or sortDir could not be set", setSortByReturn, setSortDirReturn);
            }
        } else {
            error("[roadsideSorting]", "No data on sorting element");
            meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);
        }
    }
    function initSorting() {
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, function sortedCallback(obj) {
            meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);
        });
        $sortElements.on("click", function sortingClickHandler(event) {
            var $clicked = $(event.target);
            if (!$clicked.is("a")) {
                $clicked = $clicked.closest("a");
            }
            if (!$clicked.hasClass("disabled")) {
                meerkat.messaging.publish(meerkatEvents.WEBAPP_LOCK);
                _.defer(function deferredSortClickWrapper() {
                    if (!$clicked.parent().hasClass("active")) {
                        resetSortDir($clicked);
                    }
                    setSortFromTarget($clicked);
                });
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockSorting(obj) {
            $sortElements.addClass("inactive disabled");
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockSorting(obj) {
            $sortElements.removeClass("inactive disabled");
        });
    }
    function resetSortDir($elem) {
        var sortType = $elem.attr("data-sort-type");
        $elem.attr("data-sort-dir", defaultSortStates[sortType]);
    }
    function init() {
        $(document).ready(function roadsideSortingInitDomready() {
            $sortElements = $("[data-sort-type]");
        });
    }
    function resetToDefaultSort() {
        var $priceSortEl = $("[data-sort-type='price.premium']");
        var sortBy = Results.getSortBy(), price = "price.premium";
        if (sortBy != price || $priceSortEl.attr("data-sort-dir") == "desc" && sortBy == price) {
            $priceSortEl.parent("li").siblings().removeClass("active").end().addClass("active").end().attr("data-sort-dir", "desc");
            Results.setSortBy("price.premium");
            Results.setSortDir("desc");
        }
    }
    meerkat.modules.register("roadsideSorting", {
        init: init,
        initSorting: initSorting,
        events: events,
        resetToDefaultSort: resetToDefaultSort
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        roadsideVehicleMake: {}
    }, moduleEvents = events.roadsideVehicleMake;
    var makeData, $makeElement;
    function initRoadsideVehicleMake() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "roadside") {
                return;
            }
            makeData = meerkat.site.vehicleSelectionDefaults.data;
            $makeElement = $("#roadside_vehicle_make");
            applyEventListeners();
            renderSelectionMenu("makes");
        });
    }
    function applyEventListeners() {
        var $makeDes = $("#" + $makeElement.attr("id") + "Des");
        $makeElement.on("change", function() {
            if ($(this).val() !== "") {
                $makeDes.val($(this).find("option:selected").text());
            }
        });
    }
    function renderSelectionMenu(type) {
        if (typeof makeData === "undefined" || typeof makeData.makes === "undefined") {
            return;
        }
        var obj = meerkat.site.vehicleSelectionDefaults, selected, options = [];
        if (obj.hasOwnProperty(type) && obj[type] !== "") {
            selected = obj[type];
        }
        options.push($("<option/>", {
            text: "Please choose...",
            value: ""
        }));
        options.push($("<optgroup/>", {
            label: "Top Makes"
        }));
        options.push($("<optgroup/>", {
            label: "All Makes"
        }));
        for (var key in makeData.makes) {
            if (!makeData.makes.hasOwnProperty(key)) {
                continue;
            }
            var item = makeData.makes[key], option;
            option = $("<option/>", {
                text: item.label,
                value: item.code
            });
            if (selected == item.code) {
                option.prop("selected", true);
            }
            if (item.isTopMake === true) {
                option.appendTo(options[1], options[2]);
            } else {
                options[2].append(option);
            }
        }
        for (var o = 0; o < options.length; o++) {
            $makeElement.append(options[o]);
        }
        if (selected !== "") {
            $makeElement.trigger("change");
        }
    }
    meerkat.modules.register("roadsideVehicleMake", {
        init: initRoadsideVehicleMake,
        events: events
    });
})(jQuery);