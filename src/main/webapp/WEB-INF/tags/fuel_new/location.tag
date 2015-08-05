<%@ tag description="Fuel Location"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="xpath" %>

<form_new:row label="Postcode / Suburb">
    <field_new:lookup_suburb_postcode xpath="${xpath}/location" placeholder="Postcode / Suburb" required="true" />
</form_new:row>

<go:script marker="js-head">
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
</go:script>

<go:validate selector="${xpath}_location" rule="validateLocation" parm="true" message="Please select a valid postcode to compare fuel" />