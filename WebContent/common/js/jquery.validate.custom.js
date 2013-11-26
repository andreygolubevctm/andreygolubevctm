$.validator.addMethod("dateEUR", function(value, element) {
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
// Ensures that an email address or URL is not being entered
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
	return !($('input[name="quote_contact_oktocall"]:checked').val() == "Y" && value == "");
}, "");

$.validator
		.addMethod(
				"validAddress",
				function(value, element, name) {
					"use strict";
					var valid = false;

					var streetNoElement = $("#" + name + "_streetNum");
					var unitShopElement = $("#" + name + "_unitShop");
					var dpIdElement = $("#" + name + "_dpId");

					var fldName = $(element).attr("id").substring(name.length);

					switch (fldName) {
					case "_streetSearch":
						if ($("#" + name + "_nonStd").is(":checked")) {
							$(element).removeClass("error");
							return true;
						} else if (streetNoElement.hasClass('canBeEmpty')) {
							$("#mainform").validate().element(unitShopElement);
							$(element).removeClass("error");
							valid = true;
						} else if (streetNoElement.val() != ""
								|| $("#" + name + "_houseNoSel").val() != "") {
							$("#mainform").validate().element(streetNoElement);
							if (!unitShopElement.hasClass('canBeEmpty')) {
								$("#mainform").validate().element(
										unitShopElement);
							}
							$(element).removeClass("error");
							valid = true;
						}
						if (valid
								&& (dpIdElement.val() == "" || $(
										"#" + name + "_fullAddress").val() == "")) {
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
										streetId : $("#" + name + "_streetId")
												.val(),
										houseNo : houseNo,
										unitNo : unitNo,
										unitType : unitType
									}, $(element));
						}
						break;
					case "_streetNum":
						return true;
					case "_suburb":
						return !$(element).is(":visible")
								|| ($(element).val() != "" && $(element).val() != "Please select...");
					case "_nonStdStreet":
						if (!$(element).is(":visible")) {
							return true;
						}

						if (value == "") {
							return false;
						}
						/** Residential street cannot start with GPO or PO * */
						if ($("#" + name + "_type").val() == 'R') {
							if (AddressUtils.isPostalAddress(value)) {
								return false;
							}
						}
						$(element).trigger("customAddressEnteredEvent",
								[ name ]);
						return true;
					case "_unitShop":
						if (!$(element).hasClass('canBeEmpty')) {
							valid = $(element).val() != "";
						} else {
							valid = true;
						}
						valid = !$(element).is(":visible")
								|| $("#" + name + "_nonStd").is(":checked")
								|| valid;
						break;
					case "_nonStd":
						if ($(element).is(":checked:")) {
							$("#mainform").validate().element(
									"#" + name + "_streetSearch");
						} else {
							$("#mainform").validate().element(
									"#" + name + "_suburb");
							$("#mainform").validate().element(
									"#" + name + "_nonStdStreet");
							if (!$("#" + name + "_streetNum").hasClass(
									"canBeEmpty")) {
								$("#mainform").validate().element(
										"#" + name + "_streetNum");
							}
							$("#mainform").validate().element(unitShopElement);
						}
						return true;
					default:
						return false;
					}
					if (valid) {
						$(element).removeClass("error");
					}
					return valid;
				}, "Please enter a valid address");

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
			FatalErrorDialog.register({
				message : "An error occurred checking the address: " + txt,
				page : "ajax/json/address/get_address.jsp",
				description : "An error occurred checking the address: " + txt,
				data : data
			});
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
				$(element).removeClass("error");
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
		error : function(obj, txt) {
			passed = true;
			FatalErrorDialog.register({
				message : "An error occurred validating the postcode: " + txt,
				page : "ajax/json/validation/validate_postcode.jsp",
				description : "An error occurred validating the postcode: "
						+ txt,
				data : data
			});
		},
		timeout : 6000
	});
	return passed;
};

String.prototype.startsWith = function(prefix) {
	return (this.substr(0, prefix.length) === prefix);
};
String.prototype.endsWith = function(suffix) {
	return (this.substr(this.length - suffix.length) === suffix);
};
handleServerSideValidation = function(validationErrors) {
	"use strict";
	document.severSideValidation = true;
	$('#slideErrorContainer ul').empty();
	jQuery.each(
					validationErrors,
					function(key, value) {
						var partialName = value.elementName.replace("/", "_");
						var invalidField = $("select[name$='" + partialName
								+ "']");
						if (typeof invalidField == 'undefined'
								|| invalidField.length == 0) {
							invalidField = $("input[name$='" + partialName
									+ "']");
						}
						if (value.message == "ELEMENT REQUIRED"
								&& (typeof invalidField == 'undefined' || invalidField.length == 0)) {
							invalidField = $('input[name*="' + partialName
									+ '"]');
						}
						if (value.message == "ELEMENT REQUIRED"
								&& (typeof invalidField == 'undefined' || invalidField.length == 0)) {
							invalidField = $('select[name*="' + partialName
									+ '"]');
						}
						if (typeof invalidField != 'undefined') {
							if (!invalidField.hasClass("error")) {
								invalidField.addClass("error");
							}
							if (invalidField.is(':radio')) {
								invalidField.closest('.fieldrow').addClass(
										'errorGroup');
								if (invalidField.hasClass('first-child')) {
									invalidField.addClass('checking');
								};
							}
						}
						var message = "";
						if (value.message == "INVALID VALUE") {
							message = "Please enter a valid value for "
									+ value.elementName.replace("/", " ") + ".";
						} else if (value.message == "ELEMENT REQUIRED") {
							if (invalidField.attr("data-msg-required") != "") {
								message = invalidField
										.attr("data-msg-required");
							} else {
								message = "Please enter the "
										+ value.elementName.replace("/", " ")
										+ ".";
							}
						} else {
							message = "Please check "
									+ value.elementName.replace("/", " ") + ".";
						}
						$('#slideErrorContainer ul').append(
								"<li>" + message + "</li>");
	});
	$('#slideErrorContainer').show();
	$('#slideErrorContainer ul').show();
	$('#page > .right-panel').addClass('hidden');
};

$.validator.addMethod('validateTelNo', function(value, element, param) {
	var valid = true;
	var strippedValue = value.replace(/[^0-9]+/g, '');
	if (strippedValue != "") {
		var phoneRegex = new RegExp("^(0[234785]{1}[0-9]{8})$");
		valid = phoneRegex.test(strippedValue);
	}
	return valid;
});

$.validator.addMethod('checkPrefix', function(value, element, param) {
	var tmpVal = value.replace(/[^0-9]+/g, '');
	var phoneRegex = new RegExp("^(0[234785]{1})");
	return phoneRegex.test(tmpVal);
});

$.validator.addMethod('confirmLandline', function(value, element, param) {
	var strippedValue = value.replace(/[^0-9]+/g, '');
	return strippedValue == '' || isLandLine(strippedValue);
});

$.validator.addMethod("validateMobile", function(value, element) {
	var valid = true;
	var strippedValue = value.replace(/[^0-9]+/g, '');
	if (strippedValue != "" ) {
		var voipsNumber = strippedValue.indexOf("0500") == 0;
		var phoneRegex = new RegExp("^(0[45]{1}[0-9]{8})$");
		if (!phoneRegex.test(strippedValue) || voipsNumber) {
			valid = false;
		}
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
	;
}, "Custom message");

isLandLine = function (number) {
	var mobileRegex = new RegExp("^(0[45]{1})");
	var voipsNumber = number.indexOf("0500") == 0;
	return !mobileRegex.test(number) || voipsNumber;
};
