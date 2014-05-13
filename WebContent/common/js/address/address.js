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
		};
	},
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

function init_address(name, residentalAddress , isPostalAddress) {
	"use strict";
	
	var streetFld			= $("#" + name + "_streetSearch"),
	lastSearchFld			= $("#" + name + "_lastSearch"),
	streetNameFld			= $("#" + name + "_streetName"),
	streetIdFld				= $("#" + name + "_streetId"),
	unitSelFld				= $("#" + name + "_unitSel"),
	unitTypeFld				= $('#' + name + '_unitType'),
	postCodeFld				= $("#" + name + "_postCode"),
	streetNumFld 			= $("#" + name + "_streetNum"),
	houseNoSel				= $("#" + name + "_houseNoSel"),
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
	selectedAddress			= {
									hasUnits : false
							},
	selectedStreetFld		= "",
	userStartedTyping		= true;
	
	var unitInputFld			= $("#" + name + "_unitShop");

	unitInputFld.data("srchLen" , 1);
	streetNumFld.data("srchLen" , 1);
	streetFld.data("srchLen" , 2);

	var streetNumFldLastSelected = null;
	var excludePostBoxes = residentalAddress || !isPostalAddress;
	
	// POSTCODE
	postCodeFld.change(function() {
		// Clear associated fields if value changes
		if ($(this).data('previous') != $(this).val()) {
			reset(streetFld.val() != lastSearchFld.val() || streetFld.val() == "");
			streetFld.val("");
			nonStdStreet.val("");
			lastSearchFld.val("");
			selectedAddress = {
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

	suburbFld.change(function() {
		setSuburbName();
	});

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
							if (resp.suburbs.length == 1  || (defaultSuburbSeq != undefined && resp.suburbs[i].id == defaultSuburbSeq)) {
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
							if(!nonStdFld.prop('checked')) {
								nonStdFld.prop('checked', true);
								nonStdFld.click();
								nonStdFld.prop('checked', true);
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

	// INIT
	var ok = true;
	try {
		var re = /Android (\d)+\.?(\d+)?/i;
		var android = navigator.userAgent.match(re);
		if (android.length >= 3) {
			//Require 4.1+
			if (parseInt(android[1] , 10) < 4 || (android[1] == '4' && parseInt(android[2], 10) < 1)) {
				ok = false;
			}
		}
	}
	catch(e) {}

	if (ok) {
		postCodeFld.mask("9999",{placeholder:""});
	} else {
		postCodeFld.numeric();
	}
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
			var url = "ajax/html/smart_street.jsp?" +
				"&postCode=" + postCodeFld.val() +
				"&fieldId=" + $(this).attr("id") +
				"&showUnable=yes" +
				"&residentalAddress=" + residentalAddress;
			lastSearchFld.val(streetFld.val());

		var match = null;				
			for (var idx=0,len=searches.length; idx<len; idx++) {
			var search = searches[idx];
			var re = new RegExp(search.regex);					
				var reMatch = re.exec(streetSearch);
			if ( reMatch != null) {
				for (var i = 1; i < reMatch.length; i++) {
						url = url + "&" + search.fields[i-1] + "=" + $.trim(reMatch[i]);
				}
				match = search;
				break;
			}
		}
		// No match found... send for a street search 
		if (match == null){
				url = url + "&street=" + streetSearch;
		}
			url = url.replace(/\'/g,"");
			
			callback(url);
		}
	};
			
	streetFld.on('getSearchURL' , getSearchURLStreetFld);

	var populateFullAddressStreetSearch =  function(event, name, jsonAddress) {
		if(name != fieldName) {
			return;
		}
		var hasUnits = selectedAddress.hasUnits;
		selectedAddress = jsonAddress;
		selectedAddress.hasUnits = hasUnits;
		if(jsonAddress.fullAddress == "") {
			setUnitType();
			selectedAddress = jsonAddress;
			jsonAddress.fullAddressLineOne = getFullAddressLineOne();
			jsonAddress.fullAddress = getFullAddress(jsonAddress);
		}
		dpIdFld.val(jsonAddress.dpId);
		fullAddressFld.val(jsonAddress.fullAddress);
		fullAddressLineOneFld.val(jsonAddress.fullAddressLineOne);
		lastSearchFld.val("");
		setStreetSearchAddress(jsonAddress);
		unitShopRow.hide();
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
		if(name != fieldName) {
			return;
		}
		selectedAddress.unitNo = $.trim(unitInputFld.val().toUpperCase().replace(/\s{2,}/g," "));
		setUnitType();
					
		setSuburbName();
		selectedAddress.state = stateFld.val().toUpperCase();
		selectedAddress.houseNo =$.trim(streetNumFld.val().toUpperCase().replace(/\s{2,}/g," "));
		if(nonStdFld.is(":checked")) {
			selectedAddress.streetName = getFormattedStreet(nonStdStreet.val() , false);
		} else {
		selectedAddress.streetName = getFormattedStreet(streetNameFld.val() , false);
		}
		selectedAddress.suburbSequence = suburbFld.val().toUpperCase();
		selectedAddress.postCode = postCodeFld.val().toUpperCase();
		if(selectedAddress.suburbSequence != "" && selectedAddress.streetName != "") {
		var data = {
					postCode : selectedAddress.postCode,
					suburbSequence : selectedAddress.suburbSequence,
					street : selectedAddress.streetName.toUpperCase(),
					houseNo : selectedAddress.houseNo,
					unitNo : selectedAddress.unitNo,
					unitType : selectedAddress.unitType
				};
		$.ajax({
			url: "ajax/json/address/get_address.jsp",
			data: data,
			type: "POST",
			async: true,
			cache: false,
			success: function(jsonResult) {
				if(jsonResult.foundAddress) {
						selectedAddress = jsonResult;
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
						selectedAddress.streetName = getFormattedStreet(streetNameFld.val() , false);
						selectedAddress.fullAddressLineOne = getFullAddressLineOne();
						fullAddressLineOneFld.val(selectedAddress.fullAddressLineOne);
						fullAddressFld.val(getFullAddress(selectedAddress));
								}			
			},
			dataType: "json",
			error: function(obj,txt) {
					selectedAddress.streetName = getFormattedStreet(streetNameFld.val() , false);
					selectedAddress.fullAddressLineOne = getFullAddressLineOne();
					fullAddressLineOneFld.val(selectedAddress.fullAddressLineOne);
					fullAddressFld.val(getFullAddress(selectedAddress));
				FatalErrorDialog.register({
					message:		"An error occurred checking the address: " + txt,
					page:			"ajax/json/address/get_address.jsp",
					description:	"An error occurred checking the address: " + txt
							 });					
			},
			timeout:6000
		});
		}
	};
				
	var setUnitType = function() {
		if(selectedAddress.unitType != "") {
			selectedAddress.unitTypeText = unitTypeFld.find('option[value="' + selectedAddress.unitType + '"]').text();
			unitTypeFld.val(selectedAddress.unitType);
		} else {
			selectedAddress.unitTypeText = "";
			unitTypeFld.val("");
		}
	};

	streetFld.on('itemSelected' , function streetSelected(event, key, val) {
		if (key != "*NOTFOUND") {
			var emptyClassName = 'canBeEmpty';
			if(unitInputFld.hasClass( emptyClassName ) ) {
				unitSelFld.removeClass(emptyClassName);
				unitInputFld.removeClass( emptyClassName);
			}
			if(streetNumFld.hasClass(emptyClassName) ) {
				streetNumFld.removeClass(emptyClassName);
			}
			selectedAddress = jQuery.parseJSON( key );
			setUnitType();
			selectedAddress.streetName = val;
			selectedAddress.postCode = postCodeFld.val();
			setStreetSearchAddress(selectedAddress);
			if (selectedAddress.houseNo != "") {
				// Unit/HouseNo Street Suburb State
				if (selectedAddress.unitNo != "") {
					// full address so store dpId
					dpIdFld.val(selectedAddress.dpId);
					selectedAddress.fullAddressLineOne = getFullAddressLineOne();
					fullAddressLineOneFld.val(selectedAddress.fullAddressLineOne);
					fullAddressFld.val(getFullAddress(selectedAddress));
					// HouseNo Street Suburb State
			} else {
					if (selectedAddress.hasUnits) {
							unitShopRow.show();
								unitInputFld.focus();
						if(selectedAddress.hasEmptyUnits) {
									if(!unitInputFld.hasClass( 'canBeEmpty' )) {
										unitSelFld.addClass("canBeEmpty");
										unitInputFld.addClass("canBeEmpty");
			}
									dpIdFld.val(selectedAddress.dpId);
							selectedAddress.fullAddressLineOne = getFullAddressLineOne();
									fullAddressLineOneFld.val(selectedAddress.fullAddressLineOne);
									fullAddressFld.val(getFullAddress(selectedAddress));
								}
		} else {
							unitShopRow.hide();
							dpIdFld.val(selectedAddress.dpId);
							fullAddressFld.val(getFullAddress(selectedAddress));
						fullAddressLineOneFld.val(getFullAddressLineOne());
		}
				streetNumRow.hide();
			}
			} else {
				// Street name and suburb only
				selectedAddress.houseNo = 0;
				streetNumRow.show();
				streetNumFld.focus();
				if(selectedAddress.emptyHouseNumberhasUnits ) {
					unitShopRow.show();
					selectedAddress.hasUnits = true;
					if(selectedAddress.emptyHouseNumberhasUnits) {
						if(streetNumFld.attr('class').indexOf("canBeEmpty") == -1) {
							streetNumFld.addClass( "canBeEmpty" );
		}
						if(selectedAddress.hasEmptyUnit && !unitInputFld.hasClass( 'canBeEmpty' )) {
							unitSelFld.addClass("canBeEmpty");
							unitInputFld.addClass("canBeEmpty");
	}
					}
				}
			}
			if(selectedAddress.emptyHouseNumberhasUnits) {
				if(streetNumFld.attr('class').indexOf("canBeEmpty") == -1) {
					streetNumFld.addClass( "canBeEmpty" );
		}
				if(selectedAddress.hasEmptyUnit && !unitInputFld.hasClass( 'canBeEmpty' )) {
					unitSelFld.addClass("canBeEmpty");
					unitInputFld.addClass("canBeEmpty");
				}
			}
		} else {
			nonStdFld.prop('checked', true);
			nonStdFld.click();
			nonStdFld.prop('checked', true);
			suburbFld.focus();
		}
		setTimeout("ajaxdrop_hide('" + $(this).attr("id") + "')", 50);
	});
		
	streetFld.keydown(function(event) {
		reset(streetFld.val() != lastSearchFld.val() || streetFld.val() == "");
		return ajaxdrop_onkeydown($(this).attr("id"), event);
	});

	streetFld.keyup(ajaxdrop_onAction);

	streetFld.blur(function() {
		if(selectedStreetFld != "") {
			streetFld.val(selectedStreetFld);
		}
		setTimeout("ajaxdrop_hide('" + $(this).attr("id") + "')", 150);
	});
	
	streetFld.focus(function(event) {
		userStartedTyping = true;
		if (lastSearchFld.val() != "") {
			streetFld.val(lastSearchFld.val());
			ajaxdrop_update(streetFld);
		}
	});
	
	streetFld.change(function() {
		if (!nonStdFld.is(":checked") && selectedAddress.dpId == ""){
			unitInputFld.val("");
			selectedAddress.houseNo ="";
			setHouseNo();
		}
	});
		
	streetNumFld.on('getSearchURL' , function(event, callback) {
		var url = "";
		if (!nonStdFld.is(":checked")){
			url = "ajax/html/street_number.jsp?" +
						"&streetId=" + streetIdFld.val() +
						"&search=" + streetNumFld.val() +
						"&fieldId=" + streetNumFld.attr("id");
		}
		callback(url);
	});

	streetNumFld.on('itemSelected' , function(event, key, val) {
		var values = key.split(":");
		selectedAddress.houseNo = values[0];
		setHouseNo();
		streetNumFldLastSelected = $(this).val();


		// values[1] will contain the number of units/shops/levels etc
		selectedAddress.hasUnits = (values[1] > 1);
		if (selectedAddress.hasUnits) {
			unitShopRow.show();
			selectedAddress.dpId = "";
			resetSelectAddress();
		} else {
			selectedAddress.unitNo = "";
			selectedAddress.unitType = "";
			setUnitType();
			selectedAddress.dpId = values[2];
			dpIdFld.val(selectedAddress.dpId);
			selectedAddress.fullAddressLineOne = getFullAddressLineOne();
			fullAddressLineOneFld.val(selectedAddress.fullAddressLineOne);
			fullAddressFld.val(getFullAddress(selectedAddress));
			unitShopRow.hide();
		}		
		setTimeout("ajaxdrop_hide('" + streetNumFld.attr("id") + "')", 50);
	});

	streetNumFld.keydown(function(event) {
		ajaxdrop_onkeydown($(this).attr("id"), event);
	});

	streetNumFld.keyup(ajaxdrop_onAction);

	streetNumFld.blur(function() {
		setTimeout("ajaxdrop_hide('" + $(this).attr("id") + "')", 150);
		if (streetNumFldLastSelected &&
				streetNumFldLastSelected != $(this).val()){
			selectedAddress.hasUnits = false;
		} 
		if (!nonStdFld.is(":checked")) {
			if (selectedAddress.hasUnits){
				unitShopRow.show();
			} else {
				unitShopRow.hide();
			}
		} 
		if (streetNumFld.attr('class').indexOf("canBeEmpty") != -1  && (selectedAddress.hasUnits && $(this).val() == '0' || $(this).val() == '')) {
			unitShopRow.show();
	}
	});

	streetNumFld.change(function() {
		if (!nonStdFld.is(":checked")){
		unitInputFld.val("");
			selectedAddress.unitType = "";
			setUnitType();
		resetSelectAddress();
		}
		else {
			selectedAddress.houseNo = streetNumFld.val();
			houseNoSel.val(selectedAddress.houseNo);
		}
	});

	unitInputFld.on('getSearchURL' , function(event, callback) {
		if (nonStdFld.is(":checked")){
			callback("");
		} else {
			var houseNo = streetNumFld.val();
			if (houseNoSel.val()!=""){
				houseNo = houseNoSel.val();
			}
			callback("ajax/html/shop_unit_level.jsp?" +
						"&streetId=" + streetIdFld.val() +
						"&houseNo=" + houseNo +
						"&search=" + $.trim($(this).val()) +
						"&unitType=" + unitTypeFld.val() +
						"&fieldId=" + $(this).attr("id")+
						"&residentalAddress=" + residentalAddress);
		}
	});
	
	unitInputFld.on('itemSelected' , function(event, key, val) {
		var values = key.split(':');
		selectedAddress.unitNo = values[0];
		selectedAddress.unitType = values[1];
		selectedAddress.dpId = values[2];

		setUnitType();

		unitInputFld.val(selectedAddress.unitNo);
		unitSelFld.val(selectedAddress.unitNo);

		dpIdFld.val(selectedAddress.dpId);

		selectedAddress.fullAddressLineOne = getFullAddressLineOne();
		fullAddressLineOneFld.val(selectedAddress.fullAddressLineOne);
		fullAddressFld.val(getFullAddress(selectedAddress));

		setTimeout("ajaxdrop_hide('" + unitInputFld.attr("id") + "')", 50);
	});

	unitInputFld.keydown(function(event) {
		if (!nonStdFld.is(":checked") && dpIdFld.val() != "") {
			selectedAddress.unitType = "";
			setUnitType();
		}
		resetSelectAddress();
		unitSelFld.val("");
		ajaxdrop_onkeydown($(this).attr("id"),event);
	});

	unitInputFld.keyup(ajaxdrop_onAction);

	unitInputFld.blur(function() {
		setTimeout("ajaxdrop_hide('" + $(this).attr("id") + "')", 150);
	});

	// NON STANDARD ADDRESS
	nonStdFld.click(function() {
		if (nonStdFld.attr("checked")) {
			stdStreetFld.hide();
			nonStdstreetRow.show();
			streetNumRow.show();
			unitShopRow.show();
				resetSelectAddress();
				nonStdStreet.val(selectedAddress.streetName);
			selectedAddress.hasUnits = true;
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
				dataType : "json",
				error : function(obj, txt) {
					streetFld.val("");
					reset(true);
				},
				timeout : 6000
			});
			suburbFld.valid();
		}
	});

	nonStdFld.keyup( function() {
		nonStdFld.click();
	});

	var resetSelectAddress = function() {
		selectedAddress.dpId = "";
		dpIdFld.val("");
		fullAddressLineOneFld.val("");
		fullAddressFld.val("");
	};

	var reset = function(resetAll) {
		resetSelectAddress();
		selectedStreetFld = "";
		// reset if address previously set
		if (streetFld.val() != lastSearchFld.val() || streetFld.val() == ""){
			streetIdFld.val("");
			suburbFld.val("");
			streetNameFld.val("");
			suburbNameFld.val("");
			selectedAddress.houseNo = "";

			setHouseNo();
			unitInputFld.val("");
			unitSelFld.val("");
			selectedAddress.unitType = "";
			setUnitType();
			if (!nonStdFld.is(":checked")) {
				streetNumRow.hide();
				unitShopRow.hide();
}
		}
	};

	var setStreetSearchAddress = function(address) {

		nonStdFld.prop('checked', false);
		streetNameFld.val(address.streetName);
		streetIdFld.val(address.streetId);
		suburbFld.val(address.suburbSeq);

		selectedAddress.unitNo = address.unitNo;
		setUnitNo();
		setUnitType();
		selectedAddress.houseNo = address.houseNo;
		setHouseNo();

		suburbNameFld.val(address.suburb);
		suburbFld.val(address.suburbSeq);
		stateFld.val(address.state);

		var hasStreetNum = address.houseNo != "" && address.houseNo != "0";
		var hasUnitNum = address.unitNo != "0";
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
		streetFld.val(des + ", " + address.suburb + " " + address.state);

		selectedStreetFld = streetFld.val();
	};

	var getFullAddressLineOne = function() {
		if(typeof(selectedAddress.streetName) == 'undefined') {
			selectedAddress.streetName = "";
		}
		var fullAddressLineOneValue  = "";
		if(selectedAddress.unitNo != "" && selectedAddress.unitNo != '0') {
			if(selectedAddress.unitType != "OT" && selectedAddress.unitType != "" && typeof selectedAddress.unitType != 'undefined') {
				fullAddressLineOneValue  += selectedAddress.unitTypeText + " ";
			}
			fullAddressLineOneValue  += selectedAddress.unitNo + " ";
		}
		if(selectedAddress.houseNo != "" && selectedAddress.houseNo != '0') {
			var isPostBox = false;
			if(isPostalAddress) {
				isPostBox =  AddressUtils.isPostalBox(selectedAddress.streetName);
			}
			if (isPostBox) {
				fullAddressLineOneValue  += selectedAddress.streetName + " " + selectedAddress.houseNo;
			} else {
				fullAddressLineOneValue  += selectedAddress.houseNo + " " + selectedAddress.streetName;
			}
		} else {
			fullAddressLineOneValue  += selectedAddress.streetName;
		}
		return fullAddressLineOneValue;
	};

	var getFullAddress = function(jsonAddress) {
		selectedAddress = jsonAddress;
		var fullAddressLineOne = jsonAddress.fullAddressLineOne;
		if(typeof fullAddressLineOne == 'undefined' || fullAddressLineOne == "") {
			fullAddressLineOne  = getFullAddressLineOne();
		}
		return fullAddressLineOne + "," +  jsonAddress.suburb + " " + jsonAddress.state + " " + jsonAddress.postCode;
	};

	$( document).ready(function() {
		$(document).on('validStreetSearchAddressEnteredEvent', populateFullAddressStreetSearch);
		$(document).on('customAddressEnteredEvent', populateFullAddress);
	});

	var setSuburbName =  function() {
		selectedAddress.suburbSeq = suburbFld.val();
		if(selectedAddress.suburbSeq == "") {
			selectedAddress.suburb = "";
			suburbNameFld.val("");
		} else {
			selectedAddress.suburb = suburbFld.find("option:selected").text();
			suburbNameFld.val(selectedAddress.suburb);
}
	};

	var setHouseNo =  function() {
		if(selectedAddress.houseNo == "0" ) {
			streetNumFld.val("");
		} else {
		streetNumFld.val(selectedAddress.houseNo);
		}
		houseNoSel.val(selectedAddress.houseNo);
	};

	var setUnitNo =  function() {
		if(selectedAddress.unitNo == "" ) {
			selectedAddress.unitNo = "0";
		}
		if(selectedAddress.unitNo == "0" ) {
			unitInputFld.val("");
		} else {
			unitInputFld.val(selectedAddress.unitNo);
		}
		unitSelFld.val(selectedAddress.unitNo);
	};

	if(nonStdFld.is(":checked")) {
		selectedAddress.streetName = getFormattedStreet(nonStdStreet.val() , false);
		selectedAddress.houseNo = streetNumFld.val();
	} else {
		selectedAddress.streetName = getFormattedStreet(streetNameFld.val() , false);
		selectedAddress.houseNo = houseNoSel.val();
}
}


