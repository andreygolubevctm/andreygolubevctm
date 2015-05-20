/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var moduleEvents = {
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    };
    var steps = null;
    function initJourneyEngine() {
        if (meerkat.site.pageAction === "confirmation") {
            meerkat.modules.journeyEngine.configure(null);
        } else {
            initProgressBar(false);
            meerkat.modules.journeyEngine.configure({
                startStepId: null,
                steps: _.toArray(steps)
            });
            var transaction_id = meerkat.modules.transactionId.get();
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackQuoteEvent",
                object: {
                    action: "Start",
                    transactionID: parseInt(transaction_id, 10),
                    vertical: meerkat.site.vertical,
                    verticalFilter: meerkat.modules.homeloan.getVerticalFilter()
                }
            });
        }
    }
    function initProgressBar(render) {
        setJourneyEngineSteps();
        configureProgressBar();
    }
    function setJourneyEngineSteps() {
        var startStep = {
            title: "Your Situation",
            navigationId: "situation",
            slideIndex: 0,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.homeloan.getTrackingFieldsObject
            },
            onInitialise: function initStartStep(event) {
                meerkat.modules.homeloanResults.initPage();
                meerkat.modules.currencyField.initCurrency();
                var $emailQuoteBtn = $(".slide-feature-emailquote");
                var $privacyOptin = $("#homeloan_privacyoptin");
                if ($privacyOptin.is(":checked")) {
                    $emailQuoteBtn.addClass("privacyOptinChecked");
                }
                $privacyOptin.on("change", function(event) {
                    if ($(this).is(":checked")) {
                        $emailQuoteBtn.addClass("privacyOptinChecked");
                    } else {
                        $emailQuoteBtn.removeClass("privacyOptinChecked");
                    }
                });
            },
            onBeforeLeave: function(event) {}
        };
        var resultsStep = {
            title: "Results",
            navigationId: "results",
            slideIndex: 1,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.homeloan.getTrackingFieldsObject
            },
            validation: {
                validate: false,
                customValidation: function validateSelection(callback) {
                    callback(true);
                }
            },
            onInitialise: function() {
                meerkat.modules.homeloanMoreInfo.initMoreInfo();
                meerkat.modules.homeloanFilters.initFilters();
            },
            onBeforeEnter: function enterResultsStep(event) {
                Results.removeSelectedProduct();
                if (event.isForward === true) {
                    $("#resultsPage").addClass("hidden");
                    $(".morePromptContainer, .comparison-rate-disclaimer").addClass("hidden");
                }
            },
            onAfterEnter: function(event) {
                if (event.isForward === true) {
                    meerkat.modules.homeloanResults.get();
                }
                $("#navbar-main").addClass("affix-top").removeClass("affix");
            },
            onBeforeLeave: function(event) {
                if (event.isBackward === true) {
                    meerkat.modules.transactionId.getNew(3);
                }
            }
        };
        var enquiryStep = {
            title: "Enquiry",
            navigationId: "enquiry",
            slideIndex: 2,
            tracking: {
                touchType: "A"
            },
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.homeloan.getTrackingFieldsObject
            },
            onInitialise: function() {
                meerkat.modules.homeloanEnquiry.initHomeloanEnquiry();
                meerkat.modules.homeloanSnapshot.initHomeloanSnapshot();
            },
            onBeforeEnter: function() {
                meerkat.modules.homeloanSnapshot.onEnter();
                if (Results.getSelectedProduct() !== false && Results.getSelectedProduct().hasOwnProperty("id")) {
                    $("#homeloan_product_id").val(Results.getSelectedProduct().id);
                    $("#homeloan_product_lender").val(Results.getSelectedProduct().lender);
                }
                var $situationStepFirstNameInput = $("#homeloan_contact_firstName"), $enquiryStepFirstNameRow = $("#homeloan_enquiry_contact_firstName").closest(".form-group"), $situationStepLastNameInput = $("#homeloan_contact_lastName"), $enquiryStepLastNameRow = $("#homeloan_enquiry_contact_lastName").closest(".form-group");
                if ($situationStepFirstNameInput.val() === "" || $situationStepLastNameInput.val() === "") {
                    $enquiryStepFirstNameRow.add($enquiryStepLastNameRow).removeClass("hidden");
                }
            }
        };
        steps = {
            startStep: startStep,
            resultsStep: resultsStep,
            enquiryStep: enquiryStep
        };
    }
    function configureProgressBar() {
        meerkat.modules.journeyProgressBar.configure([ {
            label: "Your Situation",
            navigationId: steps.startStep.navigationId
        }, {
            label: "Your Quote",
            navigationId: steps.resultsStep.navigationId
        }, {
            label: "Make an Enquiry",
            navigationId: steps.enquiryStep.navigationId
        } ]);
    }
    function getVerticalFilter() {
        return $("#homeloan_details_situation").val() || null;
    }
    function getTrackingFieldsObject(special_case) {
        try {
            special_case = special_case || false;
            var transactionId = meerkat.modules.transactionId.get();
            var goal = $("#homeloan_details_goal").val();
            var postCode = $("#homeloan_details_postcode").val();
            var stateCode = $("#homeloan_details_state").val();
            var purchasePrice = $("#homeloan_loanDetails_purchasePrice").val();
            var loanAmount = $("#homeloan_loanDetails_loanAmount").val();
            var interestRateType = $("input[name=homeloan_loanDetails_interestRate]:checked").val();
            var email = $("#homeloan_contact_email").val();
            var marketOptIn = $("#homeloan_contact_optIn").is(":checked") ? "Y" : "N";
            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();
            var actionStep = "";
            switch (current_step) {
              case 0:
                actionStep = "your situation";
                break;

              case 1:
                if (special_case === true) {
                    actionStep = "homeloan more info";
                } else {
                    actionStep = "homeloan results";
                }
                break;

              case 2:
                actionStep = "enquire now";
                break;
            }
            var response = {
                vertical: meerkat.site.vertical,
                actionStep: actionStep,
                transactionID: transactionId,
                quoteReferenceNumber: transactionId,
                postCode: null,
                state: null,
                email: null,
                emailID: null,
                marketOptIn: null,
                okToCall: null
            };
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("situation")) {
                _.extend(response, {
                    verticalFilter: meerkat.modules.homeloan.getVerticalFilter(),
                    goal: goal,
                    postCode: postCode,
                    state: stateCode,
                    purchasePrice: purchasePrice,
                    loanAmount: loanAmount,
                    interestRateType: interestRateType,
                    email: email,
                    marketOptIn: marketOptIn
                });
            }
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex("enquiry")) {
                _.extend(response, {});
            }
            return response;
        } catch (e) {
            return false;
        }
    }
    function applyValuesFromBrochureSite() {
        if (meerkat.site.isFromBrochureSite === true) {
            _.defer(function() {
                if (meerkat.site.brochureValues.hasOwnProperty("situation")) {
                    if ($("#homeloan_details_situation_" + meerkat.site.brochureValues.situation).length === 1) {
                        $("#homeloan_details_situation").val(meerkat.site.brochureValues.situation);
                    }
                }
                if (meerkat.site.brochureValues.hasOwnProperty("location")) {
                    $("#homeloan_details_location").val(meerkat.site.brochureValues.location);
                }
            });
        }
    }
    function configureContactDetails() {
        if (meerkat.site.pageAction === "confirmation") {
            return;
        }
        var $situationStepPhoneInput = $("#homeloan_contact_contactNumberinput"), $enquiryStepPhoneInput = $("#homeloan_enquiry_contact_contactNumberinput"), $situationStepEmailInput = $("#homeloan_contact_email"), $enquiryStepEmailInput = $("#homeloan_enquiry_contact_email"), $situationStepFirstNameInput = $("#homeloan_contact_firstName"), $enquiryStepFirstNameInput = $("#homeloan_enquiry_contact_firstName"), $situationStepLastNameInput = $("#homeloan_contact_lastName"), $enquiryStepLastNameInput = $("#homeloan_enquiry_contact_lastName");
        var contactDetailsFields = {
            name: [ {
                $field: $enquiryStepFirstNameInput,
                $fieldInput: $situationStepFirstNameInput
            }, {
                $field: $enquiryStepFirstNameInput,
                $fieldInput: $enquiryStepFirstNameInput
            } ],
            lastname: [ {
                $field: $enquiryStepLastNameInput,
                $fieldInput: $situationStepLastNameInput
            }, {
                $field: $enquiryStepLastNameInput,
                $fieldInput: $enquiryStepLastNameInput
            } ],
            email: [ {
                $field: $enquiryStepEmailInput,
                $fieldInput: $situationStepEmailInput
            }, {
                $field: $enquiryStepEmailInput,
                $fieldInput: $enquiryStepEmailInput
            } ],
            phone: [ {
                $field: $("#homeloan_contact_contactNumber"),
                $fieldInput: $situationStepPhoneInput
            }, {
                $field: $("#homeloan_enquiry_contact_contactNumber"),
                $fieldInput: $enquiryStepPhoneInput
            } ]
        };
        meerkat.modules.contactDetails.configure(contactDetailsFields);
    }
    function trackHandover() {
        var product = Results.getSelectedProduct();
        if (_.isEmpty(product)) {
            product = {};
            product.productId = "General Enquiry";
            product.lenderProductName = "General Enquiry";
            product.brandCode = "General Enquiry";
        }
        var transaction_id = meerkat.modules.transactionId.get();
        meerkat.modules.partnerTransfer.trackHandoverEvent({
            product: product,
            type: "ONLINE",
            quoteReferenceNumber: transaction_id,
            transactionID: transaction_id,
            productID: product.productId,
            productName: product.lenderProductName,
            productBrandCode: product.brandCode
        }, false);
    }
    function initHomeloan() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "homeloan") return false;
            applyValuesFromBrochureSite();
            initJourneyEngine();
            configureContactDetails();
        });
    }
    meerkat.modules.register("homeloan", {
        init: initHomeloan,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject,
        getVerticalFilter: getVerticalFilter,
        trackHandover: trackHandover
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    function init() {
        jQuery(document).ready(function($) {
            if (typeof meerkat.site === "undefined") return;
            if (meerkat.site.pageAction !== "confirmation") return;
            if (confirmationData.hasOwnProperty("confirmation") === false || confirmationData.confirmation.hasOwnProperty("flexOpportunityId") === false) {
                var message = "Trying to load the confirmation page failed";
                if (confirmationData.hasOwnProperty("confirmation") && confirmationData.confirmation.hasOwnProperty("message")) {
                    message = confirmationData.confirmation.message;
                }
                meerkat.modules.errorHandling.error({
                    message: message,
                    page: "homeloanConfirmation.js module",
                    description: "Invalid data",
                    data: null,
                    errorLevel: "warning"
                });
            } else {
                var data = confirmationData.confirmation;
                fillTemplate(data);
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "completedApplication",
                    object: {
                        productID: data.product && data.product.id ? data.product.id : null,
                        productBrandCode: data.product && data.product.lender ? data.product.lender : null,
                        quoteReferenceNumber: data.flexOpportunityId,
                        verticalFilter: data.hasOwnProperty("situation") ? data.situation : null,
                        transactionID: confirmationTranId || null,
                        vertical: meerkat.site.vertical
                    }
                });
            }
        });
    }
    function fillTemplate(obj) {
        var confirmationTemplate = $("#confirmation-template").html();
        if (confirmationTemplate.length) {
            var htmlTemplate = _.template(confirmationTemplate);
            var htmlString = htmlTemplate(obj);
            $("#confirmation").html(htmlString);
        }
    }
    meerkat.modules.register("homeloanConfirmation", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, stateSubmitInProgress = false, $foundProperty, $foundPanel, $bestContact, $bestContactPanel, $submitButton;
    var moduleEvents = {
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    };
    function applyEventListeners() {
        $submitButton.on("click", function(event) {
            var valid = meerkat.modules.journeyEngine.isCurrentStepValid();
            if (valid) {
                submitEnquiry();
            }
        });
        $bestContact.on("change", function() {
            if ($bestContact.val() === "P") {
                $bestContactPanel.addClass("show_Y").removeClass("show_N").removeClass("show_");
            } else {
                $bestContactPanel.addClass("show_N").removeClass("show_Y").removeClass("show_");
            }
        });
        $("#homeloan_enquiry_contact_firstName, #homeloan_enquiry_contact_lastName").on("change", function() {
            meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(2) .snapshot");
        });
        $foundProperty.on("change", function() {
            if ($("#homeloan_enquiry_newLoan_foundAProperty_Y").is(":checked")) {
                $foundPanel.addClass("show_Y").removeClass("show_N").removeClass("show_");
            } else {
                $foundPanel.addClass("show_N").removeClass("show_Y").removeClass("show_");
                $("#homeloan_enquiry_newLoan_offerTime").val("");
                $("#homeloan_enquiry_newLoan_propertyType").val("");
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, lockSlide);
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, unlockSlide);
    }
    function initHomeloanEnquiry() {
        $(document).ready(function() {
            $submitButton = $("#submit_btn");
            $bestContact = $("#homeloan_enquiry_contact_bestContact");
            $bestContactPanel = $("#homeloan_enquiry_contact_bestcontactToggleArea");
            $foundProperty = $("#homeloan_enquiry_newLoan_foundAProperty");
            $foundPanel = $("#homeloan_enquiry_newLoan_foundToggleArea");
            applyEventListeners();
            $bestContact.trigger("change");
            $foundProperty.trigger("change");
        });
    }
    function lockSlide(obj) {
        var isSameSource = typeof obj !== "undefined" && obj.source && obj.source === "homeloanEnquiry";
        var disableFields = typeof obj !== "undefined" && obj.disableFields && obj.disableFields === true;
        $submitButton.addClass("disabled");
        if (disableFields === true) {
            var $slide = $("#enquiryForm");
            $slide.find(":input").prop("disabled", true);
            $slide.find(".select").addClass("disabled");
            $slide.find(".btn-group label").addClass("disabled");
        }
        if (isSameSource === true) {
            meerkat.modules.loadingAnimation.showAfter($submitButton);
        }
    }
    function unlockSlide(obj) {
        $submitButton.removeClass("disabled");
        meerkat.modules.loadingAnimation.hide($submitButton);
        var $slide = $("#enquiryForm");
        $slide.find(":input").prop("disabled", false);
        $slide.find(".select").removeClass("disabled");
        $slide.find(".btn-group label").removeClass("disabled");
    }
    function submitEnquiry() {
        if (stateSubmitInProgress === true) {
            alert("This page is still being processed. Please wait.");
            return;
        }
        stateSubmitInProgress = true;
        var postData = meerkat.modules.journeyEngine.getFormData();
        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {
            source: "homeloanEnquiry",
            disableFields: true
        });
        meerkat.modules.comms.post({
            url: "ajax/json/homeloan_submit.jsp",
            data: postData,
            cache: false,
            useDefaultErrorHandling: false,
            errorLevel: "fatal",
            timeout: 75e3,
            onSuccess: function onSubmitSuccess(resultData) {
                stateSubmitInProgress = false;
                if (resultData.hasOwnProperty("confirmationkey") === false) {
                    onSubmitError(false, "", "Missing confirmationkey", false, resultData);
                    return;
                }
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "trackQuoteForms",
                    object: meerkat.modules.homeloan.getTrackingFieldsObject
                });
                var confirmationId = resultData.confirmationkey;
                meerkat.modules.leavePageWarning.disable();
                window.location.href = "viewConfirmation?key=" + encodeURI(confirmationId);
            },
            onError: onSubmitError,
            onComplete: function onSubmitComplete() {
                stateSubmitInProgress = false;
            }
        });
    }
    function onSubmitError(jqXHR, textStatus, errorThrown, settings, resultData) {
        stateSubmitInProgress = false;
        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
            source: "homeloanEnquiry"
        });
        meerkat.modules.errorHandling.error({
            message: "An error occurred when attempting to submit your enquiry.",
            page: "homeloanEnquiry.js:submitEnquiry()",
            errorLevel: "warning",
            description: "Ajax request to homeloan/opportunity/apply.json failed to return a valid response: " + errorThrown,
            data: resultData
        });
    }
    meerkat.modules.register("homeloanEnquiry", {
        initHomeloanEnquiry: initHomeloanEnquiry
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $dropdown, $modal, $component, filterValues = {}, joinDelimiter = ",", modalId = false, filterHtml, $filtersContainer, isIE8 = false;
    var events = {
        homeloanFilters: {
            CHANGED: "HOMELOAN_FILTERS_CHANGED"
        }
    }, moduleEvents = events.homeloanFilters;
    function updateFilters() {
        readFilterValues("value");
    }
    function readFilterValues(propertyNameToStoreValue, readOnlyFromFilters) {
        var propName = propertyNameToStoreValue || "value";
        $component.find("[data-filter-type]").each(function() {
            var $this = $(this), filterType = $this.attr("data-filter-type"), id = $this.attr("id"), value = "";
            if (typeof id === "undefined") return;
            if ("radio" === filterType) {
                value = $this.find(":checked").val() || "";
                if (readOnlyFromFilters !== true) {
                    if (id == "filter-interest-rate-type") {
                        $("#homeloan_filter_loanDetails_interestRate_P").prop("checked", $("#homeloan_loanDetails_interestRate_P").is(":checked"));
                        $("#homeloan_filter_loanDetails_interestRate_I").prop("checked", $("#homeloan_loanDetails_interestRate_I").is(":checked"));
                        $("input[name=homeloan_filter_loanDetails_interestRate]:checked").change();
                        value = $("input[name=homeloan_filter_loanDetails_interestRate]:checked").val();
                    } else if (id == "filter-repaymentFrequency") {
                        $("#homeloan_filter_results_repaymentFrequency_weekly").prop("checked", $("#homeloan_results_frequency_weekly").val() === "Y");
                        $("#homeloan_filter_results_repaymentFrequency_fortnightly").prop("checked", $("#homeloan_results_frequency_fortnightly").val() === "Y");
                        $("#homeloan_filter_results_repaymentFrequency_monthly").prop("checked", $("#homeloan_results_frequency_monthly").val() === "Y");
                        $("input[name=homeloan_filter_results_repaymentFrequency]:checked").change();
                        value = $("input[name=homeloan_filter_results_repaymentFrequency]:checked").val();
                    }
                }
            }
            if ("select" === filterType) {
                value = $this.find(":selected").val() || "";
                if (readOnlyFromFilters !== true) {
                    if (id == "filter-loan-term") {
                        value = $("#homeloan_results_loanTerm").val();
                    }
                }
            }
            if ("checkbox" === filterType) {
                if (readOnlyFromFilters !== true) {
                    if (id == "filter-loan-type") {
                        $("#homeloan_filter_loanDetails_productFixed").prop("checked", $("#homeloan_loanDetails_productFixed").prop("checked")).change();
                        $("#homeloan_filter_loanDetails_productVariable").prop("checked", $("#homeloan_loanDetails_productVariable").prop("checked")).change();
                        $("#homeloan_filter_loanDetails_productLineOfCredit").prop("checked", $("#homeloan_loanDetails_productLineOfCredit").val() === "Y").change();
                        $("#homeloan_filter_loanDetails_productLowIntroductoryRate").prop("checked", $("#homeloan_loanDetails_productLowIntroductoryRate").val() === "Y").change();
                    } else if (id == "filter-fees") {
                        $("#homeloan_filter_fees_noApplication").prop("checked", $("#homeloan_fees_noApplication").val() === "Y").change();
                        $("#homeloan_filter_fees_noOngoing").prop("checked", $("#homeloan_fees_noOngoing").val() === "Y").change();
                    } else if (id == "filter-features") {
                        $("#homeloan_filter_features_redraw").prop("checked", $("#homeloan_features_redraw").val() === "Y").change();
                        $("#homeloan_filter_features_offset").prop("checked", $("#homeloan_features_offset").val() === "Y").change();
                        $("#homeloan_filter_features_bpay").prop("checked", $("#homeloan_features_bpay").val() === "Y").change();
                        $("#homeloan_filter_features_onlineBanking").prop("checked", $("#homeloan_features_onlineBanking").val() === "Y").change();
                        $("#homeloan_filter_features_extraRepayments").prop("checked", $("#homeloan_features_extraRepayments").val() === "Y").change();
                    }
                }
                var values = [];
                values = $this.find("[type=checkbox]:checked").map(function() {
                    return this.value;
                });
                value = values.get().join(joinDelimiter);
            }
            if ("text" === filterType) {
                if (readOnlyFromFilters !== true) {
                    if (id == "filter-loan-amount") {
                        value = $("#homeloan_loanDetails_loanAmountentry").val();
                        $this.find("input[type=text]").val(value);
                    }
                } else {
                    value = $this.find("input[type=text]").val();
                }
            }
            if (!filterValues.hasOwnProperty(id)) filterValues[id] = {};
            filterValues[id].type = filterType;
            filterValues[id][propName] = value;
        });
        log("readFilterValues", readOnlyFromFilters === true ? "readOnlyFromFilters" : "!readOnlyFromFilters", _.extend({}, filterValues));
    }
    function revertSelections() {
        var value, filterId;
        for (filterId in filterValues) {
            if (filterValues.hasOwnProperty(filterId)) {
                value = filterValues[filterId].value;
                switch (filterValues[filterId].type) {
                  case "radio":
                    if (value === "") {
                        $component.find("#" + filterId + " input").prop("checked", false).change();
                    } else {
                        $component.find("#" + filterId + ' input[value="' + value + '"]').prop("checked", true).change();
                    }
                    break;

                  case "select":
                    $component.find("#" + filterId + " select").val(value);
                    break;

                  case "text":
                    $component.find("#" + filterId + " input").val(value);
                    break;

                  case "checkbox":
                    $component.find("#" + filterId + " input[type=checkbox]").prop("checked", false);
                    if (value.length) {
                        var values = value.split(",");
                        for (var i = 0; i < values.length; i++) {
                            switch (filterId) {
                              case "filter-loan-type":
                                $("#homeloan_filter_loanDetails_product" + values[i]).prop("checked", true);
                                break;

                              case "filter-features":
                                $("#homeloan_filter_features_" + values[i]).prop("checked", true);
                                break;

                              case "filter-fees":
                                $("#homeloan_filter_fees_" + values[i]).prop("checked", true);
                                break;
                            }
                        }
                    }
                    break;
                }
            }
        }
    }
    function saveSelection() {
        $component.addClass("is-saved");
        _.defer(function() {
            var valueOld, valueNew, filterId, needToFetchFromServer = false;
            readFilterValues("valueNew", true);
            for (filterId in filterValues) {
                if (filterValues.hasOwnProperty(filterId)) {
                    if (filterValues[filterId].value !== filterValues[filterId].valueNew) {
                        if ($("#" + filterId).attr("data-filter-serverside")) {
                            needToFetchFromServer = true;
                            break;
                        }
                    }
                }
            }
            for (filterId in filterValues) {
                if (filterValues.hasOwnProperty(filterId)) {
                    valueOld = filterValues[filterId].value;
                    valueNew = filterValues[filterId].valueNew;
                    if (valueOld !== valueNew) {
                        var selected, j;
                        switch (filterId) {
                          case "filter-loan-amount":
                            var $field = $("#homeloan_loanDetails_loanAmountentry");
                            $field.val(valueNew);
                            $("#homeloan_loanDetails_loanAmount").val($field.asNumber());
                            break;

                          case "filter-loan-term":
                            $("#homeloan_results_loanTerm").val(valueNew);
                            break;

                          case "filter-interest-rate-type":
                            $("input[name=homeloan_loanDetails_interestRate]").prop("checked", false).change();
                            $("#homeloan_loanDetails_interestRate_" + valueNew).prop("checked", true).change();
                            break;

                          case "filter-repaymentFrequency":
                            $("input[id^=homeloan_results_frequency_]").val("");
                            $("#homeloan_results_frequency_" + valueNew).val("Y");
                            if (valueNew !== "") {
                                Results.setFrequency(valueNew, false);
                            }
                            break;

                          case "filter-fees":
                          case "filter-features":
                            var prefix = filterId == "filter-fees" ? "fees" : "features";
                            clearCheckboxes($("input[id^=homeloan_" + prefix + "]"));
                            selected = valueNew.split(joinDelimiter);
                            if (selected.length) {
                                for (j = 0; j < selected.length; j++) {
                                    $("#homeloan_" + prefix + "_" + selected[j]).val("Y");
                                }
                            }
                            break;

                          case "filter-loan-type":
                            clearCheckboxes($("input[id^=homeloan_loanDetails_product]"));
                            selected = valueNew.split(joinDelimiter);
                            if (selected.length) {
                                for (j = 0; j < selected.length; j++) {
                                    var $el = $("#homeloan_loanDetails_product" + selected[j]);
                                    if ($el.attr("type") == "checkbox") {
                                        $el.prop("checked", true);
                                    } else {
                                        $el.val("Y");
                                    }
                                }
                            }
                            break;
                        }
                    }
                }
            }
            close();
            meerkat.messaging.publish(moduleEvents.CHANGED);
            if (needToFetchFromServer) {
                _.defer(function() {
                    meerkat.modules.journeyEngine.loadingShow("...updating your quotes...", true);
                    _.delay(function() {
                        meerkat.modules.homeloanResults.get();
                    }, 100);
                });
            } else {
                Results.applyFiltersAndSorts();
            }
        });
    }
    function open() {
        if ($dropdown.hasClass("open") === false) {
            $dropdown.find(".activator").dropdown("toggle");
        }
    }
    function afterOpen() {
        $component = $(".filters-component");
        $component.on("click.filters", ".btn-save", saveSelection).on("click.filters", ".btn-cancel", close);
        $("#homeloan_filter_loanDetails_loanAmount").each(meerkat.modules.currencyField.initSingleCurrencyField);
        if (isIE8) {
            $component.on("change.checkedForIE", ".checkbox input, .compareCheckbox input", function applyCheckboxClicks() {
                var $this = $(this);
                if ($this.is(":checked")) {
                    $this.addClass("checked");
                } else {
                    $this.removeClass("checked");
                }
            });
            $component.find(".checkbox input").change();
            $component.on("focus", "#homeloan_filter_results_loanTerm", function() {
                var el = $(this);
                el.data("width", el.width());
                el.width("auto");
                el.data("width-auto", $(this).width());
                if (el.data("width-auto") < el.data("width")) {
                    el.width(el.data("width"));
                } else {
                    el.width(el.data("width-auto") + 15);
                }
            }).on("blur", "#homeloan_filter_results_loanTerm", function() {
                var el = $(this);
                el.width(el.data("width"));
            });
        }
    }
    function close() {
        if ($dropdown.hasClass("open")) {
            $dropdown.find(".activator").dropdown("toggle");
        }
        if (modalId !== false) {
            meerkat.modules.navMenu.close();
            meerkat.modules.dialogs.close(modalId);
        }
    }
    function clearCheckboxes($el) {
        $el.each(function() {
            var $self = $(this);
            if ($self.attr("type") == "checkbox") {
                $self.prop("checked", false);
            } else {
                $self.val("");
            }
        });
    }
    function afterClose() {
        if ($component.hasClass("is-saved")) {
            $component.removeClass("is-saved");
        } else {
            revertSelections();
        }
        modalId = false;
        meerkat.modules.navMenu.close();
        $component.off("click.filters", ".btn-save");
        $component.off("click.filters", ".btn-cancel");
        $component.find(":checkbox").removeClass("has-error");
        $component.find(".alert").remove();
    }
    function initFilters() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "homeloan" || meerkat.site.pageAction === "confirmation") {
                return false;
            }
            isIE8 = meerkat.modules.performanceProfiling.isIE8();
            eventSubscriptions();
            applyEventListeners();
        });
    }
    function eventSubscriptions() {
        $dropdown = $("#filters-dropdown");
        $modal = $("#filters-modal");
        $filtersContainer = $("#filters-container");
        var $e = $("#filters-template");
        if ($e.length > 0) {
            templateCallback = _.template($e.html());
            filterHtml = templateCallback();
        }
        if (meerkat.modules.deviceMediaState.get() !== "xs") {
            $filtersContainer.empty().html(filterHtml);
        }
        $dropdown.on("show.bs.dropdown", function() {
            afterOpen();
            updateFilters();
        }).on("hidden.bs.dropdown", function() {
            afterClose();
        });
        $modal.on("click", function(e) {
            e.preventDefault();
            var options = {
                htmlContent: filterHtml,
                hashId: "filters",
                closeOnHashChange: true,
                leftBtn: {
                    label: "Back",
                    icon: "",
                    className: "btn-sm btn-close-dialog",
                    callback: afterClose
                },
                rightBtn: {
                    label: "Save Changes",
                    icon: "",
                    className: "btn-sm",
                    callback: saveSelection
                },
                onOpen: function() {
                    afterOpen();
                    $component.find(".btn-cancel, .btn-save").addClass("hidden");
                    updateFilters();
                }
            };
            modalId = meerkat.modules.dialogs.show(options);
        });
    }
    function applyEventListeners() {
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockFilters(obj) {
            close();
            $dropdown.children(".activator").addClass("inactive").addClass("disabled");
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockFilters(obj) {
            $dropdown.children(".activator").removeClass("inactive").removeClass("disabled");
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function filtersEnterXsState() {
            if ($dropdown.hasClass("open")) {
                meerkat.modules.homeloanFilters.close();
                meerkat.modules.navMenu.close();
            }
            $filtersContainer.empty();
        });
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function filtersLeaveXsState() {
            if (modalId !== false) {
                meerkat.modules.homeloanFilters.close();
            }
            $filtersContainer.empty().html(filterHtml);
        });
    }
    meerkat.modules.register("homeloanFilters", {
        initFilters: initFilters,
        events: events,
        open: open,
        close: close
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, $bridgingContainer = $(".bridgingContainer");
    var events = {
        homeloanMoreInfo: {}
    }, moduleEvents = events.homeloanMoreInfo;
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
            retrieveExternalCopy: retrieveExternalCopy,
            additionalTrackingData: {
                verticalFilter: meerkat.modules.homeloan.getVerticalFilter()
            }
        };
        meerkat.modules.moreInfo.initMoreInfo(options);
        eventSubscriptions();
        applyEventListeners();
    }
    function applyEventListeners() {
        $(document.body).on("click", ".btn-apply", onClickApplyNow);
    }
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
            meerkat.modules.moreInfo.setDataResult(product);
            return dfd.resolveWith(this, []).promise();
        });
    }
    function onClickApplyNow() {
        Results.model.setSelectedProduct($(".btn-apply").attr("data-productId"));
        meerkat.modules.homeloan.trackHandover();
        meerkat.modules.journeyEngine.gotoPath("next");
    }
    function onBeforeShowModal(product) {
        var settings = {
            additionalTrackingData: {
                productName: product.lenderProductName
            }
        };
        meerkat.modules.moreInfo.updateSettings(settings);
    }
    function trackProductView() {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteForms",
            object: _.bind(meerkat.modules.homeloan.getTrackingFieldsObject, this, true)
        });
    }
    meerkat.modules.register("homeloanMoreInfo", {
        initMoreInfo: initMoreInfo,
        events: events,
        runDisplayMethod: runDisplayMethod
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, supertagEventMode = "Load";
    var events = {
        RESULTS_ERROR: "RESULTS_ERROR",
        RESULTS_REMAINING_PRODUCTS: "HOMELOAN_RESULTS_REMAINING_PRODUCTS"
    };
    var $component;
    var previousBreakpoint;
    var best_price_count = 5;
    var needToBuildFeatures = false;
    function initPage() {
        initResults();
        Features.init();
        meerkat.modules.compare.initCompare({
            callbacks: {
                switchMode: function(mode) {
                    switch (mode) {
                      case "features":
                        switchToFeaturesMode(true);
                        break;

                      case "price":
                        switchToPriceMode(true);
                        break;
                    }
                }
            }
        });
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
                url: "ajax/json/homeloan_results.jsp",
                runShowResultsPage: false,
                paths: {
                    results: {
                        rootElement: "responseData",
                        list: "responseData.searchResults",
                        general: "responseData.totalCount"
                    },
                    price: {
                        monthly: "monthlyRepayments"
                    },
                    rate: "intrRate",
                    availability: {
                        product: "productAvailable",
                        price: {
                            monthly: "monthly"
                        }
                    },
                    productId: "id",
                    productBrandCode: "brandCode",
                    productName: "lenderProductName"
                },
                show: {
                    topResult: false,
                    savings: false,
                    featuresCategories: false,
                    nonAvailableProducts: false,
                    unavailableCombined: true
                },
                availability: {
                    product: [ "equals", "Y" ],
                    price: [ "equals", true ]
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
                    sortBy: false
                },
                frequency: "monthly",
                animation: {
                    results: {
                        individual: {
                            active: false
                        },
                        delay: 500,
                        options: {
                            easing: "swing",
                            duration: 0
                        }
                    },
                    shuffle: {
                        active: false,
                        options: {
                            easing: "swing",
                            duration: 0
                        }
                    },
                    filter: {
                        active: false,
                        reposition: {
                            options: {
                                duration: 0,
                                easing: "swing"
                            }
                        },
                        appear: {
                            options: {
                                duration: 0
                            }
                        },
                        disappear: {
                            options: {
                                duration: 0
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
                    } ]
                },
                rankings: {
                    paths: {
                        rank_productId: "id",
                        rank_premium: "monthlyRepayments"
                    },
                    filterUnavailableProducts: false
                },
                incrementTransactionId: false
            });
        } catch (e) {
            Results.onError("Sorry, an error occurred initialising page", "results.tag", "meerkat.modules.homeloanResults.initResults(); " + e.message, e);
        }
    }
    function eventSubscriptions() {
        $(document.body).on("click", ".btn-enquire-now", enquireNowClick);
        $(Results.settings.elements.resultsContainer).on("click", ".result-row", resultRowClick);
        meerkat.messaging.subscribe(meerkatEvents.affix.AFFIXED, function navbarFixed() {
            $("#resultsPage").css("margin-top", "37px");
        });
        meerkat.messaging.subscribe(meerkatEvents.affix.UNAFFIXED, function navbarUnfixed() {
            $("#resultsPage").css("margin-top", "0");
        });
        meerkat.messaging.subscribe(meerkatEvents.homeloanFilters.CHANGED, function onFilterChange(obj) {
            Results.settings.incrementTransactionId = true;
            meerkat.modules.session.poke();
        });
        meerkat.messaging.subscribe(events.RESULTS_ERROR, function resultsError() {
            _.delay(function() {
                meerkat.modules.journeyEngine.gotoPath("previous");
            }, 1e3);
        });
        meerkat.messaging.subscribe(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW, function modelUpdated() {
            Results.model.returnedProducts = massageResultsObject(Results.model.returnedProducts);
            Results.model.sortedProducts = Results.model.returnedProducts;
        });
        $(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function() {
            Features.buildHtml();
        });
        $(Results.settings.elements.resultsContainer).on("noFilteredResults", function() {
            Results.view.show();
        });
        $(Results.settings.elements.resultsContainer).on("noResults", function onResultsNone() {
            showNoResults();
        });
        $(document).on("resultsLoaded", onResultsLoaded);
        $(document).on("resultsReturned", function() {
            meerkat.modules.utilities.scrollPageTo($("header"));
            $(".morePromptContainer, .comparison-rate-disclaimer").removeClass("hidden");
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
        if (_.isArray(products) && products.length > 0 && _.isArray(products[0])) {
            products = [ {
                productAvailable: "N"
            } ];
        } else {
            _.each(products, function massageJson(result, index) {
                _.each(result, function changeProperties(value, key, list) {
                    if (value === true) {
                        result[key] = "Y";
                    } else if (value === false) {
                        result[key] = "N";
                    }
                });
                result.productAvailable = "Y";
                result.brandCode = result.lender;
                result.productId = result.id;
                result.formatted = {
                    intrRate: Number(result.intrRate).toFixed(2) + "%",
                    comparRate: Number(result.comparRate).toFixed(2) + "%",
                    appFees: meerkat.modules.currencyField.formatCurrency(result.appFees).replace("$0.00", "$0"),
                    settlFees: meerkat.modules.currencyField.formatCurrency(result.settlFees).replace("$0.00", "$0"),
                    ongoingFees: meerkat.modules.currencyField.formatCurrency(result.ongoingFees).replace("$0.00", "$0"),
                    repayments: {
                        monthly: meerkat.modules.currencyField.formatCurrency(result.monthlyRepayments, {
                            roundToDecimalPlace: 0
                        }),
                        fortnightly: meerkat.modules.currencyField.formatCurrency(result.fortnightlyRepayments).replace(".00", ""),
                        weekly: meerkat.modules.currencyField.formatCurrency(result.weeklyRepayments).replace(".00", "")
                    }
                };
                result.formatted.repayments.monthlyFull = result.formatted.repayments.monthly + " monthly";
                result.formatted.repayments.fortnightlyFull = result.formatted.repayments.fortnightly + " fortnightly";
                result.formatted.repayments.weeklyFull = result.formatted.repayments.weekly + " weekly";
                if (result.ongoingFees > 0) {
                    result.formatted.ongoingFees = result.formatted.ongoingFees + " " + result.ongoingFeesCycle;
                }
            });
        }
        return products;
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
        $("#homeloan_results_pageNumber").val("1");
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
        meerkat.modules.dialogs.show({
            htmlContent: $("#no-results-content")[0].outerHTML
        });
    }
    function publishExtraSuperTagEvents() {
        meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
            additionalData: {
                loadMoreResultsPageNumber: "1"
            },
            onAfterEventMode: "Load"
        });
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
                publishExtraSuperTagEvents();
            }
        }
    }
    function enquireNowClick(event) {
        event.preventDefault();
        var $enquireNow = $(event.target);
        if ($enquireNow.attr("data-productId")) {
            Results.setSelectedProduct($enquireNow.attr("data-productId"));
        }
        meerkat.modules.homeloan.trackHandover();
        meerkat.modules.journeyEngine.gotoPath("next", $enquireNow);
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
        Results.model.setSelectedProduct($resultrow.attr("data-productId"));
        meerkat.modules.homeloanMoreInfo.runDisplayMethod();
    }
    function init() {
        $component = $("#resultsPage");
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_RANKING_READY, publishExtraSuperTagEvents);
        meerkat.messaging.subscribe(meerkatEvents.compare.AFTER_ENTER_COMPARE_MODE, function() {
            $(".slide-feature-filters, .slide-feature-filters a").addClass("inactive disabled");
        });
        meerkat.messaging.subscribe(meerkatEvents.compare.EXIT_COMPARE, function() {
            $(".slide-feature-filters, .slide-feature-filters a").removeClass("inactive disabled");
        });
    }
    meerkat.modules.register("homeloanResults", {
        init: init,
        initPage: initPage,
        events: events,
        onReturnToPage: onReturnToPage,
        get: get,
        stopColumnWidthTracking: stopColumnWidthTracking,
        recordPreviousBreakpoint: recordPreviousBreakpoint,
        switchToPriceMode: switchToPriceMode,
        switchToFeaturesMode: switchToFeaturesMode,
        showNoResults: showNoResults,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents,
        massageResultsObject: massageResultsObject
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var $component, $activator, $pageNumber;
    function init() {
        $(document).ready(initResultsLoadMore);
    }
    function initResultsLoadMore() {
        $component = $('[data-provide="results-load-more"]');
        if ($component.length === 0) {
            return;
        }
        $pageNumber = $("#homeloan_results_pageNumber");
        $activator = $component.find(".results-load-more-activator");
        if ($activator.length === 0) {
            $activator = false;
        } else {
            $activator.on("click.resultsLoadMore", onStart);
        }
        meerkat.messaging.subscribe(meerkat.modules.homeloanResults.events.RESULTS_REMAINING_PRODUCTS, function remainingProducts(obj) {
            if (_.isNumber(obj) && obj > 0) {
                show();
            } else {
                hide();
            }
        });
    }
    function onStart() {
        meerkat.modules.loadingAnimation.showInside($component, true);
        if ($activator !== false) {
            $activator.hide();
        }
        $pageNumber.val(parseInt($pageNumber.val(), 10) + 1);
        meerkat.modules.comms.post({
            url: Results.settings.url,
            data: meerkat.modules.form.getData($(Results.settings.formSelector)),
            dataType: "json",
            cache: false,
            errorLevel: "warning"
        }).fail(onError).done(onSuccess).always(onComplete);
    }
    function onError() {
        $pageNumber.val(parseInt($pageNumber.val(), 10) - 1);
    }
    function onSuccess(json) {
        Results.model.updateTransactionIdFromResult(json);
        Results.model.triggerEventsFromResult(json);
        var newResults = Object.byString(json, Results.settings.paths.results.list);
        if (typeof newResults !== "undefined") {
            var indexIncrement = Results.model.sortedProducts.length;
            Results.model.sortedProducts = newResults;
            meerkat.modules.homeloanResults.massageResultsObject(Results.model.sortedProducts);
            var sTagProductList = {};
            _.each(newResults, function eachResult(result, index) {
                Results.model.returnedProducts.push(result);
                Results.model.filteredProducts.push(result);
                sTagProductList[indexIncrement] = {
                    productID: result.id,
                    ranking: indexIncrement,
                    productName: result.lenderProductName,
                    productBrandCode: result.brandCode,
                    available: "Y"
                };
                indexIncrement++;
            });
            meerkat.messaging.publish(meerkatEvents.resultsTracking.TRACK_QUOTE_RESULTS_LIST, {
                additionalData: {
                    products: sTagProductList,
                    loadMoreResultsPageNumber: $pageNumber.val(),
                    event: "Refresh"
                },
                onAfterEventMode: "Load"
            });
            var $overflow = $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.resultsOverflow);
            var overflowPreviousHeight = $overflow.outerHeight(true);
            var overflowNewHeight = "auto";
            Results.view.buildHtml();
            Results.model.sortedProducts = Results.model.filteredProducts;
            var countVisible = 0;
            $.each(Results.model.sortedProducts, function(index, result) {
                $(".result_" + result.id).addClass("notfiltered").attr("data-position", countVisible).attr("id", "result-row-" + index).attr("data-sort", index);
                countVisible++;
            });
            overflowNewHeight = $overflow.outerHeight(true);
            $overflow.css({
                height: overflowPreviousHeight,
                overflow: "hidden"
            });
            $overflow.animate({
                height: overflowNewHeight
            }, 2e3, function animateComplete() {
                $overflow.css("height", "auto");
            });
        }
    }
    function onComplete() {
        meerkat.modules.loadingAnimation.hide($component);
        if ($activator !== false) {
            $activator.show();
        }
    }
    function hide() {
        $component.addClass("hidden");
    }
    function show() {
        $component.removeClass("hidden");
    }
    meerkat.modules.register("homeloanResultsLoadMore", {
        init: init,
        onStart: onStart,
        onComplete: onComplete,
        hide: hide,
        show: show
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        homeloanSnapshot: {}
    }, moduleEvents = events.example;
    var product, $snapshotGoal, $productSnapshot;
    function initHomeloanSnapshot() {
        $snapshotGoal = $(".snapshotGoal");
        $productSnapshot = $(".product-snapshot");
        $("#homeloan_enquiry_contact_firstName, #homeloan_enquiry_contact_lastName").on("change", renderSnapshot);
    }
    function onEnter() {
        renderSnapshot();
        fillTemplate();
    }
    function renderSnapshot() {
        var $situation = '<p>Looking to <span data-source="#homeloan_details_goal"></span>';
        if ($("#homeloan_details_situation").val() === "E") {
            if ($("#homeloan_details_currentLoan_Y").is(":checked")) {
                $situation = $situation + " with an existing loan";
            } else {
                $situation = $situation + " with no existing loan";
            }
            $situation = $situation + ' and property worth <span data-source="#homeloan_details_assetAmountentry"></span>';
        }
        $situation = $situation + '. Looking to borrow <span data-source="#homeloan_loanDetails_loanAmountentry"></span>.';
        $snapshotGoal.html($situation);
        meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(2) .snapshot");
    }
    function fillTemplate() {
        var currentProduct = Results.getSelectedProduct();
        if (currentProduct !== false) {
            var productTemplate = $("#snapshot-template").html();
            var htmlTemplate = _.template(productTemplate);
            var htmlString = htmlTemplate(currentProduct);
            $productSnapshot.html(htmlString);
        } else {
            $productSnapshot.empty();
        }
    }
    meerkat.modules.register("homeloanSnapshot", {
        initHomeloanSnapshot: initHomeloanSnapshot,
        events: events,
        renderSnapshot: renderSnapshot,
        onEnter: onEnter
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $firstname, $surname, $email, $marketing, $iAm, $lookingTo, $currentHomeLoan, $purchasePrice, $purchasePriceHidden, $loanAmount, $amountOwing, $amountOwingHidden, $currentLoanPanel, $existingOwnerPanel, $purchasePricePanel;
    function applyEventListeners() {
        $(document.body).on("click", ".btn-view-brands", displayBrandsModal);
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
        $iAm.on("change", function() {
            var arr = [], currLookingToValue = $lookingTo.val();
            $lookingTo.val("");
            if ($iAm.val() === "E") {
                arr = [ {
                    code: "APL",
                    label: "Buy another property to live in"
                }, {
                    code: "IP",
                    label: "Buy an investment property"
                }, {
                    code: "REP",
                    label: "Renovate my existing property"
                }, {
                    code: "CD",
                    label: "Consolidate my debt"
                }, {
                    code: "CL",
                    label: "Compare better home loan options"
                } ];
                toggleView($existingOwnerPanel, true);
            } else {
                arr = [ {
                    code: "FH",
                    label: "Buy my first home"
                }, {
                    code: "IP",
                    label: "Buy an investment property"
                } ];
                toggleView($existingOwnerPanel, false);
                $amountOwing.val("");
                $amountOwingHidden.val("");
                $propertyWorth.val("");
                $propertyWorthHidden.val("");
            }
            for (var currOpts = [], opts = '<option id="homeloan_details_goal_" value="">Please choose...</option>', i = 0; i < arr.length; i++) {
                opts += '<option id="homeloan_details_goal_' + arr[i].code + '" value="' + arr[i].code + '">' + arr[i].label + "</option>";
                currOpts.push(arr[i].code);
            }
            $lookingTo.html(opts);
            if (currLookingToValue && currOpts.indexOf(currLookingToValue) != -1) {
                $lookingTo.val(currLookingToValue).change();
            }
        });
        if ($iAm.val() !== "") {
            $iAm.change();
        }
        $lookingTo.on("change", function() {
            var val = $(this).val(), currentLoan = $("#homeloan_details_currentLoan_Y").is(":checked");
            if (val == "CD" || val == "CL") {
                $amountOwing.val("");
                $amountOwingHidden.val("");
                toggleView($currentLoanPanel, false);
                toggleView($purchasePricePanel, false);
                $purchasePrice.val("");
                $purchasePriceHidden.val("");
            } else if (val === "FH" || val === "APL" || val === "IP") {
                if (currentLoan) {
                    toggleView($currentLoanPanel, true);
                }
                toggleView($purchasePricePanel, true);
            } else {
                if (currentLoan) {
                    toggleView($currentLoanPanel, true);
                }
                toggleView($purchasePricePanel, false);
                $purchasePrice.val("");
                $purchasePriceHidden.val("");
            }
        });
        $currentHomeLoan.on("change", function() {
            if ($("#homeloan_details_currentLoan_Y").is(":checked") && $lookingTo.val() != "CD" && $lookingTo.val() != "CL") {
                toggleView($currentLoanPanel, true);
            } else {
                toggleView($currentLoanPanel, false);
            }
            $amountOwing.val("");
            $amountOwingHidden.val("");
        });
        $purchasePrice.on("blur.hmlValidate", function() {
            if ($loanAmount.val().length === 0) {
                return;
            }
            _.delay(function checkValidation() {
                $loanAmount.isValid(true);
            }, 250);
        });
    }
    function toggleView($el, makeVisible) {
        if (makeVisible) {
            $el.addClass("show_Y").removeClass("show_N show_");
        } else {
            $el.addClass("show_N").removeClass("show_Y show_");
        }
    }
    function init() {
        $(document).ready(function() {
            $firstname = $("#homeloan_contact_firstName");
            $surname = $("#homeloan_contact_lastName");
            $email = $("#homeloan_contact_email");
            $marketing = $("#homeloan_contact_optIn");
            $iAm = $("#homeloan_details_situation");
            $lookingTo = $("#homeloan_details_goal");
            $currentHomeLoan = $('input:radio[name="homeloan_details_currentLoan"]');
            $purchasePrice = $("#homeloan_loanDetails_purchasePriceentry");
            $purchasePriceHidden = $("#homeloan_loanDetails_purchasePrice");
            $loanAmount = $("#homeloan_loanDetails_loanAmountentry");
            $amountOwing = $("#homeloan_details_amountOwingentry");
            $amountOwingHidden = $("#homeloan_details_amountOwing");
            $propertyWorth = $("#homeloan_details_assetAmountentry");
            $propertyWorthHidden = $("#homeloan_details_assetAmount");
            $currentLoanPanel = $("#homeloan_details_currentLoanToggleArea");
            $existingOwnerPanel = $(".homeloan_details_existingToggleArea");
            $purchasePricePanel = $(".homeloan_loanDetails_purchasePriceToggleArea");
            $firstname.removeAttr("required");
            $surname.removeAttr("required");
            $email.removeAttr("required");
            applyEventListeners();
        });
    }
    function displayBrandsModal(event) {
        var template = _.template($("#brands-template").html());
        var obj = {};
        obj.pretext = "<h2>Our Home Loan Lender Panel</h2><p>We can help you find a loan to suit your needs. With access to over 1,300 home loan products from 29 of Australia's reputable lenders, finding a tailored loan to suit your needs has never been so easy.</p>";
        var htmlContent = template(obj);
        var brands = meerkat.modules.dialogs.show({
            title: $(this).attr("title"),
            htmlContent: htmlContent,
            hashId: "brands",
            closeOnHashChange: true,
            openOnHashChange: false
        });
        return false;
    }
    meerkat.modules.register("homeloanStart", {
        init: init
    });
})(jQuery);