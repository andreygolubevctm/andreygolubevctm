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

var selectedAddressObj = new Object();

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
	fieldName				= name,
	selectedStreetFld		= "",
	userStartedTyping		= true;

	window.selectedAddressObj = {
			hasUnits : false
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
			window.selectedAddressObj = {
				hasUnits : false
			};
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
		meerkat.messaging.subscribe(meerkat.modules.events.CANT_FIND_ADDRESS, function handleCantFindAddress(data) {
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
						options = '<option value="">Please select...</option>';
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

		var hasUnits = window.selectedAddressObj.hasUnits;
		window.selectedAddressObj = _.extend(window.selectedAddressObj, jsonAddress);
		if(window.selectedAddressObj.fullAddress == "") {
			setUnitType();
			window.selectedAddressObj.fullAddressLineOne = getFullAddressLineOne();
			window.selectedAddressObj.fullAddress = getFullAddress(jsonAddress);
		}
		dpIdFld.val(window.selectedAddressObj.dpId);
		fullAddressFld.val(window.selectedAddressObj.fullAddress);
		fullAddressLineOneFld.val(window.selectedAddressObj.fullAddressLineOne);
		lastSearchFld.val("");
		setStreetSearchAddress(window.selectedAddressObj);
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

		window.selectedAddressObj.unitNo = $.trim(unitInputFld.val().toUpperCase().replace(/\s{2,}/g," "));
		if(nonStdFld.is(":checked")) {
			window.selectedAddressObj.unitType = $.trim(unitTypeFld.val());
		}
		setUnitType();

		setSuburbName();
		window.selectedAddressObj.state = stateFld.val().toUpperCase();
		window.selectedAddressObj.houseNo =$.trim(streetNumFld.val().toUpperCase().replace(/\s{2,}/g," "));
		if(nonStdFld.is(":checked")) {
			window.selectedAddressObj.streetName = getFormattedStreet(nonStdStreet.val() , false);
		} else {
			window.selectedAddressObj.streetName = getFormattedStreet(streetNameFld.val() , false);
		}
		window.selectedAddressObj.suburbSequence = suburbFld.val().toUpperCase();
		window.selectedAddressObj.postCode = postCodeFld.val().toUpperCase();

		if(window.selectedAddressObj.suburbSequence != "" && window.selectedAddressObj.streetName != "") {
			var data = {
				postCode : window.selectedAddressObj.postCode,
				suburbSequence : window.selectedAddressObj.suburbSequence,
				street : window.selectedAddressObj.streetName.toUpperCase(),
				houseNo : window.selectedAddressObj.houseNo,
				unitNo : window.selectedAddressObj.unitNo,
				unitType : window.selectedAddressObj.unitType
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
						window.selectedAddressObj = jsonResult;
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
						window.selectedAddressObj.streetName = getFormattedStreet(streetNameFld.val() , false);
						window.selectedAddressObj.fullAddressLineOne = getFullAddressLineOne();
						fullAddressLineOneFld.val(window.selectedAddressObj.fullAddressLineOne);
						fullAddressFld.val(getFullAddress(window.selectedAddressObj));
					}
				},
				error: function(obj, txt, errorThrown) {
					window.selectedAddressObj.streetName = getFormattedStreet(streetNameFld.val() , false);
					window.selectedAddressObj.fullAddressLineOne = getFullAddressLineOne();
					fullAddressLineOneFld.val(window.selectedAddressObj.fullAddressLineOne);
					fullAddressFld.val(getFullAddress(window.selectedAddressObj));
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
		if(window.selectedAddressObj.unitType != "") {
			window.selectedAddressObj.unitTypeText = unitTypeFld.find('option[value="' + window.selectedAddressObj.unitType + '"]').text();
			unitTypeFld.val(window.selectedAddressObj.unitType);
			toggleValidationStyles(unitTypeFld, true);
		} else {
			window.selectedAddressObj.unitTypeText = "";
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

		window.selectedAddressObj = datum; //jQuery.parseJSON( key );
		setUnitType();
		window.selectedAddressObj.postCode = postCodeFld.val();

		setStreetSearchAddress(window.selectedAddressObj);
		if (window.selectedAddressObj.houseNo != "" || window.selectedAddressObj.emptyHouseNumber || window.selectedAddressObj.emptyHouseNumberHasUnits) {
			// Unit/HouseNo Street Suburb State
			if (window.selectedAddressObj.unitNo != "") {
				// full address so store dpId
				dpIdFld.val(window.selectedAddressObj.dpId);
				window.selectedAddressObj.fullAddressLineOne = getFullAddressLineOne();
				fullAddressLineOneFld.val(window.selectedAddressObj.fullAddressLineOne);
				fullAddressFld.val(getFullAddress(window.selectedAddressObj));
				// HouseNo Street Suburb State
			} else {
				if (window.selectedAddressObj.hasUnits) {
					unitShopRow.show();
					//unitInputFld.focus();
					if(window.selectedAddressObj.hasEmptyUnits) {
						if(!unitInputFld.hasClass( 'canBeEmpty' )) {
							unitSelFld.addClass("canBeEmpty");
							unitInputFld.addClass("canBeEmpty");
						}

						// Set dpId as by default it's set to the empty unit
						dpIdFld.val(window.selectedAddressObj.dpId);

					} else {
						// Otherwise flush out the dpId
						window.selectedAddressObj.dpId = "";
						dpIdFld.val(window.selectedAddressObj.dpId);
					}

					window.selectedAddressObj.fullAddressLineOne = getFullAddressLineOne();
					fullAddressLineOneFld.val(window.selectedAddressObj.fullAddressLineOne);
					fullAddressFld.val(getFullAddress(window.selectedAddressObj));
				} else {
					unitShopRow.hide();
					dpIdFld.val(window.selectedAddressObj.dpId);
					fullAddressFld.val(getFullAddress(window.selectedAddressObj));
					fullAddressLineOneFld.val(getFullAddressLineOne());
				}
				streetNumRow.hide();
				streetFld.blur();
			}
		} else {
			// Street name and suburb only
			window.selectedAddressObj.houseNo = 0;
			streetNumRow.show();
			streetNumFld.focus();
			if(window.selectedAddressObj.emptyHouseNumberhasUnits ) {
				unitShopRow.show();
				window.selectedAddressObj.hasUnits = true;
			}
		}
		if(window.selectedAddressObj.emptyHouseNumberhasUnits) {
			if(streetNumFld.attr('class').indexOf("canBeEmpty") == -1) {
				streetNumFld.addClass( "canBeEmpty" );
			}
		}
	});

	streetFld.keydown(function(event) {
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
		if(unitInputFld.val() == window.selectedAddressObj.unitNo && unitTypeFld.val() != '') {
			_.defer(streetFld.valid); // wrapped in defer for iPad (not iPhone... just iPad)
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
		window.selectedAddressObj.houseNo = datum.value;
		setHouseNo();
		streetNumFldLastSelected = streetNumFld.val();

		// values[1] will contain the number of units/shops/levels etc
		window.selectedAddressObj.hasUnits = (datum.unitCount > 1);
		window.selectedAddressObj.hasEmptyUnits = (datum.minUnitNo == '0');
		if (window.selectedAddressObj.hasUnits) {
			unitShopRow.show();
			if(window.selectedAddressObj.hasEmptyUnits) {
				window.selectedAddressObj.dpId = datum.dpId;
			} else {
				resetSelectAddress();
			}
			toggleValidationStyles(streetNumFld, true);
		} else {
			window.selectedAddressObj.unitNo = "";
			window.selectedAddressObj.unitType = "";
			setUnitType();
			window.selectedAddressObj.dpId = datum.dpId; //values[2];
			dpIdFld.val(window.selectedAddressObj.dpId);
			window.selectedAddressObj.fullAddressLineOne = getFullAddressLineOne();
			fullAddressLineOneFld.val(window.selectedAddressObj.fullAddressLineOne);
			fullAddressFld.val(getFullAddress(window.selectedAddressObj));
			unitShopRow.hide();

			/* Let's nicely format the address into one line if we've got this far */
			_.defer(function(){ // wrapped in defer for iPad (not iPhone... just iPad)
				attemptToConfirmFullAddress(streetNumFld);
			});
		}

		// Always attempt to revalidate the street search as it HAS to be cool to get this far
		_.defer(streetFld.valid); // wrapped in defer for iPad (not iPhone... just iPad)
	});

	streetNumFld.on("change blur", function() {
		if (!nonStdFld.is(":checked")){
			unitInputFld.val("");
			window.selectedAddressObj.unitType = "";
			setUnitType();
			resetSelectAddress();
			if (streetNumFldLastSelected && streetNumFldLastSelected != $(this).val()){
				window.selectedAddressObj.hasUnits = false;
			}
			if (streetNumFldLastSelected != $(this).val()){
				window.selectedAddressObj.houseNo = streetNumFld.val();
				houseNoSelFld.val(window.selectedAddressObj.houseNo);
				toggleValidationStyles(streetNumFld);
			}
			if (window.selectedAddressObj.hasUnits){
				unitShopRow.show();
			} else {
				unitShopRow.hide();
			}
			if (streetNumFld.attr('class').indexOf("canBeEmpty") != -1  && (window.selectedAddressObj.hasUnits && $(this).val() == '0' || $(this).val() == '')) {
				unitShopRow.show();
			}
		} else {
			window.selectedAddressObj.houseNo = streetNumFld.val();
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

		window.selectedAddressObj.unitNo = datum.value;
		window.selectedAddressObj.unitType = datum.unitType; //values[1];
		window.selectedAddressObj.dpId = datum.dpId; //values[2];

		toggleValidationStyles(unitInputFld, true);

		setUnitType();

		unitInputFld.val(window.selectedAddressObj.unitNo);
		unitSelFld.val(window.selectedAddressObj.unitNo);

		dpIdFld.val(window.selectedAddressObj.dpId);

		window.selectedAddressObj.fullAddressLineOne = getFullAddressLineOne();
		fullAddressLineOneFld.val(window.selectedAddressObj.fullAddressLineOne);
		fullAddressFld.val(getFullAddress(window.selectedAddressObj));

		/* Let's nicely format the address into one line if we've got this far */
		_.defer(function(){ // wrapped in defer for iPad (not iPhone... just iPad)
			attemptToConfirmFullAddress(unitInputFld);
		});
	});

	unitInputFld.keydown(function(event) {
		if (!nonStdFld.is(":checked") && dpIdFld.val() != "") {
			window.selectedAddressObj.unitType = "";
			setUnitType();
		}
		resetSelectAddress();
		unitSelFld.val("");
	});

	// NON STANDARD ADDRESS
	nonStdFld.on('change' /*click*/, function nonStdFldClick() {

		if ($(this).is(':checked')) {
			stdStreetFld.hide();
			nonStdstreetRow.show();
			streetNumRow.show();
			unitShopRow.show();
			resetSelectAddress();
			nonStdStreet.val(window.selectedAddressObj.streetName);
			window.selectedAddressObj.hasUnits = true;
			streetFld.valid();
		} else {
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
		window.selectedAddressObj.dpId = "";
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
		window.selectedAddressObj = {hasUnits:false};
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
		window.selectedAddressObj.houseNo = address.houseNo;
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
		if(typeof(window.selectedAddressObj.streetName) == 'undefined') {
			window.selectedAddressObj.streetName = "";
		}
		var fullAddressLineOneValue  = "";
		if(window.selectedAddressObj.unitNo != "" && window.selectedAddressObj.unitNo != '0') {
			if(window.selectedAddressObj.unitType != "OT" && window.selectedAddressObj.unitType != "" && typeof window.selectedAddressObj.unitType != 'undefined') {
				fullAddressLineOneValue  += window.selectedAddressObj.unitTypeText + " ";
			}
			fullAddressLineOneValue  += window.selectedAddressObj.unitNo + " ";
		}
		if(window.selectedAddressObj.houseNo != "" && window.selectedAddressObj.houseNo != '0') {
			var isPostBox = false;
			if(isPostalAddress) {
				isPostBox =  AddressUtils.isPostalBox(window.selectedAddressObj.streetName);
			}
			if (isPostBox) {
				fullAddressLineOneValue  += window.selectedAddressObj.streetName + " " + window.selectedAddressObj.houseNo;
			} else {
				fullAddressLineOneValue  += window.selectedAddressObj.houseNo + " " + window.selectedAddressObj.streetName;
			}
		} else {
			fullAddressLineOneValue  += window.selectedAddressObj.streetName;
		}

		return fullAddressLineOneValue;
	};

	var getFullAddress = function(jsonAddress) {

		window.selectedAddressObj = _.extend(window.selectedAddressObj, jsonAddress);
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
			dpIdFld, {
				streetId : window.selectedAddressObj.streetId,
				houseNo : window.selectedAddressObj.houseNo,
				unitNo : window.selectedAddressObj.unitNo,
				unitType : window.selectedAddressObj.unitType
			},
			element
		);
	}
;
	var setSuburbName =  function() {
		window.selectedAddressObj.suburbSeq = suburbFld.val();
		if(window.selectedAddressObj.suburbSeq == "") {
			window.selectedAddressObj.suburb = "";
			suburbNameFld.val("");
		} else {
			window.selectedAddressObj.suburb = suburbFld.find("option:selected").text();
			suburbNameFld.val(window.selectedAddressObj.suburb);
		}
	};

	var setHouseNo =  function() {
		streetNumFld.val(window.selectedAddressObj.houseNo);
		houseNoSelFld.val(window.selectedAddressObj.houseNo);
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
		window.selectedAddressObj.streetName = getFormattedStreet(nonStdStreet.val() , false);
		window.selectedAddressObj.houseNo = streetNumFld.val();
	} else {
		window.selectedAddressObj.streetName = getFormattedStreet(streetNameFld.val() , false);
		window.selectedAddressObj.houseNo = houseNoSelFld.val();
	}
}