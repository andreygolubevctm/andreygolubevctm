<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldGroupLabel">
    <c:choose>
        <c:when test="${addressFormSplitTest eq true}">
            <c:out value="Where is the car parked at night"/>
        </c:when>
        <c:otherwise>
            <c:out value="Address"/>
        </c:otherwise>
    </c:choose>
</c:set>

<%-- HTML --%>
<form_new:fieldset legend="${fieldGroupLabel}" id="${name}FieldSet">

    <c:if test="${addressFormSplitTest eq true}">
        <form_new:row label="Where is the car kept at night" helpId="7">
            <field_new:import_select xpath="quote/vehicle/parking"
                                     url="/WEB-INF/option_data/parking_location.html"
                                     title="the location where the car is parked at night"
                                     className="parking_location"
                                     required="true" />
        </form_new:row>
    </c:if>

    <group_new:elastic_address xpath="${xpath}" type="R" />

    <c:if test="${addressFormSplitTest eq false}">
        <form_new:row label="Where is the car parked at night" helpId="7">
            <field_new:import_select xpath="quote/vehicle/parking"
                                     url="/WEB-INF/option_data/parking_location.html"
                                     title="the location where the car is parked at night"
                                     className="parking_location"
                                     required="true" />
        </form_new:row>
    </c:if>

</form_new:fieldset>