<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="External payment/tokenisation: Credit Card popup for IPP"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="health_popup_payment_ipp">
	<field:hidden xpath="${name}/tokenisation" required="false" />
	<form:row label="Credit Card number">
		<field:input xpath="${name}/maskedNumber" required="true" title="your secure credit card details" readOnly="false" />
	</form:row>
	<div id="${name}-dialog" class="${name}-dialog">
		<p>Credit Card number</p>
		<p class="message"></p>
		<iframe width="100%" height="110" frameBorder="0" src="" tabindex="" id="cc-frame"></iframe>
	</div>
</div>

<%--
Process:
- Call the iFrame when the pre-criteria is completed (and validated)
- Call the security session key
- iFrame will respond back with the results
- Log the final result details to the external source
--%>

<go:style marker="css-head">
	.health_popup_payment_ipp {
		display:none;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var health_popup_payment_ipp = {
		_ajax: false,
		launch: function() {
			<%-- Check that the precursor is ok --%>
			if(health_popup_payment_ipp.valid() && health_popup_payment_ipp.$masked.is(':visible')){
				$('#${name}-dialog').dialog('open');
				<%-- If there's no iFrame src than create it --%>
				if(!health_popup_payment_ipp.full()){
					health_popup_payment_ipp.authorise();
				};
			};
		},
		create: function(jsonResult) {
			if(health_popup_payment_ipp.full()){
				return false; <%-- Terminate here --%>
			};

			var _url 	= jsonResult.result.url + '?SessionId=' + jsonResult.result.refId + '&sst=' + jsonResult.result.sst
						+ '&cardType=' + health_popup_payment_ipp.cardType()
						+ '&registerError=false'
						+ '&resultPage=0';
			<%-- Populate the iFrame --%>
			$('#${name}-dialog .message').html('');
			$('#${name}-dialog #cc-frame').attr('src', _url);
		},
		authorise: function() {
			<%-- Make the masked field a readonly value --%>
			if(health_popup_payment_ipp._ajax == true || health_popup_payment_ipp.full()){
				return false;
			};

			health_popup_payment_ipp._ajax = true;
			health_popup_payment_ipp.$masked.val('Loading...');
			$('#${name}-dialog .message').html('<p>Loading...</p>');
			health_popup_payment_ipp.reset();

			$.ajax({
				url: "ajax/json/ipp/ipp_payment.jsp?ts="+ +new Date(),
				dataType: "json",
				type: "POST",
				async: true,
				cache: false,
				success: function(jsonResult){
					if((typeof jsonResult.result == 'undefined') || (jsonResult.result.success !== true)){
						health_popup_payment_ipp.fail();
					} else {
						<%-- Now create the iFrame --%>
						health_popup_payment_ipp.create(jsonResult);
					};
					health_popup_payment_ipp._ajax = false;
				},
				error: function(obj,txt) {
					<%-- Display an error message + log a normal error --%>
					health_popup_payment_ipp.fail();
					health_popup_payment_ipp._ajax = false;
				},
				timeout:60000
			});

		},
		<%-- Validate the credit details --%>
		valid: function() {
			return health_popup_payment_ipp.$creditType.valid();
		},
		<%-- If for any reason the token fails to launch, than we can still continue on with a 'fail' string --%>
		fail: function() {
			if(health_popup_payment_ipp.$token.val() == '') {
				<%-- We need to make sure the JS tunnel de-activates this --%>
				$('#${name}-dialog .message').html("We’re sorry but our system is down and we are unable to process your credit card details right now. <br /><br />Continue with your application and we can collect your details after you join.");
				health_popup_payment_ipp.$token.val('fail');
				health_popup_payment_ipp.$masked.val('Try again or continue');
				$('#${name}-dialog #cc-frame').attr('src', '');
			};
		},
		full: function(ignoreFail) {
			if( $('#${name}-dialog #cc-frame').attr('src') == '' ){
				return false;
			} else {
				return true;
			};
		},
		reset: function() {
			health_popup_payment_ipp.$token.val('');
			health_popup_payment_ipp.$masked.val('');
			$('#${name}-dialog #cc-frame').attr('src', '');
		},
		cardType: function() {
			switch(health_popup_payment_ipp.$creditType.find('option:selected').val())
			{
			case 'v':
				return 'Visa';
				break;
			case 'a':
				return 'Amex';
				break;
			case 'm':
				return 'Mastercard';
				break;
			case 'd':
				return 'Diners';
				break;
			default:
				return 'Unknown';
			}
		},
		close: function(){
			if($('#${name}-dialog').dialog('isOpen') === true){
				$('#${name}-dialog').dialog('close');
			};
		},
		register: function(jsonData){
			$.ajax({
				url: "ajax/json/ipp/ipp_log.jsp?ts="+ +new Date(),
				dataType: "json",
				data: jsonData,
				type: "POST",
				async: false,
				cache: false,
				success: function(jsonResult){
					health_popup_payment_ipp.jsonResult = jsonResult;
					if(typeof jsonResult.result == 'undefined' || jsonResult.result.success !== true){
						health_popup_payment_ipp.fail();
					} else {
						health_popup_payment_ipp.$token.val(jsonData.sessionid);
						health_popup_payment_ipp.$masked.val(jsonData.maskedcardno);
						$('#${name}-dialog #cc-frame').attr('src', '');
						health_popup_payment_ipp.close();
					};
				},
				error: function(obj,txt) {
					<%-- Display an error message + log a normal error --%>
					health_popup_payment_ipp.fail();
				},
				timeout:60000
			});
		},
		init: function(){

			health_popup_payment_ipp.$token = $('#health_payment_credit_ipp_tokenisation');
			health_popup_payment_ipp.$masked = $('#health_payment_credit_ipp_maskedNumber');
			health_popup_payment_ipp.$creditType = $('#health_payment_credit_type');

			$('#${name}-dialog').dialog({
				autoOpen: false,
				show: 'clip',
				hide: 'clip',
				'modal':true,
				'width':400, 'height':220,
				'draggable':true,
				'resizable':false,
				'dialogClass': '${name}-dialog',
				'title':'Credit card number',
				open: function() {
					$('.ui-widget-overlay').on('click.${name}', function () { health_popup_payment_ipp.close(); });
					health_popup_payment_ipp.authorise();
					Track.onCustomPage('Payment gateway popup');
				},
				close: function() {
					<%-- What is the criteria for failing --%>
					health_popup_payment_ipp.fail();
				}
			});
		}
	}
</go:script>

<%-- Make this the binding call to open the browser --%>
<go:script marker="onready">
	$("#${name}_maskedNumber").attr('readonly','readonly');
	health_popup_payment_ipp.init();

	<%-- Launch the iFrame dialog --%>
	$("#${name}_maskedNumber").on('click', function(){
		health_popup_payment_ipp.launch();
	});
</go:script>