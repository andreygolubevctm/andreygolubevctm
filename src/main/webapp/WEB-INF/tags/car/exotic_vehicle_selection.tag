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
        <field_v2:input type="text" xpath="${xpath}_year" required="true" title="year" pattern="[0-9]*" size="4" additionalAttributes=" data-rule-minlength='4'" />
    </form_v2:row>
    <!--<input type="${inputType}" ${requiredAttribute} name="${name}" pattern="[0-9]*" maxlength="4" id="${name}" class="form-control ${className}" value="${value}" size="4" data-rule-minlength="4" data-msg-minlength="Postcode should be 4 characters long" data-rule-number="true" data-msg-number="Postcode must contain numbers only." ${additionalAttributes} placeholder="PostCode" />-->


    <form_v2:row label="Engine Capacity" id="${name}_capacity">
        <field_v2:currency xpath="${xpath}_capacity"
                           required="true"
                           pattern="[0-9]*"
                           decimal="${true}"
                           nbDecimals="1"
                           title="The engine capacity of the car"/>
    </form_v2:row>

    <form_v2:row label="Value of the Car" id="${name}_value">
        <field_v2:currency xpath="${xpath}_value"
                           required="true"
                           pattern="[0-9]*"
                           decimal="${false}"
                           title="The value of the car"/>
    </form_v2:row>

</form_v2:fieldset>
