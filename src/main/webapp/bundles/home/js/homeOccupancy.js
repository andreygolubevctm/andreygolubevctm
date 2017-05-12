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
			lookingForLandlord: 	".lookingForLandlord",
			validRentalLease: 		".validRentalLease",
			pendingRentalLease: ".pendingRentalLease"
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
		if($(elements.howOccupied).val() === "Rented to tenants") {
			return true;
		} else {
			return false;
		}
	}

	function toggleLookingForLandlord(speed) {
		var $landlordField = $(elements.lookingForLandlord);

		if (isHomeRented()) {
			$landlordField.slideDown(speed);
		} else {
			$landlordField.slideUp(speed);
		}
		toggleLandlords();
	}

	function toggleLandlords() {
		var landlordSwitch = $(elements.lookingForLandlord + ' input:radio:checked').val();
		if(meerkat.site.isLandlord || (landlordSwitch === 'Y' && !meerkat.site.isLandlord && isHomeRented())) {
			meerkat.site.isLandlord = true;
			meerkat.modules.home.toggleLandlords();
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
				$(elements.lookingForLandlord).slideUp(speed);
				$(elements.howOccupiedRow).slideUp(speed);
				$(elements.whenMovedInYearRow).slideDown(speed);
				yearSelected(speed);
			} else {
				if (isHomeRented()) {
					$(elements.lookingForLandlord).slideDown(speed);
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
			$(elements.howOccupied).on('change', function() {
				toggleLookingForLandlord();
			});

			$('#'+elements.whenMovedInYear).on('change', function() {
				yearSelected();
			});

			$('input[name='+elements.name+'_ownProperty], '+elements.howOccupied).on('change', function() {
				togglePropertyOccupancyFields();
			});

			$(elements.lookingForLandlord + ' input:radio').on('change', function() {
				toggleLandlords();
			});

			$(elements.validRentalLease + ' input:radio').on('change', function() {
				togglePendingRentalLease();
			});

			$('input[name='+elements.principalResidence+']').on('change', function() {
				togglePropertyOccupancyFields();
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
			toggleLookingForLandlord(0);
			togglePendingRentalLease(0);
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
