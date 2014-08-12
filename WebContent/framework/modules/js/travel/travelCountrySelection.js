/*
 *
 * Handling of the country selection
 *
*/
;(function($, undefined) {

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events,
	log = meerkat.logging.info,
	$countries;

	var $destinations,
		$destinationsCheckboxes;


	// If at least 1 checkbox is checked, set the hidden flag
	function updateCountries(){
		//Clear a previous error-field div
		var $errorField = $destinationsFieldset.find(".error-field");
		if ($errorField.length > 0) { $errorField.remove(); }

		//Set the hidden field to contain a 1 or nothing if we have checked boxes.
		if($destinationsFieldset.find('.destcheckbox:checked').length > 0){
			$destinations.val('1');
		}else{
			$destinations.val('');
		}

		$destinations.valid();
	}

	function initCountrySelection()
	{
		//Elements need to be in the page
		$(document).ready(function() {
			$destinationsFieldset = $('.travel_details_destinations');
			$destinations = $('#travel_destination');
			$destinationsCheckboxes = $('.destcheckbox');

			applyEventListeners();
		});
	}

	function applyEventListeners(){
		$destinationsCheckboxes.on('change', function(){
			meerkat.modules.travelCountrySelection.updateCountries();
		});
	}

	meerkat.modules.register("travelCountrySelection", {
		initCountrySelection: initCountrySelection,
		updateCountries: updateCountries
	});

})(jQuery);