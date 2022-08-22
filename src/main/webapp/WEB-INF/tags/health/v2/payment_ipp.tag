<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="External payment/tokenisation: Credit Card popup for IPP" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%--

	See corresponding module: healthPaymentIPP.js

	The component (div.health_popup_payment_ipp) is hidden by default.

--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="health_popup_payment_ipp hidden" data-provide="payment-ipp">
	<field_v1:hidden xpath="${xpath}/tokenisation" required="false" className="payment-ipp-tokenisation" />

	<div>We now need to register your credit card through Bambora Custom Checkout in order to process your payment. Please be assured that your personal and financial information is treated as highly confidential and stored in accordance with data protection regulations.</div>
	<c:set var="fieldXpath" value="${xpath}/maskedNumber" />
	<form_v3:row fieldXpath="${fieldXpath}" label="Credit Card Details" renderLabelAsSimplesDialog="true">
		<field_v2:input xpath="${fieldXpath}" className="payment-ipp-maskedNumber sessioncamexclude" required="true" title="your secure credit card details" additionalAttributes=" data-rule-validateBupaCard='true'" readOnly="${false}" />
	</form_v3:row>
</div>
