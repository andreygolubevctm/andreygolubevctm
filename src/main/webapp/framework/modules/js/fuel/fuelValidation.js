(function($) {
    var postcode_match = new RegExp(/^(\s)*\d{4}(\s)*$/),
        search_match = new RegExp(/^((\s)*[\w\-]+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);
    $.validator.addMethod("validateLocation", function(value, element) {
        value = $.trim(String(value));
        value = value.replace("'","");

        if(meerkat.site.isFromBrochureSite) {
            meerkat.site.isFromBrochureSite = false;
            $('#fuel_location').trigger("focus");
            return true;
        }

        if( value !== '' ) {
            if(value.match(postcode_match) || value.match(search_match)) {
                return true;
            }
        }

        return false;
    }, "");

    $.validator.addMethod("fuelSelected", function(value, element) {
        var $inputs = $("#checkboxes-all").find("input"),
            $checked = $inputs.filter(":checked"),
            isValid = ($checked.length > 0 && $checked.length <= 2);

        $inputs.toggleClass("has-error", !isValid);
        return isValid;
    }, "");
})(jQuery);