<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Postcode Search"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>
<%@ attribute name="label" required="true" rtexprvalue="true" description="field group's label" %>
<%@ attribute name="simples" required="false" rtexprvalue="true" description="use form_v3" %>


<c:choose>
  <c:when test="${simples eq true}">
    <form_v3:row label="${label}" className="addressSearchV2 addressSearchV2--postcodeSearch">
      <field_v2:input className="addressSearchV2__inputField" additionalAttributes="autocomplete='off'" xpath="${xpath}/location" title="postcode" required="${true}" />
      <field_v1:hidden xpath="${xpath}/suburb" defaultValue="" />
      <field_v1:hidden xpath="${xpath}/postcode" defaultValue="" />
      <field_v1:hidden xpath="${xpath}/state" defaultValue="" />
      <div class="addressSearchV2__results"></div>
    </form_v3:row>
  </c:when>
  <c:otherwise>
    <form_v2:row label="${label}" className="addressSearchV2 addressSearchV2--postcodeSearch">
      <field_v2:input className="addressSearchV2__inputField" xpath="${xpath}/location" title="postcode" required="${true}" />
      <field_v1:hidden xpath="${xpath}/suburb" defaultValue="" />
      <field_v1:hidden xpath="${xpath}/postcode" defaultValue="" />
      <field_v1:hidden xpath="${xpath}/state" defaultValue="" />
      <div class="addressSearchV2__results"></div>
    </form_v2:row>
  </c:otherwise>
</c:choose>
