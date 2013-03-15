<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<div id="utilities-confirmation" class="utilities-confirmation">
	<div class="wrapper">
		<div class="column left">
			<div class="inner left">
				<div class="panel nobdr lgetxt">
					<div id="thank_you"></div>
				</div>
			</div>
			<div class="inner left">
				<div class="panel nobdr lgetxt">
					<form:scrape id="1" />
				</div>
			</div>
		</div>
		<div class="column right">
			<div id="orderNoContainer">
				<div id="orderNoTitle">Order Number</div>
				<h2 id="orderNo"> </h2>
				Please note your order no. for future reference
			</div>
			<agg:panel>
				<p><strong>Compare</strong>the<strong>market</strong>.com.au is an online comparison website. Energy product information is provided by our trusted affiliate, Switchwise Pty Ltd.</p>
				<div id="logo-switchwise"><img src="common/images/logos/utilities/switchwise-logo.gif" alt="Switchwise Logo" title="Switchwise Logo" /></div>
				<core:clear />
			</agg:panel>
			
			<agg:panel>
				<form:scrape id="2" />
			</agg:panel>
		</div>
	</div>
</div>

<core:js_template id="move-template">
	<p><strong>Thank you</strong> for choosing <strong>compare</strong>the<strong>market</strong>.com.au (powered by Switchwise) to help you save on your energy bills.</p>
	<p>Your [#= selected_utilities #] connection request for [#= moving_date #] with [#= provider #] has been received. An email confirmation of your application details will be sent to the email address you provided.</p>
	[#= provider_text #]
	<p>If there are any issues with your connection request [#= provider #] might need to speak to you; if they are unable to contact you your connection request might not be processed.</p> 
	[#= state_text #]
	<p>Remember to tell your current energy supplier(s) that you are moving out of your current home and that you would like the power and/or gas to be disconnected on the date you move out.</p> 
	<p>You have a 10 business day cooling-off period if you change your mind. </p>
	<p>Best of luck with your move!</p>
</core:js_template>

<core:js_template id="move-provider-dodo-template">
	<p>Switchwise will send your connection request to Dodo Power & Gas and they should contact you within 1 business day to collect your payment details. If you do not hear from them within one business day please contact them directly on 13 dodo (13 36 36). Please note that if you do not speak to Dodo Power & Gas and provide your payment details your connection request will not be processed.</p>
</core:js_template>

<core:js_template id="move-provider-template">
	<p>Switchwise will send your connection request to [#= provider #]. If your connection request is approved by [#= provider #] they will send a letter and a welcome pack to your postal address. The welcome pack will confirm the tariffs applicable to your property and include details of your energy agreement.</p>
</core:js_template>

<core:js_template id="move-state-qld-template">
	<p>If you find that the power is off at your new property when you move-in please call [#= provider #] on [#= info.CallRetailerPhone #] as soon as possible to arrange a time for an Energex representative to visit your property to reconnect the power.  If an Energex technician does need to attend you will need to be home for the connection to take place.</p>
</core:js_template>

<core:js_template id="move-state-template">
	<p>A technician from your local electricity distributor might be required to visit your property on [#= moving_date #] to replace your fuse. In this case, you do not need to be home on the day but you will need to switch off all power at the mains otherwise the fuse will not be replaced for safety reasons and your power will not be connected. You might be charged an additional fee to arrange your connection on another day.</p>
</core:js_template>

<core:js_template id="switch-template">
	<p><strong>Thank you</strong> for choosing <strong>compare</strong>the<strong>market</strong>.com.au (powered by Switchwise) to help you save on your energy bills.</p> 
	<p>Your [#= selected_utilities #] account transfer request with [#= provider #] has been received. An email confirmation of your application details will be sent to the email address you provided.</p>
	[#= provider_text #]
	<p>If there are any issues with your transfer request [#= provider #] might need to speak to you; if they are unable to contact you your transfer request might not be processed.</p> 
	<p>If you have requested the transfer of both electricity and gas please note that electricity meters and gas meters are often read at different times. As a result the transfer of your gas account will probably occur on a different date to the transfer of your electricity account.</p> 
	<p><strong>Please DO NOT cancel your [#= selected_utilities #] account(s) with your current supplier(s) as this might result in your [#= selected_utilities #] being disconnected!</strong> [#= provider #] will notify your current supplier as part of the transfer process. Your [#= selected_utilities #] account will be transferred to [#= provider #] only when your meter is next read, which may be in up to 3 months' time.  You will receive final accounts from your current retailer prior to receiving account from your new retailer.</p>
	<p>You have a 10 business day cooling-off period if you change your mind.</p>
</core:js_template>

<core:js_template id="switch-provider-dodo-template">
	<p>Switchwise will soon send your transfer request to Dodo Power & Gas and they should contact you within 2 business days to collect your payment details. If you do not hear from them within two business days please contact them directly on 13 dodo (13 36 36). Please note that if you do not speak to Dodo Power & Gas and provide your payment details your transfer request will not be processed.</p>
</core:js_template>

<core:js_template id="switch-provider-template">
	<p>Switchwise will send your transfer request to [#= provider #]. If your transfer request is approved by [#= provider #] they will send a letter and a welcome pack to your postal address. The welcome pack will confirm the tariffs applicable to your property and include details of your energy agreement.</p>
</core:js_template>

<core:js_template id="energy-australia-move-template">
	<p><strong>Thank you</strong> for choosing <strong>compare</strong>the<strong>market</strong>.com.au (powered by Switchwise) to help you save on your energy bills.</p> 
	<p>Your [#= selected_utilities #] connection request for [#= moving_date #] with Energy Australia has been received. An email confirmation of your application details will be sent to the email address you provided.</p>
	<p>To process your [#= selected_utilities #] connection request a Switchwise Customer Service Representative will call you to confirm your details and your acceptance of the key terms and conditions that apply to your chosen plan.</p> 
	<p>If you cannot be contacted to discuss your connection request, your connection may not be able to be arranged with [#= selected_utilities #].</p> 
	<p>If you have not heard from Switchwise within 1 business day please feel free to call them on 1300 867 948 to complete your connection request.</p>
</core:js_template>

<core:js_template id="energy-australia-switch-template">
	<p><strong>Thank you</strong> for choosing <strong>compare</strong>the<strong>market</strong>.com.au (powered by Switchwise) to help you save on your energy bills.</p> 
	<p>Your [#= selected_utilities #] account(s) transfer request with Energy Australia has been received. An email confirmation of your application details will be sent to the email address you provided.</p>
	<p>To process your [#= selected_utilities #] transfer request a Switchwise Customer Service Representative will call you to confirm your details and your acceptance of the key terms and conditions that apply to your chosen plan.</p> 
	<p>If you cannot be contacted to discuss your transfer request, your transfer may not be able to be arranged for [#= selected_utilities #] account(s) to Energy Australia.</p> 
	<p>If you have not heard from Switchwise within 1 business day please feel free to call them on 1300 867 948 to complete your transfer request.</p>
</core:js_template>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var UtilitiesConfirmationPage = {

	init: function() {
		
	},

	show: function(applicationObj) {	
		UtilitiesQuote.checkQuoteOwnership(function(){
		
			$("#utilities-confirmation #orderNo").html(applicationObj.ReceiptID);
		
			Track.onConfirmation( Results.getSelectedProduct() );
		
			UtilitiesConfirmationPage.updateThankYou();
			
			$('#summary-header').find("h2").first().slideUp("fast", function(){
				$(this).empty().append("Thank You...").slideDown("fast");
			});
			
			$("#page").slideUp("fast", function(){
				$("#start-new-quote").slideDown("fast", function(){
					$("#utilities-confirmation").slideDown("fast");
				});
			});
		});
	},
	
	updateThankYou: function(){
		
		var msg;
		
		if(utilitiesChoices._product.service == 'ENA'){
			msg = UtilitiesConfirmationPage.getEnergyAustraliaThankYou();
		} else {
			msg = UtilitiesConfirmationPage.getThankYou();
		}
		
		$('#thank_you').html(msg);
	},
	
	getThankYou: function(){
		
		var data = {
			selected_utilities: utilitiesChoices.returnWhatToCompare(),
			moving_date: $('#utilities_application_details_movingDate').val()
		};
		var product = $.extend({}, utilitiesChoices._product, data );
		
		var template;
		if(utilitiesChoices._movingIn == 'Y'){
		
			template = $("#move-template").html();
			
			// parse the provider's text
			var provider_text;
			if(product.service == 'DOD'){
				providerTemplate = $("#move-provider-dodo-template").html();
			}else{
				providerTemplate = $("#move-provider-template").html();
			}
			providerText = { provider_text: parseTemplate( providerTemplate, product ) };
			$.extend( product, providerText );
			
			// parse the state's text
			var state_text;
			if(utilitiesChoices._state == 'QLD'){
				stateTemplate = $("#move-state-qld-template").html();
			}else{
				stateTemplate = $("#move-state-template").html();
			}
			stateText = { state_text: parseTemplate( stateTemplate, product ) };
			$.extend( product, stateText );
			
		} else {
		
			template = $("#switch-template").html();
			
			// parse the provider's text
			var provider_text;
			if(product.service == 'DOD'){
				providerTemplate = $("#switch-provider-dodo-template").html();
			}else{
				providerTemplate = $("#switch-provider-template").html();
			}
			providerText = { provider_text: parseTemplate( providerTemplate, product ) };
			$.extend( product, providerText );
			
		}
		
		return $(parseTemplate( template, product ) );
		
	},
	
	getEnergyAustraliaThankYou: function(){
		
		var data = {
			selected_utilities: utilitiesChoices.returnWhatToCompare(),
			moving_date: $('#utilities_application_details_movingDate').val()
		};
		var product = $.extend({}, utilitiesChoices._product, data );
		
		var template;
		if(utilitiesChoices._movingIn == 'Y'){
			template = $("#energy-australia-move-template").html();
		} else {
			template = $("#energy-australia-switch-template").html();
		}
		
		return $(parseTemplate( template, product ) );
	}
	
};
</go:script>
<go:script marker="onready">
	UtilitiesConfirmationPage.init();
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
#utilities-confirmation {
	min-width:				980px;
	max-width:				980px;
	width:					980px;
	display: 				none;
	overflow:				hidden;
}

#utilities-confirmation {margin:0 auto;padding-top:22px;}

#utilities-confirmation .clear
{clear:both;}

#utilities-confirmation .wrapper .column,
#utilities-confirmation .wrapper .column .inner {
	float:					left;
}

#utilities-confirmation .wrapper .column.left {
	width:					664px;
	/*height:					400px;*/
}

#utilities-confirmation .wrapper .column.right {
	width:					296px;
	/*height:					400px;*/
	margin-left:			20px;
}

#utilities-confirmation .wrapper .column.left .inner.top {
	width:					604px;
}

#utilities-confirmation .wrapper .column.left .inner.left {
	width:					604px;
}

#utilities-confirmation .wrapper .column.left .inner.bottom {
	width:					604px;
}

#utilities-confirmation .wrapper .panel {
	padding:					10px;
	margin:						0 0 10px 0;
	border:						1px solid #DAE0E4;
	-moz-border-radius: 		5px;
	-webkit-border-radius: 		5px;
	-khtml-border-radius: 		5px;
	border-radius: 				5px;
}

#utilities-confirmation .wrapper .panel.nobdr {
	border-color:				#FFFFFF;
}

#utilities-confirmation .wrapper .panel.nopad {
	padding:					0;
}

#utilities-confirmation .wrapper .panel.dark {
	background-color:			#F4F9FE;
}

#utilities-confirmation .wrapper p {
	font-size:					105%;
	line-height:				110%;
}

#utilities-confirmation .wrapper p {
	padding:					5px 0;
}

#utilities-confirmation .wrapper .panel.lgetxt p {
	font-size:					120%;
}

#utilities-confirmation .wrapper h4,
#utilities-confirmation .wrapper h5 {
	margin:						15px 0 5px 0;
}

#utilities-confirmation .wrapper h4.first,
#utilities-confirmation .wrapper h5.first,
#utilities-confirmation .wrapper h6.first {
	margin-top:					0;
}

#utilities-confirmation .wrapper h5 {
	font-size:					140%;
}

#utilities-confirmation .wrapper h6 {
	font-size:					120%;
	margin:						20px 0 5px 0;
}

#utilities-confirmation .wrapper .right-panel {
	margin-left:				0px !important;
}

#utilities-confirmation .wrapper .right-panel .right-panel-top,
#utilities-confirmation .wrapper .right-panel .right-panel-bottom {
	height:						5px !important;
}

#utilities-confirmation .wrapper .right-panel .right-panel-bottom {
	background-position:		bottom center !important;
}

#utilities-confirmation .wrapper .right-panel-middle .panel {
    margin-bottom: 				0px;
}

#utilities-confirmation .wrapper .head {
	height:						25px;
}

#utilities-confirmation .wrapper .head.space {
	border:						1px solid #FFFFFF;
}

#utilities-confirmation .wrapper .head div {
	float:						left;
	margin:						22px 0 0 5px;
	font-size:					130%;
	font-weight:				900;
}

#utilities-confirmation .wrapper .head div span {
	font-size:					130%;
}

#utilities-confirmation .wrapper .head .reference {
	float:						right;
	margin-top:					9px;
}

#utilities-confirmation .promotion {
	margin-top:					10px;
}

#utilities-confirmation .promotion .innertube {
	width:						272px;
	margin-left:				auto;
	margin-right:				auto;
}

#utilities-confirmation a {
	font-size:					14px;
	font-weight:				normal;
	color:						#4A4F51;
	padding:					2px 0 2px 10px;
	background:					transparent url(brand/ctm/images/bullet_edit.png) center left no-repeat;
}

#utilities-confirmation #orderNoContainer{
	margin-bottom: 10px;
	color: grey;
}
#utilities-confirmation #orderNoTitle{
	color: #0B0161;
	font-size: 23px;
	margin-bottom: 5px;
}
#utilities-confirmation h2{
	font-size: 20px;
	font-weight: normal;
	margin-bottom: 5px;
	font-family: Arial, sans-serif;
}

#utilities-confirmation #logo-switchwise{
	float: right;
	margin-top: 10px;
}

</go:style>
