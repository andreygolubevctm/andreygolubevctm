<%@ tag description="Fuel Location"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="xpath" %>

<form_v2:row label="Postcode / Suburb">
    <field_v2:lookup_suburb_postcode xpath="${xpath}/location" placeholder="Postcode / Suburb" required="true" extraDataAttributes=" data-rule-validateLocation='true' data-msg-validateLocation='Please select a valid postcode to compare fuel'" />
</form_v2:row>