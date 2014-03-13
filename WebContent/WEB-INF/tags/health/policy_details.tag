<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Policy details summary panel"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- HTML --%>
<div id="policy_details" class="health_policy_details right-panel">
	<div class="header"></div>	
	<div class="middle">
		<h3>Your policy details</h3>
		<div class="message"></div>		
		<div class="data"><%-- TEMPLATE AREA --%></div>		
		<a href="javascript:void(0);" class="more">More info</a>		
	</div>
	<div class="footer"></div>
</div>


<%-- TEMPLATE: MAIN --%>
<core:js_template id="policy-details-template">
	<div class="thumb"><img src="common/images/logos/health/[#= info.provider #].png" alt="[#= info.provider #]"/></div>
	<div class="week">
		<div class="premium week" data-text="[#= premium.weekly.text #]" data-lhcfreetext="[#= premium.weekly.lhcfreetext #]">
			<strong>[#= premium.weekly.lhcfreetext #]</strong> <span class="frequency">Per Week</span>
		</div>
		<div class="pricing">[#= premium.weekly.lhcfreepricing #]</div>
	</div>
	<div class="fortnight">
		<div class="premium fortnight" data-text="[#= premium.fortnightly.text #]" data-lhcfreetext="[#= premium.fortnightly.lhcfreetext #]">
			<strong>[#= premium.fortnightly.lhcfreetext #]</strong>
			<span class="frequency">Per Fortnight</span>
		</div>
		<div class="pricing">[#= premium.fortnightly.lhcfreepricing #]</div>
	</div>
	<div class="month">
		<div class="premium month" data-text="[#= premium.monthly.text #]" data-lhcfreetext="[#= premium.monthly.lhcfreetext #]">
			<strong>[#= premium.monthly.lhcfreetext #]</strong>
			<span class="frequency">Per Month</span>
		</div>
		<div class="pricing">[#= premium.monthly.lhcfreepricing #]</div>
	</div>
	<div class="quarter">
		<div class="premium quarter" data-text="[#= premium.quarterly.text #]" data-lhcfreetext="[#= premium.quarterly.lhcfreetext #]">
			<strong>[#= premium.quarterly.lhcfreetext #]</strong> <span class="frequency">Per Quarter</span>
		</div>
		<div class="pricing">[#= premium.quarterly.lhcfreepricing #]</div>		
	</div>
	<div class="halfyear">
		<div class="premium halfyear" data-text="[#= premium.halfyearly.text #]" data-lhcfreetext="[#= premium.halfyearly.lhcfreetext #]">
			<strong>[#= premium.halfyearly.lhcfreetext #]</strong> <span class="frequency">Per Half-Year</span>
		</div>
		<div class="pricing">[#= premium.halfyearly.lhcfreepricing #]</div>
	</div>
	<div class="annual">
		<div class="premium year" data-text="[#= premium.annually.text #]" data-lhcfreetext="[#= premium.annually.lhcfreetext #]"><strong>[#= premium.annually.lhcfreetext #]</strong> <span class="frequency">Per Year</span></div>
		<div class="pricing">[#= premium.annually.lhcfreepricing #]</div>		
	</div>
	<health:alt_premium />
	<h4 class="fund">[#= info.name #]</h4>
	<ul>
		<li class="start">Start date: <span></span></li>
	</ul>	
</core:js_template>


<%-- TEMPLATE: POLICY EXTRAS --%>
<core:js_template id="policy-details-extras-template">
	<li class="excess">Excess: <span>[#= excess #]</span></li>
	<li class="waivers">Excess Waivers: <span>[#= waivers #]</span></li>
	<li class="waivers">Co-payment / % Hospital Contribution: <span>[#= copayment #]</span></li>
</core:js_template>