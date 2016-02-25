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
    var $showLocation = $("#showLocation");
    var $showCompareTo = $("#showCompareTo");
    var $showMovingIn = $("#showMovingIn");

    var $postcodeSuburbField =  $("div.postcode-suburb");
    var $whatToCompareField  = $("div.what-to-compare");
    var $movingInField = $("div.moving-in");

    var $fieldSetHouseHoldDetails = $("fieldset.household-details");




    //------------------------------------------------------------------

    function displayHiddenFields() {
        $showLocation.data("show","true");
        $showCompareTo.data("show","true");
        $showMovingIn.data("show","true");
        console.log("finished changing the attributes now lets see if we can show them");
        initParams();

    }











   function initParams() {
       var displayLocation = $showLocation.data("show");
       var displayCompareTo = $showCompareTo.data("show");
       var displayMovingIn = $showMovingIn.data("show");

       console.log(" location :"+displayLocation+" compareto:"+displayCompareTo+" movingin:"+displayMovingIn);
       displayLocation ? $postcodeSuburbField.show() : $postcodeSuburbField.hide();
       displayCompareTo ? $whatToCompareField.show() : $whatToCompareField.hide();
       displayMovingIn ? $movingInField.show() : $movingInField.hide();
       if(displayLocation && displayCompareTo && displayMovingIn) {
           $fieldSetHouseHoldDetails.show();
       }
       else {
           $fieldSetHouseHoldDetails.hide();
       }


   }

    meerkat.modules.register("utilitiesParameters", {
        init: initParams,
        displayHiddenFields:displayHiddenFields
    });

})(jQuery);