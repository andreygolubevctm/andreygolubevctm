(function ($) {

    var additionalBrandSpecificErrorMsg = "";
    if (meerkat.site.tracking.brandCode === 'ctm') {
        additionalBrandSpecificErrorMsg = ", please <a href='https://www.comparethemarket.com.au/health-insurance/health-insurance-overseas-visitors/'>click here</a>";
    }

    $.validator.addMethod('medicareCardColour', function (value, element) {
        return (value !== 'none');
    }, "To proceed with this policy, you must have a green, blue or yellow medicare card. For overseas visitor cover" + additionalBrandSpecificErrorMsg + ".");

})(jQuery);