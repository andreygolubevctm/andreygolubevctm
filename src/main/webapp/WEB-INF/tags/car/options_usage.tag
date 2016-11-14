<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_v2:fieldset legend="Using Your Car" id="${name}FieldSet">

	<c:if test="${isFromExoticPage eq true or data.quote.vehicle.marketValue > 150000}">
		<car:exotic_your_usage_questions xpath="${xpath}/vehicle/exoticcar" />
	</c:if>

	<div id="securityOptionHiddenRow"></div>
	<form_v2:row id="securityOptionRow" label="Does the car have an alarm or an immobiliser fitted?" helpId="5">
		<field_v2:import_select xpath="${xpath}/securityOption"
			url="/WEB-INF/option_data/car_security.html"
			title="whether an alarm or immobiliser is fitted" className="quote_security"
			required="true" />
	</form_v2:row>

	<form_v2:row label="How is the car used?" helpId="8">
		<field_v2:import_select xpath="${xpath}/use"
			url="/WEB-INF/option_data/vehicle_use.html"
			title="how is the vehicle used" className="vehicle_use"
			required="true" />
	</form_v2:row>

	<form_v2:row label="Will the car be used for carrying passengers for payment, providing paid driving instruction or hiring out to other people?" className="passengerPayment">
		<field_v2:array_radio xpath="${xpath}/passengerPayment" required="true"
							   className="quote_passengerPayment" id="quote_passengerPayment" items="Y=Yes,N=No"
							   title="if the car will be used for carrying passengers for payment, providing paid driving instruction or hiring out to other people?" />
	</form_v2:row>

	<form_v2:row label="Will the car be used for carrying goods for payment?" className="goodsPayment"  helpId="541">
		<field_v2:array_radio xpath="${xpath}/goodsPayment" required="true"
							   className="quote_goodsPayment" id="quote_goodsPayment" items="Y=Yes,N=No"
							   title="if the car will be used for carrying goods for payment?" />
	</form_v2:row>

	<form_v2:row label="Is there any finance on the car?" helpId="9">
		<field_v2:import_select xpath="${xpath}/finance"
			url="/WEB-INF/option_data/finance_type.html"
			title="if the vehicle is under any finance" className="finance_type"
			required="true" />
	</form_v2:row>


	<form_v2:row label="Enter the number of kilometres the car is driven per year (Australian average 15,000 Km’s per year)" helpId="14" className="noOfKms">
		<field_v2:kilometers_travelled xpath="${xpath}/annualKilometres" id="annual_kilometres" className="annual_kilometres" placeHolder="Example: 20000" required="true" />
	</form_v2:row>

	<form_v2:row label="Does the car have any accident or hail damage?" id="accidentDamageRow" helpId="24">
		<field_v2:array_radio xpath="${xpath}/damage" required="true"
			className="quote_damage" id="quote_damage" items="Y=Yes,N=No"
			title="if the car has any accident or hail damage" />
	</form_v2:row>

</form_v2:fieldset>
