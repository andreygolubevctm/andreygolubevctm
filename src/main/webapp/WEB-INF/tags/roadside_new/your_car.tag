<%@ tag description="Your Car Fieldset" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}"/>
<c:set var="name" value="${go:nameFromXpath(xpath)}"/>

<form_new:fieldset legend="Please tell us about your car" id="${name}_sel ection">

    <c:set var="fieldXpath" value="${xpath}/vehicle/year"/>
    <form_new:row label="Year of manufacture">
        <c:set var="yearsList"><roadside_new:create_years /></c:set>
        <field_new:array_select xpath="${fieldXpath}" required="true" title=" the vehicle's year" items="${yearsList}" />
        <field:hidden xpath="${xpath}/vehicle/registrationYear"></field:hidden>
    </form_new:row>

    <c:set var="fieldXpath" value="${xpath}/vehicle/make"/>
    <form_new:row label="Make of car" fieldXpath="${fieldXpath}">
        <field_new:array_select xpath="${fieldXpath}" required="true" title=" the vehicle's manufacturer" items="" />
        <field:hidden xpath="${fieldXpath}Des"></field:hidden>
    </form_new:row>

    <c:set var="fieldXpath" value="${xpath}/vehicle/vehicle/commercial"/>
    <form_new:row label="Is the car used for private and commuting purposes only? (i.e. not commercial business use)" fieldXpath="${fieldXpath}" helpId="201">
        <%-- THESE VALUES ARE  REVERSED AS THE API USES "COMMERCIAL" INSTEAD OF PRIVATE USE --%>
        <field_new:array_radio xpath="${fieldXpath}" required="true"
                               className="" items="N=Yes,Y=No"
                               title="if the car is used for private and commuting purposes only"/>
    </form_new:row>

    <c:set var="fieldXpath" value="${xpath}/vehicle/vehicle/odometer"/>
    <form_new:row label="Does the car have less than 250,000 kms on the odometer?" helpId="202">
        <%-- THESE VALUES ARE  REVERSED AS THE API USES "COMMERCIAL" INSTEAD OF PRIVATE USE --%>
        <field_new:array_radio xpath="${fieldXpath}" required="true"
                               items="N=Yes,Y=No"
                               title="if the car has less than 250,000 kms on the odometer"/>
    </form_new:row>

    <c:set var="fieldXpath" value="${xpath}/riskAddress/state"/>
    <form_new:row label="In which state do you use your car?">
        <field_new:array_select xpath="${fieldXpath}" required="true" title=" the state you use your car in" items="=Please choose...,ACT=ACT,NSW=NSW,NT=NT,QLD=QLD,SA=SA,TAS=TAS,VIC=VIC,WA=WA" />
    </form_new:row>

</form_new:fieldset>