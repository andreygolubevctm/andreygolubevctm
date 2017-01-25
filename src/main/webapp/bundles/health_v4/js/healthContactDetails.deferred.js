;(function($, undefined) {

    var meerkat = window.meerkat,
        postalMatch = '#health_application_postalMatch';

    function initHealthContactDetails() {
        $(document).ready(function () {
            _eventSubscriptions();
        });
    }

    function _eventSubscriptions() {
        _togglePostalGroup();

        $(postalMatch).on('change', function() {
            _togglePostalGroup();
        });
    }

    function _togglePostalGroup() {
        var postalGroup = '#health_application_postalGroup';
        if( $(postalMatch).is(':checked')  ){
            $(postalGroup).slideUp();
        } else {
            $(postalGroup).slideDown();
        }
    }

    meerkat.modules.register("healthContactDetails", {
        init: initHealthContactDetails
    });

})(jQuery);
