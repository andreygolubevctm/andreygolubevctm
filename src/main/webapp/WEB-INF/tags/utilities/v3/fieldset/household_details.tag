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

<% nowPlusDay.add(GregorianCalendar.YEAR, 5); %>
<fmt:formatDate var="nowPlusYears_Date" pattern="yyyy-MM-dd" value="${nowPlusDay.time}" />

<form_v2:fieldset legend="Household Details" className="household-details">
    <c:set var="fieldXPath" value="${xpath}/location" />
    <form_v3:row label="Postcode / Suburb" fieldXpath="${fieldXPath}" className="clear">
        <%-- Uses autocomplete='false' instead of 'off' due to Chrome bug https://code.google.com/p/chromium/issues/detail?id=468153 --%>
        <field_v2:lookup_suburb_postcode
                xpath="${fieldXPath}"
                placeholder="Your postcode / suburb."
                required="true"
                extraDataAttributes=" data-rule-validateLocation='true' data-msg-validateLocation='Please select a valid location' autocomplete='false'" />

        <field_v1:hidden xpath="${xpath}/postcode" defaultValue="N" />
        <field_v1:hidden xpath="${xpath}/suburb" defaultValue="N" />
        <field_v1:hidden xpath="${xpath}/state" defaultValue="N" />
    </form_v3:row>

    <c:set var="fieldXPath" value="${xpath}/whatToCompare" />
    <form_v3:row label="What would you like to compare?" fieldXpath="${fieldXPath}" className="clear" helpId="528">
        <field_v2:array_radio xpath="${fieldXPath}"
                               required="true"
                               className="what-to-compare roundedCheckboxIcons"
                               items="E=Electricity,G=Gas,EG=Electricity and Gas"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="which energies to compare." />
    </form_v3:row>

    <c:set var="fieldXPath" value="${xpath}/movingIn" />
    <form_v3:row label="Are you moving to this property?" fieldXpath="${fieldXPath}" className="clear moving-in" helpId="413">
        <field_v2:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="Y=Yes,N=No"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="if you are moving to this property." />
    </form_v3:row>

    <c:set var="fieldXPath" value="${xpath}/movingInDate" />
    <form_v3:row label="What date are you moving in?" fieldXpath="${fieldXPath}" className="clear moving-in-date">
        <field_v2:basic_date xpath="${fieldXPath}"
                              required="true"
                              title="moving in date"
                              maxDate="${nowPlusYears_Date}"
                              minDate="${nowPlusDay_Date}" />
    </form_v3:row>

    <c:set var="fieldXPath" value="${xpath}/recentElectricityBill" />
    <form_v3:row label="Do you have a recent electricity bill in front of you?" fieldXpath="${fieldXPath}" className="clear recent-electricity-bill">
        <field_v2:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="Y=Yes,N=No"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="if you have a recent electricity bill." />
    </form_v3:row>

    <c:set var="fieldXPath" value="${xpath}/recentGasBill" />
    <form_v3:row label="Do you have a recent gas bill in front of you?" fieldXpath="${fieldXPath}" className="clear recent-gas-bill">
        <field_v2:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="Y=Yes,N=No"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="if you have a recent gas bill." />
    </form_v3:row>
</form_v2:fieldset>

   <field_v1:hidden xpath="${xpath}/tariff" required="false" />

