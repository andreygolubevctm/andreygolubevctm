(function($) {

    var numericOnly = /[^0-9]+/g;

    var flexiRegex = new RegExp('^[(]*((?:\\+?61|0)[\\s]*[234785\\s]{1}[)]*[\\s]*[0-9\\s]{10})$');
    var landLineRegex = new RegExp('^[(]*((?:\\+?61|0)[\\s]*[23785\\s]{1}[)]*[\\s]*[0-9\\s]{10})$');
    var mobileRegex = new RegExp('^[(]*((?:\\+?61|0)[\\s]*[4\\s]{1}[)]*[\\s]*[0-9\\s]{10})$');


    /**
     * Validate the number
     * @param number
     * @returns boolean
     */
    function validateNumber (element, type) {
        var formattedNumber = meerkat.modules.phoneFormat.formatPhoneNumber( element);

        switch (type) {
            case 'flexi':
                return flexiRegex.test(formattedNumber);
            case 'mobile':
                return mobileRegex.test(formattedNumber);
            case 'landline':
                return landLineRegex.test(formattedNumber);
        }
    }
    /**
     * Enhanced Validate flexi telephone landline OR mobile numbers.
     */
    $.validator.addMethod('validateFlexiTelNo', function (value, element) {
        if (!value.length) return true;
        return formattedNumber = validateNumber (element,'flexi');
    });
    /**
     * Validate telephone landline
     */
    $.validator.addMethod('validateLandLineTelNo', function (value, element) {
        if (!value.length) return true;
        return formattedNumber = validateNumber (element,'landline');
    });
    /**
     * Validate mobile phone numbers.
     */
    $.validator.addMethod('validateMobileTelNo', function (value, element) {
        if (!value.length) return true;
        return formattedNumber = validateNumber (element,'mobile');
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






