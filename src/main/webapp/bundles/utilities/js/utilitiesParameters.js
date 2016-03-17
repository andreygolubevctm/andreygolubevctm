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
    var $showLocation,
        $showCompareTo,
        $showMovingIn,
        $postcodeSuburbField,
        $whatToCompareField,
        $movingInField,
        $fieldSetHouseHoldDetails;




    //------------------------------------------------------------------
    /**
     * Originally the requirement was to hide the fields if user is coming from the widget
     * however to show the fields when coming from step 2 to step 1
     * This requirement has been relaxed as we would always show the fields.
     * however it may come back at a later stage. for when it does is just a mater of modifying parameters.tag
     */

    function displayHiddenFields() {
        $showLocation.data("show","true");
        $showCompareTo.data("show","true");
        $showMovingIn.data("show","true");
        console.log("finished changing the attributes now lets see if we can show them");
        initParams();

    }

   function initParams() {
       $showLocation = $("#showLocation"),
       $showCompareTo = $("#showCompareTo"),
       $showMovingIn = $("#showMovingIn"),

       $postcodeSuburbField =  $("div.postcode-suburb"),
       $whatToCompareField  = $("div.what-to-compare"),
       $movingInField = $("div.moving-in"),
       $fieldSetHouseHoldDetails = $("fieldset.household-details");

       var displayLocation = $showLocation.data("show");
       var displayCompareTo = $showCompareTo.data("show");
       var displayMovingIn = $showMovingIn.data("show");

       displayLocation ? $postcodeSuburbField.removeClass('hidden') : $postcodeSuburbField.addClass('hidden');
       displayCompareTo ? $whatToCompareField.removeClass('hidden') : $whatToCompareField.addClass('hidden');
       displayMovingIn ? $movingInField.removeClass('hidden') : $movingInField.addClass('hidden');
       if(displayLocation && displayCompareTo && displayMovingIn) {
           $fieldSetHouseHoldDetails.removeClass('hidden');
       }
       else {
           $fieldSetHouseHoldDetails.addClass('hidden');
       }
   }

    function _hideWhenGasSelected() {
        $(".gas-details div.spend,.gas-details div.days, .gas-details div.usage").hide();
    }

    function _hideWhenElectritySelected() {
        $(".electricity-details div.spend,.electricity-details div.days, .electricity-details div.electricity-meter").hide();
    }



    function initialState() {
        var movingIn = $movingInField.find("input[type='radio']:checked").val();
        var whatToCompare = $whatToCompareField.find("input[type='radio']:checked").val();
        if(_.isEqual(movingIn,"N") ) {
            switch(whatToCompare) {
                case "G":
                    _hideWhenGasSelected();
                    break;
                case "E":
                    _hideWhenElectritySelected();
                    break;
                default:
                    _hideWhenElectritySelected();
                    _hideWhenGasSelected();
            }
        }
    }

    meerkat.modules.register("utilitiesParameters", {
        init: initParams,
        displayHiddenFields:displayHiddenFields,
        initialState:initialState

    });

})(jQuery);