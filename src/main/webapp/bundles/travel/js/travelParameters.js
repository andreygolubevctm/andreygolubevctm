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
        $partyType;




    //------------------------------------------------------------------


    function initParams() {
        $secondTravellerRow = $(".second_traveller_age_row"),
        $childrenRow = $(".children_row"),
        $partyType = $("#partyType");
    }

    function displayAccordingTravellerType() {
        var travelPartyVal = $partyType.data("type");
        switch(travelPartyVal) {
            case "C":
                $secondTravellerRow.show();
                $childrenRow.hide();
                break;
            case "F":
                $secondTravellerRow.show();
                $childrenRow.show();
                break;
            default:
                $secondTravellerRow.hide();
                $childrenRow.hide();
        }

    }



    meerkat.modules.register("travelParameters", {
        init: initParams,
        displayAccordingTravellType:displayAccordingTravellerType
    });

})(jQuery);