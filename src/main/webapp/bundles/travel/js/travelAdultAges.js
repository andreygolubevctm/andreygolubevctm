/*
 This module supports the Sorting for travel results page.
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		$travel_party,
		$travel_adults,
		$single_parent,
		$single_parent_row,
		$children_row,
		$travellerNumControls,
		isIe8 = meerkat.modules.performanceProfiling.isIE8(),
        showMethod = isIe8 ? 'show' : 'slideDown',
        hideMethod = isIe8 ? 'hide' : 'slideUp';

	function initAdultAges() {
		$(document).ready(function travelSortingInitDomready() {
			$travel_party = $('.travel_party');
			$travel_adults = $('#travel_adults');
            $travellerNumControls= $('.traveller-num-controls');

			$travel_party.find('label:nth-child(1)').addClass('icon-single');
			$travel_party.find('label:nth-child(2)').addClass('icon-single-family');
			$travel_party.find('label:nth-child(3)').addClass('icon-couple');
			$travel_party.find('label:nth-child(4)').addClass('icon-family');
			$travel_party.find('label:nth-child(5)').addClass('icon-group-travel');

			$single_parent = $('.single_parent');
			$single_parent_row = $('.single_parent_row');
			$children_row = $('.children_row');

			initEventListeners();
		});
	}
	
	function _handleTravelPartyChange() {
			var selected = $(this).find("input[type='radio']:checked").val();
			switch(selected) {
				case 'S':
                    $children_row[hideMethod]();
					$single_parent_row[showMethod]();
					$travellerNumControls[hideMethod]();
                    $single_parent.find("#travel_singleParent_N").prop('checked', true).trigger('change');
					$travel_adults.val(1);
                    $('#travel_childrenSelect').val("");
					break;
				case 'C':
					$children_row[hideMethod]();
					$('#travel_childrenSelect').val("");
					$single_parent_row[hideMethod]();
                    $travellerNumControls[hideMethod]();
                    $travel_adults.val(2);
					break;
				case 'SF':
					$children_row[showMethod]();
					$single_parent_row[hideMethod]();
                    $travellerNumControls[hideMethod]();
                    $travel_adults.val(1);
					break;
				case 'F':
					$children_row[showMethod]();
					$single_parent_row[hideMethod]();
                    $travellerNumControls[hideMethod]();
                    $travel_adults.val(2);
					break;
				case 'G':
					$children_row[hideMethod]();
					$single_parent_row[hideMethod]();
                    $travellerNumControls[showMethod]();
                    $('#travel_childrenSelect').val("");
					break;
				default:
                    $single_parent_row[hideMethod]();
                    $children_row[hideMethod]();
                    $travellerNumControls[hideMethod]();

			}
	}

	function initEventListeners() {
		$travel_party.off().on("change", _handleTravelPartyChange);

		$travel_party.trigger("change");

		$single_parent.off().on("change", function showSingleParent() {
			var selected = $(this).find("input[type='radio']:checked").val();
			if (selected === "Y") {
                $travel_party.find('.icon-single-family input').prop('checked', true).trigger('change');
			}
		});

	}

	function updateHiddenField() {
		var numAdults = $('.age-container input').length,
			numChildren = parseInt($('#travel_childrenSelect').val()) || 0;
				
		$('#travel_adults').val(numAdults);
		$('#travel_children').val(numChildren);
	}

	meerkat.modules.register('travelAdultAges', {
		initAdultAges: initAdultAges,
		updateHiddenField: updateHiddenField
	});

})(jQuery);