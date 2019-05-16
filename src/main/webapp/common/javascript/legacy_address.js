var postalMatchHandler =  {
	init: function(name){
		var postalMatch = $('#' + name + '_postalMatch');
		this.setPostal(postalMatch , name);
		postalMatch.on('change', function(){
			postalMatchHandler.setPostal(postalMatch , name);
		});
	},
	setPostal: function(postalMatch , name){
		var postalGroup = $('#' + name + '_postalGroup');
		if( postalMatch.is(':checked')  ){
			postalGroup.slideUp();
			postalGroup.find('input,select').addClass('dontSubmit');
		} else {
			postalGroup.slideDown();
			postalGroup.find('input,select').removeClass('dontSubmit');
		}
	}
};

var AddressUtils = new Object();
AddressUtils = {
	isPostalBox : function(street){
		"use strict";
		var formattedStreet =$.trim(street.toUpperCase().replace(/[^A-Z]/g, ""));
		var postBoxPrefixes = ':GPOBOX:GENERALPOSTOFFICEBOX:POBOX:POBX:POBOX:POSTOFFICEBOX:CAREPO:CAREOFPOSTOFFICE' +
					':CMB:COMMUNITYMAILBAG:CMA:CPA:LOCKEDBAG:MS:RSD:RMB:ROADSIDEMAILBOX:ROADSIDEMAILBAG:RMS:PRIVATEBAG:PMB:';
		return postBoxPrefixes.indexOf(":" + formattedStreet + ":") != -1 ;

	}
};

window.selectedAddressObj  = {
	P:{
		hasUnits:false
	},
	R:{
		hasUnits:false
	}
};

function init_address(name, residentalAddress , isPostalAddress, defaultSuburbSeq) {
	"use strict";

	var streetFld			= $("#" + name + "_streetSearch"),
	lastSearchFld			= $("#" + name + "_lastSearch"),
	streetNameFld			= $("#" + name + "_streetName"),
	streetIdFld				= $("#" + name + "_streetId"),
	unitInputFld			= $("#" + name + "_unitShop"),
	unitSelFld				= $("#" + name + "_unitSel"),
	unitTypeFld				= $('#' + name + '_unitType'),
	postCodeFld				= $("#" + name + "_postCode"),
	streetNumFld 			= $("#" + name + "_streetNum"),
	houseNoSelFld			= $("#" + name + "_houseNoSel"),
	nonStdStreet			= $("#" + name + "_nonStdStreet"),
	streetNumRow			= $("#" + name + "_streetNumRow"),
	unitShopRow				= $("." + name + "_unitShopRow"),
	nonStdstreetRow			= $("." + name + "_nonStd_street"),
	suburbFld				= $("#" + name + "_suburb"),
	suburbNameFld			= $("#" + name + "_suburbName"),
	stateFld				= $("#" + name + "_state"),
	dpIdFld					= $("#" + name + "_dpId"),
	fullAddressLineOneFld	= $("#" + name + "_fullAddressLineOne"),
	fullAddressFld			= $("#" + name + "_fullAddress"),
	stdStreetFld			= $("#" + name + "_std_street"),
	nonStdFld				= $("#" + name + "_nonStd"),
	nonStdFldRow			= $("#" + name + "_nonStd_row"),
	nonStdContainer			= $("." + name + "_non_standard_container"),
	fieldName				= name,
	selectedStreetFld		= "",
	userStartedTyping		= true;

	var getType = function() {
		return isPostalAddress ? "P" : "R";
	};

	unitInputFld.data("srchLen" , 1);
	streetNumFld.data("srchLen" , 1);
	streetFld.data("srchLen" , 2);

	var streetNumFldLastSelected = null;
	var excludePostBoxes = residentalAddress || !isPostalAddress;

	// POSTCODE
	postCodeFld.on('change', function postCodeFldInput() {
		// Clear associated fields if value changes
		if ($(this).data('previous') != $(this).val()) {
			if(!nonStdFld.is(':checked')) {
				removeValidationOnStdSearchForm();
			}
			reset();
			streetFld.val("");
			nonStdStreet.val("");
			lastSearchFld.val("");
			selectedStreetFld = "";
			$(this).data('previous', $(this).val());
			updateSuburb($(this).val(), function validatePostCode(valid) {
				if(valid) {
					postCodeFld.removeClass("invalidPostcode");
				} else {
					postCodeFld.addClass("invalidPostcode");
				}
				postCodeFld.valid();
			});
		}
	});

	if (typeof meerkat !== 'undefined') {
		meerkat.messaging.subscribe(meerkat.modules.events.autocomplete.CANT_FIND_ADDRESS, function handleCantFindAddress(data) {
			// Check that the event came from this address group
			if (data.hasOwnProperty('fieldgroup') && data.fieldgroup === fieldName) {
				//nonStdFld.prop('checked', false);
				//nonStdFld.click();
				nonStdFld.prop('checked', true);
				nonStdFld.change();
				suburbFld.focus();
			}
		});
	}

	suburbFld.on('change', setSuburbName);

	var updateSuburb = function(code, callback) {
		nonStdFldRow.show();
		// Validate postcode
		if (/[0-9]{4}/.test(code) === false) {
			suburbFld.html("<option value=''>Enter Postcode</option>").attr("disabled", "disabled");

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
					suburbFld.removeAttr("disabled");
					var options = '';
					if(resp.suburbs.length != 1) {
						options = '<option value="">Select suburb</option>';
					}
					for (var i = 0; i < resp.suburbs.length; i++) {
						if (resp.suburbs.length == 1  || (typeof defaultSuburbSeq !== 'undefined' && defaultSuburbSeq !== null && resp.suburbs[i].id == defaultSuburbSeq)) {
							options += '<option value="' + resp.suburbs[i].id + '" selected="selected">' + resp.suburbs[i].des + '</option>';

						} else {
							options += '<option value="' + resp.suburbs[i].id + '">' + resp.suburbs[i].des + '</option>';
						}
					}

					suburbFld.html(options);
					if(typeof callback == 'function') {
						callback(true);
					}
					if(resp.postBoxOnly) {
						if(!nonStdFld.is(':checked')) {
							//nonStdFld.prop('checked', true);
							//nonStdFld.click();
							nonStdFld.prop('checked', true);
							nonStdFld.change();
							suburbFld.focus();
						}
						nonStdFldRow.hide();
					}
				} else {
					suburbFld.html("<option value=''>Invalid Postcode</option>").attr("disabled", "disabled");
					if(typeof callback === 'function') {
						callback(false);
					}
				}
				if (resp.state && resp.state.length > 0){
					stateFld.val(resp.state);
				} else {
					stateFld.val("");
				}
				setSuburbName();
			}
		);
	};

    nonStdFld.change(function () {
        if ($(this).is(':checked')) {
            postCodeFld.trigger('change');
        }
	});

	suburbFld.off('change.nonStdAddress').on('change.nonStdAddress', function(){
		if(nonStdFld.is(':checked')) {
			var id = $(this).val();
			var suburb = $(this).find("option[value=" + id + "]").text();
			suburbNameFld.val(suburb);
		}
	});

	// Handle prefilled fields (e.g. retrieved quote)
	postCodeFld.data('previous', postCodeFld.val());
	updateSuburb(postCodeFld.val());

	var searches = [
				// 1 Cat St , 33A Cat St ,  200-210 Cat St, 1 C
				{"name":"Number_Street",
						"regex":"^([\\d-]+[A-Z]{0,1})[\\s]+([A-Z\\s]*)$",
						"fields":["houseNo","street"]},

				// e.g.  1Cat St,
				{"name":"Number_Street",
						"regex":"^([\\d-]+)([A-Z]{2,}[A-Z\\s]*)$",
						"fields":["houseNo","street"]},

				// e.g. 14 LUCY ST., MILTON QLD
				{"name":"Number_Street",
						"regex":"^([A-Z0-9-]+)[\-/\\s]+([A-Z0-9-]+)\\s+([\\w\\W\\s]+)$",
						"fields":["houseNo","street"]},

				// e.g. 24/45 , 3C / 85 , 21-21 / 4
				{"name":"NUMBER_UNIT",
					"regex":"^([\\d]*[\\s-]*[-]{0,1}[\\s-]*[\\d]*[A-Z]{0,1})[\\s]*[/]{1}[\\s]*([\\d]*[\\s-]*[-]{0,1}[\\s-]*[\\d]*[A-Z]{0,1})[\\s]*$",
					"fields":["unitNo", "houseNo"]},

				// e.g. 200, 24-45 , 3C
				{"name":"NUMBER_ONLY",
						"regex":"^([\\d]*[\\s-]*[-]{0,1}[\\s-]*[\\d]*[A-Z]{0,1})[\\s]*[/]{0,1}$",
						"fields":["houseNo"]},

				{"name":"Level_UnitNo/Number_Street",
					"regex":"^[Ll][Ee][Vv][Ee][Ll][\\s+]?([A-Z]*)(\\d*)([a-zA-Z]*)[/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","level","suffix","houseNo","street"]},

				{"name":"Lvl_UnitNo/Number_Street",
					"regex":"^[Ll][Vv]?[Ll]?[\\s+]?([A-Z]*)(\\d*)([a-zA-Z]*)[/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","level","suffix","houseNo","street"]},

				{"name":"UNITNO_UnitNo/Number_Street",
						"regex":"^[Uu][Nn][Ii][Tt]\\s*[Nn][Oo][\.]*\\s*([A-Z]*)(\\d*)([a-zA-Z]*)[/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
						"fields":["prefix","unitNo","suffix","houseNo","street"]},

				{"name":"UNIT_UnitNo/Number_Street",
					"regex":"^[Uu][Nn][Ii][Tt]\\s*([a-zA-Z]*)(\\d*)([A-Z]*)[/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","unitNo","suffix","houseNo","street"]},

				{"name":"UnitNo/Number_Street",
					"regex":"^([a-zA-Z]*)([A-Z0-9-]+)([A-Z]*)[\-/\\s]+([A-Z0-9-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","unitNo","suffix","houseNo","street"]},


				{"name":"U_UnitNo/Number_Street",
					"regex":"^[Uu]\\s*([A-Z]*)(\\d*)([A-Z]*)[/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","unitNo","suffix","houseNo","street"]},


				{"name":"PO_Box_No_Number_Street",
					"regex":"^([Pp][\\.\\s]?[Oo][\\.\\s]?[\\s+]?[Bb][Oo][Xx]\\s+\\d+)$",
					"fields":["POBox"]}
				];


	var getSearchURLStreetFld = function(event, callback) {
		var streetSearch = getFormattedStreet($(this).val(), true);
		var lastSearch = getFormattedStreet(lastSearchFld.val(), true);
		if(lastSearch != streetSearch || userStartedTyping) {
			streetSearch = streetSearch.replace(/\'/g,'&#39;');
			userStartedTyping = false;
			// STREET
			var url = "ajax/json/address_smart_street.jsp?" +
				"postCode=" + postCodeFld.val() +
				"&fieldId=" + $(this).attr("id") +
				"&showUnable=yes" +
				"&residentalAddress=" + residentalAddress;
			lastSearchFld.val(streetFld.val());

			var match = null;
			for (var idx=0,len=searches.length; idx<len; idx++) {
				var search = searches[idx];
				var re = new RegExp(search.regex);
				var reMatch = re.exec(streetSearch);
				if (reMatch != null) {
					for (var i = 1; i < reMatch.length; i++) {
						if(!_.isUndefined(search.fields[i-1])) {
							url = url + "&" + search.fields[i-1] + "=" + $.trim(reMatch[i]);
						}
					}
					match = search;
					break;
				}
			}
			// No match found... send for a street search
			if (match == null) {
				url = url + "&street=" + streetSearch;
			}
			url = url.replace(/\'/g,"");

			streetFld.data('source-url', url);

			if (typeof callback === 'function') {
				callback(url);
			}
		}
	};

	streetFld.on('getSearchURL' , getSearchURLStreetFld);

	var populateFullAddressStreetSearch =  function(event, name, jsonAddress) {

		if(name != fieldName) return;

		var hasUnits = window.selectedAddressObj[getType()].hasUnits;
		window.selectedAddressObj[getType()] = _.extend(window.selectedAddressObj[getType()], jsonAddress);
		if(window.selectedAddressObj[getType()].fullAddress == "") {
			setUnitType();
			window.selectedAddressObj[getType()].fullAddress = getFullAddress(jsonAddress);
		}
		if(window.selectedAddressObj[getType()].fullAddressLineOne == "") {
			window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
		}
		dpIdFld.val(window.selectedAddressObj[getType()].dpId);
		fullAddressFld.val(window.selectedAddressObj[getType()].fullAddress);
		fullAddressLineOneFld.val(window.selectedAddressObj[getType()].fullAddressLineOne);
		lastSearchFld.val("");
		setStreetSearchAddress(window.selectedAddressObj[getType()]);
		if (!hasUnits || (hasUnits && jsonAddress.unitNo != 0 && jsonAddress.unitNo !== '')) {
			unitShopRow.hide();
		}
		streetNumRow.hide();
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

		window.selectedAddressObj[getType()].unitNo = $.trim(unitInputFld.val().toUpperCase().replace(/\s{2,}/g," "));
		if(nonStdFld.is(":checked")) {
			window.selectedAddressObj[getType()].unitType = $.trim(unitTypeFld.val());
		}
		setUnitType();

		setSuburbName();
		window.selectedAddressObj[getType()].state = stateFld.val().toUpperCase();
		window.selectedAddressObj[getType()].houseNo =$.trim(streetNumFld.val().toUpperCase().replace(/\s{2,}/g," "));
		if(nonStdFld.is(":checked")) {
			window.selectedAddressObj[getType()].streetName = getFormattedStreet(nonStdStreet.val() , false);
		} else {
			window.selectedAddressObj[getType()].streetName = getFormattedStreet(streetNameFld.val() , false);
		}

		var suburb = suburbFld.val();
		var postcode = postCodeFld.val();
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
						dpIdFld.val(jsonResult.dpId);
						fullAddressFld.val(jsonResult.fullAddress);
						fullAddressLineOneFld.val(jsonResult.fullAddressLineOne);
						setStreetSearchAddress(jsonResult);
						nonStdstreetRow.hide();
						stdStreetFld.show();
						streetNumRow.hide();
							if(jsonResult.hasUnits && jsonResult.unitNo == 0) {
								unitShopRow.show();
							} else {
								unitShopRow.hide();
							}
					} else {
						window.selectedAddressObj[getType()].streetName = getFormattedStreet(streetNameFld.val() , false);
						window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
						fullAddressLineOneFld.val(window.selectedAddressObj[getType()].fullAddressLineOne);
						fullAddressFld.val(getFullAddress(window.selectedAddressObj[getType()]));
					}
				},
				error: function(obj, txt, errorThrown) {
					window.selectedAddressObj[getType()].streetName = getFormattedStreet(streetNameFld.val() , false);
					window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
					fullAddressLineOneFld.val(window.selectedAddressObj[getType()].fullAddressLineOne);
					fullAddressFld.val(getFullAddress(window.selectedAddressObj[getType()]));
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
			window.selectedAddressObj[getType()].unitTypeText = unitTypeFld.find('option[value="' + window.selectedAddressObj[getType()].unitType + '"]').text();
			unitTypeFld.val(window.selectedAddressObj[getType()].unitType);
			toggleValidationStyles(unitTypeFld, true);
		} else {
			window.selectedAddressObj[getType()].unitTypeText = "";
			unitTypeFld.val("");
		}
	};

	streetFld.on('typeahead:selected', function streetFldAutocompleteSelected(obj, datum, name /*event, key, val*/) {

		var emptyClassName = 'canBeEmpty';
		if(unitInputFld.hasClass( emptyClassName ) ) {
			unitSelFld.removeClass(emptyClassName);
			unitInputFld.removeClass( emptyClassName);
		}
		if(streetNumFld.hasClass(emptyClassName) ) {
			streetNumFld.removeClass(emptyClassName);
		}

		window.selectedAddressObj[getType()] = datum; //jQuery.parseJSON( key );
		setUnitType();
		window.selectedAddressObj[getType()].postCode = postCodeFld.val();

		setStreetSearchAddress(window.selectedAddressObj[getType()]);
		if (window.selectedAddressObj[getType()].houseNo != "" || window.selectedAddressObj[getType()].emptyHouseNumber || window.selectedAddressObj[getType()].emptyHouseNumberHasUnits) {
			// Unit/HouseNo Street Suburb State
			if (window.selectedAddressObj[getType()].unitNo != "") {
				// full address so store dpId
				dpIdFld.val(window.selectedAddressObj[getType()].dpId);
				window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
				fullAddressLineOneFld.val(window.selectedAddressObj[getType()].fullAddressLineOne);
				fullAddressFld.val(getFullAddress(window.selectedAddressObj[getType()]));
				// HouseNo Street Suburb State
			} else {
				if (window.selectedAddressObj[getType()].hasUnits) {
					unitShopRow.show();
					//unitInputFld.focus();
					if(window.selectedAddressObj[getType()].hasEmptyUnits) {
						if(!unitInputFld.hasClass( 'canBeEmpty' )) {
							unitSelFld.addClass("canBeEmpty");
							unitInputFld.addClass("canBeEmpty");
						}

						// Set dpId as by default it's set to the empty unit
						dpIdFld.val(window.selectedAddressObj[getType()].dpId);

					} else {
						// Otherwise flush out the dpId
						window.selectedAddressObj[getType()].dpId = "";
						dpIdFld.val(window.selectedAddressObj[getType()].dpId);
					}

					window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
					fullAddressLineOneFld.val(window.selectedAddressObj[getType()].fullAddressLineOne);
					fullAddressFld.val(getFullAddress(window.selectedAddressObj[getType()]));
				} else {
					unitShopRow.hide();
					dpIdFld.val(window.selectedAddressObj[getType()].dpId);
					fullAddressFld.val(getFullAddress(window.selectedAddressObj[getType()]));
					fullAddressLineOneFld.val(getFullAddressLineOne());
				}
				streetNumRow.hide();
				streetFld.blur();
			}
		} else {
			// Street name and suburb only
			window.selectedAddressObj[getType()].houseNo = 0;
			streetNumRow.show();
			streetNumFld.focus();
			if(window.selectedAddressObj[getType()].emptyHouseNumberhasUnits ) {
				unitShopRow.show();
				window.selectedAddressObj[getType()].hasUnits = true;
			}
		}
		if(window.selectedAddressObj[getType()].emptyHouseNumberhasUnits) {
			if(streetNumFld.attr('class').indexOf("canBeEmpty") == -1) {
				streetNumFld.addClass( "canBeEmpty" );
			}
		}
	});

	streetFld.keydown(function(event) {
        if (event.target.name === "health_application_address_streetSearch") {
            if (nonInputKey(event))  {
            	return;
            }
        }
		reset();
	});

	//streetFld.keyup(ajaxdrop_onAction);

	streetFld.blur(function() {
		if(selectedStreetFld != "") {
			streetFld.typeahead('setQuery', selectedStreetFld);
		}
	});

	streetFld.focus(function(event) {
		userStartedTyping = true;
	});

	var validateIfUnitNoAndTypePopulated = function() {
		if(unitInputFld.val() == window.selectedAddressObj[getType()].unitNo && unitTypeFld.val() != '') {
			_.defer(function(){
				streetFld.valid(); // wrapped in defer for iPad (not iPhone... just iPad)
			});
		}
	};

	unitInputFld.change(function(){
		if(!nonStdFld.is(':checked')) {
			// Allow time for typeahead to complete
			_.defer(validateIfUnitNoAndTypePopulated);
		}
	});

	unitTypeFld.change(function(){
		if(!nonStdFld.is(':checked')) {
			validateIfUnitNoAndTypePopulated();
		}
	});

	streetNumFld.on('getSearchURL', function(event, callback) {
		var url = "";
		if (!nonStdFld.is(":checked")) {
			url = "ajax/json/address_street_number.jsp?" +
						"streetId=" + streetIdFld.val() +
						"&search=" + streetNumFld.val() +
						"&fieldId=" + streetNumFld.attr("id");
		}

		streetNumFld.data('source-url', url);

		if (typeof callback === 'function') {
			callback(url);
		}
	});

	streetNumFld.on('typeahead:selected', function streetNumFldAutocompleteSelected(obj, datum, name /*event, key, val*/) {
		window.selectedAddressObj[getType()].houseNo = datum.value;
		setHouseNo();
		streetNumFldLastSelected = streetNumFld.val();

		// values[1] will contain the number of units/shops/levels etc
		window.selectedAddressObj[getType()].hasUnits = (datum.unitCount > 1);
		window.selectedAddressObj[getType()].hasEmptyUnits = (datum.minUnitNo == '0');
		if (window.selectedAddressObj[getType()].hasUnits) {
			unitShopRow.show();
			if(window.selectedAddressObj[getType()].hasEmptyUnits) {
				window.selectedAddressObj[getType()].dpId = datum.dpId;
			} else {
				resetSelectAddress();
			}
			toggleValidationStyles(streetNumFld, true);
		} else {
			window.selectedAddressObj[getType()].unitNo = "";
			window.selectedAddressObj[getType()].unitType = "";
			setUnitType();
			window.selectedAddressObj[getType()].dpId = datum.dpId; //values[2];
			dpIdFld.val(window.selectedAddressObj[getType()].dpId);
			window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
			fullAddressLineOneFld.val(window.selectedAddressObj[getType()].fullAddressLineOne);
			fullAddressFld.val(getFullAddress(window.selectedAddressObj[getType()]));
			unitShopRow.hide();

			/* Let's nicely format the address into one line if we've got this far */
			_.defer(function(){ // wrapped in defer for iPad (not iPhone... just iPad)
				attemptToConfirmFullAddress(streetNumFld);
			});
		}

		// Always attempt to revalidate the street search as it HAS to be cool to get this far
		_.defer(function(){
			streetFld.valid();// wrapped in defer for iPad (not iPhone... just iPad)
		});
	});

	streetNumFld.on("change blur", function() {
		if (!nonStdFld.is(":checked")){
			unitInputFld.val("");
			window.selectedAddressObj[getType()].unitType = "";
			setUnitType();
			resetSelectAddress();
			if (streetNumFldLastSelected && streetNumFldLastSelected != $(this).val()){
				window.selectedAddressObj[getType()].hasUnits = false;
			}
			if (streetNumFldLastSelected != $(this).val()){
				window.selectedAddressObj[getType()].houseNo = streetNumFld.val();
				houseNoSelFld.val(window.selectedAddressObj[getType()].houseNo);
				toggleValidationStyles(streetNumFld);
			}
			if (window.selectedAddressObj[getType()].hasUnits){
				unitShopRow.show();
			} else {
				unitShopRow.hide();
			}
			if (streetNumFld.attr('class').indexOf("canBeEmpty") != -1  && (window.selectedAddressObj[getType()].hasUnits && $(this).val() == '0' || $(this).val() == '')) {
				unitShopRow.show();
			}
		} else {
			window.selectedAddressObj[getType()].houseNo = streetNumFld.val();
			houseNoSelFld.val("");
		}
	});

	unitInputFld.on('getSearchURL' , function(event, callback) {
		if (nonStdFld.is(":checked")) {
			if (typeof callback === 'function') {
				callback("");
			}
		} else {
			var houseNo = streetNumFld.val();
			if (houseNoSelFld.val() != ""){
				houseNo = houseNoSelFld.val();
			}
			var url = "ajax/json/address_shopunitlevel.jsp?" +
						"streetId=" + streetIdFld.val() +
						"&houseNo=" + houseNo +
						"&search=" + $.trim($(this).val()) +
						"&unitType=" + unitTypeFld.val() +
						"&fieldId=" + $(this).attr("id")+
						"&residentalAddress=" + residentalAddress;

			unitInputFld.data('source-url', url);

			if (typeof callback === 'function') {
				callback(url);
			}
		}
	});

	unitInputFld.on('typeahead:selected', function unitInputFldAutocompleteSelected(obj, datum, name /*event, key, val*/) {

		window.selectedAddressObj[getType()].unitNo = datum.value;
		window.selectedAddressObj[getType()].unitType = datum.unitType; //values[1];
		window.selectedAddressObj[getType()].dpId = datum.dpId; //values[2];

		toggleValidationStyles(unitInputFld, true);

		setUnitType();

		unitInputFld.val(window.selectedAddressObj[getType()].unitNo);
		unitSelFld.val(window.selectedAddressObj[getType()].unitNo);

		dpIdFld.val(window.selectedAddressObj[getType()].dpId);

		window.selectedAddressObj[getType()].fullAddressLineOne = getFullAddressLineOne();
		fullAddressLineOneFld.val(window.selectedAddressObj[getType()].fullAddressLineOne);
		fullAddressFld.val(getFullAddress(window.selectedAddressObj[getType()]));

		/* Let's nicely format the address into one line if we've got this far */
		_.defer(function(){ // wrapped in defer for iPad (not iPhone... just iPad)
			attemptToConfirmFullAddress(unitInputFld);
		});
	});

	unitInputFld.keydown(function(event) {
		if (!nonStdFld.is(":checked") && dpIdFld.val() != "") {
			window.selectedAddressObj[getType()].unitType = "";
			setUnitType();
		}
		resetSelectAddress();
		unitSelFld.val("");
	});

	// NON STANDARD ADDRESS
	nonStdFld.on('change' /*click*/, function nonStdFldClick() {
		if ($(this).is(':checked')) {
			nonStdContainer.show();
			stdStreetFld.hide();
			nonStdstreetRow.show();
			streetNumRow.show();
			unitShopRow.show();
			resetSelectAddress();
			nonStdStreet.val(window.selectedAddressObj[getType()].streetName);
			window.selectedAddressObj[getType()].hasUnits = true;
			streetFld.valid();
		} else {
			nonStdContainer.hide();
			nonStdstreetRow.hide();
			stdStreetFld.show();
			streetNumRow.hide();
			unitShopRow.hide();

			$.ajax({
				url : "ajax/json/address/get_address.jsp",
				data : {
					suburbSequence  : suburbFld.val(),
					postCode		: postCodeFld.val(),
					houseNo			: streetNumFld.val(),
					unitNo			: unitInputFld.val(),
					unitType		: unitTypeFld.val(),
					street			: nonStdStreet.val()
				},
				dataType : "json",
				type : "POST",
				async : false,
				cache : false,
				success : function(jsonResult) {
					if (jsonResult.foundAddress) {
						populateFullAddressStreetSearch(null , fieldName , jsonResult);
					} else {
						reset(true);
						streetFld.val("");
					}
				},
				error : function(obj, txt, errorThrown) {
					meerkat.modules.errorHandling.error({
						message:		"An error occurred checking the address: " + txt + ' ' + errorThrown,
						page:			"ajax/json/address/get_address.jsp",
						description:	"legacy_address:nonStdFldClick(): " + txt + ' ' + errorThrown,
						errorLevel: 	"silent"
					});
					streetFld.val("");
					reset(true);
				},
				timeout : 6000
			});
			suburbFld.valid();
		}
	});

	//nonStdFld.keyup( function() {
	//	nonStdFld.click();
	//});

	var resetSelectAddress = function() {
		window.selectedAddressObj[getType()].dpId = "";
		dpIdFld.val("");
		fullAddressLineOneFld.val("");
		fullAddressFld.val("");
	};

	var reset = function(resetAll) {
		resetSelectAddress();
		selectedStreetFld = "";
		streetIdFld.val("");
		suburbFld.val("");
		streetNameFld.val("");
		suburbNameFld.val("");
		streetNumFld.val("");
		houseNoSelFld.val("");
		unitInputFld.val("");
		unitSelFld.val("");
		unitTypeFld.val("");
		if (!nonStdFld.is(":checked")) {
			streetNumRow.hide();
			unitShopRow.hide();
		}
		streetNumFldLastSelected = null;
		window.selectedAddressObj[getType()] = {hasUnits: false};
	};

	var nonInputKey = function(eventObj) {
		var returnVal = false;

		if (!eventObj.key) {

            var UnicodeKeyCode = eventObj.which || eventObj.keyCode;

            switch (UnicodeKeyCode) {
				case 13:
				case 9:
				case 16:
				case 17:
				case 39:
				case 37:
				case 20:
				case 18:
				case 91:
				case 144:
				case 33:
				case 34:
				case 36:
				case 45:
				case 35:
				case 27:
				case 19:
				case 145:
				case 181:
				case 183:
				case 182:
				case 0:
				case 93:
				case 112:
				case 113:
				case 114:
				case 115:
				case 116:
				case 117:
				case 118:
				case 119:
				case 120:
				case 121:
				case 122:
				case 123:
                    returnVal = true;
                    break;
                default:
                    returnVal = false;
			}

		} else {
            switch (eventObj.key) {
                case "Enter":
                case "Tab":
                case "Shift":
                case "Control":
                case "ArrowRight":
                case "ArrowLeft":
                case "CapsLock":
                case "Alt":
                case "Meta":
                case "NumLock":
                case "PageUp":
                case "PageDown":
                case "Home":
                case "Insert":
                case "End":
                case "Escape":
                case "Pause":
                case "Cancel":
                case "ScrollLock":
                case "AudioVolumeMute":
                case "AudioVolumeUp":
                case "AudioVolumeDown":
                case "MediaPlayPause":
                case "MediaStop":
                case "MediaTrackPrevious":
                case "MediaTrackNext":
                case "ContextMenu":
                case "F1":
                case "F2":
                case "F3":
                case "F4":
                case "F5":
                case "F6":
                case "F7":
                case "F8":
                case "F9":
                case "F10":
                case "F11":
                case "F12":
                    returnVal = true;
                    break;
                default:
                    returnVal = false;
            }
		}

        return returnVal;
	};

	var removeValidationOnStdSearchForm = function() {

		var fields = [streetFld, streetNumFld, unitInputFld, unitTypeFld];
		for(var i=0; i<fields.length; i++) {
			fields[i].removeClass('has-error has-success').val('');
			fields[i].closest('.form-group').find('.row-content').removeClass('has-error has-success')
			.end().find('.error-field').remove();
		}
	};

	var setStreetSearchAddress = function(address) {
		// #CANTFIND#
		if (address.hasOwnProperty('value') && address.value === 'Type your address...') return;

		nonStdFld.prop('checked', false);
		streetNameFld.val(address.streetName);
		streetIdFld.val(address.streetId);
		suburbFld.val(address.suburbSeq);

		// Populate the "selected values" fields
		if(address.unitNo == 0) {
			address.unitNo = "";
		}
		if(address.houseNo == 0) {
			address.houseNo = "";
		}

		unitSelFld.val(address.unitNo);
		unitInputFld.val(address.unitNo);
		setUnitType();
		window.selectedAddressObj[getType()].houseNo = address.houseNo;
		setHouseNo();

		suburbNameFld.val(address.suburb);
		suburbFld.val(address.suburbSeq);
		stateFld.val(address.state);

		var hasStreetNum = address.houseNo != "";
		var hasUnitNum = address.unitNo != "";
		var des = "";
		if(hasUnitNum && hasStreetNum) {
			des = address.unitNo + " / " + address.houseNo  + " " + address.streetName;
		} else if(!hasUnitNum && hasStreetNum) {
			des = address.houseNo  + " " + address.streetName;
		} else if(hasUnitNum) {
			des = address.unitNo  + " " + address.streetName;
		} else {
			des = address.streetName;
		}
		if(lastSearchFld.val() == "") {
			lastSearchFld.val(des);
		}
		// REVIEW THIS. Commented out so it doesn't trigger another street search.
		//streetFld.val(des + ", " + address.suburb + " " + address.state);
		streetFld.typeahead('setQuery', des + ", " + address.suburb + " " + address.state);

		selectedStreetFld = streetFld.val();
	};

	var getFullAddressLineOne = function() {
		if(typeof(window.selectedAddressObj[getType()].streetName) == 'undefined') {
			window.selectedAddressObj[getType()].streetName = "";
		}
		var fullAddressLineOneValue  = "";
		if(window.selectedAddressObj[getType()].unitNo != "" && window.selectedAddressObj[getType()].unitNo != '0') {
			var unitTypeText = window.selectedAddressObj[getType()].unitTypeText;
			var unitNo = window.selectedAddressObj[getType()].unitNo;

			if(window.selectedAddressObj[getType()].unitType != "OT" && window.selectedAddressObj[getType()].unitType != "" && typeof window.selectedAddressObj[getType()].unitType != 'undefined') {
				fullAddressLineOneValue  += unitTypeText + " ";
			}
			var regex = /(^duplex)|(^floor)|(^house)|(^level)|(^lot)|(^shop)|(^suite)|(^townhouse)|(^unit)/i;
			if (regex.test(unitNo)) {
				unitNo = $.trim(unitNo.replace(regex, ''));
			}

			fullAddressLineOneValue  += unitNo + " ";
		}
		if(window.selectedAddressObj[getType()].houseNo != "" && window.selectedAddressObj[getType()].houseNo != '0') {
			var isPostBox = false;
			if(isPostalAddress) {
				isPostBox =  AddressUtils.isPostalBox(window.selectedAddressObj[getType()].streetName);
			}
			if (isPostBox) {
				fullAddressLineOneValue  += window.selectedAddressObj[getType()].streetName + " " + window.selectedAddressObj[getType()].houseNo;
			} else {
				fullAddressLineOneValue  += window.selectedAddressObj[getType()].houseNo + " " + window.selectedAddressObj[getType()].streetName;
			}
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

		return fullAddressLineOne + ", " +  jsonAddress.suburb + " " + jsonAddress.state + " " + jsonAddress.postCode;
	};

	$(document).ready(function() {
		$(document).on('validStreetSearchAddressEnteredEvent', populateFullAddressStreetSearch);
		$(document).on('customAddressEnteredEvent', populateFullAddress);
	});

	var attemptToConfirmFullAddress = function(element) {
		validateAddressAgainstServer(
			fieldName,
			dpIdFld, {
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
		window.selectedAddressObj[getType()].suburbSeq = suburbFld.val();
		if(window.selectedAddressObj[getType()].suburbSeq == "") {
			window.selectedAddressObj[getType()].suburb = "";
			suburbNameFld.val("");
		} else {
			window.selectedAddressObj[getType()].suburb = suburbFld.find("option:selected").text();
			suburbNameFld.val(window.selectedAddressObj[getType()].suburb);
		}
	};

	var setHouseNo =  function() {
		streetNumFld.val(window.selectedAddressObj[getType()].houseNo);
		houseNoSelFld.val(window.selectedAddressObj[getType()].houseNo);
	};

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

	if(nonStdFld.is(":checked")) {
		window.selectedAddressObj[getType()].streetName = getFormattedStreet(nonStdStreet.val() , false);
		window.selectedAddressObj[getType()].houseNo = streetNumFld.val();
	} else {
		window.selectedAddressObj[getType()].streetName = getFormattedStreet(streetNameFld.val() , false);
		window.selectedAddressObj[getType()].houseNo = houseNoSelFld.val();
	}
}