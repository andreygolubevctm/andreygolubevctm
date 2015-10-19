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
		var currentslide = 0;
		if (typeof QuoteEngine !== 'undefined') {
			currentSlide = QuoteEngine.getCurrentSlide();
		}
		else if (typeof meerkat !== 'undefined') {
			currentSlide = meerkat.modules.journeyEngine.getCurrentStepIndex();
		}
		var currentSlideIsAhead = currentSlide > this.journeyStage;
		var hasPhoneNumber = inputs.hasOwnProperty('phoneType');
		if(!currentSlideIsAhead &&   this.elements.phoneInput.attr( "id" ) !== inputs.origin && hasPhoneNumber ) {
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

		if ($('body').hasClass('health')) return;

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
		if (!$('body').hasClass('health') && !Modernizr.input['placeholder']) {
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
	if ($('body').hasClass('health')) return;

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
	if ($('body').hasClass('health')) return;

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
	if ($('body').hasClass('health')) return;

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

var serialiseWithoutEmptyFields = function(formSelector) {
	var fields = "";
	clearPlaceholders();
	fields =  $(formSelector).find("input,select,textarea").filter(function(){
		return $(this).val() && $(this).val() != "Please choose..." && !$(this).hasClass("dontSubmit");
	}).serialize();
	setPlaceholders();
	fields+= "&transactionId="+referenceNo.getTransactionID();
	return fields;
};

/* Shim for ECMA-262 level browsers (NOT ES5 or JS1.6 level) that don't
 * support the Array.filter method. This would be ie8, ie7 etc etc.
 * This works, assuming no other shims are in effect on object,
 * typeError, fun.call is Function.prototype.call, and
 * Array.prototype.push is in it's original value too. From:
 * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter
 * */
if (!Array.prototype.filter) {
	Array.prototype.filter = function(fun /*, thisp*/) {
		'use strict';
		if (!this) {
			throw new TypeError();
		}
		var objects = Object(this);
		objects.length >>> 0;
		if (typeof fun !== 'function') {
			throw new TypeError();
		}
		var res = [];
		var thisp = arguments[1];
		for (var i in objects) {
			if (objects.hasOwnProperty(i)) {
				if (fun.call(thisp, objects[i], i, objects)) {
				res.push(objects[i]);
				}
			}
		}
		return res;
	};
}

/*-- ------------------------------------------------- --*/
/*-- --------- VARIOUS PRESENTATION STATES ----------- --*/
/*-- ------------------------------------------------- --*/

//Set up some state calls
var shared = { state : {} };

shared.state = {
	success : function(target) {
			shared.state.clear(target);
			$(target).addClass('state-right state-success');
	},
	error : function(target,extraInfo) {
			shared.state.clear(target);
			$(target).addClass('state-right state-error');
			$(target).find('select').addClass('state-force-validate');// force validator to check this field.
			//if (extraInfo != '') { console.error(extraInfo); }
	},
	busy : function(target,extraInfo) {
			shared.state.clear(target);
			$(target).addClass('state-right state-busy');
	},
	clear : function(target) {
			//non destructively remove the state classes
			//you can pass it a single target or a set
			$target = $(target);
			if ($target.length > 1) {
				$target.filter('*[class^="state-"], *[class*=" state-"]').each(function(){
					shared.state.clear(this);
				});
			} else {
				var classes = $target.attr("class");
				if(typeof classes != 'undefined') {
					var classesSplit = classes.split(" ");
					var filtered = classesSplit.filter(function(item) {
						return item.indexOf("state-") === -1 ? item : "";
					});
					var finalFiltered = filtered.join(" ");
					$target.attr("class", finalFiltered);
				}
			}
	}
};