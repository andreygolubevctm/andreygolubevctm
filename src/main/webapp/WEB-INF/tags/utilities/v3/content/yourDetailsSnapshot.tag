<%@ tag description="Your Details Snapshot" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="your-details-snapshot-template">
<div class="sidebar-box yourDetailsSnapshot hidden-xs">
	<div class="row">
		<div class="col-sm-12">
			<h4>Your Details</h4>
		</div>
		<div class="col-sm-12">
			<div class="row">
				<div class="col-sm-12 title">Comparing: <span>{{= obj.whatToCompare }}</span></div>
			</div>
			<div class="row">
				<div class="col-sm-12 title">Living in: <span>{{= obj.livingIn }}</span></div>
			</div>
			{{ if (obj.showElectricityUsage == true) { }}
			<div class="row electricityUsageContainer">
				<div class="col-sm-12 title">Electricity Usage:</div>
				<div class="col-sm-12">{{= obj.electricityUsage }}</div>
			</div>
			{{ } }}
			{{ if (obj.showGasUsage == true) { }}
			<div class="row gasUsageContainer">
				<div class="col-sm-12 title">Natural Gas Usage:</div>
				<div class="col-sm-12">{{= obj.gasUsage }}</div>
			</div>
			{{ } }}
		</div>
	</div>
</div>
</core_v1:js_template>