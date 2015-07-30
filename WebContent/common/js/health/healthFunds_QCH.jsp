<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>

<%-- Because of cross domain issues with the payment gateway, we always use a CTM iframe to proxy to HAMBS' iframes so we need iframe src URL and hostOrigin to be pulled from CTM's settings (not the base and root URLs of the current brand). --%>
<c:set var="ctmSettings" value="${settingsService.getPageSettingsByCode('CTM','HEALTH')}"/>
<c:set var="hostOrigin">${ctmSettings.getRootUrl()}</c:set>
<c:if test="${fn:endsWith(hostOrigin, '/')}">
	<c:set var="hostOrigin">${fn:substring( hostOrigin, 0, fn:length(hostOrigin)-1 )}</c:set>
</c:if>

<c:set var="content">
<%--
=======================
QCH
=======================
--%>
var healthFunds_QCH = {
	processOnAmendQuote: true,

	set: function() {
		<%-- HTML was already injected so unhide it --%>
		if ($('#QCH_questionset').length > 0) {
			$('#QCH_questionset').show();

			<%-- Reflow questions --%>
			$('#QCH_questionset input').trigger('change');
		}
		else {



			<c:set var="html">
				<div id="QCH_questionset">
					<c:set var="fieldXpath" value="health/payment/medicare/cardPosition" />
					<form_new:row fieldXpath="${fieldXpath}" label="Position you appear on your medicare card">
						<field_new:count_select xpath="${fieldXpath}" min="1" max="5" step="1" title="your medicare card position" required="true" className="health_payment_medicare_cardPosition"/>
					</form_new:row>
				</div>
			</c:set>
			$('#health_payment_medicare-selection .content').append('<c:out value="${html}" escapeXml="false" />');


			$('#QCH_questionset input').on('change', function() {
				switch ($(this).val()) {
				case 'Y':
					$('#QCH_questionset .QCH').slideDown(200);
					break;
				default:
					$('#QCH_questionset .QCH').slideUp(200, function(){ $(this).hide(); });
				}
			});




		}<%-- /injection --%>






		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('injectingFund')) {



			<%-- Dependant definition --%>
			healthFunds._dependants('Queensland Country Health Fund(QCHF) policies provide cover for all dependents up to the age of 21, including step and foster children. Adult dependents who are single, aged between 21 and 25 years and who are: studying full time at a school, college or university, or are training as an apprentice and earning no more than $30,000 p.a. may continue to be covered by QCHF policies.');

			$.extend(healthDependents.config, { 'fulltime':true, 'school':true, 'schoolMin':21, 'schoolMax':24, 'schoolID':false, 'apprentice':true});
			healthFunds_QCH.tmpSchoolLabel = $('.health_dependant_details_schoolGroup .control-label').html();
			$('.health_dependant_details_schoolGroup .control-label').html('Please supply the name of the school your child is attending eg. UNSW');
			$('.health_dependant_details_schoolGroup .help-icon').hide();

			<%-- Increase minimum age requirement for applicants from 16 to 18 --%>
			<%-- Primary --%>
			healthFunds_QCH.$_dobPrimary = $('#health_application_primary_dob');
			healthFunds_QCH.$_dobPartner = $('#health_application_partner_dob');

			meerkat.modules.validation.setMinAgeValidation(healthFunds_QCH.$_dobPrimary, 18 , "primary person's");
			meerkat.modules.validation.setMinAgeValidation(healthFunds_QCH.$_dobPartner, 18, "partner's");

			<%-- How to send information. Second argument = validation required --%>
			healthApplicationDetails.showHowToSendInfo('QCHF', true);


			<%-- Previous funds --%>
			$('#health_previousfund_primary_memberID').attr('maxlength', '10');
			$('#health_previousfund_partner_memberID').attr('maxlength', '10');
			healthFunds._previousfund_authority(true);

			<%-- Partner authority --%>
			healthFunds._partner_authority(false);

			<%-- Fund IDs become optional --%>
			$('#clientMemberID').find('input').rules('remove', 'required');
			$('#partnerMemberID').find('input').rules('remove', 'required');

			<%-- Calendar for start cover --%>
			meerkat.modules.healthPaymentStep.setCoverStartRange(0, 29);

			<%-- Payments --%>
			meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':true, 	'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });
			meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':true, 	'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });

			<%--selections for payment date --%>
			$('#update-premium').on('click.QCH', function() {
				var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
				healthFunds._payments = { 'min':3, 'max':17, 'weekends':true };
				var _html = healthFunds._paymentDays( $('#health_payment_details_start').val() );
				healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
				healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);

				$('.health_bank-details_policyDay-message').html('');
				$('.health_credit-card-details_policyDay-message').html('');

				$('#health_payment_bank_policyDay').attr('type','hidden');
				$('#health_payment_credit_policyDay').attr('type','hidden');

				var startDate = $('#health_payment_details_start').val();
				var policyStart = healthFunds._setPolicyDate(startDate);

				$('#health_payment_credit_policyDay option[value='+policyStart+']').attr('selected','selected');
				$('#health_payment_bank_policyDay option[value='+policyStart+']').attr('selected','selected');

				if (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'ba') {
					$('.health_bank-details_policyDay-message').html('Your payment will be deducted 7 days after your policy start date');
				}
				else if (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc') {
					$('.health_credit-card-details_policyDay-message').html('Your payment will be deducted 7 days after your policy start date');
				}
			});
			/*$('#health_payment_medicare_cover').rules('add', {required:true});*/

		}<%-- not loading quote --%>
		meerkat.modules.paymentGateway.setup({
			"paymentEngine" : meerkat.modules.healthPaymentGatewayNAB,
			"name" : 'health_payment_gateway',
			"src": '${ctmSettings.getBaseUrl()}', <%-- the CTM iframe source URL --%>
			"origin": '${hostOrigin}', <%-- the CTM host origin --%>
			"providerCode": 'qch',
			"brandCode": '${pageSettings.getBrandCode()}',
			"handledType" :  {
				"credit" : true,
				"bank" : false
			},
			"paymentTypeSelector" : $("input[name='health_payment_details_type']:checked"),
			"clearValidationSelectors" : $('#health_payment_details_frequency, #health_payment_details_start ,#health_payment_details_type'),
			"getSelectedPaymentMethod" :  meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
		});
	},
	unset: function() {
		$('#QCH_questionset').hide();

		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('injectingFund')) {
			<%-- Dependants --%>
			healthFunds._dependants(false);
			$('.health_dependant_details_schoolGroup .control-label').html(healthFunds_QCH.tmpSchoolLabel);
			delete healthFunds_QCH.tmpSchoolLabel;
			$('.health_dependant_details_schoolGroup .help-icon').show();

			<%-- Age requirements for applicants (back to default) --%>
			meerkat.modules.validation.setMinAgeValidation(healthFunds_QCH.$_dobPrimary, dob_health_application_primary_dob.ageMin , "primary person's");
			meerkat.modules.validation.setMinAgeValidation(healthFunds_QCH.$_dobPartner, dob_health_application_partner_dob.ageMin, "partner's");

			delete healthFunds_QCH.$_dobPrimary;
			delete healthFunds_QCH.$_dobPartner;

			<%-- How to send information --%>
			healthApplicationDetails.hideHowToSendInfo();

			<%-- Authority off --%>
			healthFunds._previousfund_authority(false);

			healthFunds._reset();

			<%-- Remove message --%>
			$('#health_payment_details-selection p.QCH').remove();
			<%-- Enable bank account payment option --%>
			$('#health_payment_details_type_ba').prop('disabled', false);
			$('#health_payment_details_type_ba').parent('label').removeClass('disabled').removeClass('disabled-by-fund');

			$('#health_payment_bank_policyDay').attr('type','');
			$('#health_payment_credit_policyDay').attr('type','');

			$('#update-premium').off('click.QCH');
			meerkat.modules.paymentGateway.reset();
		}
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, ' ')}" escapeXml="false" />