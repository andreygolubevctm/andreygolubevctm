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
			<field_v2:creditcard_number xpath="${fieldXpath}" title="Credit card number" required="true" className="health-credit_card_details-number sessioncamexclude" />
		</form_v2:row>
		
		<c:set var="fieldXpath" value="${xpath}/expiry" />
		<form_v2:row fieldXpath="${fieldXpath}_cardExpiryMonth" label="Credit Card Expiry" id="${name}_expiry" className="health_credit-card-details_expiry_group">
			<field_v1:cards_expiry rule="ccExp" xpath="${fieldXpath}" title="Credit card expiry date" required="true" className="health-credit_card_details-expiry sessioncamexclude" maxYears="7"/>
		</form_v2:row>
		
		<c:set var="fieldXpath" value="${xpath}/ccv" />
		<form_v2:row fieldXpath="${fieldXpath}" label="CCV number" helpId="402" className="health_credit-card-details_ccv">
			<field_v2:creditcard_ccv xpath="${fieldXpath}" required="true"  />
		</form_v2:row>
		
		<health_v1:payment_ipp xpath="${xpath}/ipp" />

	</form_v2:fieldset>

</div>
