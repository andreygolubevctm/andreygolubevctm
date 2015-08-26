(function($) {

    var mobileRegex = new RegExp("^(0[45]{1})");
    var numericOnly = /[^0-9]+/g;

    /**
     * Validate if the field is a landline.
     */
    $.validator.addMethod('isLandLine', function (value) {
        var strippedValue = value.replace(numericOnly, '');
        return strippedValue === '' || isLandLine(strippedValue);
    });


    /**
     * Determine if a phone number is a landline
     * @param number
     * @returns {boolean}
     */
    function isLandLine(number) {
        var voipsNumber = number.indexOf("0500") === 0;
        return !mobileRegex.test(number) || voipsNumber;
    }

    /**
     * Validate telephone landline OR mobile numbers.
     */
    $.validator.addMethod('validateTelNo', function (value) {
        if (value.length === 0) return true;

        var strippedValue = value.replace(numericOnly, '');
        if (strippedValue.length === 0 && value.length > 0) {
            return false;
        }

        var phoneRegex = new RegExp('^(0[234785]{1}[0-9]{8})$');
        return phoneRegex.test(strippedValue);
    });

    /**
     * Validate mobile phone numbers.
     */
    $.validator.addMethod('validateMobile', function (value) {
        if (value.length == 0) return true;

        var valid = true;
        var strippedValue = value.replace(numericOnly, '');
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

    /**
     * Must have at least one number.
     */
    $.validator.addMethod("requireOneContactNumber", function(value, element) {
        var nameSuffix = element.id.split(/[_]+/);
        nameSuffix.pop();
        nameSuffix = nameSuffix.join("_");
        var mobileElement = $("#" + nameSuffix + "_mobile");
        var otherElement = $("#" + nameSuffix + "_other");
        return mobileElement.val() + otherElement.val() !== '';
    });

})(jQuery);






