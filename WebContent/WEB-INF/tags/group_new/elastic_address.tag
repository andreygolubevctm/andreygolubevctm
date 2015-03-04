<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 						required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="type" 						required="true"	 rtexprvalue="true"	 description="the address type R=Residential P=Postal" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="postcode" 		value="${name}_postcode" />
<c:set var="streetSearch" 	value="${name}_streetSearch" />
<c:set var="address" 		value="${data.node[xpath]}" />

<go:script href="common/javascript/elastic_address.js" marker="js-href"/>

<div id="elasticSearchTypeaheadComponent">

	<%-- STREET-SEARCH (ELASTIC) --%>
	<c:set var="fieldXpath" value="${xpath}/streetSearch" />
	<form_new:row fieldXpath="${fieldXpath}" label="Street Address" id="${name}_std_street" className="std_street">
		<field_new:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-streetSearch show-loading sessioncamexclude" title="the street address" placeHolder="${placeholder}" required="false" />
	</form_new:row>

	<%-- POSTCODE --%>
	<c:set var="fieldXpath" value="${xpath}/nonStdPostCode" />
	<form_new:row fieldXpath="${fieldXpath}" label="Postcode" id="${name}_postCode_suburb" className="std_postCode">
		<field:post_code xpath="${fieldXpath}" required="true" title="postcode" />
	</form_new:row>

	<%-- SUBURB DROPDOWN (populated from postcode) --%>
	<c:set var="fieldXpath" value="${xpath}/suburb" />
	<form_new:row fieldXpath="${fieldXpath}" label="Suburb" className="${name}_nonStd_street">
		<c:choose>
			<c:when test="${not empty address.postCode}">
				<sql:query var="result" dataSource="jdbc/aggregator">
					SELECT suburb, count(street) as streetCount, suburbSeq, state, street
					FROM aggregator.streets
					WHERE postCode = ?
					GROUP by suburb
					<sql:param>${address.postCode}</sql:param>
				</sql:query>
				<div class="select">
					<span class=" input-group-addon" data-target="${name}">
						<i class="icon-sort"></i>
					</span>
					<select name="${name}_suburb" id="${name}_suburb" title="the suburb" class="form-control" data-attach="true">
						<%-- Write the initial "Please select" option --%>
						<option value="">Please select</option>
						<%-- Write the options for each row --%>
						<c:forEach var="row" items="${result.rows}">
							<c:choose>
								<c:when test="${row.suburbSeq == address.suburb || row.suburb == address.suburbName}">
									<option value="${row.suburbSeq}" selected="selected">${row.suburb}</option>
								</c:when>
								<c:otherwise>
									<option value="${row.suburbSeq}">${row.suburb}</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</select>
				</div>
			</c:when>
			<c:otherwise>
				<div class="select">
					<span class=" input-group-addon" data-target="${name}">
						<i class="icon-sort"></i>
					</span>
					<select name="${name}_suburb" id="${name}_suburb" title="the suburb" class="form-control" data-msg-required="Please select a suburb" data-attach="true" disabled="disabled">
						<option value=''>Enter Postcode</option>
					</select>
				</div>
			</c:otherwise>
		</c:choose>
	</form_new:row>

	<core:clear />

	<%-- STREET NAME --%>
	<c:set var="fieldXpath" value="${xpath}/nonStdStreet" />
	<form_new:row fieldXpath="${fieldXpath}" label="Street" className="${name}_nonStd_street">
		<field_new:input xpath="${fieldXpath}" title="the street" required="false" className="sessioncamexclude" />
	</form_new:row>

	<%-- STREET NUMBER --%>
	<c:set var="fieldXpath" value="${xpath}/streetNum" />
	<form_new:row fieldXpath="${fieldXpath}" label="Street No." id="${name}_streetNumRow" className="std_streetNum">
		<div class="${name}_streetNum_container">
			<field_new:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-streetNum blur-on-select show-loading sessioncamexclude" title="the street no." includeInForm="true" required="true" />
		</div>
	</form_new:row>

	<%-- UNIT/SHOP NUMBER (Optional) --%>
	<c:set var="fieldXpath" value="${xpath}/unitShop" />
	<form_new:row fieldXpath="${fieldXpath}" label="Unit/Shop/Level" id="${name}_unitShopRow" className="std_streetUnitShop ${name}_unitShopRow">
		<field_new:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-unitShop blur-on-select show-loading sessioncamexclude" title="the unit/shop" includeInForm="true" required="false" />
	</form_new:row>

	<%-- UNIT/SHOP TYPE (Optional) --%>
	<c:set var="unitTypes">=Please choose...,CO=Cottage,DU=Duplex,FA=Factory,HO=House,KI=Kiosk,L=Level,M=Maisonette,MA=Marine Berth,OF=Office,PE=Penthouse,RE=Rear,RO=Room,SH=Shop,ST=Stall,SI=Site,SU=Suite,TO=Townhouse,UN=Unit,VI=Villa,WA=Ward,OT=Other</c:set>
	<c:set var="fieldXpath" value="${xpath}/unitType" />
	<form_new:row fieldXpath="${fieldXpath}" label="Unit Type" className="${name}_nonStd_street ${name}_unitShopRow">
		<field_new:array_select items="${unitTypes}" xpath="${fieldXpath}" title="the unit type" required="false" includeInForm="true" />
	</form_new:row>

	<!-- NON STANDARD CHECKBOX -->
	<c:set var="fieldXpath" value="${xpath}/nonStd" />
	<form_new:row fieldXpath="${fieldXpath}" label="" id="${name}_nonStd_row" className="nonStd">
		<field_new:checkbox xpath="${fieldXpath}" value="Y" title="Tick here if you are unable to find the address" label="true" required="false" />
	</form_new:row>

	<core:clear />

	<!-- HIDDEN FIELDS (Populated in autocomplete.js or elastic_search.js) -->
	<field:hidden xpath="${xpath}/type" defaultValue="R" />
	<field:hidden xpath="${xpath}/elasticSearch" defaultValue="Y" />
	<field:hidden xpath="${xpath}/lastSearch" />
	<field:hidden xpath="${xpath}/fullAddressLineOne" />
	<field:hidden xpath="${xpath}/fullAddress" />

	<field:hidden xpath="${xpath}/dpId" />
	<field:hidden xpath="${xpath}/unitType" />
	<field:hidden xpath="${xpath}/unitSel" />
	<field:hidden xpath="${xpath}/houseNoSel" />
	<field:hidden xpath="${xpath}/floorNo" />
	<field:hidden xpath="${xpath}/streetName" />
	<field:hidden xpath="${xpath}/streetId" />
	<field:hidden xpath="${xpath}/suburbName" />
	<field:hidden xpath="${xpath}/postCode" />
	<field:hidden xpath="${xpath}/state" />
</div>

<%-- Custom validation for address --%>
<go:validate selector="${name}_streetSearch"	rule="validStreetSearch"	parm="'${name}'"	message="Please select a valid address"/>
<go:validate selector="${name}_postCode"		rule="validAddress"			parm="'${name}'"	message="Please enter a valid postcode"/>
<go:validate selector="${name}_suburb"			rule="validSuburb"			parm="'${name}'"	message="Please select a suburb"/>
<go:validate selector="${name}_nonStdStreet"	rule="validAddress"			parm="'${name}'"	message="Please enter the residential street"/>
<go:validate selector="${name}_streetNum"		rule="validAddress"			parm="'${name}'"	message="Please enter a valid street number"/>
<go:validate selector="${name}_unitShop"		rule="validAddress"			parm="'${name}'"	message="Please enter a valid unit/shop/level"/>
<go:validate selector="${name}_unitType"		rule="validAddress"			parm="'${name}'"	message="Please select a unit type"/>
<go:validate selector="${name}_nonStd"			rule="validAddress"			parm="'${name}'"	message="Please enter the address"/>

<go:script marker="onready">
	<c:choose>
		<c:when test="${not empty address.suburb}">
			init_address("${name}", ${address.suburb});
		</c:when>
		<c:otherwise>
			init_address("${name}");
		</c:otherwise>
	</c:choose>
		$("#${name}_streetNum").val("${address.streetNum}");
		$("#${name}_unitShop").val("${address.unitShop}");
	<%-- Standard Address --%>
	<c:if test="${address.nonStd != 'Y'}">
		$(".${name}_nonStd_street").hide();
		$("#${name}_postCode_suburb").hide();

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

	<%-- Non-standard Address --%>
	$("#${name}_nonStdStreet").change(function changeNonStdStreet(){
		$(this).val($.trim($(this).val()));
		$("#${name}_streetName").val($(this).val());
	});
	$("#${name}_streetSearch, #${name}_streetNum, #${name}_unitShop, #${name}_unitType").bind('blur', function blurStreetNumUnit(){
		if($("#mainform").validate().numberOfInvalids() !== 0) {
			$("#mainform").validate().element($(this));
		}
	});
</go:script>