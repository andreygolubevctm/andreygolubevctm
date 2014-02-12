<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<% pageContext.setAttribute("newLineChar2", "\r"); %>
<% pageContext.setAttribute("aposChar", "'"); %>
<% pageContext.setAttribute("aposChar2", "\\\\'"); %>
<% pageContext.setAttribute("slashChar", "\\\\"); %>
<% pageContext.setAttribute("slashChar2", "\\\\\\\\"); %>
<%--
=======================
HIF
=======================
--%>
var healthFunds_HIF = {
	processOnAmendQuote: true,

	set: function() {
		<%-- HTML was already injected so unhide it --%>
		if ($('#hif_questionset').length > 0) {
			$('#hif_questionset').show();

			<%-- Reflow questions --%>
			$('#hif_questionset input').trigger('change');
		}
		else {
			<%-- Inject CSS --%>
			<c:set var="html">
				<style type="text/css">
				body.HIF .health_previous_fund_authority,
				body.HIF .health_person-details_authority_group { display: block !important; }
				body.HIF #health_previousfund .membership.onA.onB .inlineMessage { top: 37px; }
				body.HIF .health_credit-card-details_day_group { display: none; }
				</style>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
			$('head').append('<c:out value="${html}" escapeXml="false" />');

			<c:set var="html">
				<div id="hif_questionset">
					<div class="fieldrow">
						<div class="fieldrow_label">Did you or any persons included on this application emigrate to Australia after 1 July 2000?</div>
						<div class="fieldrow_value">
							<field:array_radio xpath="health/application/hif/emigrate" required="true" title="" items="Y=Yes,N=No" />
							<p class="HIF" style="display:none; margin-top:1em; width:390px">As you ticked "Yes", HIF will require a copy of your Medicare Eligibility letter which states the date at which you became eligible to receive Medicare benefits. This letter will assist HIF in determining if a Lifetime Health Cover age loading will need to be added to the amount quoted in this application.</p>
						</div>
						<div class="cleardiv"></div>
					</div>
				</div>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

			$('#health_payment_medicare-selection .content').append('<c:out value="${html}" escapeXml="false" />');

			$('#hif_questionset .radio_buttons').buttonset();
			$('#hif_questionset input').on('change', function() {
				switch ($(this).val()) {
				case 'Y':
					$('#hif_questionset .HIF').slideDown(200);
					break;
				default:
					$('#hif_questionset .HIF').slideUp(200, function(){ $(this).hide(); });
				}
			});

		}<%-- /injection --%>

		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('stage-0')) {
			<%-- Dependant definition --%>
			healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');
			$.extend(healthDependents.config, { 'school':false, 'schoolMin':18, 'schoolMax':24, 'schoolID':false });

			<%-- Increase minimum age requirement for applicants from 16 to 18 --%>
			<%-- Primary --%>
			healthFunds_HIF.$_dobPrimary = $('#health_application_primary_dob');
			healthFunds_HIF.defaultAgeMin = dob_health_application_primary_dob.ageMin;
			dob_health_application_primary_dob.ageMin = 18;
			healthFunds_HIF.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_primary_dob': healthFunds_HIF.$_dobPrimary.attr('title') + ' age cannot be under ' + dob_health_application_primary_dob.ageMin} } );
			<%-- Partner --%>
			healthFunds_HIF.$_dobPartner = $('#health_application_partner_dob');
			dob_health_application_partner_dob.ageMin = 18;
			healthFunds_HIF.$_dobPartner.rules('add', {messages: {'min_dob_health_application_partner_dob': healthFunds_HIF.$_dobPartner.attr('title') + ' age cannot be under ' + dob_health_application_partner_dob.ageMin} } );

			<%-- How to send information. Second argument = validation required --%>
			healthApplicationDetails.showHowToSendInfo('HIF', true);
			healthApplicationDetails.addOption('SMS', 'S');

			<%-- Previous funds --%>
			$('#health_previousfund_primary_memberID').attr('maxlength', '10');
			$('#health_previousfund_partner_memberID').attr('maxlength', '10');

			<%-- Authority --%>
			healthFunds._authority(true);

			<%-- Fund IDs become optional --%>
			$('#clientMemberID').find('input').rules('remove', 'required');
			$('#partnerMemberID').find('input').rules('remove', 'required');

			<%-- Calendar for start cover --%>
			healthCalendar._min = 0;
			healthCalendar._max = 29;
			healthCalendar.update();

			<%-- Payments --%>
			paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true };
			<%-- Add message --%>
			$('#health_payment_details_type').after('<p class="HIF" style="margin-top:1em; width:390px">An initial credit card payment is required to join HIF. If you wish to change your direct debit to withdraw from a bank account at any stage in your relationship with HIF, please contact them directly once you have received confirmation from Comparethemarket.com.au that your application has been submitted.</p>');
			<%-- Disable bank account payment option --%>
			$('#health_payment_details_type_ba').attr('checked', false);
			$('#health_payment_details_type_ba').button('disable');

		}<%-- /not loading quote --%>
	},
	unset: function() {
		$('#hif_questionset').hide();

		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('stage-0')) {
			<%-- Dependants --%>
			healthFunds._dependants(false);

			<%-- Age requirements for applicants (back to default) --%>
			dob_health_application_primary_dob.ageMin = healthFunds_HIF.defaultAgeMin;
			healthFunds_HIF.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_primary_dob': healthFunds_HIF.$_dobPrimary.attr('title') + ' age cannot be under ' + dob_health_application_primary_dob.ageMin} } );

			dob_health_application_partner_dob.ageMin = healthFunds_HIF.defaultAgeMin;
			healthFunds_HIF.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_partner_dob': healthFunds_HIF.$_dobPartner.attr('title') + ' age cannot be under ' + dob_health_application_partner_dob.ageMin} } );

			delete healthFunds_HIF.defaultAgeMin;
			delete healthFunds_HIF.$_dobPrimary;
			delete healthFunds_HIF.$_dobPartner;

			<%-- How to send information --%>
			healthApplicationDetails.removeLastOption();
			healthApplicationDetails.hideHowToSendInfo();

			<%-- Authority off --%>
			healthFunds._authority(false);

			healthFunds._reset();

			<%-- Remove message --%>
			$('#health_payment_details-selection p.HIF').remove();
			<%-- Enable bank account payment option --%>
			$('#health_payment_details_type_ba').button('enable').next('label').addClass('ui-state-default');
		}
	}
};