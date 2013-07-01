<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="type" 		required="true"	 rtexprvalue="true"	 description="the address type" %>


<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="postcode" 		value="${name}_postcode" />
<c:set var="streetSearch" 	value="${name}_streetSearch" />
<c:set var="address" 		value="${data.node[xpath]}" />

<%-- CSS --%>
<go:style marker="css-head">
.groupAddressSuburb {
	display:inline-block;
}
.groupAddressSuburb div {
	clear: none;
	width: 54px;
	float:left;
	display:block;
	margin:10px 0 0 35px;
}
.groupAddressPostcode { float:left; }

.street-search-help { /*margin-left: 205px;*/ }
</go:style>
<%-- HTML --%>
<go:script href="brand/ctm/competition/meerkat_rewards/js/address/address.js" marker="js-href"/>
<go:script href="brand/ctm/competition/meerkat_rewards/js/address/ajax_drop.js" marker="js-href"/>

<c:set var="isPostalAddress" value="${type!='R'}" />

<%-- POSTCODE --%>
<input type='hidden' name='${name}_type' value='${type}'>
<div id="${name}_postCode_suburb" class="row nohover">
	<div class="nohover columns">
		<div class="nohover groupAddressSuburb postcode">
			<label>Postcode</label>
			<input type="text" title="the postcode" name="${name}_postCode" id="${name}_postCode" maxlength="4" value="${address.postCode}" class="groupAddressPostcode">
		</div>
		<%-- SUBURB DROPDOWN (NON STD) --%>
		<div class="${name}_nonStd_street nohover groupAddressSuburb">
			<label>Suburb:</label>
			<select name="${name}_suburb" id="${name}_suburb" title="the suburb">
				<option value>Please select...</option>
			</select>
		</div>
	</div>
</div>

<%-- ADDRESS LABEL AND TITLES --%>
<c:set var="addressLabel" value="Street Address" />
<c:set var="addressTitle" value="the street address" />
<c:if test="${isPostalAddress}">
	<c:set var="addressLabel" value="Postal Address" />
	<c:set var="addressTitle" value="the postal address" />
</c:if>

<%-- STREET-SEARCH --%>
<div class="street-search-help"><p>Enter your postcode then start typing your address, and select the correct address from the drop down box below.</p></div>

<meerkatrewards:row label="${addressLabel}" id="${name}_std_street" className="large-12 nohover std_street">
	<div class="${name}_streetSearch_container"><input type="text" title="${addressTitle}" name="${name}_streetSearch" id="${name}_streetSearch" class="streetSearch" value="${address.streetSearch}" onkeyup="ajaxdrop_update(this.id)"></div>
	<div class="ui-corner-all ajaxdrop_streetSearch" id="ajaxdrop_${name}_streetSearch" style="display:none;"></div>
</meerkatrewards:row>


<%-- STREET INPUT (NON STD) --%>
<meerkatrewards:row label="Street" className="large-12 nohover ${name}_nonStd_street">
	<input type="text" title="the street" name="${name}_nonStdStreet" id="${name}_nonStdStreet" value="${address.nonStdStreet}">
</meerkatrewards:row>

<%-- STREET/HOUSE NUMBER (BOTH STD & NON STD) --%>
<c:set var="streetLabel" value="Street No." />
<c:if test="${isPostalAddress}">
	<c:set var="streetLabel" value="Street No. or PO Box" />
</c:if>

<meerkatrewards:row label="${streetLabel}" id="${name}_streetNumRow" className="large-12 nohover std_streetNum">
	<div class="${name}_streetNum_container"><input type="text"  title="the street no." name="${name}_streetNum" id="${name}_streetNum" class="streetSearchNum" value="${address.streetNum}" ></div>
	<div class="ui-corner-all ajaxdrop_streetSearchNum" id="ajaxdrop_${name}_streetNum"></div>
</meerkatrewards:row>


<%-- UNIT/SHOP (BOTH STD & NON STD) --%>
<meerkatrewards:row label="Unit/Shop/Level" id="${name}_unitShopRow" className="large-12 nohover std_streetUnitShop">
	<input type="text"  title="the unit/shop" name="${name}_unitShop" id="${name}_unitShop"  class="streetSearchUnitShop" value="${address.unitShop}">
	<div class="ui-corner-all ajaxdrop_streetUnitShop" id="ajaxdrop_${name}_unitShop"></div>
	<div class="ui-corner-all" id="ajaxdrop_current"></div>
</meerkatrewards:row>

<c:set var="nonStdChecked" value="" />
<c:if test="${address.nonStd=='Y'}">
	<c:set var="nonStdChecked" value=" checked='checked'" />
</c:if>

<meerkatrewards:row label="" id="${name}_nonStd_row" className="large-12 nonStd inline_label">

	<label for="checkbox1" class="${name}_nonStd">
		<input type="checkbox" name="${name}_nonStd" id="${name}_nonStd" value="Y"${nonStdChecked} tabIndex="-1" />
		<span class="custom checkbox"></span>
		<div class="checkboxLabel">
			<c:choose>
				<c:when test="${isPostalAddress}">
					Unable to find the address or PO Box?
				</c:when>
				<c:otherwise>
					Unable to find the address?
				</c:otherwise>
			</c:choose>
		</div>
	</label>
</meerkatrewards:row>
<core:clear />

<input type="hidden" name="${name}_lastSearch" 	id="${name}_lastSearch" value="${address.lastSearch}">
<input type="hidden" name="${name}_sbrSeq" 		id="${name}_sbrSeq" 	value="${address.sbrSeq}">
<input type="hidden" name="${name}_streetId" 	id="${name}_streetId" 	value="${address.streetId}">
<input type="hidden" name="${name}_houseNoSel" 	id="${name}_houseNoSel" value="${address.houseNoSel}">
<input type="hidden" name="${name}_unitSel" 	id="${name}_unitSel" 	value="${address.unitSel}">

<input type="hidden" name="${name}_streetName" 	id="${name}_streetName" value="${address.streetName}">
<input type="hidden" name="${name}_suburbName" 	id="${name}_suburbName" value="${address.suburbName}">
<input type="hidden" name="${name}_state" 		id="${name}_state" 		value="${address.state}">

<%-- Custom validation for address --%>
<go:validate selector="${name}_postCode" 		rule="required" 	parm="true" 		message="Please enter the postcode"/>
<go:validate selector="${name}_streetSearch" 	rule="validAddress" parm="'${name}'"	message="We can&#39;t seem to find that address&#46;<br /><br />Let&#39;s try again&#58; Please start typing your street address and then select your address from our drop-down box&#46;<br /><br />If you cannot find your address in our drop down&#44; please tick the &#39;Unable to find the address&#39; checkbox to manually enter your address&#46;"/>
<go:validate selector="${name}_suburb" 			rule="validAddress" parm="'${name}'"	message="Please select a suburb"/>
<c:choose>
	<c:when test="${type == 'R'}">
		<go:validate selector="${name}_nonStdStreet" 	rule="validAddress" parm="'${name}'"	message="Please enter the residential street"/>
	</c:when>
	<c:when test="${type == 'P'}">
		<go:validate selector="${name}_nonStdStreet" 	rule="validAddressP" parm="'${name}'"	message="Please enter the postal street"/>
	</c:when>
	<c:otherwise>
		<go:validate selector="${name}_nonStdStreet" 	rule="validAddress" parm="'${name}'"	message="Please enter the street"/>
	</c:otherwise>
</c:choose>
<go:validate selector="${name}_streetNum" 		rule="validAddress" parm="'${name}'"	message="Please enter the street number"/>
<go:validate selector="${name}_unitShop" 		rule="validAddress" parm="'${name}'"	message="Please enter the unit/shop"/>
<go:validate selector="${name}_nonStd" 			rule="validAddress" parm="'${name}'"	message="Please enter the address"/>

<go:script marker="onready">

	init_address("${name}");
	defaultSuburbSeq = ("${address.suburb}");
	<c:if test="${address.nonStd == 'Y'}">
		$("#${name}_postCode").change(function(){
			if (/[0-9]{4}/.test($(this).val())) {
				$.getJSON("ajax/html/suburbs.jsp",
						{postCode:$("#${name}_postCode").val()},
						function(resp) {
							if (resp.suburbs && resp.suburbs.length > 0) {
								var options = '<option value="">Please select...</option>';
								for (var i = 0; i < resp.suburbs.length; i++) {
									if (defaultSuburbSeq != undefined && resp.suburbs[i].id == defaultSuburbSeq){
										options += '<option value="' + resp.suburbs[i].id + '" selected="">' + resp.suburbs[i].des + '</option>';
									} else {
									options += '<option value="' + resp.suburbs[i].id + '">' + resp.suburbs[i].des + '</option>';
									}
								}
								$("#${name}_suburb").html(options).removeAttr("disabled");
							} else {
								$("#${name}_suburb").html("<option value=''>Invalid Postcode</option>").attr("disabled", "disabled");
							}
							if (resp.state && resp.state.length > 0){
								$("#${name}_state").val(resp.state);
							} else {
								$("#${name}_state").val("");
							}
						});
			}
		});
		$("#${name}_postCode").change();
		$("#${name}_streetNum").val("${address.streetNum}");
		$("#${name}_unitShop").val("${address.unitShop}");
		$("#${name}_suburbName").val("${address.suburbName}");
		$("#${name}_streetName").val("${address.nonStdStreet}");
	</c:if>
	<%-- Standard Address --%>
	<c:if test="${address.nonStd != 'Y'}">
		$(".${name}_nonStd_street").hide();

		<c:if test="${fn:length(address.streetNum) == 0 }">
			$("#${name}_streetNumRow").hide();
		</c:if>
		<c:if test="${fn:length(address.unitShop) == 0 }">
			$("#${name}_unitShopRow").hide();
		</c:if>
	</c:if>

	<%-- Non-standard Address --%>
	<c:if test="${address.nonStd == 'Y'}">
		$("#${name}_std_street").hide();
	</c:if>

	$("#${name}_nonStd").siblings('span').first().on('click', function(){
		if (!$("#${name}_nonStd").is(':checked')) { // will be checked after this code
			$(".${name}_nonStd_street, #${name}_streetNumRow, #${name}_unitShopRow").show();
			$("#${name}_std_street, .street-search-help").hide();
			meerkatRewards.resetAddress();
		} else {
			$(".${name}_nonStd_street, #${name}_streetNumRow, #${name}_unitShopRow").hide();
			$("#${name}_std_street, .street-search-help").show();
		}
		//$("#meerkatRewardsForm").validate().element("#${name}_nonStd");
	});

	$("#${name}_nonStd").siblings('div.checkboxLabel').first().on('click', function(){
		$("#${name}_nonStd").siblings('span').first().trigger('click');
	});

	<%-- Non-standard Address --%>
		$("#${name}_nonStdStreet").change(function(){
			$(this).val($(this).val().trim());
			$("#${name}_streetName").val($(this).val());
		});
	$("#${name}_suburb").change(function(){
		$("#${name}_suburbName").val($(this).children("option:selected").first().text());
	});
	$("#${name}_streetSearch, #${name}_streetNum, #${name}_unitShop").bind('blur',function(){
		if($("#meerkatRewardsForm").validate().numberOfInvalids()!=0){
			$("#meerkatRewardsForm").validate().element($(this));
		}
	});

//
// ADDRESS VALIDATION
//
// Called for all of the address fields,
// allows correct cross-field dependency checks
// and cross field validation
//
<c:choose>
	<c:when test="${type == 'P'}">
		$.validator.addMethod("validAddressP",
	</c:when>
	<c:otherwise>
		$.validator.addMethod("validAddress",
	</c:otherwise>
</c:choose>
		function(value, element, name) {
			return true;
			var fldName=$(element).attr("id").substring(name.length);
			switch(fldName){
			case "_streetSearch":
				if ($("#"+name+"_nonStd").is(":checked")){
					$(element).removeClass("error");
					return true;
				} else if ( $("#"+name+"_streetName").val()!="" ){
					$("#meerkatRewardsForm").validate().element("#"+name+"_streetNum");
					$("#meerkatRewardsForm").validate().element("#"+name+"_unitShop");
					$(element).removeClass("error");
					return true;
				} else {
					return false;
				}
			case "_streetNum":
			case "_suburb":
				return !$(element).is(":visible")
						|| $(element).val()!="";

			case "_nonStdStreet":
				if (!$(element).is(":visible")) {
					return true;
				}
				<c:if test="${type == 'R'}">
					<%-- Residential street cannot start with GPO or PO, or contain numbers --%>
					var re = /^G?\.?P\.?O\.?\s/i;
					if (re.test(value) || /\d/.test(value)) {
						return false;
					};
				</c:if>
				<%-- If no space, then the street type is missing --%>
				if(value.indexOf(' ') == -1){
					return false;
				}
				return (value!="");

			case "_unitShop":
				return !$(element).is(":visible")
						|| $("#"+name+"_nonStd").is(":checked")
						|| $(element).val()!="";
			case "_nonStd":
				return true;
				if ($(element).is(":checked:")){
					$("#meerkatRewardsForm").validate().element("#"+name+"_streetSearch");
				} else {
					$("#meerkatRewardsForm").validate().element("#"+name+"_suburb");
					$("#meerkatRewardsForm").validate().element("#"+name+"_nonStdStreet");
					$("#meerkatRewardsForm").validate().element("#"+name+"_streetNum");
					$("#meerkatRewardsForm").validate().element("#"+name+"_unitShop");
				}
				return true;
			}
			return false;
		},
		"Please enter a valid address"
);



</go:script>