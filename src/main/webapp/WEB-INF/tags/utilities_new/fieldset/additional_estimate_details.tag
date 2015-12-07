<%@ tag description="Additional estimate details fieldset" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_new:fieldset legend="Electricity" className="electricity-details">

    <c:set var="fieldXPath" value="utilities/householdDetails/solarPanels" />
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

    <c:set var="fieldXPath" value="${xpath}/electricity/usage" />
    <form_new:row label="Select the level that best describes your typical electricity usage" fieldXpath="${fieldXPath}" className="clear electricity-usage">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className="col-md-12"
                               items="Low=<h3>Low</h3><span><i class='energy-people-sm'></i>1 - 2 people</span><span><i class='energy-bed-sm'></i>1 - 2 bedrooms</span><span><i class='energy-plug-sm'></i>Weekly laundry. Rarely cook or use heating/cooling</span><span><i class='energy-house-sm'></i>Not home much in day or evenings</span>,Medium=<h3>Medium</h3><span><i class='energy-people-md'></i>3 - 4 people</span><span><i class='energy-bed-md'></i>3 bedrooms</span><span><i class='energy-plug-md'></i>Regular laundry. Rarely cook or use heating/cooling. Use a few appliances</span><span><i class='energy-house-md'></i>Usually at work during the day and kids at school. Home evenings and weekends</span>,High=<h3>High</h3><span><i class='energy-people-hi'></i>4 - 5+ people</span><span><i class='energy-bed-hi'></i>4+ bedrooms</span><span><i class='energy-plug-hi'></i>Daily laundry. Frequent cooking and heating/cooling use. Use multiple appliances</span><span><i class='energy-house-hi'></i>In and out throughout the day. Home evenings and weekends</span>"
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

    <c:set var="fieldXPath" value="${xpath}/electricity/meter" />
    <form_new:row label="How are you charged for electricity?" fieldXpath="${fieldXPath}" className="clear additional-estimate-details-row electricity-meter">
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
                                                              inputType="offpeak"
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

    <c:set var="fieldXPath" value="${xpath}/gas/usage" />
    <form_new:row label="Select the level that best describes your typical gas usage" fieldXpath="${fieldXPath}" className="clear gas-usage">
        <field_new:array_radio xpath="${fieldXPath}"
                               required="true"
                               className="col-md-12"
                               items="Low=<h3>Low</h3><span><i class='energy-people-sm'></i>1 - 2 people</span><span><i class='energy-gas-sm'></i>Small hot water system. Occasionally use gas cooking and/or heating</span>,Medium=<h3>Medium</h3><span><i class='energy-people-md'></i>3 - 4 people</span><span><i class='energy-gas-md'></i>Medium hot water system. Regularly use gas cooking and/or heating</span>,High=<h3>High</h3><span><i class='energy-people-hi'></i>4 - 5+ people</span><span><i class='energy-gas-hi'></i>Large hot water system. Frequently use gas cooking and/or heating</span>"
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

