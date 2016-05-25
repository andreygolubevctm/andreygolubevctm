<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
BUP
=======================
--%>
var healthFunds_BUP = {

set: function () {
	"use strict";

		<%-- Authority Fund Name --%>
		healthFunds._previousfund_authority(true);
		$('#health_previousfund_primary_authority').setRequired(true, 'Bupa requires authorisation to contact your previous fund');
		$('#health_previousfund_partner_authority').setRequired(true, 'Bupa requires authorisation to contact your partner\'s previous fund');

		<%-- calendar for start cover --%>
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 60);

		<%-- Increase minimum age requirement for applicants from 16 to 17 --%>
		healthFunds_BUP.$_dobPrimary = $('#health_application_primary_dob');
		healthFunds_BUP.$_dobPartner = $('#health_application_partner_dob');
		healthFunds_BUP.$_dobPrimary.addRule('youngestDOB', 17, "primary person's age cannot be under 17");
		healthFunds_BUP.$_dobPartner.addRule('youngestDOB', 17, "partner's age cannot be under 17");

		<%-- Payment Options --%>
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly':false, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });

		<%-- Payment Day --%>
		$('#update-premium').on('click.BUP', function() {
			var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
			if (freq == 'fortnightly') {
				var deductionText = "Your initial payment will be one month's premium and a fortnightly amount thereafter. Your account will be debited within the next 24 hours.";
			} else {
				var deductionText = 'Your account will be debited within the next 24 hours.';
			};

			healthFunds._payments = { 'min':6, 'max':7, 'weekends':false };

			var date = new Date();
			var _html = meerkat.modules.healthPaymentDay.paymentDays(meerkat.modules.dateUtils.dateValueFormFormat(date));
			meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
			meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);

			<%-- Select the only option --%>
			$('.health_payment_credit_details-policyDay').prop('selectedIndex',1);
			$('.health_payment_bank_details-policyDay').prop('selectedIndex',1);
			<%-- Change the deduction rate --%>

			$('.health_credit-card-details_policyDay-message').text( deductionText);
			$('.health_payment_bank-details_policyDay-message').text(deductionText);
		});

		<%-- credit card options --%>
	meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':true, 'diners':false });
		meerkat.modules.healthCreditCard.render();

		meerkat.modules.healthPaymentIPP.show();

		<%-- Dependant's Age and message --%>
		healthFunds._dependants('Dependent child means a person who does not have a partner and is \(i\) aged under 21 or \(ii\) is receiving a full time education at a school, college or university recognised by the company and who is not aged 25 or over.');
	meerkat.modules.healthDependants.setMaxAge(25);
	meerkat.modules.healthDependants.updateConfig({showMiddleName: true});

	},
	unset: function () {
		"use strict";
		healthFunds._reset();

		<%-- Authority Fund Name --%>
		healthFunds._previousfund_authority(false);
		$('#health_previousfund_primary_authority, #health_previousfund_partner_authority').setRequired(false);

		<%-- Dependants --%>
		healthFunds._dependants(false);

		<%-- Age requirements for applicants (back to default) --%>

		healthFunds_BUP.$_dobPrimary.addRule('youngestDOB', dob_health_application_primary_dob.ageMin, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
		healthFunds_BUP.$_dobPartner.addRule('youngestDOB', dob_health_application_partner_dob.ageMin, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

		healthFunds_BUP.$_dobPrimary = undefined;
		healthFunds_BUP.$_dobPartner = undefined;

		<%-- fund Name's become mandatory (back to default) --%>
		$('#health_previousfund_primary_fundName, #health_previousfund_partner_fundName').setRequired(true);

		<%-- credit card options --%>
		meerkat.modules.healthCreditCard.resetConfig();
		meerkat.modules.healthCreditCard.render();

		meerkat.modules.healthPaymentIPP.hide();

		<%-- selections for payment date --%>
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), false);
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), false);
		$('#update-premium').off('click.BUP');

		$('.bup-payment-legend').remove();
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />