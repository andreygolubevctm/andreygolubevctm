<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_v2:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
		<ui:bubble variant="info" className="point-left">
			<h4>Tell us about your car</h4>
			<p>Answering these questions will help us supply you with car insurance quotes from our participating suppliers.</p>
		</ui:bubble>
	</jsp:attribute>

	<jsp:body>
		<form_v2:fieldset legend="Your Car" id="${name}_selection">

			<car:rego_lookup xpath="${xpath}/vehicle" />

			<form_v2:row label="Make" id="${name}_makeRow" className="initial" helpId="3">
				<field_v2:general_select xpath="${xpath}/make" title="vehicle manufacturer" required="true" initialText="&nbsp;" />
				<field_v1:hidden xpath="${xpath}/makeDes"></field_v1:hidden>
			</form_v2:row>

			<form_v2:row label="Model" id="${name}_modelRow">
				<field_v2:general_select xpath="${xpath}/model" title="vehicle model" required="true" initialText="&nbsp;" />
				<field_v1:hidden xpath="${xpath}/modelDes"></field_v1:hidden>
			</form_v2:row>

			<form_v2:row label="Year" id="${name}_yearRow">
				<field_v2:general_select xpath="${xpath}/year" title="vehicle year" required="true" initialText="&nbsp;" />
				<field_v1:hidden xpath="${xpath}/registrationYear"></field_v1:hidden>
				</form_v2:row>

			<form_v2:row label="Body" id="${name}_bodyRow" className="hidden">
				<field_v2:general_select xpath="${xpath}/body" title="vehicle body" required="true" initialText="&nbsp;" />
			</form_v2:row>

			<form_v2:row label="Transmission" id="${name}_transRow" className="hidden">
				<field_v2:general_select xpath="${xpath}/trans" title="vehicle transmission" required="true" initialText="&nbsp;" />
			</form_v2:row>

			<form_v2:row label="Fuel" id="${name}_fuelRow" className="hidden">
				<field_v2:general_select xpath="${xpath}/fuel" title="fuel type" required="true" initialText="&nbsp;" />
			</form_v2:row>

			<form_v2:row label="Type" id="${name}_redbookCodeRow" className="${name}_redbookCodeRow hidden">
				<field_v2:general_select xpath="${xpath}/redbookCode" title="vehicle type" required="true" className="vehicleDes" initialText="&nbsp;" />
				<field_v1:hidden xpath="${xpath}/marketValue"></field_v1:hidden>
				<field_v1:hidden xpath="${xpath}/variant"></field_v1:hidden>
			</form_v2:row>

			<form_v2:row label="What is the color of the car?" id="${name}_colourRow" className="hidden">
				<field_v2:general_select xpath="${xpath}/colour" title="colour" required="true" initialText="&nbsp;" />
			</form_v2:row>
		</form_v2:fieldset>
	</jsp:body>
</form_v2:fieldset_columns>