<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Credit Card details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="gatewayXpath" value="${xpath}/gateway"/>
<c:set var="xpath" value="${xpath}/credit"/>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-credit_card_details">

	<form_new:fieldset legend="Credit Card Details">
	
		<field_new:creditcard_assurance_message showCreditCards="true" />

		<health:payment_external xpath="${gatewayXpath}" />

		<c:set var="fieldXpath" value="${xpath}/type" />
		<form_new:row fieldXpath="${fieldXpath}" label="Credit Card Type" className="health-credit_card_details-type-group">
			<field_new:array_select xpath="${fieldXpath}" required="true" delims="||" className="health-credit_card_details-type" title="type of credit card" items="=Please choose...||v=Visa||m=Mastercard||a=AMEX" />
		</form_new:row>
		
		<c:set var="fieldXpath" value="${xpath}/name" />
		<form_new:row fieldXpath="${fieldXpath}" label="Name on Credit Card">
			<field_new:input xpath="${fieldXpath}"
						title="account name" required="true"
						className="health-credit_card_details-name sessioncamexclude" />
		</form_new:row>

		<field:credit_card_validation />
		
		<c:set var="fieldXpath" value="${xpath}/number" />
		<form_new:row fieldXpath="${fieldXpath}" label="Credit Card Number" className="health_credit-card-details_number">
			<field_new:creditcard_number xpath="${fieldXpath}" title="Credit card number" required="true" className="health-credit_card_details-number sessioncamexclude" />
		</form_new:row>
		
		<c:set var="fieldXpath" value="${xpath}/expiry" />
		<form_new:row fieldXpath="${fieldXpath}_cardExpiryMonth" label="Credit Card Expiry" id="${name}_expiry">
			<field:cards_expiry rule="ccExp" xpath="${fieldXpath}" title="Credit card expiry date" required="true" className="health-credit_card_details-expiry sessioncamexclude" />
		</form_new:row>
		
		<c:set var="fieldXpath" value="${xpath}/ccv" />
		<form_new:row fieldXpath="${fieldXpath}" label="CCV number" helpId="402" className="health_credit-card-details_ccv">
			<field_new:creditcard_ccv xpath="${fieldXpath}" required="true"  />
		</form_new:row>
		
		<health:payment_ipp xpath="${xpath}/ipp" />

		<%-- Default (HCF) payment day question --%>
		<c:set var="fieldXpath" value="${xpath}/day" />
		<form_new:row fieldXpath="${fieldXpath}" label="What day would you like your payment deducted?" className="health_credit-card-details_day_group">
			<field_new:count_select xpath="${fieldXpath}" min="1" max="27" step="1" title="your chosen day"
						required="true" className="health-credit_card_details-day"/>
		</form_new:row>
		
		<%-- NIB based payment day --%>
		<c:set var="fieldXpath" value="${xpath}/paymentDay" />
		<form_new:row fieldXpath="${fieldXpath}" label="What day would you like your payment deducted?" className="health_credit-card-details_paymentDay_group">
			<health:payment_day xpath="${fieldXpath}" title="your chosen day"
						required="true" className="health-credit-card_details-paymentDay" />
		</form_new:row>
		
		<%-- AUF based payment day --%>
		<c:set var="fieldXpath" value="${xpath}/policyDay" />
		<form_new:row fieldXpath="${fieldXpath}" label="What day would you like your payment deducted?" className="health_credit-card-details_policyDay-group">
			<field_new:array_select xpath="${fieldXpath}"
						required="true" className="health-credit-card_details-policyDay" items="=Please choose..." title="your chosen day" />
			<p class="health_credit-card-details_policyDay-message"></p>
		</form_new:row>
	 	
	</form_new:fieldset>

</div>

<go:validate selector="${name}_name" rule="regex" parm="'[^0-9]*'" message="For credit card name, please do not use numbers" />