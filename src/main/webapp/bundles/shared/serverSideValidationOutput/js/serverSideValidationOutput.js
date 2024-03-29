;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var init = function() {

	};

	var outputValidationErrors = function(options) {
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
				if (matches.length === 0 && !!error.elements) {
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
					$(element).parent()
						.removeClass("has-success")
						.addClass("has-error");

					//Inline validation
					//An error message placeholder will be injected above the form element, generally inside the parent .row-content

					var $referenceElement = $element;
					var dataValidationPlacementAttr = $element.attr('data-validation-placement');
					if(dataValidationPlacementAttr !== null && dataValidationPlacementAttr !== ''){
						$referenceElement = $(dataValidationPlacementAttr);
					}

					var parent = $referenceElement.closest('.row-content, .fieldrow_value');

					if(parent.length === 0) parent = $element.parent();

					var errorContainer = parent.children('.error-field');

					// FYI error.message == "ELEMENT REQUIRED" || INVALID VALUE
					var message = "invalid field";
					if(_.has(error,"message") && !_.isEmpty(error.message)) {
						if (error.message === "ELEMENT REQUIRED") {
							message = "This field is required.";
						} else { // Otherwise use the message provided
							message = error.message;
							var hasOmittableCopy = message.indexOf("value= '");
							// This additional text has been removed for UTL but need
							// to cater for other verticals
							if(hasOmittableCopy > 0) {
								message = message.substring(0, hasOmittableCopy);
							}
						}
					}
					if (!errorContainer.length) {
						parent.prepend('<div class="error-field"></div>');
						errorContainer = parent.children('.error-field')
							.hide()
							.slideDown(100);
					}
					errorContainer.append(message);
				}


			}
        meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK, {source: 'validationFailure'});
			if(matches.length > 0) {
				// eg: work out which slide to navigate to - will be the start or the slide with the first error field
				if(!_.has(options,"startStage") || !_.isEmpty(options.startStage)) {
					// If not provided then work out from the elements parent form
					options.startPage = $(matches[0]).closest("form").attr("id").slice(0,-4);
				}
				// If startPage doesn't represent a genuine slide then simply revert to Start
				if(_.isUndefined(meerkat.modules.journeyEngine.getStepIndex(options.startPage))){
					options.startPage = "start";
				}
                meerkat.modules.address.setHash(options.startStage);
			} else {
                meerkat.modules.errorHandling.error({
                    errorLevel:		'warning',
                    message:		"It looks like there was an issue with validation please check the form and try again.",
                    page:			"",
                    description:	"",
                    data:			options
                });
                meerkat.modules.address.setHash(options.startStage);
			}
	};

	var triggerErrorContainer =  function() {
		if(typeof FormElements != 'undefined'){
			if( !FormElements.errorContainer.is(':visible') && FormElements.errorContainer.find('li').length > 0 ) {
				FormElements.rightPanel.addClass('hidden');
				FormElements.errorContainer
					.show()
					.find('li')
					.show()
					.find('.error')
					.show();
			}
		}
	};

	meerkat.modules.register("serverSideValidationOutput", {
		init: init,
		outputValidationErrors: outputValidationErrors
	});

})(jQuery);