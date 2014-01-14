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

<c:set var="isPostalAddress" value="${type == 'POSTAL'}" />
<c:set var="isResidentialAddress" value="${type == 'RES'}" />

<c:set var="unitTypes">=Please choose...,CO=Cottage,DU=Duplex</c:set>
<c:if test="${!isResidentialAddress}">
	<c:set var="unitTypes">${unitTypes},FA=Factory</c:set>
</c:if>
<c:set var="unitTypes">${unitTypes},HO=House</c:set>
<c:if test="${!isResidentialAddress}">
	<c:set var="unitTypes">${unitTypes},KI=Kiosk</c:set>
</c:if>
<c:set var="unitTypes">${unitTypes},L=Level,M=Maisonette,MA=Marine Berth</c:set>
<c:if test="${!isResidentialAddress}">
	<c:set var="unitTypes">${unitTypes},OF=Office</c:set>
</c:if>
<c:set var="unitTypes">${unitTypes},PE=Penthouse,RE=Rear,RO=Room</c:set>
<c:if test="${!isResidentialAddress}">
	<c:set var="unitTypes">${unitTypes},SH=Shop,ST=Stall</c:set>
</c:if>
<c:set var="unitTypes">${unitTypes},SI=Site,SU=Suite,TO=Townhouse,UN=Unit,VI=Villa,WA=Ward,OT=Other</c:set>

<%-- CSS --%>
<go:style marker="css-head">
.street-search-help { margin-left: 205px; }
</go:style>
<%-- HTML --%>
<go:script href="common/js/address/address.js" marker="js-href"/>
<go:script href="common/js/address/ajax_drop.js" marker="js-href"/>

<field:hidden xpath="${xpath}/type" />

<%-- POSTCODE --%>
<form:row label="Postcode" id="${name}_postCode_suburb" className="halfrow">
	<input type="text" title="the postcode" name="${name}_postCode" id="${name}_postCode" maxlength="4" value="${address.postCode}">
</form:row>
<%-- SUBURB DROPDOWN (NON STD) --%>
<form:row label="Suburb" className="halfrow right ${name}_nonStd_street" >
		<select name="${name}_suburb" id="${name}_suburb" title="the suburb">
		<option></option>
		</select>
</form:row>

<core:clear />

<%-- ADDRESS LABEL AND TITLES --%>
<c:set var="addressLabel" value="Street Address" />
<c:set var="addressTitle" value="the street address" />
<c:if test="${isPostalAddress}">
	<c:set var="addressLabel" value="Postal Address" />
	<c:set var="addressTitle" value="the postal address" />
</c:if>

<%-- STREET-SEARCH --%>
<div class="street-search-help"><p>Start typing your address, and select the correct address from the drop down box below.</p></div>

<form:row label="${addressLabel}" id="${name}_std_street" className="std_street">
	<div class="${name}_streetSearch_container">
		<input type="text" title="${addressTitle}" name="${name}_streetSearch" id="${name}_streetSearch" class="streetSearch" value="${address.streetSearch}"></div>
	<div class="ui-corner-all ajaxdrop_streetSearch" id="ajaxdrop_${name}_streetSearch" style="display:none;"></div>
</form:row>


<%-- STREET INPUT (NON STD) --%>
<form:row label="Street" className="${name}_nonStd_street">
	<input type="text" title="the street" name="${name}_nonStdStreet" id="${name}_nonStdStreet" value="${address.nonStdStreet}">
</form:row>

<%-- STREET/HOUSE NUMBER (BOTH STD & NON STD) --%>
<c:set var="streetLabel" value="Street No." />
<c:if test="${isPostalAddress}">
	<c:set var="streetLabel" value="Street No. or PO Box" />
</c:if>

<form:row label="${streetLabel}" id="${name}_streetNumRow" className="std_streetNum">
	<div class="${name}_streetNum_container">
		<input type="text"  title="the street no." name="${name}_streetNum"
			id="${name}_streetNum" class="streetSearchNum" value="${address.streetNum}" >
		</div>
	<div class="ui-corner-all ajaxdrop_streetSearchNum" id="ajaxdrop_${name}_streetNum"></div>
</form:row>


<%-- UNIT/SHOP (BOTH STD & NON STD) --%>
<form:row label="Unit/Shop/Level" id="${name}_unitShopRow" className="std_streetUnitShop halfrow ${name}_unitShopRow">
	<input type="text"  title="the unit/shop" name="${name}_unitShop" id="${name}_unitShop" class="groupAddressTwoColumn" value="${address.unitShop}">
	<div class="ui-corner-all ajaxdrop_streetUnitShop" id="ajaxdrop_${name}_unitShop"></div>
	<div class="ui-corner-all" id="ajaxdrop_current"></div>
</form:row>

<form:row label="Unit Type" className="halfrow right ${name}_nonStd_street ${name}_unitShopRow">
	<field:array_select items="${unitTypes}" xpath="${xpath}/unitType" title="the unit type" required="false" />
</form:row>

<core:clear />

<c:set var="nonStdChecked" value="" />
<c:if test="${address.nonStd=='Y'}">
	<c:set var="nonStdChecked" value=" checked='checked'" />
</c:if>

<form:row label="" id="${name}_nonStd_row" className="nonStd">
	<input type="checkbox" name="${name}_nonStd" id="${name}_nonStd" value="Y"${nonStdChecked} tabIndex="-1">
	<label for="${name}_nonStd">Tick here if you are unable to find the address</label>
</form:row>
<core:clear />

<field:hidden xpath="${xpath}/lastSearch" />
<field:hidden xpath="${xpath}/sbrSeq" />
<field:hidden xpath="${xpath}/streetId" />
<field:hidden xpath="${xpath}/houseNoSel" />
<field:hidden xpath="${xpath}/unitSel" />
<field:hidden xpath="${xpath}/streetName" />
<field:hidden xpath="${xpath}/suburbName" />
<field:hidden xpath="${xpath}/state" />
<field:hidden xpath="${xpath}/dpId" />
<field:hidden xpath="${xpath}/fullAddressLineOne" />
<field:hidden xpath="${xpath}/fullAddress" />

<%-- Custom validation for address --%>
<go:validate selector="${name}_postCode" 		rule="required" 	parm="true" 		message="Please enter the postcode"/>
<go:validate selector="${name}_streetSearch" 	rule="validAddress" parm="'${name}'"	message="We can&#39;t seem to find that address&#46;<br /><br />Let&#39;s try again&#58; Please start typing your street address and then select your address from our drop-down box&#46;<br /><br />If you cannot find your address in our drop down&#44; please tick the &#39;Unable to find the address&#39; checkbox to manually enter your address&#46;"/>
<go:validate selector="${name}_suburb" 			rule="validAddress" parm="'${name}'"	message="Please select a suburb"/>
<c:choose>
	<c:when test="${type == 'R'}">
		<go:validate selector="${name}_nonStdStreet" 	rule="validAddress" parm="'${name}'"	message="Please enter the residential street"/>
	</c:when>
	<c:when test="${type == 'P'}">
		<go:validate selector="${name}_nonStdStreet" 	rule="validAddress" parm="'${name}'"	message="Please enter the postal street"/>
	</c:when>
	<c:otherwise>
		<go:validate selector="${name}_nonStdStreet" 	rule="validAddress" parm="'${name}'"	message="Please enter the street"/>
	</c:otherwise>
</c:choose>
<go:validate selector="${name}_streetNum" 		rule="validAddress" parm="'${name}'"	message="Please enter the street number"/>
<go:validate selector="${name}_unitShop" 		rule="validAddress" parm="'${name}'"	message="Please enter the unit/shop"/>
<go:validate selector="${name}_nonStd" 			rule="validAddress" parm="'${name}'"	message="Please enter the address"/>

<go:script marker="onready">

	init_address("${name}" , ${isResidentialAddress} , ${isPostalAddress});
	defaultSuburbSeq = ("${address.suburb}");
	<c:if test="${address.nonStd == 'Y'}">
		$("#${name}_postCode").change(function() {
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

		<c:if test="${fn:length(address.streetNum) == 0 || fn:length(address.dpId) != 0 }">
			$("#${name}_streetNumRow").hide();
		</c:if>
		<c:if test="${fn:length(address.unitShop) == 0 || fn:length(address.dpId) != 0 }">
			$("#${name}_unitShopRow").hide();
		</c:if>
	</c:if>

	<%-- Non-standard Address --%>
	<c:if test="${address.nonStd == 'Y'}">
		$("#${name}_std_street").hide();
	</c:if>

	$("#${name}_nonStd").click(function(){
		if ($(this).attr('checked')) {
			$(".${name}_nonStd_street, #${name}_streetNumRow, #${name}_unitShopRow").show();
			$("#${name}_std_street, .street-search-help").hide();
		} else {
			$(".${name}_nonStd_street, #${name}_streetNumRow, #${name}_unitShopRow").hide();
			$("#${name}_std_street, .street-search-help").show();
		}
		$("#mainform").validate().element("#${name}_nonStd");
	});

	<%-- Non-standard Address --%>
		$("#${name}_nonStdStreet").change(function(){
			$(this).val($.trim($(this).val()));
			$("#${name}_streetName").val($(this).val());
		});
	$("#${name}_suburb").change(function(){
		$("#${name}_suburbName").val($(this).children("option:selected").first().text());
	});
	$("#${name}_streetSearch, #${name}_streetNum, #${name}_unitShop").bind('blur',function(){
		if($("#mainform").validate().numberOfInvalids() !== 0) {
			$("#mainform").validate().element($(this));
		}
	});
</go:script>
<go:style marker="css-head">
<%-- NOTE: extra styles located in style_ie (IE) --%>
#${name}_postCode {
	width:50px;
}
#${name}_streetSearch {
	width:350px;
}
#ajaxdrop_${name}_streetSearch,
	#ajaxdrop_${name}_streetNum,
	#ajaxdrop_${name}_unitShop {
	position:absolute;
	left:auto;
	top:auto;
	width:210px;
	z-index:10;
	border:1px solid #CECECE;
	background-color:white;
	display:none;
	white-space: nowrap;
	overflow: hidden;
	margin-left:1px;
	margin-top:0px;
	text-align:left;
	padding:2px;
}
#ajaxdrop_${name}_streetSearch {
	width:350px;
}
#ajaxdrop_${name}_streetSearch div,
	#ajaxdrop_${name}_streetNum div,
	#ajaxdrop_${name}_unitShop div {
	text-indent:4px;
}

#${name}_streetNum,
	#${name}_unitShop,
	#ajaxdrop_${name}_streetNum,
	#ajaxdrop_${name}_unitShop {
	width: 6em;
}

#${name}_nonStdStreet {
	width: 19em;
}

#ajaxdrop_current {
	display:none;
}
.ajaxdrop	{ font-size:13px; height: 22px; line-height:22px; cursor: pointer;}
.ajaxdrop_over { color: #ffffff; background-color:#0CB24E;cursor: pointer;}
</go:style>