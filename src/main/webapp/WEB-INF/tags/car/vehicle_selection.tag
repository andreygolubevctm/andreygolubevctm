<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
              description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}"/>

<%-- HTML --%>
<ui:bubble variant="chatty">
    <h4>Tell us about your car</h4>
    <p>Answering these questions will help us supply you with car insurance quotes from our participating suppliers.</p>
</ui:bubble>
<form_v2:fieldset legend="Your Car" id="${name}_selection">

    <c:if test="${not empty param.quote_vehicle_searchRego and not empty param.quote_vehicle_searchState}">
        <div id="unableToFindRego" class="hidden">
            <p>Sorry, your car cannot be matched using the registration provided</p>
            <p><em>Please select you car below</em></p>
            <br /><br />
        </div>
        <field_v1:hidden xpath="${xpath}/nvicCode" />
    </c:if>


    <c:set var="analAttribute"><field_v1:analytics_attr analVal="Car Make" quoteChar="\"" /></c:set>
    <c:set var="analAttributeTT"><field_v1:analytics_attr analVal="Car Make Tooltip" quoteChar="\"" /></c:set>
    <form_v2:row label="Make" id="${name}_makeRow" className="initial" helpId="3" tooltipAttributes="${analAttributeTT}">
        <field_v2:general_select xpath="${xpath}/make" title="vehicle manufacturer" required="true" initialText="&nbsp;" additionalAttributes="${analAttribute}"/>
        <field_v1:hidden xpath="${xpath}/makeDes"></field_v1:hidden>
    </form_v2:row>

    <form_v2:row label="Model" id="${name}_modelRow">
        <c:set var="analAttribute"><field_v1:analytics_attr analVal="Car Model" quoteChar="\"" /></c:set>
        <field_v2:general_select xpath="${xpath}/model" title="vehicle model" required="true" initialText="&nbsp;" additionalAttributes="${analAttribute}"/>
        <field_v1:hidden xpath="${xpath}/modelDes"></field_v1:hidden>
    </form_v2:row>

    <form_v2:row label="Year" id="${name}_yearRow">
        <c:set var="analAttribute"><field_v1:analytics_attr analVal="Car Year" quoteChar="\"" /></c:set>
        <field_v2:general_select xpath="${xpath}/year" title="vehicle year" required="true" initialText="&nbsp;" additionalAttributes="${analAttribute}"/>
        <field_v1:hidden xpath="${xpath}/registrationYear"></field_v1:hidden>
    </form_v2:row>

    <form_v2:row label="Body" id="${name}_bodyRow" className="hidden">
        <c:set var="analAttribute"><field_v1:analytics_attr analVal="Car Body" quoteChar="\"" /></c:set>
        <field_v2:general_select xpath="${xpath}/body" title="vehicle body" required="true" initialText="&nbsp;" additionalAttributes="${analAttribute}"/>
    </form_v2:row>

    <form_v2:row label="Transmission" id="${name}_transRow" className="hidden">
        <c:set var="analAttribute"><field_v1:analytics_attr analVal="Car Transmission" quoteChar="\"" /></c:set>
        <field_v2:general_select xpath="${xpath}/trans" title="vehicle transmission" required="true" initialText="&nbsp;" additionalAttributes="${analAttribute}"/>
    </form_v2:row>

    <form_v2:row label="Fuel" id="${name}_fuelRow" className="hidden">
        <c:set var="analAttribute"><field_v1:analytics_attr analVal="Car Fuel Type" quoteChar="\"" /></c:set>
        <field_v2:general_select xpath="${xpath}/fuel" title="fuel type" required="true" initialText="&nbsp;" additionalAttributes="${analAttribute}"/>
    </form_v2:row>

    <form_v2:row label="Type" id="${name}_redbookCodeRow" className="${name}_redbookCodeRow hidden">
        <c:set var="analAttribute"><field_v1:analytics_attr analVal="Car Body Type" quoteChar="\"" /></c:set>
        <field_v2:general_select xpath="${xpath}/redbookCode" title="vehicle type" required="true" className="vehicleDes" initialText="&nbsp;" additionalAttributes="${analAttribute}"/>
        <field_v1:hidden xpath="${xpath}/marketValue"></field_v1:hidden>
        <field_v1:hidden xpath="${xpath}/variant"></field_v1:hidden>
    </form_v2:row>

    <form_v2:row label="What is the colour of the car?" id="${name}_colourRow" className="hidden">
        <c:set var="analAttribute"><field_v1:analytics_attr analVal="Car Colour" quoteChar="\"" /></c:set>
        <field_v2:general_select xpath="${xpath}/colour" title="colour" required="true" initialText="&nbsp;" additionalAttributes="${analAttribute}"/>
    </form_v2:row>
</form_v2:fieldset>
