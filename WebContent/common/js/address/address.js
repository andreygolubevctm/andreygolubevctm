
function init_address(name){

	var m=document.mainform;

	var street		= $("#"+name+"_streetSearch");
	var lastSearch	= $("#"+name+"_lastSearch");
	var streetNum	= $("#"+name+"_streetNum");
	var streetName	= $("#"+name+"_streetName");
	var streetId	= $("#"+name+"_streetId");
	var unitShop	= $("#"+name+"_unitShop");

	var postCodeFld	= $("#"+name+"_postCode");
	var suburbFld 	= $("#"+name+"_suburb");
	var sbrSeq 		= $("#"+name+"_sbrSeq");
	var houseNoSel	= $("#"+name+"_houseNoSel");
	var unitSel		= $("#"+name+"_unitSel");
	var nonStdStreet= $("#"+name+"_nonStdStreet");
	var streetNumRow= $("#"+name+"_streetNumRow");
	var unitShopRow = $("#"+name+"_unitShopRow");

	var streetFld = document.getElementById(name+"_streetSearch");
	var nonStdFld = document.getElementById(name+"_nonStd");
	var dom_suburbFld = document.getElementById(name+"_suburb");

	var suburbName	= $("#"+name+"_suburbName");
	var state		= $("#"+name+"_state");

	// POSTCODE
	postCodeFld.change(function(e){
		// Clear associated fields if value changes
		if ($(this).data('previous') != $(this).val()) {
			streetFld.reset();
			street.val("");
			nonStdStreet.val("");
			lastSearch.val("");
			$(this).data('previous', $(this).val());

			//if (nonStdFld.checked) {
				if (dom_suburbFld.updateSuburb($(this).val())) {
					$(this).valid();
				}
			//}
		}
	});

	dom_suburbFld.updateSuburb = function(_code) {
		// Validate postcode
		if (/[0-9]{4}/.test(_code) == false) {
			suburbFld.html("<option value=''>Enter Postcode</option>").attr("disabled", "disabled");
			return false;
		}

		$.getJSON("ajax/html/suburbs.jsp",
			{postCode:_code},
			function(resp) {
				if (resp.suburbs && resp.suburbs.length > 0) {
					var options = '<option value="">Please select...</option>';
					for (var i = 0; i < resp.suburbs.length; i++) {
						if (defaultSuburbSeq != undefined && resp.suburbs[i].id == defaultSuburbSeq){
							options += '<option value="' + resp.suburbs[i].id + '" selected="SELECTED">' + resp.suburbs[i].des + '</option>';
						} else {
							options += '<option value="' + resp.suburbs[i].id + '">' + resp.suburbs[i].des + '</option>';
						}
					}
					suburbFld.html(options).removeAttr("disabled");
				} else {
					suburbFld.html("<option value=''>Invalid Postcode</option>").attr("disabled", "disabled");
				}
				if (resp.state && resp.state.length > 0){
					state.val(resp.state);
				} else {
					state.val("");
				}
				suburbFld.trigger('change');
			}
		);
		return true;
	}

	// INIT
	postCodeFld.removeAttr('maxlength');
	var ok = true;
	try {
		var re = /Android (\d)+\.?(\d+)?/i;
		var android = navigator.userAgent.match(re);
		if (android.length >= 3) {
			//Require 4.1+
			if (parseInt(android[1]) < 4 || (android[1] == '4' && parseInt(android[2]) < 1)) {
				ok = false;
			}
		}
	}
	catch(e) {}

	if (ok) {
		postCodeFld.mask("9999",{placeholder:""});
	}
	else {
		postCodeFld.numeric();
	}
	postCodeFld.keyup(function(){
		postCodeFld.change();
	});

	// Handle prefilled fields (e.g. retrieved quote)
	postCodeFld.data('previous', postCodeFld.val());
	if (nonStdFld.checked) {
		dom_suburbFld.updateSuburb(postCodeFld.val());
	}

	var searches = [
				{"name":"NUMBER_ONLY",
					"regex":"^([\\d\\s/]*)$",
					"fields":["houseNo"]},

				{"name":"Level_UnitNo/Number_Street",
					"regex":"^[Ll][Ee][Vv][Ee][Ll][\\s+]?([a-zA-Z]*)(\\d*)([a-zA-Z]*)[/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","level","suffix","houseNo","street"]},

				{"name":"Lvl_UnitNo/Number_Street",
					"regex":"^[Ll][Vv]?[Ll]?[\\s+]?([a-zA-Z]*)(\\d*)([a-zA-Z]*)[/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","level","suffix","houseNo","street"]},

				{"name":"UNITNO_UnitNo/Number_Street",
						"regex":"^[Uu][Nn][Ii][Tt]\\s*[Nn][Oo][\.]*\\s*([a-zA-Z]*)(\\d*)([a-zA-Z]*)[/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
						"fields":["prefix","unitNo","suffix","houseNo","street"]},

				{"name":"UNIT_UnitNo/Number_Street",
					"regex":"^[Uu][Nn][Ii][Tt]\\s*([a-zA-Z]*)(\\d*)([a-zA-Z]*)[/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","unitNo","suffix","houseNo","street"]},

				{"name":"UnitNo_Number_Street",
					"regex":"^([a-zA-Z]*)(\\d*)([a-zA-Z]*)/([\\d-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","unitNo","suffix","houseNo","street"]},

				{"name":"UnitNo/Number_Street",
					"regex":"^([a-zA-Z]*)(\\d*)([a-zA-Z]*)[\-/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","unitNo","suffix","houseNo","street"]},

				{"name":"Number_Street",
					"regex":"^([\\d-]+)([a-zA-Z]*)\\s+([\\w\\W\\s?]+)$",
					"fields":["houseNo","suffix","street"]},

				{"name":"U_UnitNo/Number_Street",
					"regex":"^[Uu]\\s*([a-zA-Z]*)(\\d*)([a-zA-Z]*)[/\\s]+([\\d-]+)\\s+([\\w\\W\\s]+)$",
					"fields":["prefix","unitNo","suffix","houseNo","street"]},


				{"name":"PO_Box_No_Number_Street",
					"regex":"^([Pp][\\.\\s]?[Oo][\\.\\s]?[\\s+]?[Bb][Oo][Xx]\\s+\\d+)$",
					"fields":["POBox"]}
				];

	streetFld.getSearchURL = function(){
		// STREET
		var url = "ajax/html/smart_street.jsp?"
		+ "&postCode=" + postCodeFld.val()
		+ "&fieldId=" + $(this).attr("id")
		+ "&showUnable=yes";

		var match = null;
		for (idx in searches){
			var search = searches[idx];
			var re = new RegExp(search.regex);
			var reMatch = re.exec(this.value);

			if ( reMatch != null) {
				for (var i = 1; i < reMatch.length; i++) {
					url = url + "&" + search.fields[i-1] + "=" + reMatch[i];
				}
				match = search;
				break;
			}
		}
		// No match found... send for a street search
		if (match == null){
			url = url + "&street=" + this.value;

		// Value is numbers only..
		} else if (match.name=="NUMBER_ONLY"){
			return "";
		}
		url = url.replace(/\'/g,"");
		//alert(url);
		return url;
	};
	streetFld.itemSelected = function(key,val){
		if (key != "*NOTFOUND"){
			// Key will take the form- adr_sbrSeq:adr_suburbName:adr_streetId
			var parts = key.split(":");

			var des = "";
			var partStreetName  = val;
			var partSbrSeq		= parts[0];
			var partSuburb 		= parts[1];
			var partState  		= parts[2];
			var partStreetId  	= parts[3];

			streetName.val(partStreetName);
			streetId.val(partStreetId);
			sbrSeq.val(partSbrSeq);

			if (parts.length > 4) {
				var partHouseNo  = parts[4];
				var partUnitNo   = parts[5];

				// Unit/HouseNo Street Suburb State
				if (partUnitNo != ""){
					des = partUnitNo + "/" + partHouseNo + " " + partStreetName;

				// HouseNo Street Suburb State
				} else {
					des = partHouseNo + " " + partStreetName;

					// Check if the house has units
					$.get("ajax/html/has_units.jsp",
							{streetId:partStreetId,
								houseNo:partHouseNo },
							function(resp) {
								if (resp.indexOf("true")>-1){
									streetNum.hasUnits = true;
									unitShopRow.show();
									unitShop.focus();
								} else {
									streetNum.hasUnits = false;
									unitShopRow.hide();
								}
							});
				}

			// Street name and suburb only
			} else {
				des = partStreetName;
			}
			des = des + ", " + partSuburb + " " + partState;

			lastSearch.val(street.val());
			street.val(des);
			streetFld.previousValue = des;
			suburbName.val(partSuburb);
			state.val(partState);

			nonStdFld.checked = false;

			// If we haven't selected a street ..
			if (parts.length == 4) {
				streetNumRow.show();
				nonStdFld.focus();

			// Populate the "selected values" fields
			} else {
				streetNumRow.hide();
				houseNoSel.val(parts[4]);
				unitSel.val(parts[5]);
				nonStdFld.focus();
			}
		} else {
			nonStdFld.checked=true;
			$(nonStdFld).click();
			nonStdFld.checked=true;
			suburbFld.focus();
		}
		setTimeout("ajaxdrop_hide('"+this.id+"')", 50);
	};
	streetFld.reset=function(){
		// reset if address previously set
		if (this.value != this.previousValue || this.value==""){
			streetId.val("");
			sbrSeq.val("");
			streetName.val("");
			suburbName.val("");
			state.val("");
			houseNoSel.val("");
			unitSel.val("");

			streetNum.val("");
			unitShop.val("");
			if (!nonStdFld.checked) {
				streetNumRow.hide();
				unitShopRow.hide();
			}
		}
	}
	streetFld.onkeydown = function(e){
		streetFld.reset();
		return ajaxdrop_onkeydown(this.id,e);
	};
	streetFld.onkeyup= function(e){
		//streetFld.reset();
		return ajaxdrop_onkeyup(this.id,e);
	};
	streetFld.onblur =function(e){
		if (this.value == "") {
			lastSearch.value="";
		}

		setTimeout("ajaxdrop_hide('"+this.id+"')", 150);
	};
	streetFld.onfocus = function(e){
		if (lastSearch.val() != "") {
			street.val(lastSearch.val());
			this.reset();
		}
		this.onkeyup(e);
	};

	streetFld.onchange = function(){
		if (!nonStdFld.checked){
			streetNum.value="";
			unitShop.value="";
		}
	};

	// STREET NUMBER
	var streetNumFld = document.getElementById(name+"_streetNum");
	streetNumFld.srchLen = 1;
	streetNumFld.getSearchURL=function(){
		if (nonStdFld.checked){
			return "";
		} else {
			return "ajax/html/street_number.jsp?"
					+ "&streetId=" + $("#"+name+"_streetId").val()
					+ "&search=" + this.value
					+ "&fieldId=" + this.id;
		}
	};
	streetNumFld.itemSelected=function(key,val){
		var parts = key.split(":");
		this.value=parts[0];
		this.lastSelected = this.value;

		// parts[1] will contain the number of units/shops/levels etc
		this.hasUnits = (parts[1] > 1);
		if (this.hasUnits){
			unitShopRow.show();
		} else {
			unitShopRow.hide();
		}
		setTimeout("ajaxdrop_hide('"+this.id+"')", 50);
	};
	streetNumFld.onkeydown=function(e){
		ajaxdrop_onkeydown(this.id,e);
	};
	streetNumFld.onkeyup=function(e){
		ajaxdrop_onkeyup(this.id,e);
	};
	streetNumFld.onblur=function(e){
		setTimeout("ajaxdrop_hide('"+this.id+"')", 150);
		if (this.lastSelected
				&& this.lastSelected!=this.value){
			streetNumFld.hasUnits = false;
		}
		if (!nonStdFld.checked) {
			if (streetNumFld.hasUnits){
				unitShopRow.show();
			} else {
				unitShopRow.hide();
			}
		}
	};
	streetNumFld.onchange=function(){
		unitShop.val("");
	}

	// UNIT/SHOP/LEVEL
	var unitShopFld = document.getElementById(name+"_unitShop");
	unitShopFld.srchLen = 1;
	unitShopFld.getSearchURL=function(){
		if (nonStdFld.checked){
			return "";
		} else {

			var houseNo = $("#"+name+"_streetNum").val();
			if (houseNoSel.val()!=""){
				houseNo = houseNoSel.val();
			}

			return "ajax/html/shop_unit_level.jsp?"
						+ "&streetId=" + $("#"+name+"_streetId").val()
						+ "&houseNo=" + houseNo
						+ "&search=" + this.value
						+ "&fieldId=" + this.id;
		}
	};
	unitShopFld.itemSelected=function(key,val){
		this.lastSelected = key;
		this.value=key;
		setTimeout("ajaxdrop_hide('"+this.id+"')", 50);
		nonStdFld.focus();
	};
	unitShopFld.onkeydown=function(e){
		ajaxdrop_onkeydown(this.id,e);
	};
	unitShopFld.onkeyup=function(e){
		ajaxdrop_onkeyup(this.id,e);
	};
	unitShopFld.onblur=function(e){
		setTimeout("ajaxdrop_hide('"+this.id+"')", 150);
	};

	// NON STANDARD ADDRESS
	nonStdFld.onclick=function(e){
		if ($(this).attr("checked")){
			streetId.val("");
			sbrSeq.val("");
			streetName.val("");
			suburbName.val("");
			state.val("");
			street.val("");
			streetNum.val("");
			unitShop.val("");
			houseNoSel.val("");
			unitSel.val("");

			postCodeFld.data('previous', '');
			postCodeFld.change();

			$("#"+name+"_std_street").hide();
			$("."+name+"_nonStd_street").show();

		} else {
			street.previousValue = "";
			streetName.val("");
			street.val("");
			nonStdStreet.val("");
			$("."+name+"_nonStd_street").hide();
			$("#"+name+"_std_street").show();

		}


		if ($(this).attr("checked")){
			streetNumRow.show();
			unitShopRow.show();
		} else if (street.val() == ""){
			streetNumRow.hide();
			unitShopRow.hide();
			street.focus();
		}
	};
	nonStdFld.keyup=nonStdFld.click;
}
