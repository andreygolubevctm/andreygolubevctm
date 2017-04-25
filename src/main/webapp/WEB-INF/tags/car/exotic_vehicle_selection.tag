<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
              description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}"/>

<%-- HTML --%>
<form_v2:fieldset legend="Your Car" id="${name}_selection" className="hidden">

    <form_v2:row label="Make" id="${name}_makeRow" className="initial" helpId="3">
        <field_v2:input type="text" xpath="${xpath}_make" required="true" title="make" />
    </form_v2:row>

    <form_v2:row label="Model" id="${name}_modelRow">
        <field_v2:input type="text" xpath="${xpath}_model" required="true" title="model" />
    </form_v2:row>

    <form_v2:row label="Year" id="${name}_yearRow">
        <field_v2:input className="numeric" type="text" xpath="${xpath}_year" required="true" title="year" pattern="[0-9]*" size="4" additionalAttributes=" data-rule-minlength='4' data-rule-number='true' data-msg-number='Year must contain numbers only.'" />
    </form_v2:row>

    <form_v2:row label="Engine Capacity" id="${name}_capacity">
        <field_v2:input className="numeric" type="text" xpath="${xpath}_capacity" required="true" title="capacity" pattern="[0-9]*" additionalAttributes=" data-rule-number='true' data-msg-number='Capacity must contain numbers only.'" />
    </form_v2:row>

    <form_v2:row label="Market value of car" id="${name}_value">
        <field_v2:currency xpath="${xpath}_value"
                           required="true"
                           decimal="${false}"
                           title="The value of the car"
                            />
    </form_v2:row>
</form_v2:fieldset>