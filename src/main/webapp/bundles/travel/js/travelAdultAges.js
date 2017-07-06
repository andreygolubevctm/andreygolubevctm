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

			$travel_party.find('label:nth-child(1)').addClass('icon-single');
			$travel_party.find('label:nth-child(2)').addClass('icon-couple');
			$travel_party.find('label:nth-child(3)').addClass('icon-family');
			$travel_party.find('label:nth-child(4)').addClass('icon-group-travel');

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
				$single_parent_row[showMethod]();
				$single_parent.trigger("change");
				$travel_adults.val(1);
			} else if (selected === "C") {
				$children_row[hideMethod]();
				$('#travel_childrenSelect').val(0);
				$single_parent_row[hideMethod]();
				$travel_adults.val(2);
			} else if (selected === "F") {
				$children_row[showMethod]();
				$single_parent_row[hideMethod]();
				$travel_adults.val(2);
			} else if(selected === "G") {
				$children_row[hideMethod]();
				$single_parent_row[hideMethod]();
				$('#travel_childrenSelect').val(0);
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
				numAdults = $('.age-container input').length,
				numChildren = parseInt($('#travel_childrenSelect').val()) || 0;
				
		$('#travel_adults').val(numAdults);
		$('#travel_children').val(numChildren);
	}

	meerkat.modules.register('travelAdultAges', {
		initAdultAges: initAdultAges,
		updateHiddenField: updateHiddenField
	});

})(jQuery);