<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Application Options group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="${name}">
	
	<form:fieldset legend="Options" id="${name}">
		
		<form:row label="Would you like to setup Direct Debit?" id="${name}_directDebitRow">
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/directDebit" title="if you want to setup direct debit" required="true" className="${name}_directDebit" id="${name}_directDebit" />
		</form:row>
		
		<div id="paymentSmoothingContainer">
			<form:row label="Would you like your account to be debited monthly as a set amount?" id="${name}_paymentSmoothingRow">
				<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/paymentSmoothing" title="if you want to be debited monthly as a set amount" required="true" className="${name}_paymentSmoothing" id="${name}_paymentSmoothing" />
			</form:row>
			<form:row label=" " id="paymentSmoothingNote">
				Note: As you have opted for a direct debit to be set up and your account to be paid in full by the due date, we'll arrange to have a direct debit form sent to you. Please complete and send the form back to us as soon as you are able to.
			</form:row>
		</div>
		
		<div id="paymentDetailsContainer">
			<form:row label="Payment Details">
				<div id="${name}_payment_details_placeholder"></div>
		
				<core:js_template id="payment-details-template">
					<p>Your first instalment payment amount will be [#= firstInstalmentsText #]. <strong>Alinta Energy will send a direct debit form to your mailing address which you must complete and return to Alinta Energy</strong>. Reviews of your monthly payments will be performed at least every six months, using your actual electricity usage history. You can choose the day of the month on which your payments are deducted.</p>	
					<p>If you do not provide direct debit details to Alinta Energy, or Alinta Energy is unable to set up a direct debit to your bank account or credit card, the pay on time discount available on this plan will be reduced from 12% to 7%</p>
				</core:js_template>
			</form:row>
		</div>
		
		<form:row label="Would you like to receive electronic bills?" id="${name}_electronicBillRow">
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/electronicBill" title="if you want to receive electronic bills" required="true" className="${name}_electronicBill" />
		</form:row>
		
		<form:row label="Would you like to receive electronic communication?" id="${name}_electronicCommunicationRow">
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/electronicCommunication" title="if you want to receive electronic communication" required="true" className="${name}_electronicCommunication" />
		</form:row>
		
		<form:row label="Choose your bill delivery method" id="${name}_billDeliveryMethodRow">
			<field:array_radio items="Email=Email,Post=Post" xpath="${xpath}/billDeliveryMethod" title="your bill delivery method" required="true" className="${name}_billDeliveryMethod" />
		</form:row>
		
	</form:fieldset>

</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} #paymentSmoothingContainer,
	#${name} #paymentDetailsContainer{
		display:none;
		margin-bottom: 10px;
	}
	
	#${name} #paymentSmoothingContainer .fieldrow_value,
	#${name} #paymentDetailsContainer .fieldrow_value{
		max-width: 400px;
	}
</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	
	var utilitiesOptions = {
	
		init: function(){
		
			$('.${name}_directDebit, .${name}_paymentSmoothing, .${name}_electronicBill, .${name}_electronicCommunication, .${name}_billDeliveryMethod').buttonset();
		
		
			$('#${name}_directDebit').on('change', function(){
				if($('#${name}_directDebit :checked').val() == 'Y' && utilitiesChoices._product.service == 'ALN'){
					$('#${name} #paymentSmoothingContainer').slideDown();
					$('#${name}_paymentSmoothing').trigger('change');
					
					$("#utilities_application_thingsToKnow_hidden_paymentSmoothingRequired").val('Y');
				}else{
					$('#${name} #paymentSmoothingContainer').slideUp();
					$('#${name} #paymentDetailsContainer').slideUp();
					
					$("#utilities_application_thingsToKnow_hidden_paymentSmoothingRequired").val('N');
				}
			});
			$('#${name}_directDebit').trigger('change');
			
			$('#${name}_paymentSmoothing').on('change', function(){
				if($('#${name}_paymentSmoothing :checked').val() == 'Y'){
					$('#${name} #paymentDetailsContainer').slideDown();
				}else{
					$('#${name} #paymentDetailsContainer').slideUp();
				}
			});
			$('#${name}_paymentSmoothing').trigger('change');
		}
		
	}
	
</go:script>

<go:script marker="onready">

	utilitiesOptions.init();

</go:script>


<%-- VALIDATION --%>
