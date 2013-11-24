var jQTransition = 'normal';

var Fields = {
	handleToggleOnChecked: function(selector , selectorToToggle) {
		var checked = $(selector).is(':checked');
		if(checked) {
			$(selectorToToggle).show(jQTransition);
		} else {
			$(selectorToToggle).hide(jQTransition);
		}
		return checked;
	},

	handleToggleOnYes: function(field , selectorToToggle) {
		var selected = field.val();
		if(selected == 'N' || selected == "" || selected == null) {
			$(selectorToToggle).hide(jQTransition);
		} else {
			$(selectorToToggle).show(jQTransition);
		}
	}
};

triggerContactDetailsEvent= function (elementInput, elementHidden, phoneType) {
	var valid = phoneNumberUpdated(elementInput, elementHidden, $(this).prop('required'));
	var phoneNumber = elementHidden.val();
	var phoneNumberInput = elementInput.val();
	if(!valid) {
		phoneNumber = "";
		phoneNumberInput = "";
	}
	var phoneType = "mobile";
	if(elementInput.hasClass("landline") || (elementInput.hasClass("anyPhoneType") && isLandLine(phoneNumber))) {
		phoneType = "landline";
	}
	$(document).trigger("CONTACT_DETAILS", [{
		phoneNumberInput : phoneNumberInput,
		phoneNumber : phoneNumber,
		phoneType : phoneType,
		origin :elementInput.attr("id")
	}]);
};

function ContactDetails () {
	this.that = this;
	this.allowLandline = false;
	this.allowMobile = false;
	this.elements = {
		phoneInput: [],
		phone: []
	};
	this.mobileValue = "";
	this.mobileValueInput = "";
	this.otherValueInput = "";
	this.otherValue = "";
	this.required;
	this.userHasInteracted = false;
	this.journeyStage = 1000;
	this.setPhoneNumber = function(inputs, setFields) {
		var currentSlideIsAhead = QuoteEngine.getCurrentSlide() > this.journeyStage;
		if(!currentSlideIsAhead &&   this.elements.phoneInput.attr( "id" ) !== inputs.origin) {
			if(this.allowLandline && inputs.phoneType == "landline") {
				this.otherValue = inputs.phoneNumber;
				this.otherValueInput = inputs.phoneNumberInput;
			} else if(this.allowMobile && inputs.phoneType == "mobile") {
				this.mobileValue = inputs.phoneNumber;
				this.mobileValueInput = inputs.phoneNumberInput;
			}
			if(setFields) {
				this.updatePhoneInputs(inputs.phoneType);
			}
		}
	};
	this.updatePhoneInputs = function(phoneType) {
		var allowChange = !this.userHasInteracted;
		var setFromMobile = this.allowMobile && this.mobileValue != ""  && (typeof(phoneType) == 'undefined' || phoneType == "mobile");
		var setFromLandLine = this.allowLandline && (typeof(phoneType) == 'undefined' || phoneType == "landline");
		if(setFromMobile && allowChange) {
			this.elements.phoneInput.val(this.mobileValueInput);
			this.elements.phone.val(this.mobileValue);
		} else if(setFromLandLine && allowChange) {
			this.elements.phoneInput.val(this.otherValueInput);
			this.elements.phone.val(this.otherValue);
		}
		if (!Modernizr.input['placeholder'] && this.elements.phoneInput.val() == "") {
			this.elements.phoneInput.val(this.elements.phoneInput.attr("placeholder"));
		}
	};
	this.init = function(phoneInput , phone , allowLandline, allowMobile) {
		this.allowLandline = allowLandline;
		this.allowMobile = allowMobile;
		this.elements.phoneInput = phoneInput;
		this.elements.phone = phone;
		var strippedValue = getStrippedPhoneValue(phoneInput);
		this.userHasInteracted = strippedValue != "";
		this.elements.phoneInput.on('blur', {
				contactDetails: this
			}, function(event) {
			var strippedValue = getStrippedPhoneValue($(this));
			event.data.contactDetails.userHasInteracted = strippedValue != "";
		});
	};
}

valueEqualsPlaceHolder  = function (elementInput) {
	var placeHolder = elementInput.attr("placeholder");
	var hasCustomPlaceHolder = typeof placeHolder !== 'undefined' && !Modernizr.input['placeholder'];
	return hasCustomPlaceHolder && placeHolder == elementInput.val();
};

getStrippedPhoneValue  = function (elementInput) {
	var strippedValue = "";
	if (!valueEqualsPlaceHolder(elementInput)) {
		strippedValue = elementInput.val().replace(/[^0-9]+/g, '');
	}
	return strippedValue;
};


phoneNumberUpdated= function (elementInput, elementHidden, required) {
	var valid = true;
	var strippedValue = getStrippedPhoneValue(elementInput);
	if (!required && strippedValue == "") {
		elementHidden.val("");
		if (!Modernizr.input['placeholder']) {
			elementInput.val(elementInput.attr("placeholder"));
		} else {
			elementInput.val('');
		}
	} else {
		elementHidden.val(strippedValue);
		valid = elementInput.valid();
		if(!valid) {
			elementHidden.val("");
		}
	}
	return valid;
};

setPhoneMask = function(element) {
	var number = element.val().replace(/[^0-9]+/g, '');
	var mobileRegex = new RegExp("^(0[45]{1})");
	if(mobileRegex.test(number) ) {
		element.inputMask('(0000) 000 000');
	} else {
		element.inputMask('(00) 0000 0000');
	}
};


function setUpPlaceHolders() {
	if (!Modernizr.input['placeholder']) {
		var placeHolders = $('input[placeholder].placeholder');
		if(placeHolders.length > 0) {
			var _setUpPlaceHolder = function() {
				setUpPlaceHolder($( this ));
			};

			$(placeHolders).each(_setUpPlaceHolder);
			placeHolders.first().parents("form").submit(function( event ) {
				clearPlaceholders();
			});
		}
	}
};

function setUpPlaceHolder(inputElement) {
	if (!Modernizr.input['placeholder']) {
		inputElement.data( "fontColour", inputElement.css('color') );
		setPlaceholder($(inputElement));

		inputElement.on('focus', function() {
			clearPlaceholder($(this));
		});
		inputElement.on('blur', function() {
			setPlaceholder($(this));
		});
	}
};

function clearPlaceholders() {
	if (!Modernizr.input['placeholder']) {
		var _clearPlaceholder = function() {
			clearPlaceholder($(this));
		};
		$('input[placeholder].placeholder').each(_clearPlaceholder);
	}
};



function clearPlaceholder(inputElement) {
	if(inputElement.val() == inputElement.attr("placeholder")) {
		inputElement.val('');
		inputElement.css('color', inputElement.data("fontColour"));
	}
};


function setPlaceholders() {
	if (!Modernizr.input['placeholder']) {
		var _setPlaceholder = function() {
			setPlaceholder($(this));
		};
		$('input[placeholder].placeholder').each(_setPlaceholder);
	}
};

function setPlaceholder(inputElement) {
	if(inputElement.val() == ''){
		inputElement.val(inputElement.attr("placeholder"));
		inputElement.css('color', '#949494');
	}
};
