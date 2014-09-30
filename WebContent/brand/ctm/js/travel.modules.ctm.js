/*!
 * CTM-Platform v0.8.3
 * Copyright 2014 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, templateMoreInfo;
    var moduleEvents = {
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    };
    
    var steps = null;
    function initJourneyEngine() {
        $(document).ready(function() {
            setJourneyEngineSteps();
            var startStepId = null;
            if (meerkat.site.isFromBrochureSite === true) {
                startStepId = steps.detailsStep.navigationId;
            } else {
                if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === "amend" || meerkat.site.pageAction === "load") {
                    meerkat.modules.journeyEngine.loadingShow("retrieving your quote information");
                    meerkat.modules.travelReloadQuote.loadQuote();
                }
                if (meerkat.site.pageAction === "latest") {
                    meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
                    startStepId = steps.resultsStep.navigationId;
                }
            }
            meerkat.modules.journeyEngine.configure({
                startStepId: startStepId,
                steps: _.toArray(steps)
            });
            var transaction_id = meerkat.modules.transactionId.get();
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackQuoteEvent",
                object: {
                    action: "Start",
                    transactionID: transaction_id
                }
            });
            if (meerkat.site.isNewQuote === false) {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "trackQuoteEvent",
                    object: {
                        action: "Retrieve",
                        transactionID: transaction_id
                    }
                });
            }
            var $e = $("#more-info-template");
            if ($e.length > 0) {
                templateMoreInfo = _.template($e.html());
            }
        });
    }
    function setJourneyEngineSteps() {
        var detailsStep = {
            title: "Travel Details",
            navigationId: "start",
            slideIndex: 0,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.travel.getTrackingFieldsObject
            },
            onInitialise: function onStartInit(event) {
                meerkat.modules.travelCountrySelection.initCountrySelection();
            },
            onBeforeEnter: function(event) {},
            onBeforeLeave: function(event) {}
        };
        var resultsStep = {
            title: "Results",
            navigationId: "results",
            slideIndex: 1,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.travel.getTrackingFieldsObject
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.travelResults.initPage();
                meerkat.modules.travelSummaryText.initSummaryText();
                meerkat.modules.travelMoreInfo.initMoreInfo();
                meerkat.modules.travelSorting.initSorting();
                meerkat.modules.partnerTransfer.initTransfer();
            },
            onBeforeEnter: function enterResultsStep(event) {
                $("#resultsPage").addClass("hidden");
                meerkat.modules.travelSummaryText.updateText();
            },
            onAfterEnter: function afterEnterResults(event) {
                meerkat.modules.travelResults.get();
            },
            onAfterLeave: function(event) {}
        };
        steps = {
            detailsStep: detailsStep,
            resultsStep: resultsStep
        };
    }
    function getTrackingFieldsObject() {
        try {
            var ok_to_call = $("input[name=travel_marketing]", "#mainform").val() === "Y" ? "Y" : "N";
            var mkt_opt_in = $("input[name=travel_marketing]:checked", "#mainform").val() === "Y" ? "Y" : "N";
            var transactionId = meerkat.modules.transactionId.get();
            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();
            var policyType = $("#travel_policyType").val(), email = $("#travel_email").val(), dest = "", insType = "";
            var actionStep = "";
            switch (current_step) {
              case 0:
                actionStep = "travel details";
                break;

              case 1:
                actionStep = "travel results";
                break;
            }
            if (meerkat.modules.moreInfo.isModalOpen()) {
                actionStep = "travel more info";
            }
            if (policyType == "S") {
                $("input.destcheckbox:checked").each(function(idx, elem) {
                    dest += "," + $(this).val();
                });
                dest = dest.substring(1);
                insType = "Single Trip";
            } else {
                insType = "Annual Policy";
            }
            var response = {
                vertical: "travel",
                actionStep: actionStep,
                transactionID: transactionId,
                quoteReferenceNumber: transactionId,
                email: email,
                marketOptIn: mkt_opt_in
            };
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("start")) {
                _.extend(response, {
                    email: email,
                    destinationCountry: dest,
                    travelInsuranceType: insType,
                    marketOptIn: mkt_opt_in
                });
            }
            return response;
        } catch (e) {
            return false;
        }
    }
    meerkat.modules.register("travel", {
        init: initJourneyEngine,
        events: moduleEvents,
        getTrackingFieldsObject: getTrackingFieldsObject
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $firstname, $surname, $email, $marketing;
    function applyEventListeners() {
        $marketing.on("change", function() {
            if ($(this).is(":checked")) {
                $firstname.attr("required", "required").valid();
                $surname.attr("required", "required").valid();
                $email.attr("required", "required").valid();
            } else {
                $firstname.removeAttr("required").valid();
                $surname.removeAttr("required").valid();
                $email.removeAttr("required").valid();
            }
        });
    }
    function init() {
        $(document).ready(function() {
            $firstname = $("#travel_firstName");
            $surname = $("#travel_surname");
            $email = $("#travel_email");
            $marketing = $("#travel_marketing");
            $firstname.removeAttr("required");
            $surname.removeAttr("required");
            $email.removeAttr("required");
            applyEventListeners();
        });
    }
    meerkat.modules.register("travelContactDetails", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $countries;
    var $destinations, $destinationsCheckboxes;
    function updateCountries() {
        var $errorField = $destinationsFieldset.find(".error-field");
        if ($errorField.length > 0) {
            $errorField.remove();
        }
        if ($destinationsFieldset.find(".destcheckbox:checked").length > 0) {
            $destinations.val("1");
        } else {
            $destinations.val("");
        }
        $destinations.valid();
    }
    function initCountrySelection() {
        $(document).ready(function() {
            $destinationsFieldset = $(".travel_details_destinations");
            $destinations = $("#travel_destination");
            $destinationsCheckboxes = $(".destcheckbox");
            applyEventListeners();
        });
    }
    function applyEventListeners() {
        $destinationsCheckboxes.on("change", function() {
            meerkat.modules.travelCountrySelection.updateCountries();
        });
    }
    meerkat.modules.register("travelCountrySelection", {
        initCountrySelection: initCountrySelection,
        updateCountries: updateCountries
    });
})(jQuery);

(function($, undefined) {
    "use strict";
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var $fromDateInput, $toDateInput, now = new Date(), fromDateCurrent, fromDate_StartDateRange, fromDate_EndDateRange, fromDate_PlusYear, toDateCurrent, toDate_StartDateRange, toDate_EndDateRange;
    function stringDate(inputFormat, rfc3339) {
        if (typeof rfc3339 === "undefined") {
            rfc3339 = false;
        }
        function pad(s) {
            return s < 10 ? "0" + s : s;
        }
        var d = new Date(inputFormat);
        if (!rfc3339) {
            return [ pad(d.getDate()), pad(d.getMonth() + 1), d.getFullYear() ].join("/");
        } else {
            return [ d.getFullYear(), pad(d.getMonth() + 1), pad(d.getDate()) ].join("-");
        }
    }
    function initDateRangeVars() {
        fromDate_StartDateRange = now;
        fromDate_EndDateRange = new Date(fromDate_StartDateRange.toString());
        fromDate_EndDateRange.setYear(parseInt(fromDate_EndDateRange.getFullYear()) + 1);
        toDate_StartDateRange = now;
        toDate_EndDateRange = new Date(toDate_StartDateRange.toString());
        toDate_EndDateRange.setYear(parseInt(toDate_EndDateRange.getFullYear()) + 1);
    }
    function initDatePickers() {
        initDateRangeVars();
        $fromDateInput.datepicker({
            startDate: fromDate_StartDateRange,
            endDate: fromDate_EndDateRange
        });
        $fromDateInput.siblings(".dateinput-nativePicker").find("input").attr("min", stringDate(fromDate_StartDateRange, true)).attr("max", stringDate(fromDate_EndDateRange, true));
        $toDateInput.datepicker({
            startDate: toDate_StartDateRange,
            endDate: toDate_EndDateRange
        });
        $toDateInput.siblings(".dateinput-nativePicker").find("input").attr("min", stringDate(toDate_StartDateRange, true)).attr("max", stringDate(toDate_EndDateRange, true));
    }
    function syncToDateRanges() {
        fromDateCurrent = $fromDateInput.datepicker("getDate");
        if (fromDateCurrent.toString() !== "Invalid Date") {
            toDate_StartDateRange = new Date(fromDateCurrent.toString());
            toDate_EndDateRange = new Date(toDate_StartDateRange.toString());
            toDate_EndDateRange.setYear(parseInt(toDate_EndDateRange.getFullYear()) + 1);
            $toDateInput.datepicker("setStartDate", toDate_StartDateRange).datepicker("setEndDate", toDate_EndDateRange);
            $toDateInput.siblings(".dateinput-nativePicker").find("input").attr("min", stringDate(toDate_StartDateRange, true)).attr("max", stringDate(toDate_EndDateRange, true));
            $toDateInput.rules("remove", "maxDateEUR");
            $toDateInput.rules("add", {
                maxDateEUR: stringDate(toDate_EndDateRange),
                messages: {
                    maxDateEUR: "The return date should be equal to or before one year after the departure date (i.e. " + stringDate(toDate_EndDateRange) + ")"
                }
            });
        }
    }
    function syncToDateWithin1yearRange() {
        fromDateCurrent = $fromDateInput.datepicker("getDate");
        toDateCurrent = $toDateInput.datepicker("getDate");
        fromDate_PlusYear = new Date(fromDateCurrent.toString());
        fromDate_PlusYear.setYear(parseInt(fromDate_PlusYear.getFullYear()) + 1);
        if (fromDate_PlusYear < toDateCurrent) {
            meerkat.modules.formDateInput.populate($toDateInput, stringDate(fromDate_PlusYear));
            $toDateInput.datepicker("update", fromDate_PlusYear);
        }
    }
    function initDateEvents() {
        $fromDateInput.on("hide serialised.meerkat.formDateInput", function updateToDateInput() {
            syncToDateWithin1yearRange();
            syncToDateRanges();
        });
        $toDateInput.on("hide serialised.meerkat.formDateInput", function updateFromDateInput() {
            $fromDateInput.blur();
        });
    }
    function init() {
        $(document).ready(function() {
            $fromDateInput = $("#travel_dates_fromDate");
            $toDateInput = $("#travel_dates_toDate");
            $fromDateInput.datepicker({
                orientation: "top right"
            });
            $toDateInput.datepicker({
                orientation: "top right"
            });
            initDatePickers();
            initDateEvents();
        });
    }
    meerkat.modules.register("datesSelection", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, $bridgingContainer = $(".bridgingContainer");
    var events = {
        travelMoreInfo: {}
    }, moduleEvents = events.travelMoreInfo;
    function initMoreInfo() {
        var options = {
            container: $bridgingContainer,
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
            onBeforeShowModal: null,
            onAfterShowModal: trackProductView,
            onAfterShowTemplate: null,
            onBeforeHideTemplate: null,
            onAfterHideTemplate: null,
            onClickApplyNow: onClickApplyNow,
            onBeforeApply: null,
            onApplySuccess: null,
            retrieveExternalCopy: retrieveExternalCopy
        };
        meerkat.modules.moreInfo.initMoreInfo(options);
        eventSubscriptions();
        applyEventListeners();
    }
    function applyEventListeners() {}
    function runDisplayMethod(productId) {
        meerkat.modules.moreInfo.showModal();
        meerkat.modules.address.appendToHash("moreinfo");
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState() {
            if (meerkat.modules.moreInfo.isModalOpen()) {
                meerkat.modules.moreInfo.close();
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState() {
            if (meerkat.modules.moreInfo.isModalOpen()) {
                meerkat.modules.moreInfo.close();
            }
        });
    }
    function retrieveExternalCopy(product) {
        return $.Deferred(function(dfd) {
            var objectArray = [], orderArray = {};
            $.each(product.info, function(a) {
                if (this.order !== "") {
                    orderArray[this.order] = a;
                }
                objectArray.push([ product.info[a].desc, a ]);
            });
            product.sorting = meerkat.modules.travelMoreInfo.arraySort(orderArray, objectArray);
            meerkat.modules.moreInfo.setDataResult(product);
            return dfd.resolveWith(this, [ product ]).promise();
        });
    }
    function onClickApplyNow(product, applyNowCallback) {
        var options = {
            product: product,
            applyNowCallback: applyNowCallback
        };
        meerkat.modules.partnerTransfer.transferToPartner(options);
    }
    function trackProductView() {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteForms",
            object: _.bind(meerkat.modules.travel.getTrackingFieldsObject, this, true)
        });
    }
    function arraySort(orderArray, objectArray) {
        var sortedArray = [];
        if (orderArray.length > 0) {
            $.each(orderArray, function(a) {
                $.each(objectArray, function(b) {
                    if (orderArray[a] == objectArray[b][1]) {
                        sortedArray.push([ objectArray[b][0], objectArray[b][1] ]);
                    }
                });
            });
            return sortedArray;
        } else {
            objectArray.sort();
            return objectArray;
        }
    }
    meerkat.modules.register("travelMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        runDisplayMethod: runDisplayMethod,
        arraySort: arraySort
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, $htmlBody, $morePrompt, promptInit = false;
    function initPrompt() {
        $(document).ready(function() {
            $htmlBody = $("body,html"), $footer = $("#footer"), $morePrompt = $(".morePromptContainer"), 
            contentBottom = $footer.offset().top - $(window).height();
            if (!promptInit && meerkat.modules.deviceMediaState.get() != "xs") {
                applyEventListeners();
            } else if (promptInit) {
                _.delay(handleFades, 600);
            }
            eventSubscriptions();
        });
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function leaveXSMode() {
            if (!promptInit) {
                applyEventListeners();
            }
        });
    }
    function handleFades() {
        var height = "innerHeight" in window ? window.innerHeight : document.documentElement.offsetHeight;
        if (height + $(window).scrollTop() >= $(".resultsContainer").outerHeight()) {
            $morePrompt.fadeOut();
        } else {
            $morePrompt.fadeIn();
        }
    }
    function applyEventListeners() {
        $morePrompt.fadeIn();
        promptInit = true;
        $(window).scroll(function() {
            clearTimeout($.data(this, "scrollCheck"));
            $.data(this, "scrollCheck", setTimeout(handleFades, 150));
        });
        $(document.body).on("click", ".morePromptLink", function(e) {
            var scrollTo = "top".toLowerCase(), animationOptions = {}, contentBottom = $footer.offset().top - $(window).height();
            if (scrollTo == "bottom") {
                contentBottom += $footer.outerHeight(true);
            }
            animationOptions.scrollTop = contentBottom;
            $htmlBody.stop(true, true).animate(animationOptions, 800);
        });
    }
    function hasScrollBar($obj) {
        return $obj.get(0).scrollHeight > $(window).height();
    }
    function init() {
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, function morePromptCallBack(obj) {
            meerkat.modules.travelMorePrompt.initPrompt();
        });
    }
    meerkat.modules.register("travelMorePrompt", {
        init: init,
        initPrompt: initPrompt
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    function initReloadQuote() {}
    function loadQuote() {
        var params = getURLVars(window.location.search), dat = "vertical=travel&action=load&id=" + params.id + "&hash=" + params.hash + "&type=" + params.type + "&vertical=TRAVEL&transactionId=" + params.id;
        meerkat.modules.comms.post({
            url: "ajax/json/remote_load_quote.jsp",
            data: dat,
            cache: false,
            useDefaultErrorHandling: false,
            errorLevel: "fatal",
            timeout: 3e4,
            onError: onSubmitToLoadQuoteError,
            onSuccess: function onSubmitSuccess(resultData) {
                window.location = resultData.result.destUrl + "&ts=" + Number(new Date());
            }
        });
    }
    function onSubmitToLoadQuoteError(jqXHR, textStatus, errorThrown, settings, resultData) {
        stateSubmitInProgress = false;
        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
            source: "loadQuote"
        });
        meerkat.modules.errorHandling.error({
            message: "An error occurred when attempting to retrieve your quotes",
            page: "travelReloadQuote.js:loadQuote()",
            errorLevel: "warning",
            description: "Ajax request to remote_load_quote.jsp failed to return a valid response: " + errorThrown,
            data: resultData
        });
    }
    function getURLVars(sSearch) {
        if (sSearch.length > 1) {
            var obj = {};
            for (var aItKey, nKeyId = 0, aCouples = sSearch.substr(1).split("&"); nKeyId < aCouples.length; nKeyId++) {
                aItKey = aCouples[nKeyId].split("=");
                obj[decodeURIComponent(aItKey[0])] = aItKey.length > 1 ? decodeURIComponent(aItKey[1]) : "";
            }
            return obj;
        }
    }
    meerkat.modules.register("travelReloadQuote", {
        init: initReloadQuote,
        loadQuote: loadQuote
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, supertagEventMode = "Load";
    var supertagResultsEventMode = "Load";
    var $component;
    var previousBreakpoint;
    var best_price_count = 1;
    var needToBuildFeatures = false;
    function initPage() {
        initResults();
        Compare.init();
        eventSubscriptions();
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
                url: "ajax/json/travel_quote_results.jsp",
                runShowResultsPage: false,
                paths: {
                    results: {
                        list: "results.price"
                    },
                    productId: "productId",
                    price: {
                        premium: "price"
                    },
                    benefits: {
                        cxdfee: "info.cxdfee.value",
                        excess: "info.excess.value",
                        medical: "info.medical.value",
                        luggage: "info.luggage.value"
                    },
                    availability: {
                        product: "available"
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
                paginationTouchEnabled: false,
                sort: {
                    sortBy: "price.premium",
                    sortDir: "asc"
                },
                frequency: "premium",
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
                    callback: meerkat.modules.travelResults.rankingCallback,
                    forceIdNumeric: false,
                    filterUnavailableProducts: false
                }
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred initialising page", "results.tag", "meerkat.modules.travelResults.init(); " + e.message, e);
        }
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            $component.css("margin-top", "8px");
        });
        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            $component.css("margin-top", "0");
        });
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
            Results.view.show();
        });
        $(document).on("resultsReturned", function() {
            meerkat.modules.utilities.scrollPageTo($("header"));
            $(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");
        });
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.modules.journeyEngine.loadingShow("...getting your quotes...");
            $component.removeClass("hidden");
            Results.pagination.hide();
        });
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            $(Results.settings.elements.page).show();
            meerkat.modules.journeyEngine.loadingHide();
            if (Results.getDisplayMode() !== "price") {
                Results.pagination.show();
            } else {
                $(document.body).removeClass("priceMode").addClass("priceMode");
            }
            var availableCounts = 0;
            $.each(Results.model.returnedProducts, function() {
                if (this.available === "Y" && this.productId !== "CURR") {
                    availableCounts++;
                }
            });
            if (availableCounts === 0) {
                showNoResults();
            }
        });
        $(Results.settings.elements.resultsContainer).on("click", ".result-row", resultRowClick);
    }
    function rankingCallback(product, position) {
        var data = {};
        data["rank_premium" + position] = product.price;
        data["rank_productId" + position] = product.productId;
        if (_.isNumber(best_price_count) && position < best_price_count) {
            data["best_price" + position] = 1;
            data["best_price_productName" + position] = product.name;
            data["best_price_excess" + position] = product.info.excess.text;
            data["best_price_medical" + position] = product.info.medical.text;
            data["best_price_cxdfee" + position] = product.info.cxdfee.text;
            data["best_price_luggage" + position] = product.info.luggage.text;
            data["best_price_price" + position] = product.priceText;
            data["best_price_url" + position] = product.quoteUrl;
        }
        return data;
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
        meerkat.modules.travelMoreInfo.runDisplayMethod();
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
    function get() {
        Results.get();
    }
    function onResultsLoaded() {
        startColumnWidthTracking();
        if (Results.getDisplayMode() !== "features") needToBuildFeatures = true;
    }
    function showNoResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $("#no-results-content")[0].outerHTML
        });
    }
    function publishExtraSuperTagEvents() {
        var data = {
            vertical: meerkat.site.vertical,
            actionStep: meerkat.site.vertical + " results",
            event: supertagResultsEventMode
        };
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteList",
            object: data
        });
        supertagResultsEventMode = "Refresh";
    }
    function init() {
        $component = $("#resultsPage");
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
    }
    meerkat.modules.register("travelResults", {
        init: init,
        initPage: initPage,
        get: get,
        showNoResults: showNoResults,
        rankingCallback: rankingCallback
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, error = meerkat.logging.error, exception = meerkat.logging.exception, $sortElements, activeSortBy, activeSortDir;
    var events = {
        travelSortings: {}
    }, moduleEvents = events.travelSorting;
    function setSortFromTarget($elem) {
        var sortType = $elem.attr("data-sort-type");
        var sortDir = $elem.attr("data-sort-dir");
        if (typeof sortType !== "undefined" && typeof sortDir !== "undefined") {
            if (sortType === Results.getSortBy() && sortDir === Results.getSortDir()) {
                sortDir === "asc" ? sortDir = "desc" : sortDir = "asc";
                $elem.attr("data-sort-dir", sortDir);
            }
            var sortByResult = Results.sortBy(sortType, sortDir);
            if (sortByResult) {
                $sortElements.parent("li").removeClass("active");
                $elem.parent("li").addClass("active");
            } else {
                error("[travelSorting]", "The sortBy or sortDir could not be set", setSortByReturn, setSortDirReturn);
            }
        } else {
            error("[travelSorting]", "No data on sorting element");
        }
    }
    function initSorting() {
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, function sortedCallback(obj) {
            meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);
        });
        $sortElements.on("click", function sortingClickHandler(event) {
            $clicked = $(event.target);
            if (!$clicked.is("a")) {
                $clicked = $clicked.closest("a");
            }
            if (!$clicked.hasClass("disabled")) {
                meerkat.messaging.publish(meerkatEvents.WEBAPP_LOCK);
                _.defer(function deferredSortClickWrapper() {
                    setSortFromTarget($clicked);
                });
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockSorting(obj) {
            $sortElements.addClass("inactive").addClass("disabled");
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockSorting(obj) {
            $sortElements.removeClass("inactive").removeClass("disabled");
        });
    }
    function init() {
        $(document).ready(function travelSortingInitDomready() {
            $sortElements = $("[data-sort-type]");
            if (typeof Results === "undefined") {
                meerkat.logging.exception("[travelSorting]", "No Results Object Found!");
            } else {
                return;
            }
        });
    }
    meerkat.modules.register("travelSorting", {
        init: init,
        initSorting: initSorting,
        events: events
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var $resultsSummaryPlaceholder, $fromDate, $toDate, $worldwide, $adults, $children;
    function updateSummaryText() {
        var txt = "<span>" + (meerkat.modules.deviceMediaState.get() !== "sm" ? "Your quote" : "Quote") + '</span> is based on: <span class="highlight">';
        var adults = $adults.val(), children = $children.val(), chkCount = $(".destcheckbox:checked").length;
        txt += adults + " adult" + (adults == 1 ? "" : "s");
        if (children > 0) {
            txt += " and " + children + " child" + (children == 1 ? "" : "ren");
        }
        if ($policytype.val() == "S") {
            txt += '</span> <span class="optional">travelling</span> to <span class="highlight">';
            if ($worldwide.is(":checked")) {
                txt += "any country";
            } else if (chkCount > 1) {
                txt += chkCount + " destinations";
            } else {
                var chkId = $(".destcheckbox:checked").first().attr("id");
                txt += $("label[for=" + chkId + "]").text();
            }
            var x = $fromDate.val().split("/"), y = $toDate.val().split("/"), date1 = new Date(x[2], x[1] - 1, x[0]), date2 = new Date(y[2], y[1] - 1, y[0]);
            var DAY = 1e3 * 60 * 60 * 24, days = 1 + Math.ceil((date2.getTime() - date1.getTime()) / DAY);
            txt += "</span> for <span class='highlight'>" + days + " days";
        } else {
            txt += "</span> travelling <span class='highlight'>multiple times in one year";
        }
        $resultsSummaryPlaceholder.html(txt + "</span>").fadeIn();
    }
    function initSummaryText() {
        $resultsSummaryPlaceholder = $(".resultsSummaryPlaceholder"), $fromDate = $("#travel_dates_fromDate"), 
        $toDate = $("#travel_dates_toDate"), $worldwide = $("#travel_destinations_do_do"), 
        $adults = $("#travel_adults"), $children = $("#travel_children"), $policytype = $("#travel_policyType");
        applyEventListeners();
    }
    function applyEventListeners() {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_SM, function updateSummaryTextXS() {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results") {
                updateSummaryText();
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_MD, function updateSummaryTextMD() {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results") {
                updateSummaryText();
            }
        });
    }
    function init() {}
    meerkat.modules.register("travelSummaryText", {
        init: init,
        initSummaryText: initSummaryText,
        updateText: updateSummaryText
    });
})(jQuery);