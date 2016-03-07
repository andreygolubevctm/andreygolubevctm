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
        $travel_adults,
        $adult_dob_2
        ;

    //------------------------------------------------------------------


    function initParams() {
        $secondTravellerRow = $(".second_traveller_age_row"),
        $childrenRow = $(".children_row"),
        $partyType = $("#partyType"),
        $travel_adults = $('#travel_adults'),
        $adult_dob_2 = $('#travel_travellers_traveller2DOB');
    }

    function noOfTravellersDisplayLogic() {
        var travelPartyVal = $partyType.data("type");
        switch(travelPartyVal) {
            case "C":
                $secondTravellerRow.show();
                $childrenRow.hide();
                $travel_adults.val("2");
                $adult_dob_2.addClass('validate').attr('required','required');
                break;
            case "F":
                $secondTravellerRow.show();
                $childrenRow.show();
                $travel_adults.val("2");
                $adult_dob_2.removeClass('validate').removeAttr('required');
                break;
            default:
                $secondTravellerRow.hide();
                $childrenRow.hide();
                $travel_adults.val("1");
        }
    }



    meerkat.modules.register("travelParameters", {
        init: initParams,
        noOfTravellersDisplayLogic:noOfTravellersDisplayLogic
    });

})(jQuery);