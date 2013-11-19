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
	};
	this.init = function(phoneInput , phone , allowLandline, allowMobile) {
		this.allowLandline = allowLandline;
		this.allowMobile = allowMobile;
		this.elements.phoneInput = phoneInput;
		this.elements.phone = phone;
		var strippedValue = phoneInput.val().replace(/[^1-9]+/g, '');
		this.userHasInteracted = strippedValue != "" && phoneInput.val() != "(0x)xxx or 04xxx";
		this.elements.phoneInput.on('blur', {
				contactDetails: this
			}, function(event) {
			var strippedValue = $(this).val().replace(/[^1-9]+/g, '');
			event.data.contactDetails.userHasInteracted = strippedValue != "" && $(this).val() != "(0x)xxx or 04xxx";
		});
	};
}

phoneNumberUpdated= function (elementInput, elementHidden, required) {
	var valid = true;
	var strippedValue = elementInput.val().replace(/[^0-9]+/g, '');
	if (!required && (strippedValue == "" || strippedValue == "0000000000")) {
		elementHidden.val("");
		elementInput.val("");
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