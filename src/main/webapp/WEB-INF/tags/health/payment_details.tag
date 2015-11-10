<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="field_frequency" value="${xpath}/frequency" />
<c:set var="field_frequency" value="${go:nameFromXpath(field_frequency)}" />
<c:set var="disclaimer_content"><content:get key="paymentDisclaimer" /></c:set>

<!-- This is a deactivated split test as it is likely to be run again in the future -->
<%-- <jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" /> --%>
<%-- <c:set var="isAltView" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}" /> --%>

<%-- HTML --%>
<div id="${name}-selection" class="health-payment_details">

	<form_new:fieldset legend="Payment Details" >

		<div class="definition alert alert-info">
			<%-- insert promo data --%>
		</div>
		<div class="fundWarning alert alert-danger">
			<%-- insert fund warning data --%>
		</div>

		<health:calendar xpath="${xpath}" />

		<c:set var="fieldXpath" value="${xpath}/type" />
		<form_new:row fieldXpath="${fieldXpath}" label="Payment method" className="changes-premium">
			<field_new:array_radio items="cc=Credit Card,ba=Bank Account" xpath="${fieldXpath}" title="how would you like to pay" required="true" className="health-payment_details-type" id="${name}_type"/>
		</form_new:row>

		<%-- Note: this form row's HTML is changed by JavaScript --%>
		<c:set var="fieldXpath" value="${xpath}/frequency" />
		<form_new:row fieldXpath="${fieldXpath}" label="How often would you like to make payments" className="changes-premium">
			<field_new:array_select items="=Please choose..." xpath="${fieldXpath}" title="frequency of payments" required="true" delims="||" className="health-payment_details-frequency" />
		</form_new:row>
		
		<c:set var="fieldXpath" value="${xpath}/claims" />
		<form_new:row fieldXpath="${fieldXpath}" label="Do you want to supply bank account details for claims to be paid into" className="health-payment_details-claims-group">
			<field_new:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="if you want to supply bank account details for claims to be paid into" required="true" className="health-payment_details-claims" id="${name}_claims"/>
		</form_new:row>

		<coupon:fields xpath="health" />

		<c:if test="${not empty disclaimer_content}">
			<c:set var="fieldXpath" value="${xpath}/disclaimer" />
			<form_new:row fieldXpath="${fieldXpath}" hideHelpIconCol="true">
				<field_new:checkbox xpath="${fieldXpath}" value="Y" title="${disclaimer_content}" required="true" errorMsg="Please read and accept the Payment Disclaimer in order to proceed" label="true" />
			</form_new:row>
		</c:if>

		<form_new:row className="health-payment-details_update" hideHelpIconCol="true">
			<a href="javascript:void(0);" class="btn btn-next col-xs-12 col-sm-8 col-md-5 journeyNavButton" id="update-premium">Update Premium <span class="icon icon-arrow-right"></span></a>
		</form_new:row>

		<form_new:row label="Your Premium" className="health-payment-details_premium">
			<div class="policySummaryContainer formMode">
				<c:choose>
					<c:when test="${isAltView}">
						<div class="priceItemisationTemplateHolder priceItemisation hidden-xs hidden-sm"></div>
						<div class="policySummaryTemplateHolder productSummary horizontal no-logo hidden-md hidden-lg"></div>
					</c:when>
					<c:otherwise>
			<div class="policySummaryTemplateHolder productSummary horizontal no-logo"></div>
					</c:otherwise>
				</c:choose>
			</div>
		</form_new:row>

	</form_new:fieldset>

</div>

