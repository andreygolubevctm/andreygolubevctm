;(function ($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var useInitProviders,
		$competitionRequiredElems,
        providerResults;



    function initUtilitiesHouseholdDetailsFields() {
        if(meerkat.site.pageAction === "confirmation") {
            return;
        }
        if(meerkat.site.providerResults != null &&  (
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

            _toggleMovingInDate();
            _toggleAdditionalEstimateDetails();

            var isIosXS = meerkat.modules.performanceProfiling.isIos() && meerkat.modules.deviceMediaState.get() == 'xs';
            if(isIosXS) {
                _wrapInOptGroup($('#utilities_householdDetails_howToEstimate'), "How would you like us to estimate how much energy you use?");
            }

            // Grab the available providers if the location field is already set
            var $locationField = $("#utilities_householdDetails_location");
            if ($locationField.length && $locationField.val().length)
                _onTypeaheadSelected(null, {value: $locationField.val()});

            _registerEventSubscriptions();
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
        $(".what-to-compare, .how-to-estimate").change(_toggleAdditionalEstimateDetails);
        $(".moving-in").change(_toggleMovingInDate);
        $("#utilities_privacyoptin").change(_onPrivacyOptinChange);
        $("#utilities_householdDetails_location").on("typeahead:selected", _onTypeaheadSelected);
        $('#utilities_resultsDisplayed_competition_optin').on('change.applyValidationRules', _applyCompetitionValidationRules);
        meerkat.modules.ie8SelectMenuAutoExpand.bindEvents($('#startForm'), '#utilities_householdDetails_howToEstimate');
    }

    function _applyCompetitionValidationRules(e) {
        if($competitionRequiredElems) {
            if ($(this).prop('checked')) {
                $competitionRequiredElems.attr('required', 'required');
            } else {
                $competitionRequiredElems.removeAttr('required').each(function () {
                    $(this).valid();
                });
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
     * Toggles the moving in date fields depending on if a user is moving to the property
     * @private
     */
    function _toggleMovingInDate() {
        var val = $(".moving-in").find("input[type='radio']:checked").val();
        $(".moving-in-date").toggle(val === "Y");
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
        var $hideableFieldsets = $(".additional-estimate-details"),
            $additionalEstimateDetails = $(".additional-estimate-details"),
            $electricityInputs = $additionalEstimateDetails.find(".electricity"),
            $gasInputs = $additionalEstimateDetails.find(".gas");

        var whatToCompare = $(".what-to-compare").find("input[type='radio']:checked").val(),
            howToEstimate = $(".how-to-estimate").val();

        if (whatToCompare && howToEstimate) {
            $hideableFieldsets.show();

            $electricityInputs.toggle(whatToCompare === "E" || whatToCompare === "EG");
            $gasInputs.toggle(whatToCompare === "G" || whatToCompare === "EG");

            $("#current-electricity-provider-field").toggle(whatToCompare === "E" || whatToCompare === "EG");
            $("#current-gas-provider-field").toggle(whatToCompare === "G" || whatToCompare === "EG");

            if (!howToEstimate)
                $hideableFieldsets.hide();

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