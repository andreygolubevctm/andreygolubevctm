<%@ tag description="Additional estimate details fieldset" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_v2:fieldset legend="Electricity" className="electricity-details">

    <c:set var="fieldXPath" value="utilities/householdDetails/solarPanels" />
    <form_v3:row label="Do you have solar panels installed on your property?" fieldXpath="${fieldXPath}" className="clear">
        <field_v2:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="Y=Yes,N=No"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="if you have solar panels." />
    </form_v3:row>

    <form_v3:row label="Who is your current provider?" className="clear">
        <c:set var="fieldXPath" value="utilities/estimateDetails/usage/electricity/currentSupplier" />
        <field_v2:array_select xpath="${fieldXPath}" required="true" className="init"
                                title="your current electricity supplier." items="=Scroll up and re-select postcode / suburb"
                                extraDataAttributes="data-default='${data[fieldXPath]}'" />
    </form_v3:row>

    <c:set var="fieldXPath" value="${xpath}/electricity/usage" />
    <form_v3:row label="Select your household size to estimate your typical electricity usage" fieldXpath="${fieldXPath}" className="clear electricity-usage hidden-lg">
        <field_v2:array_radio xpath="${fieldXPath}"
                               required="true"
                               className="col-md-12 roundedCheckboxIcons"
                               items="Low=Low 1-2 Occupants,Medium=Medium 3-4 Occupants,High=High 5+ Occupants"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="what household size best describes your electricity usage." />
    </form_v3:row>
    <form_v3:row label="Select the level that best describes your typical electricity usage" fieldXpath="${fieldXPath}" className="clear electricity-usage hidden-xs hidden-sm hidden-md">
        <field_v2:array_radio xpath="${fieldXPath}"
                              required="true"
                              className="col-md-12"
                              items="Low=<h3>Low</h3><span><i class='energy-people-sm'></i><span class='optionText'>1 - 2 people</span></span><span><i class='energy-bed-sm'></i><span class='optionText'>1 - 2 bedrooms</span></span><span><i class='energy-plug-sm'></i><span class='optionText'>Weekly laundry. Rarely cook or use heating/cooling</span></span><span><i class='energy-house-sm'></i><span class='optionText'>Not home much in day or evenings</span></span>,Medium=<h3>Medium</h3><span><i class='energy-people-md'></i><span class='optionText'>3 - 4 people</span></span><span><i class='energy-bed-md'></i><span class='optionText'>3 bedrooms</span></span><span><i class='energy-plug-md'></i><span class='optionText'>Regular laundry. Rarely cook or use heating/cooling. Use a few appliances</span></span><span><i class='energy-house-md'></i><span class='optionText'>Usually at work during the day and kids at school. Home evenings and weekends</span></span>,High=<h3>High</h3><span><i class='energy-people-hi'></i><span class='optionText'>4 - 5+ people</span></span><span><i class='energy-bed-hi'></i><span class='optionText'>4+ bedrooms</span></span><span><i class='energy-plug-hi'></i><span class='optionText'>Daily laundry. Frequent cooking and heating/cooling use. Use multiple appliances</span></span><span><i class='energy-house-hi'></i><span class='optionText'>In and out throughout the day. Home evenings and weekends</span></span>"
                              id="${go:nameFromXpath(fieldXPath)}"
                              title="what level best describes your electricity usage." />
    </form_v3:row>

    <form_v3:row label="How much is your bill?" className="clear additional-estimate-details-row spend">
    <utilities_v2_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                              utilityType="Electricity"
                                                              inputType="spend"
                                                              required="true"
                                                              inputGroupText="$"
                                                              inputGroupTextPosition="left"/>
    </form_v3:row>

    <form_v3:row label="How many days are in the billing period?" className="clear additional-estimate-details-row days">
        <utilities_v2_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Electricity"
                                                                  inputType="days"
                                                                  required="true"
                                                                  inputGroupText="days"
                                                                  inputGroupTextPosition="right"/>
    </form_v3:row>

    <c:set var="fieldXPath" value="${xpath}/electricity/meter" />
    <form_v3:row label="How are you charged for electricity?" fieldXpath="${fieldXPath}" className="clear additional-estimate-details-row electricity-meter">
        <field_v2:array_radio xpath="${fieldXPath}"
                               required="true"
                               className=""
                               items="S=Single rate,T=Two rate,M=Time of use"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="how you are charged." />
    </form_v3:row>

    <form_v3:row label="Peak usage" className="clear usage peak-usage">
        <utilities_v2_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Electricity"
                                                                  inputType="peak"
                                                                  required="true"
                                                                  helpId="536"
                                                                  inputGroupText="kWh"
                                                                  inputGroupTextPosition="right"/>
    </form_v3:row>

    <form_v3:row label="Off-peak usage (if any)" className="clear usage off-peak-usage">
        <utilities_v2_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Electricity"
                                                                  inputType="offpeak"
                                                                  required="true"
                                                                  helpId="537"
                                                                  inputGroupText="kWh"
                                                                  inputGroupTextPosition="right"/>
    </form_v3:row>

    <form_v3:row label="Shoulder usage (if any)" className="clear usage shoulder-usage">
        <utilities_v2_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Electricity"
                                                                  inputType="shoulder"
                                                                  required="false"
                                                                  inputGroupText="kWh"
                                                                  inputGroupTextPosition="right"/>
    </form_v3:row>

</form_v2:fieldset>

<form_v2:fieldset legend="Gas" className="gas-details">

    <form_v3:row label="Who is your current provider?" className="clear">
        <c:set var="fieldXPath" value="utilities/estimateDetails/usage/gas/currentSupplier" />
        <field_v2:array_select xpath="${fieldXPath}" required="true" className="init"
                                title="your current gas supplier." items="=Scroll up and re-select postcode / suburb"
                                extraDataAttributes="data-default='${data[fieldXPath]}'" />
    </form_v3:row>

    <c:set var="fieldXPath" value="${xpath}/gas/usage" />
    <form_v3:row label="Select your household size to estimate your typical gas usage" fieldXpath="${fieldXPath}" className="clear gas-usage hidden-lg">
        <field_v2:array_radio xpath="${fieldXPath}"
                               required="true"
                               className="col-md-12 roundedCheckboxIcons"
                               items="Low=Low 1-2 Occupants,Medium=Medium 3-4 Occupants,High=High 5+ Occupants"
                               id="${go:nameFromXpath(fieldXPath)}"
                               title="what household size best describes your gas usage." />
    </form_v3:row>
    <form_v3:row label="Select the level that best describes your typical gas usage" fieldXpath="${fieldXPath}" className="clear gas-usage hidden-xs hidden-sm hidden-md">
        <field_v2:array_radio xpath="${fieldXPath}"
                              required="true"
                              className="col-md-12"
                              items="Low=<h3>Low</h3><span><i class='energy-people-sm'></i><span class='optionText'>1 - 2 people</span></span><span><i class='energy-gas-sm'></i><span class='optionText'>Small hot water system. Occasionally use gas cooking and/or heating</span></span>,Medium=<h3>Medium</h3><span><i class='energy-people-md'></i><span class='optionText'>3 - 4 people</span></span><span><i class='energy-gas-md'></i><span class='optionText'>Medium hot water system. Regularly use gas cooking and/or heating</span></span>,High=<h3>High</h3><span><i class='energy-people-hi'></i><span class='optionText'>4 - 5+ people</span></span><span><i class='energy-gas-hi'></i><span class='optionText'>Large hot water system. Frequently use gas cooking and/or heating</span></span>"
                              id="${go:nameFromXpath(fieldXPath)}"
                              title="what level best describes your gas usage." />
    </form_v3:row>

    <form_v3:row label="How much do you usually spend?" className="clear additional-estimate-details-row spend">
        <utilities_v2_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Gas"
                                                                  inputType="spend"
                                                                  required="true"
                                                                  inputGroupText="$"
                                                                  inputGroupTextPosition="left"/>
    </form_v3:row>

    <form_v3:row label="How many days are in the billing period?" className="clear additional-estimate-details-row days">
        <utilities_v3_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Gas"
                                                                  inputType="days"
                                                                  required="true"
                                                                  inputGroupText="days"
                                                                  inputGroupTextPosition="right"/>
    </form_v3:row>

    <form_v3:row label="Standard usage (peak/anytime)" className="clear additional-estimate-details-row usage">
        <utilities_v3_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Gas"
                                                                  inputType="peak"
                                                                  helpId="538"
                                                                  required="true"
                                                                  inputGroupText="MJ"
                                                                  inputGroupTextPosition="right"/>
    </form_v3:row>

    <form_v3:row label="Off-peak usage (if any)" className="clear additional-estimate-details-row usage">

        <utilities_v3_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Gas"
                                                                  inputType="offpeak"
                                                                  helpId="539"
                                                                  required="false"
                                                                  inputGroupText="MJ"
                                                                  inputGroupTextPosition="right"/>
    </form_v3:row>

</form_v2:fieldset>

