/*
 This module supports the Sorting for travel results page.
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		$travel_adults,
		$adult_dob_2;

	function initAdultAges() {
		$(document).ready(function travelSortingInitDomready() {
			$travel_adults = $('#travel_adults'),
			$adult_dob_2 = $('.second_traveller_age_row');
			$adult_dob_2.hide();

			initEventListeners();
		});
	}

	function initEventListeners() {
		var isIe8 = meerkat.modules.performanceProfiling.isIE8(), showMethod = isIe8 ? 'show' : 'slideDown', hideMethod = isIe8 ? 'hide' : 'slideUp';
		$travel_adults.off().on("change", function changeAdultCount() {
			if ($(this).val() == 2) {
				$adult_dob_2[showMethod]();
			} else {
				$adult_dob_2[hideMethod]();
			}
		});
	}

	function updateHiddenField() {
		var numAdults = $('#travel_adults').val(),
			adultDOBs = new Array(numAdults);

		for (var i = 0; i < numAdults; i++) {
			adultDOBs[i] = $('#travel_travellers_traveller'+(i+1)+'DOB').val();
		}

		$('#travel_travellers_travellersDOB').val(adultDOBs.join(','));
	}

	meerkat.modules.register('travelAdultAges', {
		initAdultAges: initAdultAges,
		updateHiddenField: updateHiddenField
	});

})(jQuery);