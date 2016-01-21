/*
 This module supports the Sorting for travel results page.
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		$travel_party,
		$travel_adults,
		$adult_dob_2,
		$children_row;

	function initAdultAges() {
		$(document).ready(function travelSortingInitDomready() {
			$travel_party = $('.travel_party'),
			$travel_adults = $('#travel_adults'),
			$adult_dob_2 = $('.second_traveller_age_row');

			$adult_dob_2.hide();
			$children_row = $('.children_row');
			$children_row.hide();

			initEventListeners();
		});
	}

	function initEventListeners() {
		var isIe8 = meerkat.modules.performanceProfiling.isIE8(), showMethod = isIe8 ? 'show' : 'slideDown', hideMethod = isIe8 ? 'hide' : 'slideUp';
		$travel_party.off().on("change", function changeAdultCount() {
			var selected = $(this).find("input[type='radio']:checked").val();
			if (selected === "S") {
				$adult_dob_2[hideMethod]();
				$children_row[hideMethod]();
				$travel_adults.val(1);
			} else if (selected === "C") {
				$adult_dob_2[showMethod]();
				$children_row[hideMethod]();
				$travel_adults.val(2);
			} else if (selected === "F") {
				$adult_dob_2[showMethod]();
				$children_row[showMethod]();
				$travel_adults.val(2);
			}
		});
	}

	function updateHiddenField() {
		var numAdults = parseInt($('#travel_adults').val()),
			numChildren = parseInt($('#travel_childrenSelect').val()),
			adultDOBs = [numAdults];

		for (var i = 0; i < numAdults; i++) {
			adultDOBs[i] = $('#travel_travellers_traveller'+(i+1)+'DOB').val();
		}

		$('#travel_travellers_travellersDOB').val(adultDOBs.join(','));

		$('#travel_children').val(numChildren);
	}

	meerkat.modules.register('travelAdultAges', {
		initAdultAges: initAdultAges,
		updateHiddenField: updateHiddenField
	});

})(jQuery);