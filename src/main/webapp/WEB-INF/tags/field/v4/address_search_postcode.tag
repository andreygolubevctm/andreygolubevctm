<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for non standard address"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true"
              description="field group's xpath" %>

<form_v2:row label="Postcode" className="addressSearchV2 addressSearchV2--postcode">
  <input type="text" class="addressSearchV2__input" />
  <field_v1:hidden className="addressSearchV2__stateValue" xpath="${xpath}/state" />
  <div class="addressSearchV2__buttons addressSearchV2__buttons--hidden">
    <button type="button" class="btn btn-secondary"></button>
    <button type="button" class="btn btn-secondary"></button>
  </div>
</form_v2:row>