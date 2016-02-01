<%@ tag description="Your Details Snapshot" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="your-details-snapshot-template">
	{{ if (obj.showWhatToCompare == true || obj.showLivingIn == true || obj.showElectricityUsage == true || obj.showGasUsage == true) { }}
	<div class="sidebar-box yourDetailsSnapshot hidden-xs">
		<div class="row">
			<div class="col-sm-12">
				<h4>Your Summary</h4>
			</div>
			<div class="col-sm-12">
				{{ if (obj.showWhatToCompare == true) { }}
				<div class="row">
					<div class="col-sm-12 title">Comparing: <span>{{= obj.whatToCompare }}</span></div>
				</div>
				{{ } }}
				{{ if (obj.showLivingIn == true) { }}
				<div class="row">
					<div class="col-sm-12 title">Property: <span>{{= obj.livingIn }}</span></div>
				</div>
				{{ } }}
				{{ if (obj.showElectricityUsage == true) { }}
				<div class="row electricityUsageContainer">
					<div class="col-sm-12 title">Electricity Usage:</div>
					<div class="col-sm-12">{{= obj.electricityUsage }}</div>
				</div>
				{{ } }}
				{{ if (obj.showGasUsage == true) { }}
				<div class="row gasUsageContainer">
					<div class="col-sm-12 title">Gas Usage:</div>
					<div class="col-sm-12">{{= obj.gasUsage }}</div>
				</div>
				{{ } }}
			</div>
		</div>
	</div>
	{{ } }}
</core_v1:js_template>