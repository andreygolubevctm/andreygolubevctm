<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Estimate Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="${name}">

	<form_v1:fieldset legend="Additional Estimate Details">

		<div class="spend">
			<div class="utilities-titles">
				<h5 class="left ${name}_electricity_h5 electricity">Electricity</h5>
				<h5 class="left ${name}_gas_h5 gas">Gas</h5>
			</div>
			<core_v1:clear />

			<form_v1:row label="How much do you usually spend?">
				<field_v1:currency xpath="${xpath}/spend/electricity/amount" title="Your electricity spend" required="true" symbol="$" decimal="${false}" className="${name}_input electricity" maxLength="15" />
				<field_v1:array_select items="=Select period,M=Month,Q=Quarter,Y=Year" xpath="${xpath}/spend/electricity/period" title="an electricity spend period" className="electricity" required="true" />
				<field_v1:currency xpath="${xpath}/spend/gas/amount" title="Your gas spend" required="true" symbol="$" decimal="${false}" className="${name}_input gas" maxLength="15" />
				<field_v1:array_select items="=Select period,M=Month,B=2 Months,Q=Quarter,Y=Year" xpath="${xpath}/spend/gas/period" title="a gas spend period" className="gas" required="true"/>
			</form_v1:row>
		</div>

		<div class="household">
			<form_v1:row label="How many people live in your home?">
				<field_v1:array_select items="1=1,2=2,3=3,4=4+" xpath="${xpath}/household/people" title="household people" required="true" />
			</form_v1:row>

			<form_v1:row label="How many bedrooms in your home?">
				<field_v1:array_select items="1=1,2=2,3=3,4=4+" xpath="${xpath}/household/bedrooms" title="household bedrooms" required="true" />
			</form_v1:row>

		</div>

		<div class="usage">
			<div class="utilities-titles">
				<h5 class="left ${name}_electricity_h5 electricity">Electricity</h5><div class="help_icon electricity" id="help_414"></div>
				<h5 class="left ${name}_gas_h5 gas">Gas</h5><div class="help_icon gas" id="help_415"></div>
			</div>
			<core_v1:clear />

			<form_v1:row label="Standard usage (peak/anytime)">
				<field_v1:currency xpath="${xpath}/usage/electricity/peak/amount" title="electricity peak usage" required="true" symbol="" decimal="false" className="${name}_input electricity" /><span class="electricity"> kWh</span>
				<field_v1:array_select items="=Select period,M=Month,Q=Quarter,Y=Year" xpath="${xpath}/usage/electricity/peak/period" title="the electricity peak usage period" required="true" className="${name}_select_usage electricity" />
				<field_v1:currency xpath="${xpath}/usage/gas/peak/amount" title="gas peak usage" required="true" symbol="" decimal="false" className="${name}_input gas" /><span class="gas"> MJ</span>
				<field_v1:array_select items="=Select period,M=Month,Q=Quarter,Y=Year" xpath="${xpath}/usage/gas/peak/period" title="the gas peak usage period" required="true" className="${name}_select_usage gas" />
			</form_v1:row>

			<form_v1:row label="Off-peak usage (if any)">
				<field_v1:currency xpath="${xpath}/usage/electricity/offpeak/amount" title="electricity offpeak usage" required="false" symbol="" decimal="false" className="${name}_input electricity" /><span class="electricity"> kWh</span>
				<field_v1:array_select items="=Select period,M=Month,Q=Quarter,Y=Year" xpath="${xpath}/usage/electricity/offpeak/period" title="the electricity offpeak usage period" required="false" className="${name}_select_usage electricity" />
				<field_v1:currency xpath="${xpath}/usage/gas/offpeak/amount" title="gas offpeak usage" required="false" symbol="" decimal="false" className="${name}_input gas" /><span class="gas"> MJ</span>
				<field_v1:array_select items="=Select period,M=Month,Q=Quarter,Y=Year" xpath="${xpath}/usage/gas/offpeak/period" title="the gas offpeak usage period" required="false" className="${name}_select_usage gas" />
			</form_v1:row>

			<div class="shoulderRow">
				<form_v1:row label="Shoulder usage (if any)">
					<field_v1:currency xpath="${xpath}/usage/electricity/shoulder/amount" title="electricity shoulder usage" required="false" symbol="" decimal="false" className="${name}_input electricity" /><span class="electricity"> kWh</span>
					<field_v1:array_select items="=Select period,M=Month,Q=Quarter,Y=Year" xpath="${xpath}/usage/electricity/shoulder/period" title="the electricity shoulder usage period" required="false" className="${name}_select_usage electricity" />
				</form_v1:row>
			</div>

		</div>

		<div class="currentProviderContainer">
			<form_v1:row label="Who is your current supplier?">
				<field_v1:hidden xpath="${xpath}/usage/electricity/currentSupplierSelected" constantValue="${data['utilities/estimateDetails/usage/electricity/currentSupplier']}" />
				<field_v1:general_select xpath="${xpath}/usage/electricity/currentSupplier" type="elecProvider" title="current electricity provider" required="true" className="${name}_select_currentSupplier electricity" />
				<field_v1:hidden xpath="${xpath}/usage/gas/currentSupplierSelected" constantValue="${data['utilities/estimateDetails/usage/gas/currentSupplier']}" />
				<field_v1:general_select xpath="${xpath}/usage/gas/currentSupplier" type="gasProvider" title="current gas provider" required="true" className="${name}_select_currentSupplier gas" />
			</form_v1:row>

			<form_v1:row label="" className="currentProviderContainerHelpTextRow">
				<div class="helptext">As we don't have access to your current bill details, we have assumed you are on a standard tariff <span></span>.</div>
			</form_v1:row>
		</div>

	</form_v1:fieldset>

</div>

<%-- CSS --%>
<go:style marker="css-head">
	.utilities-titles{
		padding-left: 207px;
	}
	.help_icon.electricity{
		margin-left: -139px;
	}

	#${name},
	#${name} .spend,
	#${name} .household,
	#${name} .usage,
	#${name} .currentProviderContainer{
		zoom: 1;
		min-height:0;
	}

	#${name} .${name}_electricity_h5 {
		margin-right: 141px;
	}
	#${name} .spend .${name}_electricity_h5 {
		margin-right: 124px;
	}
	#${name} h5 {
		padding-left: 0;
		clear:none;
	}

	#${name} .${name}_select_currentSupplier.electricity,
	#${name} .${name}_select_currentPlan.electricity,
	#${name} #${name}_spend_electricity_period {
		margin-right: 20px;
	}

	#${name} .fieldrow_value.dollar {
		position: relative;
	}

	#${name} .fieldrow_value.dollar input {
		padding-left: 11px;
	}

	#${name} .fieldrow_value.dollar span {
		position: absolute;
		width: 10px;
		height: 12px;
		top: 9px;
		left: 4px;
	}

	#${name} .${name}_input {
		width: 46px;
	}
	#${name} .${name}_select_usage.electricity{
		margin-right: 10px;
	}

	#${name} .${name}_select_currentSupplier,
	#${name} .${name}_select_currentPlan {
		width: 175px;
		max-width: 175px;
	}


	#${name},
	#${name} .spend,
	#${name} .spend .electricity,
	#${name} .spend .gas,
	#${name} .household,
	#${name} .usage,
	#${name} .usage .shoulderRow,
	#${name} .usage .electricity,
	#${name} .usage .gas,
	#${name} .currentProviderContainer{
		display: none;
	}

	#${name} .currentProviderContainer .currentProviderContainerCurrentPlanRow {
		display: none;
	}

	#${name} .currentProviderContainer .currentProviderContainerHelpTextRow {
		display: none;
	}

	#${name} .currentProviderContainer .currentProviderContainerHelpTextRow .helptext {
		width: 400px;
		font-style:italic;
	}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="onready">

</go:script>

<%-- VALIDATION --%>

<%-- Usage Electricity --%>
<go:validate selector="${name}_spend_electricity_amountentry" rule="maximumSpend" parm="true" />
<go:validate selector="${name}_spend_gas_amountentry" rule="maximumSpend" parm="true" />

<go:validate selector="${name}_usage_electricity_peak_amountentry" rule="maximumUsage" parm="true" />
<go:validate selector="${name}_usage_electricity_offpeak_amountentry" rule="maximumUsage" parm="true" />

<%-- Usage Electricity --%>
<go:validate selector="${name}_usage_gas_peak_amountentry" rule="maximumUsageGas" parm="true" />
<go:validate selector="${name}_usage_gas_offpeak_amountentry" rule="maximumUsageGas" parm="true" />

<go:validate selector="${name}_usage_electricity_offpeak_period" rule="amountPeriodRequired" parm="true" message="Please choose the usage electricity offpeak period" />
<go:validate selector="${name}_usage_gas_offpeak_period" rule="amountPeriodRequired" parm="true" message="Please choose the usage gas offpeak period" />
<go:validate selector="${name}_usage_electricity_shoulder_period" rule="amountPeriodRequired" parm="true" message="Please choose the usage electricity shoulder period" />