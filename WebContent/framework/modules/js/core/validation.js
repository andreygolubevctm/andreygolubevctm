;(function($, undefined){

	var meerkat = window.meerkat;

	var events = {
		validation: {

		}
	};

	var $form= null;

	function init(){
		jQuery(document).ready(function($) {
			$form = $("#mainform");
		});
		$.validator
			.addMethod(
			"personName", validatePersonName, "Please enter alphabetic characters only. " +
			"Unfortunately, international alphabetic characters, numbers and symbols are not " +
			"supported by many of our partners at this time."
		);
	}

	var validNameCharsRegex = /^([a-zA-Z .'\-,]*)$/;
	var isUrlRegex = /(?:[^\s])\.(com|co|net|org|asn|ws|us|mobi)(\.[a-z][a-z])?/;

	// Name is alpha and .'\-, only with no foreign characters as providers don't support them
	// Ensures that an email address or URL is not being entered
	//
	function validatePersonName(value) {
		var isURL = value.match(isUrlRegex) !== null;
		return !isURL && validNameCharsRegex.test(value);
	}

	function setMinAgeValidation($field, ageMin, title) {
		$field.rules('add', {
			messages: {
				min_DateOfBirth: title + ' age cannot be under ' + ageMin
			},
			min_DateOfBirth: {
				ageMin: ageMin
			}
		} );

	}

	function isValid( $element, displayErrors ){
		if( displayErrors ){
			return $element.valid();
		}
		return $form.validate().check( $element );
	}

	function setupDefaultValidationOnForm( $formElement ){

		$formElement.validate({
			submitHandler: function(form) {
				form.submit();
			},
			invalidHandler: function(form, validator) {

				if (!validator.numberOfInvalids()) return;
				if(jQuery.validator.scrollingInProgress) return;

				var $ele = $(validator.errorList[0].element),
					$parent = $ele.closest('.row-content, .fieldrow_value');


				if($ele.attr('data-validation-placement') !== null && $ele.attr('data-validation-placement') !== ''){
					$ele2 = $($ele.attr('data-validation-placement'));
					if ($ele2.length > 0) $ele = $ele2;
				}

				/** If the element has a row parent (where the error message gets inserted to), then scroll to that instead **/
				if ($parent.length > 0) $ele = $parent;
				jQuery.validator.scrollingInProgress = true;
				meerkat.modules.utils.scrollPageTo($ele,500,-50, function(){
					jQuery.validator.scrollingInProgress = false;
				});
			},
			ignore: ':hidden,:disabled',
			//wrapper: 'li',
			meta: 'validate',
			debug: true,
			errorClass: 'has-error',
			validClass: 'has-success',
			errorPlacement: function ($error, $element) {
				/** Inline validation
					An error message placeholder will be injected above the form element, generally inside the parent .row-content
				**/

				var $referenceElement = $element;
				if($element.attr('data-validation-placement') !== null && $element.attr('data-validation-placement') !== ''){
					$referenceElement = $($element.attr('data-validation-placement'));
				}

				var parent = $referenceElement.closest('.row-content, .fieldrow_value');

				if(parent.length === 0) parent = $element.parent();

				var errorContainer = parent.children('.error-field');

				if (errorContainer.length === 0) {
					parent.prepend('<div class="error-field"></div>');
					errorContainer = parent.children('.error-field');
					errorContainer.hide().slideDown(100);
				}
				errorContainer.append($error);
			},
			onkeyup: function(element) {
				var element_id = jQuery(element).attr('id');
				if ( !this.settings.rules.hasOwnProperty(element_id) || !this.settings.rules[element_id].onkeyup) {
					return;
				}

				if (validation && element.name !== "captcha_code") {
					this.element(element);
				}
			},
			onfocusout: function(element, event) {
				/** Autocomplete-specific rule: do not perform validation if the autocomplete menu is open.
					This prevents the issue of focus leaving the input when clicking a menu option which triggers validation and reports an error on the input.
				**/
				var $ele = $(element);
				if ($ele.hasClass('tt-query')) {
					var $menu = $ele.nextAll('.tt-dropdown-menu');
					if ($menu.length > 0 && $menu.first().is(':visible')) {
						return false;
					}
				}

				/** Call the default onfocusout **/
				$.validator.defaults.onfocusout.call(this, element, event);
			},
			highlight: function( element, errorClass, validClass ) {
				/** console.log('highlight', element); **/

				/** Apply correct classes to element **/
				if (element.type === "radio") {
					this.findByName(element.name).addClass(errorClass).removeClass(validClass);
				} else {
					$(element).addClass(errorClass).removeClass(validClass);
				}

				/** Apply correct classes to row **/
				var $wrapper = $(element).closest('.row-content, .fieldrow_value');
				$wrapper.addClass(errorClass).removeClass(validClass);

				/** If the error container is not visible, show it.
					Delay/animation is used to return back to the event loop so that interactions still behave nicely
						e.g. you're focused into an input, then click on a radio button - if an error message appeared immediately your click could miss the radio.
				**/
				var errorContainer = $wrapper.find('.error-field');
				if (errorContainer.find('label:visible').length === 0) {
					if (errorContainer.is(':visible')) {
						errorContainer.stop();
					}
					errorContainer.delay(10).slideDown(100);
					/** console.log('error-field slideDown()'); **/
				}
			},
			unhighlight: function( element, errorClass, validClass ) {
				return this.ctm_unhighlight( element, errorClass, validClass );
			}
		});
	}


	meerkat.modules.register("validation", {
		init: init,
		events: events,
		isValid: isValid,
		setupDefaultValidationOnForm: setupDefaultValidationOnForm,
		validatePersonName: validatePersonName,
		setMinAgeValidation: setMinAgeValidation
	});

})(jQuery);

jQuery.fn.extend({
	isValid: function( displayErrors ) {
		return meerkat.modules.validation.isValid( $(this), displayErrors );
	}
});