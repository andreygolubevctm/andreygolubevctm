<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<ui:bubble variant="chatty">
	<h4>Tell us about your car</h4>
	<p>Answering these questions will help us supply you with car insurance quotes from our participating suppliers.</p>
</ui:bubble>

<form_v2:fieldset legend="Your Car" id="${name}_selection">

	<form_v2:row label="Make" id="${name}_makeRow" className="initial" helpId="3">
		<field_new:general_select xpath="${xpath}/make" title="vehicle manufacturer" required="true" initialText="&nbsp;" />
		<field:hidden xpath="${xpath}/makeDes"></field:hidden>
	</form_v2:row>

	<form_v2:row label="Model" id="${name}_modelRow">
		<field_new:general_select xpath="${xpath}/model" title="vehicle model" required="true" initialText="&nbsp;" />
		<field:hidden xpath="${xpath}/modelDes"></field:hidden>
	</form_v2:row>

	<form_v2:row label="Year" id="${name}_yearRow">
		<field_new:general_select xpath="${xpath}/year" title="vehicle year" required="true" initialText="&nbsp;" />
		<field:hidden xpath="${xpath}/registrationYear"></field:hidden>
		</form_v2:row>

	<form_v2:row label="Body" id="${name}_bodyRow" className="hidden">
		<field_new:general_select xpath="${xpath}/body" title="vehicle body" required="true" initialText="&nbsp;" />
	</form_v2:row>

	<form_v2:row label="Transmission" id="${name}_transRow" className="hidden">
		<field_new:general_select xpath="${xpath}/trans" title="vehicle transmission" required="true" initialText="&nbsp;" />
	</form_v2:row>

	<form_v2:row label="Fuel" id="${name}_fuelRow" className="hidden">
		<field_new:general_select xpath="${xpath}/fuel" title="fuel type" required="true" initialText="&nbsp;" />
	</form_v2:row>

	<c:choose>
		<c:when test="${editDetailsRedbookCodeSplitTest eq true}">
			<form_v2:row label="Please select your car type" hideHelpIconCol="true" id="${name}_redbookCodeRow" className="${name}_redbookCodeRow radio-button-group-row hidden">
				<div id="${name}_redbookCode" class="radio-button-group"><!-- to be populated --></div>
				<field:hidden xpath="${xpath}/marketValue"></field:hidden>
				<field:hidden xpath="${xpath}/variant"></field:hidden>
			</form_v2:row>
		</c:when>
		<c:otherwise>
			<form_v2:row label="Type" id="${name}_redbookCodeRow" className="${name}_redbookCodeRow hidden">
				<field_new:general_select xpath="${xpath}/redbookCode" title="vehicle type" required="true" className="vehicleDes" initialText="&nbsp;" />
				<field:hidden xpath="${xpath}/marketValue"></field:hidden>
				<field:hidden xpath="${xpath}/variant"></field:hidden>
			</form_v2:row>
		</c:otherwise>
	</c:choose>

</form_v2:fieldset>
