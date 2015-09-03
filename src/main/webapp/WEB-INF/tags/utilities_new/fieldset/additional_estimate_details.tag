<%@ tag description="Additional estimate details fieldset" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Fieldset XPath" %>

<form_new:fieldset legend="Additional Estimate Details" className="additional-estimate-details">
    <form_new:row label="How much do you usually spend?" className="clear additional-estimate-details-row spend">
        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Electricity"
                                                                  inputType="spend"
                                                                  required="true"
                                                                  inputGroupText="$"
                                                                  inputGroupTextPosition="left"/>

        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Gas"
                                                                  inputType="spend"
                                                                  required="true"
                                                                  inputGroupText="$"
                                                                  inputGroupTextPosition="left"/>
    </form_new:row>

    <form_new:row label="Standard usage (peak/anytime)" className="clear additional-estimate-details-row usage">
        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Electricity"
                                                                  inputType="peak"
                                                                  helpId="536"
                                                                  required="true"
                                                                  inputGroupText="kWh"
                                                                  inputGroupTextPosition="right"/>

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
                                                                  utilityType="Electricity"
                                                                  inputType="offpeak"
                                                                  required="false"
                                                                  helpId="537"
                                                                  inputGroupText="kWh"
                                                                  inputGroupTextPosition="right"/>

        <utilities_new_fieldset:additional_estimate_details_input xpath="${xpath}"
                                                                  utilityType="Gas"
                                                                  inputType="offpeak"
                                                                  helpId="539"
                                                                  required="false"
                                                                  inputGroupText="MJ"
                                                                  inputGroupTextPosition="right"/>
    </form_new:row>

    <form_new:row label="Who is your current provider?" className="clear">
        <div id="current-electricity-provider-field">
            <h5>Electricity</h5>

            <div class="clearfix">
                <c:set var="fieldXPath" value="${xpath}/usage/electricity/currentSupplier" />
                <field_new:array_select xpath="${fieldXPath}" required="true"
                                        title="your current electricity supplier." items=""
                                        extraDataAttributes="data-default='${data[fieldXPath]}'" />
            </div>
        </div>

        <div id="current-gas-provider-field">
            <h5>Gas</h5>

            <div class="clearfix">
                <c:set var="fieldXPath" value="${xpath}/usage/gas/currentSupplier" />
                <field_new:array_select xpath="${fieldXPath}" required="true"
                                        title="your current gas supplier." items=""
                                        extraDataAttributes="data-default='${data[fieldXPath]}'" />
            </div>
        </div>
    </form_new:row>
</form_new:fieldset>