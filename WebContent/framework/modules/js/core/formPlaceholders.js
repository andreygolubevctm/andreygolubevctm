/**
* Copyright Compare the Market 2014
*
* FEATURES:
* - Custom placeholder behaviour on input fields.
*
* USAGE:
* Add a 'data-placeholder-unfocused' attribute to input elements.
* <input type="text" data-placeholder-unfocused="Unfocused placeholder text">
*
* If a 'placeholder' attribute is present it will be shown when focus is given to the input.
*/

;(function($, undefined){

	var meerkat = window.meerkat;

	function initPlaceholders() {
		if (Modernizr.input.placeholder) {
			setUpUnfocused();
		}
	}

	function setUpUnfocused() {
		var $inputs = $('input[data-placeholder-unfocused]');
		$inputs.each(function eachInput() {
			var $element = $(this);

			// Keep original placeholders in a new data attribute.
			var original = '';
			if ($element.attr('placeholder')) {
				original = $element.attr('placeholder');
			}
			$element.attr('data-placeholder', original);

			// Replace placeholder
			$element.attr('placeholder', $element.attr('data-placeholder-unfocused'));

			// On focus, switch to original placeholder
			$element.on('focus.formPlaceholders.unfocused', function swapPlaceholderFocus() {
				$(this).attr('placeholder', $(this).attr('data-placeholder'));
			});

			// On blur, check if we should switch back to unfocused placeholder
			$element.on('blur.formPlaceholders.unfocused', function swapPlaceholderBlur() {
				if ($(this).val().length > 0)
					return;

				$(this).attr('placeholder', $(this).attr('data-placeholder-unfocused'));
			});
		});
	}



	meerkat.modules.register('formPlaceholders', {
		init: initPlaceholders
	});

})(jQuery);
