$.validator.addMethod('validateOkToCall', function(value, element) {
    var optin = ($("#quote_contactFieldSet input[name='quote_contact_oktocall']:checked").val() === 'Y');
    var phone = $('#quote_contact_phone').val();
    if(optin === true && _.isEmpty(phone)) {
        return false;
    }
    return true;
});

$.validator.addMethod('validateOkToCallRadio', function(value, element) {
    var $optin	= $("#quote_contactFieldSet input[name='quote_contact_oktocall']:checked");
    var noOptin = $optin.length == 0;
    var phone = $('#quote_contact_phone').val();
    if(!_.isEmpty(phone) && noOptin == true) {
        return false;
    }
    return true;
});

$.validator.addMethod('confirmLandline', function (value) {
    var strippedValue = value.replace(/[^0-9]+/g, '');
    return strippedValue == '' || isLandLine(strippedValue);
});

$.validator.addMethod('validateTelNo', function (value) {
    if (value.length == 0) return true;

    var strippedValue = value.replace(/[^0-9]/g, '');
    if (strippedValue.length == 0 && value.length > 0) {
        return false;
    }

    var phoneRegex = new RegExp('^(0[234785]{1}[0-9]{8})$');
    return phoneRegex.test(strippedValue);
});

$.validator.addMethod('validateMobile', function (value) {
    if (value.length == 0) return true;

    var valid = true;
    var strippedValue = value.replace(/[^0-9]/g, '');
    if (strippedValue.length == 0 && value.length > 0) {
        return false;
    }

    var voipsNumber = strippedValue.indexOf('0500') == 0;
    var phoneRegex = new RegExp('^(0[45]{1}[0-9]{8})$');
    if (!phoneRegex.test(strippedValue) || voipsNumber) {
        valid = false;
    }
    return valid;
});

$.validator.addMethod("requiredOneContactNumber", function(value, element) {
    var nameSuffix = element.id.split(/[_]+/);
    nameSuffix.pop();
    nameSuffix = nameSuffix.join("_");
    var mobileElement = $("#" + nameSuffix + "_mobile");
    var otherElement = $("#" + nameSuffix + "_other");
    return mobileElement.val() + otherElement.val() != '';
});

isLandLine = function(number) {
    var mobileRegex = new RegExp("^(0[45]{1})");
    var voipsNumber = number.indexOf("0500") == 0;
    return !mobileRegex.test(number) || voipsNumber;
};