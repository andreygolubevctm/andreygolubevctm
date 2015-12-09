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
    var $movingInDate;
    var movingDateStartRange, movingDateEndRange,movingInDateCurrent,movingInDatePlusOneYear;
    var now = new Date();

    //------------------------------------------------------------------


    function initDateRangeVars(){
        //Initialise to get the initial range and a date 1 year in advance.
        movingDateStartRange = now;
        movingDateEndRange = new Date(movingDateStartRange.toString());
        movingDateEndRange.setYear(parseInt(movingDateEndRange.getFullYear()) + 1);
    }

    //Useful to pass the corrected DD/MM/YYYY format to the input
    //In the case you're trying to use it for the native picker, set true for rfc3339
    //min and max ranges for the rfc3339 may or may not actually want the full 2008-12-19T16:39:57.67Z format on iOS safari web.
    function stringDate(inputFormat, rfc3339) {
        if (typeof rfc3339 === "undefined") { rfc3339 = false; }

        function pad(s) { return (s < 10) ? '0' + s : s; }
        var d = new Date(inputFormat);
        log("the rfc is :"+rfc3339);

        if(!rfc3339) {
            return [pad(d.getDate()), pad(d.getMonth()+1), d.getFullYear()].join("/");
        } else {
            log("the date is:"+ d.getDate()+" month: "+ d.getMonth()+1 + " full year:"+ d.getFullYear());
            return [d.getFullYear(), pad(d.getMonth()+1), pad(d.getDate())].join("-");
        }
    }



    //Setup function for init()
    function initDatePickers(){

        initDateRangeVars();
        //NOTE: These .datepickers are set up by the datepicker.js wrapper FIRST. Here we customise from the defaults and add custom functionality.

        // We could have set up the actual date objects for fromDate_StartDateRange and toDate_StartDateRange, but on init there's a 'today' shortcut.

        // initialise from/leave date datepicker
        $movingInDate.datepicker(
            { startDate: movingDateStartRange, endDate: movingDateEndRange}
        );
        //update the native picker range checking
        $movingInDate.siblings(".dateinput-nativePicker").find("input")
            .attr("min", stringDate(movingDateStartRange,true))
            .attr("max", stringDate(movingDateEndRange,true));

        // initialise to/return date datepicker with some default date ranges.
        $movingInDate.datepicker(
            { startDate: movingDateStartRange, endDate: movingDateEndRange }
        );

    }














    function initUtilitiesDatesSelection(){
        //Elements need to be in the page
        $(document).ready(function(){
            //Grab the elements on the page
            $movingInDate = $("#utilities_householdDetails_movingInDate");
            $movingInDate.datepicker({ orientation: "top left", numberOfMonths: 2, allowHeaderStyling: true});
            $movingInDate.datepicker("setDaysOfWeekDisabled", [0, 6]);
            initDatePickers();

        });
    }

    meerkat.modules.register("datesSelection", {
        init: initUtilitiesDatesSelection
    });

})(jQuery);