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
	log = meerkat.logging.info,
	meerkatEvents = meerkat.modules.events;

	var events = {
			sliders: {
			EVENT_UPDATE_RANGE: 'EVENT_UPDATE_RANGE',
			EVENT_SET_VALUE : 'SET_VALUE'
		}
	};

	var moduleEvents = events.sliders;

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

			var serialization = null;

			range = {
				'min': Number(range[0]),
				'max': Number(range[1])
			};

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
					$field.val(value);
				};

				serialization = {
					lower: [
						$.Link({
							target:customSerialise,
							format: {
								decimals: 0
							}
						})
					]
				};

			}
			if ('price' === type) {
				// Hidden field within the main form
				$field = $('#health_filter_priceMin');

				// Get the value from the field e.g. set by load quote
				if ($field.length > 0 && $field.val().length > 0) {
					initialValue = $field.val();
				}

				customSerialise = function(value, handleElement, slider ) {
					if (value <= range.min) {
						$field.val(0);
						$selection.text('All prices');
					} else {
						$field.val(value);
						$selection.text('from $' + value );
					}
				};

				serialization = {
					lower: [
						$.Link({
							target:customSerialise,
							format: {
								decimals: 0,
								encoder: function( value ){
									value = Math.round(value);
									return Math.floor(value / 5) * 5;
								}
							}
						})
					]
				};


				// When the frequency filter is modified, update the price slider to reflect
				update =  function(event, min, max, isUpdateFrequency) {
					var oldMin = range.min;
					var oldMax = range.max;
					var oldValue = $field.val();

					$slider.val(oldValue);

					range = {
						'min': min,
						'max': max
					};

					// Apply the new range
					// 1% is to handle starting at 0
					changeRange($slider, {
						'min': 0,
						'1%': min,
						'max': max
					}, true);

					//calculate only on updateFrequency
					if (isUpdateFrequency) {
						//If the value of the slider was previously at the minimum, keep the value at the new minimum
						if (oldValue == oldMin || oldValue == '0') {
							$slider.val(0);
						} else if (oldValue == oldMax) {
							//If the value of the slider was previously at the maximum, keep the value at the new maximum
							$slider.val(range.max);
						} else {
							// work out where the slider should be based off the previous selection
							var percentSelected = (oldValue - oldMin) / (oldMax - oldMin);
							var newValue = range.min + ((range.max - range.min) * percentSelected);
							$slider.val(newValue);
						}
					}
				};
			}

			//
			// Apply events
			//
			if (typeof update === 'function') {
				$(this).on(moduleEvents.EVENT_UPDATE_RANGE, update);
			}
			$slider.on(moduleEvents.EVENT_SET_VALUE, function(event, value) {
				setValue($slider, value);
			});

			//
			// Init the slider plugin
			//
			$slider.noUiSlider({
				range: range,
				step: 1,
				start: [initialValue],
				serialization: serialization,
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
		init: initModule,
		events: events
	});

})(jQuery);
