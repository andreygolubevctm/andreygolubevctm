<%@ tag language="java" pageEncoding="ISO-8859-1" %>
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
		<div class="premium week"><strong>[#= premium.weekly.text #]</strong> <span class="frequency">Per Week</span></div>
		<div class="pricing">[#= premium.weekly.pricing #]</div>
	</div>
	<div class="fortnight">
		<div class="premium"><strong>[#= premium.fortnightly.text #]</strong> <span class="frequency">Per Fortnight</span></div>
		<div class="pricing">[#= premium.fortnightly.pricing #]</div>
	</div>
	<div class="month">
		<div class="premium month"><strong>[#= premium.monthly.text #]</strong> <span class="frequency">Per Month</span></div>
		<div class="pricing">[#= premium.monthly.pricing #]</div>
	</div>
	<div class="quarter">
		<div class="premium quarter"><strong>[#= premium.quarterly.text #]</strong> <span class="frequency">Per Quarter</span></div>
		<div class="pricing">[#= premium.quarterly.pricing #]</div>		
	</div>
	<div class="halfyear">
		<div class="premium halfyear"><strong>[#= premium.halfyearly.text #]</strong> <span class="frequency">Per Half-Year</span></div>
		<div class="pricing">[#= premium.halfyearly.pricing #]</div>
	</div>
	<div class="annual">
		<div class="premium year"><strong>[#= premium.annually.text #]</strong> <span class="frequency">Per Year</span></div>
		<div class="pricing">[#= premium.annually.pricing #]</div>		
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
</core:js_template>




<%-- JAVASCRIPT --%>
<go:script marker="js-head">

healthPolicyDetails = {
	messagePriceChange: 'You have made changes that will possibly affect your policy price',
	messageFinal: 'Your premium',
	
	init: function(){
		this.$_obj = $('#policy_details');
		return;
	},
	create: function(){
		this.changeFrequency();
		this.clearError();
		this.render();
		this.$_obj.slideDown();
		return;
	},
	destroy: function(){
		this.$_obj.slideUp();
		this.clearError();
		return;
	},
	<%-- Show/hide the selected pricing category and populate ready for the application call --%>
	changeFrequency: function(){
	
		healthPolicyDetails.$_obj.removeClass('week fortnight month annual halfyear quarter');
		
		var freq = paymentSelectsHandler.getFrequency();
		
		switch( freq )
		{
			case 'W':
				healthPolicyDetails.$_obj.addClass('week');
				healthApplicationDetails.periods = 52;
				healthApplicationDetails.premium = Results._selectedProduct.premium.weekly.value;
				break;
			case 'F':
				healthPolicyDetails.$_obj.addClass('fortnight');
				healthApplicationDetails.periods = 26;
				healthApplicationDetails.premium = Results._selectedProduct.premium.fortnightly.value;
				break;
			case 'Q':
				healthPolicyDetails.$_obj.addClass('quarter');
				healthApplicationDetails.periods = 4;
				healthApplicationDetails.premium = Results._selectedProduct.premium.quarterly.value;
				break;
			case 'H':
				healthPolicyDetails.$_obj.addClass('halfyear');
				healthApplicationDetails.periods = 2;
				healthApplicationDetails.premium = Results._selectedProduct.premium.halfyearly.value;
				break;
			case 'A':
				healthPolicyDetails.$_obj.addClass('annual');
				healthApplicationDetails.periods = 1;
				healthApplicationDetails.premium = Results._selectedProduct.premium.annually.value;
				break;
			default:
				healthPolicyDetails.$_obj.addClass('month');
				healthApplicationDetails.periods = 12;
				healthApplicationDetails.premium = Results._selectedProduct.premium.monthly.value;
				break;
		};
		
		if( altPremium.exists() && $("#policy_details").hasClass("hasAltPremium") ) {
			var ap = Results.getSelectedAltPremium();
			$("#policy_details").find("span.apd_content").each(function(){
				$(this).empty().append( altPremium.getHTML(ap) );
			});
		}
	},	
	render: function(){
		if( typeof Results._selectedProduct == 'undefined' ){
			return false;
		};
		
		var product = $.extend({
				altPremiumContent : altPremium.getHTML(Results._selectedProduct.altPremium.monthly)
		}, Results._selectedProduct);
		
		<%-- Merge the policy data --%>
		var $_T_panel = $(parseTemplate( $("#policy-details-template").html(), product ));		
				
		this.$_obj.find('.data').html( $_T_panel );
		
		<%-- If Hospital or Combined add the excess info --%>
		if(Results._selectedProduct.info.ProductType != 'GeneralHealth'){
			var $_T_extras = $(parseTemplate( $("#policy-details-extras-template").html(), product.hospital.inclusions ));
			this.$_obj.find('.data ul').append( $_T_extras );
		};
		
		<%-- Add alt premium content if require --%>
		if( altPremium.exists() ) {
			$('#policy_details').addClass("hasAltPremium");
			healthPolicyDetails.changeFrequency();
		} else {
			$('#policy_details').removeClass("hasAltPremium");
		}
		
		<%-- Add the start date (not found in object) --%>
		this.startDate();
	},
	startDate: function(){
		if(Health._mode == 'confirmation'){
			var _date = Health._confirmation.data.startDate;
		} else {
			var _date = $('#mainform').find('.basic_date').not('.error').val();	
		};
		
		if( _date == '' ){
			this.$_obj.find('.start span').text('Please confirm');
		} else {
			this.$_obj.find('.start span').text( _date );
		};
	},
	error: function(){
		this.$_obj.find('.message').text(healthPolicyDetails.messagePriceChange);
		healthPayment.priceChange();
	},
	final: function(){
		this.$_obj.find('.message').text(healthPolicyDetails.messageFinal);
	},
	clearError: function(){
		this.$_obj.find('.message').empty();
	}
}

</go:script>

<go:script marker="onready">
	healthPolicyDetails.init();
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#policy_details {
		display:none;
	}
	#policy_details .week,
	#policy_details .fortnight,
	#policy_details .month,
	#policy_details .quarter,
	#policy_details .halfyear,
	#policy_details .annual {
		display:none;
	}
	#policy_details.week .week,
	#policy_details.fortnight .fortnight,
	#policy_details.annual .annual,
	#policy_details.quarter .quarter,
	#policy_details.halfyear .halfyear,
	#policy_details.month .month {
		display:block;
	}
</go:style>