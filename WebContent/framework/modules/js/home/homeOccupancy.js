/**
 * Occupancy question set logic
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	/* Variables */
	var currentTime = new Date();
	var months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
	var currentYear = currentTime.getFullYear();
	var currentMonth = currentTime.getMonth() + 1;
	var selectedMonth = '';

	var elements = {
			name:					"home_occupancy",
			ownProperty:			"home_occupancy_ownProperty",
			principalResidence:		"home_occupancy_principalResidence",
			whenMovedInYear:		"home_occupancy_whenMovedIn_year",
			whenMovedInMonth:		"home_occupancy_whenMovedIn_month",
			howOccupied:			"#home_occupancy_howOccupied",
			whenMovedInYearRow:		".whenMovedInYear",
			whenMovedInMonthRow:	".whenMovedInMonth",
			howOccupiedRow:			".howOccupied"

	};

	function isPrincipalResidence() {
		if($('input:radio[name='+elements.principalResidence+']:checked').val() == "Y"){
			return true;
		} else {
			return false;
		}
	}
	/* Here you put all functions for use in your module */
	function togglePropertyOccupancyFields(speed) {

		var ownProperty = $('input:radio[name='+elements.ownProperty+']:checked').val();
		var howOccupied =  $(elements.howOccupied).find('option:selected').val();
		var isItPrincipalResidence = isPrincipalResidence();
		var $howOccupied = $(elements.howOccupied);

		if (!isItPrincipalResidence && (typeof ownProperty == 'undefined' || ownProperty == "N")){
			$(elements.howOccupiedRow).slideUp(speed);
			$(elements.whenMovedInYearRow+', '+elements.whenMovedInMonthRow).slideUp(speed);
		} else {
			if(isItPrincipalResidence){
				$(elements.howOccupiedRow).slideUp(speed);
				$(elements.whenMovedInYearRow).slideDown(speed);
				yearSelected(speed);
			} else {
				$(elements.howOccupiedRow).slideDown(speed);
				$(elements.whenMovedInYearRow+', '+elements.whenMovedInMonthRow).slideUp(speed);
			}
		}
	}
	function yearSelected(speed) {
		var selectedYear = $('select[name="'+elements.whenMovedInYear+'"]').val();
		var selectedMonth = selectedMonth;

		var monthField = $('#'+elements.whenMovedInMonth);
		var monthHelpId = $('#help_504');
		var numberOfMonths = 12;

		monthField.empty().append($('<option>', { value : "" }).text("Please Select..."));

		if(selectedYear == currentYear) {
			numberOfMonths = currentMonth;
		}

		if(selectedYear >= (currentYear - 2)) {
			$(elements.whenMovedInMonthRow).slideDown(speed);
			monthHelpId.slideDown(speed);
			for(var i = 1; i <= numberOfMonths ; i++) {
				monthField.append($('<option>', { value : i }).text(months[i-1]));
			}
			if(selectedMonth !== '' && selectedMonth <= numberOfMonths) {
				$('select[name="'+elements.whenMovedInMonth+'"]').val(selectedMonth);
			} else {
				$('select[name="'+elements.whenMovedInMonth+'"]').val("");
			}
		} else {
			$(elements.whenMovedInMonthRow).slideUp(speed);
			monthHelpId.slideUp(speed);
		}
	}
	function applyEventListeners() {
		$(document).ready(function() {
			$('#'+elements.whenMovedInYear).on('change', function() {
				yearSelected();
			});

			$('input[name='+elements.name+'_ownProperty], '+elements.howOccupied).on('change', function() {
				togglePropertyOccupancyFields();
			});

			$('input[name='+elements.principalResidence+']').on('change', function() {
				togglePropertyOccupancyFields();
			});
		});
	}
	/* main entrypoint for the module to run first */
	function initHomeOccupancy() {
		log("[HomeOccupancy] Initialised"); //purely informational
		applyEventListeners();
		$(document).ready(function() {
			togglePropertyOccupancyFields(0);
		});
	}

	meerkat.modules.register('homeOccupancy', {
		initHomeOccupancy: initHomeOccupancy, //main entrypoint to be called.
		events: moduleEvents,
		isPrincipalResidence : isPrincipalResidence//exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);

