<%@ tag description="Fuel Location"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="xpath" %>

<form_new:row label="Postcode / Suburb">
    <field_new:lookup_suburb_postcode xpath="${xpath}/location" placeholder="Postcode / Suburb" required="true" />
</form_new:row>


<go:validate selector="${xpath}_location" rule="validateLocation" parm="true" message="Please select a valid postcode to compare fuel" />