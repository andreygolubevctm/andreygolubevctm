<%@ tag import="java.util.GregorianCalendar" %>
<%@ tag description="Utilities Household Details Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="now_Date" pattern="yyyy-MM-dd" value="${now}" />

<fmt:setLocale value="en_AU" scope="session" />

<jsp:useBean id="nowPlusDay" class="java.util.GregorianCalendar" />
<% nowPlusDay.add(GregorianCalendar.DAY_OF_YEAR, 1); %>
<fmt:formatDate var="nowPlusDay_Date" pattern="yyyy-MM-dd" value="${nowPlusDay.time}" />

<c:if test="${param.preload eq 'true'}">
    <fmt:formatDate var="movingInDate" pattern="dd/MM/yyyy" value="${nowPlusDay.time}" />
    <go:setData dataVar="data" xpath="${xpath}/movingInDate" value="${movingInDate}" />
</c:if>

<form_new:fieldset legend="Household Details" className="household-details">
    <c:set var="fieldXPath" value="${xpath}/location" />
    <form_new:row label="Postcode / Suburb" fieldXpath="${fieldXPath}" className="clear">
        <field_new:lookup_suburb_postcode xpath="${fieldXPath}" placeholder="Your postcode / suburb." required="true" />

        <field:hidden xpath="${xpath}/postcode" defaultValue="N" />
        <field:hidden xpath="${xpath}/suburb" defaultValue="N" />
        <field:hidden xpath="${xpath}/state" defaultValue="N" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/movingIn" />
    <form_new:row label="Are you moving to this property?" fieldXpath="${fieldXPath}" className="clear moving-in" helpId="413">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="Y=Yes,N=No"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="if you are moving to this property." />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/movingInDate" />
    <form_new:row label="What date are you moving in?" fieldXpath="${fieldXPath}" className="clear moving-in-date">
        <field_new:basic_date xpath="${fieldXPath}"
                              required="true"
                              title="moving in date"
                              minDate="${nowPlusDay_Date}" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/whatToCompare" />
    <form_new:row label="What would you like to compare?" fieldXpath="${fieldXPath}" className="clear" helpId="528">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className="what-to-compare"
                               items="E=Electricity,G=Gas,EG=Electricity and Gas"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="which energies to compare." />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/howToEstimate" />
    <form_new:row label="Would you like us to estimate how much energy you use?" fieldXpath="${fieldXPath}" className="clear" helpId="526">
        <field_new:array_select xpath="${fieldXPath}"
                                required="true"
                                className="how-to-estimate"
                                title="how to estimate how much energy you use."
                                items="=Please choose...,S=Yes - Use my $ spend to work out my usage,U=No&nbsp;&nbsp;&nbsp;- I will enter my usage in kWh/MJ from a recent bill(s)" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/solarPanels" />
    <form_new:row label="Do you have solar panels installed on your property?" fieldXpath="${fieldXPath}" className="clear">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="Y=Yes,N=No"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="if you have solar panels." />
    </form_new:row>

    <field:hidden xpath="${xpath}/tariff" required="false" />
</form_new:fieldset>