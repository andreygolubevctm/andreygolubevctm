<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
BUD (Budget Direct)
=======================
--%>
var healthFunds_BUD = {
	$policyDateCreditMessage : $('.health_credit-card-details_policyDay-message'),
	$policyDateBankMessage : $('.health_bank-details_policyDay-message'),
	set: function(){
		<%-- inject bud current customer question --%>
		if ($('#bud_current_customer').length > 0) {
			<%-- HTML was already injected so unhide it --%>
			$('#bud_current_customer').show();
			<%-- Reflow current customer question --%>
			$('#bud_current_customer .bud-main select').trigger('change');
		} else {
			<c:set var="budCurrentCustomerHtml">

				<form_new:fieldset id="bud_current_customer" legend="Current Customer" className="primary">

					<c:set var="fieldXpath" value="health/application/currentCustomer" />
					<form_new:row fieldXpath="${fieldXpath}" label="Are you a current Budget Direct customer?" className="bud-main" helpId="531">
						<field_new:array_select xpath="${fieldXpath}" required="true" title="Are you a current Budget Direct customer" items="=Please choose...,Y=Yes,N=No" />
					</form_new:row>
					

					<c:set var="fieldXpath" value="health/application/currentCustomerPolicyNo" />
					<form_new:row fieldXpath="${fieldXpath}" label="My policy number is" className="bud-sub">
						<field_new:input xpath="${fieldXpath}" title="" required="true" maxlength="20" />
					</form_new:row>

				</form_new:fieldset>

			</c:set>
			$('#health_application').prepend('<c:out value="${budCurrentCustomerHtml}" escapeXml="false" />');
			$('#bud_current_customer .bud-sub').hide();
		}
		
		<%-- show or hide policy number field --%>
		$('#bud_current_customer .bud-main select').on('change', function() {
			if ($(this).val() === 'Y') {
				$('#bud_current_customer .bud-sub').slideDown(200);
			} else {
				$('#bud_current_customer .bud-sub').slideUp(200);
			}
		});
		<%-- dependant definition --%>
		healthFunds._dependants('This policy provides cover for children until their 21st birthday. Adult dependants over 21 years old can be covered by applying for a separate singles policy.');

		<%-- Authority --%>
		healthFunds._previousfund_authority(true);

		<%-- remove the DR in your details --%>
		healthFunds.$_optionDR = $('.person-title').find('option[value=DR]').first();
		$('.person-title').find('option[value=DR]').remove();

		<%-- selections for payment date --%>
		$('#update-premium').on('click.BUD', function(){
			var messageField = null;
			if(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc'){
				messageField = healthFunds_BUD.$policyDateCreditMessage;
			} else {
				messageField = healthFunds_BUD.$policyDateBankMessage;
			}
			meerkat.modules.healthPaymentDate.paymentDaysRenderEarliestDay(messageField, $('#health_payment_details_start').val(), [1,15], 7);
		});

		<%-- change age of dependants and school --%>
		healthDependents.config.school = false;
		healthDependents.maxAge = 21;

		<%-- fund ID's become optional --%>
		$('#clientMemberID input').rules("remove", "required");
		$('#partnerMemberID input').rules("remove", "required");

		<%-- credit card & bank account frequency & day frequency --%>
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

		<%-- claims account --%>
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		<%-- credit card options --%>
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		<%-- calendar for start cover --%>
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);
	},
	unset: function(){
		<%-- Custom questions - hide in case user comes back --%>
		$('#bud_current_customer, #bud_current_customer .bud-sub').hide();

		healthFunds._reset();

		<%-- dependant definition off --%>
		healthFunds._dependants(false);

		<%-- Authority off --%>
		healthFunds._previousfund_authority(false);

		<%-- re-insert the DR in your details --%>
		$('.person-title').append( healthFunds.$_optionDR    );

		<%-- selections for payment date --%>
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
		$('#update-premium').off('click.BUD');

		<%-- credit card options --%>
		creditCardDetails.resetConfig();
		creditCardDetails.render();

	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />