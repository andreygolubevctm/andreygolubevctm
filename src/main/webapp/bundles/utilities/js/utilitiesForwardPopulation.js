;(function($) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    function init() {}

    function configure() {
        var fields = {
            name: [
                {
                    $field: $("#utilities_resultsDisplayed_firstName")
                }, {
                    $field: $("#utilities_application_details_firstName")
                }
            ],
            email: [
                {
                    $field: $("#utilities_resultsDisplayed_email")
                }, {
                    $field: $("#utilities_application_details_email")
                }
            ],
            moveInDate: [
                {
                    $field: $("#utilities_householdDetails_movingInDate"),
                    $fieldInput: $("#utilities_householdDetails_movingInDate")
                }, {
                    $field: $("#utilities_application_details_movingDate"),
                    $fieldInput: $("#utilities_application_details_movingDate")
                }
            ],
            alternatePhone: [
                {
                    $field: $("#utilities_resultsDisplayed_phoneinput")
                },
                {
                    $field: $("#utilities_application_details_mobileinput"),
                    $fieldInput: $("#utilities_application_details_mobileinput"),
                    $otherField: $("#utilities_application_details_otherinput"),
                    $otherFieldInput: $("#utilities_application_details_otherinput")
                }
            ]
        };

        meerkat.modules.contactDetails.configure(fields);
    }

    meerkat.modules.register("utilitiesForwardPopulation", {
        init: init,
        configure: configure
    });

})(jQuery);