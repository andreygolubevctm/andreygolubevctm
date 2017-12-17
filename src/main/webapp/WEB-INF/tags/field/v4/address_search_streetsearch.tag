<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for non standard address"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>


<c:set var="address" value="${data.node[xpath]}"/>
<c:set var="postCode">=Enter Postcode,${address.suburbName}=${address.suburbName}</c:set>

<div class="addressSearchV2 addressSearchV2--street">
  
  <%-- Street Search --%>
  <form_v2:row label="Street Search" className="addressSearchV2__searchContainer">
    <field_v2:input xpath="${xpath}/streetSearch" required="true" title="postcode" additionalAttributes=" data-rule-validAddress='${name}' data-msg-validAddress='Please enter a valid postcode' data-validation-position='append'" disableErrorContainer="${false}" />
    <div class="addressSearchV2__results"></div>
  </form_v2:row>
  <field_v1:hidden xpath="${xpath}/fullAddressLineOne" />
  <field_v1:hidden xpath="${xpath}/state" />
  <field_v1:hidden xpath="${xpath}/suburb" />
  
  <%-- Postcode --%>
  <div class="addressSearchV2__cantFindFields addressSearchV2__cantFindFields--hidden">
    <form_v2:row fieldXpath="${xpath}" label="Postcode" className="addressSearchV2__postcodeSearch">
      <field_v2:input xpath="${xpath}/postCode" required="true" title="postcode" additionalAttributes=" data-rule-validAddress='${name}' data-msg-validAddress='Please enter a valid postcode' data-validation-position='append'" disableErrorContainer="${false}" />
      <field_v1:hidden className="addressSearchV2__lastPostcodeSearch" xpath="${xpath}/lastpostcodeSearch" />
    </form_v2:row>
    
    <%-- Suburb --%>
    <form_v2:row fieldXpath="${xpath}" label="Suburb" className="addressSearchV2__suburbSelect">
      <field_v2:array_select items="${postCode}" xpath="${xpath}/suburbName" title="the unit type" required="true" includeInForm="true"  placeHolder="Enter Postcode" extraDataAttributes="data-validation-position='append'" />
    </form_v2:row>
    
    <%-- Street --%>
    <form_v2:row fieldXpath="${xpath}" label="Street">
      <field_v2:input xpath="${xpath}/streetName" title="the street" required="false" className="sessioncamexclude" placeHolder="Enter street name e.g. Smith Street" additionalAttributes="data-rule-validAddress='${name}' data-msg-validAddress='Please enter the street' data-rule-regex='[a-zA-Z0-9 ]+' data-msg-regex='Street Name may only contain letters and numbers' data-validation-position='append' " disableErrorContainer="${false}" maxlength="32" />
    </form_v2:row>
    
    <%-- Street No.  --%>
    <form_v2:row fieldXpath="${xpath}" label="Street No.">
      <field_v2:input xpath="${xpath}/streetNum" className="typeahead typeahead-address typeahead-streetNum blur-on-select show-loading sessioncamexclude" title="the street number" includeInForm="true" required="true" placeHolder="Enter street number e.g. 66" additionalAttributes="data-msg-required='Please enter a street number' data-validation-position='append' " />
    </form_v2:row>
    
    <%-- Unit No  --%>
    <form_v2:row fieldXpath="${xpath}" label="Unit/Shop/Level">
      <field_v2:input xpath="${xpath}/unitShop" className="typeahead typeahead-address typeahead-unitShop blur-on-select show-loading sessioncamexclude" title="the unit/shop" includeInForm="true" required="false" placeHolder="Enter unit number if applicable e.g. 3" additionalAttributes="data-msg-required='Please enter a Unit number'  data-validation-position='append' " />
    </form_v2:row>
    
    <%-- Unit Type  --%>
    <c:set var="unitTypes">=Please choose...,CO=Cottage,DU=Duplex,FA=Factory,HO=House,KI=Kiosk,L=Level,M=Maisonette,MA=Marine Berth,OF=Office</c:set>
    <c:set var="unitTypes">${unitTypes},PE=Penthouse,RE=Rear,RO=Room,SH=Shop,ST=Stall,SI=Site,SU=Suite,TO=Townhouse,UN=Unit,VI=Villa,WA=Ward</c:set>
    <form_v2:row fieldXpath="${xpath}" label="Unit Type">
      <field_v2:array_select items="${unitTypes}" xpath="${xpath}/unitType" title="the unit type" required="false" includeInForm="true" placeHolder="Unit Type" extraDataAttributes="data-validation-position='append'" />
    </form_v2:row>

  </div>
  <form_v2:row className="addressSearchV2__checkbox checkbox">
    <input type="checkbox" name="hide_search_field" id="hide_search_field" />
    <label for="hide_search_field">Tick here if you are unable to find the address</label>
  </form_v2:row>
</div>
