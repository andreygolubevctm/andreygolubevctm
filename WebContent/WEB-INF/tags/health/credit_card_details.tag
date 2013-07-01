<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Credit Card details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-credit_card_details">

	<form:fieldset legend="Your credit card details" >
	
		<div class="assurance_message">
			<p><img src="brand/${data.settings.styleCode}/images/icon_large_lock.png" alt="" />
			<strong>Secure credit card transaction</strong> <span>This is a secure 128-bit SSL encrypted transaction</span></p>
			<img src="brand/${data.settings.styleCode}/images/logo_verisign.png" alt="VeriSign secured" class="verisign" />
		</div>

		<form:row label="Type of Credit Card" className="health-credit_card_details-type-group">
			<field:array_select xpath="${xpath}/type" required="true" delims="||" className="health-credit_card_details-type" title="type of credit card" items="=Please choose...||v=Visa||m=Mastercard||a=AMEX" />
			<ul class="cards">
				<li class="mastercard"><img src="brand/${data.settings.styleCode}/images/icon_mastercard.png" alt="Mastercard" /></li>
				<li class="visa"><img src="brand/${data.settings.styleCode}/images/icon_visa.png" alt="Visa" /></li>
				<li class="amex"><img src="brand/${data.settings.styleCode}/images/icon_amex.png" alt="American Express" /></li>
			</ul>
		</form:row>	
		
		<form:row label="Name on Credit Card">
			<field:input xpath="${xpath}/name" title="account name" required="true" className="health-credit_card_details-name" />
		</form:row>
		
		<field:credit_card_validation />
		
		<form:row label="Credit Card number">
			<field:creditcard_number xpath="${xpath}/number" title="Credit card number" required="true" className="health-credit_card_details-number" />
		</form:row>
		
		<form:row label="Credit Card expiry date" id="${name}_expiry">
			<field:cards_expiry rule="ccExp" xpath="${xpath}/expiry" title="Credit card expiry date" required="true" className="health-credit_card_details-expiry" />
		</form:row>
		
		<form:row label="CCV number" helpId="402">
			<field:input_numeric id="${name}_ccv" maxLength="4" xpath="${xpath}/ccv" required="true" validationMessage="CCV number on card" title="CCV number on card"/>
			<span><img src="brand/${data.settings.styleCode}/images/icon_card_ccv.png" alt="CCV" class="ccv"/></span>
		</form:row>
		
		<%-- Default (HCF) payment day question --%>
		<form:row label="What day would you like your payment deducted" className="health_credit-card-details_day_group">
			<field:count_select xpath="${xpath}/day" min="1" max="27" step="1" title="your chosen day"
						required="true" className="health-credit_card_details-day"/>
		</form:row>
		
		<%-- NIB based payment day --%>
		<form:row label="What day would you like your payment deducted" className="health_credit-card-details_paymentDay_group">
			<health:payment_day xpath="${xpath}/paymentDay" title="your chosen day"
						required="true" className="health-credit-card_details-paymentDay" />
		</form:row>
		
		<%-- AUF based payment day --%>
		<form:row label="What day would you like your payment deducted" className="health_credit-card-details_policyDay-group">
			<field:array_select xpath="${xpath}/policyDay"
						required="true" className="health-credit-card_details-policyDay" items="=Please choose..." title="your chosen day" />
			<span class="health_credit-card-details_policyDay-message"></span>
		</form:row>
	 	
	</form:fieldset>

</div>


<%-- CSS --%>
<go:style marker="css-head">
.health_credit-card-details_paymentDay_group,
.health_credit-card-details_policyDay-group,
.health_credit-card-details_policyDay-message {
	display:none;
}
.health_credit-card-details_policyDay-message {
	clear:both;
	padding-top:20px;
}
#${name}-selection .cards {
	float:left;
	margin-left:5px;
}
#${name}_type {
	float:left;
}
.health-credit_card_details-type-group {
	min-width:390px;
}
#${name}-selection .cards li {
	float:left;
	padding-left:5px;
	padding-top:5px;
}
#${name}-selection .ccv {
	margin-left:5px;
}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
creditCardDetails = {

	resetConfig: function(){
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':true, 'diners':false };	
	},
	
	render: function(){
		var $_obj = $('#${name}_type');
		var $_icons = $('#${name}-selection .cards');
		$_icons.find('li').hide();
	
		var _html = '<option id="${name}_type_" value="">Please choose...</option>';
		var _selected = $_obj.find(':selected').val();
			
		<%-- Visa Check --%>
		if( creditCardDetails.config.visa === true ){
			_html += '<option id="${name}_type_v" value="v">Visa</option>';
			$_icons.find('.visa').show();
		};
		<%-- Mastercard Check --%>
		if( creditCardDetails.config.mc === true ){
			_html += '<option id="${name}_type_m" value="m">Mastercard</option>';
			$_icons.find('.mastercard').show();
		};
		<%-- Amex Check --%>
		if( creditCardDetails.config.amex === true ){
			_html += '<option id="${name}_type_a" value="a">AMEX</option>';
			$_icons.find('.amex').show();
		};
		<%-- Diners Check --%>
		if( creditCardDetails.config.diners === true ){
			_html += '<option id="${name}_type_d" value="d">Diners Club</option>';
			$_icons.find('.diners').show();
		};
		
		$_obj.html( _html ).find('option[value='+ _selected +']').attr('selected', 'SELECTED');
		return;
	},
	
	set: function(){
		creditCardDetails.$_obj = $('#${name}_number');
		creditCardDetails.$_objCCV = $('#${name}_ccv');			
		var _type = this._getType();
		<%-- Launch the main validation --%>
		field_credit_card_validation.set(_type, creditCardDetails.$_obj, creditCardDetails.$_objCCV);
	},
	
	_getType: function(){
		return $('#${name}_type').find(':selected').val();
	}
};

</go:script>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$('#${name}_type').on('change', function(){
		creditCardDetails.set();
	});
	creditCardDetails.set();
</go:script>
