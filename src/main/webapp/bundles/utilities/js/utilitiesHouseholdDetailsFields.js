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
        $utilities_resultsDisplayed_phoneinput,
        $utilities_energy_comparison,
        $utilities_electricity_icons,
        $utilities_gas_icons;



    function initUtilitiesHouseholdDetailsFields() {
        if(meerkat.site.pageAction === "confirmation") {
            return;
        }

        $utilities_resultsDisplayed_firstName = $('#utilities_resultsDisplayed_firstName');
        $utilities_resultsDisplayed_email = $('#utilities_resultsDisplayed_email');
        $utilities_resultsDisplayed_phoneinput = $('#utilities_resultsDisplayed_phoneinput');
        $utilities_energy_comparison = $('#utilities_householdDetails_whatToCompare');
        $utilities_electricity_icons = $('.electricity-usage.hidden-lg .roundedCheckboxIcons');
        $utilities_gas_icons = $('.gas-usage.hidden-lg .roundedCheckboxIcons');

        // save a copy of the competition text
        firstname_comp_label = $utilities_resultsDisplayed_firstName.attr('data-msg-required');
        email_comp_label = $utilities_resultsDisplayed_email.attr('data-msg-required');
        phone_comp_label = $utilities_resultsDisplayed_phoneinput.attr('data-msg-required');

        $utilities_energy_comparison.find('label:nth-child(1)').addClass('energy-electricity');
        $utilities_energy_comparison.find('label:nth-child(2)').addClass('energy-gas');
        $utilities_energy_comparison.find('label:nth-child(3)').addClass('energy-combined');

        $utilities_electricity_icons.find('label:nth-child(1)').addClass('energy-people-sm');
        $utilities_electricity_icons.find('label:nth-child(2)').addClass('energy-people-md');
        $utilities_electricity_icons.find('label:nth-child(3)').addClass('energy-people-hi');

        $utilities_gas_icons.find('label:nth-child(1)').addClass('energy-people-sm');
        $utilities_gas_icons.find('label:nth-child(2)').addClass('energy-people-md');
        $utilities_gas_icons.find('label:nth-child(3)').addClass('energy-people-hi');

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

            _toggleAdditionalElectricityDetails();
            _toggleAdditionalGasDetails();

            var isIosXS = meerkat.modules.performanceProfiling.isIos() && meerkat.modules.deviceMediaState.get() == 'xs';
            if(isIosXS) {
                _wrapInOptGroup($('#utilities_householdDetails_howToEstimate'), "How would you like us to estimate how much energy you use?");
            }

            // Grab the available providers if the location field is already set
            var $locationField = $("#utilities_householdDetails_location");
            if ($locationField.length && $locationField.val().length)
                _onTypeaheadSelected(null, {value: $locationField.val()});


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



    function _registerEventListeners() {

        $(".what-to-compare, .moving-in, .recent-gas-bill, .recent-electricity-bill").on("change",function () {
            _toggleAdditionalGasDetails();
            _toggleAdditionalElectricityDetails();
        });

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
        $("#utilities_resultsDisplayed_optinPhone, #utilities_resultsDisplayed_optinMarketing").val(val);
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
        $input.removeClass('init');

        if(!json.length) {
            $input.addClass('init');
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

            Results.updateAggregatorEnvironment();

            var providersUrl = "utilities/providers/get.json";
            if (meerkat.modules.splitTest.isActive(40) || meerkat.site.isDefaultToEnergyQuote) {
                providersUrl = "spring/rest/energy/providers/get.json";
            }

            var $promise = meerkat.modules.comms.post({
                url: providersUrl,
                data: {
                    postcode: postcode,
                    environmentOverride: $("#environmentOverride").val()
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

        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method:'trackQuoteForms',
            object: meerkat.modules.utilities.getTrackingFieldsObject('LocationNoQuote')
        });
    }

    function _toggleAdditionalElectricityDetails() {
        var whatToCompare = $(".what-to-compare").find("input[type='radio']:checked").val(),
        movingIn = $(".moving-in").find("input[type='radio']:checked").val(),
        $recentElectrityBillField = $(".recent-electricity-bill"),
        recentElectricityBill = meerkat.modules.utilitiesResults.getBillClicked() && $recentElectrityBillField.find("input[type='radio']:checked").val() !== undefined ? $recentElectrityBillField.find("input[type='radio']:checked").val() : 'N'   ,

        $electricityUsageDetails = $('.electricity-details .electricity-usage'),
        $electricityAdditionalDetails = $('.electricity-details .additional-estimate-details-row'),

        $electricityUsage = $('.electricity-details .usage'),

        $gasDetails = $(".gas-details"),
        $electDetails = $(".electricity-details");

        if (whatToCompare === "E" && !_.isUndefined(movingIn)) {
            $gasDetails.hide();
            $electDetails.show();
        }
        if (whatToCompare === "EG" && !_.isUndefined(movingIn)) {
            $gasDetails.show();
            $electDetails.show();
        }

        if (movingIn === "Y") {
            $electricityUsageDetails.show();
            $electricityAdditionalDetails.hide();
            $recentElectrityBillField.hide();
            $electricityUsage.hide();

        }
        else {
            if(_.isUndefined(recentElectricityBill)) {
                meerkat.modules.utilitiesResults.getBillClicked() ? $recentElectrityBillField.show() : $recentElectrityBillField.hide();
                $electricityAdditionalDetails.hide();
                $electricityUsageDetails.hide();
                $electricityUsage.hide();
            }
            else {
                if (recentElectricityBill === "N" ) {
                    $electricityUsageDetails.show();
                    $electricityAdditionalDetails.hide();
                    meerkat.modules.utilitiesResults.getBillClicked() ? $recentElectrityBillField.show() : $recentElectrityBillField.hide();
                    $electricityUsage.hide();
                }
                else {
                    $electricityUsageDetails.hide();
                    $electricityAdditionalDetails.show();
                    meerkat.modules.utilitiesResults.getBillClicked() ? $recentElectrityBillField.show() : $recentElectrityBillField.hide();
                    _toggleElectricityMeter();
                }
            }

        }

    }

    function _toggleAdditionalGasDetails() {
        var whatToCompare = $(".what-to-compare").find("input[type='radio']:checked").val(),
        movingIn = $(".moving-in").find("input[type='radio']:checked").val(),
        $recentGasBillField = $(".recent-gas-bill"),
        recentGasBill = meerkat.modules.utilitiesResults.getBillClicked() && $recentGasBillField.find("input[type='radio']:checked").val() !== undefined ?  $recentGasBillField.find("input[type='radio']:checked").val() : 'N',

        $gasUsageDetails = $(".gas-details .gas-usage"),
        $gasAdditionalDetails = $(".gas-details .additional-estimate-details-row"),

        $electricityDetails = $('.electricity-details'),
        $gasDetails = $('.gas-details');

        if (whatToCompare == "G" && !_.isUndefined(movingIn)) {
            $electricityDetails.hide();
            $gasDetails.show();
        }
        if (whatToCompare === "EG" && !_.isUndefined(movingIn)) {
            $gasDetails.show();
            $electricityDetails.show();
        }

        if (movingIn === "Y") {
            $gasUsageDetails.show();
            $gasAdditionalDetails.hide();
            $recentGasBillField.hide();
        }
        else  {
            if(_.isUndefined(recentGasBill)) {
                meerkat.modules.utilitiesResults.getBillClicked() ? $recentGasBillField.show() : $recentGasBillField.hide();
                $gasAdditionalDetails.hide();
                $gasUsageDetails.hide();
            }
            else {
                if (recentGasBill === "N" ) {
                    $gasUsageDetails.show();
                    $gasAdditionalDetails.hide();
                    meerkat.modules.utilitiesResults.getBillClicked() ? $recentGasBillField.show() : $recentGasBillField.hide();
                }
                else {
                    $gasUsageDetails.hide();
                    $gasAdditionalDetails.show();
                    meerkat.modules.utilitiesResults.getBillClicked() ? $recentGasBillField.show() : $recentGasBillField.hide();
                }
            }

        }

    }


    function _toggleElectricityMeter() {
        var meter = $(".electricity-meter").find("input[type='radio']:checked").val();

        if(meter === 'S') {
            $(".peak-usage .control-label").html('Standard usage');
        } else {
            $(".peak-usage .control-label").html('Peak usage');
        }

        if(meter === 'T') {
            $(".off-peak-usage .control-label").html('Off-peak usage');
        } else {
            $(".off-peak-usage .control-label").html('Off-peak usage (if any)');
        }

        $(".peak-usage").toggle(meter === "S" || meter === "T" || meter === "M");
        $(".off-peak-usage").toggle(meter === "T" || meter === "M");
        $(".shoulder-usage").toggle(meter === "M");
    }

    meerkat.modules.register("utilitiesHouseholdDetailsFields", {
        init: initUtilitiesHouseholdDetailsFields,
        showErrorOccurred: showErrorOccurred
    });

})(jQuery);