<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="label" required="false" rtexprvalue="true" description="The label displayed above the element"%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="Additional classes to be added to the partent element"%>
<%@ attribute name="asBubble" required="false" rtexprvalue="true" description="Render style for content"%>

<form_v2:fieldset legend="${label}" className="hidden snapshot yourDetailsSnapshot hidden-xs ${className}">
	<div class="row snapshot">
		<div class="col-sm-12">
			<h4>Your Details</h4>
		</div>
		<div class="col-sm-12">
			<div class="row">
				<div class="col-sm-12 title">Comparing: <span data-source="input[name='utilities_householdDetails_whatToCompare']" data-callback="meerkat.modules.utilitiesSnapshot.getComparisonType"></span></div>
			</div>
			<div class="row">
				<div class="col-sm-12 title">Living in: <span data-source="#utilities_householdDetails_location"></span></div>
			</div>
			<div class="row electricityUsageContainer hidden">
				<div class="col-sm-12 title">Electricity Usage:</div>
				<div class="col-sm-12"><span data-source="input[name='utilities_estimateDetails_electricity_meter']" data-callback="meerkat.modules.utilitiesSnapshot.getElectricityUsage"></span></div>
			</div>
			<div class="row gasUsageContainer hidden">
				<div class="col-sm-12 title">Natural Gas Usage:</div>
				<div class="col-sm-12"><span data-source="input[name='utilities_estimateDetails_gas_usage']" data-callback="meerkat.modules.utilitiesSnapshot.getGasUsage"></span></div>
			</div>
		</div>
	</div>
</form_v2:fieldset>