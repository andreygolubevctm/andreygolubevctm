<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-bank_details">

	<form_new:fieldset legend="Bank Account Details" >
	


		<health:bank_account_details xpath="${xpath}" />
		
		<%-- Default payment day --%>	
		<c:set var="fieldXpath" value="${xpath}/day" />
		<form_new:row fieldXpath="${fieldXpath}" label="What day would you like your payment deducted?" className="health_bank-details_day-group">
			<field_new:count_select xpath="${fieldXpath}" min="1" max="27" step="1" title="your chosen day" required="true" className="health-bank_details-day"/>
		</form_new:row>
		
		<%-- NIB based payment day --%>		
		<c:set var="fieldXpath" value="${xpath}/paymentDay" />
		<form_new:row fieldXpath="${fieldXpath}" label="What day would you like your payment deducted?" className="health_bank-details_paymentDay_group">
			<field:payment_day xpath="${fieldXpath}" title="your chosen day" required="true" className="health_payment_day health-bank_details-paymentDay" messageClassName="health_payment-day_message"
								displayDatePattern="d" buffer="8" includeOriginal="true" exclude="28" days="30"
								message="It can take up to 6 days to set up your direct debit so your payment may not be deducted until the following month if you chose a date within this time frame"/>
		</form_new:row>
		
		<%-- AUF based payment day --%>
		<c:set var="fieldXpath" value="${xpath}/policyDay" />
		<form_new:row fieldXpath="${fieldXpath}" label="What day would you like your payment deducted?" className="health_bank-details_policyDay-group">
			<field_new:array_select xpath="${fieldXpath}" required="true" className="health-bank_details-policyDay" items="=Please choose..." title="your chosen day" />
			<p class="health_bank-details_policyDay-message"></p>
		</form_new:row>

		<c:set var="fieldXpath" value="${xpath}/claims" />
		<form_new:row fieldXpath="${fieldXpath}" label="Would you like your claim refunds paid into the same account?" className="health_bank-details_claims_group">
			<field_new:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="would you like your claim refunds paid into the same account" required="true" className="health-bank_details-claims" id="${name}_claims"/>
		</form_new:row>

	</form_new:fieldset>

</div>

<div id="${name}_claim-selection" class="health-bank_claim_details">
	<form_new:fieldset legend="Please nominate a bank account for future claim payments">
		<health:bank_account_details xpath="${xpath}/claim" />
	</form_new:fieldset>
</div>
