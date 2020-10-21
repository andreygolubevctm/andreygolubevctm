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
<div id="${name}-selection" class="health-credit_card_details ${name}-selection">


		<field_v2:creditcard_assurance_message showCreditCards="true" />

		<health_v1:payment_external xpath="${gatewayXpath}" />

		<c:set var="fieldXpath" value="${xpath}/type" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Credit Card Type" className="health_credit-card_details_type_group" renderLabelAsSimplesDialog="true">
			<field_v2:array_radio items="v=Visa,m=Mastercard,a=AMEX" xpath="${fieldXpath}" title="type of credit card" required="true" className="health-credit_card_details-type" />
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/name" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Name on Credit Card" className="health_credit-card-details_name" renderLabelAsSimplesDialog="true">
			<field_v2:input xpath="${fieldXpath}"
							 title="account name" required="true"
							 className="health-credit_card_details-name sessioncamexclude" additionalAttributes=" data-rule-regex='[^0-9]*' data-msg-regex='For credit card name, please do not use numbers' "/>
		</form_v3:row>

		<c:set var="fieldXpath" value="${xpath}/number" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Credit Card Number" className="health_credit-card-details_number_group" renderLabelAsSimplesDialog="true">
			<field_v2:creditcard_number xpath="${fieldXpath}" title="Credit card number" required="true" className="health-credit_card_details-number sessioncamexclude" placeHolder="Card #" />
		</form_v3:row>


		<health_v3:credit_card_expiry_group xpath="${xpath}" />

		<health_v2:payment_ipp xpath="${xpath}/ipp" />

</div>
