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

		<simples:dialogue id="110" vertical="health" className="red" />

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

		<simples:dialogue id="105" vertical="health" className="hidden simples-affiliate-dialogue" />

		<health_v2:price_promise_check xpath="health/price_promise" />

		<health_v2:vouchers xpath="health/voucher" />

		<div id="possibleMatchingCustomer">
			<h5>Split Transaction found</h5>
			<p>Some of the customer details in this transaction match a previous sale made within the last 60 days. Please select a reason for the split transaction.</p>

			<div class="disableable-fields">

				<c:set var="fieldXpath" value="${xpath}/splitTransaction/matched/transactionId" />
				<form_v3:row fieldXpath="${fieldXpath}" label="Matched transaction Id" className="healthSplitTransactionTransIdRow">
					<field_v2:input readOnly="true" xpath="${fieldXpath}" title="Matched transaction Id" required="false" className="health-payment_details-splitTransaction_trans-Id" />
					<p id="healthSplitTransactionTransactionId" class="display-only"></p>
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/splitTransaction/matched/rootId" />
				<form_v3:row fieldXpath="${fieldXpath}" label="Matched root Id" className="healthSplitTransactionRootIdRow">
					<field_v2:input readOnly="true" xpath="${fieldXpath}" title="Matched Root Id" required="false" className="health-payment_details-splitTransaction_root-Id" />
					<p id="healthSplitTransactionRootId" class="display-only"></p>
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/splitTransaction/matched/fullName" />
				<form_v3:row fieldXpath="${fieldXpath}" label="Matched full name" className="healthSplitTransactionfullNameRow">
					<field_v2:input readOnly="true" xpath="${fieldXpath}" title="Matched full name" required="false" className="health-payment_details-splitTransaction_full-name" />
					<p id="healthSplitTransactionFullName" class="display-only"></p>
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/splitTransaction/matched/date" />
				<form_v3:row fieldXpath="${fieldXpath}" label="Matched date" className="healthSplitTransactionDateRow">
					<field_v2:input readOnly="true" xpath="${fieldXpath}" title="Matched date" required="false" className="health-payment_details-splitTransaction_date" />
					<p id="healthSplitTransactionDate" class="display-only"></p>
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/splitTransaction/matched/time" />
				<form_v3:row fieldXpath="${fieldXpath}" label="Matched time" className="healthSplitTransactionTimeRow">
					<field_v2:input readOnly="true" xpath="${fieldXpath}" title="Matched time" required="false" className="health-payment_details-splitTransaction_time" />
					<p id="healthSplitTransactionTime" class="display-only"></p>
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/splitTransaction/matched/operatorId" />
				<form_v3:row fieldXpath="${fieldXpath}" label="Matched operator id" className="healthSplitTransactionOperatorIdRow">
					<field_v2:input readOnly="true" xpath="${fieldXpath}" title="Matched operator id" required="false" className="health-payment_details-splitTransaction_operator-id" />
					<p id="healthSplitTransactionOperatorId" class="display-only"></p>
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/splitTransaction/reason" />
				<form_v3:row fieldXpath="${fieldXpath}" label="Reason for split transaction?" className="healthSplitTransactionReasonRow">
					<field_v2:array_select items="=Please choose...,HES=Hospital extras split contact centre,CSP=Couple Split on Different Policies,FSP=Family or Couple Split on Same Policy,CRX=Customer Resold Cancel Previous Policy,CSS=Child Sold Separate to family,DSP=Double Sold Same Policy,BFS=Blood Family Split (ie brothers and sisters),RPF=Reprocessed Failed Join,FDA=False Duplicate (to be Audited)" xpath="${fieldXpath}" title="split transaction reason" required="false" className="health-payment_details-splitTransaction_reason" />
					<p id="healthSplitTransactionReason" class="display-only"></p>
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/splitTransaction/approvedby" />
				<form_v3:row fieldXpath="${fieldXpath}" label="Approved By?" className="healthSplitTransactionApprovedByRow">
					<p id="healthSplitTransactionApprovedBy" class="display-only"></p>
					<field_v1:hidden xpath="${fieldXpath}" required="false" validationMessage="Voucher much be approved" />  <%-- the required prop might need to be set dynamically  --%>
				</form_v3:row>

				<c:set var="fieldXpath" value="${xpath}/splitTransaction/authorisationcode" />
				<c:set var="wrapperClass" value="authorisation-column" />
				<form_v3:row fieldXpath="${fieldXpath}" label="Team Leader Authorisation?" className="healthSplitTransactionAuthorisationRow" isNestedField="${false}" hideHelpIconCol="${true}" smRowOverride="6">
					<div class="split-trans-validation-messages"><!-- empty --></div>
					<div class="col-xs-12 col-sm-7 ${wrapperClass}">
						<field_v1:password xpath="${fieldXpath}" required="false" title="authorisation code" placeHolder="authorisation code" />
					</div>
					<div class="col-xs-12 col-sm-5 ${wrapperClass} buttons">
						<a href="javascript:;" class="btn btn-cta btn-authorise">AUTHORISE</a>
						<a href="javascript:;" class="btn btn-save btn-reset">RESET</a>
					</div>
				</form_v3:row>
			</div>
		</div>

		<c:if test="${not empty disclaimer_content}">
			<c:set var="fieldXpath" value="${xpath}/disclaimer" />
			<form_v3:row fieldXpath="${fieldXpath}" hideHelpIconCol="true">
				<field_v2:checkbox xpath="${fieldXpath}" value="Y" title="${disclaimer_content}" required="true" errorMsg="Please read and accept the Payment Disclaimer in order to proceed" label="true" />
			</form_v3:row>
		</c:if>

	</form_v3:fieldset>

</div>
