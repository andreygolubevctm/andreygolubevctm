<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>
<%@ attribute name="type" required="true" rtexprvalue="true" description="the address type R=Residential P=Postal" %>
<%@ attribute name="suburbNameAdditionalAttributes" required="false" rtexprvalue="true" description="Used for passing in additional attributes" %>
<%@ attribute name="suburbAdditionalAttributes" required="false" rtexprvalue="true" description="Used for passing in additional attributes" %>
<%@ attribute name="postCodeNameAdditionalAttributes" required="false" rtexprvalue="true" description="Used for passing in additional attributes" %>
<%@ attribute name="postCodeAdditionalAttributes" required="false" rtexprvalue="true" description="Used for passing in additional attributes" %>
<%@ attribute name="stateValidationField"		required="false" rtexprvalue="true"	 description="true/false to show the main title" %>
<%@ attribute name="disableErrorContainer" 	required="false" 	rtexprvalue="true"    	 description="Show or hide the error message container" %>
<c:set var="isPostal" value="${type eq 'P'}"/>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}"/>
<c:set var="postcode" value="${name}_postcode"/>
<c:set var="autofilllessSearchXpath" value="${name}"/>
<c:set var="address" value="${data.node[xpath]}"/>

<%-- Fix PostCode Fields --%>
<c:choose>
    <c:when test="${empty address.postCode and not empty address.nonStdPostCode}">
        <go:setData dataVar="data" value="${address.nonStdPostCode}" xpath="${xpath}/postCode"/>
        <c:set var="address" value="${data.node[xpath]}"/>
    </c:when>
    <c:when test="${empty address.nonStdPostCode and not empty address.postCode}">
        <go:setData dataVar="data" value="${address.postCode}" xpath="${xpath}/nonStdPostCode"/>
        <c:set var="address" value="${data.node[xpath]}"/>
    </c:when>
    <c:otherwise></c:otherwise>
</c:choose>

<%-- Appears to retrieve the post codes for the dropdown list in nonstd. Moved up higher because its required sooner. --%>
<c:if test="${not empty address.postCode or not empty address.nonStdPostCode}">
    <sql:query var="result" dataSource="${datasource:getDataSource()}">
        SELECT suburb, count(street) as streetCount, suburbSeq, state, street
        FROM aggregator.streets
        WHERE postCode = ?
        GROUP by suburb
        <sql:param>${address.postCode}</sql:param>
    </sql:query>
</c:if>
<%-- Reset the address xpath to add in suburb sequence. This is needed as otherwise the frontend will reset suburbName to empty, which results in no results on Car/Home --%>
<c:forEach var="row" items="${result.rows}">
    <c:if test="${row.suburbSeq == address.suburb || row.suburb == address.suburbName}">
        <c:if test="${empty address.suburb}">
            <go:setData dataVar="data" value="${row.suburbSeq}" xpath="${xpath}/suburb"/>
            <c:set var="address" value="${data.node[xpath]}" />
        </c:if>
    </c:if>
</c:forEach>


<div class="elasticSearchTypeaheadComponent elasticsearch_container_${name}" data-address-id="${name}" data-suburbSeqNo="${address.suburb}" data-search-type="${type}"
     data-address-streetNum="${address.streetNum}" data-address-unitShop="${address.unitShop}">
    <form_v2:row id="${name}_error_container">
        <div class="error-field"></div>
    </form_v2:row>

    <%-- STREET-SEARCH (ELASTIC) --%>
    <!-- Since Chrome now ignores the autofill="off" param we can't have address or street in the name/id of the search field. Thanks Chrome... -->
    <c:set var="fieldXpath" value="${xpath}/autofilllessSearch"/>
    <c:set var="fullAddressFieldXpath" value="${xpath}/fullAddress"/>
    <%-- Update the search field with the full address xpath value if available --%>
    <c:if test="${not empty data[fullAddressFieldXpath]}">
        <go:setData dataVar="data" xpath="${fieldXpath}" value="${data[fullAddressFieldXpath]}"/>
    </c:if>
    <c:set var="addressLabel">
        <c:choose>
            <c:when test="${isPostal eq true}">Postal</c:when>
            <c:otherwise>Street</c:otherwise>
        </c:choose>
    </c:set>
    <form_v2:row fieldXpath="${fieldXpath}" label="${addressLabel} Address" id="${autofilllessSearchXpath}_autofilllessSearchRow" addForAttr="false">
        <c:set var="placeholder" value="e.g. 5/20 Sample St"/>
        <field_v2:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-autofilllessSearch show-loading sessioncamexclude" title="the street address"
                        placeHolder="${placeholder}" required="false"
                        additionalAttributes=" data-rule-validAutofilllessSearch='${name}' data-msg-validAutofilllessSearch='Please select a valid address' " disableErrorContainer="${disableErrorContainer}"/>
    </form_v2:row>

    <%-- POSTCODE --%>
    <form_v2:row label="Postcode" isNestedStyleGroup="${true}" className="${name}_nonStdFieldRow">
        <c:set var="fieldXpath" value="${xpath}/nonStdPostCode"/>
        <form_v2:row fieldXpath="${fieldXpath}" label="Postcode" id="${name}_postCode_suburb" className="${name}_nonStdFieldRow" smRowOverride="5" isNestedField="${true}" hideHelpIconCol="${true}">
            <field_v1:post_code xpath="${fieldXpath}" required="true" title="postcode" additionalAttributes="${postCodeNameAdditionalAttributes}" disableErrorContainer="${disableErrorContainer}" />
        </form_v2:row>

        <%-- SUBURB DROPDOWN (populated from postcode) --%>
        <c:set var="fieldXpath" value="${xpath}/suburb"/>
        <form_v2:row fieldXpath="${fieldXpath}" label="Suburb" className="${name}_nonStdFieldRow" smRowOverride="7" hideHelpIconCol="${true}" isNestedField="${true}">
            <c:choose>
                <c:when test="${not empty address.postCode or not empty address.nonStdPostCode}">
                    <div class="select">
                        <span class=" input-group-addon" data-target="${name}">
                            <i class="icon-angle-down"></i>
                        </span>
                        <select name="${name}_suburb" id="${name}_suburb" class="form-control" data-attach="true" data-rule-validSuburb="${name}" ${suburbNameAdditionalAttributes} <c:if test="${disableErrorContainer eq true}"> data-disable-error-container='true'</c:if>>
                                <%-- Write the initial "Please select" option --%>
                            <option value="">Suburb</option>
                                <%-- Write the options for each row --%>
                            <c:forEach var="row" items="${result.rows}">
                                <c:choose>
                                    <c:when test="${row.suburbSeq == address.suburb || row.suburb == address.suburbName}">
                                        <option value="${row.suburbSeq}" selected="selected">${row.suburb}</option>
                                        <%-- Fix Suburb for really old quotes --%>
                                        <c:if test="${empty address.suburb}">
                                            <go:setData dataVar="data" value="${row.suburbSeq}" xpath="${xpath}/suburb"/>
                                            <c:set var="address" value="${data.node[xpath]}"/>
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
                            <i class="icon-angle-down"></i>
                        </span>
                        <select name="${name}_suburb" id="${name}_suburb" class="form-control" data-attach="true" disabled="disabled" data-rule-validSuburb="${name}" ${suburbNameAdditionalAttributes}>
                            <option value=''>Enter Postcode</option>
                        </select>
                    </div>
                </c:otherwise>
            </c:choose>
        </form_v2:row>
    </form_v2:row>

    <core_v1:clear/>


    <form_v2:row label="Unit / Street Number" isNestedStyleGroup="${true}" className="${name}_nonStdFieldRow">
        <%-- UNIT/SHOP NUMBER (Optional) --%>
        <c:set var="fieldXpath" value="${xpath}/unitShop"/>
        <form_v2:row fieldXpath="${fieldXpath}" label="Unit/Shop/Level" id="${name}_unitShopRow" className="${name}_nonStdFieldRow" smRowOverride="5" isNestedField="${true}" hideHelpIconCol="${true}">
            <field_v2:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-unitShop blur-on-select show-loading sessioncamexclude" title="the unit/shop" includeInForm="true"
                            required="false" placeHolder="Unit/Shop/Level"/>
        </form_v2:row>

        <%-- STREET NUMBER --%>
        <c:set var="fieldXpath" value="${xpath}/streetNum"/>
        <c:set var="streetNoLabel" value="Street No."/>
        <c:if test="${isPostal}">
            <c:set var="streetNoLabel" value="${streetNoLabel} or PO Box"/>
        </c:if>

        <form_v2:row fieldXpath="${fieldXpath}" label="${streetNoLabel}" id="${name}_streetNumRow" className="${name}_nonStdFieldRow" smRowOverride="2"  isNestedField="${true}" hideHelpIconCol="${true}">
            <div class="${name}_streetNum_container">
                <field_v2:input xpath="${fieldXpath}" className="typeahead typeahead-address typeahead-streetNum blur-on-select show-loading sessioncamexclude" title="the street no." includeInForm="true"
                                required="false" additionalAttributes=" data-rule-validAddress='${name}' data-msg-validAddress='Please enter a valid street number'" placeHolder="St. #"/>
            </div>
        </form_v2:row>

        <%-- UNIT/SHOP TYPE (Optional) --%>
        <c:set var="unitTypes">=Please choose...,CO=Cottage,DU=Duplex,FA=Factory,HO=House,KI=Kiosk,L=Level,M=Maisonette,MA=Marine Berth,OF=Office,PE=Penthouse,RE=Rear,RO=Room,SH=Shop,ST=Stall,SI=Site,SU=Suite,TO=Townhouse,UN=Unit,VI=Villa,WA=Ward,OT=Other</c:set>
        <c:set var="fieldXpath" value="${xpath}/nonStdUnitType"/>
        <form_v2:row fieldXpath="${fieldXpath}" label="Unit Type" className="${name}_nonStdFieldRow" smRowOverride="5"  isNestedField="${true}" hideHelpIconCol="${true}">
            <field_v2:array_select items="${unitTypes}" xpath="${fieldXpath}" title="the unit type" required="false" includeInForm="true" placeHolder="Unit Type"/>
        </form_v2:row>
    </form_v2:row>

    <core_v1:clear/>

    <%-- STREET NAME --%>
    <c:set var="fieldXpath" value="${xpath}/nonStdStreet"/>
    <form_v2:row fieldXpath="${fieldXpath}" label="Street" className="${name}_nonStdFieldRow">
        <field_v2:input xpath="${fieldXpath}" title="the street" required="false" className="sessioncamexclude"
                        additionalAttributes=" data-rule-validAddress='${name}' data-rule-validAddress='Please enter the residential street' " disableErrorContainer="${disableErrorContainer}" placeHolder="Street Name"/>
    </form_v2:row>

    <core_v1:clear/>

    <!-- NON STANDARD CHECKBOX -->
    <c:set var="fieldXpath" value="${xpath}/nonStd"/>
    <form_v3:row fieldXpath="${fieldXpath}" label="" className="${name}_nonStd_row nonStd">
        <c:set var="unableToFindCheckboxText" value="Tick here if you are unable to find the address"/>

        <c:if test="${isPostal}">
            <c:set var="unableToFindCheckboxText" value="${unableToFindCheckboxText} or your address is a PO Box"/>
        </c:if>
    </form_v3:row>

    <form_v2:row fieldXpath="${fieldXpath}" label="" className="nonStd">
        <field_v2:checkbox xpath="${fieldXpath}" value="Y" title="${unableToFindCheckboxText}" label="true" required="false"/>
    </form_v2:row>


    <!-- HIDDEN FIELDS (Populated in autocomplete.js or elastic_search.js) -->
    <c:set var="errorPlacementSelector" value="#${name}_error_container .error-field"/>
    <field_v1:hidden xpath="${xpath}/type" defaultValue="${type}"/>
    <field_v1:hidden xpath="${xpath}/elasticSearch" defaultValue="Y"/>
    <field_v1:hidden xpath="${xpath}/lastSearch"/>
    <field_v1:hidden xpath="${xpath}/fullAddressLineOne"/>
    <field_v1:hidden xpath="${xpath}/fullAddress"/>

    <field_v1:hidden xpath="${xpath}/dpId"/>
    <field_v1:hidden xpath="${xpath}/unitType"/>
    <field_v1:hidden xpath="${xpath}/unitSel"/>
    <field_v1:hidden xpath="${xpath}/houseNoSel"/>
    <field_v1:hidden xpath="${xpath}/floorNo"/>
    <field_v1:hidden xpath="${xpath}/streetName"/>
    <field_v1:hidden xpath="${xpath}/streetId"/>
    <field_v2:validatedHiddenField xpath="${xpath}/suburbName" validationErrorPlacementSelector="${errorPlacementSelector}" additionalAttributes="${suburbAdditionalAttributes}"/>
    <field_v2:validatedHiddenField xpath="${xpath}/postCode" validationErrorPlacementSelector="${errorPlacementSelector}"
                                    additionalAttributes="${postCodeAdditionalAttributes} data-rule-validAddress='${name}' data-msg-validAddress='Please enter a valid postcode'"/>

    <c:choose>
        <c:when test="${not empty stateValidationField}">
            <field_v2:validatedHiddenField xpath="${xpath}/state" validationErrorPlacementSelector="${stateValidationField}" additionalAttributes=" required data-rule-matchStates='true' " />
        </c:when>
        <c:otherwise>
            <field_v1:hidden xpath="${xpath}/state" />
        </c:otherwise>
    </c:choose>
</div>