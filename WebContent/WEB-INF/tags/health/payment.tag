<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"  	rtexprvalue="true"	 description="optional id for this slide"%>
<%@ attribute name="className" 	required="false"  	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  	rtexprvalue="true"	 description="optional id for this slide"%>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div class="health-payment ${className}" id="${id}">

	<health:payment_details xpath="${xpath}/details" />

	<%-- This content will be turned on/off with the main update button --%>
	<div id="update-content">
		<health:popup_payment_external xpath="${xpath}/gateway" />
		<health:application_compliance xpath="${xpath}" />
		<health:medicare_details xpath="${xpath}/medicare" />
	</div>
	 
</div>

<%-- JAVASCRIPT --%>

<go:script marker="js-head">
var healthPayment = {

	<%-- Resets the payment status --%>
	reset: function(){
		healthPayment._premium(false);
		healthPayment._appQuestions(false);	
	},

	<%-- The price has potentially changed so the hidden items need to fold up --%>
	priceChange: function(){
		healthPayment._appQuestions(false);
		healthPayment._showUpdate();		
		healthPayment._premium(false);
	},
	
	<%-- See whether or not the update button should be seen - check the last two questions that can change the price!!! or if the confirm (submit) button is visible --%>
	_showUpdate: function(){
		if( $('#health_payment_details_frequency').find(':selected').val() == '' || $('#health_payment_details_type').find('input:checked').length == 0 || $('#confirm-step').is(':visible') ) {			
			$('#${name}_details-selection').find('.health-payment-details_update').slideUp('fast');
			$('#update-step').hide();	
		} else {
			$('#update-step').show();
			$('#${name}_details-selection').find('.health-payment-details_update').slideDown('fast');			
		};
	},
	
	<%-- Show/Hide the application questions --%>
	_appQuestions: function(_flag){
		if(!_flag){			
			$('#confirm-step').hide();
			$('#update-content, #health_declaration-selection').slideUp('fast');
		} else {			
			$('#update-content, #confirm-step, #health_declaration-selection').slideDown('slow');
		};
	},
	
	<%-- Update the premium price display --%>
	_premium: function(_flag){		
		if(!_flag){
			<%-- Clean out the payment frequencies --%>
			$('#${name}_details-selection').find('.health-payment-details_premium').slideUp();
			$('#update-premium').find('strong, em').text('');
			$('#update-premium').removeClass("hasAltPremium");
			return;
		} else {
			<%-- Get the payment premium and frequency and display  --%>			
			var J_obj = Results.getSelectedPremium();
			var apObj = Results.getSelectedAltPremium();

			<%-- Add alt premium content if require --%>
			if( altPremium.exists() ) {
				$('#update-premium').addClass("hasAltPremium");
				$("#update-premium").find(".altPremiumDisplay:first").empty().append(altPremium.getHTML(apObj, true));
				$("#policy_details").find(".altPremiumDisplay").each(function(){
					$(this).empty().append(altPremium.getHTML(apObj, true));
				});
				$("#snapshotSide").find(".altPremiumDisplay").each(function(){
					$(this).empty().append(altPremium.getHTML(apObj, true));
				});
			} else {
				$('#update-premium').removeClass("hasAltPremium");
			}
		
			$('#update-premium').find('strong').text( J_obj.text );
			$('#update-premium').find('em').text( J_obj.label );
			$('#update-premium .premium').attr( "data-text", J_obj.text );
			$('#update-premium .premium').attr( "data-lhcfreetext", J_obj.lhcfreetext );
			Results._refreshSimplesTooltipContent($('#update-premium .premium'));
			$('#update-premium .update-premium-pricing').html( J_obj.pricing );
			<c:if test="${not empty callCentre}">$('#update-premium .update-premium-pricing').append(' (' + Results.getLoading() + '%)');</c:if>
			$('#${name}_details-selection').find('.health-payment-details_premium').slideDown();
			healthPayment._showUpdate();
			return;
		};
	},

	<%-- This calls the last piece of premium functionality and displays the last price!!!! --%>
	updatePrice: function(){		
	
		if( !QuoteEngine.validate() ){
			Loading.hide();
			return false;
		};
		
		if( Health.ajaxPendingSingle ){
			Loading.hide();
			return; //one already running
		};
		
		var _success = Health.fetchPrice(false);
				
		<%-- --%>		
		if( !_success ){
			Loading.hide(function(){
				Popup.show("#update-premium-error", "#loading-overlay");
			});
			delete healthPayment._loadAjax;
			<%-- ***FIX: add a fatal error log here... --%>
		} else {
			<%-- Re-Render everything to do with the price functionality --%>
			Results.jsonExpand(Results._selectedProduct);
			Results.renderApplication();
			
			<%-- Show buttons and final price --%>
			healthPolicyDetails.final();
			healthPayment._updatePriceEnd();
		};		
		
	},
	
	_updatePriceEnd: function(){
		healthPayment._appQuestions(true);
		healthPayment._premium(true);
		Loading.hide();
	}
};


<%-- Registering the slide for when user tabs back --%>
slide_callbacks.register({
	mode:	   'before',
	direction: 'forward',
	slide_id:	4,
	callback:	function() {
		Health.setRates();
	}
});

</go:script>


<go:script marker="onready">
	<%-- TOGGLE: Bank or CC panel--%>
	$('#${name}_details_type').on('change', function() {
		if( $('input[name=${name}_details_type]:checked').val() == 'cc' ) {
			$('#${name}_credit-selection').slideDown();
			$('#${name}_bank-selection').slideUp('','', function(){ $(this).hide(); });
		} else {
			$('#${name}_bank-selection').slideDown();
			$('#${name}_credit-selection').slideUp('','', function(){ $(this).hide(); });
		};
	});	
		
	$("#update-premium-error .close-error, #update-premium-error-overlay").first().on("click", function(){
		Popup.hide("#update-premium-error");
	});
	
	<%-- Update price when it's clicked --%>
	$('#update-step').on('click', function(){
		Loading.show();
		healthPayment.updatePrice();
	});	
	
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	.health-credit_card_details, .health-bank_details {
		display:none;
	}	
	#update-content, #confirm-step, .health-payment-details_premium,
	.health_declaration, .health-payment-details_update {
		display:none;
	}
	
	#update-premium-error p {
		padding:	0 15px 5px 15px;
	}
</go:style>