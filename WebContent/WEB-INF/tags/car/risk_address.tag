<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_new:fieldset legend="Address" id="${name}FieldSet">

	<group_new:address xpath="${xpath}" type="R" />

	<form_new:row label="Where is the car parked at night?" helpId="7">
		<field_new:import_select xpath="quote/vehicle/parking"
							url="/WEB-INF/option_data/parking_location.html"
							title="the location where the car is parked at night"
							className="parking_location"
							required="true" />
	</form_new:row>

</form_new:fieldset>
