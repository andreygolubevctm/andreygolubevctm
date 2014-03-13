/**
* Copyright Compare the Market 2014

FEATURES:
	- Sets up slider UI components. Companion js to field_new:slider.

	You can read (or set) the current value of a slider with $('.slider-control .slider').val()
	Alternatively you can use the serialisation to automatically push the value to where you need it. By default it will serialise into a hidden input field.

ELEMENT EVENTS:
	- SET_VALUE
		$('.slider-control').trigger('SET_VALUE', [100]);
	- UPDATE
		Depending on the type of slider, an UPDATE event will be available on the .slider-control
		For example, a price filter slider will know how to update itself based on other parameters in the application.

*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	/* Constants */
	var EVENT_UPDATE = 'UPDATE',
		EVENT_SET_VALUE = 'SET_VALUE';



	function initModule() {
		$(document).ready( initSliders );
	}

	function initSliders() {
		// Check noUiSlider is available
		if (typeof $.fn.noUiSlider !== 'function') {
			log('[sliders.js]', 'noUiSlider plugin is not available.');
			return;
		}

		$('.slider-control').each(function() {
			var $controller = $(this),
			$slider			= $controller.find('.slider'),
			$field			= $controller.find('input'),
			$selection		= $controller.find('.selection'),
			initialValue	= $slider.data('value'),
			range			= $slider.data('range').split(','),
			markerCount		= $slider.data('markers'),
			legend			= $slider.data('legend').split(','),
			type			= $slider.data('type');

			var customSerialise,
				update = false;

			// Default code when serialisation occurs: update selected value display
			customSerialise = function(value) {
				$selection.text(value);
			};

			//
			// Overrides per filter type
			//
			if ('excess' === type) {
				// Hidden field within the main form
				$field = $('#health_excess');

				// Get the value from the field e.g. set by load quote
				if ($field.length > 0 && $field.val().length > 0) {
					initialValue = $field.val();
				}

				customSerialise = function(value) {
					if (value > 0 && value <= legend.length) {
						$selection.text(legend[value-1]);
					}
					else {
						$selection.text(' ');
					}
				}
			}
			if ('price' === type) {
				// Hidden field within the main form
				$field = $('#health_filter_priceMin');

				// Update the value range based on various parameters
				update = function() {
					var coverType,
						productCategory,
						oldRange = range,
						oldValue = $slider.val();

					coverType = $("#health_situation_healthCvr").val();
					productCategory = meerkat.modules.healthBenefits.getProductCategory();

					if (coverType == 'S') {
						//$(priceMinSlider.$_obj).removeClass('multi');
						switch (productCategory) {
							case 'GeneralHealth':
								range = [0,80]; break;
							case 'Hospital':
								range = [25,185]; break;
							case 'Combined':
								range = [50,280]; break;
							default:
								// The default from PHIO Outbound is Hospital, so match the max to it
								range = [0,185];
						}
					}
					else {
						// C, SP, F
						//$(priceMinSlider.$_obj).addClass('multi');
						if (coverType == 'C') {
							switch (productCategory) {
								case 'GeneralHealth':
									range = [25,160]; break;
								case 'Hospital':
									range = [50,370]; break;
								case 'Combined':
									range = [100,560]; break;
								default:
									range = [0,370];
							}
						}
						else if (coverType == 'SPF') {
							switch (productCategory) {
								case 'GeneralHealth':
									range = [25,155]; break;
								case 'Hospital':
									range = [75,350]; break;
								case 'Combined':
									range = [100,550]; break;
								default:
									range = [0,350];
							}
						}
						else {
							switch (productCategory) {
								case 'GeneralHealth':
									range = [25,160]; break;
								case 'Hospital':
									range = [100,375]; break;
								case 'Combined':
									range = [125,560]; break;
								default:
									range = [0,375];
							}
						}
					}

					// Apply the new range
					changeRange($slider, range);

					// If the value of the slider was previously at the minimum, keep the value at the new minimum
					if (oldValue == oldRange[0]) {
						$slider.val(range[0]);
					}
				}

				customSerialise = function(value) {
					var frequency,
						rebate,
						rebateFactor,
						frequencyFactor;

					if (1*value === 0) {
						$selection.text('All prices');
					}
					else {
						try {
							// Get value from frequency filter
							frequency = meerkat.modules.healthResults.getFrequencyInWords($('#filter-frequency input:checked').val());
						}
						catch(err) {}
						frequency = meerkat.modules.healthResults.getNumberOfPeriodsForFrequency(frequency);

						rebate = meerkat.modules.health.getRebate();

						rebateFactor = 1 - (rebate / 100);
						frequencyFactor = 12 / frequency;
						$selection.text('from $' + Math.round( (value * frequencyFactor) * rebateFactor) );
					}
				}

				// When the frequency filter is modified, update the price slider to reflect
				$('#filter-frequency input').on('change', update);
			}

			//
			// Apply events
			//
			if (typeof update === 'function') {
				$(this).on(EVENT_UPDATE, update);
			}
			$controller.on(EVENT_SET_VALUE, function(event, value) {
				setValue($slider, value);
			});

			//
			// Init the slider plugin
			//
			$slider.noUiSlider({
				range: range,
				handles: 1,
				step: 1,
				start: initialValue,
				serialization: {
					to: [[
						// Serialise to hidden field if present
						$field,
						// Custom serialise
						customSerialise
					]],
					resolution: 1
				},
				behaviour: 'extend-tap'
			});

			addMarkers($controller, markerCount);
			addLegend($controller, legend);
		});
	}

	// Add mark-up for the step markers
	function addMarkers($controller, markerCount) {
		var $htmls, $e, i;

		if (markerCount > 1) {
			markerCount = markerCount - 1;
			$htmls = $('<div />');
			for (i = 0; i < markerCount; i++) {
				$e = $('<div />');
				$e.addClass('slider-marker');
				$e.css('width', (100/markerCount) + '%');
				$htmls.append($e);
			}
			$htmls.find('.slider-marker:first').addClass('first');
			$htmls.find('.slider-marker').appendTo($controller.find('.noUi-base'));
		}
	}

	// Add legend
	function addLegend($controller, legendArray) {
		var $htmls, $e, i;

		if (legendArray.length > 1) {
			$htmls = $('<div />');
			for (i = 0; i < legendArray.length; i++) {
				$e = $('<div><span><b /></span></div>');
				$e.addClass('slider-legend');
				$e.css('width', (100/(legendArray.length - 1)) + '%');
				$e.find('b').text(legendArray[i]);
				$htmls.append($e);
			}
			$htmls.find('.slider-legend:first').addClass('first');
			$htmls.find('.slider-legend:last').addClass('last');
			$htmls.find('.slider-legend').appendTo($controller.find('.slider-legends'));
		}
	}

	// Sets the value range of a slider.
	// Param 'range' is an array [min, max]
	function changeRange($slider, range) {
		$slider.noUiSlider({
				range: range
			},
			true //makes noUiSlider refresh rather than init
		);

		// Re-apply markers (the marker DOM gets blown away when updating the slider range)
		var markerCount = $slider.data('markers');
		var $controller = $slider.closest('.slider-control');
		if (typeof markerCount !== 'undefined' && $controller.length > 0) {
			addMarkers($controller, markerCount);
		}
	}

	// Set the current value of the slider
	function setValue($slider, value) {
		$slider.val(value);
	}



	meerkat.modules.register('sliders', {
		init: initModule
	});

})(jQuery);
