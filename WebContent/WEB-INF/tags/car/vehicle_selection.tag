<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_new:fieldset_columns sideHidden="true">

	<jsp:attribute name="rightColumn"></jsp:attribute>

	<jsp:body>
		<ui:bubble variant="chatty">
			<h4>Tell us about your car</h4>
			<p>Answering these questions will help us supply you with car insurance quotes from our participating suppliers.</p>
		</ui:bubble>
	</jsp:body>
</form_new:fieldset_columns>

<form_new:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
		<ui:bubble variant="help">
			<h4>Market Value</h4>
			<p>Your quote will be based on the market value of your car. Please refer to the insurers Product Disclosure Statement for more details.</p>
		</ui:bubble>
	</jsp:attribute>

	<jsp:body>
		<form_new:fieldset legend="Your Car" id="${name}_selection">

			<form_new:row label="Make" id="${name}_makeRow" className="initial" helpId="3">
				<field_new:general_select xpath="${xpath}/make" title="vehicle manufacturer" required="true" initialText="&nbsp;" />
				<field:hidden xpath="${xpath}/makeDes"></field:hidden>
			</form_new:row>

			<form_new:row label="Model" id="${name}_modelRow">
				<field_new:general_select xpath="${xpath}/model" title="vehicle model" required="true" initialText="&nbsp;" />
				<field:hidden xpath="${xpath}/modelDes"></field:hidden>
			</form_new:row>

			<form_new:row label="Year" id="${name}_yearRow">
				<field_new:general_select xpath="${xpath}/year" title="vehicle year" required="true" initialText="&nbsp;" />
				<field:hidden xpath="${xpath}/registrationYear"></field:hidden>
				</form_new:row>

			<form_new:row label="Body" id="${name}_bodyRow" className="hidden">
				<field_new:general_select xpath="${xpath}/body" title="vehicle body" required="true" initialText="&nbsp;" />
			</form_new:row>

			<form_new:row label="Transmission" id="${name}_transRow" className="hidden">
				<field_new:general_select xpath="${xpath}/trans" title="vehicle transmission" required="true" initialText="&nbsp;" />
			</form_new:row>

			<form_new:row label="Fuel" id="${name}_fuelRow" className="hidden">
				<field_new:general_select xpath="${xpath}/fuel" title="fuel type" required="true" initialText="&nbsp;" />
			</form_new:row>

			<form_new:row label="Type" id="${name}_redbookCodeRow" className="${name}_redbookCodeRow hidden">
				<field_new:general_select xpath="${xpath}/redbookCode" title="vehicle type" required="true" className="vehicleDes" initialText="&nbsp;" />
				<field:hidden xpath="${xpath}/marketValue"></field:hidden>
				<field:hidden xpath="${xpath}/variant"></field:hidden>
			</form_new:row>
		</form_new:fieldset>
	</jsp:body>
</form_new:fieldset_columns>