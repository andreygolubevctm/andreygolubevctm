;(function($, undefined) {

    var meerkat = window.meerkat,
        postalMatch = '#health_application_postalMatch';

    function initHealthContactDetails() {
        $(document).ready(function () {

            if (!meerkat.modules.splitTest.isActive(18)) {
                return false;
            }

            _eventSubscriptions();
        });
    }

    function _eventSubscriptions() {
        $(document).on("#health_application-selection input, .elasticsearch_container_health_application_postal select", _onAddressChange);
        _togglePostalGroup();

        $(postalMatch).on('change', function() {
            _togglePostalGroup();
        });
    }

    function _togglePostalGroup(){
        var postalGroup = '#health_application_postalGroup';
        if( $(postalMatch).is(':checked')  ){
            $(postalGroup).slideUp();
        } else {
            $(postalGroup).slideDown();
        }
    }

    function _onAddressChange(e) {
        // Clear old error messages when toggling
        if($(e.target).attr("id") === "health_application_postal_nonStd")
            $(".elasticsearch_container_health_application_address .error-field label").remove();

        if($(postalMatch).prop('checked')) {
            $(".elasticsearch_container_health_application_postal").find("input, select").each(function() {
                $(this).val("");
            });
        }
    }

    meerkat.modules.register("healthContactDetails", {
        init: initHealthContactDetails
    });

})(jQuery);
