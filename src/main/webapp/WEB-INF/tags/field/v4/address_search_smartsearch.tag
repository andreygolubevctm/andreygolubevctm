<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Smart Search"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true"
              description="field group's xpath" %>
              
<%@ attribute name="prefix" required="true" rtexprvalue="true" description="Used for passing in additional attributes" %>
<%@ attribute name="className" required="false" rtexprvalue="true" description="Used for passing in additional attributes" %>
<%@ attribute name="unitTypes" required="true" rtexprvalue="true" description="Unit Type" %>

<div class="addressSearchV2 addressSearchV2--${prefix} addressSearchV2--${className}">
  <form_v2:row fieldXpath="${fieldXpath}" labelTag="h5" label="${prefix} Address" className="addressHeading" hideHelpIconCol="true"></form_v2:row>
  
  <%-- Postcode --%>
  <form_v2:row label="Postcode" className="addressSearchV2__postcodeSearch">
    <field_v2:input xpath="${xpath}/postCode" minlength="4" maxlength="4" formattedInteger="true" required="true" title="postcode" additionalAttributes=" data-rule-validAddress='' data-msg-validAddress='Please enter a valid postcode' data-validation-position='append'" pattern="[0-9]{4}" disableErrorContainer="${false}" />
    <field_v1:hidden className="addressSearchV2__lastPostcodeSearch" xpath="${xpath}/lastpostcodeSearch" />
  </form_v2:row>
  
  <%-- Street Search --%>
  <form_v2:row label="Street Address" className="addressSearchV2__searchContainer">
    <field_v2:input xpath="${xpath}/fullAddressLineOne" required="true" title="postcode" additionalAttributes="autocomplete='off' data-rule-validAddress='' data-msg-validAddress='Please enter a valid postcode' data-validation-position='append'" disableErrorContainer="${false}" />
    <div class="addressSearchV2__results"></div>
  </form_v2:row>
  <field_v1:hidden xpath="${xpath}/streetName" />
  <field_v1:hidden xpath="${xpath}/state" />
  <field_v1:hidden xpath="${xpath}/gnafid" />
  
  <div class="addressSearchV2__cantFindFields addressSearchV2__cantFindFields--hidden">
    <%-- Unit Type  --%>
    
    <form_v2:row fieldXpath="${xpath}" label="Unit Type">
      <field_v2:array_select items="${unitTypes}" xpath="${xpath}/unitType" title="the unit type" required="false" includeInForm="true" placeHolder="Unit Type" extraDataAttributes="data-validation-position='append'" />
    </form_v2:row>
    
    <%-- Unit No  --%>
    <form_v2:row fieldXpath="${xpath}" label="Unit/Shop/Level Number">
      <field_v2:input xpath="${xpath}/unitShop" className="typeahead typeahead-address typeahead-unitShop blur-on-select show-loading sessioncamexclude" title="the unit/shop" includeInForm="true" required="false" placeHolder="Enter unit number if applicable e.g. 3" additionalAttributes="data-msg-required='Please enter a Unit number'  data-validation-position='append' " />
    </form_v2:row>
    
    <%-- Street No.  --%>
    <form_v2:row fieldXpath="${xpath}" label="Street Number">
      <field_v2:input xpath="${xpath}/streetNum" className="typeahead typeahead-address typeahead-streetNum blur-on-select show-loading sessioncamexclude" title="the street number" includeInForm="true" required="true" placeHolder="Enter street number e.g. 66" additionalAttributes="data-msg-required='Please enter a street number' data-validation-position='append' " />
    </form_v2:row>
      
    <%-- Street --%>
    <form_v2:row fieldXpath="${xpath}" label="Street Name">
      <field_v2:input xpath="${xpath}/nonStdStreet" title="the street" required="false" className="sessioncamexclude" placeHolder="Enter street name e.g. Smith Street" additionalAttributes="data-rule-validAddress='' data-msg-validAddress='Please enter the street' data-rule-regex='[a-zA-Z0-9 ]+' data-msg-regex='Street Name may only contain letters and numbers' data-validation-position='append' " disableErrorContainer="${false}" maxlength="32" />
    </form_v2:row>
    
    <%-- Suburb --%>
    <c:set var="postCode">=Enter Postcode</c:set>
    <form_v2:row fieldXpath="${xpath}" label="Suburb" className="addressSearchV2__suburbSelect">
      <field_v2:array_select items="${postCode}" xpath="${xpath}/suburb" title="the unit type" required="true" includeInForm="true"  placeHolder="Enter Postcode" extraDataAttributes="data-validation-position='append'" />
    </form_v2:row>
  </div>

  
  <form_v2:row className="addressSearchV2__checkbox checkbox">
    <input type="checkbox" name="hide_search_field_${prefix}" id="hide_search_field_${prefix}" />
    <label for="hide_search_field_${prefix}">Tick here if you are unable to find the address</label>
  </form_v2:row>
</div>
