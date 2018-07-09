(function ($) {

    var fullAddressRegex = /^((\s)*[\w\-]+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/;
    var getAddressXHR;

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
    $.validator.addMethod("validAddress", function (value, element, name) {

            // Default is to FAIL
            var valid = false;

            var $ele = $(element);
            var $streetNoElement = $("#" + name + "_streetNum");
            var $unitShopElement = $("#" + name + "_unitShop");
            var $unitSelElement = $("#" + name + "_unitSel");
            var $unitTypeElement = $("#" + name + "_unitType");
            var $dpIdElement = $("#" + name + "_dpId");
            var $streetIdElement = $("#" + name + "_streetId");
            var $houseNoSel = $("#" + name + "_houseNoSel");
            var houseNo = $streetNoElement.val();
            var isNonStd = $("#" + name + "_nonStd").is(":checked");

            var fldName = $ele.attr("id").substring(name.length);
            var type = $("#" + name + "_type").val();
            var selectedAddress = {};
            if (typeof window.selectedAddressObj != 'undefined' && typeof window.selectedAddressObj[type] != 'undefined') {
                selectedAddress = window.selectedAddressObj[type];
            } else if ($('[data-address-id="' + name + '"]').data('elasticAddress') != 'undefined') {
                selectedAddress = $('[data-address-id="' + name + '"]').data('elasticAddress').address;
            }

            switch (fldName) {
                case "_streetSearch":

                    if (isNonStd) {
                        $ele.removeClass("error has-error");
                        $ele.removeClass('has-error');
                        $ele.closest('.form-group').find('.row-content').removeClass('has-error')
                            .end().find('.error-field').remove();
                        return true;
                    }
                    var suburbName = $("#" + name + "_suburbName").val();
                    var suburbSelect = $("#" + name + "_suburb").val();
                    var validSuburb = suburbName !== "" && suburbSelect !== "";
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

                    if (valid && ($dpIdElement === "" || $("#" + name + "_fullAddress").val() === "")) {
                        var unitType = $unitTypeElement.val();
                        var unitNo = $unitSelElement.val();
                        if (unitNo === "") {
                            unitNo = $unitShopElement.val();
                        }

                        valid = validateAddressAgainstServer(name,
                            $dpIdElement, {
                                streetId: $streetIdElement.val(),
                                houseNo: houseNo,
                                unitNo: unitNo,
                                unitType: unitType
                            }, $ele);
                    }

                    /**
                     * Validation overrides to prevent errors being thrown on this field
                     * while we know the user is still entering data.
                     */
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
                case "_streetNum":
                    if (isNonStd) {
                        valid = true;
                    } else if (!_.isEmpty(selectedAddress.dpId)) {
                        valid = true;
                        // If street found but no street number then pass for now
                    } else if (selectedAddress.streetId > 0 && (_.isEmpty(selectedAddress.houseNo) || selectedAddress.houseNo === '0')) {
                        valid = true;
                        // If house number enter but no unit info then pass for now
                    } else if (!_.isEmpty(selectedAddress.houseNo) && selectedAddress.hasUnits === true) {
                        if (selectedAddress.hasEmptyUnits === false && (selectedAddress.unitNo === "" || selectedAddress.unitType === "")) {
                            valid = true;
                        }
                    }
                    break;
                case "_unitShop":
                    if (isNonStd || !_.isEmpty(selectedAddress.dpId)) {
                        valid = true;
                    } else if (selectedAddress.hasEmptyUnits === false && selectedAddress.unitNo !== '' && selectedAddress.unitNo !== '0') {
                        valid = true;
                    }
                    break;
                case "_unitType":
                    if (isNonStd || !_.isEmpty(selectedAddress.dpId)) {
                        valid = true;
                    } else if (selectedAddress.hasEmptyUnits === false && selectedAddress.unitType !== '' && selectedAddress.unitType !== '0') {
                        valid = true;
                    }
                    break;
                case "_nonStdStreet":
                    if (!$ele.is(":visible") || (type === 'P' && $unitTypeElement.val() === 'PO')) {
                        return true;
                    }

                    if (value === "") {
                        return false;
                    }
                    /** Residential street cannot start with GPO or PO * */
                    if (type === 'R') {
                        // AddressUtils has been removed from ElasticSearch,
                        // so this is needed to keep validation of this on the new verticals
                        if (typeof AddressUtils !== 'undefined') {
                            if (AddressUtils.isPostalBox(value)) {
                                return false;
                            }
                        }
                    }
                    $ele.trigger("customAddressEnteredEvent", [name]);
                    return true;
                case "_nonStd":

                    if (isNonStd) {
                        var $streetSearchEle = $("#" + name + "_streetSearch");
                        if ($streetSearchEle.prop('disabled') || $streetSearchEle.is(":visible") === false) {
                            return true;
                        } else {
                            $streetSearchEle.valid();
                        }
                    } else {
                        var $suburbEle = $("#" + name + "_suburb");
                        if ($suburbEle.prop('disabled') || $suburbEle.is(":visible") === false) {
                            return true;
                        } else {
                            $suburbEle.valid();
                        }
                        $("#" + name + "_nonStdStreet").valid();
                        if (!$streetNoElement.hasClass("canBeEmpty")) {
                            $streetNoElement.valid();
                        }
                        $unitShopElement.valid();
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
                    if (typeof $.validator.prototype.ctm_unhighlight === "function") {
                        $.validator.prototype.ctm_unhighlight($('#' + name + '_streetSearch').get(0), this.settings.errorClass, this.settings.validClass);
                    }
                }
            }


            return valid;

        }, "Please enter a valid address"
    );

    window.validateAddressAgainstServer = function (name, dpIdElement, data, element) {

        if (getAddressXHR && typeof getAddressXHR.state == 'function' && getAddressXHR.state() == 'pending') {
            return;
        }
        // If Safari on iPad running version 6 then need to turn off async
        //  as it will fail fatally if longer than 10sec.
        var aSyncOverride = navigator.userAgent.match(/iPad/i) !== null && meerkat.modules.performanceProfiling.isIos6() && navigator.userAgent.match(/Safari/i) !== null;
        getAddressXHR = meerkat.modules.comms.post({
            url: "ajax/json/address/get_address.jsp",
            data: data,
            async: aSyncOverride,
            cache: false,
            timeout: 6000,
            dataType: "json",
            errorLevel: "silent",
            useDefaultErrorHandling: false
        });

        getAddressXHR.done(function (jsonResult) {
            if (jsonResult.foundAddress) {
                $(element).trigger("validStreetSearchAddressEnteredEvent",
                    [name, jsonResult]);
            }
        }).fail(function (jqXHR, textStatus, errorThrown) {
            meerkat.modules.errorHandling.error({
                message: "An error occurred checking the address: " + errorThrown,
                page: "ajax/json/address/get_address.jsp",
                description: "An error occurred checking the address: " + textStatus + ' ' + errorThrown,
                data: data,
                errorLevel: "silent"
            });
        });

        return getAddressXHR;
    };

})(jQuery);
