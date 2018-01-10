<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger('jsp.common.js.health.healthFunds_THF')}" />
<session:get settings="true" />

<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>
<c:set var="dependentText">This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to a policy. Adult dependants outside this criteria can be covered by an additional premium on certain covers or can elect to take out their own policy.</c:set>
<c:if test="${not empty callCentreNumber}">
	<c:set var="dependentText">${dependentText} Please call <content:get key="brandDisplayName"/> on ${callCentreNumber}</c:set>
	<c:if test="${pageSettings.getSetting('liveChatEnabled') eq 'Y'}">
		<c:set var="dependentText">${dependentText} or chat to our consultants online</c:set>
	</c:if>
	<c:set var="dependentText">${dependentText} to discuss your health cover needs.</c:set>
</c:if>
${logger.debug('Application information for THF. {}', log:kv('liveChatEnabled', pageSettings.getSetting('liveChatEnabled')))}
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
THF
=======================
--%>
var healthFunds_THF = {
	state : '',
	healthCvr : '',
	unionMembershipFld	: '',
	employmentFld		: '',
	familyMemberFld		: '',
	areYouRelatedFld	: '',
	ineligibleMessage 	: '',
	$paymentType : $('#health_payment_details_type input'),
	$paymentFrequency : $('#health_payment_details_frequency'),
	$paymentStartDate: $("#health_payment_details_start"),

	set: function () {
		"use strict";
		healthFunds_THF.state = $('#health_situation_state').val();
		healthFunds_THF.healthCvr = $('#health_situation_healthCvr').val();

		<%-- Previous fund --%>
		$('#health_previousfund_primary_authority').setRequired(true,'Teachers Health Fund require authorisation to contact your previous fund');
		$('#health_previousfund_partner_authority').setRequired(true, 'Teachers Health Fund require authorisation to contact your partner\'s previous fund');
		$('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '10');

		<%-- Authority --%>
        meerkat.modules.healthFunds._previousfund_authority(true);

		<%--credit card & bank account frequency & day frequency--%>
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });
		<%-- THF don't support credit card --%>
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly':false, 'monthly':false, 'quarterly':false, 'halfyearly':false, 'annually':false });
		meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly': 28, 'fortnightly': 28, 'monthly': 28, 'quarterly': 28, 'halfyearly': 28, 'annually': 28 });

		<%--claims account --%>
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		<%--turn off credit card option --%>
		var $ele = $('#health_payment_details_type_cc');
			$ele.prop('checked', false);
			$ele.prop('disabled', true);
			$ele.addClass('disabled-by-fund');
			$ele.parent('label').addClass('disabled').addClass('disabled-by-fund');

		$ele = $('#health_payment_details_type_ba');
			$ele.prop('checked', true);
			$ele.change();

		if ($('#thf_eligibility').length > 0) {
			<%-- HTML was already injected so unhide it --%>
			$('#thf_eligibility').show();
		} else {
			<c:set var="thfEligibilityHtml">

				<form_v2:fieldset id="thf_eligibility" legend="How are you eligible to join Teachers Health Fund?" className="primary">

					<form_v2:row label="Are you a current or former member of a relevant education union?" id="unionMembershipRow"  helpId="523">
						<field_v2:array_select xpath="health/eligibility/unionMembership"
								required="true"
								title="Are you a current or former member of a relevant education union" items="=Please choose...,Y=Yes,N=No" />
					</form_v2:row>

					<form_v2:row label="Are you related to someone who is eligible to join Teachers Health Fund" id="areYouRelatedRow"  helpId="521">
						<field_v2:array_select xpath="health/eligibility/areYouRelated"
								required="false"
								title="Are you related to someone who is eligible to join Teachers Health Fund" items="=Please choose...,Y=Yes,N=No" />
					</form_v2:row>

					<form_v2:row label="How are you related to a family member eligible for THF?" id="familyRow">
						<field_v2:import_select xpath="health/eligibility/familyMember"
							required="true"
							url="/WEB-INF/option_data/thf/relationToTHFMember.html"
							title="How are you related to a member eligible for THF?"
							className="qualificationDropDown"
							omitPleaseChoose="false" />
					</form_v2:row>

					<form_v2:row label="Are you currently or have you ever worked for? (Permanent Employee/Contractor/Officer) "	id="employmentRow">
						<field_v2:import_select xpath="health/eligibility/employment"
							required="true"
							url="/WEB-INF/option_data/thf/employmentType.html"
							title="What are you currently working as?"
							className="qualificationDropDown"
							omitPleaseChoose="false" />
					</form_v2:row>

					<div id="thf_ineligible" class="alert alert-danger">
						<span>Unfortunately, you are not eligible to join Teachers Health Fund. Please <a href="javascript:;" data-slide-control="previous">select a different product</a>.</span>
					</div>
				</form_v2:fieldset>

			</c:set>
			$('#health_application').prepend('<c:out value="${thfEligibilityHtml}" escapeXml="false" />');
		}

		var areYouRelatedRow				= $('#areYouRelatedRow');
		var unionMembershipRow				= $('#unionMembershipRow');
		var familyRow						= $('#familyRow');
		var employmentRow					= $('#employmentRow');
		healthFunds_THF.unionMembershipFld	= $('#health_eligibility_unionMembership');
		healthFunds_THF.employmentFld		= $('#health_eligibility_employment');
		healthFunds_THF.familyMemberFld		= $('#health_eligibility_familyMember');
		healthFunds_THF.areYouRelatedFld	= $('#health_eligibility_areYouRelated');
		healthFunds_THF.ineligibleMessage 	= $('#thf_ineligible');


		healthFunds_THF.$paymentType.on('change.THF', function renderPaymentDaysPaymentType(){
			healthFunds_THF.renderPaymentDays();
		});

		healthFunds_THF.$paymentFrequency.on('change.THF', function renderPaymentDaysFrequency(){
			healthFunds_THF.renderPaymentDays();
		});

		healthFunds_THF.$paymentStartDate.on("changeDate.THF", function renderPaymentDaysCalendar(e) {
			healthFunds_THF.renderPaymentDays();
		});

		if (healthFunds_THF.healthCvr === 'F' || healthFunds_THF.healthCvr === 'SPF' ) {

			<%--dependant definition--%>
            meerkat.modules.healthFunds._dependants('<c:out value="${dependentText}" escapeXml="true"/>');
			<%--change age of dependants and school --%>
			meerkat.modules.healthDependants.setMaxAge(25);
			<%--schoolgroups and defacto --%>
			meerkat.modules.healthDependants.updateConfig({ showSchoolFields: true, useSchoolDropdownMenu: true, 'schoolMinAge': 23, 'schoolMaxAge': 24, showSchoolIdField: false, 'schoolIdRequired': false, showSchoolCommencementField: false, 'schoolDateRequired': false });
		}

		<%--calendar for start cover--%>
		if(_.has(meerkat.modules,'healthCoverStartDate')) {
			meerkat.modules.healthCoverStartDate.setCoverStartRange(0, 60);
		} else {
			meerkat.modules.healthPaymentStep.setCoverStartRange(0, 60);
		}
		healthFunds_THF.$paymentStartDate.datepicker('setDaysOfWeekDisabled', '0,6');

        <%--fund offset check--%>
        meerkat.modules.healthFundTimeOffset.onInitialise({
            weekends: false,
            coverStartRange: {
                min: 0,
                max: 60
            },
            renderPaymentDaysCb: healthFunds_THF.renderPaymentDays
        });

		<%-- elegibility --%>
		healthFunds_THF.unionMembershipFld.on('change', function unionMembershipChange() {
			employmentRow.slideUp(200);
			familyRow.slideUp(200);

			if($(this).val() === 'Y') {
				areYouRelatedRow.slideUp(200);
				healthFunds_THF.areYouRelatedFld.val("");
				healthFunds_THF.employmentFld.val("");
				healthFunds_THF.familyMemberFld.val("");
			} else {
				areYouRelatedRow.slideDown(200);
			}
			$(this).valid();
		});

		healthFunds_THF.areYouRelatedFld.on('change', function areYouRelatedChange() {
			if($(this).val() === 'Y') {
				familyRow.slideDown(200);
				employmentRow.slideUp(200);
				healthFunds_THF.employmentFld.val("");
			} else if($(this).val() === 'N' && (healthFunds_THF.state === 'NSW' || healthFunds_THF.state === 'ACT')) {
				familyRow.slideUp(200);
				employmentRow.slideDown(200);
				healthFunds_THF.familyMemberFld.val("");
			} else  {
				familyRow.slideUp(200);
				employmentRow.slideUp(200);
				healthFunds_THF.familyMemberFld.val("");
				healthFunds_THF.employmentFld.val("");
			}
			$(this).valid();
			healthFunds_THF.unionMembershipFld.valid();
		});

		healthFunds_THF.employmentFld.on('change', function areYouRelatedChange() {
			$(this).valid();
			healthFunds_THF.unionMembershipFld.valid();
		});

		healthFunds_THF.familyMemberFld.on('change', function familyMemberChange() {
			$(this).valid();
			healthFunds_THF.unionMembershipFld.valid();
		});

		$.validator.addMethod("validateTHFEligibility",
			function(value, element) {
				var valid = true;
				var notUnionMember = healthFunds_THF.unionMembershipFld.val() == 'N';
				if(notUnionMember) {
					var areYouRelated = healthFunds_THF.areYouRelatedFld.val();
					var notRelated = areYouRelated === 'N';
					var related = areYouRelated === 'Y';
					var notEmployed = healthFunds_THF.employmentFld.val() === 'None';

					var isNSW = healthFunds_THF.state === 'NSW' || healthFunds_THF.state === 'ACT';

					var ineligibleRelated = related && healthFunds_THF.familyMemberFld.val() === 'None';
					var ineligibleNotRelated = notRelated && (!isNSW || (isNSW && notEmployed));

					if(ineligibleRelated || ineligibleNotRelated ) {
						valid = false;
					}
				}
				if(valid) {
					healthFunds_THF.ineligibleMessage.slideUp(200);
				} else {
					healthFunds_THF.ineligibleMessage.slideDown(200);
				}
				return valid;
			},
			"Custom message"
		);

		$.validator.messages.validateTHFEligibility = $('#thf_ineligible span').html();

		healthFunds_THF.unionMembershipFld.setRequired(true);
		healthFunds_THF.unionMembershipFld.addRule("validateTHFEligibility");
		healthFunds_THF.areYouRelatedFld.setRequired(true);
		healthFunds_THF.familyMemberFld.setRequired(true);
		healthFunds_THF.employmentFld.setRequired(true);
	},
	renderPaymentDays: function() {
        meerkat.modules.healthFunds.setPayments({
			'minType':meerkat.modules.healthPaymentDay.FROM_EFFECTIVE_DATE,
			'min':7,
			'max':16,
			'weekends':false,
			'countFrom' : meerkat.modules.healthPaymentDay.EFFECTIVE_DATE
		});
		var _html = meerkat.modules.healthPaymentDay.paymentDays( $('#health_payment_details_start').val() );
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
		$('.thf-payment-legend').remove();
		$('#health_payment_bank_policyDay').parent().after('<span class="thf-payment-legend">Your account will be debited on or as close to the selected date possible.</span>');
	},
	unset: function () {
		"use strict";
        meerkat.modules.healthFunds._reset();

		<%-- turn back on credit card option --%>
		$('#health_payment_details_type_cc').prop('disabled', false).parent('label').removeClass('disabled').removeClass('disabled-by-fund');

		$('#thf_eligibility').hide();
		$('.thf-payment-legend').remove();

		if(healthFunds_THF.healthCvr == 'F' || healthFunds_THF.healthCvr == 'SPF') {
			<%-- TODO: Are these necessary? --%>
			$('.health_application_dependants_dependant_schoolIDGroup').show();
			$('.health_dependant_details_schoolDateGroup').show();
		}
		healthFunds_THF.unionMembershipFld.val("");
		healthFunds_THF.employmentFld.val("");
		healthFunds_THF.familyMemberFld.val("");
		healthFunds_THF.areYouRelatedFld.val("");
		healthFunds_THF.ineligibleMessage.hide();

		$('#health_previousfund_primary_authority, #health_previousfund_partner_authority').setRequired(false);
		$('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').removeAttr('maxlength');

        meerkat.modules.healthFunds._previousfund_authority(false);

		healthFunds_THF.$paymentType.off('change.THF');
		healthFunds_THF.$paymentFrequency.off('change.THF');
		healthFunds_THF.$paymentStartDate.off("changeDate.THF");
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />