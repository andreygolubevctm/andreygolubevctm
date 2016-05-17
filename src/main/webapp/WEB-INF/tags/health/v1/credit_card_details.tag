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

	<form_v2:fieldset legend="Credit Card Details">
	
		<field_v2:creditcard_assurance_message showCreditCards="true" />

		<health_v1:payment_external xpath="${gatewayXpath}" />

		<c:set var="fieldXpath" value="${xpath}/type" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Credit Card Type" className="health_credit-card_details_type_group">
			<field_v2:array_select xpath="${fieldXpath}" required="true" delims="||" className="health-credit_card_details-type" title="type of credit card" items="=Please choose...||v=Visa||m=Mastercard||a=AMEX" />
		</form_v2:row>
		
		<c:set var="fieldXpath" value="${xpath}/name" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Name on Credit Card" className="health_credit-card-details_name">
			<field_v2:input xpath="${fieldXpath}"
						title="account name" required="true"
						className="health-credit_card_details-name sessioncamexclude" additionalAttributes=" data-rule-regex='[^0-9]*' data-msg-regex='For credit card name, please do not use numbers' "/>
		</form_v2:row>

		
		<c:set var="fieldXpath" value="${xpath}/number" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Credit Card Number" className="health_credit-card-details_number_group">
			<field_v2:creditcard_number xpath="${fieldXpath}" title="Credit card number" required="true" className="health-credit_card_details-number sessioncamexclude" placeHolder="Card #" />
		</form_v2:row>
		
		<c:set var="fieldXpath" value="${xpath}/expiry" />
		<form_v2:row fieldXpath="${fieldXpath}_cardExpiryMonth" label="Credit Card Expiry" id="${name}_expiry" className="health_credit-card-details_expiry_group">
			<field_v1:cards_expiry rule="ccExp" xpath="${fieldXpath}" title="Credit card expiry date" required="true" className="health-credit_card_details-expiry sessioncamexclude" maxYears="7"/>
		</form_v2:row>
		
		<c:set var="fieldXpath" value="${xpath}/ccv" />
		<form_v2:row fieldXpath="${fieldXpath}" label="CCV number" helpId="402" className="health_credit-card-details_ccv">
			<field_v2:creditcard_ccv xpath="${fieldXpath}" required="true" placeHolder="CCV Number" />
		</form_v2:row>
		
		<health_v1:payment_ipp xpath="${xpath}/ipp" />

		<%-- Default (HCF) payment day question --%>
		<c:set var="fieldXpath" value="${xpath}/day" />
		<form_v2:row fieldXpath="${fieldXpath}"
					 label="What day would you like your payment deducted?"
					 className="health_credit-card-details_day_group">
			<field_v2:count_select xpath="${fieldXpath}"
								   min="1"
								   max="27"
								   step="1"
								   title="your chosen day"
						required="true" className="health-credit_card_details-day"/>
		</form_v2:row>
		
		<%-- NIB based payment day --%>
		<c:set var="fieldXpath" value="${xpath}/paymentDay" />
		<form_v2:row fieldXpath="${fieldXpath}" label="What day would you like your payment deducted?"
					 className="health_credit-card-details_paymentDay_group">
			<field_v1:payment_day xpath="${fieldXpath}"
								  title="your chosen day" required="true"
								  className="health_payment_day health-credit-card_details-paymentDay"
								  messageClassName="health_payment-day_message"
								  message="It can take up to 6 days to set up your direct debit so your payment may not be deducted until the following month if you chose a date within this time frame"/>
		</form_v2:row>
		
		<%-- AUF based payment day --%>
		<c:set var="fieldXpath" value="${xpath}/policyDay" />
		<form_v2:row fieldXpath="${fieldXpath}" label="What day would you like your payment deducted?" className="health_credit-card-details_policyDay-group">
			<field_v2:array_select xpath="${fieldXpath}"
						required="true" className="health-credit-card_details-policyDay" items="=Please choose..." title="your chosen day" />
			<p class="health_credit-card-details_policyDay-message"></p>
		</form_v2:row>
	 	
	</form_v2:fieldset>

</div>
