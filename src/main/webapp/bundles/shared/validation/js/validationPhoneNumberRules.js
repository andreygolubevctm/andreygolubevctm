(function($) {

    var numericOnly = /[^0-9]+/g;

    var flexiRegex = new RegExp('^[(]*((?:\\+?61|0)[\\s]*[234785\\s]{1}[)]*)((([\\s]{1})([0-9\\s]{9}))|([0-9\\s]{10}))$');
    var landLineRegex = new RegExp('^[(]*((?:\\+?61|0)[\\s]*[23785\\s]{1}[)]*([\\s]{1})([0-9\\s]{9}))$');
    var mobileRegex = new RegExp('^[(]*((?:\\+?61|0)[\\s]*[4\\s]{1}[)]*[\\s]*[0-9\\s]{10})$');
	var mobileBlacklist = ["0400 123 456","0400 000 000","0411 111 111","0412 345 678","0444 444 444","0404 040 404","0499 999 999","0422 222 222","0412 123 123","0455 555 555","0433 333 333","0411 222 333","0400 000 001","0488 888 888","0412 312 312"];

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
	 * Validate mobile phone numbers and match against blacklist.
	 */
	$.validator.addMethod('validateMobileTelNoWithBlacklist', function (value, element) {
		if (!value.length) return true;
		return _.indexOf(mobileBlacklist,value) === -1;
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






