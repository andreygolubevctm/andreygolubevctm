/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {
        utilities: {},
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    }, steps = null;
    function initUtilities() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "utilities") return false;
            initJourneyEngine();
            if (meerkat.site.pageAction === "confirmation") {
                return false;
            }
            meerkat.modules.utilitiesForwardPopulation.configure();
            eventDelegates();
            if (meerkat.site.pageAction === "amend" || meerkat.site.pageAction === "latest" || meerkat.site.pageAction === "load" || meerkat.site.pageAction === "start-again") {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
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
                            action: "Retrieve"
                        }
                    });
                } else {
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: "trackQuoteEvent",
                        object: {
                            action: "Start"
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
        var startStep = {
            title: "Household details",
            navigationId: "start",
            slideIndex: 0,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.utilities.getTrackingFieldsObject
            },
            onInitialise: function onStartInit(event) {
                $("#utilities_resultsDisplayed_competition_optin").trigger("change.applyValidationRules");
            },
            validation: {
                validate: true,
                customValidation: function(callback) {
                    var $options = $("#utilities_householdDetails_whatToCompare").find("input[type=radio]"), count = 0;
                    $options.each(function() {
                        if ($(this).prop("disabled")) {
                            count++;
                        }
                    });
                    var doContinue = count != 3;
                    if (!doContinue) {
                        meerkat.modules.utilitiesHouseholdDetailsFields.showErrorOccurred();
                    }
                    callback(doContinue);
                }
            }
        };
        var resultsStep = {
            title: "Choose a plan",
            navigationId: "results",
            slideIndex: 1,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.utilities.getTrackingFieldsObject
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.utilitiesResults.initPage();
                meerkat.modules.utilitiesSorting.initSorting();
                meerkat.modules.utilitiesMoreInfo.initMoreInfo();
                meerkat.modules.utilitiesSnapshot.initUtilitiesSnapshot();
            },
            onBeforeEnter: function enterResultsStep(event) {
                Results.removeSelectedProduct();
                if (event.isForward === true) {
                    meerkat.modules.resultsTracking.setResultsEventMode("Load");
                    $("#resultsPage").addClass("hidden");
                    meerkat.modules.utilitiesSorting.resetToDefaultSort();
                    meerkat.modules.utilitiesSorting.toggleColumns();
                    meerkat.modules.utilitiesSnapshot.onEnterResults();
                }
            },
            onAfterEnter: function afterEnterResults(event) {
                if (event.isForward === true) {
                    meerkat.modules.utilitiesResults.get();
                }
            },
            onAfterLeave: function(event) {}
        };
        var enquiryStep = {
            title: "Fill out your details",
            navigationId: "enquiry",
            slideIndex: 2,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.utilities.getTrackingFieldsObject
            },
            onInitialise: function() {
                meerkat.modules.utilitiesEnquirySubmit.initUtilitiesEnquirySubmit();
            },
            onBeforeEnter: function() {
                meerkat.modules.utilitiesSnapshot.onEnterEnquire();
                meerkat.modules.utilitiesEnquiryFields.setContent();
            },
            onAfterEnter: function() {
                $("#utilities_application_details_email").trigger("change");
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
            label: "Household details",
            navigationId: steps.startStep.navigationId
        }, {
            label: "Choose a plan",
            navigationId: steps.resultsStep.navigationId
        }, {
            label: "Fill out your details",
            navigationId: steps.enquiryStep.navigationId
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
            productName: product.retailerName,
            productBrandCode: product.brandCode
        }, {
            type: "A",
            productId: product.productId
        });
    }
    function getTrackingFieldsObject(special_case) {
        try {
            var marketOptIn = $("#utilities_resultsDisplayed_optinMarketing").val() === "Y" ? "Y" : "N";
            var okToCall = $("#utilities_resultsDisplayed_optinPhone").val() === "Y" ? "Y" : "N";
            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furthest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();
            var email = $("#utilities_resultsDisplayed_email").val(), postCode = $("#utilities_householdDetails_postcode").val(), state = $("#utilities_householdDetails_state").val(), actionStep = "";
            switch (current_step) {
              case 0:
                actionStep = "energy household";
                break;

              case 1:
                if (special_case === true) {
                    actionStep = "energy more info";
                } else {
                    actionStep = "energy choose";
                }
                break;

              case 2:
                actionStep = "energy your details";
                break;
            }
            var response = {
                actionStep: actionStep,
                quoteReferenceNumber: meerkat.modules.utilitiesResults.getThoughtWorldReferenceNumber() || meerkat.modules.transactionId.get(),
                email: null,
                emailID: null,
                marketOptIn: null,
                okToCall: null,
                state: null,
                postCode: null
            };
            if (furthest_step > meerkat.modules.journeyEngine.getStepIndex("start")) {
                _.extend(response, {
                    email: email,
                    state: state,
                    postCode: postCode,
                    marketOptIn: marketOptIn,
                    okToCall: okToCall
                });
            }
            return response;
        } catch (e) {
            return false;
        }
    }
    function getVerticalFilter() {
        return $(".what-to-compare").find("input[type='radio']:checked").val() || null;
    }
    meerkat.modules.register("utilities", {
        init: initUtilities,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject,
        getVerticalFilter: getVerticalFilter,
        trackHandover: trackHandover
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    function init() {
        $(document).ready(function($) {
            if (typeof meerkat.site === "undefined") {
                return;
            }
            if (meerkat.site.pageAction !== "confirmation") {
                return;
            }
            if (confirmationData.hasOwnProperty("confirmation") === false || confirmationData.confirmation.hasOwnProperty("uniquePurchaseId") === false) {
                var message = "Trying to load the confirmation page failed";
                if (confirmationData.hasOwnProperty("confirmation") && confirmationData.confirmation.hasOwnProperty("message")) {
                    message = confirmationData.confirmation.message;
                }
                meerkat.modules.errorHandling.error({
                    message: message,
                    page: "utilitiesConfirmation.js:init",
                    description: "Invalid data",
                    data: confirmationData,
                    errorLevel: "warning"
                });
            } else {
                var data = confirmationData.confirmation;
                if (!data.product) {
                    data.product = {};
                }
                fillTemplate(data);
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "completedApplication",
                    object: {
                        productID: data.product.id || null,
                        productBrandCode: data.product.retailerName || null,
                        productName: data.product.planName || null,
                        quoteReferenceNumber: data.uniquePurchaseId,
                        verticalFilter: data.hasOwnProperty("whatToCompare") ? data.whatToCompare : null,
                        transactionID: confirmationTranId || null
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

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var showEmailOptinMessage = false;
    function init() {
        _registerEventListeners();
    }
    function _registerEventListeners() {
        $(document).on("change keyup", "#utilities_application_details_email", _onEnquiryEmailChange).on("change", "#utilities_application_details_receiveInfoCheck", _onReceiveInfoCheckChange).on("change", "#utilities_application_details_postalMatch", _onChooseSamePostalAddress).on("change", "#utilities_application_details_address_postCode, #utilities_application_details_address_suburbName", _onChangeHiddenField).on("change.residentialAddress", ".elasticsearch_container_utilities_application_details_address input, .elasticsearch_container_utilities_application_details_address select", _onAddressChange);
        $("#utilities_application_details_firstName, #utilities_application_details_lastName").on("change", function() {
            meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(2) .snapshot-title");
        });
    }
    function _onChangeHiddenField(e) {
        $(e.target).valid();
    }
    function _onChooseSamePostalAddress(e) {
        _onAddressChange(e);
        $(".elasticsearch_container_utilities_application_details_postal").toggle(!$(e.target).prop("checked"));
    }
    function _onAddressChange(e) {
        if ($(e.target).attr("id") === "utilities_application_details_address_nonStd") $(".elasticsearch_container_utilities_application_details_address .error-field label").remove();
        if ($("#utilities_application_details_postalMatch").prop("checked")) {
            $(".elasticsearch_container_utilities_application_details_postal").find("input, select").each(function() {
                $(this).val("");
            });
        }
    }
    function _onReceiveInfoCheckChange(e) {
        var $element = $(e.target), setVal = $element[0].checked ? "Y" : "N";
        $("#utilities_application_thingsToKnow_receiveInfo").val(setVal);
    }
    function _onEnquiryEmailChange() {
        var startEmailVal = $("#utilities_resultsDisplayed_email").val(), enquiryEmailVal = $("#utilities_application_details_email").val(), isSame = startEmailVal === enquiryEmailVal, $rowContainer = $("#receiveInfoCheckContainer");
        if (isSame && showEmailOptinMessage) {
            showEmailOptinMessage = false;
        } else if (!isSame && !showEmailOptinMessage) {
            showEmailOptinMessage = true;
        }
        $rowContainer.toggle(showEmailOptinMessage);
    }
    function setContent() {
        _setTermsAndConditions();
        _setHiddenProductId();
        _toggleMoveInDate();
        var residentialAddressValues = _getSerializedAddressValues($(".elasticsearch_container_utilities_application_details_address")), postalAddressValues = _getSerializedAddressValues($(".elasticsearch_container_utilities_application_details_postal"));
        if (residentialAddressValues == postalAddressValues) $("#utilities_application_details_postalMatch").trigger("click");
    }
    function _getSerializedAddressValues($el) {
        return $el.find("input[type='text'], select").serialize().replace(/([a-zA-Z_]{1,})=/g, "").replace(/[&]/g, "");
    }
    function _toggleMoveInDate() {
        var isMovingIn = $("#utilities_householdDetails_movingIn").find(":checked").val() === "Y";
        $("#enquiry_move_in_date_container").toggle(isMovingIn);
    }
    function _setHiddenProductId() {
        var product = Results.getSelectedProduct();
        if (product) {
            var prefix = "#utilities_application_thingsToKnow_hidden_";
            $(prefix + "productId").val(product.productId);
            $(prefix + "retailerName").val(product.retailerName);
            $(prefix + "planName").val(product.planName);
        }
    }
    function _setTermsAndConditions() {
        var template = $("#terms-text-template").html(), product = Results.getSelectedProduct(), termsHTML = _.template(template, product, {
            variable: "data"
        });
        $("#terms-text-container").html(termsHTML);
    }
    meerkat.modules.register("utilitiesEnquiryFields", {
        init: init,
        setContent: setContent
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    };
    var $submitButton, submitXhr;
    function initUtilitiesEnquirySubmit() {
        $(document).ready(function() {
            $submitButton = $("#submit_btn");
            applyEventListeners();
        });
    }
    function applyEventListeners() {
        $submitButton.on("click", function(event) {
            $(".tt-hint").addClass("hidden");
            var valid = meerkat.modules.journeyEngine.isCurrentStepValid();
            if (valid) {
                submitEnquiry();
            }
        });
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, lockSlide);
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, unlockSlide);
    }
    function lockSlide(obj) {
        var isSameSource = typeof obj !== "undefined" && obj.source && obj.source === "utilitiesEnquiry";
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
        $(".tt-hint").removeClass("hidden");
        $submitButton.removeClass("disabled");
        meerkat.modules.loadingAnimation.hide($submitButton);
        var $slide = $("#enquiryForm");
        $slide.find(":input").prop("disabled", false);
        $slide.find(".select").removeClass("disabled");
        $slide.find(".btn-group label").removeClass("disabled");
    }
    function submitEnquiry() {
        if (submitXhr && typeof submitXhr.status === "function" && submitXhr.status() == "pending") {
            alert("This page is still being processed. Please wait.");
            return;
        }
        var postData = meerkat.modules.journeyEngine.getFormData();
        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {
            source: "utilitiesEnquiry",
            disableFields: true
        });
        submitXhr = meerkat.modules.comms.post({
            url: "ajax/json/utilities_submit.jsp",
            data: postData,
            cache: false,
            useDefaultErrorHandling: false,
            errorLevel: "fatal",
            timeout: 3e4,
            onSuccess: function onSubmitSuccess(resultData) {
                if (resultData.hasOwnProperty("confirmationkey") === false) {
                    onSubmitError(false, "", "Missing confirmationkey", false, resultData);
                    return;
                }
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: "trackQuoteForms",
                    object: meerkat.modules.utilities.getTrackingFieldsObject
                });
                var confirmationId = resultData.confirmationkey;
                meerkat.modules.leavePageWarning.disable();
                window.location.href = "viewConfirmation?key=" + encodeURI(confirmationId);
            },
            onError: onSubmitError
        });
    }
    function onSubmitError(jqXHR, textStatus, errorThrown, settings, resultData) {
        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, {
            source: "utilitiesEnquiry"
        });
        meerkat.modules.errorHandling.error({
            message: "<p>An error occurred when attempting to submit your enquiry.</p><p>Please click OK to try again, or call <strong>" + meerkat.site.content.callCentreNumber + "</strong> quoting your reference number <strong>" + meerkat.modules.utilitiesResults.getThoughtWorldReferenceNumber() + "</strong>.</p>",
            page: "utilitiesEnquirySubmit.js:submitEnquiry()",
            errorLevel: "warning",
            description: "Ajax request to " + settings.url + " failed to return a valid response: " + errorThrown,
            data: resultData
        });
    }
    meerkat.modules.register("utilitiesEnquirySubmit", {
        initUtilitiesEnquirySubmit: initUtilitiesEnquirySubmit,
        lockSlide: lockSlide
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    function init() {}
    function configure() {
        var fields = {
            name: [ {
                $field: $("#utilities_resultsDisplayed_firstName")
            }, {
                $field: $("#utilities_application_details_firstName")
            } ],
            email: [ {
                $field: $("#utilities_resultsDisplayed_email")
            }, {
                $field: $("#utilities_application_details_email")
            } ],
            moveInDate: [ {
                $field: $("#utilities_householdDetails_movingInDate"),
                $fieldInput: $("#utilities_householdDetails_movingInDate")
            }, {
                $field: $("#utilities_application_details_movingDate"),
                $fieldInput: $("#utilities_application_details_movingDate")
            } ],
            alternatePhone: [ {
                $field: $("#utilities_resultsDisplayed_phoneinput")
            }, {
                $field: $("#utilities_application_details_mobileNumberinput"),
                $fieldInput: $("#utilities_application_details_mobileNumberinput"),
                $otherField: $("#utilities_application_details_otherPhoneNumberinput"),
                $otherFieldInput: $("#utilities_application_details_otherPhoneNumberinput")
            } ]
        };
        meerkat.modules.contactDetails.configure(fields);
    }
    meerkat.modules.register("utilitiesForwardPopulation", {
        init: init,
        configure: configure
    });
})(jQuery);

(function($) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var useInitProviders, $competitionRequiredElems;
    function initUtilitiesHouseholdDetailsFields() {
        if (meerkat.site.pageAction === "confirmation") {
            return;
        }
        useInitProviders = typeof providerResults.gasProviders !== "undefined" && providerResults.gasProviders.length || typeof providerResults.electricityProviders !== "undefined" && providerResults.electricityProviders.length;
        _registerEventListeners();
        $(document).ready(function() {
            $competitionRequiredElems = $("#utilities_resultsDisplayed_phoneinput, #utilities_resultsDisplayed_phone, #utilities_resultsDisplayed_email");
            _toggleMovingInDate();
            _toggleAdditionalEstimateDetails();
            var isIosXS = meerkat.modules.performanceProfiling.isIos() && meerkat.modules.deviceMediaState.get() == "xs";
            if (isIosXS) {
                _wrapInOptGroup($("#utilities_householdDetails_howToEstimate"), "How would you like us to estimate how much energy you use?");
            }
            var $locationField = $("#utilities_householdDetails_location");
            if ($locationField.length && $locationField.val().length) _onTypeaheadSelected(null, {
                value: $locationField.val()
            });
            _registerEventSubscriptions();
        });
    }
    function _wrapInOptGroup($el, label) {
        if (!$el.is("select")) {
            return;
        }
        var presetValue = $el.val();
        $el.find("option").wrapAll('<optgroup label="' + label + '"></optgroup>').end().find("option:first").remove().end().prepend('<option value="">Please choose...</option>').val(presetValue);
    }
    function _registerEventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.READY, function() {
            $("#utilities_householdDetails_movingInDate").datepicker("setDaysOfWeekDisabled", [ 0, 6 ]);
        });
    }
    function _registerEventListeners() {
        $(".what-to-compare, .how-to-estimate").change(_toggleAdditionalEstimateDetails);
        $(".moving-in").change(_toggleMovingInDate);
        $("#utilities_privacyoptin").change(_onPrivacyOptinChange);
        $("#utilities_householdDetails_location").on("typeahead:selected", _onTypeaheadSelected);
        $("#utilities_resultsDisplayed_competition_optin").on("change.applyValidationRules", _applyCompetitionValidationRules);
        meerkat.modules.ie8SelectMenuAutoExpand.bindEvents($("#startForm"), "#utilities_householdDetails_howToEstimate");
    }
    function _applyCompetitionValidationRules(e) {
        if ($competitionRequiredElems) {
            if ($(this).prop("checked")) {
                $competitionRequiredElems.attr("required", "required");
            } else {
                $competitionRequiredElems.removeAttr("required").each(function() {
                    $(this).valid();
                });
            }
        }
    }
    function _onPrivacyOptinChange(e) {
        var $this = $(e.target), isChecked = $this[0].checked, val = isChecked ? "Y" : "N";
        $("#utilities_resultsDisplayed_optinPhone, #utilities_resultsDisplayed_optinMarketing").val(val);
    }
    function _toggleInput($input, enableInput) {
        if (!$input.length) {
            return;
        }
        if (enableInput) $input.removeAttr("disabled").closest("label").removeClass("disabled"); else $input.removeAttr("checked").attr("disabled", "disabled").closest("label").removeClass("active").addClass("disabled");
    }
    function _buildProviderList($input, json) {
        if (!json.length) {
            return;
        }
        var providerList = "";
        for (var i = 0; i < json.length; i++) {
            var provider = json[i];
            providerList += '<option value="' + provider.id + '">' + provider.name + "</option>";
        }
        $input.html(providerList);
    }
    function _setProviders(data) {
        var electricityProviders = data.electricityProviders, gasProviders = data.gasProviders;
        var $whatToCompare = $(".what-to-compare");
        _toggleInput($whatToCompare.find("input[value='E']"), electricityProviders.length);
        _toggleInput($whatToCompare.find("input[value='G']"), gasProviders.length);
        _toggleInput($whatToCompare.find("input[value='EG']"), electricityProviders.length && gasProviders.length);
        if (!electricityProviders.length && !gasProviders.length) {
            showErrorOccurred();
            return;
        }
        var $electricityProviderInput = $("#utilities_estimateDetails_usage_electricity_currentSupplier"), $gasProviderInput = $("#utilities_estimateDetails_usage_gas_currentSupplier");
        _buildProviderList($electricityProviderInput, electricityProviders);
        _buildProviderList($gasProviderInput, gasProviders);
        var electricityDefaultValue = $electricityProviderInput.data("default");
        if (electricityDefaultValue !== "" && $electricityProviderInput.find("option[value='" + electricityDefaultValue + "']").length) $electricityProviderInput.val(electricityDefaultValue);
        var gasDefaultValue = $gasProviderInput.data("default");
        if (gasDefaultValue !== "" && $gasProviderInput.find("option[value='" + gasDefaultValue + "']").length) $gasProviderInput.val(gasDefaultValue);
        if (_.isString(data.electricityTariff)) {
            $("#utilities_householdDetails_tariff").val(data.electricityTariff);
        }
    }
    function _onTypeaheadSelected(obj, datum, name) {
        if (typeof datum === "undefined" || typeof datum.value === "undefined") {
            showErrorOccurred();
            return false;
        }
        var value = $.trim(String(datum.value)), pieces = value.split(" "), state = pieces.pop(), postcode = pieces.pop(), suburb = pieces.join(" ");
        $("#utilities_householdDetails_state").val(state);
        $("#utilities_householdDetails_postcode").val(postcode);
        $("#utilities_householdDetails_suburb").val(suburb);
        if (useInitProviders) {
            _setProviders(providerResults);
            useInitProviders = false;
        } else {
            var $promise = meerkat.modules.comms.post({
                url: "utilities/providers/get.json",
                data: {
                    postcode: postcode
                },
                errorLevel: "silent"
            });
            $promise.done(function(data) {
                _setProviders(data);
            }).fail(function() {
                showErrorOccurred();
            });
        }
    }
    function _toggleMovingInDate() {
        var val = $(".moving-in").find("input[type='radio']:checked").val();
        $(".moving-in-date").toggle(val === "Y");
    }
    function showErrorOccurred() {
        meerkat.modules.dialogs.show({
            htmlContent: $("#blocked-ip-address")[0].outerHTML
        });
    }
    function _toggleAdditionalEstimateDetails() {
        var $hideableFieldsets = $(".additional-estimate-details"), $additionalEstimateDetails = $(".additional-estimate-details"), $electricityInputs = $additionalEstimateDetails.find(".electricity"), $gasInputs = $additionalEstimateDetails.find(".gas");
        var whatToCompare = $(".what-to-compare").find("input[type='radio']:checked").val(), howToEstimate = $(".how-to-estimate").val();
        if (whatToCompare && howToEstimate) {
            $hideableFieldsets.show();
            $electricityInputs.toggle(whatToCompare === "E" || whatToCompare === "EG");
            $gasInputs.toggle(whatToCompare === "G" || whatToCompare === "EG");
            $("#current-electricity-provider-field").toggle(whatToCompare === "E" || whatToCompare === "EG");
            $("#current-gas-provider-field").toggle(whatToCompare === "G" || whatToCompare === "EG");
            if (!howToEstimate) $hideableFieldsets.hide();
            var rowClass = ".additional-estimate-details-row";
            $(rowClass).hide();
            if (howToEstimate === "S") {
                $(rowClass + ".spend").show();
            } else if (howToEstimate === "U") {
                $(rowClass + ".usage").show();
            } else {
                $hideableFieldsets.hide();
            }
        } else {
            $hideableFieldsets.hide();
        }
    }
    meerkat.modules.register("utilitiesHouseholdDetailsFields", {
        init: initUtilitiesHouseholdDetailsFields,
        showErrorOccurred: showErrorOccurred
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var events = {
        utilitiesMoreInfo: {}
    }, moduleEvents = events.utilitiesMoreInfo;
    var $bridgingContainer = $(".bridgingContainer"), callbackModalId, scrollPosition, activeCallModal, callDirectTrackingFlag = true;
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
            onBeforeShowTemplate: renderInfo,
            onBeforeShowModal: renderInfo,
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
        });
    }
    function resizeSidebarOnBreakpointChange(leftContainer, rightContainer, mainContainer) {
        if (meerkat.modules.deviceMediaState.get() == "lg" || meerkat.modules.deviceMediaState.get() == "md") {
            fixSidebarHeight(leftContainer, rightContainer, mainContainer);
        }
    }
    function fixSidebarHeight(leftSelector, rightSelector, $container) {
        if (meerkat.modules.deviceMediaState.get() != "xs") {
            var $right = $(rightSelector, $container), $left = $(leftSelector, $container);
            if ($right.length) {
                $left.css("min-height", "0px");
                $right.css("min-height", "0px");
                var leftHeight = $left.outerHeight();
                var rightHeight = $right.outerHeight();
                if (leftHeight >= rightHeight) {
                    $right.css("min-height", leftHeight + "px");
                    $left.css("min-height", leftHeight + "px");
                } else {
                    $right.css("min-height", rightHeight + "px");
                    $left.css("min-height", rightHeight + "px");
                }
            }
        }
    }
    function recordCallDirect(event, product) {
        trackCallDirect(product);
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
    }
    function callActions(event, element) {
        event.preventDefault();
        event.stopPropagation();
        var $el = element;
        var $e = $("#utilities-call-modal-template");
        if ($e.length > 0) {
            templateCallback = _.template($e.html());
        }
        var obj = Results.getResultByProductId($el.attr("data-productId"));
        if (typeof obj === "undefined" || obj.available !== "Y") return;
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
                if ($el.hasClass("btn-calldirect")) {
                    recordCallDirect(event, obj);
                }
                meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
            },
            onClose: function(modalId) {
                meerkat.modules.sessionCamHelper.setMoreInfoModal();
            }
        };
        if (meerkat.modules.deviceMediaState.get() == "xs") {
            modalOptions.title = "Reference no. " + meerkat.modules.utilitiesResults.getThoughtWorldReferenceNumber();
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
        }
        fixSidebarHeight(".paragraphedContent:visible", ".sidebar-right", $el.closest(".modal.in"));
        meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
    }
    function setScrollPosition() {
        scrollPosition = $(window).scrollTop();
    }
    function onBeforeShowBridgingPage() {
        setScrollPosition();
        if (meerkat.modules.deviceMediaState.get() != "xs") {
            $(".resultsContainer").hide();
            $(".sortbar-container").addClass("hidden");
        }
    }
    function onAfterShowTemplate() {
        requestTracking();
        if (meerkat.modules.deviceMediaState.get() == "lg" || meerkat.modules.deviceMediaState.get() == "md") {
            fixSidebarHeight(".paragraphedContent", ".moreInfoRightColumn", $bridgingContainer);
        }
    }
    function onAfterHideTemplate() {
        $(".resultsContainer").show();
        $(".sortbar-container").removeClass("hidden");
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
        return meerkat.modules.comms.post({
            url: "utilities/moreinfo/get.json",
            cache: true,
            data: {
                productId: product.productId
            },
            errorLevel: "silent",
            onSuccess: function(result) {
                meerkat.modules.moreInfo.setDataResult(result);
            }
        });
    }
    function onClickApplyNow(product, applyNowCallback) {
        Results.model.setSelectedProduct($(".btn-more-info-apply").attr("data-productId"));
        meerkat.modules.utilities.trackHandover();
        meerkat.modules.journeyEngine.gotoPath("next");
    }
    function trackCallDirect(product) {
        if (callDirectTrackingFlag === true) {
            callDirectTrackingFlag = false;
            trackCallEvent("CrCallDir", product);
        }
    }
    function trackCallEvent(type, product) {
        meerkat.modules.partnerTransfer.trackHandoverEvent({
            product: product,
            type: type,
            quoteReferenceNumber: meerkat.modules.utilitiesResults.getThoughtWorldReferenceNumber() || meerkat.modules.transactionId.get(),
            productID: product.productId,
            productName: product.planName,
            productBrandCode: product.brandCode
        }, {
            type: "CD",
            productId: product.productId
        });
    }
    function trackProductView() {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteForms",
            object: _.bind(meerkat.modules.utilities.getTrackingFieldsObject, this, true)
        });
    }
    function requestTracking() {
        var settings = {
            additionalTrackingData: {
                productName: Results.getSelectedProduct().planName
            }
        };
        meerkat.modules.moreInfo.updateSettings(settings);
        trackProductView();
    }
    function renderInfo(json) {
        if (json === null || typeof json === "undefined") {
            return;
        }
        for (var key in json) {
            if (json.hasOwnProperty(key)) {
                if ($("#" + key).length) {
                    $("#" + key).html(json[key]);
                }
            }
        }
        $(".contentRow li").each(function() {
            $(this).prepend('<span class="icon icon-angle-right"></span>');
        });
        if (typeof json.termsUrl !== "undefined") {
            $(".termsUrl").attr("href", json.termsUrl);
        }
        if (typeof json.privacyPolicyUrl != "undefined") {
            $(".privacyPolicyUrl").attr("href", json.privacyPolicyUrl);
        }
    }
    function onApplySuccess(product) {}
    meerkat.modules.register("utilitiesMoreInfo", {
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
    var $component, thoughtWorldCustomerRef = "";
    function initPage() {
        initResults();
        eventSubscriptions();
    }
    function initResults() {
        try {
            Results.init({
                url: "ajax/json/utilities_quote_results.jsp",
                runShowResultsPage: false,
                paths: {
                    results: {
                        list: "results.plans",
                        general: "results.uniqueCustomerId"
                    },
                    productId: "productId",
                    productName: "planName",
                    productBrandCode: "retailerName",
                    contractPeriodValue: "contractPeriodValue",
                    totalDiscountValue: "totalDiscountValue",
                    yearlySavingsValue: "yearlySavingsValue",
                    availability: {
                        product: "productAvailable"
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
                    sortBy: "totalDiscountValue",
                    sortByMethod: meerkat.modules.utilitiesSorting.sortDiscounts,
                    sortDir: "desc"
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
        var whatToCompare = $(".what-to-compare").find("input[type='radio']:checked").val() || null;
        _.each(products, function massageJson(result, index) {
            result.productAvailable = "Y";
            result.brandCode = result.retailerName;
            result.productId = result.planId;
            if (whatToCompare == "EG") {
                result.discountElectricity = 0;
                result.discountGas = 0;
                result.discountOther = 0;
                result.totalDiscountValue = getTotalDiscount(result, result.payontimeDiscounts) + getTotalDiscount(result, result.ebillingDiscounts) + getTotalDiscount(result, result.guaranteedDiscounts) + getTotalDiscount(result, result.otherDiscounts);
            } else {
                result.totalDiscountValue = Number(result.payontimeDiscounts) + Number(result.ebillingDiscounts) + Number(result.guaranteedDiscounts) + Number(result.otherDiscounts);
            }
            result.contractPeriodValue = result.contractPeriod.indexOf("Year") != -1 ? parseInt(result.contractPeriod.replace(/[^\d]/g, ""), 10) : 0;
            result.yearlySavingsValue = typeof result.yearlySavings === "undefined" || result.yearlySavings === null ? 0 : result.yearlySavings;
            result.yearlySavingsValue = Number(result.yearlySavingsValue.toFixed(2));
        });
        return products;
    }
    function getTotalDiscount(result, value) {
        var discountAsNumber = Number(value);
        if (!isNaN(discountAsNumber)) {
            result.discountOther += discountAsNumber;
            return discountAsNumber;
        }
        var matches = value.match(/(Electricity)\s\-\s([0-9]{1,2})\%\sand\s(Gas)\s\-\s([0-9]{1,2})\%/);
        if (matches.length === 5) {
            result.discountElectricity += Number(matches[2]);
            result.discountGas += Number(matches[4]);
            var sum = result.discountElectricity + result.discountGas;
            return isNaN(sum) ? 0 : sum;
        }
        return 0;
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
        });
        $(Results.settings.elements.resultsContainer).on("noResults", function onResultsNone() {
            showNoResults();
        });
        $(document).on("generalReturned", function onGeneralReturned() {
            thoughtWorldCustomerRef = Results.getReturnedGeneral();
            $(".thoughtWorldRefNoContainer").html("Reference no. " + thoughtWorldCustomerRef);
            $("#utilities_partner_uniqueCustomerId").val(thoughtWorldCustomerRef);
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
        meerkat.modules.utilities.trackHandover();
        meerkat.modules.moreInfo.setProduct(Results.getResult("productId", $resultrow.attr("data-productId")));
        meerkat.modules.utilitiesMoreInfo.retrieveExternalCopy(Results.getSelectedProduct()).done(function() {
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
        meerkat.modules.utilitiesMoreInfo.runDisplayMethod();
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
    function showYearlySavings() {
        return $("#utilities_householdDetails_movingIn_N").prop("checked");
    }
    function getThoughtWorldReferenceNumber() {
        return thoughtWorldCustomerRef;
    }
    meerkat.modules.register("utilitiesResults", {
        init: init,
        initPage: initPage,
        get: get,
        showNoResults: showNoResults,
        publishExtraSuperTagEvents: publishExtraSuperTagEvents,
        showYearlySavings: showYearlySavings,
        getThoughtWorldReferenceNumber: getThoughtWorldReferenceNumber
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var events = {
        utilitiesSnapshot: {}
    };
    var $snapshotSituation, $productSnapshot;
    function initUtilitiesSnapshot() {
        $snapshotSituation = $(".snapshotSituation");
        $productSnapshot = $(".product-snapshot");
    }
    function onEnterEnquire() {
        renderEnquireSnapshot();
        fillEnquireTemplate();
    }
    function onEnterResults() {
        renderResultsSnapshot();
    }
    function renderResultsSnapshot() {
        var template = $("#results-summary-template").html(), data = {};
        data.postcode = "Postcode " + $("#utilities_householdDetails_location").val().match(/\d+/)[0];
        var whatToCompare = $(".what-to-compare :checked").val(), isSpendEstimate = $(".how-to-estimate").val() === "S";
        if (whatToCompare === "E" || whatToCompare === "EG") {
            if (isSpendEstimate) {
                data.electricitySpend = "$" + $("#utilities_estimateDetails_spend_electricity_amount").val() + " / " + $("#utilities_estimateDetails_spend_electricity_period").children("option").filter(":selected").text();
            } else {
                var elecPeakVal = $("#utilities_estimateDetails_usage_electricity_peak_amount").val(), elecPeakPeriod = $("#utilities_estimateDetails_usage_electricity_peak_period").children("option").filter(":selected").text(), elecOffpeakVal = $("#utilities_estimateDetails_usage_electricity_offpeak_amount").val(), elecOffpeakPeriod = $("#utilities_estimateDetails_usage_electricity_offpeak_period").children("option").filter(":selected").text();
                data.electricityPeak = elecPeakVal + "kWh/" + elecPeakPeriod;
                data.electricityOffPeak = (elecOffpeakVal !== "" ? elecOffpeakVal : 0) + "kWh/" + elecOffpeakPeriod;
            }
        }
        if (whatToCompare === "G" || whatToCompare === "EG") {
            if (isSpendEstimate) {
                data.gasSpend = "$" + $("#utilities_estimateDetails_spend_gas_amount").val() + " / " + $("#utilities_estimateDetails_spend_gas_period").children("option").filter(":selected").text();
            } else {
                var gasPeakVal = $("#utilities_estimateDetails_usage_gas_peak_amount").val(), gasPeakPeriod = $("#utilities_estimateDetails_usage_gas_peak_period").children("option").filter(":selected").text(), gasOffpeakVal = $("#utilities_estimateDetails_usage_gas_offpeak_amount").val(), gasOffpeakPeriod = $("#utilities_estimateDetails_usage_gas_offpeak_period").children("option").filter(":selected").text();
                data.gasPeak = gasPeakVal + "MJ/" + gasPeakPeriod;
                data.gasOffPeak = (gasOffpeakVal !== "" ? gasOffpeakVal : 0) + "MJ/" + gasOffpeakPeriod;
            }
        }
        data.isSpendEstimate = isSpendEstimate;
        data.segmentClass = isSpendEstimate ? "spend" : "usage";
        var html = _.template(template, data, {
            variable: "data"
        });
        $("#results-summary-container").html(html);
        return html;
    }
    function renderEnquireSnapshot() {
        $snapshotSituation.html(renderResultsSnapshot());
        meerkat.modules.contentPopulation.render(".journeyEngineSlide:eq(2) .snapshot");
    }
    function fillEnquireTemplate() {
        var currentProduct = Results.getSelectedProduct();
        if (currentProduct !== false) {
            var productTemplate = $("#enquire-snapshot-template").html();
            var htmlTemplate = _.template(productTemplate);
            var htmlString = htmlTemplate(currentProduct);
            $productSnapshot.html(htmlString);
        } else {
            $productSnapshot.empty();
        }
    }
    meerkat.modules.register("utilitiesSnapshot", {
        initUtilitiesSnapshot: initUtilitiesSnapshot,
        events: events,
        onEnterEnquire: onEnterEnquire,
        onEnterResults: onEnterResults
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, error = meerkat.logging.error, $sortElements, defaultSortStates = {
        contractPeriodValue: "asc",
        totalDiscountValue: "desc",
        yearlySavingsValue: "desc"
    }, sortByMethods = {
        contractPeriodValue: sortContracts,
        totalDiscountValue: sortDiscounts,
        yearlySavingsValue: null
    };
    var events = {
        utilitiesSortings: {
            CHANGED: "UTILITIES_SORTING_CHANGED"
        }
    }, performanceScore;
    function setSortFromTarget($elem) {
        meerkat.modules.performanceProfiling.startTest("utilitiesSorting");
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
                meerkat.modules.utilitiesResults.publishExtraSuperTagEvents({
                    products: [],
                    recordRanking: "N"
                });
            } else {
                error("[utilitiesSorting]", "The sortBy or sortDir could not be set", setSortByReturn, setSortDirReturn);
            }
        } else {
            error("[utilitiesSorting]", "No data on sorting element");
        }
    }
    function initSorting() {
        meerkat.messaging.subscribe(meerkatEvents.RESULTS_SORTED, function sortedCallback(obj) {
            meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK);
            var time = meerkat.modules.performanceProfiling.endTest("utilitiesSorting");
            var score;
            if (time < 1200) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.HIGH;
            } else if (time < 1500 && meerkat.modules.performanceProfiling.isIE8() === false) {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.MEDIUM;
            } else {
                score = meerkat.modules.performanceProfiling.PERFORMANCE.LOW;
            }
            if (performanceScore !== meerkat.modules.performanceProfiling.PERFORMANCE.HIGH) {
                Results.setPerformanceMode(score);
            }
            performanceScore = score;
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
        $(document).ready(function utilitiesSortingInitDomready() {
            $sortElements = $("[data-sort-type]");
            if (typeof Results === "undefined") {
                meerkat.logging.exception("[utilitiesSorting]", "No Results Object Found!");
            }
        });
    }
    function resetToDefaultSort() {
        var $priceSortEl = $("[data-sort-type='totalDiscountValue']");
        var sortBy = Results.getSortBy(), price = "totalDiscountValue";
        if (sortBy != price || $priceSortEl.attr("data-sort-dir") == "asc" && sortBy == price) {
            $priceSortEl.parent("li").siblings().removeClass("active").end().addClass("active").end().attr("data-sort-dir", "desc");
            Results.setSortBy("totalDiscountValue");
            Results.setSortDir("desc");
        }
    }
    function toggleColumns() {
        var discounts = $(".colTotalDiscounts"), savings = $(".colYearlySavings"), contractPeriod = $(".colContractPeriod");
        if (meerkat.modules.utilitiesResults.showYearlySavings()) {
            savings.removeClass("hidden");
            contractPeriod.removeClass("col-sm-5 col-lg-2").addClass("col-sm-3 col-lg-1");
            discounts.removeClass("col-sm-5 col-lg-3").addClass("col-sm-4 col-lg-2");
        } else {
            savings.addClass("hidden");
            contractPeriod.removeClass("col-sm-3 col-lg-1").addClass("col-sm-5 col-lg-2");
            discounts.removeClass("col-sm-4 col-lg-2").addClass("col-sm-5 col-lg-3");
        }
    }
    function compare(valueA, valueB) {
        if (valueA < valueB) {
            return -1;
        }
        if (valueA > valueB) {
            return 1;
        }
        return 0;
    }
    function sortDiscounts(resultA, resultB) {
        var returnValue, valueA = resultA.totalDiscountValue, valueB = resultB.totalDiscountValue;
        if (isNaN(valueA)) {
            return 1;
        }
        if (isNaN(valueB)) {
            return -1;
        }
        returnValue = compare(valueA, valueB);
        if (returnValue === 0) {
            var subValueA = resultA.yearlySavingsValue, subValueB = resultB.yearlySavingsValue;
            returnValue = compare(subValueA, subValueB);
        }
        if (Results.settings.sort.sortDir == "desc") {
            returnValue *= -1;
        }
        return returnValue;
    }
    function sortContracts(resultA, resultB) {
        var returnValue, valueA = resultA.contractPeriodValue, valueB = resultB.contractPeriodValue;
        if (isNaN(valueA)) {
            return 1;
        }
        if (isNaN(valueB)) {
            return -1;
        }
        returnValue = compare(valueA, valueB);
        if (returnValue === 0) {
            var subValueA = resultA.totalDiscountValue, subValueB = resultB.totalDiscountValue;
            returnValue = compare(subValueB, subValueA);
        }
        if (returnValue === 0) {
            var subSubValueA = resultA.yearlySavingsValue, subSubValueB = resultB.yearlySavingsValue;
            returnValue = compare(subSubValueB, subSubValueA);
        }
        if (Results.settings.sort.sortDir == "desc") {
            returnValue *= -1;
        }
        return returnValue;
    }
    meerkat.modules.register("utilitiesSorting", {
        init: init,
        initSorting: initSorting,
        events: events,
        resetToDefaultSort: resetToDefaultSort,
        toggleColumns: toggleColumns,
        sortDiscounts: sortDiscounts,
        sortContracts: sortContracts
    });
})(jQuery);