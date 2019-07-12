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
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
CUA
=======================
--%>
var healthFunds_CUA = {
	$paymentType : $('#health_payment_details_type input'),
	$paymentFrequency : $('#health_payment_details_frequency'),
	$paymentStartDate: $("#health_payment_details_start"),
set: function () {
	"use strict";
		<%-- Previous fund authority --%>
		$('#health_previousfund_primary_authority').setRequired(true, 'CUA requires authorisation to contact your previous fund');
		$('#health_previousfund_partner_authority').setRequired(true, 'CUA requires authorisation to contact your partner\'s previous fund');
		$('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '10');
    	meerkat.modules.healthFunds._previousfund_authority(true);

		<%--dependant definition--%>
        meerkat.modules.healthFunds._dependants('This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 24 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.');

		<%--credit card & bank account frequency & day frequency--%>
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly': true, 'fortnightly': true, 'monthly': true, 'quarterly': true, 'halfyearly': true, 'annually': true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly': true, 'fortnightly': true, 'monthly': true, 'quarterly': true, 'halfyearly': true, 'annually': true });
		meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly': 28, 'fortnightly': 28, 'monthly': 28, 'quarterly': 28, 'halfyearly': 28, 'annually': 28 });

		<%--claims account --%>
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		<%--credit card options --%>
		meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa': true, 'mc': true, 'amex':false, 'diners':false });
		meerkat.modules.healthCreditCard.render();

		healthFunds_CUA.$paymentType.on('change.CUA', function renderPaymentDaysPaymentType(){
			healthFunds_CUA.renderPaymentDays();
		});

		healthFunds_CUA.$paymentFrequency.on('change.CUA', function renderPaymentDaysFrequency(){
			healthFunds_CUA.renderPaymentDays();
		});

		healthFunds_CUA.$paymentStartDate.on("changeDate.CUA", function renderPaymentDaysCalendar(e) {
			healthFunds_CUA.renderPaymentDays();
		});

		<c:if test="${data.health.situation.healthCvr == 'F' || data.health.situation.healthCvr == 'SPF' }">
			<%--Dependants --%>
            meerkat.modules.healthFunds._dependants('Family policies provide cover for the policy holder, their spouse and any dependant children/young adults until their 23rd birthday. Full-time student dependants are covered up until they turn 25. Student dependants must be registered each year from when they turn 23 years of age.');
			<%--change age of dependants and school --%>
			meerkat.modules.healthDependants.setMaxAge(25);
			<%--schoolgroups and defacto --%>
			meerkat.modules.healthDependants.updateConfig({ showSchoolFields: true, useSchoolDropdownMenu: true, schoolIdMaxLength: 10, 'schoolMinAge': 23, 'schoolMaxAge': 25, showSchoolIdField: true, 'schoolIdRequired': true, showSchoolCommencementField: true, 'schoolDateRequired': true });
		</c:if>

		<%--fund offset check--%>
		meerkat.modules.healthFundTimeOffset.onInitialise({
			weekends: true,
			coverStartRange: {
				min: 0,
				max: 90
			},
            renderPaymentDaysCb: healthFunds_CUA.renderPaymentDays
		});

		dob_health_application_primary_dob.ageMax = 99;
		dob_health_application_partner_dob.ageMax = 99;

		$('#health_application_primary_dob').addRule('oldestDOB', dob_health_application_primary_dob.ageMax, "primary applicant's age cannot be over 99");
		$('#health_application_partner_dob').addRule('oldestDOB', dob_health_application_partner_dob.ageMax, "applicant's partner's age cannot be over 99");

		meerkat.modules.healthFunds.setMedicareCoverHelpId($('#medicareCoveredRow .help_icon').attr("id"));
		$('#medicareCoveredRow .help_icon').attr("id","help_520");

		meerkat.modules.paymentGateway.setup({
			"paymentEngine" : meerkat.modules.healthPaymentGatewayNAB,
			"name" : 'health_payment_gateway',
			"src": '${ctmSettings.getBaseUrl()}', <%-- the CTM iframe source URL --%>
			"origin": '${hostOrigin}', <%-- the CTM host origin --%>
			"providerCode": 'cua',
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
	},
	renderPaymentDays: function (){
		meerkat.modules.healthFunds.setPayments({ 'min':0, 'max':14, 'weekends':true, 'countFrom' : meerkat.modules.healthPaymentDay.EFFECTIVE_DATE, 'maxDay' : 28});

		var _html = meerkat.modules.healthPaymentDay.paymentDays( $('#health_payment_details_start').val() );
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);
		$('.cua-payment-legend').remove();
		$('#health_payment_credit_policyDay').parent().after('<p class="cua-payment-legend">Your account will be debited on or as close to the selected date possible.</p>');
		$('#health_payment_bank_policyDay').parent().after('<p class="cua-payment-legend">Your account will be debited on or as close to the selected date possible.</p>');
	},
	unset: function () {
		"use strict";

		$('.cua-payment-legend').remove();
		healthFunds_CUA.$paymentType.off('change.CUA');
		healthFunds_CUA.$paymentFrequency.off('change.CUA');
		healthFunds_CUA.$paymentStartDate.off("changeDate.CUA");

        meerkat.modules.healthFunds._reset();

        meerkat.modules.healthFunds._previousfund_authority(false);
		$('#health_previousfund_primary_authority, #health_previousfund_partner_authority').setRequired(false);

		dob_health_application_primary_dob.ageMax = 120;
		dob_health_application_partner_dob.ageMax = 120;

		$('#health_application_primary_dob').addRule('oldestDOB', dob_health_application_primary_dob.ageMax, "primary applicant's age cannot be over 120");
		$('#health_application_partner_dob').addRule('oldestDOB', dob_health_application_partner_dob.ageMax, "applicant's partner's age cannot be over 120");

		<c:if test="${data.health.situation.healthCvr == 'S' || data.health.situation.healthCvr == 'SM' || data.health.situation.healthCvr == 'SF'}">
			$('#health_application_primary_genderRow .ifExpectingMessage').remove();
			$('#health_application_primary_gender').unbind('change');
		</c:if>
		<c:if test="${data.health.situation.healthCvr == 'F' || data.health.situation.healthCvr == 'SPF' }">
			$('.health_application_dependants_dependant_schoolIDGroup').show();
			$('.health_dependant_details_schoolDateGroup').show();
		</c:if>

		<%--credit card options--%>
		meerkat.modules.healthCreditCard.resetConfig();
		meerkat.modules.healthCreditCard.render();
		$('#medicareCoveredRow .help_icon').attr("id",meerkat.modules.healthFunds.getMedicareCoverHelpId());
		meerkat.modules.paymentGateway.reset();
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />