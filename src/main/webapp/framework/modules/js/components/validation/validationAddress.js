(function ($) {

    var fullAddressRegex = /^((\s)*[\w\-]+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/;
    var getAddressXHR;

    // If Safari on iPad running version 6 then need to turn off async
    //  as it will fail fatally if longer than 10sec.
    // Moved out of the validate function as only needs to run once
    var aSyncOverride = navigator.userAgent.match(/iPad/i) !== null && meerkat.modules.performanceProfiling.isIos6() && navigator.userAgent.match(/Safari/i) !== null;

    $.validator.addMethod("validSuburb", function (value, element, name) {
        var valid = false;

        if ($("#" + name + "_nonStd").prop('checked')) {
            valid = value !== null && value !== '' && value !== 'Please select...';
        } else {
            $(element).removeClass("error has-error");
            valid = true;
        }

        return valid;
    }, "Please select a suburb");

    $.validator.addMethod("validStreetSearch", function (value, element, name) {
            return $("#" + name + "_fullAddress").val() !== '';
        }, "Please select a valid address"
    );

    function validateLocation(value) {

    }

    $.validator.addMethod("validateLocation", function (value, element) {
        value = $.trim(String(value)).replace("'", "");
        return value !== '' && value.match(fullAddressRegex);
    }, "Please select a valid suburb / postcode");

    /**
     * Used by autofilllessSearch to validate the separate fullAddress element input.
     */
    $.validator.addMethod("validAutofilllessSearch", function (value, element, name) {
        return $("#" + name + "_fullAddress").val() !== '';
    }, "Please select a valid address");

    /**
     * This method is utilised by both the old (health apply) and new (elastic search) address lookups.
     * Old uses streetSearch fldName, new uses validAutofilllessSearch instead.
     * However, both use the same for non standard lookups.
     */
    $.validator.addMethod("validAddress", function (value, element, xpath) {
        "use strict";

        // Default is to FAIL
        var valid = false,
            $ele = $(element),
            fldName = $ele.attr("id").substring(xpath.length),
            type = $("#" + xpath + "_type").val();

        var suburbName = "",
            suburbSelect = "",
            validSuburb = "",
            unitType = "",
            unitNo = "",
            houseNo = "",
            $streetSearchEle, $suburbEle;

        var $streetNoElement = $("#" + xpath + "_streetNum");
        var $unitShopElement = $("#" + xpath + "_unitShop");
        var $unitSelElement = $("#" + xpath + "_unitSel");
        var $unitTypeElement = $("#" + xpath + "_unitType");
        var $dpIdElement = $("#" + xpath + "_dpId");
        var $streetIdElement = $("#" + xpath + "_streetId");
        var $houseNoSel = $("#" + xpath + "_houseNoSel");
        houseNo = $streetNoElement.val();
        var isNonStd = $("#" + xpath + "_nonStd").prop('checked');

        var selectedAddress = window.selectedAddressObj[type];

        switch (fldName) {
            case "_streetSearch":

                if (isNonStd) {
                    $ele.removeClass("error has-error");
                    //$ele.removeClass('has-error');
                    $ele.closest('.form-group').find('.row-content').removeClass('has-error')
                        .end().find('.error-field').remove();
                    return true;
                }
                suburbName = $("#" + xpath + "_suburbName").val();
                suburbSelect = $("#" + xpath + "_suburb").val();
                validSuburb = suburbName !== "" && suburbSelect !== "";
                if (!validSuburb) {
                    return false;
                }
                if (houseNo === "") {
                    houseNo = $houseNoSel.val();
                    $streetNoElement.val(houseNo);
                }
                if ($streetNoElement.hasClass('canBeEmpty')) {
                    $unitShopElement.valid();
                    valid = true;
                } else if (houseNo !== '') {

                    if ($streetNoElement.is(":visible")) {
                        $streetNoElement.valid();
                    }

                    $ele.removeClass("error has-error");
                    valid = true;
                }

                if (valid && ($dpIdElement === "" || $("#" + xpath + "_fullAddress").val() === "")) {
                    unitType = $unitTypeElement.val();
                    unitNo = $unitSelElement.val();
                    if (unitNo === "") {
                        unitNo = $unitShopElement.val();
                    }
                    // This triggers a separate validation event on success, and as such wouldn't need to return a value.
                    window.validateAddressAgainstServer(xpath,
                        $dpIdElement, {
                            streetId: $streetIdElement.val(),
                            houseNo: houseNo,
                            unitNo: unitNo,
                            unitType: unitType
                        }, $ele);
                }

                // Validation overrides to prevent errors being thrown on this field
                // while we know the user is still entering data.

                if (!valid && _.isEmpty(selectedAddress.dpId)) {
                    if (_.isNumber(selectedAddress.streetId) && selectedAddress.houseNo === '0') {
                        // Pass if a street has been searched and located but no house number assigned yet
                        valid = true;
                    } else if (_.isNumber(selectedAddress.streetId) && selectedAddress.hasUnits) {
                        // Check unit fields
                        if (selectedAddress.hasEmptyUnits) {
                            valid = selectedAddress.unitNo === '' && selectedAddress.unitType === '';
                        } else {
                            valid = selectedAddress.unitNo === '' || selectedAddress.unitType === '';
                        }
                    }
                } else if (!valid && !_.isEmpty(selectedAddress.dpId) && (selectedAddress.emptyHouseNumberHasUnits || selectedAddress.emptyHouseNumber)) {
                    valid = true;
                }
                break;
            case "_nonStdStreet":
                $.validator.messages.validAddress = "Please enter the residential street";
                if (!$ele.is(":visible")) {
                    return true;
                }

                if (value === "") {
                    return false;
                }
                // Residential street cannot start with GPO or PO
                if (type === 'R') {
                    // AddressUtils has been removed from ElasticSearch,
                    // so this is needed to keep validation of this on the new verticals
                    if (typeof AddressUtils !== 'undefined') {
                        if (AddressUtils.isPostalBox(value)) {
                            return false;
                        }
                    }
                }
                $ele.trigger("customAddressEnteredEvent", [xpath]);
                return true;
            case "_nonStd":

                if (isNonStd) {
                    $streetSearchEle = $("#" + xpath + "_streetSearch");
                    if ($streetSearchEle.prop('disabled') || $streetSearchEle.is(":visible") === false) {
                        return true;
                    } else {
                        $streetSearchEle.valid();
                    }
                } else {
                    $suburbEle = $("#" + xpath + "_suburb");
                    if ($suburbEle.prop('disabled') || $suburbEle.is(":visible") === false) {
                        return true;
                    } else {
                        $suburbEle.valid();
                    }
                    $("#" + xpath + "_nonStdStreet").valid();
                    if (!$streetNoElement.hasClass("canBeEmpty")) {
                        $streetNoElement.valid();
                    }
                }
                return true;
            case "_postCode":
                return !$ele.hasClass('invalidPostcode');
            default:
                return false;
        }

        if (valid) {
            $ele.removeClass("error has-error");

            // Force an unhighlight because Validator has lost its element scope due to all the sub-valid() checks.
            if (fldName === '_streetSearch') {
                if (typeof $ele.validate().ctm_unhighlight === "function") {
                    $ele.validate().ctm_unhighlight($('#' + xpath + '_streetSearch').get(0), this.settings.errorClass, this.settings.validClass);
                }
            }
        }

        return valid;

    }, "Please enter a valid address");

    window.validateAddressAgainstServer = function (name, dpIdElement, data, element) {

        if (getAddressXHR && typeof getAddressXHR.state == 'function' && getAddressXHR.state() == 'pending') {
            return;
        }

        getAddressXHR = meerkat.modules.comms.post({
            url: "ajax/json/address/get_address.jsp",
            data: data,
            async: aSyncOverride,
            cache: false,
            timeout: 6000,
            dataType: "json",
            useDefaultErrorHandling: false
        });

        getAddressXHR.done(function (jsonResult) {
            if (jsonResult.foundAddress) {
                $(element).trigger("validStreetSearchAddressEnteredEvent",
                    [name, jsonResult]);
            }
        }).fail(function () {
            meerkat.modules.errorHandling.error({
                message: "An error occurred checking the address: " + txt,
                page: "ajax/json/address/get_address.jsp",
                description: "An error occurred checking the address: " + txt,
                data: data,
                errorLevel: "silent"
            });
        });

        return getAddressXHR;
    };

})(jQuery);
