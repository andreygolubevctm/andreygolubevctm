/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {
        car: {},
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    }, steps = null;
    var templateAccessories;
    function initCar() {
        var self = this;
        $(document).ready(function() {
            if (meerkat.site.vertical !== "car") return false;
            initJourneyEngine();
            if (meerkat.site.pageAction === "confirmation") {
                return false;
            }
            eventDelegates();
            if (meerkat.site.pageAction === "amend" || meerkat.site.pageAction === "latest" || meerkat.site.pageAction === "load" || meerkat.site.pageAction === "start-again") {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
            var $e = $("#quote-accessories-template");
            if ($e.length > 0) {
                templateAccessories = _.template($e.html());
            }
            $e = $("#more-info-template");
            if ($e.length > 0) {
                templateMoreInfo = _.template($e.html());
            }
            $e = $("#calldirect-template");
            if ($e.length > 0) {
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
            } else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === "latest") {
                startStepId = steps.resultsStep.navigationId;
            } else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === "amend") {
                startStepId = steps.startStep.navigationId;
            } else {
                startStepId = meerkat.modules.emailLoadQuote.getStartStepOverride(startStepId);
            }
            $(document).ready(function() {
                _.defer(function() {
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
        var startStep = {
            title: "Your Car",
            navigationId: "start",
            slideIndex: 0,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.car.getTrackingFieldsObject
            },
            onInitialise: function onStartInit(event) {
                var $emailQuoteBtn = $(".slide-feature-emailquote");
                if ($("#quote_privacyoptin").is(":checked")) {
                    $emailQuoteBtn.addClass("privacyOptinChecked");
                }
                $("#quote_privacyoptin").on("change", function(event) {
                    if ($(this).is(":checked")) {
                        $emailQuoteBtn.addClass("privacyOptinChecked");
                    } else {
                        $emailQuoteBtn.removeClass("privacyOptinChecked");
                    }
                });
            },
            validation: {
                validate: true,
                customValidation: function(callback) {
                    $("#quote_vehicle_selection").find("select").each(function() {
                        if ($(this).is("[disabled]")) {
                            callback(false);
                            return;
                        }
                    });
                    callback(true);
                }
            }
        };
        var optionsStep = {
            title: "Car Details",
            navigationId: "options",
            slideIndex: 1,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.car.getTrackingFieldsObject
            },
            tracking: {
                touchType: "H",
                touchComment: "OptionsAccs",
                includeFormData: true
            },
            onInitialise: function() {
                meerkat.modules.carYoungDrivers.initCarYoungDrivers();
            },
            onAfterEnter: function onOptionsEnter(event) {
                meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(1) .snapshot");
                $annualKilometers = $(".annual_kilometres_number");
                $annualKilometers.on("keyup", function(event, input) {
                    $this = $(this);
                    formatNumberInput($this, event);
                });
                $annualKilometers.trigger("keyup");
            },
            onBeforeLeave: function(event) {
                $annualKilometers = $(".annual_kilometres_number");
                if ($annualKilometers.length > 0) {
                    var numberOnlyValue = trimNonNumbers($annualKilometers.val());
                    $annualKilometers.val(numberOnlyValue);
                }
            }
        };
        var detailsStep = {
            title: "Driver Details",
            navigationId: "details",
            slideIndex: 2,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.car.getTrackingFieldsObject
            },
            tracking: {
                touchType: "H",
                touchComment: "DriverDtls",
                includeFormData: true
            },
            onAfterEnter: function onDetailsEnter(event) {
                meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(2) .snapshot");
                $annualKilometersYoungest = $(".annual_kilometres_number_youngest");
                $annualKilometersYoungest.on("keyup", function(event, input) {
                    $this = $(this);
                    formatNumberInput($this, event);
                });
                $annualKilometersYoungest.trigger("keyup");
            },
            onBeforeLeave: function(event) {
                $annualKilometersYoungest = $(".annual_kilometres_number_youngest");
                if ($annualKilometersYoungest.length > 0) {
                    var numberOnlyValue = trimNonNumbers($annualKilometersYoungest.val());
                    $annualKilometersYoungest.val(numberOnlyValue);
                }
            }
        };
        var addressStep = {
            title: "Address & Contact",
            navigationId: "address",
            slideIndex: 3,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.car.getTrackingFieldsObject
            },
            tracking: {
                touchType: "H",
                touchComment: "AddressCon",
                includeFormData: true
            },
            onInitialise: function(event) {
                var $driversFirstName = $("#quote_drivers_regular_firstname");
                var $driversLastName = $("#quote_drivers_regular_surname");
                var $driversPhoneNumber = $("#quote_contact_phoneinput");
                var $driversContactEmail = $("#quote_contact_email");
                var $competitionOptin = $("#quote_contact_competition_optin");
                var nonStdJourney = meerkat.modules.splitTest.isActive(2);
                if ($competitionOptin.length && nonStdJourney) {
                    $competitionOptin.on("change", function() {
                        if ($(this).is(":checked")) {
                            $driversFirstName.rules("add", {
                                required: true,
                                messages: {
                                    required: "Please enter your First Name to be eligible for the competition"
                                }
                            });
                            $driversLastName.rules("add", {
                                required: true,
                                messages: {
                                    required: "Please enter your Last Name to be eligible for the competition"
                                }
                            });
                            $driversPhoneNumber.rules("add", {
                                required: true,
                                messages: {
                                    required: "Please enter your Contact Number to be eligible for the competition"
                                }
                            });
                            $driversContactEmail.rules("add", {
                                required: true,
                                messages: {
                                    required: "Please enter your Email Address to be eligible for the competition"
                                }
                            });
                        } else {
                            $driversFirstName.rules("remove", "required");
                            $driversLastName.rules("remove", "required");
                            $driversPhoneNumber.rules("remove", "required");
                            $driversContactEmail.rules("remove", "required");
                            $driversFirstName.valid();
                            $driversLastName.valid();
                            $driversPhoneNumber.valid();
                            $driversContactEmail.valid();
                        }
                    });
                }
            },
            onAfterEnter: function(event) {
                meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(3) .snapshot");
            },
            onBeforeLeave: function(event) {}
        };
        var resultsStep = {
            title: "Results",
            navigationId: "results",
            slideIndex: 4,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.car.getTrackingFieldsObject
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.carResults.initPage();
                meerkat.modules.carMoreInfo.initMoreInfo();
                meerkat.modules.carEditDetails.initEditDetails();
            },
            onBeforeEnter: function enterResultsStep(event) {
                meerkat.modules.journeyProgressBar.hide();
                $("#resultsPage").addClass("hidden");
                meerkat.modules.carFilters.updateFilters();
            },
            onAfterEnter: function afterEnterResults(event) {
                meerkat.modules.carResults.get();
                meerkat.modules.carFilters.show();
            },
            onBeforeLeave: function(event) {
                if (event.isBackward === true) {
                    meerkat.modules.transactionId.getNew(3);
                }
            },
            onAfterLeave: function(event) {
                meerkat.modules.journeyProgressBar.show();
                meerkat.modules.carFilters.hide();
                meerkat.modules.carEditDetails.hide();
            }
        };
        steps = {
            startStep: startStep,
            optionsStep: optionsStep,
            detailsStep: detailsStep,
            addressStep: addressStep,
            resultsStep: resultsStep
        };
    }
    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([ {
            label: "Your Car",
            navigationId: steps.startStep.navigationId
        }, {
            label: "Car Details",
            navigationId: steps.optionsStep.navigationId
        }, {
            label: "Driver Details",
            navigationId: steps.detailsStep.navigationId
        }, {
            label: "Address & Contact",
            navigationId: steps.addressStep.navigationId
        }, {
            label: "Your Quotes",
            navigationId: steps.resultsStep.navigationId
        } ]);
    }
    function getTrackingFieldsObject(special_case) {
        try {
            special_case = special_case || false;
            var yob = $("#quote_drivers_regular_dob").val();
            if (yob.length > 4) {
                yob = yob.substring(yob.length - 4);
            }
            var gender = null;
            var gVal = $("input[name=quote_drivers_regular_gender]:checked").val();
            if (!_.isUndefined(gVal)) {
                switch (gVal) {
                  case "M":
                    gender = "Male";
                    break;

                  case "F":
                    gender = "Female";
                    break;
                }
            }
            var marketOptIn = null;
            var mVal = $("input[name=quote_contact_marketing]:checked").val();
            if (!_.isUndefined(mVal)) {
                marketOptIn = mVal;
            }
            var okToCall = null;
            var oVal = $("input[name=quote_contact_oktocall]:checked").val();
            if (!_.isUndefined(oVal)) {
                okToCall = oVal;
            }
            var postCode = $("#quote_riskAddress_postCode").val();
            var stateCode = $("#quote_riskAddress_state").val();
            var vehYear = $("#quote_vehicle_year").val();
            var vehMake = $("#quote_vehicle_make option:selected").text();
            var email = $("#quote_contact_email").val();
            var commencementDate = $("#quote_options_commencementDate").val();
            var transactionId = meerkat.modules.transactionId.get();
            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();
            var actionStep = "";
            switch (current_step) {
              case 0:
                actionStep = "your car";
                break;

              case 1:
                actionStep = "car details";
                break;

              case 2:
                actionStep = "driver details";
                break;

              case 3:
                actionStep = "address contact";
                break;

              case 4:
                if (special_case === true) {
                    actionStep = "more info";
                } else {
                    actionStep = "car results";
                }
                break;
            }
            var response = {
                vertical: meerkat.site.vertical,
                actionStep: actionStep,
                transactionID: transactionId,
                quoteReferenceNumber: transactionId,
                yearOfManufacture: null,
                makeOfCar: null,
                gender: null,
                yearOfBirth: null,
                postCode: null,
                state: null,
                email: null,
                emailID: null,
                marketOptIn: null,
                okToCall: null,
                commencementDate: null
            };
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("start")) {
                _.extend(response, {
                    yearOfManufacture: vehYear,
                    makeOfCar: vehMake
                });
            }
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("details")) {
                _.extend(response, {
                    yearOfBirth: yob,
                    gender: gender
                });
            }
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("address")) {
                _.extend(response, {
                    postCode: postCode,
                    state: stateCode,
                    email: email,
                    marketOptIn: marketOptIn,
                    okToCall: okToCall,
                    commencementDate: commencementDate
                });
            }
            return response;
        } catch (e) {
            return false;
        }
    }
    function formatNumberInput(element, event) {
        var currentValue = element.val(), numbersOnly = trimNonNumbers(currentValue), newValueLength = numbersOnly.length;
        if (currentValue.length > 7) {
            element.val(currentValue.substring(0, 7));
        } else if (newValueLength > 3) {
            var lastPart = numbersOnly.substring(newValueLength - 3, newValueLength), firstPart = numbersOnly.substring(0, newValueLength - 3);
            element.val(firstPart + "," + lastPart);
        } else {
            element.val(numbersOnly);
        }
    }
    function trimNonNumbers(string) {
        return string.replace(/\D/g, "");
    }
    meerkat.modules.register("car", {
        init: initCar,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    function initCarCommencementDate() {
        $(document).ready(function() {
            meerkat.modules.commencementDate.initCommencementDate({
                dateField: "#quote_options_commencementDate",
                getResults: meerkat.modules.carResults.get,
                updateData: function updateDataWithYoungDriver(data) {
                    _.extend(data, {
                        youngDriver: $("input[name=quote_drivers_young_exists]:checked").val()
                    });
                }
            });
        });
    }
    meerkat.modules.register("carCommencementDate", {
        init: initCarCommencementDate
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {};
    var elements = {
        fsg: "#quote_fsg",
        marketing: "#quote_contactFieldSet input[name='quote_contact_marketing']",
        oktocall: "#quote_contactFieldSet input[name='quote_contact_oktocall']",
        privacy: "#quote_privacyoptin",
        terms: "#quote_terms",
        phone: "#quote_contact_phoneinput",
        phoneRow: "#contactNoRow",
        emailRow: "#contactEmailRow",
        email: "#quote_contact_email"
    };
    function toggleValidation() {
        var isMobile = meerkat.modules.performanceProfiling.isMobile();
        var isMDorLG = _.indexOf([ "lg", "md" ], meerkat.modules.deviceMediaState.get()) !== -1;
        if (!isMobile && isMDorLG) {
            $(elements.marketing).rules("remove", "validateOkToEmailRadio");
            $(elements.marketing).rules("add", "required");
            $(elements.oktocall).rules("remove", "validateOkToCallRadio");
            $(elements.oktocall).rules("add", "required");
        }
    }
    function validateOptins() {
        $mkt = $(elements.marketing);
        $otc = $(elements.oktocall);
        if (!$mkt.is(":checked")) {
            $mkt.filter("input[value=N]").prop("checked", true).change();
        }
        if (!$otc.is(":checked")) {
            $otc.filter("input[value=N]").prop("checked", true).change();
        }
    }
    function addChangeListeners() {
        $(elements.oktocall).on("change", onOkToCallChanged);
        $(elements.marketing).on("change", onOkToEmailChanged);
        $(elements.privacy).on("change", onTermsOptinChanged);
        $(elements.phone).on("change", onPhoneChanged);
        $(elements.email).on("change", onEmailChanged);
    }
    function onPhoneChanged() {
        if ($(elements.oktocall).closest(".row-content").hasClass("has-error")) {
            _.defer(function() {
                $(elements.oktocall).valid();
            });
        }
    }
    function onOkToCallChanged() {
        if (getValue(elements.oktocall) !== "Y") {
            $row = $(elements.phoneRow);
            $row.find(".has-error").removeClass("has-error");
            $row.find(".error-field").empty().hide();
        }
    }
    function onEmailChanged() {
        if ($(elements.marketing).closest(".row-content").hasClass("has-error")) {
            _.defer(function() {
                $(elements.marketing).valid();
            });
        }
    }
    function onOkToEmailChanged() {
        if (getValue(elements.marketing) !== "Y") {
            $row = $(elements.emailRow);
            $row.find(".has-error").removeClass("has-error");
            $row.find(".error-field").empty().hide();
        }
    }
    function onTermsOptinChanged() {
        var optin = getValue(elements.privacy);
        $(elements.fsg).val(optin);
        $(elements.terms).val(optin);
    }
    function dump() {
        meerkat.logging.debug("optin data", {
            oktocall: getValue(elements.oktocall),
            privacy: getValue(elements.privacy),
            marketing: getValue(elements.marketing),
            fsg: $(elements.fsg).val(),
            terms: $(elements.terms).val()
        });
    }
    function getValue(elementId) {
        var $element = $(elementId);
        if ($element.first().attr("type") === "radio") {
            return $element.filter(":checked").val() === "Y" ? "Y" : "N";
        }
        return $element.is(":checked") ? "Y" : "N";
    }
    function initCarContactOptins() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "car") return false;
            addChangeListeners();
            toggleValidation();
            dump();
        });
    }
    meerkat.modules.register("carContactOptins", {
        init: initCarContactOptins,
        events: moduleEvents,
        validateOptins: validateOptins,
        dump: dump
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        carEditDetails: {}
    }, moduleEvents = events.carEditDetails;
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
                youngDriver: $("input[name=quote_drivers_young_exists]:checked").val()
            };
            show(templateCallback(data));
        }).on("click", ".closeDetailsDropdown", function(e) {
            hide();
            e.stopPropagation();
        }).on("click", ".dropdown-container", function(e) {
            e.stopPropagation();
        });
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
    function formatNcd(sourceEl) {
        var val = sourceEl.val(), rating;
        switch (val) {
          case "5":
            rating = 1;
            break;

          case "4":
            rating = 2;
            break;

          case "3":
            rating = 3;
            break;

          case "2":
            rating = 4;
            break;

          case "1":
            rating = 5;
            break;

          case "0":
            rating = 6;
            break;
        }
        if (rating == 6) {
            return "Rating 6 No NCD";
        }
        return typeof rating == "undefined" ? "" : "Rating " + rating + " (" + val + " Years) NCD";
    }
    function driverOptin(sourceEl) {
        var val = sourceEl.val(), output = "", years;
        switch (val) {
          case "H":
            years = 21;
            break;

          case "7":
            years = 25;
            break;

          case "A":
            years = 30;
            break;

          case "D":
            years = 40;
            break;
        }
        if (val == "3") {
            output = "No Restrictions";
        } else if (typeof years != "undefined") {
            output = "Restricted to " + years + " or older";
        }
        return output;
    }
    function formatDamage(sourceEl) {
        var val = sourceEl.find(":checked").val(), output = " Accident/Hail Damage";
        if (val === "Y") return output;
        if (val === "N") return "No" + output;
        return "";
    }
    function formatRedbookCode(sourceEl) {
        var val = "";
        if (meerkat.modules.carVehicleSelection.isSplitTest()) {
            val = sourceEl.find("input:checked").parent().text();
        } else {
            val = sourceEl.text();
        }
        return val;
    }
    meerkat.modules.register("carEditDetails", {
        initEditDetails: initEditDetails,
        events: events,
        driverOptin: driverOptin,
        formatNcd: formatNcd,
        formatDamage: formatDamage,
        formatRedbookCode: formatRedbookCode,
        hide: hide
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        carFilters: {
            CHANGED: "CAR_FILTERS_CHANGED"
        }
    }, moduleEvents = events.carFilters;
    var $component;
    var $priceMode;
    var $featuresMode;
    var $filterFrequency, $filterExcess;
    var deviceStateXS = false;
    var modalID = false;
    var pageScrollingLockYScroll = false;
    var currentValues = {
        display: false,
        frequency: false,
        excess: false
    };
    function updateFilters() {
        $priceMode.removeClass("active");
        $featuresMode.removeClass("active");
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
        var freq = $("#quote_paymentType").val();
        if (typeof freq === "undefined") {
            $filterFrequency.find(".dropdown-toggle span").text($filterFrequency.find(".dropdown-menu a:first").text());
        } else {
            $filterFrequency.find(".dropdown-toggle span").text($filterFrequency.find('.dropdown-menu a[data-value="' + freq + '"]').text());
        }
        var excess = $("#quote_excess").val();
        if (typeof excess === "undefined") {
            $filterExcess.find(".dropdown-toggle span").text($filterExcess.find(".dropdown-menu a:first").text());
        } else {
            $filterExcess.find(".dropdown-toggle span").text($filterExcess.find('.dropdown-menu a[data-value="' + excess + '"]').text());
        }
    }
    function handleDropdownOption(event) {
        event.preventDefault();
        var $menuOption = $(event.target);
        var $dropdown = $menuOption.parents(".dropdown");
        var value = $menuOption.attr("data-value");
        $dropdown.find(".dropdown-toggle span").text($menuOption.text());
        $menuOption.parent().siblings().removeClass("active");
        $menuOption.parent().addClass("active");
        if ($dropdown.hasClass("filter-frequency")) {
            if (value !== currentValues.frequency) {
                currentValues.frequency = value;
                $("#quote_paymentType").val(currentValues.frequency);
                Results.setFrequency(value);
                meerkat.messaging.publish(moduleEvents.CHANGED);
            }
        } else if ($dropdown.hasClass("filter-excess")) {
            if (value !== currentValues.excess) {
                currentValues.excess = value;
                $("#quote_excess").val(value);
                meerkat.messaging.publish(moduleEvents.CHANGED, {
                    excess: value
                });
            }
        }
    }
    function storeCurrentValues() {
        currentValues = {
            display: Results.getDisplayMode(),
            frequency: $("#quote_paymentType").val(),
            excess: $("#quote_excess").val()
        };
    }
    function preselectDropdowns() {
        $filterFrequency.find("li.active").removeClass("active");
        $filterFrequency.find("a[data-value=" + currentValues.frequency + "]").each(function() {
            $(this).parent().addClass("active");
        });
        $filterExcess.find("li.active").removeClass("active");
        if (!_.isEmpty(currentValues.excess)) {
            $filterExcess.find("a[data-value=" + currentValues.excess + "]").each(function() {
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
        $priceMode.addClass("disabled");
        $priceMode.find("a").addClass("disabled");
        $featuresMode.addClass("disabled");
        $featuresMode.find("a").addClass("disabled");
        $(".slide-feature-filters").find("a").addClass("disabled").addClass("inactive");
    }
    function enable() {
        if (meerkat.modules.compare.isCompareOpen() === false) {
            $component.find("li.dropdown.filter-excess, .filter-excess .dropdown-toggle").removeClass("disabled");
            $priceMode.removeClass("disabled");
            $priceMode.find("a").removeClass("disabled");
            $featuresMode.removeClass("disabled");
            $featuresMode.find("a").removeClass("disabled");
            $(".slide-feature-filters").find("a").removeClass("inactive").removeClass("disabled");
        }
        $component.find("li.dropdown.filter-frequency, .filter-frequency .dropdown-toggle").removeClass("disabled");
    }
    function eventSubscriptions() {
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            disable();
        });
        $(document).on("pagination.scrolling.start", function onPaginationStart() {
            pageScrollingLockYScroll = true;
            disable();
        });
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            enable();
        });
        $(document).on("pagination.scrolling.end", function onPaginationEnd() {
            pageScrollingLockYScroll = false;
            enable();
        });
        meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, enable);
        $(document.body).on("mousewheel DOMMouseScroll onmousewheel", function(e) {
            if (pageScrollingLockYScroll) {
                e.preventDefault();
                e.stopPropagation();
            }
        });
        $priceMode.on("click", function filterPrice(event) {
            event.preventDefault();
            if ($(this).hasClass("disabled")) return;
            meerkat.modules.carResults.switchToPriceMode(true);
            updateFilters();
            meerkat.modules.session.poke();
        });
        $featuresMode.on("click", function filterFeatures(event) {
            event.preventDefault();
            if ($(this).hasClass("disabled")) return;
            meerkat.modules.carResults.switchToFeaturesMode(true);
            updateFilters();
            meerkat.modules.session.poke();
        });
        $component.on("click", ".dropdown-menu a", handleDropdownOption);
    }
    function renderModal() {
        var templateAccessories = _.template($("#car-xsFilterBar-template").html());
        var excess = $("#quote_excess").val();
        var htmlContent = templateAccessories({
            startingValue: _.isEmpty(excess) ? 0 : excess
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
    function onModalOpen() {
        if (typeof Results.settings !== "undefined" && Results.settings.hasOwnProperty("displayMode") === true) {
            $("#xsFilterBarSortRow input:checked").prop("checked", false);
            $("#xsFilterBarSortRow #xsFilterBar_sort_" + Results.getDisplayMode()).prop("checked", true).change();
        }
        $("#xsFilterBarFreqRow input:checked").prop("checked", false);
        $("#xsFilterBarFreqRow #xsFilterBar_freq_" + $("#quote_paymentType").val()).prop("checked", true).change();
        try {
            meerkat.modules.sliders.init();
        } catch (e) {}
    }
    function saveModalChanges() {
        var $freq = $("#quote_paymentType");
        var $excess = $("#quote_excess");
        var revised = {
            display: $("#xsFilterBarSortRow input:checked").val(),
            freq: $("#xsFilterBarFreqRow input:checked").val(),
            excess: $("#xsFilterBarExcessRow input[name=xsFilterBar_excess]").val()
        };
        if (Number(revised.excess) === 0) {
            revised.excess = "";
        }
        $freq.val(revised.freq);
        $excess.val(revised.excess);
        if (revised.display !== currentValues.display) {
            if (revised.display === "features") {
                meerkat.modules.carResults.switchToFeaturesMode(true);
            } else if (revised.display === "price") {
                meerkat.modules.carResults.switchToPriceMode(true);
            }
        }
        meerkat.modules.dialogs.close(modalID);
        meerkat.modules.navMenu.close();
        updateFilters();
        if (currentValues.frequency !== revised.freq) {
            currentValues.frequency = revised.freq;
            Results.setFrequency(currentValues.frequency);
            meerkat.messaging.publish(moduleEvents.CHANGED);
        }
        if (currentValues.excess !== revised.excess) {
            currentValues.excess = revised.excess;
            meerkat.messaging.publish(moduleEvents.CHANGED, {
                excess: revised.excess
            });
        }
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
    function init() {
        $component = $("#navbar-filter");
        if ($component.length === 0) return;
        $priceMode = $component.find(".filter-pricemode");
        $featuresMode = $component.find(".filter-featuresmode");
        $filterFrequency = $component.find(".filter-frequency");
        $filterExcess = $component.find(".filter-excess");
        eventSubscriptions();
        $(document).ready(function onReady() {
            var $filterMenu;
            $filterMenu = $filterExcess.find(".dropdown-menu");
            $("#filter_excessOptions option").each(function() {
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
    meerkat.modules.register("carFilters", {
        init: init,
        events: events,
        updateFilters: updateFilters,
        hide: hide,
        show: show,
        disable: disable,
        enable: enable,
        onRequestModal: onRequestModal
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var events = {
        carMoreInfo: {}
    }, moduleEvents = events.carMoreInfo;
    var $bridgingContainer = $(".bridgingContainer"), callDirectLeadFeedSent = {}, specialConditionContent = "", hasSpecialConditions = false, callbackModalId, scrollPosition, activeCallModal, callDirectTrackingFlag = true;
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
            onAfterShowModal: requestTracking,
            onAfterShowTemplate: onAfterShowTemplate,
            onBeforeHideTemplate: null,
            onAfterHideTemplate: onAfterHideTemplate,
            onClickApplyNow: onClickApplyNow,
            onBeforeApply: null,
            onApplySuccess: onApplySuccess,
            retrieveExternalCopy: retrieveExternalCopy,
            additionalTrackingData: {
                productName: null
            },
            onBreakpointChangeCallback: _.bind(resizeSidebarOnBreakpointChange, this, ".paragraphedContent", ".moreInfoRightColumn", $bridgingContainer)
        };
        meerkat.modules.moreInfo.initMoreInfo(options);
        eventSubscriptions();
        applyEventListeners();
    }
    function applyEventListeners() {
        $(document).on("click", ".bridgingContainer .btn-call-actions", function(event) {
            var $el = $(this);
            callActions(event, $el);
        }).on("click", ".call-modal .btn-call-actions", function(event) {
            var $el = $(this);
            modalCallActions(event, $el);
        }).on("click", ".btn-submit-callback", function(event) {
            var $el = $(this);
            submitCallback(event, $el);
        });
        $(".slide-feature-closeMoreInfo a").off().on("click", function() {
            meerkat.modules.moreInfo.close();
        });
    }
    function setupCallbackForm() {
        setupDefaultValidationOnForm($("#getcallback"));
        var clientName = $("#quote_CrClientName");
        if (clientName.length && !clientName.val().length) {
            clientName.val($("#quote_drivers_regular_firstname").val() + " " + $("#quote_drivers_regular_surname").val());
        }
        var telNum = $("#quote_CrClientTelinput");
        if (telNum.length && !telNum.val().length) {
            telNum.val($("#quote_contact_phone").val());
        }
        telNum.attr("data-msg-required", "Please enter your contact number");
    }
    function resizeSidebarOnBreakpointChange(leftContainer, rightContainer, mainContainer) {
        if (meerkat.modules.deviceMediaState.get() == "lg" || meerkat.modules.deviceMediaState.get() == "md") {
            fixSidebarHeight(leftContainer, rightContainer, mainContainer);
        }
    }
    function fixSidebarHeight(leftSelector, rightSelector, $container) {
        if (meerkat.modules.deviceMediaState.get() != "xs") {
            if ($(rightSelector, $container).length) {
                $(leftSelector, $container).css("min-height", "0px");
                $(rightSelector, $container).css("min-height", "0px");
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
    function recordCallDirect(event, product) {
        trackCallDirect(product);
        var currProduct = product;
        if (typeof callDirectLeadFeedSent[currProduct.productId] != "undefined") {
            return;
        }
        var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();
        return callLeadFeedSave(event, {
            message: currentBrandCode + " - Car Vertical - Call direct",
            phonecallme: "CallDirect"
        }, product);
    }
    function callLeadFeedSave(event, data, product) {
        if (typeof product !== "undefined" && product !== null && typeof product.vdn !== "undefined" && !_.isEmpty(product.vdn) && product.vdn > 0) {
            data.vdn = product.vdn;
        }
        var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();
        var defaultData = {
            state: $("#quote_riskAddress_state").val(),
            brand: product.productId.split("-")[0],
            productId: product.productId
        };
        if (meerkat.site.leadfeed[data.phonecallme].use_disc_props) {
            $.extend(defaultData, {
                source: currentBrandCode + "CAR",
                leadNo: product.leadNo,
                client: $("#quote_CrClientName").val() || "",
                clientTel: $("#quote_CrClientTelinput").val() || "",
                transactionId: meerkat.modules.transactionId.get()
            });
        } else {
            $.extend(defaultData, {
                clientNumber: product.leadNo,
                clientName: $("#quote_CrClientName").val() || "",
                phoneNumber: $("#quote_CrClientTelinput").val() || "",
                partnerReference: meerkat.modules.transactionId.get()
            });
        }
        var allData = $.extend(defaultData, data);
        var $element = $(event.target);
        meerkat.modules.loadingAnimation.showInside($element, true);
        return meerkat.modules.comms.post({
            url: meerkat.site.leadfeed[data.phonecallme].url,
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
                        onOpen: function(modalId) {
                            var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal + "-submitted");
                            meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
                        },
                        onClose: function(modalId) {
                            var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal);
                            meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
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
                    callDirectLeadFeedSent[product.productId] = true;
                }
                meerkat.modules.loadingAnimation.hide($element);
            }
        });
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
        meerkat.messaging.subscribe(meerkatEvents.transactionId.CHANGED, function updateCallDirectTrackingFlag() {
            callDirectTrackingFlag = true;
        });
        meerkat.messaging.subscribe(meerkatEvents.carResults.FEATURES_CALL_ACTION, function triggerCallActions(obj) {
            callActions(obj.event, obj.element);
        });
        meerkat.messaging.subscribe(meerkatEvents.carResults.FEATURES_CALL_ACTION_MODAL, function triggerCallActionsFromModal(obj) {
            modalCallActions(obj.event, obj.element);
        });
        meerkat.messaging.subscribe(meerkatEvents.carResults.FEATURES_SUBMIT_CALLBACK, function triggerSubmitCallback(obj) {
            submitCallback(obj.event, obj.element);
        });
    }
    function callActions(event, element) {
        event.preventDefault();
        event.stopPropagation();
        var $el = element;
        var $e = $("#car-call-modal-template");
        if ($e.length > 0) {
            templateCallback = _.template($e.html());
        }
        var obj = Results.getResultByProductId($el.attr("data-productId"));
        if (obj.available !== "Y") return;
        activeCallModal = $el.attr("data-callback-toggle");
        var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal);
        var htmlContent = templateCallback(obj);
        var modalOptions = {
            htmlContent: htmlContent,
            hashId: "call",
            className: "call-modal " + obj.brandCode,
            closeOnHashChange: true,
            openOnHashChange: false,
            onOpen: function(modalId) {
                $("." + activeCallModal).show();
                fixSidebarHeight(".paragraphedContent:visible", ".sidebar-right", $("#" + modalId));
                setupCallbackForm();
                if ($el.hasClass("btn-calldirect")) {
                    recordCallDirect(event, obj);
                } else {
                    trackCallBack(obj);
                }
                meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
            },
            onClose: function(modalId) {
                meerkat.modules.sessionCamHelper.setMoreInfoModal();
            }
        };
        if (meerkat.modules.deviceMediaState.get() == "xs") {
            modalOptions.title = "Reference no. " + obj.leadNo;
        }
        callbackModalId = meerkat.modules.dialogs.show(modalOptions);
    }
    function modalCallActions(event, element) {
        if (meerkat.modules.deviceMediaState.get() != "xs") {
            event.preventDefault();
        }
        event.stopPropagation();
        var $el = element;
        var obj = Results.getResultByProductId($el.attr("data-productId"));
        activeCallModal = $el.attr("data-callback-toggle");
        var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal);
        switch (activeCallModal) {
          case "calldirect":
            $(".callback").hide();
            $(".calldirect").show();
            recordCallDirect(event, obj);
            break;

          case "callback":
            $(".calldirect").hide();
            $(".callback").show();
            trackCallBack(obj);
            break;
        }
        fixSidebarHeight(".paragraphedContent:visible", ".sidebar-right", $el.closest(".modal.in"));
        meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
    }
    function submitCallback(event, element) {
        event.preventDefault();
        var $el = element;
        var obj = Results.getResultByProductId($el.attr("data-productId"));
        if ($el.closest("form").valid()) {
            var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();
            callLeadFeedSave(event, {
                message: currentBrandCode + " - Car Vertical - Call me now",
                phonecallme: "GetaCall"
            }, obj);
            trackCallBackSubmit(obj);
        } else {
            _.delay(function() {
                fixSidebarHeight(".paragraphedContent:visible", ".sidebar-right", $el.closest(".modal.in"));
            }, 200);
        }
        return false;
    }
    function setScrollPosition() {
        scrollPosition = $(window).scrollTop();
    }
    function onBeforeShowBridgingPage() {
        setScrollPosition();
        if (meerkat.modules.deviceMediaState.get() != "xs") {
            $(".resultsContainer, #navbar-filter, #navbar-compare").hide();
        }
    }
    function onAfterShowTemplate() {
        requestTracking();
        if (meerkat.modules.deviceMediaState.get() == "lg" || meerkat.modules.deviceMediaState.get() == "md") {
            fixSidebarHeight(".paragraphedContent", ".moreInfoRightColumn", $bridgingContainer);
        }
    }
    function onAfterHideTemplate() {
        $(".resultsContainer, #navbar-filter, #navbar-compare").show();
        $(window).scrollTop(scrollPosition);
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
        return meerkat.modules.comms.get({
            url: "ajax/json/get_scrapes.jsp",
            cache: true,
            data: {
                type: "carBrandScrapes",
                code: product.productId,
                group: "car"
            },
            errorLevel: "silent",
            onSuccess: function(result) {
                meerkat.modules.moreInfo.setDataResult(result);
            }
        });
    }
    function onClickApplyNow(product, applyNowCallback) {
        var is_autogeneral = product.service.search(/agis_/i) === 0;
        if (hasSpecialConditions === true && specialConditionContent.length > 0 && !is_autogeneral) {
            var $e = $("#special-conditions-template");
            if ($e.length > 0) {
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
                        event.preventDefault();
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
        if (callbackModalId) {
            $("#" + callbackModalId).modal("hide");
        }
        if (_.isEmpty(product.quoteUrl)) {
            meerkat.modules.errorHandling.error({
                errorLevel: "warning",
                message: "An error occurred. Sorry about that!<br /><br /> To purchase this policy, please contact the provider " + (product.telNo !== "" ? " on " + product.telNo : "directly") + " quoting " + product.leadNo + ", or select another policy.",
                page: "carMoreInfo.js:proceedToInsurer",
                description: "Insurer did not provide quoteUrl in results object.",
                data: product
            });
            return false;
        }
        meerkat.modules.partnerTransfer.transferToPartner({
            encodeTransferURL: true,
            product: product,
            applyNowCallback: applyNowCallback,
            productName: product.headline.name,
            productBrandCode: product.brandCode,
            brand: product.productDes
        });
        return true;
    }
    function trackCallDirect(product) {
        if (callDirectTrackingFlag === true) {
            callDirectTrackingFlag = false;
            trackCallEvent("CrCallDir", product);
        } else {
            return;
        }
    }
    function trackCallBack(product) {
        trackCallEvent("CrCallBac", product);
    }
    function trackCallBackSubmit(product) {
        trackCallEvent("CrCallBacSub", product);
    }
    function trackCallEvent(type, product) {
        meerkat.modules.partnerTransfer.trackHandoverEvent({
            product: product,
            type: type,
            quoteReferenceNumber: product.leadNo,
            productID: product.productId,
            productName: product.headline.name,
            productBrandCode: product.brandCode
        }, false, false);
    }
    function trackProductView() {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteForms",
            object: _.bind(meerkat.modules.car.getTrackingFieldsObject, this, true)
        });
    }
    function requestTracking() {
        var settings = {
            additionalTrackingData: {
                productName: meerkat.modules.moreInfo.getOpenProduct().headline.name
            }
        };
        meerkat.modules.moreInfo.updateSettings(settings);
        trackProductView();
    }
    function renderScrapes(scrapeData) {
        if (typeof scrapeData != "undefined" && typeof scrapeData.scrapes != "undefined" && scrapeData.scrapes.length > 0) {
            $.each(scrapeData.scrapes, function(key, scrape) {
                if (scrape.html !== "") {
                    $(scrape.cssSelector).html(scrape.html);
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
    meerkat.modules.register("carMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        setSpecialConditionDetail: setSpecialConditionDetail,
        runDisplayMethod: runDisplayMethod,
        setScrollPosition: setScrollPosition
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        RESULTS_ERROR: "RESULTS_ERROR"
    };
    meerkatEvents.carResults = {
        FEATURES_CALL_ACTION: "FEATURES_CALL_ACTION",
        FEATURES_CALL_ACTION_MODAL: "FEATURES_CALL_ACTION_MODAL",
        FEATURES_SUBMIT_CALLBACK: "FEATURES_SUBMIT_CALLBACK"
    };
    var $component;
    var previousBreakpoint;
    var best_price_count = 5;
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
            var displayMode = "price";
            if (meerkat.modules.splitTest.isActive(18)) {
                displayMode = "features";
            }
            Results.init({
                url: "ajax/json/car_quote_results.jsp",
                runShowResultsPage: false,
                paths: {
                    productId: "productId",
                    productName: "headline.name",
                    productBrandCode: "brandCode",
                    price: {
                        annually: "headline.lumpSumTotal",
                        annual: "headline.lumpSumTotal",
                        monthly: "headline.instalmentTotal"
                    },
                    availability: {
                        product: "available",
                        price: {
                            annually: "headline.lumpSumTotal",
                            annual: "headline.lumpSumTotal",
                            monthly: "headline.instalmentTotal"
                        }
                    }
                },
                show: {
                    savings: false,
                    featuresCategories: false,
                    nonAvailablePrices: true,
                    nonAvailableProducts: false,
                    unavailableCombined: true
                },
                availability: {
                    product: [ "equals", "Y" ],
                    price: [ "notEquals", -1 ]
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
                    touchEnabled: Modernizr.touch
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
                        rank_premium: "headline.lumpSumTotal"
                    },
                    filterUnavailableProducts: false
                },
                incrementTransactionId: false
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred initialising page", "results.tag", "meerkat.modules.carResults.initResults(); " + e.message, e);
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
        meerkat.messaging.subscribe(meerkatEvents.carFilters.CHANGED, function onFilterChange(obj) {
            if (obj && obj.hasOwnProperty("excess")) {
                Results.settings.incrementTransactionId = true;
                get();
                Results.settings.incrementTransactionId = false;
            } else {
                meerkat.modules.resultsTracking.setResultsEventMode("Refresh");
            }
            meerkat.modules.session.poke();
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
            meerkat.modules.utilities.scrollPageTo($("header"));
            $(".featuresHeaders .expandable.expanded").removeClass("expanded").addClass("collapsed");
        });
        $(document).on("resultsFetchStart", function onResultsFetchStart() {
            meerkat.modules.journeyEngine.loadingShow("getting your quotes");
            $("#resultsPage, .loadingDisclaimerText").removeClass("hidden");
            if (meerkat.site.tracking.brandCode == "ctm" && meerkat.modules.splitTest.isActive(4)) {
                $("#resultsPage, .loadingQuoteText").removeClass("hidden");
            } else {
                $("#resultsPage, .loadingDisclaimerText").addClass("originalDisclaimer");
            }
            Results.pagination.hide();
        });
        $(document).on("resultsFetchFinish", function onResultsFetchFinish() {
            $(Results.settings.elements.page).show();
            meerkat.modules.journeyEngine.loadingHide();
            $(".loadingDisclaimerText").addClass("hidden");
            if (meerkat.site.tracking.brandCode == "ctm" && meerkat.modules.splitTest.isActive(4)) {
                $(".loadingQuoteText").addClass("hidden");
            } else {
                $(".loadingDisclaimerText").addClass("originalDisclaimer");
            }
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
            if (availableCounts === 0 && _.isArray(Results.model.returnedProducts) && Results.model.returnedProducts.length > 0) {
                showNoResults();
            }
            meerkat.messaging.publish(meerkatEvents.commencementDate.RESULTS_RENDER_COMPLETED);
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
        });
        $(document).on("resultPageChange", function(event) {
            var pageData = event.pageData;
            if (pageData.measurements === null) return false;
            var items = Results.getFilteredResults().length;
            var columnsPerPage = pageData.measurements.columnsPerPage;
            var freeColumns = columnsPerPage * pageData.measurements.numberOfPages - items;
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
        $(document.body).on("click", "#results_v3 .btnContainer .btn-call-actions", function triggerMoreInfoCallActions(event) {
            var element = $(this);
            meerkat.messaging.publish(meerkatEvents.carResults.FEATURES_CALL_ACTION, {
                event: event,
                element: element
            });
        });
        $(document.body).on("click", "#results_v3 .call-modal .btn-call-actions", function triggerMoreInfoCallActionsFromModal(event) {
            var element = $(this);
            meerkat.messaging.publish(meerkatEvents.carResults.FEATURES_CALL_ACTION_MODAL, {
                event: event,
                element: element
            });
        });
        $(document.body).on("click", "#results_v3 .btn-submit-callback", function triggerMoreInfoSubmitCallback(event) {
            var element = $(this);
            meerkat.messaging.publish(meerkatEvents.carResults.FEATURES_SUBMIT_CALLBACK, {
                event: event,
                element: element
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
        meerkat.modules.carContactOptins.validateOptins();
        Results.get();
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
        if (meerkat.modules.hasOwnProperty("carFilters")) {
            meerkat.modules.carFilters.disable();
        }
    }
    function publishExtraSuperTagEvents() {
        var $excess = $("#navbar-filter .dropdown.filter-excess span:first-child"), preferredExcess = "default";
        if ($excess.length) {
            preferredExcess = $excess.text().toLowerCase();
            preferredExcess = preferredExcess.indexOf("please") !== -1 ? null : preferredExcess;
        }
        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: {
                paymentPlan: $("#navbar-filter .dropdown.filter-frequency span:first-child").text(),
                preferredExcess: preferredExcess
            },
            onAfterEventMode: "Load"
        });
    }
    function launchOfferTerms(event) {
        meerkat.modules.carMoreInfo.setScrollPosition();
        event.preventDefault();
        var $element = $(event.target);
        var $termsContent = $element.next(".offerTerms-content");
        var $logo = $element.closest(".resultInsert, .more-info-content, .call-modal").find(".companyLogo");
        var $productName = $element.closest(".resultInsert, .more-info-content, .call-modal").find(".productTitle, .productName");
        meerkat.modules.dialogs.show({
            title: $logo.clone().wrap("<p>").addClass("hidden-xs").parent().html() + "<div class='hidden-xs heading'>" + $productName.html() + "</div>" + "<div class='heading'>Offer terms</div>",
            hashId: "offer-terms",
            className: "offer-terms-modal",
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
                meerkat.modules.resultsTracking.setResultsEventMode("Refresh");
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
                meerkat.modules.resultsTracking.setResultsEventMode("Refresh");
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
        meerkat.modules.carMoreInfo.runDisplayMethod();
    }
    function init() {
        $component = $("#resultsPage");
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
        meerkat.messaging.subscribe(meerkatEvents.compare.AFTER_ENTER_COMPARE_MODE, function() {
            $(".filter-excess, .filter-excess a").addClass("disabled");
            $(".filter-featuresmode, .filter-pricemode").addClass("hidden");
        });
        meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, function() {
            $(".filter-excess, .filter-excess a").removeClass("disabled");
            $(".filter-featuresmode, .filter-pricemode").removeClass("hidden");
        });
    }
    meerkat.modules.register("carResults", {
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
    meerkat.modules.register("carSaveQuote", {
        events: events,
        getCopy: getCopy
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {
        carVehicleOptions: {
            UPDATED_VEHICLE_DATA: "UPDATED_VEHICLE_DATA"
        }
    }, steps = null;
    var elements = {
        selector: "#securityOptionRow .select:first, #securityOptionRow .fieldrow_legend:first",
        selectorParent: "#securityOptionRow .row-content",
        visibleRow: "#securityOptionRow",
        hiddenRow: "#securityOptionHiddenRow"
    };
    var initial_load = true;
    var selectorHTML = null;
    function onUpdatedVehicleData(data) {
        $(elements.selector).remove();
        var security = "N";
        var has_alarm = !_.isEmpty(data.alarm);
        var has_immob = !_.isEmpty(data.immobiliser);
        if (has_alarm && has_immob) {
            security = "B";
        } else if (has_alarm) {
            security = "A";
        } else if (has_immob) {
            security = "I";
        }
        if (security !== "N") {
            $(elements.selectorParent).empty();
            $(elements.visibleRow).hide();
            $(elements.hiddenRow).empty().append($("<input/>", {
                type: "hidden",
                name: "quote_vehicle_securityOption",
                id: "quote_vehicle_securityOption",
                value: security
            })).append($("<input/>", {
                type: "hidden",
                name: "quote_vehicle_securityOptionCheck",
                id: "quote_vehicle_securityOptionCheck",
                value: "Y"
            })).show();
        } else {
            $(elements.hiddenRow).empty();
            selectorHTML.find("option:selected").removeAttr("selected");
            selectorHTML.find("select:first").attr("selectedIndex", 0);
            $(elements.selectorParent).empty().append(selectorHTML);
            if (initial_load === true) {
                initial_load = false;
                var securityOption = meerkat.site.vehicleSelectionDefaults.securityOption;
                if (!_.isEmpty(securityOption)) {
                    $(elements.selector).find("option").each(function() {
                        var $that = $(this);
                        if ($that.val() == securityOption) {
                            $that.prop("selected", true);
                        }
                    });
                }
            }
            $(elements.visibleRow).show();
        }
    }
    function initCarSecurityOptions() {
        var self = this;
        $(document).ready(function() {
            if (meerkat.site.vertical !== "car") return false;
            selectorHTML = $(elements.selector).clone();
            selectorHTML.find("option:selected").removeAttr("selected");
            selectorHTML.find("select:first").prop("selectedIndex", 0);
            meerkat.messaging.subscribe(meerkatEvents.carVehicleOptions.UPDATED_VEHICLE_DATA, onUpdatedVehicleData);
        });
    }
    meerkat.modules.register("carSecurityOptions", {
        init: initCarSecurityOptions,
        events: moduleEvents,
        onUpdatedVehicleData: onUpdatedVehicleData
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        carSnapshot: {}
    }, moduleEvents = events.carSnapshot;
    function initCarSnapshot() {
        meerkat.messaging.subscribe(meerkatEvents.car.DROPDOWN_CHANGED, function renderSnapshotSubscription() {
            renderSnapshot();
        });
    }
    function renderSnapshot() {
        var carMake = $("#quote_vehicle_make");
        if (carMake.val() !== "") {
            var $snapshotBox = $(".quoteSnapshot");
            $snapshotBox.removeClass("hidden");
        }
        meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(0) .snapshot");
    }
    meerkat.modules.register("carSnapshot", {
        init: initCarSnapshot,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {
        car: {
            VEHICLE_CHANGED: "VEHICLE_CHANGED"
        },
        carVehicleOptions: {
            UPDATED_VEHICLE_DATA: "UPDATED_VEHICLE_DATA"
        }
    };
    var elements = {
        factory: {
            radio: "#quote_vehicle_factoryOptionsRadioBtns",
            yn: "#quote_vehicle_factoryOptions",
            button: "#quote_vehicle_factoryOptionsButton",
            template: "#quote-factoryoptions-template",
            checkboxes: "#quote_vehicle_factoryOptionsDialog .quote-factory-options",
            inputs: "#quote_vehicle_options_inputs_container .factory:first",
            saveditems: "#quote_vehicle_factoryOptionsSelections .added-items ul"
        },
        accessories: {
            radio: "#quote_vehicle_accessoriesRadioBtns",
            yn: "#quote_vehicle_accessories",
            button: "#quote_vehicle_accessoriesButton",
            template: "#quote-nonstandard-accessories-template",
            inputs: "#quote_vehicle_options_inputs_container .accessories:first",
            wrapper: "#quote_vehicle_accessoriesDialog .quote-optional-accessories-listed",
            type: "#quote_vehicle_accessoriesDialog .ac-type",
            included: "#quote_vehicle_accessoriesDialog .ac-included",
            price: "#quote_vehicle_accessoriesDialog .ac-price",
            add: "#quote_vehicle_accessoriesDialog .ac-add",
            clear: "#quote_vehicle_accessoriesDialog .ac-clear",
            addeditems: "#quote_vehicle_accessoriesDialog .quote-optional-accessories-listed .added-items ul",
            saveditems: "#quote_vehicle_accessoriesSelections .added-items ul"
        },
        redbook: "#quote_vehicle_redbookCode"
    };
    elements.accessories.wrapper = "#quote_vehicle_accessoriesDialog .quote-optional-accessories-listed";
    var isIE8 = false;
    var modals = {
        factory: {},
        accessories: {}
    };
    var vehicleOptionsData = {};
    var vehicleNonStandardAccessories = [];
    var optionPreselections = {};
    var savedSelections = {
        factory: [],
        accessories: []
    };
    var isFirstLoad = true;
    var ajaxInProgress = false;
    var sessionCamStep = null;
    function getVehicleData(callback) {
        if (ajaxInProgress === false) {
            var $element = $(elements.factory.button);
            meerkat.modules.loadingAnimation.showAfter($element);
            var vehicle = meerkat.modules.carVehicleSelection.isSplitTest() ? $(elements.redbook).find("input:checked") : $(elements.redbook);
            var data = {
                redbookCode: vehicle ? vehicle.val() : null
            };
            ajaxInProgress = true;
            meerkat.modules.comms.get({
                url: "rest/car/vehicleAccessories/list.json",
                data: data,
                cache: true,
                useDefaultErrorHandling: false,
                numberOfAttempts: 3,
                errorLevel: "fatal",
                onSuccess: function onSubmitSuccess(resultData) {
                    vehicleOptionsData = resultData;
                    sanitiseVehicleOptionsData();
                    meerkat.messaging.publish(moduleEvents.carVehicleOptions.UPDATED_VEHICLE_DATA, vehicleOptionsData);
                    toggleFactoryOptionsFieldSet();
                    if (_.isFunction(callback)) {
                        callback();
                    }
                },
                onError: onGetVehicleDataError,
                onComplete: function onSubmitComplete() {
                    ajaxInProgress = false;
                    meerkat.modules.loadingAnimation.hide($element);
                }
            });
        }
    }
    function onGetVehicleDataError(jqXHR, textStatus, errorThrown, settings, resultData) {
        meerkat.modules.errorHandling.error({
            message: "Sorry, we cannot seem to retrieve a list of accessories for your vehicles at this time. Please come back to us later and try again.",
            page: "carVehicleOptions.js:getVehicleData()",
            errorLevel: "warning",
            description: "Failed to retrieve a list of accessories for RedBook Code: " + errorThrown,
            data: resultData
        });
    }
    function sanitiseVehicleOptionsData() {
        var list = [ "alarm", "immobiliser", "options", "standard" ];
        if (!_.isObject(vehicleOptionsData)) {
            vehicleOptionsData = {};
        }
        for (var i = 0; i < list.length; i++) {
            if (!vehicleOptionsData.hasOwnProperty(list[i]) || !_.isArray(vehicleOptionsData[list[i]])) {
                vehicleOptionsData[list[i]] = [];
            }
        }
    }
    function renderFactoryModal() {
        var optionalAccessories = generateFactoryOptionsHTML(vehicleOptionsData.options);
        var standardAccessories = generateStandardAccessoriesHTML(vehicleOptionsData.standard);
        var templateAccessories = _.template($(elements.factory.template).html());
        var htmlContent = templateAccessories({
            optionalAccessories: optionalAccessories,
            standardAccessories: standardAccessories
        });
        modals.factory = meerkat.modules.dialogs.show({
            title: $(this).attr("title"),
            htmlContent: htmlContent,
            hashId: "factory-options",
            tabs: [ {
                title: "Add Factory/Dealer Options",
                xsTitle: "Factory/Dealer Options",
                targetSelector: ".quote-factory-options"
            }, {
                title: "View Included Standard Accessories",
                xsTitle: "Standard Accessories",
                targetSelector: ".quote-standard-accessories"
            } ],
            buttons: [ {
                label: "Save Changes",
                className: "btn-save",
                action: _.bind(saveCurrentForm, this, {
                    type: "factory"
                })
            } ],
            rightBtn: {
                label: "Save Changes",
                className: "btn-sm btn-save",
                callback: _.bind(saveCurrentForm, this, {
                    type: "factory"
                })
            },
            closeOnHashChange: true,
            openOnHashChange: false,
            onClose: function() {
                meerkat.modules.sessionCamHelper.updateVirtualPage(getSessionCamStep());
                toggleButtonStates({
                    type: "factory"
                });
            },
            onOpen: function(dialogId) {
                if (_.isArray(vehicleOptionsData.options) && vehicleOptionsData.options.length) {
                    $(".quote-factory-options .no-items-found").addClass("hidden");
                } else {
                    $(".quote-factory-options .items-found").addClass("hidden");
                }
                if (_.isArray(vehicleOptionsData.standard) && vehicleOptionsData.standard.length) {
                    $(".quote-standard-accessories .no-items-found").addClass("hidden");
                } else {
                    $(".quote-standard-accessories .items-found").addClass("hidden");
                }
                $("#" + dialogId).on("click", ".nav-tabs a", function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var sessionCamStep = getSessionCamStep();
                    sessionCamStep.navigationId += "-FactoryDealerOptions-" + $(this).attr("data-target").split("-")[2];
                    meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
                    $(this).tab("show");
                    $("#" + dialogId + " .modal-title-label").html($(this).attr("title"));
                });
                $(".nav-tabs a:first").click();
                if (isIE8) {
                    _.defer(function() {
                        $(function() {
                            $("html.lt-ie9 form#quote_vehicle_factoryOptionsDialogForm").on("change.checkedForIE", ".checkbox input, .compareCheckbox input", function applyCheckboxClicks() {
                                var $this = $(this);
                                if ($this.is(":checked")) {
                                    $this.addClass("checked");
                                } else {
                                    $this.removeClass("checked");
                                }
                            });
                            $("html.lt-ie9 form#quote_vehicle_factoryOptionsDialogForm .checkbox input").change();
                        });
                    });
                }
            }
        });
        return false;
    }
    function renderAccessoriesModal() {
        var standardAccessories = generateStandardAccessoriesHTML(vehicleOptionsData.standard);
        var selectedAccessories = generateSelectedAccessoriesHTML();
        var templateAccessories = _.template($(elements.accessories.template).html());
        var accessories = optionPreselections.accessories.accs;
        var savedAccessories = $(elements.accessories.saveditems).children();
        var selectedIndexes = [];
        var selectedPrices = [];
        $.each(savedAccessories, function(index, savedAccessory) {
            savedAccessory = $(this);
            var itemIndex = savedAccessory.attr("itemIndex");
            var itemPrice = savedAccessory.attr("itemPrice");
            selectedIndexes.push(parseInt(itemIndex));
            selectedPrices.push(itemPrice);
        });
        $.each(vehicleNonStandardAccessories, function(index, vehicleNonStandardAccessory) {
            var foundSelectedIndex = selectedIndexes.indexOf(index);
            var checked = false;
            if (foundSelectedIndex >= 0) {
                checked = true;
            }
            vehicleNonStandardAccessory.checked = checked;
            vehicleNonStandardAccessory.priceDropdown = '<option value="">Please choose&hellip;</option>';
            selectedDropdown = "";
            if (selectedPrices[foundSelectedIndex] == "0") {
                selectedDropdown = "selected";
            }
            vehicleNonStandardAccessory.priceDropdown += '<option value="" disabled="true">---</option>';
            vehicleNonStandardAccessory.priceDropdown += '<option value="0" ' + selectedDropdown + ">Included in purchase price</option>";
            vehicleNonStandardAccessory.priceDropdown += '<option value="" disabled="true">---</option>';
            var min = Math.ceil(vehicleNonStandardAccessory.standard * (vehicleNonStandardAccessory.min / 100));
            var step = min;
            var max = Math.floor(vehicleNonStandardAccessory.standard * (vehicleNonStandardAccessory.max / 100));
            while (step <= max) {
                selectedDropdown = "";
                if (selectedPrices[foundSelectedIndex] == step) {
                    selectedDropdown = "selected";
                }
                vehicleNonStandardAccessory.priceDropdown += '<option value="' + step + '" ' + selectedDropdown + ">$" + step + "</option>";
                step += min;
            }
            step -= min;
            if (step != max) {
                selectedDropdown = "";
                if (selectedPrices[foundSelectedIndex] == max) {
                    selectedDropdown = "selected";
                }
                vehicleNonStandardAccessory.priceDropdown += '<option value="' + max + '" ' + selectedDropdown + ">$" + max + "</option>";
            }
        });
        var htmlContent = templateAccessories({
            standardAccessories: standardAccessories,
            vehicleNonStandardAccessories: vehicleNonStandardAccessories
        });
        var optionalTargetSelector = ".quote-optional-accessories-listed";
        var standardTargetSelector = ".quote-standard-accessories";
        modals.accessories = meerkat.modules.dialogs.show({
            title: $(this).attr("title"),
            htmlContent: htmlContent,
            hashId: "accessories",
            tabs: [ {
                title: "Add Non-Standard Accessories",
                xsTitle: "Non-Standard Accessories",
                targetSelector: optionalTargetSelector
            }, {
                title: "View Included Standard Accessories",
                xsTitle: "Standard Accessories",
                targetSelector: standardTargetSelector
            } ],
            buttons: [ {
                label: "Save Changes",
                className: "btn-save",
                action: _.bind(saveCurrentForm, this, {
                    type: "accessories"
                })
            } ],
            rightBtn: {
                label: "Save Changes",
                className: "btn-sm btn-save",
                callback: _.bind(saveCurrentForm, this, {
                    type: "accessories"
                })
            },
            closeOnHashChange: true,
            openOnHashChange: false,
            onClose: function() {
                meerkat.modules.sessionCamHelper.updateVirtualPage(getSessionCamStep());
                toggleButtonStates({
                    type: "accessories"
                });
            },
            onOpen: function(dialogId) {
                var $injectBlock = $("#injectIntoHeader");
                $injectBlock.remove();
                $(".modal-header").append($injectBlock);
                $("#quote_vehicle_accessoriesDialog").parent().css({
                    "padding-top": "5px"
                });
                if (_.isArray(vehicleNonStandardAccessories) && vehicleNonStandardAccessories.length) {
                    $(".quote-optional-accessories-listed .no-items-found").addClass("hidden");
                } else {
                    $(".quote-optional-accessories-listed .items-found").addClass("hidden");
                }
                if (_.isArray(vehicleOptionsData.standard) && vehicleOptionsData.standard.length) {
                    $(".quote-standard-accessories .no-items-found").addClass("hidden");
                } else {
                    $(".quote-standard-accessories .items-found").addClass("hidden");
                }
                $("#" + dialogId).on("click", ".nav-tabs a", function(e) {
                    if ($(this).attr("data-target") == standardTargetSelector) {
                        $injectBlock.hide();
                    } else {
                        $injectBlock.show();
                    }
                    e.preventDefault();
                    e.stopPropagation();
                    var sessionCamStep = getSessionCamStep();
                    sessionCamStep.navigationId += "-NonStandardAccessories-" + $(this).attr("data-target").split("-")[1];
                    meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
                    $(this).tab("show");
                    $("#" + dialogId + " .modal-title-label").html($(this).attr("title"));
                });
                $(".nav-tabs a:first").click();
                onAccessoriesFormRendered();
            }
        });
        return false;
    }
    function onAccessoriesFormRendered() {
        $(".nonStandardAccessoryCheckbox").on("change", function() {
            var $rowCheckbox = $(this), itemIndex = $rowCheckbox.attr("itemIndex"), $relatedPriceSelect = $('select[itemIndex="' + itemIndex + '"]');
            if ($rowCheckbox.prop("checked")) {
                $relatedPriceSelect.prop("disabled", false);
            } else {
                $relatedPriceSelect.prop("disabled", true);
                $relatedPriceSelect.val("");
            }
        });
        $(".nonStandardAccessorySelect").on("change", function() {
            var selectBox = $(this);
            if (selectBox.val() === "") {
                selectBox.parent().addClass("has-error");
            } else {
                selectBox.parent().removeClass("has-error");
            }
        });
        for (var i = 0; i < savedSelections.accessories.length; i++) {
            var item = savedSelections.accessories[i];
            var $parent = $(elements.accessories.addeditems);
            var $li = $parent.find("li.added-item-" + item.position).first();
            $li.data("info", item);
            $li.find("a:first").on("click", _.bind(onRemoveAccessoriesItem, this, item));
        }
    }
    function getAddedAccessoryItemHTML(item) {
        return $("<li/>").addClass("added-item-" + item.position).data("info", item).append($("<span/>").append(item.label)).append($("<a/>", {
            title: "remove accessory"
        }).addClass("icon-cross").on("click", _.bind(onRemoveAccessoriesItem, this, item))).append($("<span/>").append(item.price === false ? "Included" : "$" + item.price));
    }
    function onRemoveAccessoriesItem(item) {
        $(elements.accessories.addeditems).find(".added-item-" + item.position).remove();
        $(elements.accessories.type).find("option").each(function() {
            if (parseInt($(this).val(), 10) > item.position) {
                $(this).before($("<option/>", {
                    text: item.label,
                    value: item.position + "_" + item.code
                }));
                return false;
            }
        });
    }
    function generateFactoryOptionsHTML(data) {
        var output = $("<ul/>");
        for (var i = 0; i < data.length; i++) {
            var obj = data[i];
            var id = "tmp_fact_" + i + "_chk";
            var name = "tmp_quote_opts_opt" + ("0" + i).slice(-2);
            var chkbox = $("<input/>", {
                type: "checkbox",
                name: name,
                id: id,
                value: obj.code
            });
            if (_.indexOf(savedSelections.factory, id) !== -1) {
                chkbox.attr("checked", true);
            }
            output.append($("<li/>").append($("<div/>").addClass("checkbox").append(chkbox).append($("<label/>").attr("for", id).append(cleanText(obj.label)))));
        }
        return output.html();
    }
    function generateAccessoryOptionsHTML(data) {
        var output = $("<select/>");
        var options = [];
        options.push($("<option/>", {
            text: "please choose...",
            value: ""
        }));
        function isInSavedSelections(code) {
            for (var s = 0; s < savedSelections.accessories.length; s++) {
                if (code == savedSelections.accessories[s].code) {
                    return true;
                }
            }
            return false;
        }
        for (var i = 0; i < data.length; i++) {
            var obj = data[i];
            var option = $("<option/>", {
                text: obj.label,
                value: ("0" + i).slice(-2) + "_" + String(obj.code).replace("/", "/ ")
            });
            if (!isInSavedSelections(obj.code)) {
                options.push(option);
            }
        }
        for (var j = 0; j < options.length; j++) {
            output.append(options[j]);
        }
        return output.html();
    }
    function generateStandardAccessoriesHTML(data) {
        var output = $("<ul/>");
        for (var i = 0; i < data.length; i++) {
            var obj = data[i];
            output.append($("<li/>", {
                text: cleanText(obj.label)
            }));
        }
        return output.html();
    }
    function generateSelectedAccessoriesHTML() {
        var output = $("<ul/>");
        for (var i = 0; i < savedSelections.accessories.length; i++) {
            output.append(getAddedAccessoryItemHTML(savedSelections.accessories[i]));
        }
        return output.html();
    }
    function getAccessoryByCode(code) {
        for (var i = 0; i < vehicleNonStandardAccessories.length; i++) {
            if (vehicleNonStandardAccessories[i].code === code) {
                return vehicleNonStandardAccessories[i];
            }
        }
        return false;
    }
    function getFactoryOptionByIndex(index) {
        if (vehicleOptionsData.options.hasOwnProperty(index)) {
            return vehicleOptionsData.options[index];
        }
        return false;
    }
    function getFactoryOptionByCode(code) {
        for (var i = 0; i < vehicleOptionsData.options.length; i++) {
            if (code === vehicleOptionsData.options[i].code) {
                return vehicleOptionsData.options[i];
            }
        }
        return false;
    }
    function renderPreselections() {
        $(elements.factory.inputs).empty();
        $(elements.factory.saveditems).empty();
        $(elements.accessories.inputs).empty();
        $(elements.accessories.saveditems).empty();
        var factory = optionPreselections.factory;
        var accessories = optionPreselections.accessories;
        if (!_.isUndefined(factory) && !_.isEmpty(factory)) {
            for (var i in factory.opts) {
                if (factory.opts.hasOwnProperty(i)) {
                    var pos = String(parseInt(i.substring(3), 10));
                    var name = "tmp_fact_" + pos + "_chk";
                    var fItem = getFactoryOptionByIndex(pos);
                    fItem.position = ("0" + pos).slice(-2);
                    if (fItem !== false) {
                        savedSelections.factory.push("tmp_fact_" + pos + "_chk");
                        $(elements.factory.inputs).append(getInputHTML({
                            id: name.slice(4),
                            name: "quote_opts_opt" + ("0" + pos).slice(-2),
                            value: fItem.code
                        }));
                        renderExistingSelectionToMainForm({
                            type: "factory",
                            item: fItem
                        });
                    }
                }
            }
        }
        if (!_.isUndefined(accessories) && !_.isEmpty(accessories)) {
            for (var j in accessories.accs) {
                if (accessories.accs.hasOwnProperty(j)) {
                    var aItem = accessories.accs[j];
                    var itemInfo = getAccessoryByCode(aItem.sel);
                    var obj = {
                        included: aItem.inc === "Y",
                        position: parseInt(j.substring(3), 10),
                        price: aItem.hasOwnProperty("prc") ? String(aItem.prc) : "0",
                        code: aItem.sel,
                        label: itemInfo.label
                    };
                    savedSelections.accessories.push(obj);
                    addSavedAccessoryHTML(obj);
                }
            }
        }
        toggleButtonStates({
            type: "factory"
        });
        toggleButtonStates({
            type: "accessories"
        });
    }
    function onRemoveSavedItem(item) {
        $(".saved-item-" + item.type + "-" + item.position).remove();
        if (item.type == "factory") {
            for (var i = 0; i < savedSelections.factory.length; i++) {
                if (savedSelections.factory[i] == "tmp_fact_" + parseInt(item.position, 10) + "_chk") {
                    savedSelections.factory.splice(i, 1);
                }
            }
            if (_.isEmpty(savedSelections.factory)) {
                toggleButtonStates({
                    type: "factory"
                });
            }
        } else {
            for (var j = 0; j < savedSelections.accessories.length; j++) {
                if (savedSelections.accessories[j].code == item.code) {
                    savedSelections.accessories.splice(j, 1);
                }
            }
            if (_.isEmpty(savedSelections.accessories)) {
                toggleButtonStates({
                    type: "accessories"
                });
            }
        }
    }
    function getSavedAccessoryItemHTML(item) {
        var $li = $("<li/>").addClass("saved-item-" + item.type + "-" + item.position).attr("itemIndex", item.position).attr("itemPrice", item.price).append($("<span/>").append(item.label)).append($("<a/>", {
            title: "remove " + (item.type == "factory" ? "factory option" : "accessory")
        }).addClass("icon-cross").on("click", _.bind(onRemoveSavedItem, this, item)));
        if (!_.isNull(item.price)) {
            $li.append($("<span/>").append(item.price === "0" ? "Included" : "$" + item.price));
        }
        return $li;
    }
    function renderExistingSelectionToMainForm(data) {
        var item = {
            type: data.type,
            position: "",
            label: "",
            price: null,
            code: "",
            item: null
        };
        if (data.type == "accessories") {
            item.position = data.item.position;
            item.label = data.item.label;
            item.price = data.item.price;
            item.code = data.item.code;
            item.item = data.item;
            $(elements.accessories.saveditems).append(getSavedAccessoryItemHTML(item));
        } else {
            item.position = data.item.position;
            item.label = data.item.label;
            item.code = data.item.code;
            item.item = data.item;
            $(elements.factory.saveditems).append(getSavedAccessoryItemHTML(item));
        }
    }
    function onVehicleChanged() {
        if (isFirstLoad === false) {
            savedSelections.factory = [];
            savedSelections.accessories = [];
            savedSelections.accessories = [];
            $(elements.factory.inputs).empty();
            $(elements.factory.saveditems).empty();
            $(elements.accessories.inputs).empty();
            $(elements.accessories.saveditems).empty();
            toggleButtonStates({
                type: "factory"
            });
            toggleButtonStates({
                type: "accessories"
            });
            getVehicleData();
        } else {
            isFirstLoad = false;
            getVehicleData(renderPreselections);
        }
    }
    function saveCurrentForm(data) {
        if (data.type == "accessories") {
            var accessoriesToSave = [];
            var validationPasses = true;
            $(".nonStandardAccessoryCheckbox:checked").each(function(index, checkedBox) {
                checkedBox = $(this);
                var itemIndex = checkedBox.attr("itemIndex");
                var labelText = checkedBox.siblings().text();
                var $relatedPriceSelect = $('select[itemIndex="' + itemIndex + '"]');
                var itemPrice = $relatedPriceSelect.val();
                if (itemPrice === "") {
                    validationPasses = false;
                    $relatedPriceSelect.parent().addClass("has-error");
                } else {
                    $relatedPriceSelect.parent().removeClass("has-error");
                }
                var accessory = {
                    position: itemIndex,
                    label: labelText,
                    code: checkedBox.val(),
                    included: $relatedPriceSelect.val() == "0" ? true : false,
                    price: itemPrice
                };
                accessoriesToSave.push(accessory);
            });
            if (validationPasses) {
                savedSelections[data.type] = [];
                $(elements[data.type].inputs).empty();
                $(elements[data.type].saveditems).empty();
                accessoriesToSave.forEach(function(accessory) {
                    savedSelections.accessories.push(accessory);
                    addSavedAccessoryHTML(accessory);
                });
                meerkat.modules.dialogs.close(modals[data.type]);
            } else {
                $(".has-error select").first().focus();
            }
        } else {
            savedSelections[data.type] = [];
            $(elements[data.type].inputs).empty();
            $(elements[data.type].saveditems).empty();
            $(elements[data.type].checkboxes).find(":checked").each(function(i, el) {
                var that = $(this);
                savedSelections.factory.push(that.attr("id"));
                var name = that.attr("name").slice(4);
                var id = that.attr("id").slice(4);
                var index = id.split("_")[1];
                var fItem = getFactoryOptionByIndex(index);
                fItem.position = ("0" + index).slice(-2);
                $(elements.factory.inputs).append(getInputHTML({
                    id: id,
                    name: name,
                    value: that.val()
                }).addClass("saved-item-factory-" + ("0" + fItem.position).slice(-2)));
                renderExistingSelectionToMainForm({
                    type: "factory",
                    item: fItem
                });
            });
            meerkat.modules.dialogs.close(modals[data.type]);
        }
    }
    function addSavedAccessoryHTML(item) {
        $(elements.accessories.inputs).append(getInputHTML({
            name: "quote_accs_acc" + item.position + "_sel",
            id: "acc_" + item.position + "_chk",
            value: item.code
        }).addClass("saved-item-accessories-" + ("0" + item.position).slice(-2))).append(getInputHTML({
            name: "quote_accs_acc" + item.position + "_inc",
            value: item.included === true ? "Y" : "N"
        }).addClass("saved-item-accessories-" + ("0" + item.position).slice(-2)));
        if (item.included === false) {
            $(elements.accessories.inputs).append(getInputHTML({
                name: "quote_accs_acc" + item.position + "_prc",
                value: item.price
            }).addClass("saved-item-accessories-" + ("0" + item.position).slice(-2)));
        }
        renderExistingSelectionToMainForm({
            type: "accessories",
            item: item
        });
    }
    function getInputHTML(props) {
        var obj = {
            type: "hidden"
        };
        _.extend(obj, props);
        return $("<input/>", obj);
    }
    function toggleFactoryOptionsFieldSet() {
        if (_.isArray(vehicleOptionsData.options) && vehicleOptionsData.options.length) {
            $("#quote_vehicle_factoryOptionsFieldSet").removeClass("hidden");
        } else {
            $("#quote_vehicle_factoryOptionsFieldSet").addClass("hidden");
        }
    }
    function toggleButtonStates(data) {
        var hasDefault = $(elements[data.type].radio + " input:radio").is(":checked");
        if (_.isEmpty(savedSelections[data.type])) {
            $(elements[data.type].button).css({
                display: "none"
            });
            $(elements[data.type].radio).css({
                display: "block"
            });
            $(elements[data.type].radio + " input:radio").prop("checked", false).change();
            if (hasDefault === true) {
                $(elements[data.type].radio + " input:radio:last").prop("checked", true).change();
                $(elements[data.type].yn).val("N");
            }
        } else {
            $(elements[data.type].radio + " input:radio").prop("checked", false);
            $(elements[data.type].radio + " input:radio:first").prop("checked", true).change();
            $(elements[data.type].yn).val("Y");
            $(elements[data.type].radio).css({
                display: "none"
            });
            $(elements[data.type].button).css({
                display: "block"
            });
        }
    }
    function cleanText(text) {
        return $("<div />").html(text).text();
    }
    function onYesNoButtonClicked(data, event) {
        event.preventDefault();
        event.stopPropagation();
        data.callback();
    }
    function initCarVehicleOptions() {
        var self = this;
        $(document).ready(function() {
            if (meerkat.site.vertical !== "car") return false;
            isIE8 = meerkat.modules.performanceProfiling.isIE8();
            meerkat.messaging.subscribe(meerkatEvents.car.VEHICLE_CHANGED, onVehicleChanged);
            vehicleNonStandardAccessories = [];
            if (_.isObject(meerkat.site.nonStandardAccessoriesList) && meerkat.site.nonStandardAccessoriesList.hasOwnProperty("items") && _.isArray(meerkat.site.nonStandardAccessoriesList.items)) {
                vehicleNonStandardAccessories = meerkat.site.nonStandardAccessoriesList.items;
            }
            _.extend(optionPreselections, userOptionPreselections);
            var list = [ "factory", "accessories" ];
            for (var i = 0; i < list.length; i++) {
                var label = list[i];
                var val = $(elements[label].yn).val();
                if (_.isEmpty(val) && !_.isEmpty(optionPreselections[label])) {
                    $(elements[label].yn).val("Y");
                    val = "Y";
                }
                if (!_.isEmpty(val)) {
                    $(elements[label].radio + " input:radio").prop("checked", false).change();
                    $(elements[label].radio + " input:radio[value=" + val + "]").prop("checked", true).change();
                }
            }
            $(elements.factory.radio + " label:first").on("click", _.bind(onYesNoButtonClicked, this, {
                type: "factory",
                callback: renderFactoryModal
            }));
            $(elements.accessories.radio + " label:first").on("click", _.bind(onYesNoButtonClicked, this, {
                type: "accessories",
                callback: renderAccessoriesModal
            }));
            $(elements.factory.radio + " label:last").on("click", function() {
                $(elements.factory.yn).val("N");
            });
            $(elements.accessories.radio + " label:last").on("click", function() {
                $(elements.accessories.yn).val("N");
            });
            $(elements.factory.button).on("click", renderFactoryModal);
            $(elements.accessories.button).on("click", renderAccessoriesModal);
        });
    }
    function getSessionCamStep() {
        if (sessionCamStep == null) {
            sessionCamStep = meerkat.modules.journeyEngine.getCurrentStep();
        }
        return _.extend({}, sessionCamStep);
    }
    meerkat.modules.register("carVehicleOptions", {
        init: initCarVehicleOptions,
        events: moduleEvents,
        onVehicleChanged: onVehicleChanged
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {
        car: {
            VEHICLE_CHANGED: "VEHICLE_CHANGED",
            DROPDOWN_CHANGED: "DROPDOWN_CHANGED"
        }
    }, steps = null;
    var elements = {
        makes: "#quote_vehicle_make",
        makeDes: "#quote_vehicle_makeDes",
        makesRow: "#quote_vehicle_makeRow",
        models: "#quote_vehicle_model",
        modelDes: "#quote_vehicle_modelDes",
        modelsRow: "#quote_vehicle_modelRow",
        years: "#quote_vehicle_year",
        registrationYear: "#quote_vehicle_registrationYear",
        yearsRow: "#quote_vehicle_yearRow",
        bodies: "#quote_vehicle_body",
        bodiesDes: "#quote_vehicle_bodyDes",
        bodiesRow: "#quote_vehicle_bodyRow",
        transmissions: "#quote_vehicle_trans",
        transmissionsRow: "#quote_vehicle_transRow",
        fuels: "#quote_vehicle_fuel",
        fuelsRow: "#quote_vehicle_fuelRow",
        types: "#quote_vehicle_redbookCode",
        typesRow: "#quote_vehicle_redbookCodeRow",
        marketValue: "#quote_vehicle_marketValue",
        variant: "#quote_vehicle_variant"
    };
    var snippets = {
        pleaseChooseOptionHTML: "Please choose...",
        resetOptionHTML: "&nbsp;",
        notFoundOptionHTML: "No match for above choices",
        errorInOptionHTML: "Error finding "
    };
    var vehicleSelect = {};
    var RETRY_LIMIT = 3;
    var tryCount = 1;
    var defaults = {};
    var selectorOrder = [ "makes", "models", "years", "bodies", "transmissions", "fuels", "types" ];
    var selectorData = {};
    var activeSelector = false;
    var ajaxInProgress = false;
    var useSessionDefaults = true;
    var radioButtonFields = [ "types" ];
    var isSplitTestFlag = false;
    function getVehicleData(type) {
        if (ajaxInProgress === false) {
            activeSelector = type;
            var $element = $(elements[type]);
            var $loadingIconElement = $element;
            if (!$loadingIconElement.closest(".form-group").hasClass("hidden")) {
                meerkat.modules.loadingAnimation.showAfter($loadingIconElement);
            } else {
                $loadingIconElement = $loadingIconElement.closest(".form-group").prev().find("select");
                meerkat.modules.loadingAnimation.showAfter($loadingIconElement);
            }
            var data = {};
            for (var i = 0; i < _.indexOf(selectorOrder, type); i++) {
                var previousType = selectorOrder[i];
                if (_.indexOf(selectorOrder, type) > _.indexOf(selectorOrder, "bodies") && previousType == "bodies") {
                    data.body = $(elements[previousType]).val();
                } else {
                    data[previousType.substring(0, previousType.length - 1)] = $(elements[previousType]).val();
                }
            }
            stripValidationStyles($element);
            if (isSplitTest() && isRadioButtonField(type)) {
                $element.empty();
            } else {
                $element.attr("selectedIndex", 0);
                $element.empty().append($("<option/>", {
                    value: ""
                }).append(snippets.resetOptionHTML));
            }
            enableDisablePreviousSelectors(type, true);
            ajaxInProgress = true;
            _.defer(function() {
                meerkat.modules.comms.get({
                    url: "rest/car/" + type + "/list.json",
                    data: data,
                    cache: true,
                    useDefaultErrorHandling: false,
                    numberOfAttempts: 3,
                    errorLevel: "fatal",
                    onSuccess: function onSubmitSuccess(resultData) {
                        populateSelectorData(type, resultData);
                        renderVehicleSelectorData(type);
                        return true;
                    },
                    onError: onGetVehicleSelectorDataError,
                    onComplete: function onSubmitComplete() {
                        ajaxInProgress = false;
                        meerkat.modules.loadingAnimation.hide($loadingIconElement);
                        checkAndNotifyOfVehicleChange();
                        disableFutureSelectors(type);
                        return true;
                    }
                });
            });
        }
    }
    function onGetVehicleSelectorDataError(jqXHR, textStatus, errorThrown, settings, resultData) {
        ajaxInProgress = false;
        meerkat.modules.loadingAnimation.hide($(elements[activeSelector]));
        var previous = getPreviousSelector(activeSelector);
        if (previous !== false) {
            var $e = $(elements[previous]);
            $e.find("option:selected").prop("selected", false);
        }
        enableDisablePreviousSelectors(activeSelector, false);
        $(elements[activeSelector]).empty().append($("<option/>", {
            text: snippets.errorInOptionHTML + activeSelector,
            value: ""
        })).prop("disabled", false).blur();
        meerkat.modules.errorHandling.error({
            message: "Sorry, we cannot seem to retrieve a list of " + activeSelector + " for your vehicles at this time. Please come back to us later and try again.",
            page: "vehicleSelection.js:getVehicleSelectorData()",
            errorLevel: "warning",
            description: "Failed to retrieve a list of " + activeSelector + ": " + errorThrown,
            data: resultData
        });
        return false;
    }
    function populateSelectorData(type, response) {
        flushSelectorData(type);
        for (var i = _.indexOf(selectorOrder, type); i < selectorOrder.length; i++) {
            if (response.hasOwnProperty(selectorOrder[i]) && selectorData.hasOwnProperty(selectorOrder[i])) {
                selectorData[selectorOrder[i]] = response[selectorOrder[i]];
            }
        }
    }
    function flushSelectorData(type) {
        var start = _.isUndefined(type) ? 0 : _.indexOf(selectorOrder, type);
        for (var i = start; i < selectorOrder.length; i++) {
            selectorData[selectorOrder[i]] = {};
        }
    }
    function renderVehicleSelectorData(type) {
        if (selectorData.hasOwnProperty(type)) {
            activeSelector = type;
            var autoSelect = false;
            var isIosXS = meerkat.modules.performanceProfiling.isIos() && meerkat.modules.deviceMediaState.get() == "xs";
            if (selectorData[type] && _.isArray(selectorData[type])) {
                var selected = null;
                if (useSessionDefaults === true && defaults.hasOwnProperty(type) && defaults[type] !== "") {
                    selected = defaults[type];
                }
                autoSelect = selectorData[type].length === 1;
                $selector = $(elements[type]);
                $selector.empty();
                var options = [];
                if (!isSplitTest() || isSplitTest() && !isRadioButtonField(type)) {
                    options.push($("<option/>", {
                        text: snippets.pleaseChooseOptionHTML,
                        value: ""
                    }));
                }
                var hasPopularModels = false;
                if (type == "models" && selectorData[type][0].hasOwnProperty("isTopModel") && selectorData[type][0].isTopModel === true) {
                    hasPopularModels = true;
                }
                if (type == "makes" || hasPopularModels) {
                    var label = type.charAt(0).toUpperCase() + type.slice(1);
                    options.push($("<optgroup/>", {
                        label: "Top " + label
                    }));
                    options.push($("<optgroup/>", {
                        label: "All " + label
                    }));
                } else if ((!isSplitTest() || isSplitTest() && !isRadioButtonField(type)) && isIosXS && autoSelect !== true) {
                    options.push($("<optgroup/>", {
                        label: type.charAt(0).toUpperCase() + type.slice(1)
                    }));
                }
                for (var i in selectorData[type]) {
                    if (selectorData[type].hasOwnProperty(i)) {
                        if (typeof selectorData[type][i] === "function") continue;
                        var item = selectorData[type][i];
                        var option = null;
                        if (isSplitTest() && isRadioButtonField(type)) {
                            var radio_name = "quote_vehicle_redbookCode";
                            option = $("<div/>", {
                                "class": "radioCustom"
                            }).append($("<input/>", {
                                type: "radio",
                                id: radio_name + "_" + item.code,
                                name: radio_name,
                                value: item.code,
                                required: "required",
                                "data-autosave": "true",
                                "data-msg-required": "Please select a vehicle type"
                            })).append($("<label/>", {
                                "for": radio_name + "_" + item.code,
                                text: item.label
                            }));
                        } else {
                            option = $("<option/>", {
                                text: item.label,
                                value: item.code
                            });
                        }
                        if (selected !== true && (autoSelect === true || !_.isNull(selected) && selected == item.code)) {
                            if (isSplitTest() && isRadioButtonField(type)) {
                                option.find("input").prop("checked", true);
                            } else {
                                option.prop("selected", true);
                            }
                            selected = true;
                        }
                        if (type == "makes" || type == "models" && hasPopularModels) {
                            if (item[hasPopularModels ? "isTopModel" : "isTopMake"] === true) {
                                option.appendTo(options[1], options[2]);
                            } else {
                                options[2].append(option);
                            }
                        } else {
                            if ((!isSplitTest() || isSplitTest() && !isRadioButtonField(type)) && isIosXS && autoSelect !== true) {
                                options[1].append(option);
                            } else {
                                options.push(option);
                            }
                        }
                    }
                }
                for (var o = 0; o < options.length; o++) {
                    $selector.append(options[o]);
                }
                if (isSplitTest() && isRadioButtonField(type)) {
                    addChangeListenerToRadioGroup($selector, type);
                }
                $selector.prop("disabled", false);
                if (!$selector.is(":visible")) {
                    $(elements[type + "Row"]).removeClass("hidden");
                }
                if (type === "makes") {
                    disableFutureSelectors(type);
                }
                stripValidationStyles($selector);
                if (autoSelect === true || !_.isNull(selected)) {
                    addValidationStyles($selector);
                    $selector.blur();
                }
                enableDisablePreviousSelectors(type, false);
                var next = getNextSelector(type);
                meerkat.messaging.publish(moduleEvents.car.DROPDOWN_CHANGED);
                if (next !== false) {
                    if (_.isArray(selectorData[next]) && !_.isEmpty(selectorData[next])) {
                        renderVehicleSelectorData(next);
                    } else if (autoSelect === true) {
                        ajaxInProgress = false;
                        getVehicleData(next);
                    }
                }
            } else {
                if (isSplitTest() && isRadioButtonField(type)) {
                    $(elements[activeSelector + "Row"]).addClass("hidden");
                    $(elements[activeSelector]).empty();
                } else {
                    $(elements[activeSelector]).empty().append($("<option/>", {
                        text: snippets.notFoundOptionHTML,
                        value: ""
                    }));
                }
            }
        }
    }
    function getPreviousSelector(current) {
        var prev = _.indexOf(selectorOrder, current) - 1;
        if (selectorOrder.hasOwnProperty(prev)) {
            return selectorOrder[prev];
        }
        return false;
    }
    function getNextSelector(current) {
        var next = _.indexOf(selectorOrder, current) + 1;
        if (selectorOrder.hasOwnProperty(next)) {
            return selectorOrder[next];
        }
        return false;
    }
    function emptyElement($element) {
        $element.empty();
    }
    function disableFutureSelectors(current) {
        var indexOfActiveSelector = _.indexOf(selectorOrder, current);
        if (indexOfActiveSelector > -1) {
            for (var i = 0; i < selectorOrder.length; i++) {
                if (elements.hasOwnProperty(selectorOrder[i])) {
                    var $e = $(elements[selectorOrder[i]]);
                    if (i > indexOfActiveSelector) {
                        if (isSplitTest() && isRadioButtonField(selectorOrder[i])) {
                            $(elements[selectorOrder[i] + "Row"]).addClass("hidden");
                            $e.empty();
                        } else {
                            $e.attr("selectedIndex", 0);
                            $e.empty().append($("<option/>", {
                                value: ""
                            }).append(snippets.resetOptionHTML));
                        }
                        stripValidationStyles($e);
                        $e.prop("disabled", true);
                        if (indexOfActiveSelector === 1) {
                            $(elements.marketValue).val("");
                            $(elements.variant).val("");
                            $(elements.modelDes).val("");
                            $(elements.registrationYear).val("");
                        }
                    }
                }
            }
        }
    }
    function enableDisablePreviousSelectors(current, disabled) {
        disabled = disabled || false;
        for (var i = 0; i <= _.indexOf(selectorOrder, current); i++) {
            $(elements[selectorOrder[i]]).prop("disabled", disabled);
        }
    }
    function selectionChanged(data) {
        useSessionDefaults = false;
        var next = getNextSelector(data.field);
        var invalid = _.isEmpty($(elements[data.field]).val());
        if (invalid === true) {
            stripValidationStyles($(elements[data.field]));
            disableFutureSelectors(data.field);
        }
        var make = getDataForCode("makes", $(elements.makes).val());
        if (make !== false) {
            $(elements.makeDes).val(make.label);
        } else {
            $("span[data-source='#quote_vehicle_make']").text("");
        }
        var model = getDataForCode("models", $(elements.models).val());
        if (model !== false) $(elements.modelDes).val(model.label);
        var year = getDataForCode("years", $(elements.years).val());
        if (year !== false) $(elements.registrationYear).val(year.code);
        if (invalid === false && next !== false) {
            disableFutureSelectors(next);
            getVehicleData(next);
        }
        if (data.field === "types") {
            var $element = $(elements.types);
            if (isSplitTest() && $element.find("input:checked") || !isSplitTest() && !_.isEmpty($element.val())) {
                addValidationStyles($element);
                checkAndNotifyOfVehicleChange();
            }
        }
        meerkat.messaging.publish(moduleEvents.car.DROPDOWN_CHANGED);
    }
    function addChangeListeners() {
        for (var i = 0; i < selectorOrder.length; i++) {
            if (selectorOrder.hasOwnProperty(i)) {
                if (isSplitTest() && isRadioButtonField(selectorOrder[i])) {
                    addChangeListenerToRadioGroup($(elements[selectorOrder[i]]), selectorOrder[i]);
                } else {
                    $(elements[selectorOrder[i]]).off().on("change", _.bind(selectionChanged, this, {
                        field: selectorOrder[i]
                    }));
                }
            }
        }
    }
    function addChangeListenerToRadioGroup($element, type) {
        $element.find("input[type=radio]").off().on("change", _.bind(selectionChanged, this, {
            field: type
        }));
    }
    function stripValidationStyles(element) {
        element.removeClass("has-success has-error");
        element.closest(".form-group").find(".row-content").removeClass("has-success has-error").end().find(".error-field").remove();
    }
    function addValidationStyles(element) {
        element.addClass("has-success");
        element.closest(".form-group").find(".row-content").addClass("has-success");
    }
    function getDataForCode(type, code) {
        if (!_.isEmpty(code)) {
            for (var i = 0; i < selectorData[type].length; i++) {
                if (code == selectorData[type][i].code) {
                    return selectorData[type][i];
                }
            }
        }
        return false;
    }
    function checkAndNotifyOfVehicleChange() {
        var vehicle = isSplitTest() ? $(elements.types).find("input:checked") : $(elements.types);
        var rbc = vehicle ? vehicle.val() : null;
        if (!_.isEmpty(rbc)) {
            var make = getDataForCode("makes", $(elements.makes).val());
            if (make !== false) $(elements.makeDes).val(make.label);
            var model = getDataForCode("models", $(elements.models).val());
            if (model !== false) $(elements.modelDes).val(model.label);
            var year = getDataForCode("years", $(elements.years).val());
            if (year !== false) $(elements.registrationYear).val(year.code);
            var type = getDataForCode("types", rbc);
            if (type !== false) {
                $(elements.marketValue).val(type.marketValue);
                $(elements.variant).val(type.label);
            }
            if (isSplitTest()) {
                _.defer(function() {
                    meerkat.messaging.publish(moduleEvents.car.VEHICLE_CHANGED);
                });
            } else {
                meerkat.messaging.publish(moduleEvents.car.VEHICLE_CHANGED);
            }
        }
    }
    function initCarVehicleSelection() {
        var self = this;
        $(document).ready(function() {
            if (meerkat.site.vertical !== "car") return false;
            isSplitTestFlag = meerkat.modules.splitTest.isActive(8);
            for (var i = 0; i < selectorOrder.length; i++) {
                $(elements[selectorOrder[i]]).attr("tabindex", i + 1);
            }
            flushSelectorData();
            _.extend(defaults, meerkat.site.vehicleSelectionDefaults);
            _.extend(selectorData, meerkat.site.vehicleSelectionDefaults.data);
            addChangeListeners();
            renderVehicleSelectorData("makes");
            checkAndNotifyOfVehicleChange();
            if (!isSplitTest() && meerkat.modules.performanceProfiling.isIE8()) {
                $(document).on("focus", "#quote_vehicle_redbookCode", function() {
                    var el = $(this);
                    el.data("width", el.width());
                    el.width("auto");
                    el.data("width-auto", $(this).width());
                    if (el.data("width-auto") < el.data("width")) {
                        el.width(el.data("width"));
                    } else {
                        el.width(el.data("width-auto") + 15);
                    }
                }).on("blur", "#quote_vehicle_redbookCode", function() {
                    var el = $(this);
                    el.width(el.data("width"));
                });
            }
        });
    }
    function isRadioButtonField(type) {
        return _.indexOf(radioButtonFields, type) > -1;
    }
    function isSplitTest() {
        return isSplitTestFlag;
    }
    meerkat.modules.register("carVehicleSelection", {
        init: initCarVehicleSelection,
        events: moduleEvents,
        isSplitTest: isSplitTest
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {}, steps = null;
    var elements = {
        toggle: "#quote_drivers_youngToggleArea",
        labels: "#quote_drivers_youngDriverRow .row-content",
        restrict: "#quote_options_driverOption",
        reg_dob: "#quote_drivers_regular_dob",
        yng_dob: "#quote_drivers_young_dob",
        age_row: "#quote_restricted_ageRow"
    };
    var driverOptions = {};
    var driverOptionsOrder = [ "0", "3", "H", "7", "A", "D" ];
    var selectorHTML = null;
    var sessionCamStep = null;
    function updateRestrictAgeSelector() {
        var ageRegular = meerkat.modules.utilities.returnAge($(elements.reg_dob).val(), true);
        var ageYoungest = meerkat.modules.utilities.returnAge($(elements.yng_dob).val(), true);
        var age = Math.min(ageRegular, ageYoungest);
        if (age <= 20) {
            $(elements.age_row).slideUp();
        } else if (age <= 24) {
            $(elements.age_row).slideDown();
            updateSelector([ "H" ]);
        } else if (age <= 29) {
            $(elements.age_row).slideDown();
            updateSelector([ "H", "7" ]);
        } else if (age <= 39) {
            $(elements.age_row).slideDown();
            updateSelector([ "H", "7", "A" ]);
        } else {
            $(elements.age_row).slideDown();
            updateSelector([ "H", "7", "A", "D" ]);
        }
    }
    function updateSelector(opts) {
        var $selector = $(elements.restrict);
        var selected = $selector.val();
        $selector.empty();
        for (var i = 0; i < driverOptionsOrder.length; i++) {
            var key = driverOptionsOrder[i];
            if (driverOptions.hasOwnProperty(key)) {
                if (key === "0" || key === "3" || _.indexOf(opts, key) >= 0) {
                    var $option = driverOptions[key].clone();
                    if (key === selected) {
                        $option.prop("selected", true);
                    }
                    $selector.append($option);
                }
            }
        }
    }
    function captureOptions() {
        var $e = $(elements.restrict);
        $e.find("option").each(function() {
            var $that = $(this);
            var key = _.isEmpty($that.val()) ? 0 : $that.val();
            driverOptions[key] = $that.clone();
            driverOptions[key].prop("selected", false);
        });
    }
    function isYoungDriverSelected() {
        var $e = $(elements.labels).find("input:checked");
        if (!_.isEmpty($e)) {
            return $e.val() === "Y";
        }
        return false;
    }
    function toggleVisibleContent(updateVirtualPage) {
        updateVirtualPage = updateVirtualPage || false;
        var $e = $(elements.labels).find("input:checked");
        if (!_.isEmpty($e)) {
            if (isYoungDriverSelected()) {
                $(elements.toggle).slideDown("fast", function() {
                    if (updateVirtualPage) {
                        var sessionCamStep = getSessionCamStep();
                        sessionCamStep.navigationId += "-youngdriver";
                        meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
                    }
                });
            } else {
                $(elements.toggle).slideUp("fast", function() {
                    var $that = $(this);
                    $that.find(":text").val("");
                    $that.find(":radio").prop("checked", false).change();
                    $(elements.yng_dob).val("").change();
                    $that.find(".has-success").removeClass("has-success");
                    $that.find(".has-error").removeClass("has-error");
                    $that.find(".error-field").remove();
                    if (updateVirtualPage) {
                        meerkat.modules.sessionCamHelper.updateVirtualPage(getSessionCamStep());
                    }
                });
            }
        }
    }
    function initCarYoungDrivers() {
        var self = this;
        meerkat.modules.sessionCamHelper.addStepToIgnoreList("details");
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function youngDriverStepOnStepChange(event) {
            if (event.navigationId == "details") {
                _.defer(_.bind(toggleVisibleContent, this, true));
            }
        });
        $(document).ready(function() {
            if (meerkat.site.vertical !== "car") return false;
            $(elements.labels + " label input").on("click", function(e) {
                _.defer(_.bind(toggleVisibleContent, this, true));
            });
            $(elements.reg_dob + "," + elements.yng_dob).on("change", updateRestrictAgeSelector);
            captureOptions();
            toggleVisibleContent();
            setTimeout(function() {
                if (meerkat.modules.journeyEngine.getCurrentStep().navigationId == "details") {
                    var sessionCamStep = getSessionCamStep();
                    if (isYoungDriverSelected()) {
                        sessionCamStep.navigationId += "-youngdriver";
                    }
                    meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
                }
            }, 250);
            updateRestrictAgeSelector();
        });
    }
    function getSessionCamStep() {
        if (sessionCamStep == null) {
            sessionCamStep = meerkat.modules.journeyEngine.getCurrentStep();
        }
        return _.extend({}, sessionCamStep);
    }
    meerkat.modules.register("carYoungDrivers", {
        initCarYoungDrivers: initCarYoungDrivers,
        events: moduleEvents,
        getSessionCamStep: getSessionCamStep
    });
})(jQuery);