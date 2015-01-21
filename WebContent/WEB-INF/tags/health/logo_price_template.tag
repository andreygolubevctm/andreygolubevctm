<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE --%>
<script id="logo-price-template" type="text/html">
	<%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
	{{ var property = premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = altPremium; } }}

	<div class="companyLogo {{= info.provider }}"></div>
	<div class="price premium">
		{{ if( typeof property.annually !== "undefined" ) { }}
		<div class="frequency annually {{= _selectedFrequency != 'annually' ? 'displayNone' : '' }}" data-text="{{= property.annually.text }}" data-lhcfreetext="{{= property.annually.lhcfreetext }}">
			{{ if(property.annually.value > 0 || property.annually.text.indexOf('$0.') < 0) { }}
				<div class="frequencyAmount">
					{{= typeof mode === "undefined" || mode != "lhcInc" ? property.annually.lhcfreetext : property.annually.text }}
					<span class="frequencyTitle">PER YEAR</span>
				</div>
				<div class="lhcText">{{= typeof mode === "undefined" || mode != "lhcInc" ? property.annually.lhcfreepricing : property.annually.pricing }}</div>
			{{ } else { }}
				<div class="frequencyAmount">Coming Soon</div>
			{{ } }}
			<div class="rounding">Premium may vary slightly due to rounding</div>
		</div>
		{{ } }}
		{{ if( typeof property.halfyearly !== "undefined" ) { }}
		<div class="frequency halfyearly {{= _selectedFrequency != 'halfyearly' ? 'displayNone' : '' }}" data-text="{{= property.halfyearly.text }}" data-lhcfreetext="{{= property.halfyearly.lhcfreetext }}">
			{{ if(property.halfyearly.value > 0 || property.halfyearly.text.indexOf('$0.') < 0) { }}
				<div class="frequencyAmount">
					{{= typeof mode === "undefined" || mode != "lhcInc" ? property.halfyearly.lhcfreetext : property.halfyearly.text }}
					<span class="frequencyTitle">PER HALF YEAR</span>
				</div>
				<div class="lhcText">{{= typeof mode === "undefined" || mode != "lhcInc" ? property.halfyearly.lhcfreepricing : property.halfyearly.pricing }}</div>
			{{ } else { }}
				<div class="frequencyAmount">Coming Soon</div>
			{{ } }}
			<div class="rounding">Premium may vary slightly due to rounding</div>
		</div>
		{{ } }}
		{{ if( typeof property.quarterly !== "undefined" ) { }}
		<div class="frequency quarterly {{= _selectedFrequency != 'quarterly' ? 'displayNone' : '' }}" data-text="{{= property.quarterly.text }}" data-lhcfreetext="{{= property.quarterly.lhcfreetext }}">
			{{ if(property.quarterly.value > 0 || property.quarterly.text.indexOf('$0.') < 0) { }}
				<div class="frequencyAmount">
					{{= typeof mode === "undefined" || mode != "lhcInc" ? property.quarterly.lhcfreetext : property.quarterly.text }}
					<span class="frequencyTitle ">PER QUARTER</span>
				</div>
				<div class="lhcText">{{= typeof mode === "undefined" || mode != "lhcInc" ? property.quarterly.lhcfreepricing : property.quarterly.pricing }}</div>
			{{ } else { }}
				<div class="frequencyAmount">Coming Soon</div>
			{{ } }}
			<div class="rounding">Premium may vary slightly due to rounding</div>
		</div>
		{{ } }}
		{{ if( typeof property.monthly !== "undefined" ) { }}
		<div class="frequency monthly {{= _selectedFrequency != 'monthly' ? 'displayNone' : '' }}" data-text="{{= property.monthly.text }}" data-lhcfreetext="{{= property.monthly.lhcfreetext }}">
			{{ if(property.monthly.value > 0 || property.monthly.text.indexOf('$0.') < 0) { }}
				<div class="frequencyAmount">
					{{= typeof mode === "undefined" || mode != "lhcInc" ? property.monthly.lhcfreetext : property.monthly.text }}
					<span class="frequencyTitle ">PER MONTH</span>
				</div>
				<div class="lhcText">{{= typeof mode === "undefined" || mode != "lhcInc" ? property.monthly.lhcfreepricing : property.monthly.pricing }}</div>
			{{ } else { }}
				<div class="frequencyAmount">Coming Soon</div>
			{{ } }}
			<div class="rounding">Premium may vary slightly due to rounding</div>
		</div>
		{{ } }}
		{{ if( typeof property.fortnightly !== "undefined" ) { }}
		<div class="frequency fortnightly {{= _selectedFrequency != 'fortnightly' ? 'displayNone' : '' }}" data-text="{{= property.fortnightly.text }}" data-lhcfreetext="{{= property.fortnightly.lhcfreetext }}">
			{{ if(property.fortnightly.value > 0 || property.fortnightly.text.indexOf('$0.') < 0) { }}
				<div class="frequencyAmount">
					{{= typeof mode === "undefined" || mode != "lhcInc" ? property.fortnightly.lhcfreetext : property.fortnightly.text }}
					<span class="frequencyTitle ">PER F/NIGHT</span>
				</div>
				<div class="lhcText">{{= typeof mode === "undefined" || mode != "lhcInc" ? property.fortnightly.lhcfreepricing : property.fortnightly.pricing }}</div>
			{{ } else { }}
				<div class="frequencyAmount">Coming Soon</div>
			{{ } }}
			<div class="rounding">Premium may vary slightly due to rounding</div>
		</div>
		{{ } }}
		{{ if( typeof property.weekly !== "undefined" ) { }}
		<div class="frequency weekly {{= _selectedFrequency != 'weekly' ? 'displayNone' : '' }}" data-text="{{= property.weekly.text }}" data-lhcfreetext="{{= property.weekly.lhcfreetext }}">
			{{ if(property.weekly.value > 0 || property.weekly.text.indexOf('$0.') < 0) { }}
				<div class="frequencyAmount">
					{{= typeof mode === "undefined" || mode != "lhcInc" ? property.weekly.lhcfreetext : property.weekly.text }}
					<span class="frequencyTitle ">PER WEEK</span>
				</div>
				<div class="lhcText">{{= typeof mode === "undefined" || mode != "lhcInc" ? property.weekly.lhcfreepricing : property.weekly.pricing }}</div>
			{{ } else { }}
				<div class="frequencyAmount">Coming Soon</div>
			{{ } }}
			<div class="rounding">Premium may vary slightly due to rounding</div>
		</div>
		{{ } }}
	</div>
</script>