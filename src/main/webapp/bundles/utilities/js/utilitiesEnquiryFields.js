;(function($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var showEmailOptinMessage = false;

    function init() {
        _registerEventListeners();
    }

    function _registerEventListeners() {
        $(document).on("change keyup", "#utilities_application_details_email", _onEnquiryEmailChange)
            .on("change", "#utilities_application_details_receiveInfoCheck", _onReceiveInfoCheckChange)
            .on("change", "#utilities_application_details_postalMatch", _onChooseSamePostalAddress)
            .on("change", "#utilities_application_details_address_postCode, #utilities_application_details_address_suburbName", _onChangeHiddenField)
            .on("change.residentialAddress", ".elasticsearch_container_utilities_application_details_address input, .elasticsearch_container_utilities_application_details_address select", _onAddressChange);
        // Re-render details in snapshot on change.
        $('#utilities_application_details_firstName, #utilities_application_details_lastName').on("change", function() {
            meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(2) .snapshot-title');
        });
    }

    /**
     * Forces validtion of hidden field on change
     * @param e
     * @private
     */
    function _onChangeHiddenField(e) {
        $(e.target).valid();
    }

    function _onChooseSamePostalAddress(e) {
        _onAddressChange(e);
        $(".elasticsearch_container_utilities_application_details_postal").toggle(!$(e.target).prop('checked'));
    }

    function _onAddressChange(e) {
        // Clear old error messages when toggling
        if($(e.target).attr("id") === "utilities_application_details_address_nonStd")
            $(".elasticsearch_container_utilities_application_details_address .error-field label").remove();

        if($("#utilities_application_details_postalMatch").prop('checked')) {
            $(".elasticsearch_container_utilities_application_details_postal").find("input, select").each(function() {
                $(this).val("");
            });
        }
    }

    function _onReceiveInfoCheckChange(e) {
        var $element = $(e.target),
            setVal = $element[0].checked ? "Y" : "N";
        $("#utilities_application_thingsToKnow_receiveInfo").val(setVal);
    }

    function _onEnquiryEmailChange() {
        var startEmailVal = $("#utilities_resultsDisplayed_email").val(),
            enquiryEmailVal = $("#utilities_application_details_email").val(),
            isSame = (startEmailVal === enquiryEmailVal),
            $rowContainer = $("#receiveInfoCheckContainer");

        if(isSame && showEmailOptinMessage) {
            // SAME: Hide new checkbox
            showEmailOptinMessage = false;
        } else if(!isSame && !showEmailOptinMessage) {
            // DIFFERENT: Show new checkbox
            showEmailOptinMessage = true;
        }

        $rowContainer.toggle(showEmailOptinMessage);
    }
    
    function setContent() {
        _setTermsAndConditions();
        _setHiddenProductId();
        _toggleMoveInDate();

        // If the residential and postal addresses are the same on entering this page, tick the postal match checkbox
        var residentialAddressValues = _getSerializedAddressValues($(".elasticsearch_container_utilities_application_details_address")),
            postalAddressValues = _getSerializedAddressValues($(".elasticsearch_container_utilities_application_details_postal"));
        if(residentialAddressValues == postalAddressValues) {
            $("#utilities_application_details_postalMatch").prop("checked", true).trigger("change");
        }
    }

    function _getSerializedAddressValues($el) {
        return $el.find("input[type='text'], select").serialize().replace(/([a-zA-Z_]{1,})=/g, "").replace(/[&]/g, "");
    }

    function _toggleMoveInDate() {
        var isMovingIn = ($("#utilities_householdDetails_movingIn").find(":checked").val() === "Y");
        $("#enquiry_move_in_date_container").toggle(isMovingIn);
    }

    /**
     * Sets the product ID, Retailer Name and Plan Name on the enquiry page to the selected
     * product. This is so we can set variables in confirmation, for completedApplication tracking.
     * @private
     */
    function _setHiddenProductId() {
        var product = Results.getSelectedProduct();
        if(product) {
            var prefix = "#utilities_application_thingsToKnow_hidden_";
            $(prefix+"productId").val(product.productId);
            $(prefix+"retailerName").val(product.retailerName);
            $(prefix+"planName").val(product.planName);
        }
    }

    /**
     * Sets the terms and conditions text
     * @private
     */
    function _setTermsAndConditions() {
        // Set the terms and conditions text
        var template = $("#terms-text-template").html(),
            product = Results.getSelectedProduct(),
            termsHTML = _.template(template, { variable: "data" });

        $("#terms-text-container").html(termsHTML(product));
    }

    meerkat.modules.register("utilitiesEnquiryFields", {
        init: init,
        setContent: setContent
    });

})(jQuery);