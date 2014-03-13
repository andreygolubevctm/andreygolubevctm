<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
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
		$('#health_previousfund_primary_authority').rules('add', {required:true, messages:{required:'Bupa requires authorisation to contact your previous fund'}});
		$('#health_previousfund_partner_authority').rules('add', {required:true, messages:{required:'Bupa requires authorisation to contact your partner\'s previous fund'}});

		<%-- calendar for start cover --%>
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 60);

		<%-- Age requirements for applicants --%>
		<%-- primary --%>
		healthFunds_BUP.$_dobPrimary = $('#health_application_primary_dob');
		healthFunds_BUP.defaultAgeMin = dob_health_application_primary_dob.ageMin;
		dob_health_application_primary_dob.ageMin = 17;
		healthFunds_BUP.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_primary_dob': healthFunds_BUP.$_dobPrimary.attr('title') + ' age cannot be under ' + dob_health_application_primary_dob.ageMin} } );
		<%-- partner --%>
		healthFunds_BUP.$_dobPartner = $('#health_application_partner_dob');
		dob_health_application_partner_dob.ageMin = 17;
		healthFunds_BUP.$_dobPartner.rules('add', {messages: {'min_dob_health_application_partner_dob': healthFunds_BUP.$_dobPartner.attr('title') + ' age cannot be under ' + dob_health_application_partner_dob.ageMin} } );

		<%-- fund IDs become optional --%>
		$('#clientMemberID input').rules("remove", "required");
		$('#partnerMemberID input').rules("remove", "required");

		<%-- Payment Options --%>
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly':false, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });

		<%-- Payment Day --%>
		$('#update-premium').on('click.BUP', function() {
			var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
			if (freq == 'fortnightly') {
				var deductionText = "Your initial payment will be one month's premium and a fortnightly amount thereafter. Your account will be debited within the next five working days.";
			} else {
				var deductionText = 'Your account will be debited within the next five working days.';
			};

			healthFunds._payments = { 'min':6, 'max':7, 'weekends':false };
			function pad (str, max) {
				return str.length < max ? pad("0" + str, max) : str;
			}
			var date = new Date();
			var d = pad(date.getDate().toString(), 2);
			var m = pad((date.getMonth()+1).toString(), 2);
			var y = date.getFullYear();
			var _html = healthFunds._paymentDays(d + '/' + m + '/' + y);
			healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
			healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);

			<%-- Select the only option --%>
			$('.health-credit-card_details-policyDay').prop('selectedIndex',1);
			$('.health-bank_details-policyDay').prop('selectedIndex',1);
			<%-- Change the deduction rate --%>

			$('.health_credit-card-details_policyDay-message').text( deductionText);
			$('.health_bank-details_policyDay-message').text(deductionText);
		});

		<%-- credit card options --%>
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':true, 'diners':false };
		creditCardDetails.render();

		meerkat.modules.healthPaymentIPP.show();

		<%-- Inject CSS --%>
		<c:set var="html">
			<style type="text/css">
				body.BUP .health_popup_payment_ipp,
				body.BUP .health_person-details_middlename,
				body.BUP .health_dependant_details_middleName,
				body.BUP .health-medicare_details,
				body.BUP .health_previous_fund_authority,
				body.BUP .health_bank-details_policyDay-group,
				body.BUP .health_bank-details_policyDay-message,
				body.BUP .health_credit-card-details_policyDay-group,
				body.BUP .health_credit-card-details_policyDay-message {
					display:block !important;
				}
				body.BUP .health_dependant_details_schoolGroup,
				body.BUP .health_credit-card-details_number,
				body.BUP .health_credit-card-details_ccv,
				body.BUP .health_credit-card-details_day_group,
				body.BUP .health_bank-details_day-group,
				body.BUP #clientMemberID .clientMemberID,
				body.BUP #partnerMemberID .partnerMemberID,
				body.BUP .health-payment_details .definition,
				body.BUP .membership h5 {
					display:none !important;
				}
				body.BUP .membership #clientMemberID .fieldrow_label,
				body.BUP .membership #partnerMemberID .fieldrow_label,
				body.BUP .health_credit-card-details_policyDay-group label {
					visibility:hidden !important;
				}
				body.BUP .health_credit-card-details_policyDay-group .select,
				body.BUP .health_bank-details_policyDay-group .select {
					position: absolute;
					visibility: hidden;
				}
				body.BUP .health_bank-details_policyDay-group .control_label,
				body.BUP .health_credit-card-details_policyDay-group .control_label {
					visibility: hidden;
				}
			</style>
		</c:set>
		$('head').append('<c:out value="${html}" escapeXml="false" />');

		<%-- Dependant's Age and message --%>
		healthFunds._dependants('Dependent child means a person who does not have a partner and is \(i\) aged under 21 or \(ii\) is receiving a full time education at a school, college or university recognised by the company and who is not aged 25 or over.');
		healthDependents.maxAge = 25;

	},
	unset: function () {
		"use strict";
		healthFunds._reset();

		<%-- Authority Fund Name --%>
		healthFunds._previousfund_authority(false);
		$('#health_previousfund_primary_authority').rules('remove', 'required');
		$('#health_previousfund_partner_authority').rules('remove', 'required');

		<%-- Dependants --%>
		healthFunds._dependants(false);

		<%-- Age requirements for applicants (back to default) --%>
		dob_health_application_primary_dob.ageMin = healthFunds_BUP.defaultAgeMin;
		healthFunds_BUP.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_primary_dob': healthFunds_BUP.$_dobPrimary.attr('title') + ' age cannot be under ' + dob_health_application_primary_dob.ageMin} } );

		dob_health_application_partner_dob.ageMin = healthFunds_BUP.defaultAgeMin;
		healthFunds_BUP.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_partner_dob': healthFunds_BUP.$_dobPartner.attr('title') + ' age cannot be under ' + dob_health_application_partner_dob.ageMin} } );

		healthFunds_BUP.defaultAgeMin = undefined;
		healthFunds_BUP.$_dobPrimary = undefined;
		healthFunds_BUP.$_dobPartner = undefined;

		<%-- fund Name's become mandatory (back to default) --%>
		$('#health_previousfund_primary_fundName').attr('required', 'required');
		$('#health_previousfund_partner_fundName').attr('required', 'required');

		<%-- credit card options --%>
		creditCardDetails.resetConfig();
		creditCardDetails.render();

		meerkat.modules.healthPaymentIPP.hide();

		<%-- selections for payment date --%>
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		$('#update-premium').off('click.BUP');

		$('.bup-payment-legend').remove();
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />