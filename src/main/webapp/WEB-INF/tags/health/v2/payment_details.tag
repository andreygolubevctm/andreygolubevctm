<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="base_xpath" required="true"	 rtexprvalue="true"	 description="the base xpath without 'details' as we have moved credit/payment inside this fieldset. " %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="field_frequency" value="${xpath}/frequency" />
<c:set var="field_frequency" value="${go:nameFromXpath(field_frequency)}" />
<c:set var="disclaimer_content"><content:get key="paymentDisclaimer" /></c:set>

<!-- This is a deactivated split test as it is likely to be run again in the future -->
<%-- <jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" /> --%>
<%-- <c:set var="isAltView" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}" /> --%>

<health_v1:dual_pricing_settings />

<%-- HTML --%>
<div id="${name}-selection" class="health-payment_details ">

	<form_v3:fieldset legend="Payment Details" >

		<c:if test="${isDualPriceActive eq true}">
			<div class="alert alert-info">
				Remember: Premiums will rise from 1st April. You <b>must</b> select a cover start date <b>before <span class="pricingDateText"></span></b> and a payment start date <b>before <span class="dropDeadDateText"></span></b> to be eligible for the lower rate
			</div>
		</c:if>

		<div class="fundWarning alert alert-danger">
				<%-- insert fund warning data --%>
		</div>

		<health_v2:calendar xpath="${xpath}" />

		<c:set var="fieldXpath" value="${xpath}/type" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Payment method" className="changes-premium">
			<field_v2:array_radio items="cc=Credit Card,ba=Bank Account" xpath="${fieldXpath}" title="how would you like to pay" required="true" className="health-payment_details-type" id="${name}_type" />
		</form_v3:row>

		<%-- Note: this form row's HTML is changed by JavaScript --%>
		<c:set var="fieldXpath" value="${xpath}/frequency" />
		<form_v3:row fieldXpath="${fieldXpath}" label="How often would you like to make payments" className="changes-premium">
			<field_v2:array_select items="=Please choose..." xpath="${fieldXpath}" title="frequency of payments" required="true" delims="||" className="health-payment_details-frequency" />
			<div class="fieldrow_legend lhcText"></div>
		</form_v3:row>

		<c:if test="${isDualPriceActive eq true}">
			<div class="hidden frequencyWarning simples-dialogue mandatory"></div>
		</c:if>

		<c:set var="fieldXpath" value="${xpath}/claims" />
		<form_v3:row fieldXpath="${fieldXpath}" label="Do you want to supply bank account details for claims to be paid into" className="health-payment_details-claims-group">
			<field_v2:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="if you want to supply bank account details for claims to be paid into" required="true" className="health-payment_details-claims" id="${name}_claims"/>
		</form_v3:row>

		<simples:dialogue id="79" vertical="health" className="hidden" />
		<simples:dialogue id="80" vertical="health" className="hidden" />
		<simples:dialogue id="88" vertical="health" className="hidden" />
		<simples:dialogue id="89" vertical="health" className="hidden" />
		<simples:dialogue id="90" vertical="health" className="hidden" />
		<simples:dialogue id="91" vertical="health" className="hidden" />
		<simples:dialogue id="92" vertical="health" className="hidden" />
		<simples:dialogue id="103" vertical="health" className="hidden" />

		<health_v2:price_promise_check xpath="health/price_promise" />

		<health_v2:vouchers xpath="health/voucher" />

		<c:if test="${not empty disclaimer_content}">
			<c:set var="fieldXpath" value="${xpath}/disclaimer" />
			<form_v3:row fieldXpath="${fieldXpath}" hideHelpIconCol="true">
				<field_v2:checkbox xpath="${fieldXpath}" value="Y" title="${disclaimer_content}" required="true" errorMsg="Please read and accept the Payment Disclaimer in order to proceed" label="true" />
			</form_v3:row>
		</c:if>

	</form_v3:fieldset>

</div>
