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
	var isNormalJourney = $('.isNormalJourney').length > 0;
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
			lookingForLandlord: 	".lookingForLandlord",
			validRentalLease: 		".validRentalLease",
			pendingRentalLease: ".pendingRentalLease",
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

	function isHomeRented() {
		return $(elements.howOccupied).val() === "Rented to tenants";
	}

	function homeOccupiedChange(speed) {
		var $landlordField = $(elements.lookingForLandlord);

		if (isHomeRented() && isNormalJourney) {
			$landlordField.slideDown(speed);
		} else {
			$landlordField.slideUp(speed);
			if (meerkat.site.isLandlord && isNormalJourney && !isHomeRented()) {
				meerkat.site.isLandlord = false;
				meerkat.modules.home.toggleLandlords();
			}
		}
	}

	function toggleLandlords() {
		var landlordSwitch = $(elements.lookingForLandlord + ' input:radio:checked').val();
		// Landlords is active, but the user said no to landlord journey OR home is not rented.
		if ((meerkat.site.isLandlord && landlordSwitch === 'N') || !isHomeRented()) {
			meerkat.site.isLandlord = false;
			meerkat.modules.home.toggleLandlords();

		// Landlords is active OR user wants to enable landlords.
		} else if (meerkat.site.isLandlord || (landlordSwitch === 'Y' && isHomeRented())) {
			meerkat.site.isLandlord = true;
			meerkat.modules.home.toggleLandlords();
			// hacky soultion to activate the radioBtn on for the first page
			$('.isLandlord #home_occupancy_ownProperty_Y').prop('checked', true).change();
		// Otherwise, disable landlords.
		} else {
			meerkat.site.isLandlord = false;
			meerkat.modules.home.toggleLandlords();

		}
	}

	function togglePendingRentalLease(speed) {
		var validRentalLease = $(elements.validRentalLease + ' input:radio:checked').val();
		var $pendingRental = $(elements.pendingRentalLease);
		if (validRentalLease === 'N') {
			$pendingRental.slideDown(speed);
		} else if(validRentalLease === 'Y' || validRentalLease == null) {
			$pendingRental.slideUp(speed);
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
		var isLandlord = meerkat.site.isLandlord;

		if ((isItPrincipalResidence === null || (!isItPrincipalResidence && (typeof ownProperty == 'undefined' || ownProperty == "N"))) && !isLandlord) {
			$(elements.howOccupiedRow).slideUp(speed);
			$(elements.whenMovedInYearRow+', '+elements.whenMovedInMonthRow).slideUp(speed);

		} else {
			if(isItPrincipalResidence){
				$(elements.lookingForLandlord).slideUp(speed);
				$(elements.howOccupiedRow).slideUp(speed);
				$(elements.whenMovedInYearRow).slideDown(speed);
				yearSelected(speed);
				if(isLandlord) {
					meerkat.site.isLandlord = false;
					meerkat.modules.home.toggleLandlords();
				}
			} else {
				if (isHomeRented() && !isLandlord) {
					$(elements.lookingForLandlord).slideDown(speed);
					if ($(elements.lookingForLandlord + ' input:checked').val() === "Y") {
						meerkat.site.isLandlord = true;
						meerkat.modules.home.toggleLandlords();
					}
				}
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
			$(elements.howOccupied).on('change', homeOccupiedChange);
			$('#'+elements.whenMovedInYear).on('change', yearSelected);
			$('input[name='+elements.name+'_ownProperty], '+elements.howOccupied).on('change', togglePropertyOccupancyFields);
			$(elements.lookingForLandlord + ' input:radio').on('change', toggleLandlords);
			$(elements.validRentalLease + ' input:radio').on('change', togglePendingRentalLease);
			$('input[name='+elements.principalResidence+']').on('change', togglePropertyOccupancyFields);
			$(elements.coverType).on('blur', toggleUnderFinanceQuestion);
		});
	}
	/* main entrypoint for the module to run first */
	function initHomeOccupancy() {
		if(!initialised) {
			initialised = true;
			log("[HomeOccupancy] Initialised"); //purely informational
			applyEventListeners();
			togglePropertyOccupancyFields(0);
			homeOccupiedChange(0);
			togglePendingRentalLease(0);
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
