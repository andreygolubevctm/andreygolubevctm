;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var init = function() {

	};

	var outputValidationErrors = function(options) {
		"use strict";
		handleServerSideValidation(options);
		triggerErrorContainer();
	};

	var handleServerSideValidation = function(options) {

		var matches = null;
			var erroredElements = [];

			for(var i=0; i<options.validationErrors.length; i++){

				var error = options.validationErrors[i];

				var partialName = error.elementXpath.replace(/\//g, "_");
				matches = $(":input[name$='" + partialName	+ "']");

				if (matches.length === 0 && error.elements !== "") {

					// Didn't find the element, try more attempts...

					var elements = error.elements.split(",");
					for(var x = 0; x < elements.length; x++){
						var fieldName = partialName + "_" + $.trim(elements[x]);

						matches = $('input[name*="' + fieldName + '"]');
						if(matches.length === 0) matches = $('input[id*="' + fieldName + '"]');	// Try finding by ID.

					}

				}

				for(var b=0;b<matches.length;b++){
					var element = matches[b];
					erroredElements.push(element);
					var $element = $(element);
					$(element).parent().removeClass("has-success");
					$(element).parent().addClass("has-error");

					//Inline validation
					//An error message placeholder will be injected above the form element, generally inside the parent .row-content

					var $referenceElement = $element;
					if($element.attr('data-validation-placement') !== null && $element.attr('data-validation-placement') !== ''){
						$referenceElement = $($element.attr('data-validation-placement'));
					}

					var parent = $referenceElement.closest('.row-content, .fieldrow_value');

					if(parent.length === 0) parent = $element.parent();

					var errorContainer = parent.children('.error-field');

					// FYI error.message == "ELEMENT REQUIRED" || INVALID VALUE
					var message = "invalid field";
					if(error.message === "ELEMENT REQUIRED") {
						message = "This field is required.";
					}
					if (errorContainer.length === 0) {
						parent.prepend('<div class="error-field"></div>');
						errorContainer = parent.children('.error-field');
						errorContainer.hide().slideDown(100);
					}
					errorContainer.append(message);
				}


			}

			if(matches.length > 0){
				// TODO - Decide what to do here,
				// eg: work out which slide to navigate to, also should we display a message to the user as the error may be unrecoverable?
				if(typeof options.startStage === 'undefined') {
					options.startStage = 'start';
				}
				// meerkat.modules.journeyEngine.gotoPath(options.startStage);
				meerkat.modules.address.setHash(options.startStage);
			}
	};

	var triggerErrorContainer =  function() {
		if(typeof FormElements != 'undefined'){
			if( !FormElements.errorContainer.is(':visible') && FormElements.errorContainer.find('li').length > 0 ) {
				FormElements.rightPanel.addClass('hidden');
				FormElements.errorContainer.show();
				FormElements.errorContainer.find('li').show();
				FormElements.errorContainer.find('li .error').show();
			}
		}
	};

	meerkat.modules.register("serverSideValidationOutput", {
		init: init,
		outputValidationErrors: outputValidationErrors
	});

})(jQuery);