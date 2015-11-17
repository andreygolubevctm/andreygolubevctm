<%@ tag description="Additional estimate details fieldset" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_new:fieldset legend="Electricity" className="electricity-details">

    <c:set var="fieldXPath" value="${xpath}/solarPanels" />
    <form_new:row label="Do you have solar panels installed on your property?" fieldXpath="${fieldXPath}" className="clear">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="Y=Yes,N=No"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="if you have solar panels." />
    </form_new:row>

    <form_new:row label="Who is your current provider?" className="clear">
        <c:set var="fieldXPath" value="utilities/estimateDetails/usage/electricity/currentSupplier" />
        <field_new:array_select xpath="${fieldXPath}" required="true"
                                title="your current electricity supplier." items=""
                                extraDataAttributes="data-default='${data[fieldXPath]}'" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/electricity-ussge" />
    <form_new:row label="What level best describes your typical electricity usage?" fieldXpath="${fieldXPath}" className="clear electricity-usage">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="L=Low,M=Med,H=High"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="what level best describes your electricity usage." />
    </form_new:row>

    <form_new:row label="How much is your bill?" className="clear additional-estimate-details-row spend">
    <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                              utilityType="Electricity"
                                                              inputType="spend"
                                                              required="true"
                                                              inputGroupText="$"
                                                              inputGroupTextPosition="left"/>
    </form_new:row>

    <form_new:row label="How many days are in the billing period?" className="clear additional-estimate-details-row days">
        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Electricity"
                                                                  inputType="days"
                                                                  required="true"
                                                                  inputGroupText="days"
                                                                  inputGroupTextPosition="right"/>
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/electricityCharged" />
    <form_new:row label="How are you charged for electricity?" fieldXpath="${fieldXPath}" className="clear additional-estimate-details-row electricity-charged">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="S=Single rate,T=Two rate,M=Time of use"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="how you are charged." />
    </form_new:row>

    <form_new:row label="Standard usage" className="clear usage standard-usage">
    <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                              utilityType="Electricity"
                                                              inputType="peak"
                                                              helpId="536"
                                                              required="true"
                                                              inputGroupText="kWh"
                                                              inputGroupTextPosition="right"/>
    </form_new:row>

    <form_new:row label="Peak usage" className="clear usage peak-usage">
        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Electricity"
                                                                  inputType="peak"
                                                                  required="true"
                                                                  helpId="536"
                                                                  inputGroupText="kWh"
                                                                  inputGroupTextPosition="right"/>
    </form_new:row>

    <form_new:row label="Off-peak usage (if any)" className="clear usage off-peak-usage">
        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Electricity"
                                                                  inputType="offpeak"
                                                                  required="true"
                                                                  helpId="537"
                                                                  inputGroupText="kWh"
                                                                  inputGroupTextPosition="right"/>
    </form_new:row>

    <form_new:row label="Controlled Load" className="clear usage controlled-usage">
    <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                              utilityType="Electricity"
                                                              inputType="controlled"
                                                              required="false"
                                                              inputGroupText="kWh"
                                                              inputGroupTextPosition="right"/>
    </form_new:row>

    <form_new:row label="Shoulder usage (if any)" className="clear usage shoulder-usage">
        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Electricity"
                                                                  inputType="shoulder"
                                                                  required="false"
                                                                  inputGroupText="kWh"
                                                                  inputGroupTextPosition="right"/>
    </form_new:row>

</form_new:fieldset>

<form_new:fieldset legend="Gas" className="gas-details">

    <form_new:row label="Who is your current provider?" className="clear">
        <c:set var="fieldXPath" value="utilities/estimateDetails/usage/gas/currentSupplier" />
        <field_new:array_select xpath="${fieldXPath}" required="true"
                                title="your current gas supplier." items=""
                                extraDataAttributes="data-default='${data[fieldXPath]}'" />
    </form_new:row>

    <c:set var="fieldXPath" value="${xpath}/gas-ussge" />
    <form_new:row label="What level best describes your typical gas usage?" fieldXpath="${fieldXPath}" className="clear gas-usage">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="L=<h1>Low</h1><span>1 to 2 people</span>,M=Med,H=High"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="what level best describes your gas usage." />
    </form_new:row>

    <form_new:row label="How much do you usually spend?" className="clear additional-estimate-details-row spend">
        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Gas"
                                                                  inputType="spend"
                                                                  required="true"
                                                                  inputGroupText="$"
                                                                  inputGroupTextPosition="left"/>
    </form_new:row>

    <form_new:row label="How many days are in the billing period?" className="clear additional-estimate-details-row days">
        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Gas"
                                                                  inputType="days"
                                                                  required="true"
                                                                  inputGroupText="days"
                                                                  inputGroupTextPosition="right"/>
    </form_new:row>

    <form_new:row label="Standard usage (peak/anytime)" className="clear additional-estimate-details-row usage">
        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Gas"
                                                                  inputType="peak"
                                                                  helpId="538"
                                                                  required="true"
                                                                  inputGroupText="MJ"
                                                                  inputGroupTextPosition="right"/>
    </form_new:row>

    <form_new:row label="Off-peak usage (if any)" className="clear additional-estimate-details-row usage">

        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Gas"
                                                                  inputType="offpeak"
                                                                  helpId="539"
                                                                  required="false"
                                                                  inputGroupText="MJ"
                                                                  inputGroupTextPosition="right"/>
    </form_new:row>

</form_new:fieldset>

