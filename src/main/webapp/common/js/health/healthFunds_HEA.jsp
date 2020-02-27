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
        HEA (health.com.au)
        =======================
        --%>
		var healthFunds_HEA = {
			$paymentType : $('#health_payment_details_type input'),
			$paymentFrequency : $('#health_payment_details_frequency'),
			$paymentStartDate: $("#health_payment_details_start"),
			$claimsY: $('#health_payment_details_claims_Y'),
			$paymentMethod: $('#health_payment_details_type_cc'),
			set: function () {
				"use strict";
				<%-- Previous fund authority --%>
				$('#health_previousfund_primary_authority').setRequired(true, 'HEA requires authorisation to contact your previous fund');
				$('#health_previousfund_partner_authority').setRequired(true, 'HEA requires authorisation to contact your partner\'s previous fund');
				$('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '10');
				meerkat.modules.healthFunds._previousfund_authority(true);

				<%--dependant definition--%>
				meerkat.modules.healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

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

				healthFunds_HEA.$paymentType.on('change.HEA', function renderPaymentDaysPaymentType(){
					healthFunds_HEA.renderPaymentDays();
				});

				healthFunds_HEA.$paymentFrequency.on('change.HEA', function renderPaymentDaysFrequency(){
					healthFunds_HEA.renderPaymentDays();
				});

				healthFunds_HEA.$paymentStartDate.on("changeDate.HEA", function renderPaymentDaysCalendar(e) {
					healthFunds_HEA.renderPaymentDays();
				});

				<c:if test="${data.health.situation.healthCvr == 'F' || data.health.situation.healthCvr == 'SPF' }">
				<%--Dependants --%>
				meerkat.modules.healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');
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
						max: 30
					},
					renderPaymentDaysCb: healthFunds_HEA.renderPaymentDays
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
					"providerCode": 'hea',
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

				healthFunds_HEA.$claimsY.trigger('click');

				healthFunds_HEA.$paymentMethod.parent().hide();
			},
			renderPaymentDays: function (){
				meerkat.modules.healthFunds.setPayments({ 'min':0, 'max':14, 'weekends':true, 'countFrom' : meerkat.modules.healthPaymentDay.EFFECTIVE_DATE, 'maxDay' : 28});

				var _html = meerkat.modules.healthPaymentDay.paymentDays( $('#health_payment_details_start').val() );
				meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
				meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);
				$('.hea-payment-legend').remove();
				$('#health_payment_credit_policyDay').parent().after('<p class="hea-payment-legend">Your account will be debited on or as close to the selected date possible.</p>');
				$('#health_payment_bank_policyDay').parent().after('<p class="hea-payment-legend">Your account will be debited on or as close to the selected date possible.</p>');
			},
			unset: function () {
				"use strict";

				$('.hea-payment-legend').remove();
				healthFunds_HEA.$paymentType.off('change.HEA');
				healthFunds_HEA.$paymentFrequency.off('change.HEA');
				healthFunds_HEA.$paymentStartDate.off("changeDate.HEA");

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
				meerkat.modules.paymentGateway.reset();

				healthFunds_HEA.$claimsY.prop('checked', false).parent().removeClass('active');
				healthFunds_HEA.$paymentMethod.parent().show();
			}
		};
		</c:set>
		<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />
