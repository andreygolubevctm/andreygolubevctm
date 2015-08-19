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

<go:script marker="js-head">
    $.validator.addMethod("amountPeriodRequired", function (value, element) {

        var amount = $('#' + $(element).attr('id').replace('_period', '_amount'));
        var period = $(element);

        var amt = $.trim(amount.val());

        if (amt == '' || amt == '0' || (amount.val != '' && period.val() != '')) {
            return true;
        } else {
            return false;
        }

    });

    $.validator.addMethod("maximumSpend",
            function (value, e) {

                var element = $('#' + $(e).attr('id'));
                var spend = $(element).val();
                var period = $('#' + $(element).attr('id').replace('_amount', '_period'));
                var normalise;

                switch (period.val()) {
                    case 'M':
                        normalise = 1;
                        break;
                    case 'B':
                        normalise = 2;
                        break;
                    case 'Q':
                        normalise = 3;
                        break;
                    default:
                        normalise = 12;
                        break;
                }

                if (spend >= 1 && spend < (5000 * normalise)) {
                    return true;
                } else {
                    return false;
                }

            }, (function (value, e) {
                var element = $('#' + $(e).attr('id'));
                var period = $('#' + $(element).attr('id').replace('_amount', '_period'));
                switch (period.val()) {
                    case 'M':
                        return "Monthly spend should be between $1 and $5,000";
                        break;
                    case 'B':
                        return "Bimonthly spend should be between $1 and $10,000";
                        break;
                    case 'Q':
                        return "Quartly spend should be between $1 and $15,000";
                        break;
                    default:
                        return "Annual spend should be between $1 and $60,000";
                        break;
                }
            })
    );

    $.validator.addMethod("maximumUsage",
            function (value, e) {

                element = $('#' + $(e).attr('id'));
                var $amountElement = $(element);
                var usage = $amountElement.val();
                var minimumUsage = $amountElement.attr('id').indexOf('offpeak') == -1 ? 0 : -1;
                var period = $('#' + $amountElement.attr('id').replace('_amount', '_period'));
                var normalise;
                var valid = false;

                switch ($(period).val()) {
                    case 'M':
                        if (usage == '' || (usage > minimumUsage && usage <= 7000)) {
                            valid = true;
                        }
                        break;
                    case 'B':
                        if (usage == '' || (usage > minimumUsage && usage <= 14000)) {
                            valid = true;
                        }
                        break;
                    case 'Q':
                        if (usage == '' || (usage > minimumUsage && usage <= 20000)) {
                            valid = true;
                        }
                        break;
                    default:
                        if (usage == '' || (usage > minimumUsage && usage <= 85000)) {
                            valid = true;
                        }
                        break;
                }

                return valid;
            }, (function (value, e) {
                var element = $('#' + $(e).attr('id'));
                var period = $('#' + $(element).attr('id').replace('_amount', '_period'));

                switch ($(period).val()) {
                    case 'M':
                        return "Monthly usage should be between 1kWh and 7,000kWh";
                        break;
                    case 'B':
                        return "Bimonthly usage should be between 1kWh and 14,000kWh";
                        break;
                    case 'Q':
                        return "Quarterly usage should be between 1kWh and 20,000kWh";
                        break;
                    default:
                        return "Annual usage should be between 1kWh and 85,000kWh";
                        break;
                }
            })
    );

    $.validator.addMethod("maximumUsageGas",
            function (value, e) {

                element = $('#' + $(e).attr('id').replace('amountentry', 'amount'));
                var $amountElement = $(element);
                var usage = $amountElement.val();
                var minimumUsage = $amountElement.attr('id').indexOf('offpeak') == -1 ? 0 : -1;
                var period = $('#' + $amountElement.attr('id').replace('_amount', '_period'));
                var normalise;
                var valid = false;

                switch ($(period).val()) {
                    case 'M':
                        if (usage == '' || (usage > minimumUsage && usage <= 6500)) {
                            valid = true;
                        }
                        break;
                    case 'B':
                        if (usage == '' || (usage > minimumUsage && usage <= 14000)) {
                            valid = true;
                        }
                        break;
                    case 'Q':
                        if (usage == '' || (usage > minimumUsage && usage <= 20000)) {
                            valid = true;
                        }
                        break;
                    default:
                        if (usage == '' || (usage > minimumUsage && usage <= 85000)) {
                            valid = true;
                        }
                        break;
                }

                return valid;
            }, (function (value, e) {
                var element = $('#' + $(e).attr('id'));
                var period = $('#' + $(element).attr('id').replace('_amount', '_period'));

                switch ($(period).val()) {
                    case 'M':
                        return "Monthly usage should be between 1MJ and 6,500MJ";
                        break;
                    case 'B':
                        return "Bimonthly usage should be between 1MJ and 14,000MJ";
                        break;
                    case 'Q':
                        return "Quarterly usage should be between 1MJ and 20,000MJ";
                        break;
                    default:
                        return "Annual usage should be between 1MJ and 85,000MJ";
                        break;
                }
            })
    );
</go:script>

<%-- VALIDATION --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<%-- Usage Peak --%>
<go:validate selector="${name}_spend_electricity_amount" rule="maximumSpend" parm="true"/>
<go:validate selector="${name}_spend_gas_amount" rule="maximumSpend" parm="true"/>

<go:validate selector="${name}_usage_electricity_peak_amount" rule="maximumUsage" parm="true"/>
<go:validate selector="${name}_usage_gas_peak_amount" rule="maximumUsageGas" parm="true"/>

<%-- Usage Electricity --%>
<go:validate selector="${name}_usage_electricity_offpeak_amount" rule="maximumUsage" parm="true"/>
<go:validate selector="${name}_usage_gas_offpeak_amount" rule="maximumUsageGas" parm="true"/>

<go:validate selector="${name}_usage_electricity_offpeak_period" rule="amountPeriodRequired" parm="true"
             message="Please choose the electricity offpeak usage period"/>

<go:validate selector="${name}_usage_gas_offpeak_period" rule="amountPeriodRequired" parm="true"
             message="Please choose the gas offpeak usage period"/>

