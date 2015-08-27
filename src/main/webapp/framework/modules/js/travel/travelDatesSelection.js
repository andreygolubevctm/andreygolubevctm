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
	var $fromDateInput, $toDateInput,
	now = new Date(),
	fromDateCurrent,
	fromDate_StartDateRange,
	fromDate_EndDateRange,
	fromDate_PlusYear,
	toDateCurrent,
	toDate_StartDateRange,
	toDate_EndDateRange;

	//------------------------------------------------------------------

	//Useful to pass the corrected DD/MM/YYYY format to the input
	//In the case you're trying to use it for the native picker, set true for rfc3339
	//min and max ranges for the rfc3339 may or may not actually want the full 2008-12-19T16:39:57.67Z format on iOS safari web.
	function stringDate(inputFormat, rfc3339) {
		if (typeof rfc3339 === "undefined") { rfc3339 = false; }

		function pad(s) { return (s < 10) ? '0' + s : s; }
		var d = new Date(inputFormat);

		if(!rfc3339) {
			return [pad(d.getDate()), pad(d.getMonth()+1), d.getFullYear()].join("/");
		} else {
			return [d.getFullYear(), pad(d.getMonth()+1), pad(d.getDate())].join("-");
		}
	}


	function initDateRangeVars(){
		//Initialise to get the initial range and a date 1 year in advance.
		fromDate_StartDateRange = now;
		fromDate_EndDateRange = new Date(fromDate_StartDateRange.toString());
		fromDate_EndDateRange.setYear(parseInt(fromDate_EndDateRange.getFullYear()) + 1);

		toDate_StartDateRange = now;
		toDate_EndDateRange = new Date(toDate_StartDateRange.toString());
		toDate_EndDateRange.setYear(parseInt(toDate_EndDateRange.getFullYear()) + 1);
	}


	//Setup function for init()
	function initDatePickers(){

		initDateRangeVars();
		//NOTE: These .datepickers are set up by the datepicker.js wrapper FIRST. Here we customise from the defaults and add custom functionality.

		// We could have set up the actual date objects for fromDate_StartDateRange and toDate_StartDateRange, but on init there's a 'today' shortcut.

		// initialise from/leave date datepicker
		$fromDateInput.datepicker(
			{ startDate: fromDate_StartDateRange, endDate: fromDate_EndDateRange}
		);
		//update the native picker range checking
		$fromDateInput.siblings(".dateinput-nativePicker").find("input")
		.attr("min", stringDate(fromDate_StartDateRange,true))
		.attr("max", stringDate(fromDate_EndDateRange,true));

		// initialise to/return date datepicker with some default date ranges.
		$toDateInput.datepicker(
			{ startDate: toDate_StartDateRange, endDate: toDate_EndDateRange }
		);
		//update the native picker range checking
		$toDateInput.siblings(".dateinput-nativePicker").find("input")
		.attr("min", stringDate(toDate_StartDateRange,true))
		.attr("max", stringDate(toDate_EndDateRange,true));
	}


	//Kicks forward the to/return date ranges on the calendar when the from/leave date changes
	function syncToDateRanges() {

		// Grab the current internal date objects
		fromDateCurrent = $fromDateInput.datepicker("getDate"); //localized date object
		//Make sure we have an actual date object in the right format before setting anything new
		if (fromDateCurrent.toString() !== "Invalid Date") {
			//Initialise the to be the same
			toDate_StartDateRange = new Date(fromDateCurrent.toString());

			//increment by 1 year from current range start
			toDate_EndDateRange = new Date(toDate_StartDateRange.toString());
			toDate_EndDateRange.setYear(parseInt(toDate_EndDateRange.getFullYear()) + 1);

			//Affect the actual picker
			$toDateInput
			.datepicker("setStartDate", toDate_StartDateRange)
			.datepicker("setEndDate", toDate_EndDateRange);

			//update the native picker range checking
			$toDateInput.siblings(".dateinput-nativePicker").find("input")
			.attr("min", stringDate(toDate_StartDateRange,true))
			.attr("max", stringDate(toDate_EndDateRange,true));

			//update (remove then add) the jqvalidation to know what the new min and max dates are.

			//min toDate is handled by range validation in the tag using fromToDate rule.
			//$toDateInput.rules("remove", "minDateEUR");
			//$toDateInput.rules('add',
			//	{'minDateEUR': stringDate(toDate_StartDateRange),
			//	messages:{'minDateEUR':'The return date should be equal to or after '+toDate_StartDateRange}});

			//Max needs to be handled dynamically with this validate rules command.
			$toDateInput.rules("remove", "latestDateEUR");
			$toDateInput.rules('add',
				{'latestDateEUR': stringDate(toDate_EndDateRange),
				messages:{'latestDateEUR':'The return date should be equal to or before one year after the departure date (i.e. '+ stringDate(toDate_EndDateRange)+')'}});
		}
	}


	//Pulls back the to/return date ranges on the calendar when the from/leave date changes
	function syncToDateWithin1yearRange() {

		// Grab the current internal date objects
		fromDateCurrent = $fromDateInput.datepicker("getDate"); //localized date object
		toDateCurrent = $toDateInput.datepicker("getDate"); //localized date object

		// Increment by 1 year from Current to find the highest allowed toDate
		fromDate_PlusYear = new Date(fromDateCurrent.toString());
		fromDate_PlusYear.setYear(parseInt(fromDate_PlusYear.getFullYear()) + 1);

		// When our 'to' return date has no longer falls within 1 year ahead of the 'from' depart date.... set it to the largest available date.
		if (fromDate_PlusYear < toDateCurrent) {
			//Set the toDateInput into the 3 separate fields
			meerkat.modules.formDateInput.populate($toDateInput, stringDate(fromDate_PlusYear));
			$toDateInput.datepicker("update", fromDate_PlusYear);
		}
	}


	//------------------------------------------------------------------

	function initDateEvents(){

		$fromDateInput.on("hide serialised.meerkat.formDateInput", function updateToDateInput() {
			syncToDateWithin1yearRange();
			syncToDateRanges();
		});

		//If the toDate is updated and was causing the fromDate input to not be valid due to the "must be before the after date input" check, we need to call a blur on the other fields too.
		$toDateInput.on('hide serialised.meerkat.formDateInput', function updateFromDateInput() {
			$fromDateInput.blur();
		});

		//Strictly Debugging
		//$("#travel_dates_fromDate,#travel_dates_toDate").on('hide', function(event) {
			//console.debug({
			//"now":now,
			//"fromDateCurrent":fromDateCurrent,
			//"fromDate_StartDateRange":fromDate_StartDateRange,
			//"fromDate_EndDateRange":fromDate_EndDateRange,
			//"fromDate_PlusYear":fromDate_PlusYear,
			//"toDateCurrent":toDateCurrent,
			//"toDate_StartDateRange":toDate_StartDateRange,
			//"toDate_EndDateRange":toDate_EndDateRange
			//});
		//});
	}


	function init(){
		//Elements need to be in the page
		$(document).ready(function() {
			//Grab the elements on the page
			$fromDateInput = $("#travel_dates_fromDate");
			$toDateInput = $("#travel_dates_toDate");

			$fromDateInput.datepicker({ orientation: "top right", numberOfMonths: 2});
			$toDateInput.datepicker({ orientation: "top right", numberOfMonths: 2 });

			initDatePickers();
			initDateEvents();
		});

	}

	meerkat.modules.register("datesSelection", {
		init: init
	});

})(jQuery);