(function($) {

    var mobileRegex = new RegExp("^(0[45]{1})");
    var numericOnly = /[^0-9]+/g;
    var phoneAllowedCharacters = /[^0-9\(\)+]/g;

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
     * Format the phone number so it is in the format 04xx xxx xxx or (0x) xxxx xxxx
     * @param number
     * @returns number
     */
    function formatPhoneNumber (number){
        /*Clean up non allowed characters and the allowed spaces and brackets first */
        number = number.replace(phoneAllowedCharacters,'').replace(/([\s\(\)])/g,'');

        switch(true){
            case stringStartsWith(number, "04"): // Mobile eg 0412 345 678
                return number.replace(/(\d{7})/, '$1 ').replace(/(\d{4})/, '$1 ');
            case stringStartsWith(number, "+614"): // Mobile eg +61412 345 678
                return number.replace(/(\d{8})/, '$1 ').replace(/(\d{5})/, '$1 ');
            case stringStartsWith(number, "+61"): // Landline eg (+617) 1234 5678
                return number.replace(/(\d{7})/, '$1 ').replace(/(\d{3})/, '$1 ').replace(/(\d{0})/, '($1').replace(/(\d{3})/, '$1)');
            case stringStartsWith(number, "0"): // Landline eg (07) 1234 5678
                return number.replace(/(\d{6})/, '$1 ').replace(/(\d{2})/, '$1 ').replace(/(\d{0})/, '($1').replace(/(\d{2})/, '$1)');
        }
        return number;
    }
    /**
     * Checks the string starts with something
     * @param number
     * @returns boolean
     */
    function stringStartsWith (string, prefix) {
        return string.lastIndexOf(prefix, 0) === 0;
    }
    /**
     * Enhanced Validate flexi telephone landline OR mobile numbers.
     */
    $.validator.addMethod('validateFlexiTelNo', function (value, element) {
        if (!value.length) return true;

        var elementVal = $(element).val();
        var formattedNumber = formatPhoneNumber(elementVal);

        $(element).val(formattedNumber);

        var phoneRegex = new RegExp('^[(]*((?:\\+?61|0)[\\s]*[234785\\s]{1}[)]*[\\s]*[0-9\\s]{10})$');
        return phoneRegex.test(formattedNumber);
    });
    /**
     * Validate telephone landline OR mobile numbers.
     */
    $.validator.addMethod('validateTelNo', function (value) {
        if (!value.length) return true;

        var strippedValue = value.replace(numericOnly, '');
        if (!strippedValue.length && value.length > 0) {
            return false;
        }

        var phoneRegex = new RegExp('^(0[234785]{1}[0-9]{8})$');
        return phoneRegex.test(strippedValue);
    });
    /**
     * Validate mobile phone numbers.
     */
    $.validator.addMethod('validateMobile', function (value) {
        if (!value.length) return true;

        var valid = true;
        var strippedValue = value.replace(numericOnly, '');
        if (!strippedValue.length && value.length > 0) {
            return false;
        }

        var voipsNumber = strippedValue.indexOf('0500') === 0;
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






