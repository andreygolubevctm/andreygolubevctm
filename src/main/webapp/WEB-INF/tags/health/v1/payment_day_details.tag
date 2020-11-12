<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<div class="${name}-selection">

		<%-- Default (HCF) payment day question --%>
		<c:set var="fieldXpath" value="${xpath}/day" />
		<form_v3:row fieldXpath="${fieldXpath}"
					 label="What day would you like your payment deducted?"
					 className="${name}-details_day-group" renderLabelAsSimplesDialog="true">
			<field_v2:count_select xpath="${fieldXpath}"
								   min="1"
								   max="27"
								   step="1"
								   title="your chosen day"
						required="true" className="${name}-day"/>
		</form_v3:row>
		
		<%-- NIB based payment day --%>
		<c:set var="fieldXpath" value="${xpath}/paymentDay" />
		<form_v3:row fieldXpath="${fieldXpath}" label="What day would you like your payment deducted?"
					 className="${name}-details_paymentDay_group" renderLabelAsSimplesDialog="true">
			<field_v1:payment_day xpath="${fieldXpath}"
								  title="your chosen day" required="true"
								  className="health_payment_day ${name}-paymentDay"
								  messageClassName="health_payment-day_message"
								  message="It can take up to 6 days to set up your direct debit so your payment may not be deducted until the following month if you chose a date within this time frame"/>
		</form_v3:row>
		
		<%-- AUF based payment day --%>
		<c:set var="fieldXpath" value="${xpath}/policyDay" />
		<form_v3:row fieldXpath="${fieldXpath}" label="What day would you like your payment deducted?" className="${name}-details_policyDay-group" renderLabelAsSimplesDialog="true">
			<field_v2:array_select xpath="${fieldXpath}"
						required="true" className="${name}_details-policyDay" items="=Please choose..." title="your chosen day" />
			<p class="${name}-details_policyDay-message"></p>
		</form_v3:row>

</div>
