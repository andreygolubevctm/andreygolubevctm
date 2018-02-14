/**
 * tripType module provides a common interface to retrieve current trip type selections.
 */
;(function($){

	var meerkat = window.meerkat;

	var optins = {
		cruise : {
			$e : null,
			$eHidden : null,
			label : "Cruising",
			value : "cruising",
			active : false
		},
		snow : {
			$e : null,
			$eHidden : null,
			label : "Snow sports",
			value : "snowSports",
			active : false
		},
		adventure : {
			$e : null,
			$eHidden : null,
			label: "Adventure sports",
			value : "adventureSports",
			active : false
		}
	};

	function init(){
		$(document).ready(function(){
			optins.cruise.$e = $('#travel_tripType_cruising_uiElement');
			optins.cruise.$eHidden = $('#travel_tripType_cruising');
			optins.snow.$e = $('#travel_tripType_snowSports_uiElement');
			optins.snow.$eHidden = $('#travel_tripType_snowSports');
			optins.adventure.$e = $('#travel_tripType_adventureSports_uiElement');
			optins.adventure.$eHidden = $('#travel_tripType_adventureSports');
			optins.cruise.$e.trigger("change.triptype");
			_addEventListener();
			// Used primarily for a preload or retrieve quote/email
			_updateActiveStateFromPrefill();
		});
	}

	function _addEventListener() {
		// In normal journey
		// Add a change event to the inputs to update active flags (used on the results page for the icons)
		optins.cruise.$e.add(optins.snow.$e).add(optins.adventure.$e)
		.off("change.triptype").on("change.triptype",function() {
			setActiveFlags();
		});

		// User selects a trip type
		$('.trip_type input').click(function () {
			toggleActiveState($(this));
		});
	}

	// param: Selected Trip Type element
	function toggleActiveState($selectedTripType) {
		// Get value of tripType from attr on selected element
		var tripTypeValue = $selectedTripType.attr('tripType');
		if ($selectedTripType.closest('label').hasClass('active')) {
			// Set the value of the hidden field next to the selected trip type
			$selectedTripType.siblings(':hidden').val('');
			// Set active state on the input
			$selectedTripType.closest('label').removeClass('active');
			$selectedTripType.prop('checked', false);

		} else {
			// Set the value of the hidden field next to the selected trip type
			$selectedTripType.siblings(':hidden').val(tripTypeValue);
			// Set active state on the input
			$selectedTripType.closest('label').addClass('active');
			$selectedTripType.prop('checked', true);

		}
		// Update the active flag on the object (used on the results page for the icons)
		setActiveFlags();

	}

	// Check the value of the hidden field, if it matches the correct value, toggle the active State on the ui element
	function _updateActiveStateFromPrefill() {
		if (optins.cruise.$eHidden.val() == optins.cruise.value) toggleActiveState(optins.cruise.$e);
		if (optins.snow.$eHidden.val() == optins.snow.value) toggleActiveState(optins.snow.$e);
		if (optins.adventure.$eHidden.val() == optins.adventure.value) toggleActiveState(optins.adventure.$e);
	}

	function setActiveFlags() {
		optins.cruise.active = optins.cruise.$e.is(":checked");
		optins.snow.active = optins.snow.$e.is(":checked");
		optins.adventure.active = optins.adventure.$e.is(":checked");
	}

	function exists() {
		return optins.cruise.active || optins.snow.active || optins.adventure.active;
	}

	function get() {
		return optins;
	}

	meerkat.modules.register('tripType', {
		init: init,
		get: get,
		exists: exists
	});

})(jQuery);
