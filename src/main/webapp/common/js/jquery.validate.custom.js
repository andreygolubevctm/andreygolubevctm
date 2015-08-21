if(typeof window.$ == 'undefined' && typeof window.jQuery !== 'undefined') {
	window.$ = jQuery;
}

// This doesn't seem to be needed as I can find references in the meerkat.modules side ie meerkat.modules.serverSideValidationOutput.outputValidationErrors
// Don't see this referenced in life and ip so could be a candidate for deprecation?
var ServerSideValidation = {
	outputValidationErrors : function(options) {
		"use strict";

		options.singleStage = typeof options.singleStage === 'undefined' ? false : options.singleStage;
		options.startStage = typeof options.startStage === 'undefined' ? 0 : options.startStage;
		options.isAccordian = typeof options.isAccordian === 'undefined' ? false : options.isAccordian;
		options.maxSlide = typeof options.maxSlide === 'undefined' ? 100 : options.maxSlide;

		if( typeof slide_callbacks !== "undefined"){


			slide_callbacks.register({
				direction:	"reverse",
				callback: 	function() {
					$.validator.prototype.applyWindowListeners();
					FormElements.form.validate().rePosition(FormElements.errorContainer);
				}
			});
			if(options.isAccordian) {
				QuoteEngine.gotoSlide({
					index : options.startStage,
					callback : function() {
						$('.accordion').show();
						var foundInvalidField = !QuoteEngine.validate(false);
						if(!foundInvalidField || FormElements.errorContainer.find('li').length === 0 ) {
							ServerSideValidation._handleServerSideValidation(options);
							ServerSideValidation._triggerErrorContainer();
						}
					}
				});
			} else if(options.singleStage) {
				$('#resultsPage').hide("fast", function(){
					slide_callbacks.register({
						direction:	"reverse",
						slide_id:	options.startStage,
						callback: 	function() {
							$.validator.prototype.applyWindowListeners();
							FormElements.form.validate().rePosition(FormElements.errorContainer);
						}
					});
					QuoteEngine.gotoSlide({
						index : options.startStage
					});
					var valid  = QuoteEngine.validate(false);
					if(valid || FormElements.errorContainer.find('li').length === 0) {
						ServerSideValidation._handleServerSideValidation(options);
					}
				});
			} else {
				ServerSideValidation._handleServerSideValidation(options);
			}
		}else{
			ServerSideValidation._handleServerSideValidation(options);
		}

		ServerSideValidation._triggerErrorContainer();
	},

	_handleServerSideValidation : function(options) {

		if(typeof slide_callbacks === 'undefined'){
			// NEW CODE FOR NEW JOURNEY ENGINE

			var erroredElements = [];

			for(var i=0; i<options.validationErrors.length; i++){

				var error = options.validationErrors[i];

				var partialName = error.elementXpath.replace(/\//g, "_");
				var matches = $(":input[name$='" + partialName	+ "']");

				if (matches.length == 0 && error.elements != "") {

					// Didn't find the element, try more attempts...

					var elements = error.elements.split(",");
					for (var x = 0; i < elements.length; x++) {
						var fieldName = partialName + "_" + $.trim(elements[x]);

						matches = $('input[name*="' + fieldName + '"]');
						if(matches.length == 0) matches = $('input[id*="' + fieldName + '"]');	// Try finding by ID.

					}

				}

				// code to add the error message
				var SSVresult = ServerSideValidation._addErrorMessage(error, matches, false);

				for(var b=0;b<matches.length;b++){
					// FYI error.message == "ELEMENT REQUIRED" || INVALID VALUE
					var element = matches[b];
					erroredElements.push(element);
					$(element).parent().removeClass("has-success");
					$(element).parent().addClass("has-error");
				}


			}

			if(matches.length > 0){
				// eg: work out which slide to navigate to, also should we display a message to the user as the error may be unrecoverable?
				var errorSlide = $(matches[0]).closest("form").attr("id").slice(0,-4); // trim off "Form"

				// adding defer allows the setHash to actually affect the journeyEngine
				_.defer(function deferSetHash() {
					meerkat.modules.address.setHash(errorSlide === "" ? "start" : errorSlide);
				});
			}


		}else{
			// LEGACY CODE
			var validationErrors = options.validationErrors;
			var startStage = options.startStage;
			var singleStage = options.singleStage;
			options.genericMessageDisplayed = false;
			document.severSideValidation = true;
			FormElements.errorContainer.find('ul').empty();
			var firstErrorSlide = null;
			jQuery.each(validationErrors,
					function(key, value) {
						var addMessage = true;
						var partialName = value.elementXpath.replace(/\//g, "_");
						var invalidField = $("select[name$='" + partialName
										+ "']");
							if (typeof invalidField == 'undefined' || invalidField.length == 0) {
									invalidField = $("input[name$='" + partialName	+ "']");
							}
							if (value.message == "ELEMENT REQUIRED"	&& (typeof invalidField == 'undefined' || invalidField.length == 0)) {
									if (value.elements != "") {
										var elements = value.elements.split(",");
										var field = null;
										for(var i = 0 ; i < elements.length ; i++) {
											var fieldName = partialName + "_" + $.trim(elements[i]);
											field = $('input[name*="' + fieldName + '"]');
											// can't find name try id
											if(typeof field == 'undefined' || field.length == 0) {
												field = $('input[id*="' + fieldName + '"]');
											}
											if((typeof field != 'undefined' && field.length != 0) && field.prop("required") && field.val() === "") {
												invalidField = field;
											}
										}
										if((field != null && typeof field != 'undefined' && field.length != 0) && (typeof invalidField == 'undefined' || invalidField.length == 0)) {
											invalidField = field;
										}
									} else {
										invalidField = $('input[name*="' + partialName
												+ '"]');
									}
							}
				if (typeof invalidField != 'undefined' && invalidField.length > 1) {
					invalidField = invalidField.first();
				}
				if (!singleStage && typeof invalidField != 'undefined' && invalidField.length == 1) {
					firstErrorSlide = ServerSideValidation._attemptToFindAndGoToErrorSlide(invalidField, firstErrorSlide,value, options);
					if(invalidField.hasClass("error")) {
						addMessage = false;
					}
				}


				if(addMessage) {
					if (!invalidField.hasClass("error")) {
						invalidField.addClass("error");
						if (invalidField.is(':radio')) {
							invalidField.closest('.fieldrow').addClass(
							'errorGroup');
							if (invalidField.hasClass('first-child')) {
								invalidField.addClass('checking');
							}
						}
					}
					options.genericMessageDisplayed = ServerSideValidation._addErrorMessage(value, invalidField, options.genericMessageDisplayed);
				}

			});
			if (!singleStage && firstErrorSlide == null) {
				slide_callbacks.register({
					direction:	"reverse",
					slide_id:	startStage,
					callback: 	function() {
						$.validator.prototype.applyWindowListeners();
						FormElements.form.validate().rePosition(FormElements.errorContainer);
					}
				});
				QuoteEngine.gotoSlide({
					index : startStage
				});
			}

			// END LEGACY CODE
		}

	},

	_attemptToFindAndGoToErrorSlide: function(invalidField, firstErrorSlide, value, options) {
		var errorSlide = null;
		var id = invalidField.parents("div.qe-screen:eq(0)").attr("id");
		var hasValidation = invalidField.valid !== 'undefined';
		if (typeof id !== 'undefined') {
			errorSlide = id.split("slide").pop();
			if (firstErrorSlide == null && !isNaN(errorSlide) && errorSlide <= options.maxSlide) {
				firstErrorSlide = errorSlide;
				slide_callbacks.register({
					direction:	"reverse",
					slide_id:	errorSlide,
					callback: 	function() {
						$.validator.prototype.applyWindowListeners();
						FormElements.form.validate().rePosition(FormElements.errorContainer);
					}
				});
				QuoteEngine.gotoSlide({
					index : errorSlide
				});
				QuoteEngine.validate(false);
				if (!invalidField.hasClass("error")) {
					options.genericMessageDisplayed = ServerSideValidation._addErrorMessage(value, invalidField, options.genericMessageDisplayed);
				}
			} else if ((firstErrorSlide == errorSlide ) && hasValidation) {
				invalidField.valid();
			}
		}
		return firstErrorSlide;
	},

	_triggerErrorContainer: function() {
		if(typeof FormElements != 'undefined'){
			if( !FormElements.errorContainer.is(':visible') && FormElements.errorContainer.find('li').length > 0 ) {
				FormElements.rightPanel.addClass('hidden');
				FormElements.errorContainer.show();
				FormElements.errorContainer.find('li').show();
				FormElements.errorContainer.find('li .error').show();
			}
		}
	},

		_addErrorMessage: function(value,invalidField,genericMessageDisplayed) {
			var displayGenericMessage = false;
			var message = "";
			var missingFieldText = value.elementXpath.replace("/", " ");

			if (value.message == "INVALID VALUE") {
				if (UserData.callCentre) {
					message = "Please enter a valid value for " + missingFieldText + ".";
				} else {
					message = "It looks like you've missed something when filling out the form. Please check that you've entered the right details into each section.";
					displayGenericMessage = true;
				}
			} else if (value.message == "ELEMENT REQUIRED") {
				if ((typeof invalidField != 'undefined' && invalidField.length != 0) && invalidField.attr("data-msg-required") != "" && invalidField.prop("data-msg-required")) {
					message = invalidField.attr("data-msg-required");
				} else if (UserData.callCentre) {
					message = "Please enter the " + missingFieldText + ".";
				} else {
					message = "It looks like you've missed something when filling out the form. Please check that you've entered your details into each section.";
					displayGenericMessage = true;
				}
			} else {
				if (typeof UserData !== 'undefined' && UserData.callCentre) {
					message = "Please check " + missingFieldText + ".";
				} else if(value.message != '') {
					message = value.message;
					var hasOmittableCopy = message.indexOf("value= '");
					// This additional text has been removed for UTL but need
					// to cater for other verticals
					if(hasOmittableCopy > 0) {
						message = message.substring(0, hasOmittableCopy);
					}
				} else {
					message = "It looks like something has gone wrong when filling out the form. Please check that you've entered the right details into each section.";
					displayGenericMessage = true;
				}
			}
			if(!genericMessageDisplayed) {
				// pre-AMS verticals
				if ($('#slideErrorContainer').length > 0)
				{
					$('#slideErrorContainer ul').append(
						"<li><label class='error'>" + message + "</label></li>");
				} else {
					// AMS verticals
					var field = value.elementXpath.replace("/", "_");
					// this is done so that if an error message needs to be placed when it involves a dropdown, we need to do the insertion before the select field
					// otherwise the dropdown arrows don't move down with the actual field. JS validation correctly hides this error field in this new position if the values are correct.
					//

					var insertTarget = invalidField.parent('.select').length == 1 ? invalidField.parent('.select') : invalidField;
					if (typeof invalidField.attr('data-validation-placement') !== 'undefined')
					{
						insertTarget = $(invalidField.attr('data-validation-placement'));
					}


					// need to add this check so that we don't continuously add new error field divs
					if (insertTarget.prev('.error-field').hasClass('error-field'))
					{
						var errorLabel = insertTarget.prev('.error-field').find('label.has-error');
						if (errorLabel.length == 0)
						{
							insertTarget.addClass('has-error').prev('.error-field').html("<label for='"+field+"' class='has-error'>" + message + "</label>");

							if (insertTarget.hasClass('select')) {
								// this step is required otherwise we'll display a green field with a red error message
								insertTarget.children('select').removeClass('has-success').addClass('has-error');
								insertTarget.parent('.row-content').removeClass('has-success');
							}
						} else {
							errorLabel.text(message);
						}
					} else {
						$("<div class='error-field' style='display: block;'><label for='"+field+"' class='has-error'>" + message + "</label></div>").insertBefore(insertTarget);
					}
				}
			}
			return genericMessageDisplayed || displayGenericMessage;
		}
	};

// Seems to be unused as I can't find in codebase?
$.validator.addMethod('checkPrefix', function (value) {
	var tmpVal = value.replace(/[^0-9]+/g, '');
	var phoneRegex = new RegExp("^(0[234785]{1})");
	return phoneRegex.test(tmpVal);
});