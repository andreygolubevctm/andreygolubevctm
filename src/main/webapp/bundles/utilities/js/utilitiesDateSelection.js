/*
 *
 * Handling of the date from and to DATE selections
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
    var $movingInDate, $applicationMovingInDate,
    $houseHoldMovingDates, $houseHoldAppDates, $houseHoldMovingDateButton, $houseHoldAppDateButton;
    var $houseHoldAppDateD, $houseHoldAppDateM, $houseHoldAppDateY;

    //------------------------------------------------------------------





    function showCalendarOnDMYTextFields() {
        $houseHoldMovingDates.focus(function showCalendar() {
            $movingInDate.datepicker('hide');
            $houseHoldMovingDateButton.trigger("click");
        });
        $houseHoldAppDates.focus(function showCalendar() {
            $applicationMovingInDate.datepicker('hide');
            $houseHoldAppDateButton.trigger("click");
        });
    }


    function initVariables() {
        $movingInDate = $("#utilities_householdDetails_movingInDate");
        $applicationMovingInDate = $("#utilities_application_details_movingDate");

        $houseHoldMovingDates = $("#utilities_householdDetails_movingInDateInputD,#utilities_householdDetails_movingInDateInputM,#utilities_householdDetails_movingInDateInputY");
        $houseHoldAppDates = $("#utilities_application_details_movingDateInputD,#utilities_application_details_movingDateInputM,#utilities_application_details_movingDateInputY");

        $houseHoldAppDateD = $("#utilities_application_details_movingDateInputD");
        $houseHoldAppDateM = $("#utilities_application_details_movingDateInputM");
        $houseHoldAppDateY = $("#utilities_application_details_movingDateInputY");

        $houseHoldMovingDateButton = $("#utilities_householdDetails_movingInDate_button");
        $houseHoldAppDateButton = $("#utilities_application_details_movingDate_button");
    }

    function populateCalendarViewFromFields() {
        var valDate = $houseHoldAppDateD.val();
        var valMonth = $houseHoldAppDateM.val();
        var valYear = $houseHoldAppDateY.val();
        $applicationMovingInDate.datepicker('update',new Date(valYear,(valMonth -1),valDate));
    }



    function initUtilitiesDatesSelection(){
        //Elements need to be in the page
        $(document).ready(function(){
            //Grab the elements on the page
            initVariables();
            $movingInDate.datepicker({
                      orientation: "top left",
                      numberOfMonths: 2,
                      allowHeaderStyling: true,
                      autoclose:true,
                      setDaysOfWeekDisabled: [0,6],
                      daysOfWeekHighlighted: [1,2,3,4,5],
                      format: "dd/mm/yyyy"

            });
            $applicationMovingInDate.datepicker({
                orientation: "top left",
                numberOfMonths: 2,
                allowHeaderStyling: true,
                autoclose:true,
                setDaysOfWeekDisabled: [0,6],
                daysOfWeekHighlighted: [1,2,3,4,5],
                format: "dd/mm/yyyy"

            });
            showCalendarOnDMYTextFields();

        });
    }

    meerkat.modules.register("utilitiesDatesSelection", {
        init: initUtilitiesDatesSelection,
        populateCalendarViewFromFields:populateCalendarViewFromFields

    });

})(jQuery);