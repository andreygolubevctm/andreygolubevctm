<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for non standard address"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true"
              description="field group's xpath" %>

<div class="addressSearchV2 addressSearchV2--smartSearch">
  <form_v2:row label="Postcode" className="addressSearchV2 addressSearchV2--postcode">
  </form_v2:row>
  <form_v2:row label="Street Address" className="addressSearchV2 addressSearchV2--postcode">
  </form_v2:row>
</div>
