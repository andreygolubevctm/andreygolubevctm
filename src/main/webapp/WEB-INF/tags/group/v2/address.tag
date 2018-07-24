<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for non standard address"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="type" 		required="true"	 rtexprvalue="true"	 description="the address type R=Residential P=Postal" %>
<%@ attribute name="showTitle"	required="false" rtexprvalue="true"	 description="true/false to show the main title" %>
<%@ attribute name="stateValidationField"		required="false" rtexprvalue="true"	 description="true/false to show the main title" %>
<%@ attribute name="disableErrorContainer" 	required="false" 	rtexprvalue="true"    	 description="Show or hide the error message container" %>
<%@ attribute name="nonStdStreetAdditionalAttributes" required="false" rtexprvalue="true" description="Used for passing in additional attributes" %>


<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="postcode" 		value="${name}_postcode" />
<c:set var="streetSearch" 	value="${name}_streetSearch" />
<c:set var="address" 		value="${data.node[xpath]}" />

<c:set var="isPostalAddress" value="${type == 'P'}" />
<c:set var="isResidentialAddress" value="${type == 'R'}" />

<c:set var="unitTypes">=Select unit type if applicable,UN=Unit</c:set>
<c:if test="${!isResidentialAddress}">
	<c:set var="unitTypes">${unitTypes},PO=PO Box</c:set>
</c:if>
<c:set var="unitTypes">${unitTypes},L=Level,TO=Townhouse,SH=Shop,OT=Other</c:set>


<%-- HTML --%>
<go:script href="common/javascript/legacy_address.js" marker="js-href"/>

<c:if test="${empty showTitle or showTitle == 'true'}">
	<form_v2:row fieldXpath="${fieldXpath}" labelTag="h5" label="${isPostalAddress? 'Postal' : 'Residential'} Address" id="22" className="addressHeading" hideHelpIconCol="true"></form_v2:row>
</c:if>

<field_v1:hidden xpath="${xpath}/elasticSearch" defaultValue="N" />
<field_v1:hidden xpath="${xpath}/type" defaultValue="${type}" />

<%-- POSTCODE --%>
<c:set var="fieldXpath" value="${xpath}/postCode" />
<form_v2:row fieldXpath="${fieldXpath}" label="Postcode" id="${name}_postCode_suburb" smRowOverride="5" hideHelpIconCol="${true}">
	<field_v1:post_code xpath="${fieldXpath}" required="true" title="postcode" additionalAttributes=" data-rule-validAddress='${name}' data-msg-validAddress='Please enter a valid postcode' data-validation-position='append' autocomplete='no' " disableErrorContainer="${disableErrorContainer}" />
</form_v2:row>
<core_v1:clear />

<div class="${name}_non_standard_container">
	<%-- UNIT TYPE --%>
	<c:set var="fieldXpath" value="${xpath}/unitType" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Unit Type" className="${name}_nonStd_street ${name}_unitShopRow" smRowOverride="5" hideHelpIconCol="${true}">
		<field_v2:array_select items="${unitTypes}" xpath="${fieldXpath}" title="the unit type" required="false" includeInForm="true" placeHolder="Unit Type" extraDataAttributes="data-validation-position='append'" />
	</form_v2:row>

	<%-- UNIT/SHOP (BOTH STD & NON STD) --%>
	<c:set var="fieldXpath" value="${xpath}/unitShop" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Unit/Shop/Level Number" id="${name}_unitShopRow" className="std_streetUnitShop ${name}_unitShopRow" smRowOverride="5" hideHelpIconCol="${true}">
		<field_v2:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-unitShop blur-on-select show-loading sessioncamexclude" title="the unit/shop" includeInForm="true" required="false" placeHolder="Enter unit number if applicable e.g. 3" additionalAttributes="data-msg-required='Please enter a Unit number'  data-validation-position='append' " />
	</form_v2:row>

	<%-- STREET NUM --%>
	<c:set var="fieldXpath" value="${xpath}/streetNum" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Street Number" id="${name}_streetNumRow" className="std_streetNum" smRowOverride="5" hideHelpIconCol="${true}">
		<div class="${name}_streetNum_container">
			<field_v2:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-streetNum blur-on-select show-loading sessioncamexclude" title="the street number" includeInForm="true" required="true" placeHolder="Enter street number e.g. 66" additionalAttributes="data-msg-required='Please enter a street number' data-validation-position='append' " />
		</div>
	</form_v2:row>

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
	<form_v2:row fieldXpath="${fieldXpath}" label="Street Name" className="${name}_nonStd_street" smRowOverride="5" hideHelpIconCol="${true}">
		<field_v2:input xpath="${fieldXpath}" title="the street" required="false" className="sessioncamexclude" placeHolder="Enter street name e.g. Smith Street" additionalAttributes="data-rule-validAddress='${name}' data-msg-validAddress='${nonStdStreetMessage}'${nonStdStreetAdditionalAttributes} data-rule-regex='[a-zA-Z0-9 ]+' data-msg-regex='Street name may only contain letters and numbers' data-validation-position='append' " disableErrorContainer="${false}" maxlength="32" />
	</form_v2:row>
</div>

<%-- ADDRESS LABEL AND TITLES --%>
<c:set var="addressLabel" value="Street Address" />
<c:set var="addressTitle" value="the street address" />
<c:if test="${isPostalAddress}">
	<c:set var="addressLabel" value="Postal Address" />
	<c:set var="addressTitle" value="the postal address" />
</c:if>

<%-- STREET-SEARCH --%>
<c:set var="fieldXpath" value="${xpath}/streetSearch" />
<form_v2:row fieldXpath="${fieldXpath}" label="${addressLabel}" id="${name}_std_street" className="std_street">
	<field_v2:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-streetSearch show-loading sessioncamexclude" title="${addressTitle}" placeHolder="${placeholder}" required="false" additionalAttributes=" data-rule-validAddress='${name}' data-msg-validAddress='We can&#39;t seem to find that address&#46;<br /><br />Let&#39;s try again&#58; Please start typing your street address and then select your address from our drop-down box&#46;<br /><br />If you cannot find your address in our drop down&#44; please tick the &#39;Unable to find the address&#39; checkbox to manually enter your address&#46;' autocomplete='no' "  disableErrorContainer="${disableErrorContainer}"/>
</form_v2:row>

<div class="${name}_non_standard_container">
	<%-- SUBURB DROPDOWN (NON STD) --%>
	<c:set var="fieldXpath" value="${xpath}/suburb" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Suburb" className="${name}_nonStd_street" smRowOverride="5" hideHelpIconCol="${true}">
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
					<select name="${name}_suburb" id="${name}_suburb" title="the suburb" class="form-control" data-attach="true" data-rule-validSuburb="${name}" data-msg-validSuburb="Please select a suburb" <c:if test="${disableErrorContainer eq true}"> data-disable-error-container='true'</c:if> data-validation-position='append'>
						<%-- Write the initial "Please select" option --%>
						<option value="">Select suburb</option>
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
					<select name="${name}_suburb" id="${name}_suburb" title="the suburb" class="form-control" data-msg-required="Please select a suburb" data-attach="true" disabled="disabled" data-rule-validSuburb="${name}" data-msg-validSuburb="Please select a suburb" data-validation-position="append">
						<option value=''>Enter Postcode</option>
					</select>
				</div>
			</c:otherwise>
		</c:choose>
	</form_v2:row>
</div>

<c:choose>
	<c:when test="${pageSettings.getVerticalCode() eq 'health' and isPostalAddress}">
		<c:set var="nonStdPostalMessage" value="Tick here if you are unable to find the address or would like to enter a PO Box address" />
	</c:when>
	<c:otherwise>
		<c:set var="nonStdPostalMessage" value="Tick here if you are unable to find the address" />
	</c:otherwise>
</c:choose>

<c:set var="fieldXpath" value="${xpath}/nonStd" />
<form_v2:row fieldXpath="${fieldXpath}" label="" id="${name}_nonStd_row" className="nonStd">
	<field_v2:checkbox xpath="${fieldXpath}" value="Y" title="${nonStdPostalMessage}" label="true" required="false" customAttribute=" data-rule-validAddress='${name}' data-msg-validAddress='Please enter the address'" />
</form_v2:row>

<field_v1:hidden xpath="${xpath}/lastSearch" />
<field_v1:hidden xpath="${xpath}/streetId" />
<field_v1:hidden xpath="${xpath}/houseNoSel" />
<field_v1:hidden xpath="${xpath}/unitSel" />
<field_v1:hidden xpath="${xpath}/streetName" />
<field_v1:hidden xpath="${xpath}/suburbName" />
<c:choose>
	<c:when test="${not empty stateValidationField}">
		<field_v2:validatedHiddenField xpath="${xpath}/state" validationErrorPlacementSelector="${stateValidationField}" additionalAttributes=" required data-rule-matchStates='true' " />
	</c:when>
	<c:otherwise>
		<field_v1:hidden xpath="${xpath}/state" />
	</c:otherwise>
</c:choose>
<field_v1:hidden xpath="${xpath}/dpId" />
<field_v1:hidden xpath="${xpath}/fullAddressLineOne" />
<field_v1:hidden xpath="${xpath}/fullAddress" />

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
