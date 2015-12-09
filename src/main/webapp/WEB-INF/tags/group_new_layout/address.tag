<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="type" 		required="true"	 rtexprvalue="true"	 description="the address type R=Residential P=Postal" %>
<%@ attribute name="showTitle"	required="false" rtexprvalue="true"	 description="true/false to show the main title" %>
<%@ attribute name="stateValidationField"		required="false" rtexprvalue="true"	 description="true/false to show the main title" %>



<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="postcode" 		value="${name}_postcode" />
<c:set var="streetSearch" 	value="${name}_streetSearch" />
<c:set var="address" 		value="${data.node[xpath]}" />

<c:set var="isPostalAddress" value="${type == 'P'}" />
<c:set var="isResidentialAddress" value="${type == 'R'}" />

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

<%-- HTML --%>
<go:script href="common/javascript/legacy_address.js" marker="js-href"/>

<c:if test="${empty showTitle or showTitle == 'true'}">
	<form_new_layout:row fieldXpath="${fieldXpath}" label="${isPostalAddress? 'Postal' : 'Residential'} Address" id="22">
		&nbsp;
	</form_new_layout:row>
</c:if>

<field:hidden xpath="${xpath}/elasticSearch" defaultValue="N" />
<field:hidden xpath="${xpath}/type" defaultValue="${type}" />

<%-- POSTCODE --%>
<c:set var="fieldXpath" value="${xpath}/postCode" />
<form_new_layout:row fieldXpath="${fieldXpath}" label="Postcode" id="${name}_postCode_suburb">
	<field:post_code xpath="${fieldXpath}" required="true" title="postcode" additionalAttributes=" data-rule-validAddress='${name}' data-msg-validAddress='Please enter a valid postcode' " />
</form_new_layout:row>

<%-- SUBURB DROPDOWN (NON STD) --%>
<c:set var="fieldXpath" value="${xpath}/suburb" />
<form_new_layout:row fieldXpath="${fieldXpath}" label="Suburb" className="${name}_nonStd_street">
	<c:choose>
		<c:when test="${not empty address.postCode}">
			<sql:query var="result" dataSource="${datasource:getDataSource()}">
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
				<select name="${name}_suburb" id="${name}_suburb" title="the suburb" class="form-control" data-attach="true" data-rule-validSuburb="${name}" data-msg-validSuburb="Please select a suburb">
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
				<select name="${name}_suburb" id="${name}_suburb" title="the suburb" class="form-control" data-msg-required="Please select a suburb" data-attach="true" disabled="disabled" data-rule-validSuburb="${name}" data-msg-validSuburb="Please select a suburb">
					<option value=''>Enter Postcode</option>
				</select>
			</div>
		</c:otherwise>
	</c:choose>
</form_new_layout:row>

<core:clear />

<%-- ADDRESS LABEL AND TITLES --%>
<c:set var="addressLabel" value="Street Address" />
<c:set var="addressTitle" value="the street address" />
<c:if test="${isPostalAddress}">
	<c:set var="addressLabel" value="Postal Address" />
	<c:set var="addressTitle" value="the postal address" />
</c:if>

<%-- STREET-SEARCH --%>


<c:set var="fieldXpath" value="${xpath}/streetSearch" />
<form_new_layout:row fieldXpath="${fieldXpath}" label="${addressLabel}" id="${name}_std_street" className="std_street">
	<%--
	<div class="${name}_streetSearch_container">
		<input type="text" title="${addressTitle}" name="${name}_streetSearch" id="${name}_streetSearch" class="streetSearch" value="${address.streetSearch}"></div>
	<div class="ui-corner-all ajaxdrop_streetSearch" id="ajaxdrop_${name}_streetSearch" style="display:none;"></div>
	--%>
	<field_new:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-streetSearch show-loading sessioncamexclude" title="${addressTitle}" placeHolder="${placeholder}" required="false" additionalAttributes=" data-rule-validAddress='${name}' data-msg-validAddress='We can&#39;t seem to find that address&#46;<br /><br />Let&#39;s try again&#58; Please start typing your street address and then select your address from our drop-down box&#46;<br /><br />If you cannot find your address in our drop down&#44; please tick the &#39;Unable to find the address&#39; checkbox to manually enter your address&#46;' "/>
</form_new_layout:row>


<%-- STREET INPUT (NON STD) --%>
<c:set var="nonStdStreetMessage" value="" />
<c:choose>
	<c:when test="${isResidentialAddress}">
		<c:set var="nonStdStreetMessage" value="Please enter the residential street" />
	</c:when>
	<c:when test="${isPostalAddress}">
		<c:set var="nonStdStreetMessage" value="Please enter the postal street" />
	</c:when>
	<c:otherwise>
		<c:set var="nonStdStreetMessage" value="Please enter the street" />
	</c:otherwise>
</c:choose>
<c:set var="fieldXpath" value="${xpath}/nonStdStreet" />
<form_new_layout:row fieldXpath="${fieldXpath}" label="Street" className="${name}_nonStd_street">
	<field_new:input xpath="${fieldXpath}" title="the street" required="false" className="sessioncamexclude" additionalAttributes="data-rule-validAddress='${name}' data-msg-validAddress='${nonStdStreetMessage}' " />
</form_new_layout:row>

<%-- STREET/HOUSE NUMBER (BOTH STD & NON STD) --%>
<c:set var="streetLabel" value="Street No." />
<c:if test="${isPostalAddress}">
	<c:set var="streetLabel" value="Street No. or PO Box" />
</c:if>

<c:set var="fieldXpath" value="${xpath}/streetNum" />
<form_new_layout:row fieldXpath="${fieldXpath}" label="${streetLabel}" id="${name}_streetNumRow" className="std_streetNum">
	<div class="${name}_streetNum_container">
		<field_new:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-streetNum blur-on-select show-loading sessioncamexclude" title="the street no." includeInForm="true" required="false" />
	</div>
</form_new_layout:row>


<%-- UNIT/SHOP (BOTH STD & NON STD) --%>
<c:set var="fieldXpath" value="${xpath}/unitShop" />
<form_new_layout:row fieldXpath="${fieldXpath}" label="Unit/Shop/Level" id="${name}_unitShopRow" className="std_streetUnitShop ${name}_unitShopRow">
	<field_new:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-unitShop blur-on-select show-loading sessioncamexclude" title="the unit/shop" includeInForm="true" required="false"  />
</form_new_layout:row>

<c:set var="fieldXpath" value="${xpath}/unitType" />
<form_new_layout:row fieldXpath="${fieldXpath}" label="Unit Type" className="${name}_nonStd_street ${name}_unitShopRow">
	<field_new:array_select items="${unitTypes}" xpath="${fieldXpath}" title="the unit type" required="false" includeInForm="true" />
</form_new_layout:row>

<c:set var="fieldXpath" value="${xpath}/nonStd" />
<form_new_layout:row fieldXpath="${fieldXpath}" label="" id="${name}_nonStd_row" className="nonStd">
	<field_new:checkbox xpath="${fieldXpath}" value="Y" title="Tick here if you are unable to find the address" label="true" required="false" customAttribute=" data-rule-validAddress='${name}' data-msg-validAddress='Please enter the address'" />
</form_new_layout:row>
<core:clear />

<field:hidden xpath="${xpath}/lastSearch" />
<field:hidden xpath="${xpath}/streetId" />
<field:hidden xpath="${xpath}/houseNoSel" />
<field:hidden xpath="${xpath}/unitSel" />
<field:hidden xpath="${xpath}/streetName" />
<field:hidden xpath="${xpath}/suburbName" />
<c:choose>
	<c:when test="${not empty stateValidationField}">
		<field_new:validatedHiddenField xpath="${xpath}/state" validationErrorPlacementSelector="${stateValidationField}" additionalAttributes=" required data-rule-matchStates='true' " />
	</c:when>
	<c:otherwise>
		<field:hidden xpath="${xpath}/state" />
	</c:otherwise>
</c:choose>
<field:hidden xpath="${xpath}/dpId" />
<field:hidden xpath="${xpath}/fullAddressLineOne" />
<field:hidden xpath="${xpath}/fullAddress" />


<go:script marker="onready">
	<c:choose>
		<c:when test="${not empty address.suburb}">
			_.defer(function() {
			init_address("${name}" , ${isResidentialAddress} , ${isPostalAddress}, ${address.suburb});
			});
		</c:when>
		<c:otherwise>
			_.defer(function() {
			init_address("${name}" , ${isResidentialAddress} , ${isPostalAddress});
			});
		</c:otherwise>
	</c:choose>
	$("#${name}_streetNum").val("${address.streetNum}");
	$("#${name}_unitShop").val("${address.unitShop}");
	<%-- Standard Address --%>
	<c:if test="${address.nonStd != 'Y'}">
		<%--
		I added this in for a reason early on, but may no longer be necessary.
		$("#${name}_suburb").trigger('updateSuburb', $("#${name}_postCode").val());
		--%>
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
