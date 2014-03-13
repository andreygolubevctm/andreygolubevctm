<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
CUA
=======================
--%>
var healthFunds_CUA = {

set: function () {
	"use strict";
		<%-- Previous fund authority --%>
		$('#health_previousfund_primary_authority').rules('add', {required: true, messages: {required: 'CUA requires authorisation to contact your previous fund'}});
		$('#health_previousfund_partner_authority').rules('add', {required: true, messages: {required: 'CUA requires authorisation to contact your partner\'s previous fund'}});
		$('#health_previousfund_primary_memberID').attr('maxlength', '10');
		$('#health_previousfund_partner_memberID').attr('maxlength', '10');
		healthFunds._previousfund_authority(true);

		<%--dependant definition--%>
		healthFunds._dependants('This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 24 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.');

		<%--schoolgroups and defacto--%>
		healthDependents.config = { 'school': true, 'defacto':false, 'schoolMin': 21, 'schoolMax': 24 };

		<%--credit card & bank account frequency & day frequency--%>
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly': true, 'fortnightly': true, 'monthly': true, 'quarterly': true, 'halfyearly': true, 'annually': true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly': true, 'fortnightly': true, 'monthly': true, 'quarterly': true, 'halfyearly': true, 'annually': true });
		meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly': 28, 'fortnightly': 28, 'monthly': 28, 'quarterly': 28, 'halfyearly': 28, 'annually': 28 });

		<%--claims account --%>
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		<%--credit card options --%>
		creditCardDetails.config = { 'visa': true, 'mc': true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		<%-- Inject CSS --%>
		<c:set var="html">
			<style type="text/css">
				<c:choose>
					<c:when test="${data.health.application.primary.gender == 'F'}">
						.ifExpectingMessage {
							display: block;
						}
					</c:when>
					<c:otherwise>
						.ifExpectingMessage {
							display: none;
						}
					</c:otherwise>
				</c:choose>
				body.CUA .ifExpectingMessage {
					color: #0C4DA2;
					font-weight: 600;
				}
				body.CUA .ifExpectingMessage .fieldrow_label {
					float: left;
				}
				body.CUA .ifExpectingMessage .fieldrow_value {
					max-width: 400px;
				}

				body.CUA .health-payment_details-claims-group,
				body.CUA .health_previous_fund_authority {
					display: block !important;
				}

				body.CUA .health_bank-details_policyDay-group,
				body.CUA .health_credit-card-details_policyDay-group{
					display: block !important;
				}

				body.CUA .health_credit-card-details_day_group,
				body.CUA .health_bank-details_day-group {
					display: none !important;
				}

				body.CUA .cua-payment-legend {
					padding-top: 0.5em;
				}
			</style>
		</c:set>
		$('head').append('<c:out value="${html}" escapeXml="false" />');

		<c:if test="${data.health.situation.healthCvr == 'S'}">
			<c:set var="htmlPrimary">
				<form:row label="" className="ifExpectingMessage" id="ifExpectingMessage">
					<div>
						For your baby to be eligible for benefits immediately upon birth, the mother must have contributed to a family or single parent policy for at least two calendar months prior to the infant\'s birth.
					</div>
				</form:row>
			</c:set>
			$('#health_application_primary_genderRow').after('<c:out value="${htmlPrimary}" escapeXml="false" />');

			$('#health_application_primary_gender').on('change', function () {
				if( $('input[name=health_application_primary_gender]:checked').val() == 'F' ) {
					if($('#ifExpectingMessage').is(':hidden')){
						$('#ifExpectingMessage').slideDown();
					}
				} else {
					if(!$('#ifExpectingMessage').is(':hidden') ){
						$('#ifExpectingMessage').slideUp();
					}
				};
			});
		</c:if>
		$('#update-premium').on('click.CUA', function() {

			healthFunds._payments = { 'min':0, 'max':14, 'weekends':true, 'countFrom' : healthFunds.countFrom.EFFECTIVE_DATE, 'maxDay' : 28};
			var _html = healthFunds._paymentDays( $('#health_payment_details_start').val() );
			healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
			healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
			$('.cua-payment-legend').remove();
			$('#health_payment_credit_policyDay').parent().after('<p class="cua-payment-legend">Your account will be debited on or as close to the selected date possible.</p>');
			$('#health_payment_bank_policyDay').parent().after('<p class="cua-payment-legend">Your account will be debited on or as close to the selected date possible.</p>');
		});

		<c:if test="${data.health.situation.healthCvr == 'F' || data.health.situation.healthCvr == 'SPF' }">
			<%--Dependants --%>
			healthFunds._dependants('Family policies provide cover for the policy holder, their spouse and any dependant children/young adults until their 23rd birthday. Full-time student dependants are covered up until they turn 25. Student dependants must be registered each year from when they turn 23 years of age.');
			<%--change age of dependants and school --%>
			healthDependents.maxAge = 25;
			<%--schoolgroups and defacto --%>
			$.extend(healthDependents.config, { 'school': true, 'schoolMin': 23, 'schoolMax': 25, 'schoolID': true, 'schoolIDMandatory': true, 'schoolDate': true, 'schoolDateMandatory': true });

			<%--School list--%>
			var instituteElement =  '<select>
				<option value="">Please choose...</option>
				<c:import url="/WEB-INF/option_data/educationalInstitute.html" />
			</select>';
			$('.health_dependant_details_schoolGroup .fieldrow_value').each(function (i) {
				var name = $(this).find('input').attr('name');
				var id = $(this).find('input').attr('id');
				$(this).append(instituteElement);
				$(this).find('select').attr('name', name).attr('id', id + 'select');
				$(this).find('select').rules('add', {
						required: true,
						messages: {
							required: 'Please select dependant '+(i+1)+'\'s educational institute'
							}
						});
				$('#health_application_dependants_dependant' + (i+1) + '_school').hide();
			});
			$('.health_dependant_details_schoolIDGroup input').attr('maxlength', '10');

			<%--Change the Name of School label--%>
			healthFunds.$_tmpSchoolLabel = $('.health_dependant_details_schoolGroup .control-label').html();
			$('.health_dependant_details_schoolGroup .control-label').html('Educational institute this dependant is attending');
			$('.health_dependant_details_schoolGroup .help_icon').hide();

			healthDependents.config.schoolID = false;
			healthDependents.config.schoolDate = false;
		</c:if>

		<%--calendar for start cover--%>
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 90);
		dob_health_application_primary_dob.ageMax = 99;
		dob_health_application_partner_dob.ageMax = 99;

		$("#applicationForm_1").validate().settings.messages.health_application_primary_dob.max_DateOfBirth = "primary applicant's age cannot be over 99";
		$("#applicationForm_1").validate().settings.messages.health_application_partner_dob.max_DateOfBirth = "applicant's partner's age cannot be over 99";

		healthFunds._medicareCoveredText = $('#medicareCoveredRow .control-label').text();
		$('#medicareCoveredRow .control-label').text('Are all people to be included on this policy covered by a green Medicare card?');
		healthFunds._medicareCoveredHelpId = $('#medicareCoveredRow .help_icon').attr("id");
		$('#medicareCoveredRow .help_icon').attr("id","help_520");
	},
	unset: function () {
		"use strict";

		$('.cua-payment-legend').remove();
		$('#update-premium').off('click.CUA');

		healthFunds._reset();

		healthFunds._previousfund_authority(false);
		$('#health_previousfund_primary_authority').rules('remove', 'required');
		$('#health_previousfund_partner_authority').rules('remove', 'required');

		dob_health_application_primary_dob.ageMax = 120;
		dob_health_application_partner_dob.ageMax = 120;

		$("#applicationForm_1").validate().settings.messages.health_application_primary_dob.max_DateOfBirth = "primary applicant's age cannot be over 120";
		$("#applicationForm_1").validate().settings.messages.health_application_partner_dob.max_DateOfBirth = "applicant's partner's age cannot be over 120";

		<c:if test="${datahealth.situation.healthCvr == 'S'}">
			$('#health_application_primary_genderRow .ifExpectingMessage').remove();
			$('#health_application_primary_gender').unbind('change');
		</c:if>
		<c:if test="${data.health.situation.healthCvr == 'F' || data.health.situation.healthCvr == 'SPF' }">
			$('.health_dependant_details_schoolGroup select').remove();
			$('.health_dependant_details_schoolIDGroup input').removeAttr('maxlength');
			$('.health_dependant_details_schoolGroup .control-label').html(healthFunds.$_tmpSchoolLabel);
			delete healthFunds.$_tmpSchoolLabel;
			$('.health_dependant_details_schoolGroup .help_icon').show();
			$('.health_application_dependants_dependant_schoolIDGroup').show();
			$('.health_dependant_details_schoolDateGroup').show();
		</c:if>

		<%--credit card options--%>
		creditCardDetails.resetConfig();
		creditCardDetails.render();
		$('#medicareCoveredRow .control-label').text(healthFunds._medicareCoveredText);
		$('#medicareCoveredRow .help_icon').attr("id",healthFunds._medicareCoveredHelpId);
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />