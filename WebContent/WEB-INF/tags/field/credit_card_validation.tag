<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Credit Card validation files, include once only and call to validate credit cards"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

<%-- Masking sequences --%>
var field_credit_card_validation = {

	<%-- Masking types --%>
	dinersMask: '9999 999999 9999',
	dinersMaskCCV: '999',
	visaMask: '9999 9999 9999 9999',
	visaMaskCCV: '999',
	mcMask: '9999 9999 9999 9999',
	mcMaskCCV: '999',
	amexMask: '9999 999999 99999',
	amexMaskCCV: '9999',
	
	
	<%-- Apply the masking and validation rules onto a jquery obj --%>
	set: function(_type, $_obj, $_objCCV){
	
		if($_obj.length == 1 && _type != '') {
			field_credit_card_validation._remove( $_obj );
		} else {
			return false;
		};
		
		if(typeof $_objCCV == 'undefined'){
			$_objCCV = $();	
		};
		
		switch( _type )
		{
		case 'a':
			$_obj.unmask().mask( field_credit_card_validation.amexMask );
			$_obj.rules("add","ccNumberAmex");
			$_objCCV.unmask().mask(  field_credit_card_validation.amexMaskCCV );
			break;
		case 'v':
			$_obj.unmask().mask( field_credit_card_validation.visaMask );
			$_obj.rules("add","ccNumberVisa");
			$_objCCV.unmask().mask(  field_credit_card_validation.visaMaskCCV );
			break;
		case 'd':
			$_obj.unmask().mask( field_credit_card_validation.dinersMask );	
			$_obj.rules("add","ccNumberDiners");
			$_objCCV.unmask().mask(  field_credit_card_validation.dinersMaskCCV );
			break;				
		case 'm':
			$_obj.unmask().mask( field_credit_card_validation.mcMask );	
			$_obj.rules("add","ccNumberMC");
			$_objCCV.unmask().mask(  field_credit_card_validation.mcMaskCCV );
			break;																								
		default:
			return false;
			break;
		};
		
		return true;
	
	},
	
	_CCVmask: function($_objCCV, mask){
		$_objCCV.unmask().mask( mask );
	},
	
	_remove: function($_obj){
		$_obj.rules("remove","ccNumber");
		$_obj.rules("remove","ccNumberAmex");
		$_obj.rules("remove","ccNumberMC");
		$_obj.rules("remove","ccNumberVisa");
		$_obj.rules("remove","ccNumberDiners");		
	}

};

<%-- Validation for Mastercard credit cards --%>
$.validator.addMethod("ccNumberMC",
	function(value, element) {
		var regex = '^5[1-5][0-9]{14}$';
		return String( value.replace(/\s/g, '') ).search(regex) != -1; <%-- Will return true if card passes regex --%>
	},
	$.validator.messages.ccNumberMC = 'Please enter a valid Mastercard card number'
);

<%-- Validation for Visa credit cards --%>
$.validator.addMethod("ccNumberVisa",
	function(value, element) {		
		var regex = '^4[0-9]{12}(?:[0-9]{3})?$';
		return String( value.replace(/\s/g, '') ).search(regex) != -1; <%-- Will return true if card passes regex --%>		
	},
	$.validator.messages.ccNumberVisa = 'Please enter a valid Visa card number'
);

<%-- Validation for Amex credit cards --%>
$.validator.addMethod("ccNumberAmex",
	function(value, element) {
		var regex = '^3[47][0-9]{13}$';
		return String( value.replace(/\s/g, '') ).search(regex) != -1; <%-- Will return true if card passes regex --%>
	},
	$.validator.messages.ccNumberAmex = 'Please enter a valid American Express card number'
);

<%-- Validation for Diners credit cards --%>
$.validator.addMethod("ccNumberDiners",
	function(value, element) {
		var regex = '^3(?:0[0-5]|[68][0-9])[0-9]{11}$';
		return String( value.replace(/\s/g, '') ).search(regex) != -1; <%-- Will return true if card passes regex --%>
	},
	$.validator.messages.ccNumberDiners = 'Please enter a valid Diners Club card number'
);

</go:script>