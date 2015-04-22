/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        coverLevelTabs: {
            CHANGE_COVER_TAB: "CHANGE_COVER_TAB"
        }
    }, moduleEvents = events.coverLevelTabs;
    var counts = {}, currentRankingFilter = "default", hasRunTrackingCall = [], recordFullTabJourney = false, originatingTab = "default", departingTab = [], defaults = {
        enabled: true,
        verticalMapping: {},
        activeTabIndex: false,
        disableAnimationsBetweenTabs: true,
        activeTabSet: [ {
            label: "Comprehensive",
            rankingFilter: "C",
            defaultTab: true,
            showCount: true,
            filter: function(renderView) {}
        } ]
    }, settings = {}, $tabsContainer = $(".coverLevelTabs"), $currentTabContainer = $(".currentTabsContainer");
    function initCoverLevelTabs(options) {
        settings = $.extend(true, {}, defaults, options);
        if (settings.enabled === false) {
            return;
        }
        jQuery(document).ready(function($) {
            applyEventListeners();
            eventSubscriptions();
        });
    }
    function applyEventListeners() {
        if (!$tabsContainer.length) {
            return;
        }
        $tabsContainer.off("click", ".clt-action").on("click", ".clt-action", function(e) {
            var $el = $(this), tabIndex = $el.attr("data-clt-index");
            log("[coverleveltabs] click", tabIndex);
            if (tabIndex === "" || settings.activeTabIndex === tabIndex) {
                return;
            }
            if (typeof settings.activeTabSet[tabIndex] === "undefined") {
                return;
            }
            if (typeof settings.activeTabSet[tabIndex].filter === "function") {
                var filterAnimate = Results.settings.animation.filter.active;
                if (settings.disableAnimationsBetweenTabs === true) {
                    Results.settings.animation.filter.active = false;
                }
                settings.activeTabSet[tabIndex].filter();
                $el.siblings().removeClass("active").end().addClass("active");
                settings.activeTabIndex = tabIndex;
                setRankingFilter(settings.activeTabSet[tabIndex].rankingFilter);
                meerkat.messaging.publish(moduleEvents.CHANGE_COVER_TAB, {
                    activeTab: getRankingFilter()
                });
                if (settings.disableAnimationsBetweenTabs === true) {
                    Results.settings.animation.filter.active = filterAnimate;
                }
                var additionalData = {
                    recordRanking: "Y"
                }, hasTrackedThisTab = hasRunTrackingCall.indexOf(getRankingFilter()) !== -1;
                if (hasTrackedThisTab) {
                    additionalData.recordRanking = "N";
                    additionalData.products = [];
                }
                if (!recordFullTabJourney) {
                    departingTab = [];
                }
                departingTab.push(getRankingFilter());
                meerkat.modules.resultsRankings.resetTrackingProductObject();
                meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
                    additionalData: additionalData,
                    onAfterEventMode: "Refresh"
                });
                if (!hasTrackedThisTab && hasRunTrackingCall.length) {
                    var rankingData = meerkat.modules.resultsRankings.getWriteRankData(Results.settings.rankings, meerkat.modules.resultsRankings.fetchProductsToRank(true));
                    meerkat.modules.resultsRankings.sendQuoteRanking("Cover Level Tabs", rankingData);
                }
                if (!hasTrackedThisTab) {
                    hasRunTrackingCall.push(getRankingFilter());
                }
                meerkat.modules.utilities.scrollPageTo("html body", 350, 0, function() {
                    meerkat.modules.journeyEngine.sessionCamRecorder({
                        navigationId: "CoverLevel" + getRankingFilter()
                    });
                });
            }
        });
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_BEFORE_DATA_READY, setup);
    }
    function setup() {
        log("[coverleveltabs] Setup");
        buildTabs();
        activateDefault();
    }
    function activateDefault() {
        $(".clt-action:visible.active").click();
    }
    function buildTabs() {
        if (typeof settings.activeTabSet === "undefined") {
            return;
        }
        log("[coverleveltabs] buildTabs", settings.activeTabSet);
        var tabLength = settings.activeTabSet.length, xsCols = parseInt(12 / tabLength, 10), state = meerkat.modules.deviceMediaState.get();
        for (var out = "", i = 0; i < tabLength; i++) {
            var tab = settings.activeTabSet[i], count = counts[tab.rankingFilter] || null;
            out += '<div class="col-xs-' + xsCols + " text-center clt-action " + (tab.defaultTab === true ? "active" : "") + '" data-clt-index="' + i + '">';
            out += tab.label + (state !== "xs" && tab.showCount === true && count !== null ? " (" + count + ")" : "");
            out += "</div>";
            if (tab.defaultTab === true) {
                originatingTab = settings.verticalMapping[tab.rankingFilter];
            }
        }
        $currentTabContainer.empty().html(out);
    }
    function getOriginatingTab() {
        return originatingTab;
    }
    function getDepartingTabJourney() {
        var departingTabJourney = "default";
        if (settings.enabled) {
            departingTabJourney = "";
            var sep = "";
            for (var i = 0; i < departingTab.length; i++) {
                departingTabJourney += sep + settings.verticalMapping[departingTab[i]];
                sep = ",";
            }
        }
        return departingTabJourney;
    }
    function setActiveTabSet(activeTabSet) {
        log("[coverleveltabs] activeTabSet", activeTabSet);
        settings.activeTabSet = activeTabSet;
    }
    function incrementCount(coverLevel) {
        if (typeof counts[coverLevel] === "undefined") {
            counts[coverLevel] = 0;
        }
        counts[coverLevel]++;
    }
    function setRankingFilter(rankingFilter) {
        currentRankingFilter = rankingFilter;
    }
    function getRankingFilter() {
        return currentRankingFilter;
    }
    function isEnabled() {
        return settings.enabled || false;
    }
    function resetView(activeTabSet) {
        log("[coverleveltabs] resetView");
        $currentTabContainer.empty();
        hasRunTrackingCall = [];
        settings.activeTabIndex = false;
        setActiveTabSet(activeTabSet);
        counts = {};
    }
    meerkat.modules.register("coverLevelTabs", {
        initCoverLevelTabs: initCoverLevelTabs,
        events: events,
        setActiveTabSet: setActiveTabSet,
        resetView: resetView,
        getRankingFilter: getRankingFilter,
        isEnabled: isEnabled,
        incrementCount: incrementCount,
        getOriginatingTab: getOriginatingTab,
        getDepartingTabJourney: getDepartingTabJourney
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    function callFunctions() {
        log("[handoverCookieSetup]", "Running the onready code");
        if (meerkat.site.environment != "pro" && meerkat.site.environment != "prelive") {
            log("[handoverCookieSetup]", "_CtMH setting test options now");
            _CtMH.setOpts({
                debug: meerkat.site.showLogging,
                asTest: true,
                endp: meerkat.site.ctmh.fBase + "handover/confirm"
            });
        }
        log("[handoverCookieSetup]", "_CtMH running start now");
        _CtMH.start(meerkat.modules.transactionId.get(), meerkat.site.vertical);
    }
    function init() {
        log("[handoverCookieSetup]", "Initialised");
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, function resultsCallback() {
            log("[handoverCookieSetup]", "RESULTS_DATA_READY", "Triggered");
            if (typeof _CtMH !== "undefined") {
                log("[handoverCookieSetup]", "_CtMH is defined");
                _CtMH.onready(callFunctions());
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.partnerTransfer.TRANSFER_TO_PARTNER, function partnerTransferCallback(data) {
            log("[handoverCookieSetup]", "partnerTransfer.TRANSFER_TO_PARTNER", "Triggered");
            if (typeof _CtMH !== "undefined") {
                _CtMH.add(data.transactionID, data.partnerID, data.productDescription);
            }
        });
    }
    meerkat.modules.register("handoverCookieSetup", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, templateMoreInfo, $travel_dates_toDate, $travel_dates_fromDate_button, $travel_dates_fromDate, $travel_dates_toDate_button, $travel_adults, $travel_destinations_do_do;
    var moduleEvents = {
        traveldetails: {
            COVER_TYPE_CHANGE: "COVER_TYPE_CHANGE"
        },
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    };
    var steps = null, $policyTypeBtn;
    function initJourneyEngine() {
        $(document).ready(function() {
            $travel_dates_toDate = $("#travel_dates_toDate"), $travel_dates_fromDate_button = $("#travel_dates_fromDate_button"), 
            $travel_dates_fromDate = $("#travel_dates_fromDate"), $travel_dates_toDate_button = $("#travel_dates_toDate_button").trigger("click"), 
            $travel_adults = $("#travel_adults"), $travel_dates_toDate = $("#travel_dates_toDate"), 
            $travel_destinations = $("#travel_destinations");
            $policyTypeBtn = $("input[name=travel_policyType]");
            meerkat.modules.travelYourCover.initTravelCover();
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
                    transactionID: transaction_id,
                    verticalFilter: meerkat.modules.travel.getVerticalFilter()
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
                var currentJourney = meerkat.modules.tracking.getCurrentJourney();
                if (typeof currentJourney !== "undefined" && (currentJourney === 5 || currentJourney === 6)) {
                    $("#travel_location").on("blur", function() {
                        meerkat.modules.travelContactDetails.setLocation($(this).val());
                    });
                }
                if ($policyTypeBtn.is(":checked")) {
                    meerkat.messaging.publish(moduleEvents.traveldetails.COVER_TYPE_CHANGE);
                }
                $policyTypeBtn.on("change", function(event) {
                    meerkat.messaging.publish(moduleEvents.traveldetails.COVER_TYPE_CHANGE);
                });
                $("#travel_dates_fromDateInputD, #travel_dates_fromDateInputM, #travel_dates_fromDateInputY").focus(function showCalendar() {
                    $travel_dates_toDate.datepicker("hide");
                    $travel_dates_fromDate_button.trigger("click");
                });
                $("#travel_dates_toDateInputD, #travel_dates_toDateInputM, #travel_dates_toDateInputY").focus(function showCalendar() {
                    $travel_dates_fromDate.datepicker("hide");
                    $travel_dates_toDate_button.trigger("click");
                });
                $travel_adults.focus(function hideCalendar() {
                    $travel_dates_toDate.datepicker("hide");
                });
                if (meerkat.site.countrySelectionDefaults.length) {
                    var countries = meerkat.site.countrySelectionDefaults.split(",");
                    for (var i = 0; i < countries.length; i++) {
                        if (countries[i].length) {
                            $travel_destinations.val(countries[i]).change();
                        }
                    }
                }
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
                meerkat.modules.travelMorePrompt.initTravelMorePrompt();
                meerkat.modules.travelSorting.initSorting();
                meerkat.modules.partnerTransfer.initTransfer();
                meerkat.modules.travelCoverLevelTabs.initTravelCoverLevelTabs();
            },
            onBeforeEnter: function enterResultsStep(event) {
                meerkat.modules.resultsTracking.setResultsEventMode("Load");
                $("#resultsPage").addClass("hidden");
                meerkat.modules.travelSummaryText.updateText();
                meerkat.modules.travelCoverLevelTabs.updateSettings();
            },
            onAfterEnter: function afterEnterResults(event) {
                meerkat.modules.travelResults.get();
            },
            onAfterLeave: function(event) {
                if (event.isBackward) {
                    meerkat.modules.travelMorePrompt.disablePromptBar();
                }
            }
        };
        steps = {
            detailsStep: detailsStep,
            resultsStep: resultsStep
        };
    }
    function getVerticalFilter() {
        var vf = null;
        if ($policyTypeBtn.is(":checked")) {
            vf = $("input[name=travel_policyType]:checked").val() == "S" ? "Single Trip" : "Multi Trip";
        }
        return vf;
    }
    function getTrackingFieldsObject() {
        try {
            var ok_to_call = $("input[name=travel_marketing]", "#mainform").val() === "Y" ? "Y" : "N";
            var mkt_opt_in = $("input[name=travel_marketing]:checked", "#mainform").val() === "Y" ? "Y" : "N";
            var transactionId = meerkat.modules.transactionId.get();
            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();
            var policyType = $("input[name=travel_policyType]:checked").val(), email = $("#travel_email").val(), dest = "", insType = "", leaveDate = "", returnDate = null;
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
                dest = $("#travel_destination").val();
                insType = "Single Trip";
                leaveDate = formatDate($("#travel_dates_fromDate").val());
                returnDate = formatDate($("#travel_dates_toDate").val());
            } else {
                insType = "Annual Policy";
                dest = "Multi-Trip";
                leaveDate = formatDate(new Date());
            }
            var response = {
                vertical: meerkat.site.vertical,
                actionStep: actionStep,
                transactionID: transactionId,
                quoteReferenceNumber: transactionId,
                email: email,
                emailID: null,
                marketOptIn: mkt_opt_in,
                verticalFilter: meerkat.modules.travel.getVerticalFilter()
            };
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("start")) {
                _.extend(response, {
                    email: email,
                    destinationCountry: dest,
                    travelInsuranceType: insType,
                    marketOptIn: mkt_opt_in,
                    leaveDate: leaveDate,
                    returnDate: returnDate,
                    adults: $("#travel_adults").val(),
                    children: $("#travel_children").val(),
                    oldest: $("#travel_oldest").val()
                });
            }
            return response;
        } catch (e) {
            return false;
        }
    }
    function formatDate(d) {
        if (typeof d === "string") {
            var dateStr = d.split("/");
            d = new Date(dateStr[2], dateStr[1], dateStr[0]);
        }
        var month = d.getMonth() + 1;
        var day = d.getDate();
        return (day < 10 ? "0" : "") + day + "/" + (month < 10 ? "0" : "") + month + "/" + d.getFullYear();
    }
    meerkat.modules.register("travel", {
        init: initJourneyEngine,
        events: moduleEvents,
        getTrackingFieldsObject: getTrackingFieldsObject,
        getVerticalFilter: getVerticalFilter
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $firstname, $surname, $email, $postcodeDetails, $productDetailsField, $marketing, currentJourney;
    function applyEventListeners() {
        if (currentJourney != 7) {
            $marketing.on("change", function() {
                if ($(this).is(":checked")) {
                    $email.attr("required", "required").valid();
                    showHidePostcodeField();
                } else {
                    $email.removeAttr("required").valid();
                }
            });
        }
        $email.on("blur", function() {
            showHidePostcodeField();
        });
    }
    function showHidePostcodeField() {
        if (currentJourney == 5 || currentJourney == 6) {
            if ($marketing.is(":checked") && $email.valid()) {
                if ($email.val().trim().length > 0) {
                    $postcodeDetails.slideDown();
                } else {
                    $postcodeDetails.slideUp();
                }
            }
        }
    }
    function setLocation(location) {
        if (isValidLocation(location)) {
            var value = $.trim(String(location));
            var pieces = value.split(" ");
            var state = pieces.pop();
            var postcode = pieces.pop();
            var suburb = pieces.join(" ");
            $("#travel_state").val(state);
            $("#travel_postcode").val(postcode).trigger("change");
            $("#travel_suburb").val(suburb);
        }
    }
    function isValidLocation(location) {
        var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);
        value = $.trim(String(location));
        if (value !== "") {
            if (value.match(search_match)) {
                return true;
            }
        }
        return false;
    }
    function init() {
        $(document).ready(function() {
            $email = $("#travel_email");
            $marketing = $("#travel_marketing");
            $postcodeDetails = $(".postcodeDetails");
            $productDetailsField = $postcodeDetails.find("#travel_location");
            currentJourney = meerkat.modules.tracking.getCurrentJourney();
            if (currentJourney != 7) {
                $email.removeAttr("required");
            }
            applyEventListeners();
        });
    }
    meerkat.modules.register("travelContactDetails", {
        init: init,
        setLocation: setLocation
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        travelCoverLevelTabs: {}
    }, moduleEvents = events.travelCoverLevelTabs;
    var singleTripTabs = [ {
        label: "Comprehensive <span class='hidden-xs'>Cover</span>",
        rankingFilter: "C",
        defaultTab: true,
        disableAnimationsBetweenTabs: true,
        showCount: true,
        filter: function() {
            Results.filterBy("coverLevel", "value", {
                equals: "C"
            }, true);
        }
    }, {
        label: "Mid Range <span class='hidden-xs'>Cover</span>",
        rankingFilter: "M",
        defaultTab: false,
        showCount: true,
        filter: function() {
            Results.filterBy("coverLevel", "value", {
                equals: "M"
            }, true);
        }
    }, {
        label: "Basic <span class='hidden-xs'>Cover</span>",
        rankingFilter: "B",
        showCount: true,
        defaultTab: false,
        filter: function() {
            Results.filterBy("coverLevel", "value", {
                equals: "B"
            }, true);
        }
    } ], annualMultiTripTabs = [ {
        label: "International <span class='hidden-xs'>Cover</span>",
        rankingFilter: "I",
        defaultTab: true,
        showCount: true,
        filter: function() {
            Results.filterBy("coverLevel", "value", {
                equals: "I"
            }, true);
        }
    }, {
        label: "Domestic <span class='hidden-xs'>Cover</span>",
        rankingFilter: "D",
        defaultTab: false,
        showCount: true,
        filter: function() {
            Results.filterBy("coverLevel", "value", {
                equals: "D"
            }, true);
        }
    } ], $policyType;
    function initTravelCoverLevelTabs() {
        var currentJourney = meerkat.modules.tracking.getCurrentJourney();
        if (currentJourney != 2 && currentJourney != 3 && currentJourney != 4) {
            return;
        }
        setupABTestParameters(currentJourney);
        var options = {
            enabled: true,
            tabCount: 3,
            activeTabSet: getActiveTabSet(),
            hasMultipleTabTypes: true,
            verticalMapping: tabMapping()
        };
        meerkat.modules.coverLevelTabs.initCoverLevelTabs(options);
    }
    function tabMapping() {
        return {
            DEFAULT: "DEFAULT",
            C: "Comprehensive",
            M: "Mid Range",
            B: "Basic",
            I: "International",
            D: "Domestic"
        };
    }
    function setupABTestParameters(currentJourney) {
        singleTripTabs[0].defaultTab = false;
        singleTripTabs[1].defaultTab = false;
        singleTripTabs[2].defaultTab = false;
        switch (currentJourney) {
          case "2":
            singleTripTabs[0].defaultTab = true;
            break;

          case "3":
            singleTripTabs[1].defaultTab = true;
            break;

          case "4":
            singleTripTabs[2].defaultTab = true;
            break;
        }
    }
    function getActiveTabSet() {
        switch ($("input[name=travel_policyType]:checked").val()) {
          case "A":
            return annualMultiTripTabs;

          case "S":
            return singleTripTabs;
        }
    }
    function updateSettings() {
        if (meerkat.modules.coverLevelTabs.isEnabled()) {
            meerkat.modules.coverLevelTabs.resetView(getActiveTabSet());
        }
    }
    meerkat.modules.register("travelCoverLevelTabs", {
        initTravelCoverLevelTabs: initTravelCoverLevelTabs,
        events: events,
        updateSettings: updateSettings
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
            onBeforeShowModal: onBeforeShowModal,
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
    function onBeforeShowModal(product) {
        var settings = {
            additionalTrackingData: {
                productBrandCode: product.provider,
                productName: product.name,
                verticalFilter: meerkat.modules.travel.getVerticalFilter()
            }
        };
        meerkat.modules.moreInfo.updateSettings(settings);
    }
    function retrieveExternalCopy(product) {
        return $.Deferred(function(dfd) {
            var objectArray = [], orderArray = {}, exemptedBenefits = [];
            exemptedBenefits = benefitException(product);
            $.each(product.info, function(a) {
                if (this.order !== "") {
                    orderArray[this.order] = a;
                }
                if ($.inArray(a, exemptedBenefits) == -1) {
                    objectArray.push([ product.info[a].desc, a ]);
                }
            });
            product.sorting = meerkat.modules.travelMoreInfo.arraySort(orderArray, objectArray);
            meerkat.modules.moreInfo.setDataResult(product);
            return dfd.resolveWith(this, [ product ]).promise();
        });
    }
    function benefitException(product) {
        var exemptedBenefits = [];
        if (typeof product.exemptedBenefits !== "undefined") {
            $.each(product.exemptedBenefits, function(a) {
                exemptedBenefits.push(product.exemptedBenefits[a]);
            });
        }
        return exemptedBenefits;
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
    var scrollTop = 0, meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, $htmlBody, $morePrompt = null, $morePromptIcons, $morePromptTextLink, $lastResultRow, morePromptClicked = false, promptInit = false, $footer, goToBottomText = "Go to Bottom", goToTopText = "Go to Top", scrollTo = "bottom", disablePrompt = false;
    function initPrompt() {
        scrollTo = "bottom";
        $(document).ready(function() {
            $lastResultRow = $("div.results-table .available.notfiltered").last();
            if (!promptInit && meerkat.modules.deviceMediaState.get() != "xs") {
                applyEventListeners();
            }
            eventSubscriptions();
            resetMorePromptBar();
        });
    }
    function applyEventListeners() {
        $morePrompt.fadeIn("slow");
        promptInit = true;
        $(document.body).on("click", ".morePromptLink", function(e) {
            var animationOptions = {}, contentBottom = $footer.offset().top - $(window).height();
            if (scrollTo == "bottom") {
                contentBottom += $footer.outerHeight(true);
            } else {
                contentBottom = 0;
            }
            animationOptions.scrollTop = contentBottom;
            morePromptClicked = true;
            $htmlBody.stop(true, true).animate(animationOptions, 800, function morePromptAnimateEnd() {
                morePromptClicked = false;
            });
        });
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function leaveXSMode() {
            if (!promptInit) {
                applyEventListeners();
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function breakPointChange() {
            resetMorePromptBar();
        });
        if (typeof meerkatEvents.coverLevelTabs !== "undefined") {
            meerkat.messaging.subscribe(meerkatEvents.coverLevelTabs.CHANGE_COVER_TAB, function onTabChange(eventObject) {
                if (eventObject.activeTab == "D") {
                    $morePrompt.hide();
                    disablePrompt = true;
                } else {
                    $morePrompt.removeAttr("style");
                    disablePrompt = false;
                }
            });
        }
        $(document).on("results.view.animation.end", function() {
            fixMorePromptAfterSortOrFilter();
        });
        var timeout;
        $(window).off("scroll.travelMorePrompt").on("scroll.travelMorePrompt", function() {
            scrollTop = $(this).scrollTop();
            if (timeout) clearTimeout(timeout);
            timeout = setTimeout(handleMorePromptToggling, 150);
        });
    }
    function fixMorePromptAfterSortOrFilter() {
        $lastResultRow = $("div.results-table .available.notfiltered").last();
        handleMorePromptToggling();
    }
    function handleMorePromptToggling() {
        if (disablePrompt) {
            return;
        }
        var height = window.innerHeight || document.documentElement.offsetHeight, currentScrollTopPos = scrollTop, currentPos = height + currentScrollTopPos, lastAvailableProduct = $lastResultRow.position(), lastAvailableProductPos = lastAvailableProduct.top + $lastResultRow.outerHeight();
        if (scrollTop === 0) {
            $morePrompt.removeAttr("style").css({
                position: "fixed"
            });
            $morePromptTextLink.html(goToBottomText);
            toggleArrowClass("icon-angle-down");
            scrollTo = "bottom";
        } else {
            if (currentPos >= lastAvailableProductPos) {
                $morePrompt.css({
                    top: lastAvailableProductPos,
                    height: $morePrompt.height(),
                    position: "absolute"
                });
                $morePromptTextLink.html(goToTopText);
                toggleArrowClass("icon-angle-up");
                scrollTo = "top";
            } else {
                if ($morePrompt.css("position") != "fixed") {
                    $morePrompt.removeAttr("style").css({
                        position: "fixed"
                    });
                }
            }
        }
    }
    function resetMorePromptBar() {
        _.defer(function() {
            $morePromptTextLink.html(goToBottomText);
            scrollTo = "bottom";
            toggleArrowClass("icon-angle-down");
            $morePrompt.removeAttr("style");
        });
    }
    function toggleArrowClass(thisClass) {
        if (!$morePromptIcons.hasClass(thisClass)) {
            $morePromptIcons.toggleClass("icon-angle-down icon-angle-up");
        }
    }
    function disablePromptBar() {
        $(window).off("scroll.travelMorePrompt");
        $morePrompt.hide();
    }
    function initTravelMorePrompt() {
        $htmlBody = $("body,html");
        $footer = $("#footer");
        $morePrompt = $(".morePromptContainer");
        $morePromptIcons = $morePrompt.find(".icon");
        $morePromptTextLink = $morePrompt.find(".morePromptLinkText");
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, function morePromptCallBack() {
            initPrompt();
        });
    }
    meerkat.modules.register("travelMorePrompt", {
        initTravelMorePrompt: initTravelMorePrompt,
        resetMorePromptBar: resetMorePromptBar,
        disablePromptBar: disablePromptBar
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    function initReloadQuote() {}
    function loadQuote() {
        var params = getURLVars(window.location.search), dat = "vertical=travel&action=load&id=" + params.id + "&hash=" + params.hash + "&type=" + params.type + "&vertical=TRAVEL&transactionId=" + params.id;
        if (typeof meerkat.modules.transactionId.get() == "undefined") {
            meerkat.modules.transactionId.set(params.id);
        }
        meerkat.modules.comms.post({
            url: "ajax/json/remote_load_quote.jsp",
            data: dat,
            cache: false,
            useDefaultErrorHandling: false,
            errorLevel: "fatal",
            timeout: 3e4,
            onError: onSubmitToLoadQuoteError,
            onSuccess: function onSubmitSuccess(resultData) {
                meerkat.modules.leavePageWarning.disable();
                window.location = resultData.result.destUrl + "&ts=" + Number(new Date());
            }
        });
    }
    function onSubmitToLoadQuoteError(jqXHR, textStatus, errorThrown, settings, resultData) {
        stateSubmitInProgress = false;
        meerkat.modules.errorHandling.error({
            message: "An error occurred when attempting to retrieve your quotes",
            page: "travelReloadQuote.js:loadQuote()",
            errorLevel: "warning",
            description: "Ajax request to remote_load_quote.jsp failed to return a valid response: " + errorThrown,
            data: resultData
        });
        meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK, {
            source: "loadQuote"
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
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        RESULTS_ERROR: "RESULTS_ERROR"
    };
    var $component;
    var previousBreakpoint;
    var best_price_count = 5;
    var needToBuildFeatures = false;
    function initPage() {
        initResults();
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
                    productName: "name",
                    productBrandCode: "provider",
                    coverLevel: "info.coverLevel",
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
                pagination: {
                    touchEnabled: false
                },
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
                    filterUnavailableProducts: true
                }
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred initialising page", "results.tag", "meerkat.modules.travelResults.initResults(); " + e.message, e);
        }
    }
    function massageResultsObject(products) {
        if (meerkat.modules.coverLevelTabs.isEnabled() !== true) {
            return products;
        }
        var policyType = meerkat.modules.travel.getVerticalFilter();
        _.each(products, function massageJson(result, index) {
            if (typeof result.info !== "object") {
                return;
            }
            var obj = result.info;
            if (policyType == "Single Trip") {
                var medical = 5e6, countryList = $("#travel_destinations").val();
                if (countryList == "AUS") {
                    medical = 0;
                }
                if (obj.excess.value <= 250 && obj.medical.value >= medical && obj.cxdfee.value >= 7500 && obj.luggage.value >= 7500) {
                    obj.coverLevel = "C";
                    meerkat.modules.coverLevelTabs.incrementCount("C");
                } else if (obj.excess.value <= 250 && obj.medical.value >= medical && obj.cxdfee.value >= 2500 && obj.luggage.value >= 2500) {
                    obj.coverLevel = "M";
                    meerkat.modules.coverLevelTabs.incrementCount("M");
                } else {
                    obj.coverLevel = "B";
                    meerkat.modules.coverLevelTabs.incrementCount("B");
                }
            } else {
                if (result.des.indexOf("Australia") == -1) {
                    obj.coverLevel = "I";
                    meerkat.modules.coverLevelTabs.incrementCount("I");
                } else {
                    obj.coverLevel = "D";
                    meerkat.modules.coverLevelTabs.incrementCount("D");
                }
            }
        });
        return products;
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
            if (availableCounts === 0 && !Results.model.hasValidationErrors) {
                showNoResults();
            }
        });
        $(Results.settings.elements.resultsContainer).on("click", ".result-row", resultRowClick);
    }
    function rankingCallback(product, position) {
        var data = {};
        data["rank_premium" + position] = product.price;
        data["rank_productId" + position] = product.productId;
        if (typeof product.info.coverLevel !== "undefined") {
            data["coverLevelType" + position] = product.info.coverLevel;
        }
        if (_.isNumber(best_price_count) && position < best_price_count) {
            data["best_price" + position] = 1;
            data["best_price_providerName" + position] = product.provider;
            data["best_price_productName" + position] = product.name;
            data["best_price_excess" + position] = typeof product.info.excess !== "undefined" ? product.info.excess.text : 0;
            data["best_price_medical" + position] = typeof product.info.medical !== "undefined" ? product.info.medical.text : 0;
            data["best_price_cxdfee" + position] = typeof product.info.cxdfee !== "undefined" ? product.info.cxdfee.text : 0;
            data["best_price_luggage" + position] = typeof product.info.luggage !== "undefined" ? product.info.luggage.text : 0;
            data["best_price_price" + position] = product.priceText;
            data["best_price_service" + position] = product.service;
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
            var currentJourney = meerkat.modules.tracking.getCurrentJourney();
            if (currentJourney != 2 && currentJourney != 3 && currentJourney != 4) {
                meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
            }
        });
    }
    meerkat.modules.register("travelResults", {
        init: init,
        initPage: initPage,
        get: get,
        showNoResults: showNoResults,
        rankingCallback: rankingCallback,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, error = meerkat.logging.error, exception = meerkat.logging.exception, $sortElements, activeSortBy, activeSortDir, defaultSortStates = {
        "benefits.excess": "asc",
        "benefits.medical": "desc",
        "benefits.cxdfee": "desc",
        "benefits.luggage": "desc",
        "price.premium": "asc"
    };
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
                meerkat.modules.resultsTracking.setResultsEventMode("Refresh");
                meerkat.modules.travelResults.publishExtraSuperTagEvents({
                    products: [],
                    recordRanking: "N"
                });
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
                    if (!$clicked.parent().hasClass("active")) {
                        resetSortDir($clicked);
                    }
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
    function resetSortDir($elem) {
        var sortType = $elem.attr("data-sort-type");
        $elem.attr("data-sort-dir", defaultSortStates[sortType]);
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
    var $resultsSummaryPlaceholder, $fromDate, $toDate, $worldwide, $adults, $children, $policytype, $summaryHeader, $selectedTags;
    function updateSummaryText() {
        var txt = '<span class="highlight">';
        var adults = $adults.val(), children = $children.val();
        txt += adults + " adult" + (adults == 1 ? "" : "s");
        if (children > 0) {
            txt += " and " + children + " child" + (children == 1 ? "" : "ren");
        }
        if ($("input[name=travel_policyType]:checked").val() == "S") {
            $summaryHeader.html("Your quote is based on");
            txt += '</span> <span class="optional">travelling</span> <span class="sm-md-block">to <span class="highlight">';
            if ($selectedTags.children().length == 1) {
                txt += $selectedTags.find(".selected-tag span").text();
            } else {
                txt += "multiple destinations";
            }
            var x = $fromDate.val().split("/"), y = $toDate.val().split("/"), date1 = new Date(x[2], x[1] - 1, x[0]), date2 = new Date(y[2], y[1] - 1, y[0]);
            var DAY = 1e3 * 60 * 60 * 24, days = 1 + Math.ceil((date2.getTime() - date1.getTime()) / DAY);
            txt += "</span> for <span class='highlight'>" + days + " days</span>";
        } else {
            $summaryHeader.html("Your Annual Multi Trip (AMT) quote is based on");
            var blockClass = children > 1 ? "sm-md-block" : "sm-block";
            txt += "</span> travelling <span class='highlight " + blockClass + "'>multiple times in one year";
        }
        $resultsSummaryPlaceholder.html(txt + "</span>").fadeIn();
    }
    function initSummaryText() {
        $resultsSummaryPlaceholder = $(".resultsSummaryPlaceholder"), $fromDate = $("#travel_dates_fromDate"), 
        $toDate = $("#travel_dates_toDate"), $worldwide = $("#travel_destinations_do_do"), 
        $adults = $("#travel_adults"), $children = $("#travel_children"), $policytype = $("#travel_policyType");
        $summaryHeader = $(".resultsSummaryContainer h5");
        $selectedTags = $(".selected-tags");
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

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var $destinationfs, $datestravellersfs, $travel_policyType_S, $travel_policyType_A, $travel_dates_fromDate_row, $travel_dates_toDate_row, $detailsForm, $resultsContainer, modalId = null;
    function init() {
        $(document.body).on("click", ".btn-view-brands", displayBrandsModal);
        $destinationfs = $("#destinationsfs");
        $datestravellersfs = $("#datestravellersfs");
        $travel_policyType_S = $("#travel_policyType_S");
        $travel_policyType_A = $("#travel_policyType_A");
        $travel_dates_fromDate_row = $("#travel_dates_fromDate_row");
        $travel_dates_toDate_row = $("#travel_dates_toDate_row");
        $detailsForm = $("#detailsForm");
        $resultsContainer = $(".resultsContainer");
        $destinationfs.hide();
        $datestravellersfs.hide();
        $travel_dates_toDate_row.hide();
        $travel_dates_fromDate_row.hide();
        $detailsForm.find(".well-chatty > .amt, .well-chatty > .single").hide();
        meerkat.messaging.subscribe(meerkatEvents.traveldetails.COVER_TYPE_CHANGE, toggleDetailsFields);
        applyEventListeners();
    }
    function applyEventListeners() {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter() {
            if (meerkat.modules.dialogs.isDialogOpen(modalId)) {
                meerkat.modules.dialogs.close(modalId);
            }
        });
    }
    function displayBrandsModal(event) {
        var template = _.template($("#brands-template").html());
        modalId = meerkat.modules.dialogs.show({
            title: $(this).attr("title"),
            hashId: "travel-brands",
            className: "travel-brands-modal",
            htmlContent: template(),
            closeOnHashChange: true,
            openOnHashChange: false
        });
        return false;
    }
    function toggleDetailsFields() {
        $resultsContainer.attr("policytype", $("input[name=travel_policyType]:checked").val());
        meerkat.modules.journeyEngine.sessionCamRecorder({
            navigationId: "PolicyType-" + $("input[name=travel_policyType]:checked").val()
        });
        if ($travel_policyType_S.is(":checked")) {
            $detailsForm.find(".well-info, .well-chatty > .single").show();
            $detailsForm.find(".well-chatty > .amt, .well-chatty > .default").hide();
            $destinationfs.slideDown();
            $datestravellersfs.slideDown();
            $travel_dates_fromDate_row.slideDown();
            $travel_dates_toDate_row.slideDown();
            $datestravellersfs.find("h2").text("Dates & Travellers");
        } else {
            $detailsForm.find(".well-info, .well-chatty > .single, .well-chatty > .default").hide();
            $detailsForm.find(".well-chatty > .amt").show();
            if ($destinationfs.is(":visible")) {
                $destinationfs.slideUp();
                $travel_dates_toDate_row.slideUp();
                $travel_dates_fromDate_row.slideUp();
            } else {
                $datestravellersfs.slideDown();
            }
            $datestravellersfs.find("h2").text("Travellers");
        }
    }
    meerkat.modules.register("travelYourCover", {
        initTravelCover: init,
        toggleDetailsFields: toggleDetailsFields
    });
})(jQuery);