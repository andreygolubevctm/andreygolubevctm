<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-bank_details">

	<form:fieldset legend="Your bank account details" >
	
		<div class="assurance_message">
			<p><img src="brand/${data.settings.styleCode}/images/icon_large_lock.png" alt="" />
			<strong>Secure transaction</strong> <span>This is a secure 128-bit SSL encrypted transaction</span></p>
			<img src="brand/${data.settings.styleCode}/images/logo_verisign.png" alt="VeriSign secured" class="verisign" />
		</div>

		<health:bank_account_details xpath="${xpath}" />
		
		<%-- Default payment day --%>	
		<form:row label="What day would you like your payment deducted" className="health_bank-details_day-group">
			<field:count_select xpath="${xpath}/day" min="1" max="27" step="1" title="your chosen day" required="true" className="health-bank_details-day"/>
		</form:row>
		
		<%-- NIB based payment day --%>		
		<form:row label="What day would you like your payment deducted" className="health_bank-details_paymentDay_group">
			<health:payment_day xpath="${xpath}/paymentDay" title="your chosen day" required="true" className="health-bank_details-paymentDay" />
		</form:row>
		
		<%-- AUF based payment day --%>
		<form:row label="What day would you like your payment deducted" className="health_bank-details_policyDay-group">
			<field:array_select xpath="${xpath}/policyDay" required="true" className="health-bank_details-policyDay" items="=Please choose..." title="your chosen day" />
			<span class="health_bank-details_policyDay-message"></span>
		</form:row>		
		
		<form:row label="Would you like your claim refunds paid into the same account?" className="health_bank-details_claims_group">
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/claims" title="would you like your claim refunds paid into the same account" required="true" className="health-bank_details-claims" id="${name}_claims"/>
		</form:row>			
	
	</form:fieldset>

</div>

<div id="${name}_claim-selection" class="health-bank_claim_details">
	<form:fieldset legend="Please nominate a bank account for future claim payments">	
		<health:bank_account_details xpath="${xpath}/claim" />	
	</form:fieldset>
</div>


<%-- CSS --%>
<go:style marker="css-head">
	.health_bank-details_paymentDay_group,
	.health_bank-details_policyDay-group,
	#${name}_claim-selection,
	.health_bank-details_policyDay-message {
		display:none;
	}
.health_bank-details_policyDay-message {
	clear:both;
	padding-top:20px;
}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$(function() {
		$("#${name}_claims").buttonset();
	});
	$("#${name}_claims").find('input').on('change', function(){
		paymentSelectsHandler.claimsAccount();
	});	
</go:script>