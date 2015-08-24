validateAddressAgainstServer = function(name, dpIdElement, data, element) {
    var passed = false;

    /* If Safari on iPad running version 6 then need to turn off async
     as it will fail fatally if longer than 10sec */
    var aSyncOverride = false;
    if(typeof meerkat !== 'undefined') {
        aSyncOverride = navigator.userAgent.match(/iPad/i) !== null && meerkat.modules.performanceProfiling.isIos6() && navigator.userAgent.match(/Safari/i) !== null;
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
        var $ele = $(element);
        var fldName = $ele.attr("id").substring(name.length);
        var type = $("#" + name + "_type").val();

        var suburbName = "",
        suburbSelect = "",
        validSuburb =  "",
        unitType = "",
        unitNo = "",
        houseNo = "",
        $streetSearchEle, $suburbEle;

        if(typeof meerkat !== 'undefined') {

            var $streetSearch = $("#" + name + "_streetSearch");
            var $streetNoElement = $("#" + name + "_streetNum");
            var $unitShopElement = $("#" + name + "_unitShop");
            var $unitSelElement = $("#" + name + "_unitSel");
            var $unitTypeElement = $("#" + name + "_unitType");
            var $dpIdElement = $("#" + name + "_dpId");
            var $streetIdElement = $("#" + name + "_streetId");
            var $houseNoSel = $("#" + name + "_houseNoSel");
            houseNo = $streetNoElement.val();
            var isNonStd = $("#" + name + "_nonStd").is(":checked");

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
                    suburbName = $("#" + name + "_suburbName").val();
                    suburbSelect = $("#" + name + "_suburb").val();
                    validSuburb =  suburbName !== "" && suburbSelect !== "";
                    if (!validSuburb) {
                        return false;
                    }
                    if(houseNo === "") {
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

                    if (valid && ($dpIdElement === "" || $("#" + name + "_fullAddress").val() === "")) {
                        unitType = $unitTypeElement.val();
                        unitNo = $unitSelElement.val();
                        if (unitNo === "") {
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
                        if( _.isNumber(selectedAddress.streetId) && selectedAddress.houseNo === '0' ) {
                            // Pass if a street has been searched and located but no house number assigned yet
                            valid = true;
                        } else if(_.isNumber(selectedAddress.streetId) && selectedAddress.hasUnits) {
                            // Check unit fields
                            if(selectedAddress.hasEmptyUnits) {
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
                    if(isNonStd) {
                        valid = true;
                    } else if(!_.isEmpty(selectedAddress.dpId)) {
                        valid = true;
                        // If street found but no street number then pass for now
                    } else if(selectedAddress.streetId > 0 && (_.isEmpty(selectedAddress.houseNo) || selectedAddress.houseNo === '0')) {
                        valid = true;
                        // If house number enter but no unit info then pass for now
                    } else if(!_.isEmpty(selectedAddress.houseNo) && selectedAddress.hasUnits === true) {
                        if(selectedAddress.hasEmptyUnits === false && (selectedAddress.unitNo === "" || selectedAddress.unitType === "")) {
                            valid = true;
                        }
                    }
                    break;
                case "_unitShop":
                    if(isNonStd || !_.isEmpty(selectedAddress.dpId)) {
                        valid = true;
                    } else if(selectedAddress.hasEmptyUnits === false && selectedAddress.unitNo !== '' && selectedAddress.unitNo !== '0') {
                        valid = true;
                    }
                    break;
                case "_unitType":
                    if(isNonStd || !_.isEmpty(selectedAddress.dpId)) {
                        valid = true;
                    } else if(selectedAddress.hasEmptyUnits === false && selectedAddress.unitType !== '' && selectedAddress.unitType !== '0') {
                        valid = true;
                    }
                    break;
                case "_nonStdStreet":
                    if (!$ele.is(":visible")) {
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
                    $ele.trigger("customAddressEnteredEvent", [ name ]);
                    return true;
                case "_nonStd":

                    if (isNonStd) {
                        $streetSearchEle = $("#" + name + "_streetSearch");
                        if($streetSearchEle.prop('disabled') || $streetSearchEle.is(":visible") === false){
                            return true;
                        }else{
                            $streetSearchEle.valid();
                        }
                    } else {
                        $suburbEle = $("#" + name + "_suburb");
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
            var streetNoElement = $("#" + name + "_streetNum");
            var unitShopElement = $("#" + name + "_unitShop");
            var dpIdElement = $("#" + name + "_dpId");

            switch (fldName) {
                case "_streetSearch":

                    if ($("#" + name + "_nonStd").is(":checked")) {
                        $ele.removeClass("error has-error");
                        return true;
                    }
                    suburbName = $("#" + name + "_suburbName").val();
                    suburbSelect = $("#" + name + "_suburb").val();
                    validSuburb =  suburbName !== "" && suburbName !== "Please select..." && suburbSelect !== "";
                    if (!validSuburb) {
                        return false;
                    }
                    if (streetNoElement.hasClass('canBeEmpty')) {
                        unitShopElement.valid();
                        valid = true;
                    } else if (streetNoElement.val() !== "" || $("#" + name + "_houseNoSel").val() !== "") {

                        if(streetNoElement.is(":visible")){
                            streetNoElement.valid();
                        }

                        $ele.removeClass("error has-error");

                        valid = true;
                    }

                    if (valid && (dpIdElement.val() === "" || $("#" + name + "_fullAddress").val() === "")) {
                        unitType = $("#" + name + "_unitType").val();
                        if (unitType === 'Please choose...') {
                            unitType = "";
                        }
                        unitNo = $("#" + name + "_unitSel").val();
                        if (unitNo === "") {
                            unitNo = unitShopElement.val();
                        }
                        houseNo = streetNoElement.val();
                        if (houseNo === "") {
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

                    if(unitShopElement.is(":visible") && dpIdElement.val() === "" && !unitShopElement.hasClass('canBeEmpty')) {
                        valid = valid && unitShopElement.val() !== "" && unitShopElement.val() !== "0";
                    }
                    break;
                case "_streetNum":
                    return true;
                case "_nonStdStreet":
                    if (!$ele.is(":visible")) {
                        return true;
                    }

                    if (value === "") {
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
                        $streetSearchEle = $("#" + name + "_streetSearch");
                        if($streetSearchEle.prop('disabled') || $streetSearchEle.is(":visible") === false){
                            return true;
                        }else{
                            $streetSearchEle.valid();
                        }
                    } else {
                        $suburbEle = $("#" + name + "_suburb");
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
        if(value.length === 4){
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
        if (fldName === "_postCode"){
            isPostBoxOnly = $(element).hasClass('postBoxOnly');
        }
        return !isPostBoxOnly;
    },
    "Please enter a valid street address. Unfortunately we cannot compare car insurance policies for vehicles parked at a PO Box address."
);

// similar named function in healthValidation.js
$.validator.addMethod("matchStates",
    function(value, element) {
        if( $(element).val() !== utilitiesChoices._state ){
            $('#${name}_address_postCode').addClass('error');
            return false;
        } else {
            return true;
        };
    },
    "Your address does not match the original state provided"
);

// from post_code_and_state.tag
$.validator.addMethod("${name}__validateState",
    function(value, element) {
        var passed = true;

        if( String(value).length > 3 && value != ${name}__PostCodeStateHandler.current_state )
        {
            $.ajax({
                url: "ajax/json/get_state.jsp",
                data: {postCode:value},
                type: "POST",
                async: false,
                cache: true,
                success: function(jsonResult){
                    var count = Number(jsonResult[0].count);
                    var state = jsonResult[0].state;
                    ${name}__PostCodeStateHandler.current_state = state;
                    switch( count )
                    {
                        case 2:
                            if( $('#${parentName}_stateRefine').length == 0){
                                if( $('#${name}').parents('.fieldrow').length != 0 ){
                                    $('#${name}').parents('.fieldrow').after(${name}__PostCodeStateHandler.state_html);
                                } else {
                                    $('#${name}').after(${name}__PostCodeStateHandler.state_html);
                                }
                            }

                            $("#${parentName}_stateRefine").parents(".fieldrow").show('fast', function(){
                                $("#${parentName}_stateRefine").buttonset();
                            });

                            var states = state.split(", ");

                            $("#${parentName}_stateRefine_A").val(states[0]);
                            $('#${parentName}_stateRefine label:first span').empty().append(states[0]);

                            $("#${parentName}_stateRefine_B").val(states[1]);
                            $('#${parentName}_stateRefine label:last span').empty().append(states[1]);

                            $("input[name=${parentName}_stateRefine]").on('change', function(){
                                $("#${parentName}_state").val($(this).val()).trigger('change');
                            });
                            passed = true;
                            break;
                        case 1:
                            $("#${parentName}_state").val( state );
                            $("#${parentName}_stateRefine").parents(".fieldrow").hide();
                            passed = true;
                            break;
                        default:
                            $("#${parentName}_state").val("");
                            $("#${parentName}_stateRefine").parents(".fieldrow").hide();
                            passed = false;
                            break;
                    }
                    $("#${parentName}_state").trigger('change');
                },
                dataType: "json",
                error: function(obj,txt){
                    passed = false;
                },
                timeout:60000
            });
        } else {
            $("#${parentName}_stateRefine").parents(".fieldrow").hide();
            $("#${parentName}_state").val("").trigger('change');
        }

        return passed;
    },
    "Replace this message with something else"
);

$.validator.addMethod("validateLocation", function(value, element) {
    var search_match = new RegExp(/^((\s)*[\w\-]+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

    value = $.trim(String(value));
    value = value.replace("'","");

    if(value != '' && value.match(search_match)) {
        return true;
    }

    return false;
}, "");