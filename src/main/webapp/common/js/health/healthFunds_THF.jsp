<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}" />
<session:get settings="true" />

<c:set var="callCentreNumberApplication" scope="request"><content:get key="callCentreNumberApplication"/></c:set>
<c:set var="dependentText">This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to a policy. Adult dependants outside this criteria can be covered by an additional premium on certain covers or can elect to take out their own policy.</c:set>
<c:if test="${not empty callCentreNumberApplication}">
	<c:set var="dependentText">${dependentText} Please call <content:get key="brandDisplayName"/> on ${callCentreNumberApplication}</c:set>
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

	set: function () {
		"use strict";
		healthFunds_THF.state = $('#health_situation_state').val();
		healthFunds_THF.healthCvr = $('#health_situation_healthCvr').val();

		<%--schoolgroups and defacto--%>
		healthDependents.config = { 'school': true, 'defacto':false, 'schoolMin': 21, 'schoolMax': 24 };

		<%-- Previous fund --%>
		$('#health_previousfund_primary_authority').rules('add', {required:true, messages:{required:'Teachers Health Fund require authorisation to contact your previous fund'}});
		$('#health_previousfund_partner_authority').rules('add', {required:true, messages:{required:'Teachers Health Fund require authorisation to contact your partner\'s previous fund'}});
		$('#health_previousfund_primary_memberID').attr('maxlength', '10');
		$('#health_previousfund_partner_memberID').attr('maxlength', '10');

		<%-- Authority --%>
		healthFunds._previousfund_authority(true);

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

				<form_new:fieldset id="thf_eligibility" legend="How are you eligible to join Teachers Health Fund?" className="primary">

					<form_new:row label="Are you a current or former member of a relevant education union?" id="unionMembershipRow"  helpId="523">
						<field_new:array_select xpath="health/eligibility/unionMembership"
								required="true"
								title="Are you a current or former member of a relevant education union" items="=Please choose...,Y=Yes,N=No" />
					</form_new:row>

					<form_new:row label="Are you related to someone who is eligible to join Teachers Health Fund" id="areYouRelatedRow"  helpId="521">
						<field_new:array_select xpath="health/eligibility/areYouRelated"
								required="false"
								title="Are you related to someone who is eligible to join Teachers Health Fund" items="=Please choose...,Y=Yes,N=No" />
					</form_new:row>

					<form_new:row label="How are you related to a family member eligible for THF?" id="familyRow">
						<field_new:import_select xpath="health/eligibility/familyMember"
							required="true"
							url="/WEB-INF/option_data/thf/relationToTHFMember.html"
							title="How are you related to a member eligible for THF?"
							className="qualificationDropDown"
							omitPleaseChoose="false" />
					</form_new:row>

					<form_new:row label="Are you currently or have you ever worked for? (Permanent Employee/Contractor/Officer) "	id="employmentRow">
						<field_new:import_select xpath="health/eligibility/employment"
							required="true"
							url="/WEB-INF/option_data/thf/employmentType.html"
							title="What are you currently working as?"
							className="qualificationDropDown"
							omitPleaseChoose="false" />
					</form_new:row>

					<div id="thf_ineligible" class="alert alert-danger">
						<span>Unfortunately, you are not eligible to join Teachers Health Fund. Please <a href="javascript:;" data-slide-control="previous">select a different product</a>.</span>
					</div>
				</form_new:fieldset>

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


		$('#update-premium').on('click.THF', function() {
			healthFunds._payments = {
							'minType':healthFunds.minType.FROM_EFFECTIVE_DATE,
							'min':7,
							'max':16,
							'weekends':false,
							'countFrom' : healthFunds.countFrom.EFFECTIVE_DATE
							};
			var _html = healthFunds._paymentDays( $('#health_payment_details_start').val() );
			healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
			$('.thf-payment-legend').remove();
			$('#health_payment_bank_policyDay').parent().after('<span class="thf-payment-legend">Your account will be debited on or as close to the selected date possible.</span>');
		});

		if (healthFunds_THF.healthCvr === 'F' || healthFunds_THF.healthCvr === 'SPF' ) {

			<%--dependant definition--%>
			healthFunds._dependants('<c:out value="${dependentText}" escapeXml="true"/>');
			<%--change age of dependants and school --%>
			healthDependents.maxAge = 25;
			<%--schoolgroups and defacto --%>
			$.extend(healthDependents.config, { 'school': true, 'schoolMin': 23, 'schoolMax': 24, 'schoolID': false, 'schoolIDMandatory': false, 'schoolDate': false, 'schoolDateMandatory': false });

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
		}

		<%--calendar for start cover--%>
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 60);

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

		healthFunds_THF.unionMembershipFld.rules('add', {required:true});
		healthFunds_THF.unionMembershipFld.rules('add', {validateTHFEligibility:true});
		healthFunds_THF.areYouRelatedFld.rules('add', {required:true});
		healthFunds_THF.familyMemberFld.rules('add', {required:true});
		healthFunds_THF.employmentFld.rules('add', {required:true});
	},
	unset: function () {
		"use strict";
		healthFunds._reset();

		<%-- turn back on credit card option --%>
		$('#health_payment_details_type_cc').prop('disabled', false);
		$('#health_payment_details_type_cc').parent('label').removeClass('disabled').removeClass('disabled-by-fund');

		$('#thf_eligibility').hide();
		$('.thf-payment-legend').remove();

		if(healthFunds_THF.healthCvr == 'F' || healthFunds_THF.healthCvr == 'SPF') {
			$('.health_dependant_details_schoolGroup select').remove();
			$('.health_dependant_details_schoolIDGroup input').removeAttr('maxlength');
			$('.health_dependant_details_schoolGroup .control-label').html(healthFunds.$_tmpSchoolLabel);
			delete healthFunds.$_tmpSchoolLabel;
			$('.health_dependant_details_schoolGroup .help_icon').show();
			$('.health_application_dependants_dependant_schoolIDGroup').show();
			$('.health_dependant_details_schoolDateGroup').show();
		}
		healthFunds_THF.unionMembershipFld.val("");
		healthFunds_THF.employmentFld.val("");
		healthFunds_THF.familyMemberFld.val("");
		healthFunds_THF.areYouRelatedFld.val("");
		healthFunds_THF.ineligibleMessage.hide();

		$('#health_previousfund_primary_authority').rules('remove', 'required');
		$('#health_previousfund_partner_authority').rules('remove', 'required');
		$('#health_previousfund_primary_memberID').removeAttr('maxlength');
		$('#health_previousfund_partner_memberID').removeAttr('maxlength');

		healthFunds._previousfund_authority(false);
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />