<%@ tag description="The Health Logo and Prices template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE --%>
<script id="price-itemisation-template" type="text/html">
	<%-- Decide whether to render the normal premium or the alt premium (for dual-pricing) --%>
	{{ var property = premium; if (obj.hasOwnProperty('showAltPremium') && obj.showAltPremium === true) { property = altPremium; } }}

	<div class="itemisedPricing">
		{{ if( typeof property.annually !== "undefined" ) { }}
		<div class="frequency annually {{= _selectedFrequency != 'annually' ? 'displayNone' : '' }}">
			{{ if(property.annually.value > 0 || property.annually.text.indexOf('$0.') < 0) { }}
				{{ if(property.annually.grossPremium.indexOf('$0.') < 0 ) { }}
					<div class="item row basePremium">
						<div class="col-xs-7 item-label-text">BASE PREMIUM</div>
						<div class="col-xs-5 item-value">{{= property.annually.grossPremium }}</div>
					</div>
				{{ } }}
				{{ if(property.annually.lhcPercentage > 0 && property.annually.hospitalValue > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">PLUS <strong>{{= property.annually.lhcPercentage }}% LHC LOADING</strong></div>
						<div class="col-xs-5 item-value">+ {{= property.annually.lhc }}</div>
					</div>
				{{ } }}
				{{ if(property.annually.rebate > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.annually.rebate }}% GOVERNMENT REBATE</strong></div>
						<div class="col-xs-5 item-value">- {{= property.annually.rebateValue }}</div>
					</div>
				{{ } }}
				{{ if(property.annually.discountPercentage > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.annually.discountPercentage }}% PAYMENT DISCOUNT*</strong></div>
						<div class="col-xs-5 item-value">- {{= property.annually.discountAmount }}</div>
					</div>
				{{ } }}
				<div class="item row totalPremium">
					<div class="col-xs-7 item-label-text">Total Premium</div>
					<div class="col-xs-5 item-value">{{= property.annually.text }}<span class="frequencyTitle">PER YEAR</span></div>
				</div>
				<div class="rounding">Premium may vary slightly due to rounding</div>
			{{ } else { }}
				<div class="item row totalPremium">Coming Soon</div>
			{{ } }}
		</div>
		{{ } }}
		{{ if( typeof property.halfyearly !== "undefined" ) { }}
		<div class="frequency halfyearly {{= _selectedFrequency != 'halfyearly' ? 'displayNone' : '' }}">
			{{ if(property.halfyearly.value > 0 || property.halfyearly.text.indexOf('$0.') < 0) { }}
				{{ if(property.halfyearly.grossPremium.indexOf('$0.') < 0 ) { }}
					<div class="item row basePremium">
						<div class="col-xs-7 item-label-text">BASE PREMIUM</div>
						<div class="col-xs-5 item-value">{{= property.halfyearly.grossPremium }}</div>
					</div>
				{{ } }}
				{{ if(property.halfyearly.lhcPercentage > 0 && property.halfyearly.hospitalValue > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">PLUS <strong>{{= property.halfyearly.lhcPercentage }}% LHC LOADING</strong></div>
						<div class="col-xs-5 item-value">+ {{= property.halfyearly.lhc }}</div>
					</div>
				{{ } }}
				{{ if(property.halfyearly.rebate > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.halfyearly.rebate }}% GOVERNMENT REBATE</strong></div>
						<div class="col-xs-5 item-value">- {{= property.halfyearly.rebateValue }}</div>
					</div>
				{{ } }}
				{{ if(property.halfyearly.discountPercentage > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.halfyearly.discountPercentage }}% PAYMENT DISCOUNT*</strong></div>
						<div class="col-xs-5 item-value">- {{= property.halfyearly.discountAmount }}</div>
					</div>
				{{ } }}
				<div class="item row totalPremium">
					<div class="col-xs-7 item-label-text">Total Premium</div>
					<div class="col-xs-5 item-value">{{= property.halfyearly.text }}<span class="frequencyTitle">PER HALF YEAR</span></div>
				</div>
				<div class="rounding">Premium may vary slightly due to rounding</div>
			{{ } else { }}
				<div class="item row totalPremium">Coming Soon</div>
			{{ } }}
		</div>
		{{ } }}
		{{ if( typeof property.quarterly !== "undefined" ) { }}
		<div class="frequency quarterly {{= _selectedFrequency != 'quarterly' ? 'displayNone' : '' }}">
			{{ if(property.quarterly.value > 0 || property.quarterly.text.indexOf('$0.') < 0) { }}
				{{ if(property.quarterly.grossPremium.indexOf('$0.') < 0 ) { }}
					<div class="item row basePremium">
						<div class="col-xs-7 item-label-text">BASE PREMIUM</div>
						<div class="col-xs-5 item-value">{{= property.quarterly.grossPremium }}</div>
					</div>
				{{ } }}
				{{ if(property.quarterly.lhcPercentage > 0 && property.quarterly.hospitalValue > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">PLUS <strong>{{= property.quarterly.lhcPercentage }}% LHC LOADING</strong></div>
						<div class="col-xs-5 item-value">+ {{= property.quarterly.lhc }}</div>
					</div>
				{{ } }}
				{{ if(property.quarterly.rebate > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.quarterly.rebate }}% GOVERNMENT REBATE</strong></div>
						<div class="col-xs-5 item-value">- {{= property.quarterly.rebateValue }}</div>
					</div>
				{{ } }}
				{{ if(property.quarterly.discountPercentage > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.quarterly.discountPercentage }}% PAYMENT DISCOUNT*</strong></div>
						<div class="col-xs-5 item-value">- {{= property.quarterly.discountAmount }}</div>
					</div>
				{{ } }}
				<div class="item row totalPremium">
					<div class="col-xs-7 item-label-text">Total Premium</div>
					<div class="col-xs-5 item-value">{{= property.quarterly.text }}<span class="frequencyTitle">PER QUARTER</span></div>
				</div>
				<div class="rounding">Premium may vary slightly due to rounding</div>
			{{ } else { }}
				<div class="item row totalPremium">Coming Soon</div>
			{{ } }}
		</div>
		{{ } }}
		{{ if( typeof property.monthly !== "undefined" ) { }}
		<div class="frequency monthly {{= _selectedFrequency != 'monthly' ? 'displayNone' : '' }}">
			{{ if(property.monthly.value > 0 || property.monthly.text.indexOf('$0.') < 0) { }}
				{{ if(property.monthly.grossPremium.indexOf('$0.') < 0 ) { }}
					<div class="item row basePremium">
						<div class="col-xs-7 item-label-text">BASE PREMIUM</div>
						<div class="col-xs-5 item-value">{{= property.monthly.grossPremium }}</div>
					</div>
				{{ } }}
				{{ if(property.monthly.lhcPercentage > 0 && property.monthly.hospitalValue > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">PLUS <strong>{{= property.monthly.lhcPercentage }}% LHC LOADING</strong></div>
						<div class="col-xs-5 item-value">+ {{= property.monthly.lhc }}</div>
					</div>
				{{ } }}
				{{ if(property.monthly.rebate > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.monthly.rebate }}% GOVERNMENT REBATE</strong></div>
						<div class="col-xs-5 item-value">- {{= property.monthly.rebateValue }}</div>
					</div>
				{{ } }}
				{{ if(property.monthly.discountPercentage > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.monthly.discountPercentage }}% PAYMENT DISCOUNT*</strong></div>
						<div class="col-xs-5 item-value">- {{= property.monthly.discountAmount }}</div>
					</div>
				{{ } }}
				<div class="item row totalPremium">
					<div class="col-xs-7 item-label-text">Total Premium</div>
					<div class="col-xs-5 item-value">{{= property.monthly.text }}<span class="frequencyTitle">PER MONTH</span></div>
				</div>
				<div class="rounding">Premium may vary slightly due to rounding</div>
			{{ } else { }}
				<div class="item row totalPremium">Coming Soon</div>
			{{ } }}
		</div>
		{{ } }}
		{{ if( typeof property.fortnightly !== "undefined" ) { }}
		<div class="frequency fortnightly {{= _selectedFrequency != 'fortnightly' ? 'displayNone' : '' }}">
			{{ if(property.fortnightly.value > 0 || property.fortnightly.text.indexOf('$0.') < 0) { }}
				{{ if(property.fortnightly.grossPremium.indexOf('$0.') < 0 ) { }}
					<div class="item row basePremium">
						<div class="col-xs-7 item-label-text">BASE PREMIUM</div>
						<div class="col-xs-5 item-value">{{= property.fortnightly.grossPremium }}</div>
					</div>
				{{ } }}
				{{ if(property.fortnightly.lhcPercentage > 0 && property.fortnightly.hospitalValue > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">PLUS <strong>{{= property.fortnightly.lhcPercentage }}% LHC LOADING</strong></div>
						<div class="col-xs-5 item-value">+ {{= property.fortnightly.lhc }}</div>
					</div>
				{{ } }}
				{{ if(property.fortnightly.rebate > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.fortnightly.rebate }}% GOVERNMENT REBATE</strong></div>
						<div class="col-xs-5 item-value">- {{= property.fortnightly.rebateValue }}</div>
					</div>
				{{ } }}
				{{ if(property.fortnightly.discountPercentage > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.fortnightly.discountPercentage }}% PAYMENT DISCOUNT*</strong></div>
						<div class="col-xs-5 item-value">- {{= property.fortnightly.discountAmount }}</div>
					</div>
				{{ } }}
				<div class="item row totalPremium">
					<div class="col-xs-7 item-label-text">Total Premium</div>
					<div class="col-xs-5 item-value">{{= property.fortnightly.text }}<span class="frequencyTitle">PER F/NIGHT</span></div>
				</div>
				<div class="rounding">Premium may vary slightly due to rounding</div>
			{{ } else { }}
				<div class="item row totalPremium">Coming Soon</div>
			{{ } }}
		</div>
		{{ } }}
		{{ if( typeof property.weekly !== "undefined" ) { }}
		<div class="frequency weekly {{= _selectedFrequency != 'weekly' ? 'displayNone' : '' }}">
			{{ if(property.weekly.value > 0 || property.weekly.text.indexOf('$0.') < 0) { }}
				{{ if(property.weekly.grossPremium.indexOf('$0.') < 0 ) { }}
					<div class="item row basePremium">
						<div class="col-xs-7 item-label-text">BASE PREMIUM</div>
						<div class="col-xs-5 item-value">{{= property.weekly.grossPremium }}</div>
					</div>
				{{ } }}
				{{ if(property.weekly.lhcPercentage > 0 && property.weekly.hospitalValue > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">PLUS <strong>{{= property.weekly.lhcPercentage }}% LHC LOADING</strong></div>
						<div class="col-xs-5 item-value">+ {{= property.weekly.lhc }}</div>
					</div>
				{{ } }}
				{{ if(property.weekly.rebate > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.weekly.rebate }}% GOVERNMENT REBATE</strong></div>
						<div class="col-xs-5 item-value">- {{= property.weekly.rebateValue }}</div>
					</div>
				{{ } }}
				{{ if(property.weekly.discountPercentage > 0 ) { }}
					<div class="item row">
						<div class="col-xs-7 item-label-text">LESS <strong>{{= property.weekly.discountPercentage }}% PAYMENT DISCOUNT*</strong></div>
						<div class="col-xs-5 item-value">- {{= property.weekly.discountAmount }}</div>
					</div>
				{{ } }}
				<div class="item row totalPremium">
					<div class="col-xs-7 item-label-text">Total Premium</div>
					<div class="col-xs-5 item-value">{{= property.weekly.text }}<span class="frequencyTitle">PER WEEK</span></div>
				</div>
				<div class="rounding">Premium may vary slightly due to rounding</div>
			{{ } else { }}
				<div class="item row totalPremium">Coming Soon</div>
			{{ } }}
		</div>
		{{ } }}
	</div>
</script>