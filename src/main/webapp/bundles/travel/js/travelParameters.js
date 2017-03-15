/*
 *
 * Handling styling for parameters coming from website widget
 *
 */
;(function($, undefined) {

    "use strict";

    //Standard platform access:
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    //------------------------------------------------------------------

    //Elements and Variables:
    var $secondTravellerRow,
        $childrenRow,
        $partyType,
        $travel_party,
        $travel_adults,
        $adult_dob_2;

    //------------------------------------------------------------------


    function initParams() {
        $secondTravellerRow = $(".second_traveller_age_row"),
        $childrenRow = $(".children_row"),
        $travel_party = $('input[name=travel_party]'),
        $partyType = $("#partyType"),
        $travel_adults = $('#travel_adults'),
        $adult_dob_2 = $('#travel_travellers_traveller2DOB');
    }

    function noOfTravellersDisplayLogic() {
        // Param from brochure widget
        var travelPartyVal = $partyType.data("type");
        if (_.indexOf(['C','F','S'], travelPartyVal) < 0) {
            // Used when new journey or loaded from best price email
            travelPartyVal = $travel_party.filter(':checked').val();
        }
        configExtraTravellerFields(travelPartyVal);
    }

    function configExtraTravellerFields(travelType) {
        if (travelType == "C") {
            // Couple
            $childrenRow.hide();
            $travel_adults.val("2");
            $secondTravellerRow.show();
            $adult_dob_2.addClass('validate').attr('required','required');

        } else if (travelType == "F") {
            // Family
            $childrenRow.show();
            $travel_adults.val("2");
            $secondTravellerRow.show();
            $adult_dob_2.removeClass('validate').removeAttr('required');

        } else {
            // Single
            $childrenRow.hide();
            $travel_adults.val("1");
            $secondTravellerRow.hide();

        }
    }

    meerkat.modules.register("travelParameters", {
        init: initParams,
        noOfTravellersDisplayLogic:noOfTravellersDisplayLogic
    });

})(jQuery);