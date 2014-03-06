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
		healthFunds._authority(true);
		$('#health_previousfund_primary_authority').rules('add', {required:true, messages:{required:'Bupa requires authorisation to contact your previous fund'}});
		$('#health_previousfund_partner_authority').rules('add', {required:true, messages:{required:'Bupa requires authorisation to contact your partner\'s previous fund'}});

		<%-- calendar for start cover --%>
		healthCalendar._min = 0;
		healthCalendar._max = 60;
		healthCalendar.update();

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

		<%-- fund ID's become optional --%>
		$('#clientMemberID').find('input').rules("remove", "required");
		$('#partnerMemberID').find('input').rules("remove", "required");

		<%-- Payment Options --%>
		paymentSelectsHandler.bank = { 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true };
		paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true };

		<%-- Payment Day --%>
		$('#update-step').on('click.BUP', function() {
			var freq = paymentSelectsHandler.getFrequency();
			if (freq == 'F') {
				var deductionText = "Your initial payment will be one month's premium and a fortnightly amount thereafter. Your account will be debited within the next five working days.";
			} else {
				var deductionText = 'Your account will be debited within the next five working days.';
			};

			healthFunds._payments = {
							'min':6,
							'max':7,
							'weekends':false,
							};
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
				body.BUP #health_previousfund_primary_memberID,
				body.BUP #health_previousfund_partner_memberID,
				body.BUP .health-payment_details .definition,
				body.BUP .membership h5 {
					display:none !important;
				}
				body.BUP .membership #clientMemberID .fieldrow_label,
				body.BUP .membership #partnerMemberID .fieldrow_label {
					visibility:hidden !important;
				}
				body.BUP .health-credit-card_details-policyDay,
				body.BUP .health-bank_details-policyDay {
					position:absolute;
					left:-999em;
				}
				body.BUP .health_bank-details_policyDay-group .fieldrow_label,
				body.BUP .health_credit-card-details_policyDay-group .fieldrow_label {
					visibility:hidden;
				}
				body.BUP .membership .inlineMessage {
					width:110px !important;
					top: 3px;
				}
				body.BUP .membership.onA.onB .inlineMessage {
					top:26px !important;
				}
				body.BUP .membership.onB .inlineMessage {
					top:5px !important;
				}
				body.BUP .health_bank-details_policyDay-message {
					width:30em;
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
		healthFunds._authority(false);
		$('#health_previousfund_primary_authority').rules('remove', 'required');
		$('#health_previousfund_partner_authority').rules('remove', 'required');

		<%-- Dependants --%>
		healthFunds._dependants(false);

		<%-- Age requirements for applicants (back to default) --%>
		dob_health_application_primary_dob.ageMin = healthFunds_BUP.defaultAgeMin;
		healthFunds_BUP.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_primary_dob': healthFunds_BUP.$_dobPrimary.attr('title') + ' age cannot be under ' + dob_health_application_primary_dob.ageMin} } );

		dob_health_application_partner_dob.ageMin = healthFunds_BUP.defaultAgeMin;
		healthFunds_BUP.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_partner_dob': healthFunds_BUP.$_dobPartner.attr('title') + ' age cannot be under ' + dob_health_application_partner_dob.ageMin} } );

		delete healthFunds_BUP.defaultAgeMin;
		delete healthFunds_BUP.$_dobPrimary;
		delete healthFunds_BUP.$_dobPartner;

		<%-- fund Name's become mandatory (back to default) --%>
		$('#health_previousfund_primary_fundName').attr('required', 'required');
		$('#health_previousfund_partner_fundName').attr('required', 'required');

		<%-- credit card options --%>
		creditCardDetails.resetConfig();
		creditCardDetails.render();

		<%-- selections for payment date --%>
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		$('#update-step').off('click.BUP');

		$('.bup-payment-legend').remove();
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />