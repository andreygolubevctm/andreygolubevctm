<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get />
<% pageContext.setAttribute("newLineChar", "\n"); %>
<% pageContext.setAttribute("newLineChar2", "\r"); %>
<% pageContext.setAttribute("aposChar", "'"); %>
<% pageContext.setAttribute("aposChar2", "\\\\'"); %>
<% pageContext.setAttribute("slashChar", "\\\\"); %>
<% pageContext.setAttribute("slashChar2", "\\\\\\\\"); %>
<%--
=======================
CBHS (Commbank)
=======================
--%>
var healthFunds_CBH = {
	processOnAmendQuote: true,
	ajaxJoinDec: false,

	set: function() {
		<%-- Custom questions: Eligibility --%>
		if ($('#cbh_eligibility').length > 0) {
			<%-- HTML was already injected so unhide it --%>
			$('#cbh_eligibility').show();

			<%-- Reflow eligibility questions --%>
			$('#cbh_currentemployee .cbhmain select').trigger('change');

			<%-- Reflow relation eligibility --%>
			healthFunds_CBH.changeRelation();
		}
		else {

			<c:set var="html">

				<form_new:fieldset id="cbh_eligibility" legend="How are you eligible to join CBHS?" className="primary">

					<div id="cbh_currentemployee">

						<c:set var="fieldXpath" value="health/application/cbh/currentemployee" />
						<form_new:row fieldXpath="${fieldXpath}" label="Are you a current employee, contractor or franchisee of the CBA Group?" className="cbhmain">
							<field_new:array_select xpath="${fieldXpath}" required="true" title="if you are a current employee of the CBA Group" items="=Please choose...,Y=Yes,N=No" />
						</form_new:row>

						<c:set var="fieldXpath" value="health/application/cbh/currentnumber" />
						<form_new:row fieldXpath="${fieldXpath}" label="What is your employee number?" className="cbhsub">
							<field_new:input xpath="${fieldXpath}" title="" required="true" maxlength="16" />
						</form_new:row>

						<c:set var="fieldXpath" value="health/application/cbh/currentwork" />
						<form_new:row fieldXpath="${fieldXpath}" label="Who do you currently work for?" className="cbhsub">
							<field_new:array_select xpath="${fieldXpath}" required="true" title="" items="=Please choose...,1=Commonwealth Bank of Australia,4=Contractor/Franchisee,5=BankWest" />
						</form_new:row>

					</div>

					<div id="cbh_formeremployee">

						<c:set var="fieldXpath" value="health/application/cbh/formeremployee" />
						<form_new:row fieldXpath="${fieldXpath}" label="Are you a former employee, contractor or franchisee of the CBA Group?" className="cbhmain">
							<field_new:array_select xpath="${fieldXpath}" required="true" title="if you are a former employee of the CBA Group" items="=Please choose...,Y=Yes,N=No" />
						</form_new:row>

						<c:set var="fieldXpath" value="health/application/cbh/formernumber" />
						<form_new:row fieldXpath="${fieldXpath}" label="What was your employee number?" className="cbhsub">
							<field_new:input xpath="${fieldXpath}" title="" required="true" maxlength="16" />
						</form_new:row>

						<c:set var="fieldXpath" value="health/application/cbh/formerwork" />
						<form_new:row fieldXpath="${fieldXpath}" label="Who did you work for?" className="cbhsub">
							<field_new:array_select xpath="${fieldXpath}" required="true" title="who you currently work for" items="=Please choose...,1=Commonwealth Bank of Australia,4=Contractor/Franchisee,5=BankWest" />
						</form_new:row>

					</div>

					<div id="cbh_familymember">

						<c:set var="fieldXpath" value="health/application/cbh/familymember" />
						<form_new:row fieldXpath="${fieldXpath}" label="Are you an immediate family member of a current or former employee, contractor or franchisee of the CBA Group?" className="cbhmain">
							<field_new:array_select xpath="${fieldXpath}" required="true" title="if an immediate family member is a current or former employee of the CBA Group" items="=Please choose...,Y=Yes,N=No" />
						</form_new:row>

						<c:set var="fieldXpath" value="health/application/cbh/familynumber" />
						<form_new:row fieldXpath="${fieldXpath}" label="Name or employee number or CBHS membership number of family member" className="cbhsub">
							<field_new:input xpath="${fieldXpath}" title="" required="true" maxlength="30" />
						</form_new:row>

						<c:set var="fieldXpath" value="health/application/cbh/familywork" />
						<form_new:row fieldXpath="${fieldXpath}" label="Who did your family member work for?" className="cbhsub">
							<field_new:array_select xpath="${fieldXpath}" required="true" title="who your family member worked for" items="=Please choose...,1=Commonwealth Bank of Australia,4=Contractor/Franchisee,5=BankWest" />
						</form_new:row>

						<c:set var="fieldXpath" value="health/application/cbh/familyrel" />
						<form_new:row fieldXpath="${fieldXpath}" label="What is your relationship to the family member?" className="cbhsub">
							<field_new:array_select xpath="${fieldXpath}" required="true" title="your relationship to the family member" items="=Please choose...,partner=Partner,parent=Parent,child=Child,grandchild=Grandchild,sibling=Sibling,nephew=Nephew,niece=Niece" />
						</form_new:row>

					</div>

					<div id="cbh_ineligible" class="alert alert-danger">
						<span></span>
					</div>

				</form_new:fieldset>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

			$('#health_application').prepend('<c:out value="${html}" escapeXml="false" />');

			$.validator.addMethod("validateCBHEligibility",
				function(value, element) {
					return !$("#cbh_ineligible").is(":visible");
				}
			);

			$('#health_application_cbh_currentemployee').rules('add', {validateCBHEligibility:true});

			$('#cbh_eligibility .cbhsub, #cbh_formeremployee, #cbh_familymember, #cbh_ineligible').hide();

			$('#cbh_currentemployee .cbhmain select').on('change', function() {
				$('#cbh_currentemployee .cbhsub, #cbh_formeremployee, #cbh_familymember, #cbh_ineligible').slideUp(200);
				switch ($(this).val()) {
				case 'Y':
					$('#cbh_currentemployee .cbhsub').slideDown(200);
					break;
				case 'N':
					$('#cbh_formeremployee').slideDown(200);
					$('#cbh_formeremployee .cbhmain select').trigger('change');
					break;
				}
			});
			$('#cbh_formeremployee .cbhmain select').on('change', function() {
				$('#cbh_formeremployee .cbhsub, #cbh_familymember, #cbh_ineligible').slideUp(200);
				switch ($(this).val()) {
				case 'Y':
					$('#cbh_formeremployee .cbhsub').slideDown(200);
					break;
				case 'N':
					$('#cbh_familymember').slideDown(200);
					$('#cbh_familymember .cbhmain select').trigger('change');
					break;
				}
			});
			$('#cbh_familymember .cbhmain select').on('change', function() {
				$('#cbh_familymember .cbhsub, #cbh_ineligible').slideUp(200);
				switch ($(this).val()) {
				case 'Y':
					$('#cbh_familymember .cbhsub').slideDown(200);
					$('#health_application_cbh_familyrel').trigger('change');
					break;
				case 'N':
					var msg = 'Unfortunately, you are not eligible to join CBHS. Please <a href="javascript:;" data-slide-control="previous">select a different product</a>.';
					$.validator.messages.validateCBHEligibility = msg;
					$('#cbh_ineligible span').html(msg);
					$('#cbh_ineligible').slideDown(200, function() {
						$('#health_application_cbh_currentemployee').valid();
					});
					break;
				}
			});
			$('#health_application_cbh_familyrel').on('change', function() {
				healthFunds_CBH.changeRelation();
			});
		}<%-- /injection --%>

		<%-- Custom question: Partner relationship --%>
		if ($('#cbh_partnerrel').length > 0) {
			$('#cbh_partnerrel').show();
		}
		else {
			<c:set var="html">
				<c:set var="fieldXpath" value="health/application/cbh/partnerrel" />
				<form_new:row id="cbh_partnerrel" fieldXpath="${fieldXpath}" label="Relationship to you">
					<field_new:array_select xpath="${fieldXpath}" required="true" title="relationship to you" items="=Please choose...,2=Spouse,3=Defacto" />
				</form_new:row>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
			$('#health_application_partner_genderRow').after('<c:out value="${html}" escapeXml="false" />');
		}

		<%-- Custom question: Partner employee --%>
		if ($('#cbh_partneremployee').length > 0) {
			$('#cbh_partneremployee').show();
		}
		else {
			<c:set var="html">
				<c:set var="fieldXpath" value="health/application/cbh/partneremployee" />
				<form_new:row id="cbh_partneremployee" fieldXpath="${fieldXpath}" label="Is your partner a current or former employee, contractor or franchisee of the CBA Group?">
					<field_new:array_select xpath="${fieldXpath}" required="true" title="if your partner is a current or former employee of the CBA Group" items="=Please choose...,Y=Yes,N=No" />
				</form_new:row>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
			$('#health_application_partner_authority_group').after('<c:out value="${html}" escapeXml="false" />');
		}

		<%-- Custom question: Register --%>
		if ($('#cbh_register').length > 0) {
			$('#cbh_register').show();
		}
		else {
			<c:set var="html">
				<c:set var="fieldXpath" value="health/application/cbh/register" />
				<form_new:row id="cbh_register" fieldXpath="${fieldXpath}" >
					<field_new:checkbox xpath="${fieldXpath}" required="false" value="Y" label="true" title="Would you like to be registered for CBHS Online Services?" />
				</form_new:row>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
			$('#health_application_optInEmail-group').after('<c:out value="${html}" escapeXml="false" />');
		}

		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('injectingFund')) {

			<%-- Dependants --%>
			healthFunds._dependants('CBHS policies provide cover for all dependents under the age of 18 including step and foster children. Adult dependents who are aged between 18 and 24 years and who are: studying full time (min 20 hours per week), 1st or 2nd year apprentices or employed on an unpaid internship may continue to be covered by CBHS policies. Other adult dependents can apply for a separate policy (subject to meeting eligibility criteria).');
			if (Results.getSelectedProduct() !== false && Results.getSelectedProduct().info.productTitle == 'CBHS Prestige (with Non-student Dependant/s)') {
				$.extend(healthDependents.config, { 'school':false, 'schoolMin':18, 'schoolMax':24, 'schoolID':false });
			}
			else {
				$.extend(healthDependents.config, { 'school':true, 'schoolMin':18, 'schoolMax':24, 'schoolID':false });
			}

			<%-- Fund IDs become optional --%>
			$('#clientMemberID input').rules('remove', 'required');
			$('#partnerMemberID input').rules('remove', 'required');

			<%-- Partner authority --%>
			healthFunds._partner_authority(true);

			<%-- Calendar for start cover --%>
			meerkat.modules.healthPaymentStep.setCoverStartRange(0, 29);

			<%-- Payments --%>
			healthFunds_CBH.paymentLabelOriginal = $('#health_payment_details_type label:first').text();
			meerkat.modules.radioGroup.changeLabelText( $('#health_payment_details_type'), 0, 'Invoice' );

			meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly':false, 'monthly':false, 'quarterly':true, 'halfyearly':true, 'annually':true });
			meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':false, 'halfyearly':false, 'annually':false });

			$('#health_payment_details_type').after('<p class="CBH" style="display:none; margin-top:1em">You will shortly receive a Payment Notice from CBHS.  Your Payment Notice will include the biller code and reference number needed to BPAY your contribution or make your payment by credit card via BPOINT.  If CBHS does not receive your payment within 14 days, you will receive a reminder notice.</p>');
			$('.health-payment_details-type').on('change.CBH', function() {
				if ($('#health_payment_details_type input:checked').val() == 'cc') {
					$('#health_payment_details-selection p.CBH').slideDown(200);
				}
				else {
					$('#health_payment_details-selection p.CBH').slideUp(200);
				}
			});

			$('#health_payment_details_frequency').on('change.CBH', function() {
				$('.health_bank-details_policyDay-message').html('');
				if (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'ba') {
					switch (meerkat.modules.healthPaymentStep.getSelectedFrequency()) {
						case 'fortnightly':
							$('.health_bank-details_policyDay-message').html('Fortnightly payments will be deducted on a Thursday.');
							break;
						case 'monthly':
							$('.health_bank-details_policyDay-message').html('Monthly payments will be deducted on the 15th of each month.');
							break;
					}
				}
			});

			<%-- Claims account --%>
			meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
			meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

			<%-- Load join dec into label --%>
			healthFunds_CBH.joinDecLabelHtml = $('#health_declaration + label').html();
			healthFunds_CBH.ajaxJoinDec = $.ajax({
				url: 'health_fund_info/CBH/declaration.html',
				type: 'GET',
				async: true,
				dataType: 'html',
				timeout: 20000,
				cache: true,
				success: function(htmlResult) {
					$('#health_declaration + label').html(htmlResult);
				},
				error: function(obj,txt) {
				}
			});
		}<%-- /not loading quote --%>
	},
	unset: function() {
		<%-- Custom questions - hide in case user comes back --%>
		$('#cbh_eligibility, #cbh_partnerrel, #cbh_partneremployee, #cbh_register').hide();

		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('injectingFund')) {
			<%-- Dependants --%>
			healthFunds._dependants(false);
			healthDependents.resetConfig();

			healthFunds._reset();

			<%-- Payments --%>
			meerkat.modules.radioGroup.changeLabelText( $('#health_payment_details_type'), 0, healthFunds_CBH.paymentLabelOriginal );
			healthFunds_CBH.paymentLabelOriginal = undefined;

			$('.health-payment_details-type').off('change.CBH');
			$('#health_payment_details-selection p.CBH').remove();

			$('#health_payment_details_frequency').off('change.CBH');
			$('.health_bank-details_policyDay-message').html('');

			<%-- Load join dec into label --%>
			if (healthFunds_CBH.ajaxJoinDec) {
				healthFunds_CBH.ajaxJoinDec.abort();
			}
			$('#health_declaration + label').html(healthFunds_CBH.joinDecLabelHtml);
		}
	},

	changeRelation: function() {
		<%-- Check the correct path is selected for the family relationship question to display --%>
		if ($('#health_application_cbh_currentemployee').val() != 'N' || $('#health_application_cbh_formeremployee').val() != 'N' || $('#health_application_cbh_familymember').val() != 'Y')
			return;

		if (healthChoices._cover == 'S') {
		$('#cbh_ineligible').slideUp(200, function(){ $(this).hide(); });
			return true;
		}
		switch ($('#health_application_cbh_familyrel').val()) {
			case 'grandchild':
			case 'niece':
			case 'nephew':
				var msg = 'Unfortunately due to your situation your partner and/or dependants are not eligible for CBHS products. You could <a href="javascript:void(0);" onclick="Results.startOver();" style="color:inherit;font-weight:inherit;font-size:inherit;">start again</a> and select "Single" cover for just yourself, or <a href="javascript:;" data-slide-control="previous" >select a different product</a>.';
				$.validator.messages.validateCBHEligibility = msg;
				$('#cbh_ineligible span').html(msg);
				$('#cbh_ineligible').slideDown(200, function() {
					$('#health_application_cbh_currentemployee').valid();
				});
				break;
			default:
				$('#cbh_ineligible').slideUp(200, function(){ $(this).hide(); });
		}
	}
};