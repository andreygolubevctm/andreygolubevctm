/**
 * Occupancy question set logic
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	/* Variables */
	var initialised = false;
	var currentTime = new Date();
	var currentYear = currentTime.getFullYear();
	var currentMonth = currentTime.getMonth() + 1;

	var elements = {
			name:					"home_occupancy",
			ownProperty:			"home_occupancy_ownProperty",
			principalResidence:		"home_occupancy_principalResidence",
			whenMovedInYear:		"home_occupancy_whenMovedIn_year",
			whenMovedInMonth:		"home_occupancy_whenMovedIn_month",
			howOccupied:			"#home_occupancy_howOccupied",
			whenMovedInYearRow:		".whenMovedInYear",
			whenMovedInMonthRow:	".whenMovedInMonth",
			howOccupiedRow:			".howOccupied",
			coverType:				"#home_coverType",
			underFinanceRow:		".underFinanceRow"

	};

	function isPrincipalResidence() {
		if($('input:radio[name='+elements.principalResidence+']:checked').val() == "Y"){
			return true;
		}
		else if($('input:radio[name='+elements.principalResidence+']:checked').val() == "N"){
			return false;
		}
		else {
			return null;
		}
	}

	function toggleUnderFinanceQuestion() {
		var selectdCoverType = $(elements.coverType).val();

		if (selectdCoverType == 'Contents Cover Only') {
			$(elements.underFinanceRow).hide();

		} else {
			$(elements.underFinanceRow).show();

		}
	}

	/* Here you put all functions for use in your module */
	function togglePropertyOccupancyFields(speed) {

		var ownProperty = $('input:radio[name='+elements.ownProperty+']:checked').val();
		var howOccupied =  $(elements.howOccupied).find('option:selected').val();
		var isItPrincipalResidence = isPrincipalResidence();
		var $howOccupied = $(elements.howOccupied);
		if (isItPrincipalResidence === null || (!isItPrincipalResidence && (typeof ownProperty == 'undefined' || ownProperty == "N"))){
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

		var monthField = $('#'+elements.whenMovedInMonth);
		var numberOfMonths = 12;

		if(selectedYear == currentYear) {
			numberOfMonths = currentMonth;
		}
		if(selectedYear >= (currentYear - 2)) {
			$(elements.whenMovedInMonthRow).slideDown(speed);
			monthField.find('option').show();
			for(var i = 12; i > numberOfMonths ; i--) {
				monthField.find('[value="'+i+'"]').hide();
			}
		} else {
			$(elements.whenMovedInMonthRow).slideUp(speed);
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

			$(elements.coverType).on('blur', function() {
				toggleUnderFinanceQuestion();

			});
		});
	}
	/* main entrypoint for the module to run first */
	function initHomeOccupancy() {
		if(!initialised) {
			initialised = true;
			log("[HomeOccupancy] Initialised"); //purely informational
			applyEventListeners();
			togglePropertyOccupancyFields(0);
			toggleUnderFinanceQuestion();
		}
	}

	function setupButtonTileDropdownSelectors() {
		var occupiedTypeItems = meerkat.modules.home.getHomeUnitsItems($(elements.howOccupied)),
			businessTypeItems = meerkat.modules.home.getHomeUnitsItems($('#home_businessActivity_businessType'), true),
			settings = [{
				$container: $('#hasOccupiedContainer'),
				items: occupiedTypeItems[meerkat.modules.home.getPropertyType()],
				maxRadioItems: 5
			}, {
				$container: $('#businessTypeContainer'),
				items: businessTypeItems
			}];

		meerkat.modules.buttonTileDropdownSelector.initButtonTileDropdownSelector(settings);
	}

	meerkat.modules.register('homeOccupancy', {
		initHomeOccupancy: initHomeOccupancy, //main entrypoint to be called.
		events: moduleEvents,
		isPrincipalResidence : isPrincipalResidence, //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
		setupButtonTileDropdownSelectors: setupButtonTileDropdownSelectors
	});

})(jQuery);

