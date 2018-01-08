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
	$paymentType : $('#health_payment_details_type input'),
	$paymentFrequency : $('#health_payment_details_frequency'),
	$paymentStartDate: $("#health_payment_details_start"),
	$claimsAccountOptin: $('#health_payment_bank_claims'),

	set: function() {
		<%-- HTML was already injected so unhide it --%>
		if ($('#QCH_questionset').length > 0) {
			$('#QCH_questionset').show();

			<%-- Reflow questions --%>
			$('#QCH_questionset input').trigger('change');
		}

		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('injectingFund')) {



			<%-- Dependant definition --%>
            meerkat.modules.healthFunds._dependants('Queensland Country Health Fund(QCHF) policies provide cover for all dependants up to the age of 21, including step and foster children. Adult dependants who are single, aged between 21 and 25 years and who are: studying full time at a school, college or university, or are training as an apprentice and earning no more than $30,000 p.a. may continue to be covered by QCHF policies.');

			meerkat.modules.healthDependants.updateConfig({ showFullTimeField :true, showSchoolFields:true, 'schoolMinAge':21, 'schoolMaxAge':24, showSchoolIdField:false, showApprenticeField:true});
			healthFunds_QCH.tmpSchoolLabel = $('.health_dependant_details_schoolGroup .control-label').html();
			$('.health_dependant_details_schoolGroup .control-label').html('Please supply the name of the school your child is attending eg. UNSW');
			$('.health_dependant_details_schoolGroup .help-icon').hide();

			<%-- Increase minimum age requirement for applicants from 16 to 18 --%>
			<%-- Primary --%>
			healthFunds_QCH.$_dobPrimary = $('#health_application_primary_dob');
			healthFunds_QCH.$_dobPartner = $('#health_application_partner_dob');

			healthFunds_QCH.$_dobPrimary.addRule('youngestDOB', 18, "primary person's age cannot be under 18");
			healthFunds_QCH.$_dobPartner.addRule('youngestDOB', 18, "partner's age cannot be under 18");

			<%-- How to send information. Second argument = validation required --%>
			meerkat.modules.healthFunds.showHowToSendInfo('QCHF', true);


			<%-- Previous funds --%>
			$('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '10');
            meerkat.modules.healthFunds._previousfund_authority(true);

			<%-- Partner authority --%>
            meerkat.modules.healthFunds._partner_authority(false);

			<%-- Fund IDs become optional --%>
			$('#clientMemberID input, #partnerMemberID input').setRequired(false);

            <%--fund offset check--%>
            meerkat.modules.healthFundTimeOffset.onInitialise({
                weekends: true,
                coverStartRange: {
                    min: 0,
                    max: 29
                },
                renderPaymentDaysCb: healthFunds_QCH.renderPaymentDays
            });

			<%-- Payments --%>
			meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':true, 	'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });
			meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':true, 	'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });

			healthFunds_QCH.$paymentType.on('change.QCH', function renderPaymentDaysPaymentType(){
				healthFunds_QCH.renderPaymentDays();
			});

			healthFunds_QCH.$paymentFrequency.on('change.QCH', function renderPaymentDaysFrequency(){
				healthFunds_QCH.renderPaymentDays();
			});

			healthFunds_QCH.$paymentStartDate.on("changeDate.QCH", function renderPaymentDaysCalendar(e) {
				healthFunds_QCH.renderPaymentDays();
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
			"updateValidationSelectors" : meerkat.modules.healthPaymentStep.updateValidationSelectorsPaymentGateway,
			"resetValidationSelectors" : meerkat.modules.healthPaymentStep.resetValidationSelectorsPaymentGateway,
			"paymentTypeSelector" : $("input[name='health_payment_details_type']:checked"),
			"getSelectedPaymentMethod" :  meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
		});

		<%-- Unset the refund optin radio buttons --%>
		healthFunds_QCH.$claimsAccountOptin.find("input:checked").each(function(){
		  $(this).prop("checked",null).trigger("change");
		});
	},
	renderPaymentDays: function() {
		var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
		meerkat.modules.healthFunds.setPayments({ 'min':0, 'max':1, 'weekends':true });
		var _html = meerkat.modules.healthPaymentDay.paymentDays( $('#health_payment_details_start').val() );
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);

		$('.health_payment_bank-details_policyDay-message').html('');
		$('.health_payment_credit-card_policyDay-message').html('');

		var startDate = $('#health_payment_details_start').val();
		var policyStart = meerkat.modules.healthFunds._setPolicyDate(startDate, 0);

		$('#health_payment_credit_policyDay option[value='+policyStart+']').attr('selected','selected');
		$('#health_payment_bank_policyDay option[value='+policyStart+']').attr('selected','selected');

		if (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'ba') {
			$('.health_payment_bank-details_policyDay-message').html('Your first premium payment will be deducted from your nominated bank account on receipt of your application by us, or from the actual start date of your policy');
			$('#health_payment_bank_policyDay').attr('type','hidden').attr('data-attach', 'true');
		}
		else if (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc') {
			$('.health_payment_credit-details_policyDay-message').html('Your first premium payment will be deducted from your credit card on receipt of your application by us, or from the actual start date of your policy');
			$('#health_payment_credit_policyDay').attr('type','hidden').attr('data-attach', 'true');
		}
	},
	unset: function() {
		$('#QCH_questionset').hide();

		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('injectingFund')) {
			<%-- Dependants --%>
            meerkat.modules.healthFunds._dependants(false);
			$('.health_dependant_details_schoolGroup .control-label').html(healthFunds_QCH.tmpSchoolLabel);
			delete healthFunds_QCH.tmpSchoolLabel;
			$('.health_dependant_details_schoolGroup .help-icon').show();

			<%-- Age requirements for applicants (back to default) --%>
			healthFunds_QCH.$_dobPrimary.addRule('youngestDOB', dob_health_application_primary_dob.ageMin, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
			healthFunds_QCH.$_dobPartner.addRule('youngestDOB', dob_health_application_partner_dob.ageMin, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

			delete healthFunds_QCH.$_dobPrimary;
			delete healthFunds_QCH.$_dobPartner;

			<%-- How to send information --%>
			meerkat.modules.healthFunds.hideHowToSendInfo();

			<%-- Authority off --%>
            meerkat.modules.healthFunds._previousfund_authority(false);

            meerkat.modules.healthFunds._reset();

			<%-- Remove message --%>
			$('#health_payment_details-selection p.QCH').remove();
			<%-- Enable bank account payment option --%>
			$('#health_payment_details_type_ba').prop('disabled', false);
			$('#health_payment_details_type_ba').parent('label').removeClass('disabled').removeClass('disabled-by-fund');

			$('#health_payment_bank_policyDay').attr('type','').attr('data-attach', '');
			$('#health_payment_credit_policyDay').attr('type','').attr('data-attach', '');

			healthFunds_QCH.$paymentType.off('change.QCH');
			healthFunds_QCH.$paymentFrequency.off('change.QCH');
			healthFunds_QCH.$paymentStartDate.off("changeDate.QCH");
			meerkat.modules.paymentGateway.reset();
		}
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, ' ')}" escapeXml="false" />