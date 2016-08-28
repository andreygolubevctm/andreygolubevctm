/*
 This module supports the Sorting for travel results page.
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		$travel_party,
		$travel_adults,
		$adult_dob_2_row,
		$adult_dob_2,
		$single_parent,
		$single_parent_row,
		$children_row;

	function initAdultAges() {
		$(document).ready(function travelSortingInitDomready() {
			$travel_party = $('.travel_party'),
			$travel_adults = $('#travel_adults'),
			$adult_dob_2_row = $('.second_traveller_age_row'),
			$adult_dob_2 = $('#travel_travellers_traveller2DOB');

			$travel_party.find('label:nth-child(1)').addClass('icon-single');
			$travel_party.find('label:nth-child(2)').addClass('icon-couple');
			$travel_party.find('label:nth-child(3)').addClass('icon-family');

			$single_parent = $('.single_parent');
			$single_parent_row = $('.single_parent_row');
			$children_row = $('.children_row');

			initEventListeners();
		});
	}

	function initEventListeners() {
		var isIe8 = meerkat.modules.performanceProfiling.isIE8(), showMethod = isIe8 ? 'show' : 'slideDown', hideMethod = isIe8 ? 'hide' : 'slideUp';
		$travel_party.off().on("change", function changeAdultCount() {
			var selected = $(this).find("input[type='radio']:checked").val();
			if (selected === "S") {
				$adult_dob_2_row[hideMethod]();
				$single_parent_row[showMethod]();
				$single_parent.trigger("change");
				$travel_adults.val(1);
			} else if (selected === "C") {
				$adult_dob_2_row[showMethod]();
				$children_row[hideMethod]();
				$('#travel_childrenSelect').val(0);
				$single_parent_row[hideMethod]();
				$travel_adults.val(2);
			} else if (selected === "F") {
				$adult_dob_2_row[showMethod]();
				$children_row[showMethod]();
				$single_parent_row[hideMethod]();
				$travel_adults.val(2);
			}
		});

		$travel_party.trigger("change");

		$single_parent.off().on("change", function showSingleParent() {
			var selected = $(this).find("input[type='radio']:checked").val();
			if (selected === "Y") {
				$children_row[showMethod]();
			} else {
				$children_row[hideMethod]();
			}
		});

	}

	function updateHiddenField() {
		var totalAdults = parseInt($('#travel_adults').val()),
			numAdults = 0,
			numChildren = parseInt($('#travel_childrenSelect').val()),
			adultDOBs = [numAdults];

		for (var i = 0; i < totalAdults; i++) {
			var dob = $('#travel_travellers_traveller'+(i+1)+'DOB').val();
			// Family can have 1 or 2 adults
			if(dob !== '') {
				adultDOBs[i] = $('#travel_travellers_traveller'+(i+1)+'DOB').val();
				numAdults += 1;
			}
		}

        if(isNaN(numChildren)) {
        	numChildren = 0;
        }

		$('#travel_travellers_travellersDOB').val(adultDOBs.join(','));

		$('#travel_adults').val(numAdults);
		$('#travel_children').val(numChildren);
	}

	meerkat.modules.register('travelAdultAges', {
		initAdultAges: initAdultAges,
		updateHiddenField: updateHiddenField
	});

})(jQuery);