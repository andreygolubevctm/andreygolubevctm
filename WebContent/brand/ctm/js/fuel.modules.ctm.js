/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {
        fuel: {},
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    }, steps = null;
    var skipToResults = false;
    function initFuel() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "fuel") return false;
            meerkat.modules.fuelPrefill.setHashArray();
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
        if (meerkat.site.isFromBrochureSite === true && meerkat.modules.address.getWindowHashAsArray().length === 1) {
            startStepId = steps.startStep.navigationId;
            skipToResults = true;
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
            title: "Fuel Details",
            navigationId: "start",
            slideIndex: 0,
            validation: {
                validate: true
            },
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.fuel.getTrackingFieldsObject
            },
            onInitialise: function() {
                meerkat.modules.fuelPrefill.initFuelPrefill();
            },
            onAfterEnter: function() {
                if (skipToResults) {
                    meerkat.modules.journeyEngine.gotoPath("next");
                    skipToResults = false;
                }
            }
        };
        var resultsStep = {
            title: "Fuel Prices",
            navigationId: "results",
            slideIndex: 1,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.fuel.getTrackingFieldsObject
            },
            additionalHashInfo: function() {
                var fuelTypes = $("#fuel_hidden").val(), location = $("#fuel_location").val().replace(/\s/g, "+");
                return location + "/" + fuelTypes;
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.fuelResults.initPage();
                meerkat.modules.fuelSorting.initSorting();
                meerkat.modules.fuelResultsMap.initFuelResultsMap();
                meerkat.modules.fuelCharts.initFuelCharts();
            },
            onAfterEnter: function afterEnterResults(event) {
                meerkat.modules.fuelResults.get();
                meerkat.modules.fuelResultsMap.resetMap();
            }
        };
        steps = {
            startStep: startStep,
            resultsStep: resultsStep
        };
    }
    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([ {
            label: "Fuel Details",
            navigationId: steps.startStep.navigationId
        }, {
            label: "Fuel Prices",
            navigationId: steps.resultsStep.navigationId
        } ]);
    }
    function getTrackingFieldsObject(special_case) {
        try {
            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furthest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();
            var location = $("#fuel_location").val().split(" "), actionStep = "";
            switch (current_step) {
              case 0:
                actionStep = "fuel details";
                break;

              case 1:
                if (special_case === true) {
                    actionStep = "fuel more info";
                } else {
                    actionStep = "fuel results";
                }
                break;
            }
            var response = {
                actionStep: actionStep,
                quoteReferenceNumber: meerkat.modules.transactionId.get()
            };
            if (furthest_step > meerkat.modules.journeyEngine.getStepIndex("start")) {
                _.extend(response, {
                    state: location[location.length - 1],
                    postcode: location[location.length - 2]
                });
            }
            return response;
        } catch (e) {
            return {};
        }
    }
    meerkat.modules.register("fuel", {
        init: initFuel,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        fuelCharts: {}
    }, moduleEvents = events.fuelCharts, modalTemplate, modalId, chart, chartData, chartOptions;
    function initChartsApi() {
        google.load("visualization", "1", {
            packages: [ "corechart", "line" ],
            callback: drawChart
        });
    }
    function getChart() {
        return chart;
    }
    function initFuelCharts() {
        $(document).ready(function() {
            applyEventListeners();
            modalTemplate = _.template($("#price-chart-template").html());
        });
    }
    function applyEventListeners() {
        $(".openPriceHistory").click(function() {
            initChartsApi();
        });
        meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, function() {
            if (typeof google !== "undefined" && chartData && chartOptions && $(".fuelChart").length) {
                chart = new google.visualization.LineChart(document.getElementById("linechart_material"));
                chart.draw(chartData, chartOptions);
            }
        });
    }
    function squashDifferentFuelTypesToSingleDateArray(results) {
        return results.filter(function(element, index, array) {
            for (var i = 0; i < array.length; i++) {
                if (typeof array[i].amountObj == "undefined") {
                    array[i].amountObj = {};
                    array[i].amountObj[array[i].type] = array[i].amount;
                }
                if (i == index) {
                    return true;
                }
                if (array[i].period == element.period) {
                    array[i].amountObj[element.type] = element.amount;
                    return false;
                }
            }
            return true;
        });
    }
    function getChartTitle() {
        var title = "Average daily prices <span class='hidden-xs'>for selected fuel types in and</span> around ";
        var location = $("#fuel_location").val();
        if (isNaN(location.substring(1, 5))) {
            title += location;
        } else {
            title += "the postcode: " + location;
        }
        return title;
    }
    var getFuelLabel = function(fuelid) {
        var labels = [ "Unknown", "Unknown", "Unleaded", "Diesel", "LPG", "Premium Unleaded 95", "E10", "Premium Unleaded 98", "Bio-Diesel 20", "Premium Diesel" ];
        return labels[fuelid];
    };
    function drawChart() {
        createModal(function(modalId) {
            meerkat.modules.loadingAnimation.showInside($("#linechart_material"), true);
            var selectedFuelTypes = $("#fuel_hidden").val().split(",");
            if (selectedFuelTypes.indexOf("3") != -1 && selectedFuelTypes.indexOf("9") == -1) {
                selectedFuelTypes.push("9");
            }
            meerkat.modules.comms.post({
                url: "ajax/json/fuel_price_monthly_averages.jsp",
                cache: true,
                data: meerkat.modules.form.getSerializedData($("#mainform")),
                errorLevel: "warning",
                onSuccess: function onPriceHistorySuccess(result) {
                    chartData = new google.visualization.DataTable();
                    chartData.addColumn("date", "Date");
                    chartData.addColumn("number", getFuelLabel(selectedFuelTypes[0]));
                    if (selectedFuelTypes[1]) {
                        chartData.addColumn("number", getFuelLabel(selectedFuelTypes[1]));
                    }
                    if (selectedFuelTypes[2]) {
                        chartData.addColumn("number", getFuelLabel(selectedFuelTypes[2]));
                    }
                    var prices = squashDifferentFuelTypesToSingleDateArray(result.results.prices);
                    for (var dataSet = [], i = 0; i < prices.length; i++) {
                        var row = [ new Date(prices[i].period), Number(prices[i].amountObj[selectedFuelTypes[0]]) / 10 ];
                        if (selectedFuelTypes[1]) {
                            row.push(Number(prices[i].amountObj[selectedFuelTypes[1]]) / 10);
                        }
                        if (selectedFuelTypes[2]) {
                            row.push(Number(prices[i].amountObj[selectedFuelTypes[2]]) / 10);
                        }
                        dataSet.push(row);
                    }
                    chartData.addRows(dataSet);
                    chartOptions = {
                        height: 400,
                        legend: {
                            position: "bottom"
                        },
                        axisTitlesPosition: "out",
                        hAxis: {
                            title: "Collected Date",
                            format: "EEE, MMM d"
                        },
                        tooltip: {
                            trigger: "focus"
                        },
                        fontName: "Source Sans Pro",
                        explorer: {
                            axis: "horizontal",
                            actions: [ "dragToZoom", "rightClickToReset" ],
                            keepInBounds: true
                        },
                        vAxis: {
                            title: "Price Per Litre",
                            format: "###.#",
                            gridlines: {
                                color: "#b2b2b2",
                                count: -1
                            }
                        },
                        chartArea: {
                            top: 0
                        },
                        colors: [ "#1c3e93", "#0db14b", "#b2b2b2" ]
                    };
                    chart = new google.visualization.LineChart(document.getElementById("linechart_material"));
                    chart.draw(chartData, chartOptions);
                    runTrackingCall(selectedFuelTypes);
                }
            });
        });
    }
    function runTrackingCall(selectedFuelTypes) {
        var location = $("#fuel_location").val().split(" ");
        for (var out = "", i = 0; i < selectedFuelTypes.length; i++) {
            out += ":" + getFuelLabel(selectedFuelTypes[i]);
        }
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackCustomPage",
            object: {
                customPage: "Fuel:PriceHistory" + out,
                state: location[location.length - 1],
                postcode: location[location.length - 2]
            }
        });
    }
    function createModal(onOpen) {
        var options = {
            htmlContent: modalTemplate({}),
            hashId: "chart",
            className: "fuelChart",
            onOpen: onOpen,
            title: getChartTitle()
        };
        modalId = meerkat.modules.dialogs.show(options);
    }
    function _handleError(e, page) {
        meerkat.modules.errorHandling.error({
            errorLevel: "warning",
            message: "An error occurred with loading the Fuel Price History. Please reload the page and try again.",
            page: page,
            description: "[Google Charts] Error Initialising API",
            data: {
                error: e.toString()
            },
            id: meerkat.modules.transactionId.get()
        });
    }
    meerkat.modules.register("fuelCharts", {
        initFuelCharts: initFuelCharts,
        events: events,
        getChart: getChart
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatModules = meerkat.modules, meerkatEvents = meerkatModules.events, log = meerkat.logging.info;
    var $checkboxes;
    function initFuelDetails() {
        $(document).ready(function() {
            $checkboxes = $("#checkboxes-all input");
            _registerEventListeners();
        });
    }
    function _registerEventListeners() {
        $(document).on("change", "#checkboxes-all input", _onChangeCheckbox);
    }
    function _onChangeCheckbox(e) {
        var $unchecked = $checkboxes.filter(":not(:checked)"), $checked = $checkboxes.filter(":checked");
        if ($checked.length >= 2) $unchecked.attr("disabled", "disabled"); else $checkboxes.removeAttr("disabled");
        var checkedValues = $checked.map(function() {
            return this.value;
        }).get().join(",");
        $("#fuel_hidden").val(checkedValues);
        $("label[for='fuel_hidden']").remove();
        $checkboxes.removeClass("has-error");
    }
    meerkat.modules.register("fuelDetails", {
        init: initFuelDetails
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatModules = meerkat.modules, meerkatEvents = meerkatModules.events, log = meerkat.logging.info;
    var hashArray, mapLoaded = false;
    function initFuelPrefill() {
        _registerSubscriptions();
        _eventDelegates();
    }
    function setHashArray() {
        hashArray = meerkat.modules.address.getWindowHashAsArray();
    }
    function _registerSubscriptions() {
        _populateInputs();
    }
    function _eventDelegates() {
        $(document).on("resultsAnimated", _findMap);
    }
    function _findMap() {
        if (mapLoaded === false && hashArray.length >= 4 && hashArray[3].match(/^(map-)/g)) {
            var siteId = hashArray[3].replace("map-", "");
            meerkat.modules.fuelResultsMap.openMap($(document).find("a[data-siteid='" + siteId + "']").first());
            mapLoaded = true;
        }
    }
    function _populateInputs() {
        if (typeof meerkat.site.formData !== "undefined" || hashArray.length >= 3) {
            _setFuelType();
            _setLocation();
        }
    }
    function _setFuelType() {
        var fuelType;
        if (typeof hashArray[2] !== "undefined") fuelType = hashArray[2]; else if (typeof meerkat.site.formData !== "undefined" && typeof meerkat.site.formData.fuelType !== "undefined") fuelType = meerkat.site.formData.fuelType;
        if (typeof fuelType !== "undefined") {
            var isCustomSelection = fuelType.match(/\d,?\d?/g);
            if (isCustomSelection) {
                var selected = fuelType.split(",").slice(0, 2);
                $("#checkboxes-all .checkbox-custom").each(function() {
                    for (var i = 0; i < selected.length; i++) {
                        var $this = $(this);
                        if ($this.val() === selected[i]) $this.trigger("click");
                    }
                });
            } else {
                var fuelTypeId;
                switch (fuelType) {
                  case "P":
                    fuelTypeId = "petrol";
                    break;

                  case "D":
                    fuelTypeId = "diesel";
                    break;

                  case "L":
                    fuelTypeId = "lpg";
                    break;

                  default:
                    return;
                }
                $("#checkboxes-" + fuelTypeId).find(".checkbox-custom").slice(0, 2).trigger("click");
            }
        }
    }
    function _setLocation() {
        var location;
        if (typeof hashArray[1] !== "undefined" && hashArray[1].substr(0, 7) !== "?stage=") location = hashArray[1].replace(/\+/g, " "); else if (typeof meerkat.site.formData !== "undefined" && typeof meerkat.site.formData.location !== "undefined") location = meerkat.site.formData.location;
        if (location !== "undefined") $("#fuel_location").val(location);
    }
    meerkat.modules.register("fuelPrefill", {
        initFuelPrefill: initFuelPrefill,
        setHashArray: setHashArray
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatModules = meerkat.modules, meerkatEvents = meerkatModules.events, log = meerkat.logging.info;
    var events = {};
    function initPage() {
        _initResults();
        _registerEventListeners();
    }
    function _initResults() {
        try {
            var displayMode = "price";
            Results.init({
                url: "ajax/json/fuel_price_results.jsp",
                runShowResultsPage: false,
                paths: {
                    results: {
                        list: "results.price",
                        general: "results.general"
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
                    nonAvailableProducts: false,
                    unavailableCombined: true
                },
                availability: {
                    product: [ "equals", "Y" ],
                    price: [ "notEquals", -1 ]
                },
                render: {
                    templateEngine: "_",
                    dockCompareBar: false
                },
                displayMode: displayMode,
                pagination: {
                    mode: "page",
                    touchEnabled: Modernizr.touch
                },
                sort: {
                    sortBy: "price.premium",
                    city: "sort.city"
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
                rankings: {
                    triggers: [ "RESULTS_DATA_READY" ],
                    callback: _rankingCallback,
                    forceIdNumeric: false,
                    filterUnavailableProducts: true
                },
                incrementTransactionId: false
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred initialising page", "results.tag", "meerkat.modules.fuel.initResults(); " + e.message, e);
        }
    }
    function _rankingCallback(product, position) {
        var data = {};
        data["rank_premium" + position] = product.price;
        data["rank_productId" + position] = product.productId;
        return data;
    }
    function _registerEventListeners() {
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
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
            Results.view.show();
        });
        $(document).on("resultsReturned", function() {
            meerkat.modules.utils.scrollPageTo($("header"));
            _updateDisclaimer();
        });
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            $("#resultsPage, .loadingDisclaimerText").removeClass("hidden");
        });
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            $(".loadingDisclaimerText").addClass("hidden");
            $(document.body).removeClass("priceMode").addClass("priceMode");
            var availableCounts = 0;
            $.each(Results.model.returnedProducts, function() {
                if (this.available === "Y" && this.productId !== "CURR") {
                    availableCounts++;
                }
            });
            if (availableCounts === 0 && !Results.model.hasValidationErrors && Results.model.isBlockedQuote) {
                showBlockedResults();
                return;
            }
            if (availableCounts === 0 && _.isArray(Results.model.returnedProducts)) {
                showNoResults();
                _.delay(function() {
                    meerkat.modules.journeyEngine.gotoPath("previous");
                }, 1e3);
                return;
            }
            if (Results.getReturnedGeneral().source == "regional") {
                Results.view.showNoResults();
                _openRegionalModal();
                return;
            }
            $(Results.settings.elements.page).show();
        });
        $(Results.settings.elements.resultsContainer).on("click", ".result-row", _onResultRowClick);
    }
    function _onResultRowClick(event) {
        if ($(Results.settings.elements.resultsContainer).hasClass("priceMode") === false || meerkat.modules.deviceMediaState.get() !== "xs") return;
        var $resultrow = $(event.target);
        if ($resultrow.hasClass("result-row") === false) {
            $resultrow = $resultrow.parents(".result-row");
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
        if (typeof general.timeDiff !== "undefined") {
            $("#provider-disclaimer .time").text(general.timeDiff);
        }
    }
    function _updateSnapshot() {
        var fuelTypeArray = [];
        $("#checkboxes-all :checked").each(function() {
            var pushValue = "<strong>" + $.trim($(this).next("label").text()) + "</strong>";
            fuelTypeArray.push(pushValue);
        });
        var fuelTypes = fuelTypeArray.join(" &amp; "), location = $("#fuel_location").val(), data = {
            fuelTypes: fuelTypes,
            location: location
        }, template = _.template($("#snapshot-template").html(), data, {
            variable: "data"
        });
        $("#resultsSummaryPlaceholder").html(template);
    }
    function init() {}
    function _openRegionalModal() {
        var $tpl = $("#regional-results-template"), htmlString = "";
        if ($tpl.length > 0) {
            var htmlTemplate = _.template($tpl.html());
            Results.sortBy(Results.settings.sort.city, "asc");
            htmlString = htmlTemplate(Results.getSortedResults());
        }
        if (htmlString.length) {
            meerkat.modules.dialogs.show({
                title: "Regional Price Average",
                htmlContent: htmlString
            });
        } else {
            showNoResults();
        }
        _.delay(function() {
            meerkat.modules.journeyEngine.gotoPath("previous");
        }, 1e3);
    }
    function showNoResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $("#no-results-content")[0].outerHTML
        });
    }
    function showBlockedResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $("#blocked-ip-address")[0].outerHTML
        });
    }
    function getFormattedTimeAgo(date) {
        return "Last updated " + meerkat.modules.utils.getTimeAgo(date) + " ago";
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
    meerkat.modules.register("fuelResults", {
        init: init,
        initPage: initPage,
        events: events,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents,
        get: get,
        getFormattedTimeAgo: getFormattedTimeAgo
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        fuelResultsMap: {}
    }, moduleEvents = events.fuelResultsMap;
    var googleAPIKey = "AIzaSyC8ygWPujOpSI1O-7jsiyG3_YIDlPoIP6U";
    var map;
    var infoWindow;
    var markers = {};
    var currentLat, currentLng;
    var markerTemplate, modalId, siteId, modalTemplate, windowResizeListener;
    function initGoogleAPI() {
        if (typeof map !== "undefined") {
            return;
        }
        var script = document.createElement("script");
        script.type = "text/javascript";
        script.src = "https://maps.googleapis.com/maps/api/js?key=" + googleAPIKey + "&v=3.exp" + "&signed_in=false&callback=meerkat.modules.fuelResultsMap.initCallback";
        script.onerror = function(msg, url, linenumber) {
            _handleError(msg + ":" + linenumber, "fuelResultsMap.js:initGoogleAPI");
        };
        document.body.appendChild(script);
    }
    function initCallback() {
        try {
            var mapOptions = {
                zoom: 15,
                minZoom: 11,
                center: createLatLng(currentLat, currentLng),
                mapTypeId: google.maps.MapTypeId.ROAD,
                mapTypeControlOptions: {
                    style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
                }
            };
            createModal();
            map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
            infoWindow = new google.maps.InfoWindow();
            plotMarkers();
        } catch (e) {
            _handleError(e, "fuelResultsMap.js:initCallback");
        }
    }
    function initFuelResultsMap() {
        $(document).ready(function($) {
            applyEventListeners();
            markerTemplate = _.template($("#map-marker-template").html());
            modalTemplate = _.template($("#google-map-canvas-template").html());
        });
    }
    function applyEventListeners() {
        $(document).on("click", ".map-open", function() {
            openMap($(this));
        });
    }
    function openMap($el) {
        currentLat = $el.data("lat");
        currentLng = $el.data("lng");
        Results.setSelectedProduct($el.attr("data-productid"));
        if (typeof map === "undefined") {
            initGoogleAPI();
        } else {
            if (!_.keys(markers).length) {
                plotMarkers();
            }
            $("#" + modalId).modal("show");
            infoWindow.close();
            var product = Results.getSelectedProduct();
            siteId = product.siteid;
            meerkat.modules.address.appendToHash("map-" + siteId);
            if (product) {
                openInfoWindow(markers[product.siteid], product);
                centerMap(createLatLng(currentLat, currentLng));
            }
        }
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteForms",
            object: _.bind(meerkat.modules.fuel.getTrackingFieldsObject, this, true)
        });
    }
    function centerMap(LatLng) {
        map.panTo(LatLng);
    }
    function createLatLng(lat, lng) {
        return new google.maps.LatLng(parseFloat(lat), parseFloat(lng));
    }
    function plotMarkers() {
        var results = filterDuplicatesOut(Results.getFilteredResults());
        var bounds = new google.maps.LatLngBounds();
        var focusMarker, focusCoords, focusInfo;
        for (var selectedProduct = Results.getSelectedProduct(), i = 0; i < results.length; i++) {
            var latLng = createLatLng(results[i].lat, results[i].long);
            var marker = createMarker(latLng, results[i]);
            markers[results[i].siteid] = marker;
            if (results[i].siteid == selectedProduct.siteid) {
                openInfoWindow(marker, results[i]);
                focusMarker = marker;
                focusCoords = latLng;
                focusInfo = results[i];
            }
            bounds.extend(latLng);
        }
        map.fitBounds(bounds);
        if (focusMarker && focusCoords && focusInfo) {
            centerMap(focusCoords);
            openInfoWindow(focusMarker, focusInfo);
        }
    }
    function filterDuplicatesOut(results) {
        return results.filter(function(element, index, array) {
            for (var i = 0; i < array.length; i++) {
                if (i == index) {
                    return true;
                }
                if (array[i].siteid == element.siteid) {
                    if (!array[i].price2Text) {
                        array[i].price2Text = element.priceText;
                        array[i].price2 = element.price;
                        array[i].fuel2Text = element.fuelText;
                    } else {
                        array[i].price3Text = element.priceText;
                        array[i].price3 = element.price;
                        array[i].fuel3Text = element.fuelText;
                    }
                    return false;
                }
            }
            return true;
        });
    }
    function createMarker(latLng, info, markerOpts) {
        var marker = new google.maps.Marker({
            map: map,
            position: latLng,
            icon: "brand/ctm/graphics/fuel/map-pin.png",
            animation: google.maps.Animation.DROP
        });
        google.maps.event.addListener(marker, "click", function() {
            openInfoWindow(marker, info);
        });
        return marker;
    }
    function openInfoWindow(marker, info) {
        var htmlString = "";
        if (markerTemplate) {
            htmlString = markerTemplate(info);
            infoWindow.setContent(htmlString);
            infoWindow.open(map, marker);
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackProductView",
                object: {
                    productID: info.productId || null,
                    productBrandCode: info.provider || null,
                    productName: (info.name || "") + " " + (info.fuelText || "")
                }
            });
        } else {
            _handleError("", "An error occurred displaying information for this fuel provider.");
        }
    }
    function createModal() {
        var options = {
            htmlContent: modalTemplate(Results.getSelectedProduct()),
            hashId: "map-" + Results.getSelectedProduct().siteid,
            className: "googleMap",
            closeOnHashChange: false,
            destroyOnClose: false,
            onClose: onClose,
            onOpen: setMapHeight,
            fullHeight: true
        };
        modalId = meerkat.modules.dialogs.show(options);
        if (windowResizeListener) {
            google.maps.event.removeListener(windowResizeListener);
        }
        windowResizeListener = google.maps.event.addDomListener(window, "resize", function() {
            if (typeof google !== "undefined" && $("#" + modalId).length) {
                meerkat.modules.dialogs.resizeDialog(modalId);
                setMapHeight();
                google.maps.event.trigger(map, "resize");
                map.setCenter(createLatLng(currentLat, currentLng));
            }
        });
    }
    function onClose() {
        if (siteId) meerkat.modules.address.removeFromHash("map-" + siteId);
    }
    function setMapHeight() {
        _.defer(function() {
            var isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false, $modalContent = $(".googleMap .modal-body");
            var heightToSet = isXS ? $modalContent.css("height") : $modalContent.css("max-height");
            $("#google-map-container").css("height", heightToSet);
        });
    }
    function resetMap() {
        if (infoWindow) {
            infoWindow.close();
        }
        _clearMarkers();
    }
    function _clearMarkers() {
        var keys = _.keys(markers);
        if (!keys.length) {
            return;
        }
        for (var i = 0; i < keys.length; i++) {
            markers[keys[i]].setMap(null);
        }
        markers = {};
    }
    function getMap() {
        return map;
    }
    function _handleError(e, page) {
        meerkat.modules.errorHandling.error({
            errorLevel: "warning",
            message: "An error occurred with loading the Google Map. Please reload the page and try again.",
            page: page,
            description: "[Google Maps] Error Initialising Map",
            data: {
                error: e.toString()
            },
            id: meerkat.modules.transactionId.get()
        });
    }
    meerkat.modules.register("fuelResultsMap", {
        initFuelResultsMap: initFuelResultsMap,
        events: events,
        initCallback: initCallback,
        resetMap: resetMap,
        getMap: getMap,
        openMap: openMap
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatModules = meerkat.modules, meerkatEvents = meerkatModules.events, log = meerkat.logging.info;
    var $signUpForm;
    function initFuelSignup() {
        _registerEventListeners();
        $(document).ready(function() {
            $signUpForm = $("#sign-up-form");
            meerkat.modules.validation.setupDefaultValidationOnForm($signUpForm);
        });
    }
    function _registerEventListeners() {
        $(document).on("click", "#fuel_signup_terms, #fuel_signup_privacyoptin", _toggleCheckboxHidden).on("click", ".fuel-sign-up", _onClickFuelSignup);
    }
    function _toggleCheckboxHidden(e) {
        var $this = $(e.target), hiddenVal = $this.prop("checked") ? "Y" : "";
        $("#" + $this.attr("id") + "Hidden").val(hiddenVal).valid();
    }
    function _onClickFuelSignup() {
        if ($signUpForm.valid()) {
            var $promise = meerkat.modules.comms.post({
                errorLevel: "warning",
                url: "ajax/write/fuel_signup.jsp",
                dataType: "xml",
                data: $signUpForm.serialize()
            });
            $promise.done(function(xml) {
                var resultCode = $(xml).find("resultcode").text();
                if (resultCode === "0") {
                    _signupSuccess();
                } else {
                    _signupFail();
                }
            }).fail(_signupFail);
        }
    }
    function _signupSuccess() {
        var data = $signUpForm.serializeArray(), templateData = {};
        for (var i = 0; i < data.length; i++) {
            var current = data[i], name = current.name.match(/[a-zA-Z]{1,}$/g)[0];
            templateData[name] = current.value;
        }
        var html = _.template($("#signup-success-template").html(), templateData, {
            variable: "data"
        });
        $signUpForm.html(html);
    }
    function _signupFail() {
        $signUpForm.find(".form-submit-error-message").removeClass("hidden");
    }
    meerkat.modules.register("fuelSignup", {
        init: initFuelSignup
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, error = meerkat.logging.error, $sortElements, defaultSortStates = {
        "price.premium": "asc"
    }, sortByMethods = {
        "price.premium": null
    };
    var events = {
        fuelSorting: {
            CHANGED: "FUEL_SORTING_CHANGED"
        }
    }, moduleEvents = events.fuelSorting;
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
                meerkat.modules.fuelResults.publishExtraSuperTagEvents({
                    products: [],
                    recordRanking: "N"
                });
            } else {
                error("[fuelSorting]", "The sortBy or sortDir could not be set", setSortByReturn, setSortDirReturn);
            }
        } else {
            error("[fuelSorting]", "No data on sorting element");
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
        $(document).ready(function fuelSortingInitDomready() {
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
    meerkat.modules.register("fuelSorting", {
        init: init,
        initSorting: initSorting,
        events: events,
        resetToDefaultSort: resetToDefaultSort
    });
})(jQuery);