var isFuelBrochureSiteRequest = ${not empty suburb or not empty postcode};

$.validator.addMethod("validateLocation", function(value, element) {
    var postcode_match = new RegExp(/^(\s)*\d{4}(\s)*$/),
        search_match = new RegExp(/^((\s)*[\w\-]+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

    value = $.trim(String(value));
    value = value.replace("'","");

    if(isFuelBrochureSiteRequest) {
        isFuelBrochureSiteRequest = false;
        $('#fuel_location').trigger("focus");
        return true;
    }

    if( value != '' ) {
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