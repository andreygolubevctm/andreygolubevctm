window.selectedAddressObj  = {
	P:{
		hasUnits:false
	},
	R:{
		hasUnits:false
	}
};

function init_address(name, defaultSuburbSeq) {
	"use strict";

	var residentalAddress = true;
	var isPostalAddress = false;

	// General/default elements
	var autofilllessSearchInput = $("#" + name + "_autofilllessSearch"),
		autofilllessSearchFieldRow = $("#" + name + "_autofilllessSearchRow"),
		nonStdCheckbox = $("#" + name + "_nonStd"),
		lastSearchHidden = $("#" + name + "_lastSearch"),
		fullAddressLineOneHidden = $("#" + name + "_fullAddressLineOne"),
		fullAddressHidden = $("#" + name + "_fullAddress"),
		allNonStdFieldRows = $("." + name + "_nonStdFieldRow");

	// Lookup hidden fields (populated in address_lookup.js)
	var lookupStreetNameHidden = $("#" + name + "_streetName"),
		lookupStreetIdHidden = $("#" + name + "_streetId"),
		lookupUnitTypeHidden = $('#' + name + '_unitType'),
		lookupPostCodeHidden = $("#" + name + "_postCode"),
		lookupUnitSelHidden = $("#" + name + "_unitSel"),
		lookupHouseNoSelHidden = $("#" + name + "_houseNoSel"),
		lookupSuburbNameHidden = $("#" + name + "_suburbName"),
		lookupStateHidden = $("#" + name + "_state"),
		lookupDpIdHidden = $("#" + name + "_dpId");

	// Non standard fields
	var nonStdPostCodeInput = $("#" + name + "_nonStdPostCode"),
		nonStdSuburbInput = $("#" + name + "_suburb"),
		nonStdStreetNameInput = $("#" + name + "_nonStdStreet"),
		nonStdStreetNumInput = $("#" + name + "_streetNum"),
		nonStdUnitShopInput = $("#" + name + "_unitShop"),
		nonStdUnitTypeInput = $('#' + name + '_nonStdUnitType');

	// Other
	var fieldName				= name,
		selectedStreetFld		= "",
		userStartedTyping		= true,
		streetNumFldLastSelected = null,
		excludePostBoxes = residentalAddress || !isPostalAddress;

	var getType = function() {
		return isPostalAddress ? "P" : "R";
	};

	nonStdUnitShopInput.data("srchLen" , 1);
	nonStdStreetNumInput.data("srchLen" , 1);
	autofilllessSearchInput.data("srchLen" , 2);

	// Watch for these events.
	autofilllessSearchInput.on('keyup blur focus', clearValidationOnEmpty);
	nonStdCheckbox.on('change', swapInputsCleanValidation);
	nonStdPostCodeInput.on('change keyup', postCodeLookup);
	nonStdSuburbInput.on('change', setSuburbName);

	function clearValidationOnEmpty() {
		// Remove the validation if the input is empty.
		// Always remove the error validation, this prevents autofill from happening when a partial entry has been made.
		if (autofilllessSearchInput.val() == '' || autofilllessSearchInput.closest('.row-content').hasClass('has-error')) {
			toggleValidationStyles(autofilllessSearchInput);
		}

		if (autofilllessSearchInput.val() != fullAddressHidden.val()) {
			resetSelectAddress();
			toggleValidationStyles(autofilllessSearchInput);
		}
	}

	function swapInputsCleanValidation() {
		var $errorContainer = $("#elasticsearch-std-error-container");

		if ($(this).is(':checked')) {
			// Hide street search fields
			autofilllessSearchFieldRow.hide();
			// Show non-standard fields
			allNonStdFieldRows.show();

			// Reset the selected address.
			resetNonStdFields(true, false);
			resetElasticSearchFields();

			$errorContainer.hide();
		} else {
			// Show street search fields
			autofilllessSearchFieldRow.show();
			// Show non-standard fields
			allNonStdFieldRows.hide();

			// Reset the selected address.
			resetNonStdFields(true, false);
			resetElasticSearchFields();

			$errorContainer.show();
		}
	}

	function resetNonStdFields(cleanData, ignorePostCode) {
		if (cleanData) {
			if (!ignorePostCode) {
				toggleValidationStyles(nonStdPostCodeInput.val(''));
			}
			toggleValidationStyles(nonStdSuburbInput.val(''));
			toggleValidationStyles(nonStdStreetNameInput.val(''));
			toggleValidationStyles(nonStdStreetNumInput.val(''));
			toggleValidationStyles(nonStdUnitShopInput.val(''));
			toggleValidationStyles(nonStdUnitTypeInput.val(''));

		} else {
			toggleValidationStyles(nonStdPostCodeInput);
			toggleValidationStyles(nonStdSuburbInput);
			toggleValidationStyles(nonStdStreetNameInput);
			toggleValidationStyles(nonStdStreetNumInput);
			toggleValidationStyles(nonStdUnitShopInput);
			toggleValidationStyles(nonStdUnitTypeInput);

		}
		if (!ignorePostCode) {
			nonStdSuburbInput.html("<option value=''>Enter Postcode</option>").attr("disabled", "disabled");
		}

	}

	function resetElasticSearchFields() {
			toggleValidationStyles(autofilllessSearchInput);
			autofilllessSearchInput.val('');
			lookupStreetNameHidden.val('');
			lookupStreetIdHidden.val('');
			lookupUnitTypeHidden.val('');
			lookupPostCodeHidden.val('');
			lookupUnitSelHidden.val('');
			lookupHouseNoSelHidden.val('');
			lookupSuburbNameHidden.val('');
			lookupStateHidden.val('');
			lookupDpIdHidden.val('');

	}

	function postCodeLookup() {
		var postCodeField = $(this);

		if (postCodeField.val().length === 4) {
			// Clear associated fields if value changes
			if ($(this).data('previous') != postCodeField.val()) {
				if(!nonStdCheckbox.is(':checked')) {
					removeValidationOnStdSearchForm();

				}
				reset();
				autofilllessSearchInput.val("");
				nonStdStreetNameInput.val("");
				postCodeField.data('previous', postCodeField.val());
				lookupPostCodeHidden.val(postCodeField.val());

				updateSuburb($(this).val(), function validatePostCode(valid) {
					if(valid) {
						postCodeField.removeClass("invalidPostcode");

					} else {
						postCodeField.addClass("invalidPostcode");

					}
					postCodeField.valid();

				});
			}
		} else {
			resetNonStdFields(true, true);
		}
	}

	if (typeof meerkat !== 'undefined') {
		meerkat.messaging.subscribe(meerkat.modules.events.autocomplete.CANT_FIND_ADDRESS, function handleCantFindAddress(data) {
			nonStdCheckbox.prop('checked', true);
			nonStdCheckbox.change();
			nonStdPostCodeInput.focus();
		});
	}

	var toggleValidationStyles = function(element, state) {
		if(state === true) {
			element.removeClass('has-error').addClass('has-success');
			element.closest('.form-group').find('.row-content').removeClass('has-error').addClass('has-success')
			.end().find('.error-field').remove();
		} else if(state === false){
			element.removeClass('has-success').addClass('has-error');
			element.closest('.form-group').find('.row-content').removeClass('has-success').addClass('has-error');
		} else {
			element.removeClass('has-success has-error');
			element.closest('.form-group').find('.row-content').removeClass('has-success has-error')
			.end().find('.error-field').remove();
		}
	};

	var updateSuburb = function(code, callback) {
		resetNonStdFields(false, false);
		// Validate postcode
		if (/[0-9]{4}/.test(code) === false) {
			nonStdSuburbInput.html("<option value=''>Enter Postcode</option>").attr("disabled", "disabled");

			if(typeof callback === 'function') {
				callback(false);
			}
			return false;
		}

		$.getJSON("ajax/json/address/get_suburbs.jsp",
			{
				postCode:code,
				excludePostBoxes:excludePostBoxes
			},
			function suburbsResponse(resp) {
				if (resp.suburbs && resp.suburbs.length > 0) {
					nonStdSuburbInput.removeAttr("disabled");
					var options = '';
					if(resp.suburbs.length != 1) {
						options = '<option value="">Please select...</option>';
					}
					for (var i = 0; i < resp.suburbs.length; i++) {
						if (resp.suburbs.length == 1  || (typeof defaultSuburbSeq !== 'undefined' && defaultSuburbSeq !== null && resp.suburbs[i].id == defaultSuburbSeq)) {
							options += '<option value="' + resp.suburbs[i].id + '" selected="selected">' + resp.suburbs[i].des + '</option>';

						} else {
							options += '<option value="' + resp.suburbs[i].id + '">' + resp.suburbs[i].des + '</option>';
						}
					}

					nonStdSuburbInput.html(options);
					if(typeof callback == 'function') {
						callback(true);
					}
					if(resp.postBoxOnly) {
						if(!nonStdCheckbox.is(':checked')) {
							nonStdCheckbox.prop('checked', true);
							nonStdCheckbox.change();
							nonStdSuburbInput.focus();
						}
					}
				} else {
					nonStdSuburbInput.html("<option value=''>Invalid Postcode</option>").attr("disabled", "disabled");
					if(typeof callback === 'function') {
						callback(false);
					}
				}
				if (resp.state && resp.state.length > 0){
					lookupStateHidden.val(resp.state);
				} else {
					lookupStateHidden.val("");
				}
				setSuburbName();
			}
		);
	};

	// Handle prefilled fields (e.g. retrieved quote)
	nonStdPostCodeInput.data('previous', nonStdPostCodeInput.val());
	updateSuburb(nonStdPostCodeInput.val());
	if (nonStdCheckbox.is(':checked')) {
		autofilllessSearchFieldRow.hide();
		allNonStdFieldRows.show();
	}

	var getSearchURLStreetFld = function(event, callback) {

		var streetSearch = getFormattedStreet($(this).val(), true);
		var lastSearch = getFormattedStreet(lastSearchHidden.val(), true);
		if(lastSearch != streetSearch || userStartedTyping) {
			streetSearch = streetSearch.replace(/\'/g,'&#39;');
			userStartedTyping = false;

			// STREET
			var url = "address/search.json?query="+autofilllessSearchInput.val();

			lastSearchHidden.val(autofilllessSearchInput.val());

			autofilllessSearchInput.data('source-url', url);

			if (typeof callback === 'function') {
				callback(url);
			}
		}
	};

	autofilllessSearchInput.on('getSearchURL' , getSearchURLStreetFld);

	var populateFullAddressStreetSearch =  function(event, name, jsonAddress) {

		if(name != fieldName) {
			return;
		}

		var hasUnits = window.selectedAddressObj[getType()].hasUnits;
		window.selectedAddressObj[getType()] = _.extend(window.selectedAddressObj[getType()], jsonAddress);
		if(window.selectedAddressObj[getType()].fullAddress == "") {
			setUnitType();
			window.selectedAddressObj[getType()].fullAddress = getFullAddress(jsonAddress);
		}
		if(window.selectedAddressObj[getType()].fullAddressLineOne == "") {
			window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
		}
		lookupDpIdHidden.val(window.selectedAddressObj[getType()].dpId);
		fullAddressHidden.val(window.selectedAddressObj[getType()].fullAddress);
		fullAddressLineOneHidden.val(window.selectedAddressObj[getType()].fullAddressLineOne);
	};

	var getFormattedStreet = function(street, convertToUppercase) {
		var formattedStreet = street;
		if(convertToUppercase) {
			formattedStreet = street.toUpperCase();
		}
		formattedStreet =$.trim(formattedStreet.replace(/\s{2,}/g," "));
		// eg "The Place" but not "The Yachtsmans Dr"
		var hasThe = formattedStreet.split(" ") == 1 && formattedStreet.toUpperCase().substring(0, 4) == "THE ";
		if(!hasThe && formattedStreet.indexOf(" ") != -1) {
			var street = formattedStreet.substring(0, formattedStreet.lastIndexOf(" ") + 1);
			var suffix = formattedStreet.substring(formattedStreet.lastIndexOf(" ") + 1, formattedStreet.length).toUpperCase();
			var suffixes = new Array();

			suffixes[0] = ["Arc" ,':ARC:ARC.:ARCADE:'];
			suffixes[1] = ["Accs" ,':ACCS:ACCS.:ACCESS:'];
			suffixes[2] = ["Ally" ,':ALLEY:ALLY.:ALLY:'];
			suffixes[3] = ["Boulevard" ,':BLVD:BOULEVARD:BLVD.:'];
			suffixes[4] = ["Ct" ,':CT:COURT:CT.:'];
			suffixes[5] = ["Cct" ,':CCT.:CIRCUIT:CCT:'];
			suffixes[6] = ["Cl" ,':CL.:Close:CL:'];
			suffixes[7] = ["Cres" ,':CRES.:CRESCENT:CRES:'];
			suffixes[8] = ["Dr" ,':DR.:DRIVE:DR:'];
			suffixes[9] = ["Gr" ,':GR.:GROVE:GR:'];
			suffixes[10] = ["Pde" ,':PDE.:PARADE:PDE:'];
			suffixes[11] = ["Rd" ,':RD:ROAD:RD.:'];
			suffixes[12] = ["St" ,':ST:STREET:ST.:'];
			suffixes[13] = ["Ave" ,':AVE:AVENUE:AV:AV.:AVE.:'];
			suffixes[14] = ["Hwy" ,':HIGHWAY:HWY:HWY.:HIGH:'];

			for (var i = 0; i < suffixes.length; i++) {
				var suffixmappings = suffixes[i];
				var suffixmapping = suffixmappings[1];
				if(suffixmapping.indexOf(":" + suffix + ":") >= 0) {
					if(convertToUppercase) {
						formattedStreet = street + suffixmappings[0].toUpperCase();
					} else {
						formattedStreet = street + suffixmappings[0];
					}
					break;
				}
			}
		}
		return formattedStreet;
	};

	var populateFullAddress =  function(event, name) {

		if(name != fieldName) return;

		window.selectedAddressObj[getType()].unitNo = $.trim(nonStdUnitShopInput.val().toUpperCase().replace(/\s{2,}/g," "));
		if(nonStdCheckbox.is(":checked")) {
			window.selectedAddressObj[getType()].unitType = $.trim(nonStdUnitTypeInput.val());
		}
		setUnitType();

		setSuburbName();
		window.selectedAddressObj[getType()].state = lookupStateHidden.val().toUpperCase();
		window.selectedAddressObj[getType()].houseNo =$.trim(nonStdStreetNumInput.val().toUpperCase().replace(/\s{2,}/g," "));
		if(nonStdCheckbox.is(":checked")) {
			window.selectedAddressObj[getType()].streetName = getFormattedStreet(nonStdStreetNameInput.val() , false);
		} else {
			window.selectedAddressObj[getType()].streetName = getFormattedStreet(lookupStreetNameHidden.val() , false);
		}

		var suburb = nonStdSuburbInput.val();
		var postcode = nonStdPostCodeInput.val();
		window.selectedAddressObj[getType()].suburbSequence = typeof suburb == 'undefined' || suburb == null ? "" : suburb.toUpperCase();
		window.selectedAddressObj[getType()].postCode = typeof postcode == 'undefined' || postcode == null ? "" : postcode.toUpperCase();

		if(window.selectedAddressObj[getType()].suburbSequence != "" && window.selectedAddressObj[getType()].streetName != "") {
			var data = {
				postCode : window.selectedAddressObj[getType()].postCode,
				suburbSequence : window.selectedAddressObj[getType()].suburbSequence,
				street : window.selectedAddressObj[getType()].streetName.toUpperCase(),
				houseNo : window.selectedAddressObj[getType()].houseNo,
				unitNo : window.selectedAddressObj[getType()].unitNo,
				unitType : window.selectedAddressObj[getType()].unitType
			};
			$.ajax({
				url: "ajax/json/address/get_address.jsp",
				data: data,
				dataType: "json",
				type: "POST",
				async: true,
				cache: false,
				success: function(jsonResult) {
					if(jsonResult.foundAddress) {
						window.selectedAddressObj[getType()] = jsonResult;
						setUnitType();
						if(jsonResult.fullAddress == "") {
							jsonResult.fullAddress = getFullAddress(jsonResult);
							jsonResult.fullAddressLineOne = getFullAddressLineOne();
						}
						lookupDpIdHidden.val(jsonResult.dpId);
						fullAddressHidden.val(jsonResult.fullAddress);
						fullAddressLineOneHidden.val(jsonResult.fullAddressLineOne);
					} else {
						window.selectedAddressObj[getType()].streetName = getFormattedStreet(lookupStreetNameHidden.val() , false);
						window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
						fullAddressLineOneHidden.val(window.selectedAddressObj[getType()].fullAddressLineOne);
						fullAddressHidden.val(getFullAddress(window.selectedAddressObj[getType()]));
					}
				},
				error: function(obj, txt, errorThrown) {
					window.selectedAddressObj[getType()].streetName = getFormattedStreet(lookupStreetNameHidden.val() , false);
					window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
					fullAddressLineOneHidden.val(window.selectedAddressObj[getType()].fullAddressLineOne);
					fullAddressHidden.val(getFullAddress(window.selectedAddressObj[getType()]));
					meerkat.modules.errorHandling.error({
						message:		"An error occurred checking the address: " + txt + ' ' + errorThrown,
						page:			"ajax/json/address/get_address.jsp",
						description:	"legacy_address:populateFullAddress(): " + txt + ' ' + errorThrown,
						errorLevel: 	"silent"
					});
				},
				timeout:6000
			});
		}
	};

	var setUnitType = function() {
		if(window.selectedAddressObj[getType()].unitType != "") {
			window.selectedAddressObj[getType()].unitTypeText = nonStdUnitTypeInput.find('option[value="' + window.selectedAddressObj[getType()].unitType + '"]').text();
			nonStdUnitTypeInput.val(window.selectedAddressObj[getType()].unitType);
			toggleValidationStyles(nonStdUnitTypeInput, true);
		} else {
			window.selectedAddressObj[getType()].unitTypeText = "";
			nonStdUnitTypeInput.val("");
		}
	};

	autofilllessSearchInput.on('typeahead:selected', function streetFldAutocompleteSelected(obj, datum, name) {
		if (typeof datum.text !== 'undefined') {
			var fullAddressLineOneValue = datum.text.substring(0, datum.text.indexOf(','));
			fullAddressLineOneHidden.val(fullAddressLineOneValue);
			fullAddressHidden.val(datum.text);
			autofilllessSearchInput.typeahead('setQuery', datum.text);
		}
	});

	autofilllessSearchInput.focus(function(event) {
		userStartedTyping = true;
	});

	nonStdStreetNumInput.on('getSearchURL', function(event, callback) {
		var url = "";
		if (!nonStdCheckbox.is(":checked")) {
			url = "ajax/json/address_street_number.jsp?" +
						"streetId=" + lookupStreetIdHidden.val() +
						"&search=" + nonStdStreetNumInput.val() +
						"&fieldId=" + nonStdStreetNumInput.attr("id");
		}

		nonStdStreetNumInput.data('source-url', url);

		if (typeof callback === 'function') {
			callback(url);
		}
	});

	nonStdStreetNumInput.on('typeahead:selected', function streetNumFldAutocompleteSelected(obj, datum, name /*event, key, val*/) {
		window.selectedAddressObj[getType()].houseNo = datum.value;
		setHouseNo();
		streetNumFldLastSelected = nonStdStreetNumInput.val();

		// values[1] will contain the number of units/shops/levels etc
		window.selectedAddressObj[getType()].hasUnits = (datum.unitCount > 1);
		window.selectedAddressObj[getType()].hasEmptyUnits = (datum.minUnitNo == '0');
		if (window.selectedAddressObj[getType()].hasUnits) {
			if(window.selectedAddressObj[getType()].hasEmptyUnits) {
				window.selectedAddressObj[getType()].dpId = datum.dpId;
			} else {
				resetSelectAddress();
			}
			toggleValidationStyles(nonStdStreetNumInput, true);
		} else {
			window.selectedAddressObj[getType()].unitNo = "";
			window.selectedAddressObj[getType()].unitType = "";
			setUnitType();
			window.selectedAddressObj[getType()].dpId = datum.dpId; //values[2];
			lookupDpIdHidden.val(window.selectedAddressObj[getType()].dpId);
			window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
			fullAddressLineOneHidden.val(window.selectedAddressObj[getType()].fullAddressLineOne);
			fullAddressHidden.val(getFullAddress(window.selectedAddressObj[getType()]));

			/* Let's nicely format the address into one line if we've got this far */
			_.defer(function(){ // wrapped in defer for iPad (not iPhone... just iPad)
				attemptToConfirmFullAddress(nonStdStreetNumInput);
			});
		}
	});

	nonStdStreetNumInput.on("change blur", function() {
		if (!nonStdCheckbox.is(":checked")){
			nonStdUnitShopInput.val("");
			window.selectedAddressObj[getType()].unitType = "";
			setUnitType();
			resetSelectAddress();
			if (streetNumFldLastSelected && streetNumFldLastSelected != $(this).val()){
				window.selectedAddressObj[getType()].hasUnits = false;
			}
			if (streetNumFldLastSelected != $(this).val()){
				window.selectedAddressObj[getType()].houseNo = nonStdStreetNumInput.val();
				lookupHouseNoSelHidden.val(window.selectedAddressObj[getType()].houseNo);
				toggleValidationStyles(nonStdStreetNumInput);
			}
		} else {
			window.selectedAddressObj[getType()].houseNo = nonStdStreetNumInput.val();
			lookupHouseNoSelHidden.val("");
		}
	});

	nonStdUnitShopInput.on('getSearchURL' , function(event, callback) {
		if (nonStdCheckbox.is(":checked")) {
			if (typeof callback === 'function') {
				callback("");
			}
		} else {
			var houseNo = nonStdStreetNumInput.val();
			if (lookupHouseNoSelHidden.val() != ""){
				houseNo = lookupHouseNoSelHidden.val();
			}
			var url = "ajax/json/address_shopunitlevel.jsp?" +
						"streetId=" + lookupStreetIdHidden.val() +
						"&houseNo=" + houseNo +
						"&search=" + $.trim($(this).val()) +
						"&unitType=" + nonStdUnitTypeInput.val() +
						"&fieldId=" + $(this).attr("id")+
						"&residentalAddress=" + residentalAddress;

			nonStdUnitShopInput.data('source-url', url);

			if (typeof callback === 'function') {
				callback(url);
			}
		}
	});

	var resetSelectAddress = function() {
		window.selectedAddressObj[getType()].dpId = "";
		lookupDpIdHidden.val("");
		fullAddressLineOneHidden.val("");
		fullAddressHidden.val("");
	};

	var reset = function(resetAll) {
		resetSelectAddress();
		selectedStreetFld = "";
		lookupStreetIdHidden.val("");
		nonStdSuburbInput.val("");
		lookupStreetNameHidden.val("");
		lookupSuburbNameHidden.val("");
		nonStdStreetNumInput.val("");
		lookupHouseNoSelHidden.val("");
		nonStdUnitShopInput.val("");
		lookupUnitSelHidden.val("");
		nonStdUnitTypeInput.val("");
		lookupPostCodeHidden.val("");
		lookupStateHidden.val("");
		streetNumFldLastSelected = null;
		window.selectedAddressObj[getType()] = {hasUnits: false};
	};

	var getFullAddressLineOne = function() {
		if(typeof(window.selectedAddressObj[getType()].streetName) == 'undefined') {
			window.selectedAddressObj[getType()].streetName = "";
		}
		var fullAddressLineOneValue  = "";
		if(window.selectedAddressObj[getType()].unitNo != "" && window.selectedAddressObj[getType()].unitNo != '0') {
			if(window.selectedAddressObj[getType()].unitType != "OT" && window.selectedAddressObj[getType()].unitType != "" && typeof window.selectedAddressObj[getType()].unitType != 'undefined') {
				fullAddressLineOneValue  += window.selectedAddressObj[getType()].unitTypeText + " ";
			}
			fullAddressLineOneValue  += window.selectedAddressObj[getType()].unitNo + " ";
		}
		if(window.selectedAddressObj[getType()].houseNo != "" && window.selectedAddressObj[getType()].houseNo != '0') {
			fullAddressLineOneValue  += window.selectedAddressObj[getType()].houseNo + " " + window.selectedAddressObj[getType()].streetName;
		} else {
			fullAddressLineOneValue  += window.selectedAddressObj[getType()].streetName;
		}

		return fullAddressLineOneValue;
	};

	var getFullAddress = function(jsonAddress) {

		window.selectedAddressObj[getType()] = _.extend(window.selectedAddressObj[getType()], jsonAddress);
		var fullAddressLineOne = jsonAddress.fullAddressLineOne;
		if(typeof fullAddressLineOne == 'undefined' || fullAddressLineOne == "") {
			fullAddressLineOne  = getFullAddressLineOne();
		}

		return fullAddressLineOne + "," +  jsonAddress.suburb + " " + jsonAddress.state + " " + jsonAddress.postCode;
	};

	$(document).ready(function() {
		$(document).on('validStreetSearchAddressEnteredEvent', populateFullAddressStreetSearch);
		$(document).on('customAddressEnteredEvent', populateFullAddress);
	});

	var attemptToConfirmFullAddress = function(element) {
		validateAddressAgainstServer(
			fieldName,
			lookupDpIdHidden, {
				streetId : window.selectedAddressObj[getType()].streetId,
				houseNo : window.selectedAddressObj[getType()].houseNo,
				unitNo : window.selectedAddressObj[getType()].unitNo,
				unitType : window.selectedAddressObj[getType()].unitType
			},
			element
		);
	}
;
	var setSuburbName =  function() {
		window.selectedAddressObj[getType()].suburbSeq = nonStdSuburbInput.val();
		if(window.selectedAddressObj[getType()].suburbSeq == "") {
			window.selectedAddressObj[getType()].suburb = "";
			lookupSuburbNameHidden.val("");
		} else {
			window.selectedAddressObj[getType()].suburb = nonStdSuburbInput.find("option:selected").text();
			lookupSuburbNameHidden.val(window.selectedAddressObj[getType()].suburb);
		}
	};

	var setHouseNo =  function() {
		nonStdStreetNumInput.val(window.selectedAddressObj[getType()].houseNo);
		lookupHouseNoSelHidden.val(window.selectedAddressObj[getType()].houseNo);
	};

	if(nonStdCheckbox.is(":checked")) {
		window.selectedAddressObj[getType()].streetName = getFormattedStreet(nonStdStreetNameInput.val() , false);
		window.selectedAddressObj[getType()].houseNo = nonStdStreetNumInput.val();
	} else {
		window.selectedAddressObj[getType()].streetName = getFormattedStreet(lookupStreetNameHidden.val() , false);
		window.selectedAddressObj[getType()].houseNo = lookupHouseNoSelHidden.val();
	}
}