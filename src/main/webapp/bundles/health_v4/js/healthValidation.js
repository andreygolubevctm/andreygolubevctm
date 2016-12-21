(function ($) {
    $.validator.addMethod("locationSelection", function (value, element, param) {
        var isValid = !_.isEmpty(value);

        $('.health_contact_details_postcode_wrapper').toggleClass('has-location-error', !isValid);

        return isValid;
    }, 'Please select your suburb.');

})(jQuery);