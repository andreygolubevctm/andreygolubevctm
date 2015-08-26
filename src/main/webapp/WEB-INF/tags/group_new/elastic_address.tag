<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>
<%@ attribute name="type" required="true" rtexprvalue="true" description="the address type R=Residential P=Postal" %>

<c:set var="isPostal" value="${type eq 'P'}" />

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="postcode" value="${name}_postcode" />
<c:set var="autofilllessSearchXpath" value="${name}" />
<c:set var="address" value="${data.node[xpath]}" />

<%-- Fix PostCode Fields --%>
<c:choose>
	<c:when test="${empty address.postCode and not empty address.nonStdPostCode}">
		<go:setData dataVar="data" value="${address.nonStdPostCode}" xpath="${xpath}/postCode" />
		<c:set var="address" value="${data.node[xpath]}" />
	</c:when>
	<c:when test="${empty address.nonStdPostCode and not empty address.postCode}">
		<go:setData dataVar="data" value="${address.postCode}" xpath="${xpath}/nonStdPostCode" />
		<c:set var="address" value="${data.node[xpath]}" />
	</c:when>
	<c:otherwise></c:otherwise>
</c:choose>

<go:script href="common/javascript/elastic_address.js" marker="js-href"/>

<div class="elasticSearchTypeaheadComponent elasticsearch_container_${name}">
	<form_new:row id="${name}_error_container">
		<div class="error-field"></div>
	</form_new:row>

	<%-- STREET-SEARCH (ELASTIC) --%>
	<!-- Since Chrome now ignores the autofill="off" param we can't have address or street in the name/id of the search field. Thanks Chrome... -->
	<c:set var="fieldXpath" value="${xpath}/autofilllessSearch" />
	<c:set var="fullAddressFieldXpath" value="${xpath}/fullAddress" />
	<%-- Update the search field with the full address xpath value if available --%>
	<c:if test="${not empty data[fullAddressFieldXpath]}">
		<go:setData dataVar="data" xpath="${fieldXpath}" value="${data[fullAddressFieldXpath]}" />
	</c:if>
	<form_new:row fieldXpath="${fieldXpath}" label="Street Address" id="${autofilllessSearchXpath}_autofilllessSearchRow" addForAttr="false">
		<c:set var="placeholder" value="e.g. 5/20 Sample St" />
		<field_new:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-autofilllessSearch show-loading sessioncamexclude" title="the street address" placeHolder="${placeholder}" required="false" additionalAttributes=" data-rule-validAutofilllessSearch='${name}' "/>
	</form_new:row>

	<%-- POSTCODE --%>
	<c:set var="fieldXpath" value="${xpath}/nonStdPostCode" />
	<form_new:row fieldXpath="${fieldXpath}" label="Postcode" id="${name}_postCode_suburb" className="${name}_nonStdFieldRow">
		<field:post_code xpath="${fieldXpath}" required="true" title="postcode" />
	</form_new:row>

	<%-- SUBURB DROPDOWN (populated from postcode) --%>
	<c:set var="fieldXpath" value="${xpath}/suburb" />
	<form_new:row fieldXpath="${fieldXpath}" label="Suburb" className="${name}_nonStdFieldRow">
		<c:choose>
			<c:when test="${not empty address.postCode or not empty address.nonStdPostCode}">
				<sql:query var="result" dataSource="jdbc/ctm">
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
					<select name="${name}_suburb" id="${name}_suburb" class="form-control" data-attach="true" data-rule-validSuburb="${name}">
						<%-- Write the initial "Please select" option --%>
						<option value="">Please select</option>
						<%-- Write the options for each row --%>
						<c:forEach var="row" items="${result.rows}">
							<c:choose>
								<c:when test="${row.suburbSeq == address.suburb || row.suburb == address.suburbName}">
									<option value="${row.suburbSeq}" selected="selected">${row.suburb}</option>
									<%-- Fix Suburb for really old quotes --%>
									<c:if test="${empty address.suburb}">
										<go:setData dataVar="data" value="${row.suburbSeq}" xpath="${xpath}/suburb" />
										<c:set var="address" value="${data.node[xpath]}" />
									</c:if>
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
					<select name="${name}_suburb" id="${name}_suburb" class="form-control" data-attach="true" disabled="disabled" data-rule-validSuburb="${name}">
						<option value=''>Enter Postcode</option>
					</select>
				</div>
			</c:otherwise>
		</c:choose>
	</form_new:row>

	<core:clear />

	<%-- STREET NAME --%>
	<c:set var="fieldXpath" value="${xpath}/nonStdStreet" />
	<form_new:row fieldXpath="${fieldXpath}" label="Street" className="${name}_nonStdFieldRow">
		<field_new:input xpath="${fieldXpath}" title="the street" required="false" className="sessioncamexclude" additionalAttributes=" data-rule-validAddress='${name}' " />
	</form_new:row>

	<%-- STREET NUMBER --%>
	<c:set var="fieldXpath" value="${xpath}/streetNum" />
	<c:set var="streetNoLabel" value="Street No." />
	<c:if test="${isPostal}">
		<c:set var="streetNoLabel" value="${streetNoLabel} or PO Box" />
	</c:if>

	<form_new:row fieldXpath="${fieldXpath}" label="${streetNoLabel}" id="${name}_streetNumRow" className="${name}_nonStdFieldRow">
		<div class="${name}_streetNum_container">
			<c:choose>
				<c:when test="${isPostal}">
					<field_new:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-streetNum blur-on-select show-loading sessioncamexclude" title="the street no." includeInForm="true" required="false"  />
				</c:when>
				<c:otherwise>
					<field_new:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-streetNum blur-on-select show-loading sessioncamexclude" title="the street no." includeInForm="true" required="false" />
				</c:otherwise>
			</c:choose>
		</div>
	</form_new:row>

	<%-- UNIT/SHOP NUMBER (Optional) --%>
	<c:set var="fieldXpath" value="${xpath}/unitShop" />
	<form_new:row fieldXpath="${fieldXpath}" label="Unit/Shop/Level" id="${name}_unitShopRow" className="${name}_nonStdFieldRow">
		<field_new:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-unitShop blur-on-select show-loading sessioncamexclude" title="the unit/shop" includeInForm="true" required="false" />
	</form_new:row>

	<%-- UNIT/SHOP TYPE (Optional) --%>
	<c:set var="unitTypes">=Please choose...,CO=Cottage,DU=Duplex,FA=Factory,HO=House,KI=Kiosk,L=Level,M=Maisonette,MA=Marine Berth,OF=Office,PE=Penthouse,RE=Rear,RO=Room,SH=Shop,ST=Stall,SI=Site,SU=Suite,TO=Townhouse,UN=Unit,VI=Villa,WA=Ward,OT=Other</c:set>
	<c:set var="fieldXpath" value="${xpath}/nonStdUnitType" />
	<form_new:row fieldXpath="${fieldXpath}" label="Unit Type" className="${name}_nonStdFieldRow">
		<field_new:array_select items="${unitTypes}" xpath="${fieldXpath}" title="the unit type" required="false" includeInForm="true" />
	</form_new:row>

	<!-- NON STANDARD CHECKBOX -->
	<c:set var="fieldXpath" value="${xpath}/nonStd" />
	<form_new:row fieldXpath="${fieldXpath}" label="" id="${name}_nonStd_row" className="nonStd">
		<c:set var="unableToFindCheckboxText" value="Tick here if you are unable to find the address" />

		<c:if test="${isPostal}">
			<c:set var="unableToFindCheckboxText" value="${unableToFindCheckboxText} or your address is a PO Box" />
		</c:if>

		<field_new:checkbox xpath="${fieldXpath}" value="Y" title="${unableToFindCheckboxText}" label="true" required="false" />
	</form_new:row>

	<core:clear />

	<!-- HIDDEN FIELDS (Populated in autocomplete.js or elastic_search.js) -->
	<c:set var="errorPlacementSelector" value="#${name}_error_container .error-field" />
	<field:hidden xpath="${xpath}/type" defaultValue="${type}" />
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
	<field_new:validatedHiddenField xpath="${xpath}/suburbName" validationErrorPlacementSelector="${errorPlacementSelector}" required="false" />
	<field_new:validatedHiddenField xpath="${xpath}/postCode" validationErrorPlacementSelector="${errorPlacementSelector}" required="false" attributeInjection="data-rule-validAddress='${name}'" />
	<field:hidden xpath="${xpath}/state" />
</div>

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
</go:script>