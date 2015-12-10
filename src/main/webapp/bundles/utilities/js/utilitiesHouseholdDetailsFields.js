;(function ($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var useInitProviders,
		$competitionRequiredElems,
        providerResults,
        firstname_comp_label,
        email_comp_label,
        phone_comp_label,
        $utilities_resultsDisplayed_firstName,
        $utilities_resultsDisplayed_email,
        $utilities_resultsDisplayed_phoneinput;



    function initUtilitiesHouseholdDetailsFields() {
        if(meerkat.site.pageAction === "confirmation") {
            return;
        }

        $utilities_resultsDisplayed_firstName = $('#utilities_resultsDisplayed_firstName');
        $utilities_resultsDisplayed_email = $('#utilities_resultsDisplayed_email');
        $utilities_resultsDisplayed_phoneinput = $('#utilities_resultsDisplayed_phoneinput');

        // save a copy of the competition text
        firstname_comp_label = $utilities_resultsDisplayed_firstName.attr('data-msg-required');
        email_comp_label = $utilities_resultsDisplayed_email.attr('data-msg-required');
        phone_comp_label = $utilities_resultsDisplayed_phoneinput.attr('data-msg-required');

        if(meerkat.site.providerResults !== null &&  (
                ( typeof meerkat.site.providerResults.gasProviders !== "undefined"
                     && meerkat.site.providerResults.gasProviders.length )
            || ( typeof meerkat.site.providerResults.electricityProviders !== "undefined"
                     && meerkat.site.providerResults.electricityProviders.length )
            )) {
            providerResults = meerkat.site.providerResults;
            useInitProviders = true;
        }

        _registerEventListeners();

        $(document).ready(function () {
            $competitionRequiredElems = $('#utilities_resultsDisplayed_firstName, #utilities_resultsDisplayed_phoneinput, #utilities_resultsDisplayed_phone, #utilities_resultsDisplayed_email');

            _toggleAdditionalEstimateDetails();

            var isIosXS = meerkat.modules.performanceProfiling.isIos() && meerkat.modules.deviceMediaState.get() == 'xs';
            if(isIosXS) {
                _wrapInOptGroup($('#utilities_householdDetails_howToEstimate'), "How would you like us to estimate how much energy you use?");
            }

            // Grab the available providers if the location field is already set
            var $locationField = $("#utilities_householdDetails_location");
            if ($locationField.length && $locationField.val().length)
                _onTypeaheadSelected(null, {value: $locationField.val()});

            //_registerEventSubscriptions();
        });
    }

    /**
     * Wrap a select menus options in an optgroup and pass in a label.
     * @param $el
     * @param label
     * @private
     */
    function _wrapInOptGroup($el, label) {
        if(!$el.is('select')) {
            return;
        }
        var presetValue = $el.val();
        $el.find('option')
            .wrapAll('<optgroup label="'+label+'"></optgroup>').end()
            .find('option:first').remove().end()
            .prepend('<option value="">Please choose...</option>').val(presetValue);
    }

    function _registerEventSubscriptions() {
        // Disable weekends in our date picker
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.READY, function () {
            $("#utilities_householdDetails_movingInDate").datepicker("setDaysOfWeekDisabled", [0, 6]);
        });
    }

    function _registerEventListeners() {
        $(".what-to-compare, .moving-in, .recent-electricity-bill, .recent-gas-bill").change(_toggleAdditionalEstimateDetails);
        $("#utilities_privacyoptin").change(_onPrivacyOptinChange);
        $(".electricity-meter").change(_toggleElectricityMeter);
        $("#utilities_householdDetails_location").on("typeahead:selected", _onTypeaheadSelected);
        $('#utilities_resultsDisplayed_competition_optin').on('change.applyValidationRules', _applyCompetitionValidationRules);
    }

    function _applyCompetitionValidationRules(e) {
        if($competitionRequiredElems) {
            if ($(this).prop('checked')) {
                $utilities_resultsDisplayed_firstName.data('msgRequired', firstname_comp_label);
                $utilities_resultsDisplayed_email.data('msgRequired', email_comp_label);
                $utilities_resultsDisplayed_phoneinput.data('msgRequired', phone_comp_label);
            } else {
                $utilities_resultsDisplayed_firstName.data('msgRequired', "Please enter your name");
                $utilities_resultsDisplayed_email.data('msgRequired', "Please enter your email address");
                $utilities_resultsDisplayed_phoneinput.data('msgRequired', "Please include your phone number");
            }
        }
    }

    /**
     * Sets the user's optins for phone and marketing
     * @param e Trigger element
     * @private
     */
    function _onPrivacyOptinChange(e) {
        var $this = $(e.target),
            isChecked = $this[0].checked,
            val = isChecked ? "Y" : "N";
        $("#utilities_resultsDisplayed_optinPhone").val(val);
    }

    function _toggleInput($input, enableInput) {
        if(!$input.length) {
            return;
        }
        if (enableInput)
            $input
                .removeAttr("disabled")
                .closest("label")
                .removeClass("disabled");
        else
            $input
                .removeAttr("checked")
                .attr("disabled", "disabled")
                .closest("label")
                .removeClass("active")
                .addClass("disabled");
    }

    function _buildProviderList($input, json) {
        if(!json.length) {
            return;
        }

        var providerList = "";

        for (var i = 0; i < json.length; i++) {
            var provider = json[i];
            providerList += "<option value=\"" + provider.id + "\">" + provider.name + "</option>";
        }

        $input.html(providerList);
    }

    function _setProviders(data) {
        var electricityProviders = data.electricityProviders,
            gasProviders = data.gasProviders;

        var $whatToCompare = $(".what-to-compare");
        _toggleInput($whatToCompare.find("input[value='E']"), electricityProviders.length);
        _toggleInput($whatToCompare.find("input[value='G']"), gasProviders.length);
        _toggleInput($whatToCompare.find("input[value='EG']"), electricityProviders.length && gasProviders.length);

        if (!electricityProviders.length && !gasProviders.length) {
            showErrorOccurred();
            return;
        }

        var $electricityProviderInput = $("#utilities_estimateDetails_usage_electricity_currentSupplier"),
            $gasProviderInput = $("#utilities_estimateDetails_usage_gas_currentSupplier");

        _buildProviderList($electricityProviderInput, electricityProviders);
        _buildProviderList($gasProviderInput, gasProviders);

        var electricityDefaultValue = $electricityProviderInput.data("default");
        if(electricityDefaultValue !== "" && $electricityProviderInput.find("option[value='" + electricityDefaultValue + "']").length)
            $electricityProviderInput.val(electricityDefaultValue);

        var gasDefaultValue = $gasProviderInput.data("default");
        if(gasDefaultValue !== "" && $gasProviderInput.find("option[value='" + gasDefaultValue + "']").length)
            $gasProviderInput.val(gasDefaultValue);

        if (_.isString(data.electricityTariff)) {
            $("#utilities_householdDetails_tariff").val(data.electricityTariff);
        }
    }

    /**
     * On selection of a suburb
     * @param obj
     * @param datum
     * @param name
     * @private
     */
    function _onTypeaheadSelected(obj, datum, name) {
        if (typeof datum === 'undefined' || typeof datum.value === 'undefined') {
            showErrorOccurred();
            return false;
        }

        var value = $.trim(String(datum.value)),
            pieces = value.split(' '),
            state = pieces.pop(),
            postcode = pieces.pop(),
            suburb = pieces.join(' ');

        $('#utilities_householdDetails_state').val(state);
        $('#utilities_householdDetails_postcode').val(postcode);
        $('#utilities_householdDetails_suburb').val(suburb);

        if(useInitProviders) {
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

            $promise.done(function (data) {
                _setProviders(data);
            }).fail(function () {
                showErrorOccurred();
            });
        }
    }

    /**
     * Not actually for blocked IPs, but if their state has no providers. Kept same id for styling.
     */
    function showErrorOccurred() {
        meerkat.modules.dialogs.show({
            htmlContent: $('#blocked-ip-address')[0].outerHTML
        });
    }

    /**
     * Toggles the additional estimate details fields which show/hide depending
     * on if the user needs electricity/gas/both and they specify if they want to
     * estimate based on their spend or usage.
     * @private
     */
    function _toggleAdditionalEstimateDetails() {
        var $additionalEstimatesElectricity = $('.electricity-details .additional-estimate-details-row'),
            $additionalEstimatesGas = $('.gas-details .additional-estimate-details-row'),
            $electricityInputs = $(".electricity-details"),
            $electricityCalculations = $('.electricity-details .usage'),
            $gasInputs = $(".gas-details"),
            $electricityUsage = $(".electricity-usage"),
            $gasUsage = $(".gas-usage"),
            $movingInDate = $(".moving-in-date");

        var whatToCompare = $(".what-to-compare").find("input[type='radio']:checked").val(),
            movingIn = $(".moving-in").find("input[type='radio']:checked").val(),
            recentElectricityBill = $(".recent-electricity-bill").find("input[type='radio']:checked").val(),
            recentGasBill = $(".recent-gas-bill").find("input[type='radio']:checked").val();

        $movingInDate.toggle(movingIn === 'Y');
        $(".recent-electricity-bill").toggle(whatToCompare === "E" || whatToCompare === "EG");
        $(".recent-gas-bill").toggle(whatToCompare === "G" || whatToCompare === "EG");

        if (whatToCompare === "E" || whatToCompare === "EG") {
            if (movingIn === 'Y' || recentElectricityBill === 'N') {
                $electricityInputs.show();
                $electricityUsage.show();
                $additionalEstimatesElectricity.hide();
                $electricityCalculations.hide();
            } else if (movingIn === 'N') {

                if(recentElectricityBill === 'Y') {
                    $electricityInputs.show();
                    $electricityUsage.hide();
                    $additionalEstimatesElectricity.show();
                    _toggleElectricityMeter();
                    }
            } else {
                $electricityInputs.hide();
            }

            if (movingIn === 'N') {
                $('.recent-electricity-bill').show();
            } else {
                $('.recent-electricity-bill').hide();
                $(".electricity-meter").find("input[type='radio']").prop('checked',false);
                $(".electricity-meter").find('.active').removeClass('active');
            }

        } else {
            $electricityInputs.hide();
        }

        if (whatToCompare === "G" || whatToCompare === "EG") {
            if (movingIn === 'Y' || recentGasBill === 'N') {
                $gasInputs.show();
                $gasUsage.show();
                $additionalEstimatesGas.hide();
            } else if (movingIn === 'N') {
                $('.recent-gas-bill').show();

                if(recentGasBill === 'Y') {
                    $gasInputs.show();
                    $gasUsage.hide();
                    $additionalEstimatesGas.show();
                }
            } else {
                $gasInputs.hide();
            }

            if (movingIn === 'N') {
                $('.recent-gas-bill').show();
            } else {
                $('.recent-gas-bill').hide();
            }
        } else {
            $gasInputs.hide();
        }
    }

    function _toggleElectricityMeter() {
        var meter = $(".electricity-meter").find("input[type='radio']:checked").val();

        $(".standard-usage").toggle(meter === "S");
        $(".peak-usage").toggle(meter === "T" || meter === "M");
        $(".controlled-usage").toggle(meter === "T");
        $(".off-peak-usage").toggle(meter === "M");
        $(".shoulder-usage").toggle(meter === "M");
    }

    meerkat.modules.register("utilitiesHouseholdDetailsFields", {
        init: initUtilitiesHouseholdDetailsFields,
        showErrorOccurred: showErrorOccurred
    });

})(jQuery);