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
		$('#clientMemberID input[type=text], #partnerMemberID input[type=text]').setRequired(false);

		<%-- credit card & bank account frequency & day frequency --%>
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

		<%-- claims account --%>
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		<%-- credit card options --%>
		meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
		meerkat.modules.healthCreditCard.render();

		<%-- calendar for start cover --%>
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);
	},
	unset: function(){
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
		meerkat.modules.healthCreditCard.resetConfig();
		meerkat.modules.healthCreditCard.render();

	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />