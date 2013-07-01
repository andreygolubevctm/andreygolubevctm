<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" required="false" rtexprvalue="true"
	description="additional css class attribute"%>
<%@ attribute name="id" required="false" rtexprvalue="true"
	description="optional id for this slide"%>
<%-- CSS --%>
<go:style marker="css-head">
	#quote_options_driverOption {
		max-width:320px;
	}
</go:style>
<%-- HTML --%>
<form:fieldset legend="We need to get some more details about the car">
	<div id="securityOption"></div>
	<form:row id="securityOptionRow" label="Does the car have an alarm or an immobiliser fitted?" helpId="5">
		<field:import_select xpath="quote/vehicle/securityOption"
			url="/WEB-INF/option_data/car_security.html"
			title="whether an alarm or immobiliser is fitted" className="car_security"
			required="true" />
	</form:row>
	<form:row label="Has the car been modified?" helpId="6" id="modifiedRow">
		<field:array_radio xpath="quote/vehicle/modifications" required="true"
			className="car_modifications" items="Y=Yes,N=No"
			id="car_modifications" title="if the car has been modified" />
	</form:row>
	<form:row label="Does the car have any accident or hail damage?" id="accidentDamageRow">
		<field:array_radio xpath="quote/vehicle/damage" required="true"
			className="car_damage" id="car_damage" items="Y=Yes,N=No"
			title="if the car has any accident or hail damage" />
	</form:row>
	<form:row label="How is the car used?" helpId="8">
		<field:import_select xpath="quote/vehicle/use"
			url="/WEB-INF/option_data/vehicle_use.html"
			title="how is the vehicle used" className="vehicle_use"
			required="true" />
	</form:row>

	<form:row label="Is there any finance on the car?" helpId="9">
		<field:import_select xpath="quote/vehicle/finance"
			url="/WEB-INF/option_data/finance_type.html"
			title="if the vehicle is under any finance" className="finance_type"
			required="true" />
	</form:row>

	<form:row label="Enter the number of kilometres the vehicle is driven per year?" helpId="14" legend="Example: 20000" id="annual_kilometres_row">
		<field:kilometers_travelled xpath="quote/vehicle/annualKilometres"
									id="annual_kilometres"
									className="annual_kilometres"
									required="true" />
	</form:row>
	
	<form:row label="How is the car parked at night" helpId="7">
		<field:import_select xpath="quote/vehicle/parking" 
							 url="/WEB-INF/option_data/parking_location.html"
							 title="the location where the car is parked at night"
							 className="parking_location" 
							 required="true" />						
	</form:row>	
	
</form:fieldset>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$(function() {
		$("#car_modifications, #car_damage").buttonset();
	});

	var securityOption = $("#securityOptionRow").html();
	$("#securityOptionRow").remove()
</go:script>

<%-- VALIDATION --%>
<go:validate selector="quote_options_driverOption" rule="allowedDrivers"
	parm="true"
	message="Driver age restriction invalid due to regular driver's age." />






