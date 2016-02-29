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
        $("div.spend, div.days, div.usage").hide();
    }

    function _hideWhenElectiricySelected() {
        $("div.spend, div.days, div.electricity-meter").hide();
    }



    function initialState() {
        var movingIn = $(".moving-in").find("input[type='radio']:checked").val();
        var whatToCompare = $(".what-to-compare").find("input[type='radio']:checked").val();
        if(_.isEqual(movingIn,"N") ) {
            switch(whatToCompare) {
                case "G":
                    _hideWhenGasSelected();
                    break;
                case "E":
                    _hideWhenElectiricySelected();
                    break;
                default:
                    _hideWhenElectiricySelected();
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