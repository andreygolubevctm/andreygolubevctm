$.validator.addMethod('regex', function(value, element, param) {
	return value.match(new RegExp('^' + param + '$'));
});

$.validator.addMethod('min_DateOfBirth', function(value, element, params) {
	if (typeof params === 'undefined' || !params.hasOwnProperty('ageMin')) return false;

	if (params.selector) {
		value = $(params.selector).val() || value;
	}
	var now = new Date();
	var temp = value.split('/');
	var minDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- params.ageMin) );

	if (minDate > now) {
		return false;
	};

	return true;
});

$.validator.addMethod('max_DateOfBirth', function(value, element, params) {
	if (typeof params === 'undefined' || !params.hasOwnProperty('ageMax')) return false;

	if (params.selector) {
		value = $(params.selector).val() || value;
	}
	var now = new Date();
	var temp = value.split('/');
	var maxDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- params.ageMax) );

	if (maxDate < now) {
		return false;
	};

	return true;
});

$.validator.addMethod("dateEUR", function(value, element, params) {
	if (typeof params !== 'undefined' && params.selector) {
		value = $(params.selector).val() || value;
	}

	var check = false;
	var re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
	if (re.test(value)) {
		var adata = value.split('/');
		var d = parseInt(adata[0], 10);
		var m = parseInt(adata[1], 10);
		var y = parseInt(adata[2], 10);
		var xdata = new Date(y, m - 1, d);
		if ((xdata.getFullYear() == y) && (xdata.getMonth() == m - 1)
				&& (xdata.getDate() == d)) {
			check = true;
		} else {
			check = false;
		}
	} else {
		check = false;
	}
	return (this.optional(element) != false) || check;
}, "Please enter a date in dd/mm/yyyy format.");

$.validator.addMethod("minDateEUR", function(value, element, param) {
	function getDate(v) {
		var adata = v.split('/');
		return new Date(parseInt(adata[2], 10), parseInt(adata[1], 10) - 1,
				parseInt(adata[0], 10));
	}
	return (this.optional(element) != false)
			|| getDate(value) >= getDate(param);
}, $.validator.format("Please enter a minimum of {0}."));

$.validator.addMethod("maxDateEUR", function(value, element, param) {
	function getDate(v) {
		var adata = v.split('/');
		return new Date(parseInt(adata[2], 10), parseInt(adata[1], 10) - 1,
				parseInt(adata[0], 10));
	}
	return (this.optional(element) != false)
			|| getDate(value) <= getDate(param);
}, $.validator.format("Please enter a maximum of {0}."));

//
// Validates NCD: Years driving can exceed NCD years
//
$.validator.addMethod("ncdValid", function(value, element) {

	if (element.value == "")
		return false;

	function getDateFullYear(v) {
		var adata = v.split('/');
		return parseInt(adata[2], 10);
	}

	// TODO: Get date from server and not client side
	var d = new Date();
	var curYear = d.getFullYear();

	var minDrivingAge = 16;
	var rgdYrs = curYear
			- getDateFullYear($("#quote_drivers_regular_dob").val());
	var ncdYears = value;
	var yearsDriving = rgdYrs - minDrivingAge;
	// alert("ncdYears: " + ncdYears + " yearsDriving: " + yearsDriving);
	if (ncdYears > yearsDriving) {
		return false;
	}
	return true;
}, "Invalid NCD Rating based on number of years driving.");

//
// Validates youngest drivers age with regular driver, youngest can not be older
// than regular driver
//
$.validator.addMethod("youngRegularDriversAgeCheck", function(value, element,
		params) {
	function getDate(v) {
		var adata = v.split('/');
		return new Date(parseInt(adata[2], 10), parseInt(adata[1], 10) - 1,
				parseInt(adata[0], 10));
	}

	var rgdDob = getDate($("#quote_drivers_regular_dob").val());
	var yngDob = getDate(value);

	// Rgd must be older than YngDrv
	if (yngDob < rgdDob) {
		return (this.optional(element) != false) || false;
	}
	return true;
}, "Youngest driver should not be older than the regular driver.");

//
// Validates...
//
$.validator.addMethod("allowedDrivers", function(value, element, params) {

	var allowDate = false;

	function getDateFullYear(v) {
		var adata = v.split('/');
		return parseInt(adata[2], 10);
	}
	function getDateMonth(v) {
		var adata = v.split('/');
		return parseInt(adata[1], 10) - 1;
	}
	function getDate(v) {
		var adata = v.split('/');
		return new Date(parseInt(adata[2], 10), parseInt(adata[1], 10) - 1,
				parseInt(adata[0], 10));
	}

	var minAge;

	switch (value) {
	case "H":
		minAge = 21;
		break;
	case "7":
		minAge = 25;
		break;
	case "A":
		minAge = 30;
		break;
	case "D":
		minAge = 40;
		break;
	default:
		// do nothing
	}

	// TODO: Get date from server and not client side
	var d = new Date();
	var curYear = d.getFullYear();
	var curMonth = d.getMonth();
	var rgdDOB = getDate($("#quote_drivers_regular_dob").val());
	var rgdFullYear = getDateFullYear($("#quote_drivers_regular_dob").val());
	var rgdMonth = getDateMonth($("#quote_drivers_regular_dob").val());
	var rgdYrs = curYear - rgdFullYear;

	// Check AlwDrv allows Rgd
	if (rgdYrs < minAge) {
	} else if (rgdYrs == minAge) {
		if ((rgdFullYear + minAge) == curYear) {
			if (rgdMonth < curMonth) {
				allowDate = true;
			} else if (rgdMonth == curMonth) {
				if (rgdDOB <= d) {
					allowDate = true;
				}
			}
		}
	} else {
		allowDate = true;
	}

	if (allowDate == false) {
		return false;
	}

	return true;

}, "Driver age restriction invalid due to regular driver's age.");

//
// Validates youngest driver minimum age
//
$.validator.addMethod("youngestDriverMinAge", function(value, element, params) {

	function getDateFullYear(v) {
		var adata = v.split('/');
		return parseInt(adata[2], 10);
	}

	var minAge;
	switch (value) {
	case "H":
		minAge = 21;
		break;
	case "7":
		minAge = 25;
		break;
	case "A":
		minAge = 30;
		break;
	case "D":
		minAge = 40;
		break;
	default:
		// do nothing
	}

	// TODO: Get date from server and not client side
	var d = new Date();
	var curYear = d.getFullYear();
	var yngFullYear = getDateFullYear($("#quote_drivers_young_dob").val());
	var yngAge = curYear - yngFullYear;
	if (yngAge < minAge) {
		return (this.optional(element) != false) || false;
	}
	return true;

}, "Driver age restriction invalid due to youngest driver's age.");

//
// Is used to reset the number of form errors when moving between slides
//
;
(function($) {
	$.extend($.validator.prototype, {
		resetNumberOfInvalids : function() {
			this.invalid = {};
			$(this.containers).find(".error, li").remove();
		}
	});
})(jQuery);

//
// Any input field with a class of 'numeric' will only be allowed to input
// numeric characters
//
$(function() {
	try {
		$("input.numeric").numeric();
	} catch (e) {/* IGNORE */
	}
});

//
// Validates age licence obtained for regular driver
//
$.validator.addMethod("ageLicenceObtained", function(value, element, param) {

	var driver;
	switch (element.name) {
	case "quote_drivers_regular_licenceAge":
		driver = "#quote_drivers_regular_dob";
		break;
	case "quote_drivers_young_licenceAge":
		driver = "#quote_drivers_young_dob";
		break;
	default:
		return false;
	}

	function getDateFullYear(v) {
		var adata = v.split('/');
		return parseInt(adata[2], 10);
	}
	var d = new Date();
	var curYear = d.getFullYear();
	var driverFullYear = getDateFullYear($(driver).val());
	var driverAge = curYear - driverFullYear;

	if (isNaN(driverAge) || value < 16 || value > driverAge) {
		return (this.optional(element) != false) || false;
	}
	return true;

}, "Age licence obtained invalid due to driver's age.");

//
// Ensures that client agrees to the field
// Makes sure that checkbox for 'Y' is checked
//
$.validator.addMethod("agree", function(value, element, params) {
	if (value == "Y") {
		return $(element).is(":checked");
	} else {
		return false;
	}
}, "");

//
//Ensures that an email address or URL is not being entered
//
$.validator.addMethod("personName",
		function(value, element, params) {
			var isEmail = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i.test(value);
			var isURL = value.match(/(?:[^\s])\.(com|co|net|org|asn|ws|us|mobi)(\.[a-z][a-z])?/) != null;
			return !isEmail && !isURL;
		},
		"Please enter a valid name"
);

//
// Validates OK to call which ensure we have a phone number if they select yes
//
$.validator
		.addMethod(
				"personName",
				function(value, element, params) {
					var isEmail = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i
							.test(value);
					var isURL = value
							.match(/(?:[^\s])\.(com|co|net|org|asn|ws|us|mobi)(\.[a-z][a-z])?/) != null;
					return !isEmail && !isURL;
				}, "Please enter a valid name");

//
// Validates OK to call which ensure we have a phone number if they select yes
//
$.validator.addMethod("okToCall", function(value, element, params) {
	if ($('input[name="quote_contact_oktocall"]:checked').val() == "Y"
			&& $('input[name="quote_contact_phone"]').val() == "") {
		return false;
	} else {
		return true;
	}

}, "");

//
//Validates OK to email which ensure we have a email address if they select yes
//
$.validator.addMethod("marketing", function(value, element, params) {
	if ($('input[name="quote_contact_marketing"]:checked').val() == "Y"
			&& $('input[name="quote_contact_email"]').val() == "") {
		return false;
	} else {
		$('input[name="quote_contact_email"]').parent().removeClass('state-right state-error');
		return true;
	}

}, "");

$.validator
		.addMethod(
				"validAddress",
				function(value, element, name) {
					"use strict";
					//return true; // HACK TO MAKE THIS WORK FOR NOW
					var valid = false;

					var $ele = $(element);
					var streetNoElement = $("#" + name + "_streetNum");
					var unitShopElement = $("#" + name + "_unitShop");
					var dpIdElement = $("#" + name + "_dpId");

					var fldName = $ele.attr("id").substring(name.length);

					switch (fldName) {
					case "_streetSearch":

						if ($("#" + name + "_nonStd").is(":checked")) {
							$ele.removeClass("error has-error");
							return true;
						}
						var suburbName = $("#" + name + "_suburbName").val();
						var suburbSelect = $("#" + name + "_suburb").val();
						var validSuburb =  suburbName != "" && suburbName != "Please select..." && suburbSelect != "";
						if (!validSuburb) {
							return false;
						}
						if (streetNoElement.hasClass('canBeEmpty')) {
							unitShopElement.valid();
							valid = true;
						} else if (streetNoElement.val() != "" || $("#" + name + "_houseNoSel").val() != "") {

							if(streetNoElement.is(":visible")){
								streetNoElement.valid();
							}

							$ele.removeClass("error has-error");

							valid = true;
						}

						if (valid && (dpIdElement.val() == "" || $("#" + name + "_fullAddress").val() == "")) {
							var unitType = $("#" + name + "_unitType").val();
							if (unitType == 'Please choose...') {
								unitType = "";
							}
							var unitNo = $("#" + name + "_unitSel").val();
							if (unitNo == "") {
								unitNo = unitShopElement.val();
							}
							var houseNo = streetNoElement.val();
							if (houseNo == "") {
								houseNo = $("#" + name + "_houseNoSel").val();
							}
							valid = validateAddressAgainstServer(name,
									dpIdElement, {
										streetId : $("#" + name + "_streetId").val(),
										houseNo : houseNo,
										unitNo : unitNo,
										unitType : unitType
									}, $ele);
						}

						if(unitShopElement.is(":visible") && dpIdElement.val() == "" && !unitShopElement.hasClass('canBeEmpty')) {
							valid = valid && unitShopElement.val() != "" && unitShopElement.val() != "0";
						}
						break;
					case "_streetNum":
						return true;
					case "_nonStdStreet":
						if (!$ele.is(":visible")) {
							return true;
						}

						if (value == "") {
							return false;
						}
						/** Residential street cannot start with GPO or PO * */
						if ($("#" + name + "_type").val() === 'R') {
							if (AddressUtils.isPostalBox(value)) {
								return false;
							}
						}
						$ele.trigger("customAddressEnteredEvent", [ name ]);
						return true;
					case "_nonStd":

						if ($ele.is(":checked")) {
							var $streetSearchEle = $("#" + name + "_streetSearch");
							if($streetSearchEle.prop('disabled') || $streetSearchEle.is(":visible") === false){
								return true;
							}else{
								$streetSearchEle.valid();
							}
						} else {
							var $suburbEle = $("#" + name + "_suburb");
							if($suburbEle.prop('disabled') || $suburbEle.is(":visible")  === false){
								return true;
							}else{
								$suburbEle.valid();
							}
							$("#" + name + "_nonStdStreet").valid();
							if (!streetNoElement.hasClass("canBeEmpty")) {
								streetNoElement.valid();
							}
							unitShopElement.valid();
						}

						return true;
					case "_postCode":
						return !$ele.hasClass('invalidPostcode');
					default:
						return false;
					}

					if (valid) {
						$ele.removeClass("error has-error");

						// Force an unhighlight because Validator has lost its element scope due to all the sub-valid() checks.
						if (fldName === '_streetSearch') {
							if( typeof $ele.validate().ctm_unhighlight === "function"){
								$ele.validate().ctm_unhighlight($('#' + name + '_streetSearch').get(0), this.settings.errorClass, this.settings.validClass);
							}
						}
					}

					//console.log('validAddress "' + fldName + '"', valid);
					return valid;

				}, "Please enter a valid address");


$.validator.addMethod(
		"validSuburb",
		function(value, element, name) {
			"use strict";
			var valid = false;

			if ($("#" + name + "_nonStd").is(":checked")) {
				valid = value !== '' && value !== 'Please select...';
			} else {
				$(element).removeClass("error has-error");
				valid = true;
			}
			return valid;
		});

validateAddressAgainstServer = function(name, dpIdElement, data, element) {
	var passed = false;
	$.ajax({
		url : "ajax/json/address/get_address.jsp",
		data : data,
		type : "POST",
		async : false,
		cache : false,
		success : function(jsonResult) {
			passed = jsonResult.foundAddress;
			if (jsonResult.foundAddress) {
				$(element).trigger("validStreetSearchAddressEnteredEvent",
						[ name, jsonResult ]);
			}
		},
		dataType : "json",
		error : function(obj, txt) {
			passed = false;
			if( typeof meerkat !== "undefined" ){
				meerkat.modules.errorHandling.error({
					message : "An error occurred checking the address: " + txt,
					page : "ajax/json/address/get_address.jsp",
					description : "An error occurred checking the address: " + txt,
					data : data,
					errorLevel: "silent"
				});
			} else {
				FatalErrorDialog.register({
					message : "An error occurred checking the address: " + txt,
					page : "ajax/json/address/get_address.jsp",
					description : "An error occurred checking the address: " + txt,
					data : data
				});
			}
		},
		timeout : 6000
	});
	return passed;
};

//
//Validates the 4 digit postcode against server records.
//
$.validator.addMethod("validatePostcode",
		function(value, element, params) {
			var valid = false;
			if(value.length == 4){
				valid = validatePostcodeAgainstServer(name , element , {
					postcode : value
				},this.settings.baseURL );
			}

			if(valid) {
				$(element).removeClass("error has-error");
			}
			return valid;
		},
		"Please enter a valid postcode"
);

validatePostcodeAgainstServer = function(name, dpIdElement, data, url) {
	var passed = false;
	var url;
	if (url == null)
		url = '';
	$.ajax({
		url : url + "ajax/json/validation/validate_postcode.jsp",
		data : data,
		type : "POST",
		async : false,
		cache : false,
		success : function(jsonResult) {
			passed = jsonResult.isValid;

		},
		dataType : "json",
		error : function(obj, txt, errorThrown) {
			passed = true;

			if( typeof meerkat !== "undefined" ){
				meerkat.modules.errorHandling.error({
					message : "An error occurred validating the postcode: " + txt,
					page : "ajax/json/validation/validate_postcode.jsp",
					description : "An error occurred validating the postcode: "
							+ txt + " " + errorThrown,
					data : data,
					errorLevel: "silent"
				});
			} else {
				FatalErrorDialog.register({
					message : "An error occurred validating the postcode: " + txt,
					page : "ajax/json/validation/validate_postcode.jsp",
					description : "An error occurred validating the postcode: "
							+ txt,
					data : data
				});
			}
		},
		timeout : 6000
	});
	return passed;
};

//
//Validates the if a postcode is pobox only.
//
$.validator.addMethod("checkPostBoxOnly",
	function(value, element, name) {
		var isPostBoxOnly = false;
		var fldName = $(element).attr("id").substring(name.length);
		if (fldName == "_postCode"){
			isPostBoxOnly = $(element).hasClass('postBoxOnly');
		}
		return !isPostBoxOnly;
	},
	"Please enter a valid street address. Unfortunately we cannot compare car insurance policies for vehicles parked at a PO Box address."
);

String.prototype.startsWith = function(prefix) {
	return (this.substr(0, prefix.length) === prefix);
};
String.prototype.endsWith = function(suffix) {
	return (this.substr(this.length - suffix.length) === suffix);
};

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
					for(var i = 0; i < elements.length; i++){
						var fieldName = partialName + "_" + $.trim(elements[i]);

						var matches = $('input[name*="' + fieldName + '"]');
						if(matches.length == 0) matches = $('input[id*="' + fieldName + '"]');	// Try finding by ID.

					}

				}

				for(var b=0;b<matches.length;b++){
					// FYI error.message == "ELEMENT REQUIRED" || INVALID VALUE
					var element = matches[b];
					erroredElements.push(element);
					$(element).parent().removeClass("has-success");
					$(element).parent().addClass("has-error");
				}


			}

			if(matches.length > 0){
				// TODO - Decide what to do here,
				// eg: work out which slide to navigate to, also should we display a message to the user as the error may be unrecoverable?
				var firstSlide = $(matches[0]).parents(".journeyEngineSlide").first();
				meerkat.modules.address.setHash('start');
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
											if((typeof field != 'undefined' && field.length != 0) && field.prop("required") && field.val() == "") {
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
		var missingFieldText = value.elementXpath.replace("/", " ") ;
		if (value.message == "INVALID VALUE") {
			if(UserData.callCentre) {
				message = "Please enter a valid value for " + missingFieldText + ".";
			} else {
				message = "It looks like you've missed something when filling out the form. Please check that you've entered the right details into each section.";
				displayGenericMessage = true;
			}
		} else if (value.message == "ELEMENT REQUIRED") {
			if ((typeof invalidField != 'undefined' && invalidField.length != 0) && invalidField.attr("data-msg-required") != "" && invalidField.prop("data-msg-required")) {
				message = invalidField.attr("data-msg-required");
			} else if(UserData.callCentre) {
				message = "Please enter the " + missingFieldText + ".";
			} else {
				message = "It looks like you've missed something when filling out the form. Please check that you've entered your details into each section.";
				displayGenericMessage = true;
			}
		} else {
			if(UserData.callCentre) {
				message = "Please check " + missingFieldText + ".";
			} else {
				message = "It looks like something has gone wrong when filling out the form. Please check that you've entered the right details into each section.";
				displayGenericMessage = true;
			}
		}
		if(!genericMessageDisplayed) {
			$('#slideErrorContainer ul').append(
					"<li><label class='error'>" + message + "</label></li>");
		}
		return genericMessageDisplayed || displayGenericMessage;
	}
};

$.validator.addMethod('checkPrefix', function(value, element, param) {
	var tmpVal = value.replace(/[^0-9]+/g, '');
	var phoneRegex = new RegExp("^(0[234785]{1})");
	return phoneRegex.test(tmpVal);
});

$.validator.addMethod('confirmLandline', function(value, element, param) {
	var strippedValue = value.replace(/[^0-9]+/g, '');
	return strippedValue == '' || isLandLine(strippedValue);
});

$.validator.addMethod('validateTelNo', function(value, element) {
	if (value.length == 0) return true;

	var valid = true;
	var strippedValue = value.replace(/[^0-9]/g, '');
	if (strippedValue.length == 0 && value.length > 0) {
		return false;
	}

	var phoneRegex = new RegExp('^(0[234785]{1}[0-9]{8})$');
	valid = phoneRegex.test(strippedValue);
	return valid;
});

$.validator.addMethod('validateMobile', function(value, element) {
	if (value.length == 0) return true;

	var valid = true;
	var strippedValue = value.replace(/[^0-9]/g, '');
	if (strippedValue.length == 0 && value.length > 0) {
		return false;
	}

	var voipsNumber = strippedValue.indexOf('0500') == 0;
	var phoneRegex = new RegExp('^(0[45]{1}[0-9]{8})$');
	if (!phoneRegex.test(strippedValue) || voipsNumber) {
		valid = false;
	}
	return valid;
});
$.validator.addMethod("requiredOneContactNumber", function(value, element) {
	var nameSuffix = element.id.split(/[_]+/);
	nameSuffix.pop();
	nameSuffix = nameSuffix.join("_");
	var mobileElement = $("#" + nameSuffix + "_mobile");
	var otherElement = $("#" + nameSuffix + "_other");
	if (mobileElement.val() + otherElement.val() == '') {
		return false;
	} else {
		return true;
	}
});

isLandLine = function(number) {
	var mobileRegex = new RegExp("^(0[45]{1})");
	var voipsNumber = number.indexOf("0500") == 0;
	return !mobileRegex.test(number) || voipsNumber;
};