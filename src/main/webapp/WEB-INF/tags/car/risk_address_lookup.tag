<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_v2:fieldset legend="Address" id="${name}FieldSet">

    <group_v2:elastic_address xpath="${xpath}" type="R" />

    <form_v2:row label="Where is the car parked at night" helpId="7">
        <field_v2:import_select xpath="quote/vehicle/parking"
                                 url="/WEB-INF/option_data/parking_location.html"
                                 title="the location where the car is parked at night"
                                 className="parking_location"
                                 required="true" />
    </form_v2:row>

</form_v2:fieldset>