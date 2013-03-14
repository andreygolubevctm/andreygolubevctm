<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="field_frequency" value="${xpath}/frequency" />
<c:set var="field_frequency" value="${go:nameFromXpath(field_frequency)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-payment_details">

	<form:fieldset legend="Your payment details" >

		<div class="definition"><%-- insert promo data --%></div>

		<health:calendar xpath="${xpath}" />

		<form:row label="How would you like to make your payments">
			<field:array_radio items="cc=Credit Card,ba=Bank Account" xpath="${xpath}/type" title="how would you like to pay" required="true" className="health-payment_details-type" id="${name}_type"/>
		</form:row>

		<%-- Note: this form row's HTML is changed by JavaScript --%>
		<form:row label="How often would you like to make payments">
			<field:array_select items="=Please choose..." xpath="${xpath}/frequency" title="frequency of payments" required="true" delims="||" className="health-payment_details-frequency" />
		</form:row>
		
		<form:row label="Do you want to supply bank account details for claims to be paid into" className="health-payment_details-claims-group">
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/claims" title="if you want to supply bank account details for claims to be paid into" required="true" className="health-payment_details-claims" id="${name}_claims"/>
		</form:row>			

		<form:row label="" className="health-payment-details_update">
			<a href="javascript:void(0);" class="button warn" id="update-step"><span>Update premium</span></a>
		</form:row>

		<form:row label="Your premium" className="health-payment-details_premium">
			<div id="update-premium">
				<span id="health_payment_details_premiumMessage">Premium may vary slightly due to rounding</span>
				<div class="premium"><strong><%-- Price goes here --%></strong><em><%-- Frequency goes here --%></em></div>
			</div>
		</form:row>

	</form:fieldset>

</div>


<%-- CSS --%>
<go:style marker="css-head">
.health-payment-details_update, .health-payment-details_premium {
	min-height:0px;
}
.health-payment-details_premium .fieldrow_label {
	font-weight:bold;
}
.health-payment_details-claims-group {
	display:none;
}
#${name}_next {
	clear:both;
	padding-top:20px;
	padding-bottom:10px;
	color:#EC5400;
}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var paymentSelectsHandler = {

	_premiumInfo: false,

	init: function(){
		paymentSelectsHandler.resetFrequencyCheck();
		paymentSelectsHandler.updatePaymentDayOptions();
		paymentSelectsHandler.claimsAccount();		
	},
	
	resetFrequencyCheck: function(){
		paymentSelectsHandler.bank = { 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.frequency = { 'weekly':27, 'fortnightly':31, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 };
		paymentSelectsHandler.creditBankSupply = false;
		paymentSelectsHandler.creditBankQuestions = false;
	},	

	setPremiumInfo: function()
	{
		paymentSelectsHandler._premiumInfo = false;

		var product = Results.getSelectedProduct();

		if( product != false )
		{
			var product = product.premium;
			paymentSelectsHandler._premiumInfo = {
				weekly:			!product.hasOwnProperty('') || isNaN(product.weekly.value) || product.weekly.value == 0 ? false : product.weekly.text,
				fortnightly:	!product.hasOwnProperty('') || isNaN(product.fortnightly.value) || product.fortnightly.value == 0 ? false : product.fortnightly.text,
				monthly:		!product.hasOwnProperty('') || isNaN(product.monthly.value) || product.monthly.value == 0 ? false : product.monthly.text,
				quarterly:		!product.hasOwnProperty('') || isNaN(product.quarterly.value) || product.quarterly.value == 0 ? false : product.quarterly.text,
				halfyearly:		!product.hasOwnProperty('') || isNaN(product.halfyearly.value) || product.halfyearly.value == 0 ? false : product.halfyearly.text,
				annually:		!product.hasOwnProperty('') || isNaN(product.annually.value) || product.annually.value == 0 ? false : product.annually.text
			}
		}
	},

	updateSelect: function() {
		paymentSelectsHandler.setPremiumInfo();
		paymentSelectsHandler.frequencyCheck(); <%-- Make sure that the allowed frequency is kept --%>
	},

	updatePaymentDayOptions: function() {
		<%-- Switch the selected frequency to recreate the day --%>
		switch( $("#${field_frequency}").val() ) {
			case 'W':
				var option_count = paymentSelectsHandler.frequency.weekly;
				break;
		   	case 'F':
		      	var option_count = paymentSelectsHandler.frequency.fortnightly;
		      	break;
		   	case 'M':
		      	var option_count = paymentSelectsHandler.frequency.monthly;
		      	break;
			case 'Q':
				var option_count = paymentSelectsHandler.frequency.quarterly;
				break;
			case 'H':
				var option_count = paymentSelectsHandler.frequency.halfyearly;
				break;
		   	case 'A':
		      	var option_count = paymentSelectsHandler.frequency.annually;
		      	break;			      	
		   	default:			      	
		   		var option_count = 27; <%-- This is the known minimum --%>
		      	break;
		};
		
		var selected_bank_day = $("#health_payment_bank_day").val();
		var selected_credit_day = $("#health_payment_credit_day").val();

		$("#health_payment_bank_day").empty().append("<option value>Please choose...</option>");
		$("#health_payment_credit_day").empty().append("<option value>Please choose...</option>");
		for(var i=1; i <= option_count; i++)
		{
			$("#health_payment_bank_day").append("<option id='health_payment_bank_day_" + i + "' value='" + i + "'>" + i + "<" + "/option>");
			$("#health_payment_credit_day").append("<option id='health_payment_credit_day_" + i + "' value='" + i + "'>" + i + "<" + "/option>");
		}

		if( selected_bank_day ) {
			$("#health_payment_bank_day").val( selected_bank_day );
		}

		if( selected_credit_day ) {
			$("#health_payment_credit_day").val( selected_credit_day );
		}
	},

	<%-- Show approved listings only, this can potentially change per fund  --%>
	frequencyCheck: function(){

		var $_obj = $('#${name}_frequency');

		if( $('#${name}_type').find('input:checked').val() == 'cc' ){
			var method = paymentSelectsHandler.credit;
		} else if( $('#${name}_type').find('input:checked').val() == 'ba' ) {
			var method = paymentSelectsHandler.bank;
		} else {
			return;
		};
		
		var _html = '<option id="${name}_frequency_" value="">Please choose...</option>';
		var _selected = $_obj.find(':selected').val();

		<%-- Weekly Check --%>
		if( method.weekly === true && paymentSelectsHandler._premiumInfo.weekly != '' ){
			_html += '<option id="${name}_frequency_W" value="W">Weekly</option>';
		};
		<%-- Fortnightly Check --%>
		if( method.fortnightly === true && paymentSelectsHandler._premiumInfo.fortnightly != '' ){
			_html += '<option id="${name}_frequency_F" value="F">Fortnightly</option>';
		};
		<%-- Monthly Check --%>
		if( method.monthly === true && paymentSelectsHandler._premiumInfo.monthly != '' ){
			_html += '<option id="${name}_frequency_M" value="M">Monthly</option>';
		};
		<%-- Quarterly Check --%>
		if( method.quarterly === true && paymentSelectsHandler._premiumInfo.quarterly != '' ){
			_html += '<option id="${name}_frequency_Q" value="Q">Quarterly</option>';
		};
		<%-- HalfYearly Check --%>
		if( method.halfyearly === true && paymentSelectsHandler._premiumInfo.halfyearly != '' ){
			_html += '<option id="${name}_frequency_H" value="H">Half-yearly</option>';
		};
		<%-- Annually Check --%>
		if( method.annually === true || paymentSelectsHandler._premiumInfo.annually != ''){
			_html += '<option id="${name}_frequency_A" value="A">Annually</option>';
		};
		
		$_obj.html( _html ).find('option[value='+ _selected +']').attr('selected', 'SELECTED');
		
		paymentSelectsHandler.updatePaymentDayOptions(); //re-set the days if required
		return;
	},

	<%-- Switch the option objects on/off --%>
	_frequencySwitch: function($_parent, $_child, _flag){
		if(_flag == 'off'){
			if( $_child.is(':selected') ){
				$_parent.val(['']); //clear the parent for IE
			};
			$_child.addClass('disabled').prop('disabled', true).hide();
		} else {
			$_child.removeClass('disabled').prop('disabled',false).show();
		};
	},
	
	getFrequency: function(){
		if( Health._mode == 'confirmation' ){
			return Health._confirmation.data.frequency;
		} else {
			return $('#${name}_frequency').val();
		};		
	},
	
	getType: function(){
		return $('#${name}_type').find(':input:checked').val();
	},
	
	<%-- Check if details for the claims bank account needs to be shown --%>
	claimsAccount: function(){
	
		<%-- Questions are not wanted - so hide them --%>
		if( !paymentSelectsHandler.creditBankQuestions  ||  ( paymentSelectsHandler.creditBankSupply && $('.health-payment_details-claims-group').find('input:checked').val() == 'N' ) ){
			paymentSelectsHandler._renderClaims(false, false);
			return;
		};
		
		<%-- Render based on the questions --%>
		var _type = paymentSelectsHandler.getType();		
		
		if( _type == 'cc'  ||  (_type == 'ba' && $('.health_bank-details_claims_group').find('input:checked').val() == 'N'  ) ){
			paymentSelectsHandler._renderClaims(true, true); <%-- claim account is not the same as current bank or credit card is shown --%>
		} else {
			paymentSelectsHandler._renderClaims(true, false); <%-- claims account the same as current bank, or no type yet selected --%>
		};

	},
	
	<%-- Render the claims details --%>	
	_renderClaims: function(_claimsQuestion, _claimsDetails){
		<%-- Claims Form Details --%>
		if( _claimsDetails ) {
			$('.health-bank_claim_details').slideDown();
		} else {
			$('.health-bank_claim_details').slideUp('','', function(){ $(this).hide(); });
		};
		<%-- Claims Question (in Bank) --%>
		if( _claimsQuestion ) {
			$('.health_bank-details_claims_group').slideDown();
		} else {
			$('.health_bank-details_claims_group').slideUp('','', function(){ $(this).hide(); });
		};		
	}
	
	
};
</go:script>

<go:script marker="onready">
	$(function() {
		$("#${name}_type, #${name}_claims").buttonset();
	});

	paymentSelectsHandler.init(); //Note the update function is called from the results page

	// Call to update the payment frequency select options
	// ===================================================
	slide_callbacks.register({
		mode:		'after',
		slide_id:	4,
		callback:	function() {
			$('#summary-header:visible').hide();
			$("#promotions-footer:visible").hide();
			$('#steps:hidden').show();
		}
	});
	
	$("#${name}_start").on('change', function(){
		healthPolicyDetails.startDate();
	});
	$("#${name}_frequency").on('change', function(){
		paymentSelectsHandler.frequencyCheck();
		healthPolicyDetails.changeFrequency();
		healthPolicyDetails.error();
	});
	$("#${name}_type").find('input').on('change', function(){
		paymentSelectsHandler.frequencyCheck();
		healthPolicyDetails.changeFrequency();
		healthPolicyDetails.error();
		paymentSelectsHandler.claimsAccount();
	});
	
	$("#${name}_claims").find('input').on('change', function(){
		paymentSelectsHandler.claimsAccount();
	});
	
	$('#${name}_next').find('a').on('click', function(){
		$('#more_snapshot').dialog("open").dialog({ 'dialogClass':'show-close', 'dialogTab':2 });
	});	
	  
	<%-- Bind the same next-step function to confirm price --%>
	$('#confirm-step').on('click', function(){ 
		$('#next-step').trigger('click');
	});
	
</go:script>
