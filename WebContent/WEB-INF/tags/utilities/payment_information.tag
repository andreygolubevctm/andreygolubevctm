<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Applicant's situation group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<fmt:setLocale value="en_GB" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="${name}">

	<form:fieldset legend="Payment Information" className="no-background-color" id="${name}_fieldset">

		<div id="${name}_template_placeholder"></div>

		<core:js_template id="payment-information-template">
			<p>All Dodo Power &amp; Gas plans require automatic monthly direct debit instalment payments. Dodo Power &amp; Gas will call you after they receive your application to collect your bank account or credit card details.</p>
			<p>Your first instalment is paid in advance after you provide your payment details to Dodo Power &amp; Gas. Your first instalment payment amount will be $[#= monthlyEstCost #]. Once the transfer of your electricity account is completed the next instalment payment will be deducted. When your electricity meter is read each quarter and your bill calculated, any balance owing is deducted along with your next scheduled instalment. Monthly payments will be regularly reviewed, using your actual electricity usage history. You can choose the day of the month on which your payments are deducted.</p>
		</core:js_template>

	</form:fieldset>

</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${name}_fieldset{
		display: none;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var utilitiesPaymentInformation = {

		init: function(){



		}
	};

</go:script>

<go:script marker="onready">

	utilitiesPaymentInformation.init();

</go:script>

<%-- VALIDATION --%>
