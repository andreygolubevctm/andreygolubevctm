
validateAddressAgainstServer = function(name, dpIdElement, data, element) {
    var passed = false;

    /* If Safari on iPad running version 6 then need to turn off async
     as it will fail fatally if longer than 10sec */
    var aSyncOverride = false;
    if(typeof meerkat != 'undefined') {
        aSyncOverride = navigator.userAgent.match(/iPad/i) != null && meerkat.modules.performanceProfiling.isIos6() && navigator.userAgent.match(/Safari/i) != null;
    }

    $.ajax({
        url : "ajax/json/address/get_address.jsp",
        data : data,
        type : "POST",
        async : aSyncOverride,
        cache : false,
        success : function(jsonResult) {
            passed = jsonResult.foundAddress;
            if (jsonResult.foundAddress) {
                $(element).trigger("validStreetSearchAddressEnteredEvent",
                    [ name, jsonResult ]);
            }
        },
        dataType : "json",
        error : function(obj, txt) {
            passed = false;
            if( typeof meerkat !== "undefined" ){
                meerkat.modules.errorHandling.error({
                    message : "An error occurred checking the address: " + txt,
                    page : "ajax/json/address/get_address.jsp",
                    description : "An error occurred checking the address: " + txt,
                    data : data,
                    errorLevel: "silent"
                });
            } else {
                FatalErrorDialog.register({
                    message : "An error occurred checking the address: " + txt,
                    page : "ajax/json/address/get_address.jsp",
                    description : "An error occurred checking the address: " + txt,
                    data : data
                });
            }
        },
        timeout : 6000
    });
    return passed;
};


$.validator.addMethod("validAutofilllessSearch", function(value, element, name) {
    "use strict";

    // Default is to FAIL
    var valid = false;
    var fullAddressFld = $("#" + name + "_fullAddress");

    if (fullAddressFld.val() !== '') {
        valid = true;
    }

    return valid;

}, "Please select a valid address" );

$.validator.addMethod(
    "validAddress",
    function(value, element, name) {
        "use strict";

        // Default is to FAIL
        var valid = false;

        if(typeof meerkat != 'undefined') {

            var $ele = $(element);
            var $streetSearch = $("#" + name + "_streetSearch");
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
            ;
            var selectedAddress = window.selectedAddressObj[type];

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
                    var validSuburb =  suburbName != "" && suburbSelect != "";
                    if (!validSuburb) {
                        return false;
                    }
                    if(houseNo == "") {
                        houseNo = $houseNoSel.val();
                        $streetNoElement.val(houseNo);
                    }
                    if ($streetNoElement.hasClass('canBeEmpty')) {
                        $unitShopElement.valid();
                        valid = true;
                    } else if (houseNo !== '') {

                        if($streetNoElement.is(":visible")){
                            $streetNoElement.valid();
                        }

                        $ele.removeClass("error has-error");
                        valid = true;
                    }

                    if (valid && ($dpIdElement == "" || $("#" + name + "_fullAddress").val() == "")) {
                        var unitType = $unitTypeElement.val();
                        var unitNo = $unitSelElement.val();
                        if (unitNo == "") {
                            unitNo = $unitShopElement.val();
                        }

                        valid = validateAddressAgainstServer(name,
                            $dpIdElement, {
                                streetId : $streetIdElement.val(),
                                houseNo : houseNo,
                                unitNo : unitNo,
                                unitType : unitType
                            }, $ele);
                    }

                    /**
                     * Validation overrides to prevent errors being thrown on this field
                     * while we know the user is still entering data.
                     */
                    if(!valid && _.isEmpty(selectedAddress.dpId)) {
                        if( _.isNumber(selectedAddress.streetId) && selectedAddress.houseNo == '0' ) {
                            // Pass if a street has been searched and located but no house number assigned yet
                            valid = true;
                        } else if(_.isNumber(selectedAddress.streetId) && selectedAddress.hasUnits) {
                            // Check unit fields
                            if(selectedAddress.hasEmptyUnits) {
                                valid = selectedAddress.unitNo == '' && selectedAddress.unitType == '';
                            } else {
                                valid = selectedAddress.unitNo == '' || selectedAddress.unitType == '';
                            }
                        }
                    } else if (!valid && !_.isEmpty(selectedAddress.dpId) && (selectedAddress.emptyHouseNumberHasUnits || selectedAddress.emptyHouseNumber)) {
                        valid = true;
                    }
                    break;
                case "_streetNum":
                    if(isNonStd) {
                        valid = true;
                    } else if(!_.isEmpty(selectedAddress.dpId)) {
                        valid = true;
                        // If street found but no street number then pass for now
                    } else if(selectedAddress.streetId > 0 && (_.isEmpty(selectedAddress.houseNo) || selectedAddress.houseNo == '0')) {
                        valid = true;
                        // If house number enter but no unit info then pass for now
                    } else if(!_.isEmpty(selectedAddress.houseNo) && selectedAddress.hasUnits === true) {
                        if(selectedAddress.hasEmptyUnits === false && (selectedAddress.unitNo == "" || selectedAddress.unitType == "")) {
                            valid = true;
                        }
                    }
                    break;
                case "_unitShop":
                    if(isNonStd || !_.isEmpty(selectedAddress.dpId)) {
                        valid = true;
                    } else if(selectedAddress.hasEmptyUnits === false && selectedAddress.unitNo !== '' && selectedAddress.unitNo != '0') {
                        valid = true;
                    }
                    break;
                case "_unitType":
                    if(isNonStd || !_.isEmpty(selectedAddress.dpId)) {
                        valid = true;
                    } else if(selectedAddress.hasEmptyUnits === false && selectedAddress.unitType !== '' && selectedAddress.unitType != '0') {
                        valid = true;
                    }
                    break;
                case "_nonStdStreet":
                    if (!$ele.is(":visible")) {
                        return true;
                    }

                    if (value == "") {
                        return false;
                    }
                    /** Residential street cannot start with GPO or PO * */
                    if (type === 'R') {
                        // AddressUtils has been removed from ElasticSearch,
                        // so this is needed to keep validation of this on the new verticals
                        if (typeof AddressUtils != 'undefined') {
                            if (AddressUtils.isPostalBox(value)) {
                                return false;
                            }
                        }
                    }
                    $ele.trigger("customAddressEnteredEvent", [ name ]);
                    return true;
                case "_nonStd":

                    if (isNonStd) {
                        var $streetSearchEle = $("#" + name + "_streetSearch");
                        if($streetSearchEle.prop('disabled') || $streetSearchEle.is(":visible") === false){
                            return true;
                        }else{
                            $streetSearchEle.valid();
                        }
                    } else {
                        var $suburbEle = $("#" + name + "_suburb");
                        if($suburbEle.prop('disabled') || $suburbEle.is(":visible")  === false){
                            return true;
                        }else{
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
                    if( typeof $ele.validate().ctm_unhighlight === "function"){
                        $ele.validate().ctm_unhighlight($('#' + name + '_streetSearch').get(0), this.settings.errorClass, this.settings.validClass);
                    }
                }
            }
        } else {

            /* Legacy address validation for non-meerkat verticals */

            $ele = $(element);
            var streetNoElement = $("#" + name + "_streetNum");
            var unitShopElement = $("#" + name + "_unitShop");
            var dpIdElement = $("#" + name + "_dpId");

            var fldName = $ele.attr("id").substring(name.length);

            switch (fldName) {
                case "_streetSearch":

                    if ($("#" + name + "_nonStd").is(":checked")) {
                        $ele.removeClass("error has-error");
                        return true;
                    }
                    var suburbName = $("#" + name + "_suburbName").val();
                    var suburbSelect = $("#" + name + "_suburb").val();
                    var validSuburb =  suburbName != "" && suburbName != "Please select..." && suburbSelect != "";
                    if (!validSuburb) {
                        return false;
                    }
                    if (streetNoElement.hasClass('canBeEmpty')) {
                        unitShopElement.valid();
                        valid = true;
                    } else if (streetNoElement.val() != "" || $("#" + name + "_houseNoSel").val() != "") {

                        if(streetNoElement.is(":visible")){
                            streetNoElement.valid();
                        }

                        $ele.removeClass("error has-error");

                        valid = true;
                    }

                    if (valid && (dpIdElement.val() == "" || $("#" + name + "_fullAddress").val() == "")) {
                        var unitType = $("#" + name + "_unitType").val();
                        if (unitType == 'Please choose...') {
                            unitType = "";
                        }
                        var unitNo = $("#" + name + "_unitSel").val();
                        if (unitNo == "") {
                            unitNo = unitShopElement.val();
                        }
                        houseNo = streetNoElement.val();
                        if (houseNo == "") {
                            houseNo = $("#" + name + "_houseNoSel").val();
                        }
                        valid = validateAddressAgainstServer(name,
                            dpIdElement, {
                                streetId : $("#" + name + "_streetId").val(),
                                houseNo : houseNo,
                                unitNo : unitNo,
                                unitType : unitType
                            }, $ele);
                    }

                    if(unitShopElement.is(":visible") && dpIdElement.val() == "" && !unitShopElement.hasClass('canBeEmpty')) {
                        valid = valid && unitShopElement.val() != "" && unitShopElement.val() != "0";
                    }
                    break;
                case "_streetNum":
                    return true;
                case "_nonStdStreet":
                    if (!$ele.is(":visible")) {
                        return true;
                    }

                    if (value == "") {
                        return false;
                    }
                    /** Residential street cannot start with GPO or PO * */
                    if (type === 'R') {
                        if (AddressUtils.isPostalBox(value)) {
                            return false;
                        }
                    }
                    $ele.trigger("customAddressEnteredEvent", [ name ]);
                    return true;
                case "_nonStd":

                    if ($ele.is(":checked")) {
                        var $streetSearchEle = $("#" + name + "_streetSearch");
                        if($streetSearchEle.prop('disabled') || $streetSearchEle.is(":visible") === false){
                            return true;
                        }else{
                            $streetSearchEle.valid();
                        }
                    } else {
                        var $suburbEle = $("#" + name + "_suburb");
                        if($suburbEle.prop('disabled') || $suburbEle.is(":visible")  === false){
                            return true;
                        }else{
                            $suburbEle.valid();
                        }
                        $("#" + name + "_nonStdStreet").valid();
                        if (!streetNoElement.hasClass("canBeEmpty")) {
                            streetNoElement.valid();
                        }
                        unitShopElement.valid();
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
                    if( typeof $ele.validate().ctm_unhighlight === "function"){
                        $ele.validate().ctm_unhighlight($('#' + name + '_streetSearch').get(0), this.settings.errorClass, this.settings.validClass);
                    }
                }
            }
        }

        return valid;

    }, "Please enter a valid address"
);

$.validator.addMethod(
    "validSuburb",
    function(value, element, name) {
        "use strict";
        var valid = false;

        if ($("#" + name + "_nonStd").is(":checked")) {
            valid = value !== null && value !== '' && value !== 'Please select...';
        } else {
            $(element).removeClass("error has-error");
            valid = true;
        }
        return valid;
    });

$.validator.addMethod(
    "validStreetSearch",
    function(value, element, name) {
        "use strict";

        // Default is to FAIL
        var valid = false;

        var fullAddressFld = $("#" + name + "_fullAddress");

        if (fullAddressFld.val() !== '') {
            valid = true;
        }

        return valid;

    }, "Please select a valid address"
);


//
//Validates the 4 digit postcode against server records.
//
$.validator.addMethod("validatePostcode",
    function (value, element) {
        var valid = false;
        if(value.length == 4){
            valid = validatePostcodeAgainstServer(name , element , {
                postcode : value
            },this.settings.baseURL );
        }

        if(valid) {
            $(element).removeClass("error has-error");
        }
        return valid;
    },
    "Please enter a valid postcode"
);

validatePostcodeAgainstServer = function(name, dpIdElement, data, url) {
    var passed = false;
    if (url === null)
        url = '';
    $.ajax({
        url : url + "ajax/json/validation/validate_postcode.jsp",
        data : data,
        type : "POST",
        async : false,
        cache : false,
        success : function(jsonResult) {
            passed = jsonResult.isValid;

        },
        dataType : "json",
        error : function(obj, txt, errorThrown) {
            passed = true;

            if( typeof meerkat !== "undefined" ){
                meerkat.modules.errorHandling.error({
                    message : "An error occurred validating the postcode: " + txt,
                    page : "ajax/json/validation/validate_postcode.jsp",
                    description : "An error occurred validating the postcode: "
                    + txt + " " + errorThrown,
                    data : data,
                    errorLevel: "silent"
                });
            } else {
                FatalErrorDialog.register({
                    message : "An error occurred validating the postcode: " + txt,
                    page : "ajax/json/validation/validate_postcode.jsp",
                    description : "An error occurred validating the postcode: "
                    + txt,
                    data : data
                });
            }
        },
        timeout : 6000
    });
    return passed;
};

//
//Validates the if a postcode is pobox only.
//
$.validator.addMethod("checkPostBoxOnly",
    function(value, element, name) {
        var isPostBoxOnly = false;
        var fldName = $(element).attr("id").substring(name.length);
        if (fldName == "_postCode"){
            isPostBoxOnly = $(element).hasClass('postBoxOnly');
        }
        return !isPostBoxOnly;
    },
    "Please enter a valid street address. Unfortunately we cannot compare car insurance policies for vehicles parked at a PO Box address."
);