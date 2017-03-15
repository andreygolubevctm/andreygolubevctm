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
            // The default here assumed that this is a new quote, therefore additional travels were getting cut off.
            // This will check to see if travel_party is selected in the journey, or default back to what was causing the issue.
                var selectedTravelParty = $travel_party.filter(':checked').val();
                if (selectedTravelParty == "C") {
                    $secondTravellerRow.show();
                    $childrenRow.hide();
                    $travel_adults.val("2");
                    $adult_dob_2.addClass('validate').attr('required','required');

                } else if (selectedTravelParty == "F") {
                    $secondTravellerRow.show();
                    $childrenRow.show();
                    $travel_adults.val("2");
                    $adult_dob_2.removeClass('validate').removeAttr('required');

                } else {
                    $secondTravellerRow.hide();
                    $childrenRow.hide();
                    $travel_adults.val("1");

                }
        }
    }



    meerkat.modules.register("travelParameters", {
        init: initParams,
        noOfTravellersDisplayLogic:noOfTravellersDisplayLogic
    });

})(jQuery);