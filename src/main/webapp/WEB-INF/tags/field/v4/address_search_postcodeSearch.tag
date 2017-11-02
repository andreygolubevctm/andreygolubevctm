<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for non standard address"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>
<%@ attribute name="label" required="true" rtexprvalue="true" description="field group's label" %>
              
<form_v2:row label="${label}" className="addressSearchV2 addressSearchV2--postcodeSearch">
  <field_v2:input className="addressSearchV2__inputField" xpath="${xpath}/location" title="postcode" required="${true}" />
  <field_v1:hidden xpath="${xpath}/suburb" defaultValue="" />
  <field_v1:hidden xpath="${xpath}/postcode" defaultValue="" />
  <field_v1:hidden xpath="${xpath}/state" defaultValue="" />
  <div class="addressSearchV2__results"></div>
</form_v2:row>

<script type="text/javascript">
  document.addEventListener("DOMContentLoaded", function() {
    var postcodeSearch = window.meerkat.modules.addressLookupV2.getPostCodeSearch();
    var xpath = '<c:out value="${xpath}" />';
    postcodeSearch.init(xpath);
  });
</script>