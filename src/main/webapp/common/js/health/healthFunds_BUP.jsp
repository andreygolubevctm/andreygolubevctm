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
	$paymentType : $('#health_payment_details_type input'),
	$paymentFrequency : $('#health_payment_details_frequency'),
	$paymentStartDate: $("#health_payment_details_start"),
	$claimsAccountOptin: $('#health_payment_bank_claims'),
	$primaryMiddleName: $('#health_application_primary_middleName'),
	$partnerMiddleName: $('#health_application_partner_middleName'),
set: function () {
	"use strict";

		<%-- Authority Fund Name --%>
        meerkat.modules.healthFunds._previousfund_authority(true);
		$('#health_previousfund_primary_authority').setRequired(true, 'Bupa requires authorisation to contact your previous fund');
		$('#health_previousfund_partner_authority').setRequired(true, 'Bupa requires authorisation to contact your partner\'s previous fund');
		healthFunds_BUP.$primaryMiddleName.setRequired(false);
		healthFunds_BUP.$partnerMiddleName.setRequired(false);

		<%-- calendar for start cover --%>
		if(_.has(meerkat.modules,'healthCoverStartDate')) {
			meerkat.modules.healthCoverStartDate.setCoverStartRange(0, 60);
		} else {
			meerkat.modules.healthPaymentStep.setCoverStartRange(0, 60);
		}

		<%-- Increase minimum age requirement for applicants from 16 to 17 --%>
		healthFunds_BUP.$_dobPrimary = $('#health_application_primary_dob');
		healthFunds_BUP.$_dobPartner = $('#health_application_partner_dob');
		healthFunds_BUP.$_dobPrimary.addRule('youngestDOB', 17, "primary person's age cannot be under 17");
		healthFunds_BUP.$_dobPartner.addRule('youngestDOB', 17, "partner's age cannot be under 17");

		<%-- Payment Options --%>
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });

		healthFunds_BUP.$paymentType.on('change.BUP', function updatePaymentMsgPaymentType(){
			healthFunds_BUP.updateMessage();
		});

		healthFunds_BUP.$paymentFrequency.on('change.BUP', function updatePaymentMsgFrequency(){
			healthFunds_BUP.updateMessage();
		});

		healthFunds_BUP.$paymentStartDate.on("changeDate.BUP", function updatePaymentMsgCalendar(e) {
			healthFunds_BUP.updateMessage();
		});

		<%-- credit card options --%>
	meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':true, 'diners':false });
		meerkat.modules.healthCreditCard.render();

		meerkat.modules.healthPaymentIPP.show();

		<%-- Dependant's Age and message --%>
    meerkat.modules.healthFunds._dependants('Dependent child means a person who does not have a partner and is \(i\) aged under 21 or \(ii\) is receiving a full time education at a school, college or university recognised by the company and who is not aged 25 or over.');
	meerkat.modules.healthDependants.setMaxAge(25);
	meerkat.modules.healthDependants.updateConfig({showMiddleName: true});

		<%-- Unset the refund optin radio buttons --%>
		healthFunds_BUP.$claimsAccountOptin.find("input:checked").each(function(){
		  $(this).prop("checked",null).trigger("change");
		});
		
		<%-- Fix name field widths to account for the middleName field --%>
		healthFunds_BUP.$primaryFirstname = $('#health_application_primary_firstname').closest('.row-content');
		healthFunds_BUP.$primarySurname = $('#health_application_primary_surname').closest('.row-content');
		healthFunds_BUP.$partnerFirstname = $('#health_application_partner_firstname').closest('.row-content');
		healthFunds_BUP.$partnerSurname = $('#health_application_partner_surname').closest('.row-content');
		healthFunds_BUP.$primaryFirstname.removeClass('col-sm-4').addClass('col-lg-4 col-sm-3');
		healthFunds_BUP.$primarySurname.removeClass('col-sm-4').addClass('col-lg-4 col-sm-3');
		healthFunds_BUP.$partnerFirstname.removeClass('col-sm-4').addClass('col-lg-4 col-sm-3');
		healthFunds_BUP.$partnerSurname.removeClass('col-sm-4').addClass('col-lg-4 col-sm-3');

	},
	updateMessage: function() {
		var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
		if (freq == 'fortnightly') {
			var deductionText = "Your initial payment will be one month's premium and a fortnightly amount thereafter. Your account will be debited within the next 24 hours.";
		} else {
			var deductionText = 'Your account will be debited within the next 24 hours.';
		};

		meerkat.modules.healthFunds.setPayments({ 'min':6, 'max':7, 'weekends':false });
		healthFunds_BUP.$paymentStartDate.datepicker('setDaysOfWeekDisabled', '0,6');

		var date = new Date();
		var _html = meerkat.modules.healthPaymentDay.paymentDays(meerkat.modules.dateUtils.dateValueFormFormat(date));
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);

		<%-- Select the only option --%>
		$('.health_payment_credit_details-policyDay').prop('selectedIndex',1);
		$('.health_payment_bank_details-policyDay').prop('selectedIndex',1);
		<%-- Change the deduction rate --%>

		$('.health_payment_credit-details_policyDay-message').text( deductionText);
		$('.health_payment_bank-details_policyDay-message').text(deductionText);
	},
	unset: function () {
		"use strict";
        meerkat.modules.healthFunds._reset();

		<%-- Authority Fund Name --%>
        meerkat.modules.healthFunds._previousfund_authority(false);
		$('#health_previousfund_primary_authority, #health_previousfund_partner_authority').setRequired(false);

		<%-- Dependants --%>
        meerkat.modules.healthFunds._dependants(false);

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

		healthFunds_BUP.$paymentType.off('change.BUP');
		healthFunds_BUP.$paymentFrequency.off('change.BUP');
		healthFunds_BUP.$paymentStartDate.off("changeDate.BUP");

		$('.bup-payment-legend').remove();
		
		<%-- Fix name field widths to account for removal of middleName field --%>
		healthFunds_BUP.$primaryFirstname.removeClass('col-lg-4 col-sm-3').addClass('col-sm-4');
		healthFunds_BUP.$primarySurname.removeClass('col-lg-4 col-sm-3').addClass('col-sm-4');
		healthFunds_BUP.$partnerFirstname.removeClass('col-lg-4 col-sm-3').addClass('col-sm-4');
		healthFunds_BUP.$partnerSurname.removeClass('col-lg-4 col-sm-3').addClass('col-sm-4');

		healthFunds_BUP.$primaryMiddleName.setRequired(true);
		healthFunds_BUP.$partnerMiddleName.setRequired(true);

		<%-- Unset any ipp tokenisation --%>
		meerkat.modules.healthPaymentIPP.reset();
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />