if(typeof window.$ == 'undefined' && typeof window.jQuery !== 'undefined') {
	window.$ = jQuery;
}

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

	if(String(parseInt(temp[2], 10)).length === 4) {

		var minDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- params.ageMin) );

		if (minDate > now) {
			return false;
		}
	}

	return true;
});

$.validator.addMethod('max_DateOfBirth', function(value, element, params) {
	if (typeof params === 'undefined' || !params.hasOwnProperty('ageMax')) return false;

	if (params.selector) {
		value = $(params.selector).val() || value;
	}
	var now = new Date();
	var temp = value.split('/');

	if(String(parseInt(temp[2], 10)).length === 4) {

		var maxDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- params.ageMax) );

		if (maxDate < now) {
			return false;
		}
	}

	return true;
});

$.validator.addMethod("dateOfBirthEUR", function(value, element, params) {

	if (typeof params !== 'undefined' && params.selector) {
		value = $(params.selector).val() || value;
	}

	var check = false;
	var re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
	if (!re.test(value)) {
		check = false;
	} else {
		var adata = value.split('/');
		var d = parseInt(adata[0], 10);
		var m = parseInt(adata[1], 10);
		var y = parseInt(adata[2], 10);
		var xdata = new Date(y, m - 1, d);
		check = (xdata.getFullYear() == y || String(xdata.getFullYear()).substring(2) == y) && (xdata.getMonth() == m - 1)
		&& (xdata.getDate() == d);
	}

	return (this.optional(element) != false) || check;
}, "Please enter a date in dd/mm/yyyy format.");

$.validator.addMethod("dateEUR", function(value, element, params) {
	if (typeof params !== 'undefined' && params.selector) {
		value = $(params.selector).val() || value;
	}

	var check = false;
	var re = /^\d{1,2}\/\d{1,2}\/\d{2,4}$/;
	if (!re.test(value)) {
		check = false;
	} else {
		var adata = value.split('/');
		var d = parseInt(adata[0], 10);
		var m = parseInt(adata[1], 10);
		var y = parseInt(adata[2], 10);
		var xdata = new Date(y, m - 1, d);
		check = (xdata.getFullYear() == y) && (xdata.getMonth() == m - 1)
		&& (xdata.getDate() == d);
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
	return ncdYears <= yearsDriving;

}, "Invalid NCD Rating based on number of years driving.");

//
// Validates youngest drivers age with regular driver, youngest can not be older
// than regular driver
//
$.validator.addMethod("youngRegularDriversAgeCheck", function (value, element) {
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
// Validates the dropdown for mobile commencement date.
//
$.validator.addMethod("commencementDateMobileDropdownCheck", function (value, element) {
	return !(element.value == '' || element.value == null);
}, "Please select a commencement date.");

//
// Validates...
//
$.validator.addMethod("allowedDrivers", function (value) {

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
	var dobValue = $("#quote_drivers_regular_dob").val();
	var rgdDOB = getDate(dobValue);
	var rgdFullYear = getDateFullYear(dobValue);
	var rgdMonth = getDateMonth(dobValue);
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

	return allowDate;

}, "Driver age restriction invalid due to regular driver's age.");

//
// Validates youngest driver minimum age
//
$.validator.addMethod("youngestDriverMinAge", function (value, element) {

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
$.validator.addMethod("ageLicenceObtained", function (value, element) {

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
	if(this.optional(element) == false) {
		if(!isNaN(driverFullYear) ) {
			if (isNaN(driverAge) || value < 16 || value > driverAge) {
				return false;
			}
		} else if(value < 16) {
			return false;
		}
	}
	return true;

}, "Age licence obtained invalid due to driver's age.");

//
// Ensures that client agrees to the field
// Makes sure that checkbox for 'Y' is checked
//
$.validator.addMethod("agree", function (value, element) {
	if (value == "Y") {
		return $(element).is(":checked");
	} else {
		return false;
	}
}, "");

// TODO: delete this when all vertical are on the new framework
// Name is alpha and .'\-, only with no foreign characters as providers don't support them
// Ensures that an email address or URL is not being entered
//
if (typeof meerkat === 'undefined' || typeof meerkat.modules.validation === 'undefined') {
	var validNameCharsRegex = /^([a-zA-Z .'\-,]*)$/;
	var isUrlRegex = /(?:[^\s])\.(com|co|net|org|asn|ws|us|mobi)(\.[a-z][a-z])?/;
	$.validator.addMethod("personName",
		function validatePersonName(value, element) {
			return value.match(isUrlRegex) === null && validNameCharsRegex.test(value);
		},
		"Please enter alphabetic characters only. Unfortunately, international " +
		"alphabetic characters, numbers and symbols are not supported by many of our " +
		"partners at this time.");
}

// TODO: delete this when all vertical are on the new framework
// Validate only numeric only fields with no foreign characters as providers don't support them
// Ensures that an email address or URL is not being entered
if (typeof meerkat === 'undefined' || typeof meerkat.modules.validation === 'undefined') {
	var validNumericRegex = /^(\d+)$/;
	$.validator.addMethod("numericOnly",
		function validateNumericOnly(value, element) {
			return validNumericRegex.test(value);
		},
		"Please enter a valid number.");
}


//
// Validates OK to call which ensure we have a phone number if they select yes
//
$.validator.addMethod("okToCall", function() {
	return !($('input[name="quote_contact_oktocall"]:checked').val() == "Y"
	&& $('input[name="quote_contact_phone"]').val() == "");

}, "");

//
//Validates OK to email which ensure we have a email address if they select yes
//
$.validator.addMethod("marketing", function () {
	if ($('input[name="quote_contact_marketing"]:checked').val() == "Y"
		&& $('input[name="quote_contact_email"]').val() == "") {
		return false;
	} else {
		$('input[name="quote_contact_email"]').parent().removeClass('state-right state-error');
		return true;
	}

}, "");

$.validator.addMethod(
	"validAddress",
	function(value, element, name) {
		"use strict";

		// Default is to FAIL
		var valid = false;

		if(typeof meerkat != 'undefined') {

			var $ele = $(element);
			var $streetSearch = $("#" + name + "_streetSearch");
			var $streetNoElement = $("#" + name + "_streetNum");
			var $unitShopElement = $("#" + name + "_unitShop");
			var $unitSelElement = $("#" + name + "_unitSel");
			var $unitTypeElement = $("#" + name + "_unitType");
			var $dpIdElement = $("#" + name + "_dpId");
			var $streetIdElement = $("#" + name + "_streetId");
			var $houseNoSel = $("#" + name + "_houseNoSel");
			var houseNo = $streetNoElement.val();
			var isNonStd = $("#" + name + "_nonStd").is(":checked");

			var fldName = $ele.attr("id").substring(name.length);
			var type = $("#" + name + "_type").val();
			;
			var selectedAddress = window.selectedAddressObj[type];

			switch (fldName) {
				case "_streetSearch":

					if (isNonStd) {
						$ele.removeClass("error has-error");
						$ele.removeClass('has-error');
						$ele.closest('.form-group').find('.row-content').removeClass('has-error')
							.end().find('.error-field').remove();
						return true;
					}
					var suburbName = $("#" + name + "_suburbName").val();
					var suburbSelect = $("#" + name + "_suburb").val();
					var validSuburb =  suburbName != "" && suburbSelect != "";
					if (!validSuburb) {
						return false;
					}
					if(houseNo == "") {
						houseNo = $houseNoSel.val();
						$streetNoElement.val(houseNo);
					}
					if ($streetNoElement.hasClass('canBeEmpty')) {
						$unitShopElement.valid();
						valid = true;
					} else if (houseNo != '') {

						if($streetNoElement.is(":visible")){
							$streetNoElement.valid();
						}

						$ele.removeClass("error has-error");
						valid = true;
					}

					if (valid && ($dpIdElement == "" || $("#" + name + "_fullAddress").val() == "")) {
						var unitType = $unitTypeElement.val();
						var unitNo = $unitSelElement.val();
						if (unitNo == "") {
							unitNo = $unitShopElement.val();
						}

						valid = validateAddressAgainstServer(name,
							$dpIdElement, {
								streetId : $streetIdElement.val(),
								houseNo : houseNo,
								unitNo : unitNo,
								unitType : unitType
							}, $ele);
					}

					/**
					 * Validation overrides to prevent errors being thrown on this field
					 * while we know the user is still entering data.
					 */
					if(!valid && _.isEmpty(selectedAddress.dpId)) {
						if( _.isNumber(selectedAddress.streetId) && selectedAddress.houseNo == '0' ) {
							// Pass if a street has been searched and located but no house number assigned yet
							valid = true;
						} else if(_.isNumber(selectedAddress.streetId) && selectedAddress.hasUnits) {
							// Check unit fields
							if(selectedAddress.hasEmptyUnits) {
								valid = selectedAddress.unitNo == '' && selectedAddress.unitType == '';
							} else {
								valid = selectedAddress.unitNo == '' || selectedAddress.unitType == '';
							}
						}
					} else if (!valid && !_.isEmpty(selectedAddress.dpId) && (selectedAddress.emptyHouseNumberHasUnits || selectedAddress.emptyHouseNumber)) {
						valid = true;
					}
					break;
				case "_streetNum":
					if(isNonStd) {
						valid = true;
					} else if(!_.isEmpty(selectedAddress.dpId)) {
						valid = true;
						// If street found but no street number then pass for now
					} else if(selectedAddress.streetId > 0 && (_.isEmpty(selectedAddress.houseNo) || selectedAddress.houseNo == '0')) {
						valid = true;
						// If house number enter but no unit info then pass for now
					} else if(!_.isEmpty(selectedAddress.houseNo) && selectedAddress.hasUnits === true) {
						if(selectedAddress.hasEmptyUnits === false && (selectedAddress.unitNo == "" || selectedAddress.unitType == "")) {
							valid = true;
						}
					}
					break;
				case "_unitShop":
					if(isNonStd || !_.isEmpty(selectedAddress.dpId)) {
						valid = true;
					} else if(selectedAddress.hasEmptyUnits === false && selectedAddress.unitNo != '' && selectedAddress.unitNo != '0') {
						valid = true;
					}
					break;
				case "_unitType":
					if(isNonStd || !_.isEmpty(selectedAddress.dpId)) {
						valid = true;
					} else if(selectedAddress.hasEmptyUnits === false && selectedAddress.unitType != '' && selectedAddress.unitType != '0') {
						valid = true;
					}
					break;
				case "_nonStdStreet":
					if (!$ele.is(":visible")) {
						return true;
					}

					if (value == "") {
						return false;
					}
					/** Residential street cannot start with GPO or PO * */
					if (type === 'R') {
						// AddressUtils has been removed from ElasticSearch,
						// so this is needed to keep validation of this on the new verticals
						if (typeof AddressUtils != 'undefined') {
							if (AddressUtils.isPostalBox(value)) {
								return false;
							}
						}
					}
					$ele.trigger("customAddressEnteredEvent", [ name ]);
					return true;
				case "_nonStd":

					if (isNonStd) {
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
						if (!$streetNoElement.hasClass("canBeEmpty")) {
							$streetNoElement.valid();
						}
						$unitShopElement.valid();
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
		} else {

			/* Legacy address validation for non-meerkat verticals */

			$ele = $(element);
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
						houseNo = streetNoElement.val();
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
					if (type === 'R') {
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
		}

		return valid;

	}, "Please enter a valid address"
);

$.validator.addMethod(
	"validStreetSearch",
	function(value, element, name) {
		"use strict";

		// Default is to FAIL
		var valid = false;

		var fullAddressFld = $("#" + name + "_fullAddress");

		if (fullAddressFld.val() !== '') {
			valid = true;
		}

		return valid;

	}, "Please select a valid address"
);

$.validator.addMethod("validAutofilllessSearch", function(value, element, name) {
	"use strict";

	// Default is to FAIL
	var valid = false;
	var fullAddressFld = $("#" + name + "_fullAddress");

	if (fullAddressFld.val() !== '') {
		valid = true;
	}

	return valid;

}, "Please select a valid address" );

$.validator.addMethod(
	"validSuburb",
	function(value, element, name) {
		"use strict";
		var valid = false;

		if ($("#" + name + "_nonStd").is(":checked")) {
			valid = value !== null && value !== '' && value !== 'Please select...';
		} else {
			$(element).removeClass("error has-error");
			valid = true;
		}
		return valid;
	});

validateAddressAgainstServer = function(name, dpIdElement, data, element) {
	var passed = false;

	/* If Safari on iPad running version 6 then need to turn off async
	 as it will fail fatally if longer than 10sec */
	var aSyncOverride = false;
	if(typeof meerkat != 'undefined') {
		aSyncOverride = navigator.userAgent.match(/iPad/i) != null && meerkat.modules.performanceProfiling.isIos6() && navigator.userAgent.match(/Safari/i) != null;
	}

	$.ajax({
		url : "ajax/json/address/get_address.jsp",
		data : data,
		type : "POST",
		async : aSyncOverride,
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
	function (value, element) {
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
	if (url === null)
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

// Stand corrected. This is used in life but we also seem to have a meerkat version as well.
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

$.validator.addMethod('confirmLandline', function (value) {
	var strippedValue = value.replace(/[^0-9]+/g, '');
	return strippedValue == '' || isLandLine(strippedValue);
});

$.validator.addMethod('validateTelNo', function (value) {
	if (value.length == 0) return true;

	var strippedValue = value.replace(/[^0-9]/g, '');
	if (strippedValue.length == 0 && value.length > 0) {
		return false;
	}

	var phoneRegex = new RegExp('^(0[234785]{1}[0-9]{8})$');
	return phoneRegex.test(strippedValue);
});

$.validator.addMethod('validateMobile', function (value) {
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
	return mobileElement.val() + otherElement.val() != '';
});

isLandLine = function(number) {
	var mobileRegex = new RegExp("^(0[45]{1})");
	var voipsNumber = number.indexOf("0500") == 0;
	return !mobileRegex.test(number) || voipsNumber;
};

$.validator.addMethod("fromToDate", function(value, element, params){
	if (typeof params === 'undefined' || (!params.hasOwnProperty('toDate') && !params.hasOwnProperty('fromDate'))) return false;

	var fromDateVal = $('#'+params.fromDate).val();
	var toDateVal = $('#'+params.toDate).val();

	if (fromDateVal != '' && toDateVal != '')
	{
		return date_gt_date(toDateVal, fromDateVal)
	}

	return true;
});

$.validator.addMethod("digitsIgnoreComma", function(value, element, params) {
	// Replace commas with blanks.
	value = value.replace(/,/g, "");
	// Do the normal digit check.
	return this.optional(element) || /^\d+$/.test(value);
});

date_gt_date = function (date1, date2){

	// Parse dates first
	d1 = date1.split('/');
	d2 = date2.split('/');

	// Prepend leading zeros
	for(var i=0;i<3;i++){
		if(parseInt(d1[i])<10 && d1[i].indexOf('0')==-1) d1[i]='0'+d1[i];
		if(parseInt(d2[i])<10 && d2[i].indexOf('0')==-1) d2[i]='0'+d2[i];
	}

	// Return true if Date 2 >= Date 1
	var datenum1 = parseInt(d1[2]+d1[1]+d1[0]);
	var datenum2 = parseInt(d2[2]+d2[1]+d2[0]);

	return datenum2 <= datenum1;
};
