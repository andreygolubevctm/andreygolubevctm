;(function($, undefined) {

    var meerkat = window.meerkat;

    function initHealthContactDetails() {
        $(document).ready(function () {
            _eventSubscriptions();
        });
    }

   function _eventSubscriptions() {
       $(document).on("change", "#health_application_postalMatch", _onChooseSamePostalAddress).on("#health_application-selection input, .elasticsearch_container_health_application_postal select", _onAddressChange);
   }

    function _onChooseSamePostalAddress(e) {
        _onAddressChange(e);
        $(".elasticsearch_container_health_application_postal").toggle(!$(e.target).prop('checked'));
    }

    function _onAddressChange(e) {
        // Clear old error messages when toggling
        if($(e.target).attr("id") === "health_application_postal_nonStd")
            $(".elasticsearch_container_health_application_address .error-field label").remove();

        if($("#health_application_postalMatch").prop('checked')) {
            $(".elasticsearch_container_health_application_postal").find("input, select").each(function() {
                $(this).val("");
            });
        }
    }

    meerkat.modules.register("healthContactDetails", {
        initHealthContactDetails: initHealthContactDetails
    });

})(jQuery);
