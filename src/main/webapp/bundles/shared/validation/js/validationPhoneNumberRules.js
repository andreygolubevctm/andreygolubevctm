(function($) {

    var numericOnly = /[^0-9]+/g;
    var phoneAllowedCharacters = /[^0-9\(\)+]/g;
    var flexiRegex = new RegExp('^[(]*((?:\\+?61|0)[\\s]*[234785\\s]{1}[)]*[\\s]*[0-9\\s]{10})$');
    var landLineRegex = new RegExp('^[(]*((?:\\+?61|0)[\\s]*[23785\\s]{1}[)]*[\\s]*[0-9\\s]{10})$');
    var mobileRegex = new RegExp('^[(]*((?:\\+?61|0)[\\s]*[4\\s]{1}[)]*[\\s]*[0-9\\s]{10})$');

    /**
     * Format the phone number so it is in the format 04xx xxx xxx or (0x) xxxx xxxx
     * @param number
     * @returns number
     */
    function formatPhoneNumber (number, element){
        /*Clean up non allowed characters and the allowed spaces and brackets first */
        number = number.replace(phoneAllowedCharacters,'').replace(/([\s\(\)])/g,'');

        switch(true){
            case stringStartsWith(number, "04"): // Mobile eg 0412 345 678
                number = number.replace(/(\d{7})/, '$1 ').replace(/(\d{4})/, '$1 ');
                break;
            case stringStartsWith(number, "+614"): // Mobile eg +61412 345 678
                number = number.replace(/(\d{8})/, '$1 ').replace(/(\d{5})/, '$1 ');
                break;
            case stringStartsWith(number, "+61"): // Landline eg (+617) 1234 5678
                number = number.replace(/(\d{7})/, '$1 ').replace(/(\d{3})/, '$1 ').replace(/(\d{0})/, '($1').replace(/(\d{3})/, '$1)');
                break;
            case stringStartsWith(number, "0"): // Landline eg (07) 1234 5678
                number = number.replace(/(\d{6})/, '$1 ').replace(/(\d{2})/, '$1 ').replace(/(\d{0})/, '($1').replace(/(\d{2})/, '$1)');
                break;
        }
        $(element).val(number);

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
     * Start formatting (as typing) and format on blur
     * @param number
     * @returns boolean
     */
    function startFormatNumber (element, type) {
        /* Lets format the field each time a key is entered, but don't valide on it until it blurs */
        element.onkeyup = function(evt) {
            /*
             8 is the keyCode for the backspace key,
             37 is the keyCode for the left arrow,
             39 is the keyCode for the right arrow,
             46 is the keyCode for the Del,
             Which we don't want to format on */
            var disallowedKeys = [8, 37, 39, 46];
            if (disallowedKeys.indexOf(evt.keyCode) === -1) {
                validateNumber (element, type);
            }
        };
    }
    /**
     * Start formatting (as typing) and format on blur
     * @param number
     * @returns boolean
     */
    function validateNumber (element, type) {
        var elementVal = $(element).val();
        var formattedNumber = formatPhoneNumber(elementVal, element);

        switch (type) {
            case 'flexi':
                return flexiRegex.test(formattedNumber);
            case 'mobile':
                return mobileRegex.test(formattedNumber);
            case 'landline':
                return landLineRegex.test(formattedNumber);
        }

        //return formattedNumber;
    }
    /**
     * Enhanced Validate flexi telephone landline OR mobile numbers.
     */
    $.validator.addMethod('validateFlexiTelNo', function (value, element) {
        if (!value.length) return true;
        startFormatNumber (element, 'flexi');
        return formattedNumber = validateNumber (element,'flexi');
        //return flexiRegex.test(formattedNumber);
    });
    /**
     * Validate telephone landline
     */
    $.validator.addMethod('validateLandLineTelNo', function (value, element) {
        if (!value.length) return true;
        startFormatNumber (element, 'landline');
        return formattedNumber = validateNumber (element,'landline');
        //return landLineRegex.test(formattedNumber);
    });
    /**
     * Validate mobile phone numbers.
     */
    $.validator.addMethod('validateMobileTelNo', function (value, element) {
        if (!value.length) return true;
        startFormatNumber (element, 'mobile');
        return formattedNumber = validateNumber (element,'mobile');
        //return mobileRegex.test(formattedNumber);
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






