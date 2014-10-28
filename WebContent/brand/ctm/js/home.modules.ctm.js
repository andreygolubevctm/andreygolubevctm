/*!
 * CTM-Platform v0.8.3
 * Copyright 2014 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {
        home: {},
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    }, steps = null;
    var templateAccessories;
    function initHome() {
        var self = this;
        $(document).ready(function() {
            if (meerkat.site.vertical !== "home") return false;
            initJourneyEngine();
            if (meerkat.site.pageAction === "confirmation") {
                return false;
            }
            eventDelegates();
            if (meerkat.site.pageAction === "amend" || meerkat.site.pageAction === "latest" || meerkat.site.pageAction === "load" || meerkat.site.pageAction === "start-again") {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
            $e = $("#calldirect-template");
            if ($e.length) {
                templateCallDirect = _.template($e.html());
            }
        });
    }
    function eventDelegates() {}
    function initJourneyEngine() {
        if (meerkat.site.pageAction === "confirmation") {
            meerkat.modules.journeyEngine.configure(null);
        } else {
            initProgressBar(false);
            var startStepId = null;
            if (meerkat.site.isFromBrochureSite === true) {
                startStepId = steps.startStep.navigationId;
            } else if (meerkat.site.journeyStage.length && meerkat.site.pageAction === "latest") {
                startStepId = steps.resultsStep.navigationId;
            } else if (meerkat.site.journeyStage.length && meerkat.site.pageAction === "amend") {
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
                            vertical: "Home_Contents"
                        }
                    });
                } else {
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: "trackQuoteEvent",
                        object: {
                            action: "Start",
                            transactionID: parseInt(transaction_id, 10),
                            vertical: "Home_Contents"
                        }
                    });
                }
            });
        }
    }
    function initProgressBar(render) {
        setJourneyEngineSteps();
        configureProgressBar();
        if (render) {
            meerkat.modules.journeyProgressBar.render(true);
        }
    }
    function setJourneyEngineSteps() {
        var externalTrackingSettings = {
            method: "trackQuoteForms",
            object: meerkat.modules.home.getTrackingFieldsObject
        };
        var startStep = {
            title: "Cover",
            navigationId: "start",
            slideIndex: 0,
            externalTracking: externalTrackingSettings,
            onInitialise: function onStartInit(event) {
                var $emailQuoteBtn = $(".slide-feature-emailquote");
                if ($("#home_privacyoptin").is(":checked")) {
                    $emailQuoteBtn.addClass("privacyOptinChecked");
                }
                $("#home_privacyoptin").on("change", function(event) {
                    if ($(this).is(":checked")) {
                        $emailQuoteBtn.addClass("privacyOptinChecked");
                    } else {
                        $emailQuoteBtn.removeClass("privacyOptinChecked");
                    }
                });
                meerkat.modules.currencyField.initCurrency();
            }
        };
        var occupancyStep = {
            title: "Occupancy",
            navigationId: "occupancy",
            slideIndex: 1,
            tracking: {
                touchType: "H",
                touchComment: "Occupancy",
                includeFormData: true
            },
            externalTracking: externalTrackingSettings,
            onInitialise: function() {
                meerkat.modules.homeOccupancy.initHomeOccupancy();
                meerkat.modules.homeBusiness.initHomeBusiness();
            },
            onAfterEnter: function onOccupancyEnter(event) {
                meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(1) .snapshot");
            }
        };
        var propertyStep = {
            title: "Property Details",
            navigationId: "property",
            slideIndex: 2,
            tracking: {
                touchType: "H",
                touchComment: "Property",
                includeFormData: true
            },
            externalTracking: externalTrackingSettings,
            onInitialise: function onInitialiseProperty() {
                meerkat.modules.homePropertyDetails.initHomePropertyDetails();
                meerkat.modules.homePropertyFeatures.initHomePropertyFeatures();
                meerkat.modules.homeCoverAmounts.initHomeCoverAmounts();
            },
            onBeforeEnter: function onBeforeEnterProperty(event) {
                meerkat.modules.homePropertyFeatures.toggleSecurityFeatures();
                meerkat.modules.homeCoverAmounts.toggleCoverAmountsFields();
                meerkat.modules.homePropertyDetails.validateYearBuilt();
            },
            onAfterEnter: function onPropertyEnter(event) {
                meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(2) .snapshot");
            }
        };
        var policyHoldersStep = {
            title: "You",
            navigationId: "you",
            slideIndex: 3,
            tracking: {
                touchType: "H",
                touchComment: "You",
                includeFormData: true
            },
            externalTracking: externalTrackingSettings,
            onInitialise: function onInitialisePolicyHolder() {
                meerkat.modules.homePolicyHolder.initHomePolicyHolder();
            },
            onBeforeEnter: function onBeforeEnterPolicyHolder(event) {
                meerkat.modules.homePolicyHolder.togglePolicyHolderFields();
            },
            onAfterEnter: function onPolicyHolderEnter(event) {
                meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(3) .snapshot");
            }
        };
        var historyStep = {
            title: "Cover History",
            navigationId: "history",
            slideIndex: 4,
            tracking: {
                touchType: "H",
                touchComment: "History",
                includeFormData: true
            },
            externalTracking: externalTrackingSettings,
            onInitialise: function onInitialiseHistory(event) {
                meerkat.modules.homeResults.initPage();
                meerkat.modules.homeHistory.initHomeHistory();
            },
            onAfterEnter: function onHistoryEnter(event) {
                meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(4) .snapshot");
            }
        };
        var resultsStep = {
            title: "Results",
            navigationId: "results",
            slideIndex: 5,
            externalTracking: externalTrackingSettings,
            onInitialise: function onResultsInit(event) {
                meerkat.modules.homeMoreInfo.initMoreInfo();
                meerkat.modules.homeEditDetails.initEditDetails();
                meerkat.modules.homeFilters.initHomeFilters();
            },
            onBeforeEnter: function onBeforeEnterResults(event) {
                meerkat.modules.journeyProgressBar.hide();
                $("#resultsPage").addClass("hidden");
                meerkat.modules.homeFilters.updateFilters();
            },
            onAfterEnter: function onAfterEnterResults(event) {
                if (event.isForward === true) {
                    meerkat.modules.homeResults.get();
                }
                meerkat.modules.homeFilters.show();
            },
            onBeforeLeave: function onBeforeLeaveResults(event) {
                if (event.isBackward === true) {
                    meerkat.modules.transactionId.getNew(3);
                }
            },
            onAfterLeave: function onAfterLeaveResults(event) {
                meerkat.modules.journeyProgressBar.show();
                meerkat.modules.homeFilters.hide();
                meerkat.modules.homeEditDetails.hide();
            }
        };
        steps = {
            startStep: startStep,
            occupancyStep: occupancyStep,
            propertyStep: propertyStep,
            policyHoldersStep: policyHoldersStep,
            historyStep: historyStep,
            resultsStep: resultsStep
        };
    }
    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([ {
            label: "Cover Type",
            navigationId: steps.startStep.navigationId
        }, {
            label: "Occupancy",
            navigationId: steps.occupancyStep.navigationId
        }, {
            label: "Property Details",
            navigationId: steps.propertyStep.navigationId
        }, {
            label: "You",
            navigationId: steps.policyHoldersStep.navigationId
        }, {
            label: "Cover History",
            navigationId: steps.historyStep.navigationId
        } ]);
    }
    function getTrackingFieldsObject(special_case) {
        try {
            special_case = special_case || false;
            var postCode = $("#home_property_address_postCode").val();
            var stateCode = $("#home_property_address_state").val();
            var verticalOption = $("#home_coverType").val();
            var commencementDate = $("#home_startDate").val();
            var yob = $("#home_policyHolder_dob").val();
            if (yob.length > 4) {
                yob = yob.substring(yob.length - 4);
            }
            var ownProperty = $("input[name=home_occupancy_ownProperty]:checked").val();
            var principalResidence = $("input[name=home_occupancy_principalResidence]:checked").val();
            var rebuildCost = $("#home_coverAmounts_rebuildCost").val(), replaceContentsCost = $("#home_coverAmounts_replaceContentsCost").val();
            switch (getCoverType()) {
              case "H":
                replaceContentsCost = null;
                break;

              case "C":
                rebuildCost = null;
                break;
            }
            var email = $("#home_policyHolder_email").val();
            var marketOptIn = null;
            var mVal = $("input[name=home_policyHolder_marketing]:checked").val();
            var gender = $("#home_policyHolder_title").val() == "MR" ? "M" : "F";
            if ($("#home_policyHolder_title").val() === "") {
                gender = null;
            }
            if (!_.isUndefined(mVal)) {
                marketOptIn = mVal;
            }
            var okToCall = null;
            var oVal = $("input[name=home_policyHolder_oktocall]:checked").val();
            if (!_.isUndefined(oVal)) {
                okToCall = oVal;
            }
            var transactionId = meerkat.modules.transactionId.get();
            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();
            var actionStep = "";
            switch (current_step) {
              case 0:
                actionStep = "Cover";
                break;

              case 1:
                actionStep = "Occupancy";
                break;

              case 2:
                actionStep = "Property";
                break;

              case 3:
                actionStep = "You";
                break;

              case 4:
                actionStep = "History";
                break;

              case 5:
                if (special_case === true) {
                    actionStep = "MoreInfo";
                } else {
                    actionStep = "Results";
                }
                break;
            }
            var response = {
                vertical: "Home_Contents",
                actionStep: actionStep,
                transactionID: transactionId,
                quoteReferenceNumber: transactionId,
                yearOfBirth: null,
                postCode: null,
                state: null,
                email: null,
                emailID: null,
                marketOptIn: null,
                okToCall: null
            };
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("start")) {
                _.extend(response, {
                    commencementDate: commencementDate,
                    postCode: postCode,
                    state: stateCode,
                    verticalFilter: verticalOption
                });
            }
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("occupancy")) {
                _.extend(response, {
                    ownProperty: ownProperty,
                    principalResidence: principalResidence
                });
            }
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("property")) {
                _.extend(response, {
                    replaceContentsCost: replaceContentsCost,
                    rebuildCost: rebuildCost
                });
            }
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("you")) {
                _.extend(response, {
                    yearOfBirth: yob,
                    email: email,
                    marketOptIn: marketOptIn,
                    okToCall: okToCall,
                    gender: gender
                });
            }
            return response;
        } catch (e) {
            return false;
        }
    }
    function getCoverType() {
        var value = $("#home_coverType").val();
        switch (value) {
          case "Home Cover Only":
            return "H";

          case "Contents Cover Only":
            return "C";

          case "Home & Contents Cover":
            return "HC";
        }
        return "";
    }
    meerkat.modules.register("home", {
        init: initHome,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getCoverType: getCoverType,
        getTrackingFieldsObject: getTrackingFieldsObject
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {}, steps = null;
    var elements = {
        name: "home_businessActivity",
        businessRooms: ".businessRooms",
        employees: ".hasEmployees",
        dayCareChildren: ".dayCareChildren",
        registeredDayCare: ".registeredDayCare",
        businessType: ".businessType",
        employeeAmount: ".employeeAmount"
    };
    function toggleBusinessFields(speed) {
        var businessTypeValue = $("#" + elements.name + "_businessType").find("option:selected").text().toLowerCase();
        if (businessTypeValue == "home office" || businessTypeValue == "surgery/consulting rooms") {
            $(elements.businessRooms + ", " + elements.employees).slideDown(speed);
            $(elements.dayCareChildren + ", " + elements.registeredDayCare).slideUp(speed);
            toggleEmployeeAmount();
        } else if (businessTypeValue == "day care") {
            $(elements.dayCareChildren + ", " + elements.registeredDayCare).slideDown(speed);
            $(elements.businessRooms + ", " + elements.employees + ", " + elements.employeeAmount).slideUp(speed);
        } else {
            $(elements.businessRooms + ", " + elements.employees + ", " + elements.employeeAmount + ", " + elements.dayCareChildren + ", " + elements.registeredDayCare).slideUp(speed);
        }
    }
    function toggleBusinessType(speed) {
        if ($("input[name=" + elements.name + "_conducted]:checked").val() == "Y") {
            $(elements.businessType).slideDown(speed);
            toggleBusinessFields(speed);
        } else {
            hideBusinessActivityFields(speed);
        }
    }
    function toggleEmployeeAmount(speed) {
        if ($("input[name=" + elements.name + "_employees]:checked").val() == "Y") {
            $(elements.employeeAmount).slideDown(speed);
        } else {
            $(elements.employeeAmount).slideUp(speed);
        }
    }
    function hideBusinessActivityFields(speed) {
        $(elements.businessType + ", " + elements.businessRooms + ", " + elements.employees + ", " + elements.employeeAmount + ", " + elements.dayCareChildren + ", " + elements.registeredDayCare).slideUp(speed);
    }
    function applyEventListeners() {
        $(document).ready(function() {
            $("input[name=" + elements.name + "_conducted]").on("change", function() {
                toggleBusinessType();
            });
            $("#" + elements.name + "_businessType").on("change", function() {
                toggleBusinessFields();
            });
            $("input[name=" + elements.name + "_employees]").on("change", function() {
                toggleEmployeeAmount();
            });
        });
    }
    function initHomeBusiness() {
        log("[HomeBusiness] Initialised");
        applyEventListeners();
        $(document).ready(function() {
            toggleBusinessFields(0);
            toggleEmployeeAmount(0);
            toggleBusinessType(0);
        });
    }
    meerkat.modules.register("homeBusiness", {
        initHomeBusiness: initHomeBusiness,
        events: moduleEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var $desktopField = $("#home_startDate");
    var $mobileField = $("#home_startDateDropdown_mobile");
    function applyEventListeners() {
        $desktopField.on("change", function changeCommDate(event) {
            $mobileField.val($desktopField.val());
            if ($mobileField.val() == null) {
                $mobileField.val("");
            }
        });
        $mobileField.on("change", function changeCommDate(event) {
            $desktopField.val($mobileField.val()).blur().keyup();
        });
    }
    function init() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "home") {
                return false;
            }
            if ($desktopField.val() !== "") {
                $mobileField.val($desktopField.val());
            }
            if ($mobileField.val() == null) {
                $mobileField.val("");
            }
        });
        $desktopField.attr("data-attach", "true");
        applyEventListeners();
    }
    meerkat.modules.register("homeCommencementDate", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {}, steps = null;
    var elements = {
        abovePolicyLimitsElement: "home_coverAmounts_abovePolicyLimits",
        abovePolicyLimitsAmount: ".abovePolicyLimitsAmount",
        itemsAwayElement: "home_coverAmounts_itemsAway",
        specifyPersonalEffectsElement: "home_coverAmounts_specifyPersonalEffects",
        bicycle: "#home_coverAmounts_specifiedPersonalEffects_bicycle",
        musical: "#home_coverAmounts_specifiedPersonalEffects_musical",
        clothing: "#home_coverAmounts_specifiedPersonalEffects_clothing",
        jewellery: "#home_coverAmounts_specifiedPersonalEffects_jewellery",
        sporting: "#home_coverAmounts_specifiedPersonalEffects_sporting",
        photo: "#home_coverAmounts_specifiedPersonalEffects_photo",
        coverTotal: "#home_coverAmounts_coverTotal",
        principalResidence: "home_occupancy_principalResidence",
        specifiedItems: "#specifiedItemsRows",
        abovePolicyLimits: "#abovePolicyLimitsRow",
        rebuildCost: "#rebuildCostRow",
        replaceContentsCost: "#replaceContentsCostRow",
        unspecifiedCoverAmount: "#unspecifiedCoverAmountRow",
        specifyPersonalEffects: "#specifyPersonalEffectsRow",
        itemsAway: "#itemsAwayRow",
        coverType: "#home_coverType",
        specifiedValues: ".specifiedValues"
    };
    function toggleAbovePolicyLimitsAmount(speed) {
        if ($("input[name=" + elements.abovePolicyLimitsElement + "]:checked").val() == "Y") {
            $(elements.abovePolicyLimitsAmount).slideDown(speed);
        } else {
            $(elements.abovePolicyLimitsAmount).slideUp(speed);
        }
    }
    function hideCoverAmountsFields(speed) {
        $(elements.rebuildCost + ", " + elements.replaceContentsCost).find('input[type="hidden"]').each(function() {
            var $this = $(this);
            if ($this.val() !== "") {
                $this.attr("data-value", $this.val()).val("");
            }
        });
        $(elements.abovePolicyLimits + ", " + elements.rebuildCost + ", " + elements.replaceContentsCost + ", " + elements.abovePolicyLimitsAmount + ", " + elements.itemsAway + ", " + elements.unspecifiedCoverAmount + ", " + elements.specifiedItems + ", " + elements.specifyPersonalEffects).slideUp(speed);
    }
    function toggleCoverAmountsFields(speed) {
        hideCoverAmountsFields(speed);
        var coverType = $(elements.coverType).find("option:selected").val();
        switch (coverType) {
          case "Home Cover Only":
            $(elements.rebuildCost).slideDown(speed);
            $hidden = $(elements.rebuildCost + ' input[type="hidden"]');
            $hidden.val($hidden.attr("data-value"));
            break;

          case "Contents Cover Only":
            $(elements.replaceContentsCost + ", " + elements.abovePolicyLimits + ", " + elements.itemsAway + ", " + elements.specifyPersonalEffects).slideDown(speed);
            $hidden = $(elements.replaceContentsCost + ' input[type="hidden"]');
            $hidden.val($hidden.attr("data-value"));
            break;

          case "Home & Contents Cover":
            $(elements.rebuildCost + ", " + elements.replaceContentsCost + ", " + elements.abovePolicyLimits + ", " + elements.itemsAway + ", " + elements.specifyPersonalEffects).slideDown(speed);
            $hidden = $(elements.rebuildCost + ' input[type="hidden"]');
            $hidden.val($hidden.attr("data-value"));
            $hidden = $(elements.replaceContentsCost + ' input[type="hidden"]');
            $hidden.val($hidden.attr("data-value"));
            break;

          default:
            break;
        }
        togglePersonalEffectsFields();
    }
    function updateTotalPersonalEffects() {
        var bicycle = Number($(elements.bicycle).val());
        var musical = Number($(elements.musical).val());
        var clothing = Number($(elements.clothing).val());
        var jewellery = Number($(elements.jewellery).val());
        var sporting = Number($(elements.sporting).val());
        var photo = Number($(elements.photo).val());
        var totalVal = bicycle + musical + clothing + jewellery + sporting + photo;
        $(elements.coverTotal).val(totalVal).trigger("blur");
    }
    function togglePersonalEffectsFields(speed) {
        var coverType = $(elements.coverType).find("option:selected").val();
        var isPrincipalResidence = meerkat.modules.homeOccupancy.isPrincipalResidence();
        if ($("input[name=" + elements.itemsAwayElement + "]:checked").val() == "Y") {
            $(elements.unspecifiedCoverAmount + ", " + elements.specifyPersonalEffects).slideDown(speed);
            if ($("input[name=" + elements.specifyPersonalEffectsElement + "]:checked").val() == "Y") {
                $(elements.specifiedItems).slideDown(speed);
            } else {
                $(elements.specifiedItems).slideUp(speed);
            }
        } else {
            hidePersonalEffectsFields(speed);
        }
        if (isPrincipalResidence && $.inArray(coverType, [ "Home & Contents Cover", "Contents Cover Only" ]) != -1) {
            $(elements.itemsAway).slideDown(speed);
        } else {
            $(elements.itemsAway).slideUp(speed);
            hidePersonalEffectsFields(speed);
        }
    }
    function hidePersonalEffectsFields(speed) {
        $(elements.unspecifiedCoverAmount + ", " + elements.specifyPersonalEffects + ", " + elements.specifiedItems).slideUp(speed);
    }
    function applyEventListeners() {
        $(document).ready(function() {
            $("input[name=" + elements.abovePolicyLimitsElement + "]").on("change", function() {
                toggleAbovePolicyLimitsAmount();
            });
            $("input[name=" + elements.itemsAwayElement + "], input[name=" + elements.specifyPersonalEffectsElement + "]").on("change", function() {
                togglePersonalEffectsFields();
            });
            $(elements.specifiedValues).on("blur", function() {
                updateTotalPersonalEffects();
            });
        });
    }
    function initHomeCoverAmounts() {
        log("[HomeCoverAmounts] Initialised");
        applyEventListeners();
        $(document).ready(function() {
            toggleAbovePolicyLimitsAmount(0);
            togglePersonalEffectsFields(0);
        });
    }
    meerkat.modules.register("homeCoverAmounts", {
        initHomeCoverAmounts: initHomeCoverAmounts,
        toggleCoverAmountsFields: toggleCoverAmountsFields,
        events: moduleEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        homeEditDetails: {}
    }, moduleEvents = events.homeEditDetails;
    var $editDetailsDropDown = $("#edit-details-dropdown"), modalId = null;
    function initEditDetails() {
        applyEventListeners();
        eventSubscriptions();
    }
    function applyEventListeners() {
        $editDetailsDropDown.on("show.bs.dropdown", function() {
            var $e = $("#edit-details-template");
            if ($e.length > 0) {
                templateCallback = _.template($e.html());
            }
            var data = {
                coverType: $("#home_coverType").val(),
                icon: meerkat.modules.homeSnapshot.getIcon(),
                ownsHome: $("#home_occupancy_ownProperty_Y").is(":checked"),
                isPrincipalResidence: $("#home_occupancy_principalResidence_Y").is(":checked"),
                businessActivity: $("#home_businessActivity_conducted_Y").is(":checked"),
                isBodyCorp: $("#home_property_bodyCorp_Y").is(":checked"),
                hasInternalSiren: $("#home_property_securityFeatures_internalSiren").is(":checked"),
                hasExternalSiren: $("#home_property_securityFeatures_externalSiren").is(":checked"),
                hasExternalStrobe: $("#home_property_securityFeatures_strobeLight").is(":checked"),
                hasBackToBase: $("#home_property_securityFeatures_backToBase").is(":checked"),
                isSpecifyingPersonalEffects: $("#home_coverAmounts_itemsAway_Y").is(":checked"),
                specifiedPersonalEffects: $("#home_coverAmounts_specifyPersonalEffects_Y").is(":checked"),
                bicycles: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_bicycleentry"),
                musical: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_musicalentry"),
                clothing: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_clothingentry"),
                jewellery: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_jewelleryentry"),
                sporting: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_sportingentry"),
                photography: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_photoentry"),
                hasOlderResident: $("#home_policyHolder_anyoneOlder_Y").is(":checked"),
                hasRetiredOver55: $("#home_policyHolder_over55_Y").is(":checked"),
                previousCover: $("#home_disclosures_previousInsurance_Y").is(":checked"),
                previousClaims: $("#home_disclosures_claims_Y").is(":checked")
            };
            show(templateCallback(data));
        }).on("click", ".dropdown-container", function(e) {
            e.stopPropagation();
        });
    }
    function hasPersonalEffects(selector) {
        $el = $(selector);
        if ($el.val() === "$0" || $el.val() === "") {
            return false;
        }
        return true;
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockEditDetails(obj) {
            hide();
            $editDetailsDropDown.children(".activator").addClass("inactive").addClass("disabled");
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockEditDetails(obj) {
            $editDetailsDropDown.children(".activator").removeClass("inactive").removeClass("disabled");
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function editDetailsEnterXsState() {
            hide();
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function editDetailsLeaveXsState() {
            hide();
        });
    }
    function show(htmlContent) {
        if (meerkat.modules.deviceMediaState.get() == "xs") {
            modalId = showModal(htmlContent);
        } else {
            showDropDown(htmlContent);
        }
    }
    function hide() {
        if ($editDetailsDropDown.hasClass("open")) {
            $editDetailsDropDown.find(".activator").dropdown("toggle").end().find(".edit-details-wrapper").empty();
        }
        if (modalId !== null) {
            $("#" + modalId).modal("hide");
        }
    }
    function showModal(htmlContent) {
        var modalId = meerkat.modules.dialogs.show({
            htmlContent: '<div class="edit-details-wrapper"></div>',
            hashId: "edit-details",
            className: "edit-details-modal",
            closeOnHashChange: true,
            onOpen: function(modalId) {
                var $editDetails = $(".edit-details-wrapper", $("#" + modalId));
                $editDetails.html(htmlContent);
                meerkat.modules.contentPopulation.render("#" + modalId + " .edit-details-wrapper");
                $(".accordion-collapse").on("show.bs.collapse", function() {
                    $(this).prev(".accordion-heading").addClass("active-panel");
                }).on("hide.bs.collapse", function() {
                    $(this).prev(".accordion-heading").removeClass("active-panel");
                });
                $editDetails.show();
            }
        });
        return modalId;
    }
    function showDropDown(htmlContent) {
        var $editDetails = $("#edit-details-dropdown .edit-details-wrapper");
        $editDetails.html(htmlContent);
        meerkat.modules.contentPopulation.render("#edit-details-dropdown .edit-details-wrapper");
        $editDetails.find(".accordion-collapse").addClass("in").end().show();
    }
    meerkat.modules.register("homeEditDetails", {
        initEditDetails: initEditDetails,
        events: events,
        hide: hide
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        homeFilters: {
            CHANGED: "HOME_FILTERS_CHANGED"
        }
    }, moduleEvents = events.homeFilters;
    var $component;
    var $priceMode;
    var $featuresMode;
    var $filterFrequency, $filterHomeExcess, $filterContentsExcess, $filterHomeExcessLabel, $filterContentsExcessLabel;
    var deviceStateXS = false;
    var modalID = false;
    var currentValues = {
        display: false,
        frequency: false,
        homeExcess: false,
        contentsExcess: false
    };
    function updateFilters() {
        hideExcessLists();
        $priceMode.removeClass("active");
        $featuresMode.removeClass("active");
        var coverType = meerkat.modules.home.getCoverType();
        if (typeof Results.settings !== "undefined" && Results.settings.hasOwnProperty("displayMode") === true) {
            switch (Results.getDisplayMode()) {
              case "price":
                $priceMode.addClass("active");
                break;

              case "features":
                $featuresMode.addClass("active");
                break;
            }
        }
        var freq = $("#home_paymentType").val();
        if (typeof freq === "undefined") {
            $filterFrequency.find(".dropdown-toggle span").text($filterFrequency.find(".dropdown-menu a:first").text());
        } else {
            $filterFrequency.find(".dropdown-toggle span").text($filterFrequency.find('.dropdown-menu a[data-value="' + freq + '"]').text());
        }
        if (coverType == "H" || coverType == "HC") {
            if (typeof currentValues.homeExcess === "undefined") {
                $filterHomeExcess.find(".dropdown-toggle span").text($filterHomeExcess.find(".dropdown-menu a:first").text());
            } else {
                $filterHomeExcess.find(".dropdown-toggle span").text($filterHomeExcess.find('.dropdown-menu a[data-value="' + currentValues.homeExcess + '"]').text());
            }
        }
        if (coverType == "C" || coverType == "HC") {
            if (typeof currentValues.contentsExcess === "undefined") {
                $filterContentsExcess.find(".dropdown-toggle span").text($filterContentsExcess.find(".dropdown-menu a:first").text());
            } else {
                $filterContentsExcess.find(".dropdown-toggle span").text($filterContentsExcess.find('.dropdown-menu a[data-value="' + currentValues.contentsExcess + '"]').text());
            }
        }
    }
    function hideExcessLists() {
        var coverType = meerkat.modules.home.getCoverType();
        switch (coverType) {
          case "H":
            $filterHomeExcess.add($filterHomeExcessLabel).show();
            $filterContentsExcess.add($filterContentsExcessLabel).add(".excess-update").hide();
            $filterHomeExcess.find("li a").addClass("updateExcess");
            return;

          case "C":
            $filterHomeExcess.add($filterHomeExcessLabel).add(".excess-update").hide();
            $filterContentsExcess.add($filterContentsExcessLabel).show();
            $filterContentsExcess.find("li a").addClass("updateExcess");
            return;

          case "HC":
            $filterHomeExcess.add($filterHomeExcessLabel).add($filterContentsExcess).add($filterContentsExcessLabel).add(".excess-update").show();
            $filterContentsExcess.find("li a").removeClass("updateExcess");
            return;
        }
    }
    function toggleXSFilters() {
        var coverType = meerkat.modules.home.getCoverType();
        var homeXSFilterRow = $("#xsFilterBarHomeExcessRow");
        var contentsXSFilterRow = $("#xsFilterBarContentsExcessRow");
        switch (coverType) {
          case "H":
            homeXSFilterRow.show();
            contentsXSFilterRow.hide();
            return;

          case "C":
            homeXSFilterRow.hide();
            contentsXSFilterRow.show();
            return;

          case "HC":
            homeXSFilterRow.add(contentsXSFilterRow).show();
            return;
        }
    }
    function handleDropdownOption(event) {
        event.preventDefault();
        var $menuOption = $(event.target);
        if ($menuOption.hasClass("updateExcess")) {
            updateExcessValue(event);
            updateFilters();
        } else {
            var $dropdown = $menuOption.parents(".dropdown");
            var value = $menuOption.attr("data-value");
            $dropdown.find(".dropdown-toggle span").text($menuOption.text());
            $menuOption.parent().siblings().removeClass("active");
            $menuOption.parent().addClass("active");
            if ($dropdown.hasClass("filter-frequency")) {
                if (value !== currentValues.frequency) {
                    currentValues.frequency = value;
                    $("#home_paymentType").val(currentValues.frequency);
                    Results.setFrequency(value);
                    meerkat.messaging.publish(moduleEvents.CHANGED);
                }
            }
        }
    }
    function updateExcessValue(event) {
        var coverType = meerkat.modules.home.getCoverType();
        event.preventDefault();
        var $menuOption = $(event.target);
        var homeValue, contentsValue;
        if ($menuOption.text() === "update") {
            homeValue = $(".homeExcess .dropdown-toggle span").text().replace("$", "");
            contentsValue = $(".contentsExcess .dropdown-toggle span").text().replace("$", "");
        } else {
            homeValue = $menuOption.text().replace("$", "");
            contentsValue = $menuOption.text().replace("$", "");
        }
        if (homeValue !== currentValues.homeExcess && (coverType == "H" || coverType == "HC")) {
            currentValues.homeExcess = homeValue;
            $("#home_homeExcess").val(homeValue);
        }
        if (contentsValue !== currentValues.contentsExcess && (coverType == "C" || coverType == "HC")) {
            currentValues.contentsExcess = contentsValue;
            $("#home_contentsExcess").val(contentsValue);
        }
        if (coverType == "H") {
            meerkat.messaging.publish(moduleEvents.CHANGED, {
                homeExcess: homeValue
            });
        } else if (coverType == "C") {
            meerkat.messaging.publish(moduleEvents.CHANGED, {
                contentsExcess: contentsValue
            });
        } else {
            meerkat.messaging.publish(moduleEvents.CHANGED, {
                contentsExcess: contentsValue,
                homeExcess: homeValue
            });
        }
    }
    function storeCurrentValues() {
        currentValues = {
            display: Results.getDisplayMode(),
            frequency: $("#home_paymentType").val(),
            homeExcess: $("#home_homeExcess").val() || currentValues.homeExcess,
            contentsExcess: $("#home_contentsExcess").val() || currentValues.contentsExcess
        };
    }
    function setDefaultExcess() {
        currentValues = {
            homeExcess: $("#home_baseHomeExcess").val(),
            contentsExcess: $("#home_baseContentsExcess").val()
        };
    }
    function preselectDropdowns() {
        $filterFrequency.find("li.active").removeClass("active");
        $filterFrequency.find("a[data-value=" + currentValues.frequency + "]").each(function() {
            $(this).parent().addClass("active");
        });
        $filterHomeExcess.find("li.active").removeClass("active");
        $filterContentsExcess.find("li.active").removeClass("active");
        if (!_.isEmpty(currentValues.homeExcess)) {
            $filterHomeExcess.find("a[data-value=" + currentValues.homeExcess + "]").each(function() {
                $(this).parent().addClass("active");
            });
        }
        if (!_.isEmpty(currentValues.contentsExcess)) {
            $filterContentsExcess.find("a[data-value=" + currentValues.contentsExcess + "]").each(function() {
                $(this).parent().addClass("active");
            });
        }
    }
    function hide() {
        $component.slideUp(200, function hideDone() {
            $component.addClass("hidden");
        });
    }
    function show() {
        $component.removeClass("hidden").hide().slideDown(200);
        storeCurrentValues();
        preselectDropdowns();
    }
    function disable() {
        $component.find("li.dropdown, .dropdown-toggle").addClass("disabled");
        $priceMode.addClass("disabled").find("a").addClass("disabled");
        $featuresMode.addClass("disabled").find("a").addClass("disabled");
        $(".slide-feature-filters").find("a").addClass("disabled").addClass("inactive");
        $(".excess-update").find("a").addClass("disabled").addClass("inactive");
    }
    function enable() {
        $component.find("li.dropdown, .dropdown-toggle").removeClass("disabled");
        $priceMode.removeClass("disabled").find("a").removeClass("disabled");
        $featuresMode.removeClass("disabled").find("a").removeClass("disabled");
        $(".slide-feature-filters").find("a").removeClass("inactive").removeClass("disabled");
        $(".excess-update").find("a").removeClass("inactive").removeClass("disabled");
    }
    function eventSubscriptions() {
        $(document).on("resultsFetchStart pagination.scrolling.start", function onResultsFetchStart() {
            disable();
        });
        $(document).on("resultsFetchFinish pagination.scrolling.end", function onResultsFetchStart() {
            enable();
        });
        $priceMode.on("click", function filterPrice(event) {
            event.preventDefault();
            if ($(this).hasClass("disabled")) return;
            meerkat.modules.homeResults.switchToPriceMode(true);
            updateFilters();
            meerkat.modules.session.poke();
        });
        $featuresMode.on("click", function filterFeatures(event) {
            event.preventDefault();
            if ($(this).hasClass("disabled")) return;
            meerkat.modules.homeResults.switchToFeaturesMode(true);
            updateFilters();
            meerkat.modules.session.poke();
        });
        $component.on("click", ".dropdown-menu a, .excess-update a", handleDropdownOption);
    }
    function renderModal() {
        var templateAccessories = _.template($("#home-xsFilterBar-template").html());
        var homeExcess = $("#home_homeExcess").val();
        var contentsExcess = $("#home_contentsExcess").val();
        var htmlContent = templateAccessories({
            homeStartingValue: _.isEmpty(homeExcess) ? $("#home_baseHomeExcess").val() : homeExcess,
            contentsStartingValue: _.isEmpty(contentsExcess) ? $("#home_baseContentsExcess").val() : contentsExcess
        });
        modalID = meerkat.modules.dialogs.show({
            title: $(this).attr("title"),
            htmlContent: htmlContent,
            hashId: "xsFilterBar",
            rightBtn: {
                label: "Save Changes",
                className: "btn-sm btn-save",
                callback: saveModalChanges
            },
            closeOnHashChange: true,
            onOpen: onModalOpen
        });
        return false;
    }
    function onModalOpen(modal) {
        if (typeof Results.settings !== "undefined" && Results.settings.hasOwnProperty("displayMode") === true) {
            $("#xsFilterBarSortRow input:checked").prop("checked", false);
            $("#xsFilterBarSortRow #xsFilterBar_sort_" + Results.getDisplayMode()).prop("checked", true).change();
        }
        $("#xsFilterBarFreqRow input:checked").prop("checked", false);
        $("#xsFilterBarFreqRow #xsFilterBar_freq_" + $("#home_paymentType").val()).prop("checked", true).change();
        $("input[name=xsFilterBar_homeExcess], input[name=xsFilterBar_contentsexcess]", $("#" + modal)).prop("checked", false);
        $("#xsFilterBar_homeExcess_" + currentValues.homeExcess, $("#" + modal)).prop("checked", true).change();
        $("#xsFilterBar_contentsexcess_" + currentValues.contentsExcess, $("#" + modal)).prop("checked", true).change();
        toggleXSFilters();
    }
    function saveModalChanges() {
        var $freq = $("#home_paymentType");
        var $homeExcess = $("#home_homeExcess");
        var $contentsExcess = $("#home_contentsExcess");
        var revised = {
            display: $("#xsFilterBarSortRow input:checked").val(),
            freq: $("#xsFilterBarFreqRow input:checked").val(),
            homeExcess: $("#xsFilterBarHomeExcessRow input:checked").val(),
            contentsExcess: $("#xsFilterBarContentsExcessRow input:checked").val()
        };
        if (Number(revised.homeExcess) === 0) {
            revised.homeExcess = "";
        }
        if (Number(revised.contentsExcess) === 0) {
            revised.contentsExcess = "";
        }
        $freq.val(revised.freq);
        $homeExcess.val(revised.homeExcess);
        $contentsExcess.val(revised.contentsExcess);
        if (revised.display !== currentValues.display) {
            if (revised.display === "features") {
                meerkat.modules.homeResults.switchToFeaturesMode(true);
            } else if (revised.display === "price") {
                meerkat.modules.homeResults.switchToPriceMode(true);
            }
        }
        meerkat.modules.dialogs.close(modalID);
        meerkat.modules.navMenu.close();
        if (currentValues.frequency !== revised.freq) {
            currentValues.frequency = revised.freq;
            Results.setFrequency(currentValues.frequency);
            meerkat.messaging.publish(moduleEvents.CHANGED);
        }
        if (currentValues.homeExcess !== revised.homeExcess) {
            currentValues.homeExcess = revised.homeExcess;
            meerkat.messaging.publish(moduleEvents.CHANGED, {
                homeExcess: revised.homeExcess
            });
        }
        if (currentValues.contentsExcess !== revised.contentsExcess) {
            currentValues.contentsExcess = revised.contentsExcess;
            meerkat.messaging.publish(moduleEvents.CHANGED, {
                contentsExcess: revised.contentsExcess
            });
        }
        updateFilters();
    }
    function onRequestModal() {
        var is_active = !$("#navbar-filter").hasClass("hidden");
        if (is_active && deviceStateXS === true) {
            storeCurrentValues();
            renderModal();
        }
    }
    function setCurrentDeviceState(data) {
        if (_.isUndefined(data)) {
            deviceStateXS = meerkat.modules.deviceMediaState.get() === "xs";
        } else {
            deviceStateXS = data.isXS === true;
        }
        if (deviceStateXS === false) {
            if (meerkat.modules.dialogs.isDialogOpen(modalID)) {
                meerkat.modules.dialogs.close(modalID);
            }
        }
    }
    function initHomeFilters() {
        log("[HomeFilters] Initialised");
        $(document).ready(function onReady() {
            $component = $("#navbar-filter");
            if (!$component.length) return;
            $priceMode = $component.find(".filter-pricemode");
            $featuresMode = $component.find(".filter-featuresmode");
            $filterFrequency = $component.find(".filter-frequency");
            $filterHomeExcess = $component.find(".filter-excess.homeExcess");
            $filterContentsExcess = $component.find(".filter-excess.contentsExcess");
            $filterHomeExcessLabel = $component.find(".filter-label.homeExcessLabel");
            $filterContentsExcessLabel = $component.find(".filter-label.contentsExcessLabel");
            setDefaultExcess();
            eventSubscriptions();
            var $filterMenu;
            $filterMenu = $filterHomeExcess.find(".dropdown-menu");
            $("#filter_homeExcessOptions option").each(function() {
                $filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + "</a></li>");
            });
            $filterMenu = $filterContentsExcess.find(".dropdown-menu");
            $("#filter_contentsExcessOptions option").each(function() {
                $filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + "</a></li>");
            });
            $filterMenu = $filterFrequency.find(".dropdown-menu");
            $("#filter_paymentType option").each(function() {
                $filterMenu.append('<li><a href="javascript:;" data-value="' + this.value + '">' + this.text + "</a></li>");
            });
            $("#navbar-main .slide-feature-filters a").on("click", function(e) {
                e.preventDefault();
                if (!$(this).hasClass("disabled")) {
                    onRequestModal();
                }
            });
            meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, _.bind(setCurrentDeviceState, this, {
                isXS: true
            }));
            meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, _.bind(setCurrentDeviceState, this, {
                isXS: false
            }));
            setCurrentDeviceState();
        });
    }
    meerkat.modules.register("homeFilters", {
        initHomeFilters: initHomeFilters,
        events: events,
        updateFilters: updateFilters,
        hide: hide,
        show: show,
        disable: disable,
        enable: enable,
        onRequestModal: onRequestModal,
        toggleXSFilters: toggleXSFilters
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var elements = {
        name: "home_disclosures",
        atCurrentAddress: ".atCurrentAddress",
        pastInsurer: ".pastInsurer",
        insuranceExpiry: ".insuranceExpiry",
        insuranceCoverLength: ".insuranceCoverLength"
    };
    function toggleHistoryFields(speed) {
        if ($("input[name=" + elements.name + "_previousInsurance]:checked").val() == "Y") {
            $(elements.atCurrentAddress + ", " + elements.pastInsurer + ", " + elements.insuranceExpiry + ", " + elements.insuranceCoverLength).slideDown(speed);
        } else {
            $(elements.atCurrentAddress + ", " + elements.pastInsurer + ", " + elements.insuranceExpiry + ", " + elements.insuranceCoverLength).slideUp(speed);
        }
    }
    function applyEventListeners() {
        $("input[name=" + elements.name + "_previousInsurance]").on("change", function prevInsChange() {
            toggleHistoryFields();
        });
    }
    function initHomeHistory() {
        log("[HomeHistory] Initialised");
        $(document).ready(function initDomReady() {
            applyEventListeners();
            toggleHistoryFields(0);
        });
    }
    meerkat.modules.register("homeHistory", {
        initHomeHistory: initHomeHistory
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var events = {
        homeMoreInfo: {}
    }, moduleEvents = events.homeMoreInfo;
    var $bridgingContainer = $(".bridgingContainer"), callDirectLeadFeedSent = {}, specialConditionContent = "", hasSpecialConditions = false, callbackModalId, scrapeType;
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
            onBeforeShowBridgingPage: onBeforeShowBridgingPage,
            onBeforeShowTemplate: renderScrapes,
            onBeforeShowModal: renderScrapes,
            onAfterShowModal: null,
            onAfterShowTemplate: onAfterShowTemplate,
            onBeforeHideTemplate: null,
            onAfterHideTemplate: onAfterHideTemplate,
            onClickApplyNow: onClickApplyNow,
            onBeforeApply: null,
            onApplySuccess: onApplySuccess,
            retrieveExternalCopy: retrieveExternalCopy,
            additionalTrackingData: {
                vertical: "Home_Contents",
                verticalFilter: $("#home_coverType").val()
            }
        };
        meerkat.modules.moreInfo.initMoreInfo(options);
        eventSubscriptions();
        applyEventListeners();
    }
    function applyEventListeners() {
        $(document).on("click", ".bridgingContainer .btn-call-actions", function(event) {
            event.preventDefault();
            event.stopPropagation();
            var $el = $(this);
            var $e = $("#home-call-modal-template");
            if ($e.length) {
                templateCallback = _.template($e.html());
            }
            var obj = meerkat.modules.moreInfo.getOpenProduct();
            if (obj.productAvailable !== "Y") return;
            var htmlContent = templateCallback(obj);
            var modalOptions = {
                htmlContent: htmlContent,
                hashId: "call",
                className: "call-modal",
                closeOnHashChange: true,
                openOnHashChange: false,
                onOpen: function(modalId) {
                    $("." + $el.attr("data-callback-toggle")).show();
                    fixSidebarHeight(".paragraphedContent:visible", ".sidebar-right", $("#" + modalId));
                    setupCallbackForm();
                    if ($el.hasClass("btn-calldirect")) {
                        recordCallDirect(event);
                    } else {
                        trackCallBack();
                    }
                }
            };
            if (meerkat.modules.deviceMediaState.get() == "xs") {
                modalOptions.title = "Reference no. " + obj.leadNo;
            }
            callbackModalId = meerkat.modules.dialogs.show(modalOptions);
        }).on("click", ".call-modal .btn-call-actions", function(event) {
            if (meerkat.modules.deviceMediaState.get() != "xs") {
                event.preventDefault();
            }
            event.stopPropagation();
            var $el = $(this);
            switch ($el.attr("data-callback-toggle")) {
              case "calldirect":
                $(".callback").hide();
                $(".calldirect").show();
                recordCallDirect(event);
                break;

              case "callback":
                $(".calldirect").hide();
                $(".callback").show();
                trackCallBack();
                break;
            }
            fixSidebarHeight(".paragraphedContent:visible", ".sidebar-right", $el.closest(".modal.in"));
        }).on("click", ".btn-submit-callback", function(event) {
            event.preventDefault();
            var $el = $(this);
            if ($el.closest("form").valid()) {
                var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();
                callLeadFeedSave(event, {
                    message: currentBrandCode + " - Home Vertical - Call me now",
                    phonecallme: "GetaCall"
                });
                trackCallBackSubmit();
            } else {
                _.delay(function() {
                    fixSidebarHeight(".paragraphedContent:visible", ".sidebar-right", $el.closest(".modal.in"));
                }, 200);
            }
            return false;
        });
    }
    function setupCallbackForm() {
        setupDefaultValidationOnForm($("#getcallback"));
        var clientName = "";
        if ($("#CrClientName").val() !== "" && $("#CrClientName").val() !== undefined) {
            clientName = $("#CrClientName").val();
        } else if (($("#home_policyHolder_firstName").val() !== undefined || $("#home_policyHolder_lastName").val() !== undefined) && $("#home_policyHolder_firstName").val() !== "" || $("#home_policyHolder_lastName").val() !== "") {
            clientName = $("#home_policyHolder_firstName").val() + " " + $("#home_policyHolder_lastName").val();
        }
        clientName.trim();
        telNum = $("#home_CrClientTelinput");
        if (telNum.length && !telNum.val().length) {
            telNum.val($("#home_policyHolder_phone").val());
        }
        telNum.attr("data-msg-required", "Please enter your contact number");
    }
    function fixSidebarHeight(leftSelector, rightSelector, $container) {
        if (meerkat.modules.deviceMediaState.get() != "xs") {
            if ($(rightSelector, $container).length) {
                var leftHeight = $(leftSelector, $container).outerHeight();
                var rightHeight = $(rightSelector, $container).outerHeight();
                if (leftHeight >= rightHeight) {
                    $(rightSelector, $container).css("min-height", leftHeight + "px");
                    $(leftSelector, $container).css("min-height", leftHeight + "px");
                } else {
                    $(rightSelector, $container).css("min-height", rightHeight + "px");
                    $(leftSelector, $container).css("min-height", rightHeight + "px");
                }
            }
        }
    }
    function recordCallDirect(event) {
        var currProduct = meerkat.modules.moreInfo.getOpenProduct();
        if (typeof callDirectLeadFeedSent[currProduct.productId] != "undefined") return;
        trackCallDirect();
        var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();
        return callLeadFeedSave(event, {
            message: currentBrandCode + " - Home Vertical - Call direct",
            phonecallme: "CallDirect"
        });
    }
    function callLeadFeedSave(event, data) {
        var currProduct = meerkat.modules.moreInfo.getOpenProduct();
        if (typeof currProduct !== "undefined" && currProduct !== null && typeof currProduct.vdn !== "undefined" && !_.isEmpty(currProduct.vdn) && currProduct.vdn > 0) {
            data.vdn = currProduct.vdn;
        }
        var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();
        var clientName = "";
        var clientTel = "";
        var CrClientName = $("#CrClientName").val();
        var firstName = $("#home_policyHolder_firstName").val();
        var lastName = $("#home_policyHolder_lastName").val();
        var CrClientTel = $("#CrClientTel").val();
        var policyHolderPhone = $("#home_policyHolder_phone").val();
        if (typeof CrClientName !== "undefined") {
            clientName = CrClientName;
        } else if (firstName !== "" || lastName !== "") {
            clientName = firstName + " " + lastName;
        }
        if (CrClientTel !== "") {
            clientTel = CrClientTel;
        } else if (policyHolderPhone !== "") {
            clientTel = policyHolderPhone;
        }
        var defaultData = {
            source: currentBrandCode + "HOME",
            leadNo: currProduct.leadNo,
            client: clientName,
            clientTel: $("#home_CrClientTelinput").val() || "",
            state: $("#home_property_address_state").val(),
            brand: currProduct.productId.split("-")[0],
            transactionId: meerkat.modules.transactionId.get()
        };
        var allData = $.extend(defaultData, data);
        var $element = $(event.target);
        meerkat.modules.loadingAnimation.showInside($element, true);
        return meerkat.modules.comms.post({
            url: "ajax/write/lead_feed_save.jsp",
            data: allData,
            dataType: "json",
            cache: false,
            errorLevel: data.phonecallme === "GetaCall" ? "warning" : "silent",
            onSuccess: function onSubmitSuccess(resultData) {
                if (data.phonecallme == "GetaCall") {
                    var modalId = meerkat.modules.dialogs.show({
                        title: "Call back request recorded",
                        htmlContent: "<p><strong>Thank you!</strong></p><p>Your Call request has been sent to the insurer's message centre who will be in touch as soon as possible.</p>",
                        hashId: "call-back-success",
                        openOnHashChange: false,
                        closeOnHashChange: true,
                        onClose: function(modalId) {
                            $(".modal").modal("hide");
                            if (meerkat.modules.moreInfo.isBridgingPageOpen()) {
                                meerkat.modules.moreInfo.close();
                            }
                        }
                    });
                }
            },
            onComplete: function onSubmitComplete() {
                if (data.phonecallme == "CallDirect") {
                    callDirectLeadFeedSent[currProduct.productId] = true;
                }
                meerkat.modules.loadingAnimation.hide($element);
            }
        });
    }
    function updateQuoteSummaryTable() {
        var $table = $(".quote-summary-table");
        $table.find("tbody tr").remove();
        var rowHTML = "";
        var addRow = function(coverType, coverAmount) {
            coverAmount = coverAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            var tempHTML = [ "<tr>", "<td>", coverType, "</td>", '<td class="cover-amount">', "$<span>", coverAmount, "</span>", "</td>", "</tr>" ].join("");
            rowHTML += tempHTML;
        };
        var coverType = meerkat.modules.home.getCoverType();
        if (coverType == "H" || coverType == "HC") {
            var rebuildCost = parseInt($("#home_coverAmounts_rebuildCost").val());
            addRow("Home Cover", rebuildCost);
        }
        if (coverType == "C" || coverType == "HC") {
            var contentsCost = parseInt($("#home_coverAmounts_replaceContentsCost").val());
            addRow("Contents Cover", contentsCost);
            if ($(".itemsAway :checked").val() == "Y") {
                var totalPersonalEffects = parseInt($("#home_coverAmounts_unspecifiedCoverAmount").val());
                if ($(".specifyPersonalEffects :checked").val() == "Y") {
                    $('.specifiedItems input[type="hidden"]').each(function() {
                        var itemValue = this.value || 0;
                        totalPersonalEffects += parseInt(itemValue);
                    });
                }
                addRow("Personal Effects", totalPersonalEffects);
            }
        }
        $table.append(rowHTML);
    }
    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function bridgingPageHashChange(event) {
            if (meerkat.modules.deviceMediaState.get() != "xs" && event.hash.indexOf("results/moreinfo") == -1) {
                meerkat.modules.moreInfo.hideTemplate($bridgingContainer);
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState() {
            if (meerkat.modules.moreInfo.isBridgingPageOpen()) {
                meerkat.modules.moreInfo.close();
            }
            if (typeof callbackModalId != "undefined") {
                $("#" + callbackModalId).modal("hide");
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState() {
            if (meerkat.modules.moreInfo.isModalOpen()) {
                meerkat.modules.moreInfo.close();
            }
            if (typeof callbackModalId != "undefined") {
                $("#" + callbackModalId).modal("hide");
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.errorHandling.OK_CLICKED, function errorHandlingOkClicked() {
            if (meerkat.modules.moreInfo.isBridgingPageOpen() || meerkat.modules.moreInfo.isModalOpen()) {
                meerkat.modules.moreInfo.close();
            }
        });
    }
    function onBeforeShowBridgingPage() {
        if (meerkat.modules.deviceMediaState.get() != "xs") {
            $(".resultsContainer, #navbar-compare, #navbar-filter").hide();
        }
    }
    function onAfterShowTemplate() {
        if (meerkat.modules.deviceMediaState.get() == "lg" || meerkat.modules.deviceMediaState.get() == "md") {
            fixSidebarHeight(".paragraphedContent", ".moreInfoRightColumn", $bridgingContainer);
        }
    }
    function onAfterHideTemplate() {
        $(".resultsContainer, #navbar-filter").show();
    }
    function runDisplayMethod(productId) {
        if (meerkat.modules.deviceMediaState.get() != "xs") {
            meerkat.modules.moreInfo.showTemplate($bridgingContainer);
        } else {
            meerkat.modules.moreInfo.showModal();
        }
        meerkat.modules.address.appendToHash("moreinfo");
    }
    function retrieveExternalCopy(product) {
        setScrapeType();
        return meerkat.modules.comms.get({
            url: "ajax/json/get_scrapes.jsp",
            cache: true,
            data: {
                type: "homeBrandScrapes",
                code: product.productId,
                group: "home"
            },
            errorLevel: "silent",
            onSuccess: function(result) {
                meerkat.modules.moreInfo.setDataResult(result);
            }
        });
    }
    function getTransferUrl(product) {
        try {
            return "transferring.jsp?url=" + escape(product.quoteUrl) + "&trackCode=" + product.trackCode + "&brand=" + escape(product.productDes) + "&msg=" + $("#transferring_" + product.productId).text() + "&transactionId=" + meerkat.modules.transactionId.get();
        } catch (e) {
            meerkat.modules.errorHandling.error({
                errorLevel: "warning",
                message: "An error occurred. Sorry about that!<br /><br /> To purchase this policy, please contact the provider " + (product.telNo !== "" ? " on " + product.telNo : "directly") + " quoting " + product.leadNo + ", or select another policy.",
                page: "homeMoreInfo.js:getTransferUrl",
                description: "Unable to generate transferring URL",
                data: product
            });
            return "";
        }
    }
    function onClickApplyNow(product, applyNowCallback) {
        if (hasSpecialConditions === true && specialConditionContent.length) {
            var $e = $("#special-conditions-template");
            if ($e.length) {
                templateCallback = _.template($e.html());
            }
            var obj = meerkat.modules.moreInfo.getOpenProduct();
            obj.specialConditionsRule = specialConditionContent;
            var htmlContent = templateCallback(obj);
            var modalId = meerkat.modules.dialogs.show({
                htmlContent: htmlContent,
                hashId: "special-conditions",
                title: "Special Conditions Confirmation",
                closeOnHashChange: true,
                openOnHashChange: false,
                onOpen: function(modalId) {
                    $(".btn-proceed-to-insurer", $("#" + modalId)).off("click.proceed").on("click.proceed", function(event) {
                        return proceedToInsurer(product, modalId, applyNowCallback);
                    });
                    $(".btn-back", $("#" + modalId)).off("click.goback").on("click.goback", function(event) {
                        $(".modal").modal("hide");
                        if (meerkat.modules.moreInfo.isBridgingPageOpen()) {
                            meerkat.modules.moreInfo.close();
                        }
                    });
                },
                onClose: function(modalId) {
                    meerkat.modules.moreInfo.applyCallback(false);
                }
            });
            return false;
        }
        return proceedToInsurer(product, false, applyNowCallback);
    }
    function proceedToInsurer(product, modalId, applyNowCallback) {
        if (modalId) {
            $("#" + modalId).modal("hide");
        }
        if (_.isEmpty(product.quoteUrl)) {
            meerkat.modules.errorHandling.error({
                errorLevel: "warning",
                message: "An error occurred. Sorry about that!<br /><br /> To purchase this policy, please contact the provider " + (product.telNo !== "" ? " on " + product.telNo : "directly") + " quoting " + product.leadNo + ", or select another policy.",
                page: "homeMoreInfo.js:proceedToInsurer",
                description: "Insurer did not provide quoteUrl in results object.",
                data: product
            });
            return false;
        }
        trackHandover(product);
        applyNowCallback(true);
        return true;
    }
    function trackCallDirect() {
        var i = 0;
        for (var key in callDirectLeadFeedSent) {
            if (callDirectLeadFeedSent.hasOwnProperty(key)) {
                i++;
            }
        }
        if (i > 1) return;
        trackCallEvent("CrCallDir");
    }
    function trackCallBack() {
        trackCallEvent("CrCallBac");
    }
    function trackCallBackSubmit() {
        trackCallEvent("CrCallBacSub");
    }
    function trackCallEvent(type) {
        var product = meerkat.modules.moreInfo.getOpenProduct();
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackBridgingClick",
            object: {
                vertical: "Home_Contents",
                type: type,
                quoteReferenceNumber: product.leadNo,
                transactionID: meerkat.modules.transactionId.get(),
                productID: product.productId,
                verticalFilter: $("#home_coverType").val()
            }
        });
        meerkat.modules.session.poke();
    }
    function trackHandover(product) {
        var transaction_id = meerkat.modules.transactionId.get();
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackHandover",
            object: {
                quoteReferenceNumber: product.leadNo,
                transactionID: transaction_id,
                productID: product.productId,
                productBrandCode: product.brandCode,
                vertical: "Home_Contents",
                verticalFilter: $("#home_coverType").val()
            }
        });
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackHandoverType",
            object: {
                type: "ONLINE",
                quoteReferenceNumber: product.leadNo,
                transactionID: transaction_id,
                productID: product.productId,
                productBrandCode: product.brandCode,
                vertical: "Home_Contents",
                verticalFilter: $("#home_coverType").val()
            }
        });
        meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
            touchType: "A"
        });
        meerkat.modules.session.poke();
    }
    function trackProductView() {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteForms",
            object: _.bind(meerkat.modules.home.getTrackingFieldsObject, this, true)
        });
    }
    function setScrapeType() {
        var coverType = meerkat.modules.home.getCoverType();
        switch (coverType) {
          case "H":
            scrapeType = "home";
            return;

          case "C":
            scrapeType = "contents";
            return;

          case "HC":
            scrapeType = "homeandcontents";
            return;
        }
    }
    function renderScrapes(scrapeData) {
        trackProductView();
        updateQuoteSummaryTable();
        if (typeof scrapeData != "undefined" && typeof scrapeData.scrapes != "undefined" && scrapeData.scrapes.length) {
            $.each(scrapeData.scrapes, function(key, scrape) {
                if (scrape.html !== "" && scrape.cssSelector.indexOf(scrapeType) != -1) {
                    $(scrape.cssSelector.replace("-" + scrapeType, "")).html(scrape.html);
                }
            });
        }
        $(".contentRow li").each(function() {
            $(this).prepend('<span class="icon icon-angle-right"></span>');
        });
    }
    function onApplySuccess(product) {}
    function setSpecialConditionDetail(status, content) {
        hasSpecialConditions = status;
        specialConditionContent = content;
    }
    meerkat.modules.register("homeMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        setSpecialConditionDetail: setSpecialConditionDetail,
        runDisplayMethod: runDisplayMethod,
        getTransferUrl: getTransferUrl
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {}, steps = null;
    var currentTime = new Date();
    var currentYear = currentTime.getFullYear();
    var currentMonth = currentTime.getMonth() + 1;
    var elements = {
        name: "home_occupancy",
        ownProperty: "home_occupancy_ownProperty",
        principalResidence: "home_occupancy_principalResidence",
        whenMovedInYear: "home_occupancy_whenMovedIn_year",
        whenMovedInMonth: "home_occupancy_whenMovedIn_month",
        howOccupied: "#home_occupancy_howOccupied",
        whenMovedInYearRow: ".whenMovedInYear",
        whenMovedInMonthRow: ".whenMovedInMonth",
        howOccupiedRow: ".howOccupied"
    };
    function isPrincipalResidence() {
        if ($("input:radio[name=" + elements.principalResidence + "]:checked").val() == "Y") {
            return true;
        } else {
            return false;
        }
    }
    function togglePropertyOccupancyFields(speed) {
        var ownProperty = $("input:radio[name=" + elements.ownProperty + "]:checked").val();
        var howOccupied = $(elements.howOccupied).find("option:selected").val();
        var isItPrincipalResidence = isPrincipalResidence();
        var $howOccupied = $(elements.howOccupied);
        if (!isItPrincipalResidence && (typeof ownProperty == "undefined" || ownProperty == "N")) {
            $(elements.howOccupiedRow).slideUp(speed);
            $(elements.whenMovedInYearRow + ", " + elements.whenMovedInMonthRow).slideUp(speed);
        } else {
            if (isItPrincipalResidence) {
                $(elements.howOccupiedRow).slideUp(speed);
                $(elements.whenMovedInYearRow).slideDown(speed);
                yearSelected(speed);
            } else {
                $(elements.howOccupiedRow).slideDown(speed);
                $(elements.whenMovedInYearRow + ", " + elements.whenMovedInMonthRow).slideUp(speed);
            }
        }
    }
    function yearSelected(speed) {
        var selectedYear = $('select[name="' + elements.whenMovedInYear + '"]').val();
        var monthField = $("#" + elements.whenMovedInMonth);
        var numberOfMonths = 12;
        if (selectedYear == currentYear) {
            numberOfMonths = currentMonth;
        }
        if (selectedYear >= currentYear - 2) {
            $(elements.whenMovedInMonthRow).slideDown(speed);
            monthField.find("option").show();
            for (var i = 12; i > numberOfMonths; i--) {
                monthField.find("[value=" + i + "]").hide();
            }
        } else {
            $(elements.whenMovedInMonthRow).slideUp(speed);
        }
    }
    function applyEventListeners() {
        $(document).ready(function() {
            $("#" + elements.whenMovedInYear).on("change", function() {
                yearSelected();
            });
            $("input[name=" + elements.name + "_ownProperty], " + elements.howOccupied).on("change", function() {
                togglePropertyOccupancyFields();
            });
            $("input[name=" + elements.principalResidence + "]").on("change", function() {
                togglePropertyOccupancyFields();
            });
        });
    }
    function initHomeOccupancy() {
        log("[HomeOccupancy] Initialised");
        applyEventListeners();
        $(document).ready(function() {
            togglePropertyOccupancyFields(0);
        });
    }
    meerkat.modules.register("homeOccupancy", {
        initHomeOccupancy: initHomeOccupancy,
        events: moduleEvents,
        isPrincipalResidence: isPrincipalResidence
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {}, steps = null;
    var elements = {
        name: "home_policyHolder",
        anyoneOlder: "home_policyHolder_anyoneOlder",
        oldestDOBRow: "#oldest_person_DOB",
        anyoneOlderRow: "#anyoneOlder",
        principalResidence: "home_occupancy_principalResidence",
        over55: ".over55",
        otherOccupantsRow: "#home_policyHolder_other_occupants",
        toggleJointPolicyHolder: $(".toggleJointPolicyHolder"),
        jointPolicyHolder: $("#jointPolicyHolder"),
        addPolicyHolderBtn: $(".addPolicyHolderBtn")
    };
    function toggleOldestPerson(speed) {
        var isPrincipalResidence = meerkat.modules.homeOccupancy.isPrincipalResidence();
        if ($("input[name=" + elements.anyoneOlder + "]:checked").val() == "Y" && isPrincipalResidence) {
            $(elements.oldestDOBRow).slideDown(speed);
        } else {
            $(elements.oldestDOBRow).slideUp(speed);
        }
        toggleOver55(speed);
    }
    function togglePolicyHolderFields(speed) {
        var isPrincipalResidence = meerkat.modules.homeOccupancy.isPrincipalResidence();
        if (isPrincipalResidence) {
            $(elements.anyoneOlderRow + ", " + elements.otherOccupantsRow).slideDown(speed);
            toggleOldestPerson(speed);
            toggleOver55(speed);
        } else {
            $(elements.anyoneOlderRow + ", " + elements.over55 + ", " + elements.oldestDOBRow + ", " + elements.otherOccupantsRow).slideUp(speed);
        }
    }
    function toggleOver55(speed) {
        var isPrincipalResidence = meerkat.modules.homeOccupancy.isPrincipalResidence();
        var dateFormat = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;
        var dob = $("#" + elements.name + "_dob");
        var jointDob = $("#" + elements.name + "_jointDob");
        var oldestPersonDob = $("#" + elements.name + "_oldestPersonDob");
        var anyoneOlder = $("input[name=" + elements.anyoneOlder + "]:checked").val();
        if (isPrincipalResidence && (dob.val().match(dateFormat) && getAge(dob.val()) >= 55 || jointDob.val().match(dateFormat) && getAge(jointDob.val()) >= 55 || anyoneOlder === "Y" && oldestPersonDob.val().match(dateFormat) && getAge(oldestPersonDob.val()) >= 55)) {
            $(elements.over55).slideDown(speed);
        } else {
            $(elements.over55).slideUp(speed);
        }
    }
    function getAge(dateString) {
        var today = new Date();
        var dateSplit = dateString.split("/").reverse();
        var age = today.getFullYear() - parseInt(dateSplit[0], 10);
        var m = today.getMonth() + 1 - parseInt(dateSplit[1], 10);
        if (m < 0 || m === 0 && today.getDate() < parseInt(dateSplit[2], 10)) {
            age--;
        }
        return age;
    }
    function applyEventListeners() {
        $(document).ready(function() {
            $("input[name=" + elements.anyoneOlder + "]").on("change", function() {
                toggleOldestPerson();
            });
            $("#" + elements.name + "_dob, #" + elements.name + "_jointDob, #" + elements.name + "_oldestPersonDob").on("change", function() {
                toggleOldestPerson();
                toggleOver55();
            });
            elements.toggleJointPolicyHolder.on("click", function() {
                if (elements.jointPolicyHolder.is(":visible")) {
                    elements.jointPolicyHolder.slideUp();
                    elements.addPolicyHolderBtn.slideDown();
                } else {
                    elements.jointPolicyHolder.slideDown();
                    elements.addPolicyHolderBtn.slideUp();
                }
                toggleOver55();
            });
        });
    }
    function initHomePolicyHolder() {
        log("[HomePolicyHolder] Initialised");
        applyEventListeners();
        $(document).ready(function() {
            togglePolicyHolderFields(0);
            toggleOldestPerson(0);
            toggleOver55(0);
            elements.jointPolicyHolder.hide();
            if ($("#home_policyHolder_jointFirstName").val() !== "" || $("#home_policyHolder_jointLastName").val() !== "" || $("#home_policyHolder_jointDob").val() !== "" || $("#home_policyHolder_jointDob").val() !== "") {
                elements.toggleJointPolicyHolder.click();
            }
        });
    }
    meerkat.modules.register("homePolicyHolder", {
        initHomePolicyHolder: initHomePolicyHolder,
        togglePolicyHolderFields: togglePolicyHolderFields,
        events: moduleEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {}, steps = null;
    var elements = {
        name: "home_property",
        propertyType: "home_property_propertyType",
        yearBuilt: "home_property_yearBuilt",
        bestDescribesHome: ".bestDescribesHome",
        heritage: ".heritage"
    };
    function validateYearBuilt() {
        $("#" + elements.yearBuilt).blur();
    }
    function toggleBestDescribesHome(speed) {
        if ($("#" + elements.propertyType).find("option:selected").text().toLowerCase() == "other") {
            $(elements.bestDescribesHome).slideDown(speed);
        } else {
            $(elements.bestDescribesHome).slideUp(speed);
        }
    }
    function toggleHeritage(speed) {
        if (parseInt($("#" + elements.yearBuilt).find("option:selected").val()) <= 1914) {
            $(elements.heritage).slideDown(speed);
        } else {
            $(elements.heritage).slideUp(speed);
        }
    }
    function applyEventListeners() {
        $(document).ready(function() {
            $("#" + elements.propertyType).on("change", function() {
                toggleBestDescribesHome();
            });
            $("#" + elements.yearBuilt).on("change", function() {
                toggleHeritage();
            });
        });
    }
    function initHomePropertyDetails() {
        log("[HomeProperties] Initialised");
        applyEventListeners();
        $(document).ready(function() {
            toggleBestDescribesHome(0);
            toggleHeritage(0);
        });
    }
    meerkat.modules.register("homePropertyDetails", {
        initHomePropertyDetails: initHomePropertyDetails,
        events: moduleEvents,
        validateYearBuilt: validateYearBuilt
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {}, steps = null;
    var elements = {
        name: "#home_property",
        coverType: "#home_coverType"
    };
    function toggleSecurityFeatures() {
        var coverType = $(elements.coverType).find("option:selected").val();
        switch (coverType) {
          case "Contents Cover Only":
          case "Home & Contents Cover":
            $(elements.name).slideDown();
            break;

          default:
            $(elements.name).slideUp();
        }
    }
    function initHomePropertyFeatures() {
        log("[HomePropertiesFeatures] Initialised");
        $(document).ready(function() {
            toggleSecurityFeatures(0);
        });
    }
    meerkat.modules.register("homePropertyFeatures", {
        initHomePropertyFeatures: initHomePropertyFeatures,
        toggleSecurityFeatures: toggleSecurityFeatures,
        events: moduleEvents
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, supertagEventMode = "Load";
    var events = {
        RESULTS_ERROR: "RESULTS_ERROR"
    };
    var supertagResultsEventMode = "Load";
    var $component;
    var previousBreakpoint;
    var best_price_count = 5;
    var needToBuildFeatures = false;
    function initPage() {
        $component = $("#resultsPage");
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
            var displayMode = "price";
            if (typeof meerkat.site != "undefined" && typeof meerkat.site.resultOptions != "undefined") {
                displayMode = meerkat.site.resultOptions.displayMode == "features" ? "features" : "price";
            }
            Results.init({
                url: "ajax/json/home/results.jsp",
                runShowResultsPage: false,
                paths: {
                    price: {
                        annual: "price.annual.total",
                        monthly: "price.monthly.total"
                    },
                    availability: {
                        product: "productAvailable"
                    },
                    productId: "productId"
                },
                show: {
                    savings: false,
                    featuresCategories: false,
                    nonAvailableProducts: false,
                    unavailableCombined: true
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
                displayMode: displayMode,
                pagination: {
                    mode: "page",
                    touchEnabled: Modernizr.touch,
                    emptyContainerFunction: emptyPaginationLinks,
                    afterPaginationRefreshFunction: afterPaginationRefresh
                },
                sort: {
                    sortBy: "price.annually"
                },
                frequency: "annual",
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
                        rank_productId: "productId",
                        rank_premium: "price.annual.total"
                    },
                    filterUnavailableProducts: false
                },
                incrementTransactionId: false
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred initialising page", "results.tag", "meerkat.modules.homeResults.init(); " + e.message, e);
        }
    }
    function eventSubscriptions() {
        $(document.body).on("click", "a.offerTerms", launchOfferTerms);
        $(Results.settings.elements.resultsContainer).on("click", ".result-row", resultRowClick);
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            $("#resultsPage").css("margin-top", "35px");
        });
        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            $("#resultsPage").css("margin-top", "0");
        });
        meerkat.messaging.subscribe(meerkatEvents.homeFilters.CHANGED, function onFilterChange(obj) {
            if (obj && (obj.hasOwnProperty("homeExcess") || obj.hasOwnProperty("contentsExcess"))) {
                supertagResultsEventMode = "Load";
                Results.settings.incrementTransactionId = true;
                get();
                Results.settings.incrementTransactionId = false;
            } else {
                supertagResultsEventMode = "Refresh";
            }
            meerkat.modules.session.poke();
        });
        meerkat.messaging.subscribe(events.RESULTS_ERROR, function() {
            _.delay(function() {
                meerkat.modules.journeyEngine.gotoPath("previous");
            }, 1e3);
        });
        meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
            massageResultsObject();
        });
        $(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function() {
            Features.buildHtml();
        });
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
            Results.view.show();
        });
        $(document).on("resultsLoaded", onResultsLoaded);
        $(document).on("resultsReturned", function() {
            meerkat.modules.utilities.scrollPageTo($("header"));
            $(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");
        });
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.modules.journeyEngine.loadingShow("getting your quotes");
            $("#resultsPage, .loadingDisclaimerText").removeClass("hidden");
            Results.pagination.hide();
        });
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            $(Results.settings.elements.page).show();
            meerkat.modules.journeyEngine.loadingHide();
            $(".loadingDisclaimerText").addClass("hidden");
            if (Results.getDisplayMode() !== "price") {
                Results.pagination.show();
            } else {
                $(document.body).removeClass("priceMode").addClass("priceMode");
            }
            var availableCounts = 0;
            $.each(Results.model.returnedProducts, function() {
                if (this.productAvailable === "Y" && this.productId !== "CURR") {
                    availableCounts++;
                }
            });
            if (availableCounts === 0 && _.isArray(Results.model.returnedProducts) && Results.model.returnedProducts.length > 0) {
                showNoResults();
            }
        });
        $(document).on("populateFeaturesStart", function onPopulateFeaturesStart() {
            meerkat.modules.performanceProfiling.startTest("results");
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
            var coverType = meerkat.modules.home.getCoverType();
            if (coverType === "H") {
                $.each($(".featuresList"), function moveHome() {
                    $(this).children(".homeFeature").appendTo($(this));
                });
                $.each($(".featuresList"), function moveContents() {
                    $(this).children(".contentsFeature").appendTo($(this));
                });
            } else {
                $.each($(".featuresList"), function moveContents() {
                    $(this).children(".contentsFeature").appendTo($(this));
                });
                $.each($(".featuresList"), function moveHome() {
                    $(this).children(".homeFeature").appendTo($(this));
                });
            }
        });
        $(document).on("FeaturesRendered", function() {
            $(Features.target + " .expandable > " + Results.settings.elements.features.values).on("mouseenter", function() {
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
    function massageResultsObject(products) {
        products = products || Results.model.returnedProducts;
        _.each(products, function massageJson(result, index) {
            if (!_.isUndefined(result.price)) {
                if (!_.isUndefined(result.price.annual) && !_.isUndefined(result.price.annual.total)) {
                    result.price.annual.totalFormatted = meerkat.modules.currencyField.formatCurrency(result.price.annual.total, {
                        roundToDecimalPlace: 0
                    });
                }
                if (!_.isUndefined(result.price.monthly)) {
                    if (!_.isUndefined(result.price.monthly.total)) {
                        result.price.monthly.totalFormatted = meerkat.modules.currencyField.formatCurrency(result.price.monthly.total, {
                            roundToDecimalPlace: 2
                        });
                    }
                    if (!_.isUndefined(result.price.monthly.amount)) {
                        result.price.monthly.amountFormatted = meerkat.modules.currencyField.formatCurrency(result.price.monthly.amount, {
                            roundToDecimalPlace: 2
                        });
                    }
                    if (!_.isUndefined(result.price.monthly.firstPayment)) {
                        result.price.monthly.firstPaymentFormatted = meerkat.modules.currencyField.formatCurrency(result.price.monthly.firstPayment, {
                            roundToDecimalPlace: 2
                        });
                    }
                }
            }
            if (!_.isUndefined(result.HHB)) {
                if (!_.isUndefined(result.HHB.excess) && !_.isUndefined(result.HHB.excess.amount)) {
                    result.HHB.excess.amountFormatted = meerkat.modules.currencyField.formatCurrency(result.HHB.excess.amount, {
                        roundToDecimalPlace: 0
                    });
                }
            }
            if (!_.isUndefined(result.HHC)) {
                if (!_.isUndefined(result.HHC.excess) && !_.isUndefined(result.HHC.excess.amount)) {
                    result.HHC.excess.amountFormatted = meerkat.modules.currencyField.formatCurrency(result.HHC.excess.amount, {
                        roundToDecimalPlace: 0
                    });
                }
            }
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
        $component.removeClass("coverTypeContents coverTypeHome");
        var coverType = meerkat.modules.home.getCoverType();
        if (coverType === "H") {
            $component.removeClass("coverTypeContents").addClass("coverTypeHome");
        } else if (coverType === "C") {
            $component.addClass("coverTypeContents").removeClass("coverTypeHome");
        }
        Results.get();
    }
    function emptyPaginationLinks($container) {
        $container.find(".btn-pagination").parent("li").remove();
        $container.find(".pagination-label").addClass("hidden");
    }
    function afterPaginationRefresh($container) {
        if ($container.find(".btn-pagination").length > 0) {
            $container.find(".pagination-label").removeClass("hidden");
        }
    }
    function onResultsLoaded() {
        startColumnWidthTracking();
        switch (Results.getDisplayMode()) {
          case "features":
            switchToFeaturesMode(false);
            break;

          default:
            needToBuildFeatures = true;
            switchToPriceMode(false);
            break;
        }
    }
    function showNoResults() {
        meerkat.modules.dialogs.show({
            htmlContent: $("#no-results-content")[0].outerHTML
        });
        if (meerkat.modules.hasOwnProperty("homeFilters")) {
            meerkat.modules.homeFilters.disable();
        }
    }
    function publishExtraSuperTagEvents() {
        var display;
        if (meerkat.modules.compare.isCompareOpen() === true) {
            display = "compare";
        } else {
            display = Results.getDisplayMode();
            if (display.indexOf("f") === 0) {
                display = display.slice(0, -1);
            }
        }
        var data = {
            vertical: "Home_Contents",
            actionStep: "Results",
            display: display,
            paymentPlan: $("#navbar-filter .dropdown.filter-frequency span:first-child").text(),
            preferredExcess: null,
            homeExcess: null,
            contentsExcess: null,
            event: supertagResultsEventMode,
            verticalFilter: $("#home_coverType").val()
        };
        var coverType = meerkat.modules.home.getCoverType();
        if (coverType == "H" || coverType == "HC") {
            data.homeExcess = $("#home_homeExcess").val() || $("#home_baseHomeExcess").val();
        }
        if (coverType == "C" || coverType == "HC") {
            data.contentsExcess = $("#home_contentsExcess").val() || $("#home_baseContentsExcess").val();
        }
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteList",
            object: data
        });
        supertagResultsEventMode = "Load";
    }
    function launchOfferTerms(event) {
        event.preventDefault();
        var $element = $(event.target);
        var $termsContent = $element.next(".offerTerms-content");
        var $logo = $element.closest(".resultInsert, .more-info-content, .call-modal").find(".companyLogo");
        var $productName = $element.closest(".resultInsert, .more-info-content, .call-modal").find(".productTitle, .productName");
        meerkat.modules.dialogs.show({
            title: $logo.clone().wrap("<p>").addClass("hidden-xs").parent().html() + "<div class='hidden-xs heading'>" + $productName.html() + "</div>" + "<div class='heading'>Offer terms</div>",
            hashId: "offer-terms",
            openOnHashChange: false,
            closeOnHashChange: true,
            htmlContent: $logo.clone().wrap("<p>").removeClass("hidden-xs").addClass("hidden-sm hidden-md hidden-lg").parent().html() + "<h2 class='visible-xs heading'>" + $productName.html() + "</h2>" + $termsContent.html()
        });
    }
    function switchToPriceMode(doTracking) {
        if (typeof doTracking == "undefined") {
            doTracking = true;
        }
        if (Results.getDisplayMode() === null) return;
        if (Results.getDisplayMode() !== "price") {
            Results.pagination.hide();
            $("header .xs-results-pagination").addClass("hidden");
            Results.setDisplayMode("price");
            stopColumnWidthTracking();
            $(document.body).addClass("priceMode");
            $(window).scrollTop(0);
            if (doTracking) {
                supertagResultsEventMode = "Refresh";
                publishExtraSuperTagEvents();
            }
        }
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
                supertagResultsEventMode = "Refresh";
                publishExtraSuperTagEvents();
            }
        }
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
        meerkat.modules.homeMoreInfo.runDisplayMethod();
    }
    function init() {
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
        meerkat.messaging.subscribe(meerkatEvents.compare.AFTER_ENTER_COMPARE_MODE, function() {
            $(".filter-excess, .filter-excess a, .excess-update, .excess-update a").addClass("disabled");
        });
        meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, function() {
            $(".filter-excess, .filter-excess a, .excess-update, .excess-update a").removeClass("disabled");
        });
    }
    meerkat.modules.register("homeResults", {
        init: init,
        initPage: initPage,
        onReturnToPage: onReturnToPage,
        get: get,
        stopColumnWidthTracking: stopColumnWidthTracking,
        recordPreviousBreakpoint: recordPreviousBreakpoint,
        switchToPriceMode: switchToPriceMode,
        switchToFeaturesMode: switchToFeaturesMode,
        showNoResults: showNoResults,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, msg = meerkat.messaging;
    var events = {}, moduleEvents = events;
    function getCopy(type) {
        var copy = false;
        switch (type) {
          case "buttonLabel":
            copy = "Save Quote";
            break;

          case "saveAgain":
            copy = 'Click \'Save Quote\' to update your saved quote <a href="javascript:;" class="btn btn-save saved-continue-link btn-save-quote">Save Quote</a>';
            break;

          case "saveSuccess":
            copy = '<div class="col-xs-12"><h4>Your quote has been saved.</h4><p>To retrieve your quote <a href="' + meerkat.site.urls.base + 'retrieve_quotes.jsp" class="btn-cancel saved-continue-link btn-link">click here</a>.</p><a href="javascript:;" class="btn btn-cancel">Close</a></div>';
        }
        return copy;
    }
    meerkat.modules.register("homeSaveQuote", {
        events: events,
        getCopy: getCopy
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var events = {
        homeSnapshot: {}
    }, $coverType = $("#home_coverType"), $quoteSnapshot = $(".quoteSnapshot");
    function initHomeSnapshot() {
        renderSnapshot(getIcon());
        $coverType.on("change", function changeHomeCoverDetails() {
            renderSnapshot(getIcon());
        });
        $("#home_property_address_streetSearch, #home_property_address_streetNum, #home_property_address_postCode, #home_property_address_suburb, #home_property_address_nonStdStreet").on("blur", function() {
            setTimeout(function() {
                renderSnapshot();
            }, 50);
        });
    }
    function renderSnapshot(icon) {
        if ($coverType.val() !== "") {
            $quoteSnapshot.removeClass("hidden");
            if (typeof icon !== "undefined") {
                $quoteSnapshot.find(".icon:first").attr("class", "icon").addClass(icon);
            }
        }
        meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(0) .snapshot");
    }
    function getIcon() {
        var icon = "icon-home-contents";
        switch ($coverType.val()) {
          case "Home Cover Only":
            icon = "icon-house";
            break;

          case "Contents Cover Only":
            icon = "icon-contents";
            break;
        }
        return icon;
    }
    meerkat.modules.register("homeSnapshot", {
        init: initHomeSnapshot,
        events: events,
        getIcon: getIcon
    });
})(jQuery);