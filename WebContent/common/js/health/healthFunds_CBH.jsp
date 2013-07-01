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
			<%-- Inject CSS --%>
			<c:set var="html">
				<style type="text/css">
				body.CBH #health_payment_credit-selection, body.CBH .health_bank-details_day-group {display:none !important;}
				body.CBH .health_person-details_authority_group {display:block !important;}
				body.CBH .health-payment_details-claims-group, body.CBH .health_bank-details_policyDay-group, body.CBH .health_bank-details_policyDay-message {display:block !important;}
				body.CBH .health_bank-details_policyDay-group select {display:none !important;}
				body.CBH .health_bank-details_policyDay-group .fieldrow_label {color:#FAFCFE;}
				body.CBH #health_declaration-selection ul { list-style: disc }
				body.CBH #health_declaration-selection ul li { padding-bottom: 0.5em }
				</style>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

			$('head').append('<c:out value="${html}" escapeXml="false" />');

			<c:set var="html">
				<div id="cbh_eligibility" class="qe-window fieldset">
					<h4>How are you eligible to join CBHS?</h4>
					<div class="content">
						<div id="cbh_currentemployee">
							<div class="fieldrow cbhmain">
								<div class="fieldrow_label">Are you a current employee of the CBA Group?</div>
								<div class="fieldrow_value"><field:array_select xpath="health/application/cbh/currentemployee" required="false" title="" items="=Please choose...,Y=Yes,N=No" /></div>
								<div class="cleardiv"></div>
							</div>
							<div class="fieldrow cbhsub">
								<div class="fieldrow_label">What is your employee number?</div>
								<div class="fieldrow_value"><field:input xpath="health/application/cbh/currentnumber" title="" required="false" maxlength="16" /></div>
								<div class="cleardiv"></div>
							</div>
							<div class="fieldrow cbhsub">
								<div class="fieldrow_label">Who do you currently work for?</div>
								<div class="fieldrow_value"><field:array_select xpath="health/application/cbh/currentwork" required="false" title="" items="=Please choose...,1=Commonwealth Bank of Australia,4=Colonial State Bank,5=BankWest" /></div>
								<div class="cleardiv"></div>
							</div>
						</div>

						<div id="cbh_formeremployee">
							<div class="fieldrow cbhmain">
								<div class="fieldrow_label">Are you a former employee of the CBA Group?</div>
								<div class="fieldrow_value"><field:array_select xpath="health/application/cbh/formeremployee" required="false" title="" items="=Please choose...,Y=Yes,N=No" /></div>
								<div class="cleardiv"></div>
							</div>
							<div class="fieldrow cbhsub">
								<div class="fieldrow_label">What was your employee number?</div>
								<div class="fieldrow_value"><field:input xpath="health/application/cbh/formernumber" title="" required="false" maxlength="16" /></div>
								<div class="cleardiv"></div>
							</div>
							<div class="fieldrow cbhsub">
								<div class="fieldrow_label">Who did you work for?</div>
								<div class="fieldrow_value"><field:array_select xpath="health/application/cbh/formerwork" required="false" title="" items="=Please choose...,1=Commonwealth Bank of Australia,4=Colonial State Bank,5=BankWest" /></div>
								<div class="cleardiv"></div>
							</div>
						</div>

						<div id="cbh_familymember">
							<div class="fieldrow cbhmain">
								<div class="fieldrow_label">Are you an immediate family member of a current or former employee of the CBA Group?</div>
								<div class="fieldrow_value"><field:array_select xpath="health/application/cbh/familymember" required="false" title="" items="=Please choose...,Y=Yes,N=No" /></div>
								<div class="cleardiv"></div>
							</div>
							<div class="cbhsub">
								<div class="fieldrow_label">Name or employee number or CBHS membership number of family member</div>
								<div class="fieldrow_value"><field:input xpath="health/application/cbh/familynumber" title="" required="false" maxlength="30" /></div>
								<div class="cleardiv"></div>
							</div>
							<div class="fieldrow cbhsub">
								<div class="fieldrow_label">Who did your family member work for?</div>
								<div class="fieldrow_value"><field:array_select xpath="health/application/cbh/familywork" required="false" title="" items="=Please choose...,1=Commonwealth Bank of Australia,4=Colonial State Bank,5=BankWest" /></div>
								<div class="cleardiv"></div>
							</div>
							<div class="fieldrow cbhsub">
								<div class="fieldrow_label">What is your relationship to the family member?</div>
								<div class="fieldrow_value"><field:array_select xpath="health/application/cbh/familyrel" required="false" title="" items="=Please choose...,partner=Partner,parent=Parent,child=Child,grandchild=Grandchild,sibling=Sibling,nephew=Nephew,niece=Niece" /></div>
								<div class="cleardiv"></div>
							</div>
						</div>

						<div id="cbh_ineligible" style="position:relative; color:#EB5300; background:#fff; padding:10px">
							<span></span><input type="checkbox" style="position:absolute; clip:rect(0px 1px 1px 0px); clip:rect(0px, 1px, 1px, 0px); height:1px; width:1px" value="Y" disabled="disabled" name="health_application_cbh_ineligible" id="health_application_cbh_ineligible">
						</div>
					</div>
					<div class="footer"></div>
				</div>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

			$('#health_application').prepend('<c:out value="${html}" escapeXml="false" />');

			$('#health_application_cbh_currentemployee').rules('add', 'required');
			$('#health_application_cbh_currentwork').rules('add', 'required');
			$('#health_application_cbh_currentnumber').rules('add', 'required');
			$('#health_application_cbh_formeremployee').rules('add', 'required');
			$('#health_application_cbh_formerwork').rules('add', 'required');
			$('#health_application_cbh_familymember').rules('add', 'required');
			$('#health_application_cbh_familynumber').rules('add', 'required');
			$('#health_application_cbh_familywork').rules('add', 'required');
			$('#health_application_cbh_familyrel').rules('add', 'required');

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
					var msg = 'Unfortunately, you are not eligible to join CBHS. Please <a href="javascript:void(0);" onclick="QuoteEngine.prevSlide();" style="color:inherit;font-weight:inherit;font-size:inherit;">select a different product</a>.';
					$('#health_application_cbh_ineligible').rules('remove', 'required');
					$('#health_application_cbh_ineligible').rules('add', {required:true, messages:{required:msg}});
					$('#cbh_ineligible span').html(msg);
					$('#cbh_ineligible').slideDown(200);
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
				<div class="fieldrow" id="cbh_partnerrel">
					<div class="fieldrow_label">Relationship to you</div>
					<div class="fieldrow_value"><field:array_select xpath="health/application/cbh/partnerrel" required="false" title="" items="=Please choose...,2=Spouse,3=Defacto" /></div>
					<div class="cleardiv"></div>
				</div>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
			$('#health_application_partner_genderRow').after('<c:out value="${html}" escapeXml="false" />');
			$('#health_application_cbh_partnerrel').rules('add', 'required');
		}

		<%-- Custom question: Partner employee --%>
		if ($('#cbh_partneremployee').length > 0) {
			$('#cbh_partneremployee').show();
		}
		else {
			<c:set var="html">
				<div class="fieldrow" id="cbh_partneremployee">
					<div class="fieldrow_label">Is your partner a current or former employee of the CBA Group?</div>
					<div class="fieldrow_value"><field:array_select xpath="health/application/cbh/partneremployee" required="false" title="" items="=Please choose...,Y=Yes,N=No" /></div>
					<div class="cleardiv"></div>
				</div>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
			$('#health_application_partner_authority_group').after('<c:out value="${html}" escapeXml="false" />');
			$('#health_application_cbh_partneremployee').rules('add', 'required');
		}

		<%-- Custom question: Register --%>
		if ($('#cbh_register').length > 0) {
			$('#cbh_register').show();
		}
		else {
			<c:set var="html">
				<div class="fieldrow" id="cbh_register">
					<div class="fieldrow_label"></div>
					<div class="fieldrow_value"><field:checkbox xpath="health/application/cbh/register" required="false" value="Y" label="true" title="Would you like to be registered for CBHS Online Services?" /></div>
					<div class="cleardiv"></div>
				</div>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
			$('#health_application_optInEmail-group').after('<c:out value="${html}" escapeXml="false" />');
		}

		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('stage-0')) {
			<%-- Dependants --%>
			healthFunds._dependants('CBHS policies provide cover for all dependents under the age of 18 including step and foster children. Adult dependents who are aged between 18 and 24 years and who are: studying full time (min 20 hours per week), 1st or 2nd year apprentices or employed on an unpaid internship may continue to be covered by CBHS policies. Other adult dependents can apply for a separate policy (subject to meeting eligibility criteria).');
			if (Results._selectedProduct && Results._selectedProduct.info.productTitle == 'CBHS Prestige (with Non-student Dependant/s)') {
				$.extend(healthDependents.config, { 'school':false, 'schoolMin':18, 'schoolMax':24, 'schoolID':false });
			}
			else {
				$.extend(healthDependents.config, { 'school':true, 'schoolMin':18, 'schoolMax':24, 'schoolID':false });
			}

			<%-- Fund ID's become optional --%>
			$('#clientMemberID').find('input').rules('remove', 'required');
			$('#partnerMemberID').find('input').rules('remove', 'required');

			<%-- Calendar for start cover --%>
			healthCalendar._min = 0;
			healthCalendar._max = 29;
			healthCalendar.update();

			<%-- Payments --%>
			healthFunds_CBH.$paymentLabel = $('#health_payment_details_type .ui-button-text:first');
			healthFunds_CBH.paymentLabelOriginal = healthFunds_CBH.$paymentLabel.text();
			healthFunds_CBH.$paymentLabel.text('Invoice');

			paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly':false, 'monthly':false, 'quarterly':true, 'halfyearly':true, 'annually':true };
			paymentSelectsHandler.bank = { 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':false, 'halfyearly':false, 'annually':false };

			$('#health_payment_details_type').after('<p class="CBH" style="display:none; margin-top:1em; width:390px">You will shortly receive a Payment Notice from CBHS.  Your Payment Notice will include the biller code and reference number needed to BPAY your contribution or make your payment by credit card via BPOINT.  If CBHS does not receive your payment within 14 days, you will receive a reminder notice.</p>');
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
				if (paymentSelectsHandler.getType() == 'ba') {
					switch (paymentSelectsHandler.getFrequency()) {
						case 'F':
							$('.health_bank-details_policyDay-message').html('Fortnightly payments will be deducted on a Thursday.');
							break;
						case 'M':
							$('.health_bank-details_policyDay-message').html('Monthly payments will be deducted on the 15th of each month.');
							break;
					}
				}
			});

			<%-- Claims account --%>
			paymentSelectsHandler.creditBankSupply = true;
			paymentSelectsHandler.creditBankQuestions = true;

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
		if (!$('body').hasClass('stage-0')) {
			<%-- Dependants --%>
			healthFunds._dependants(false);
			healthDependents.resetConfig();

			<%-- Calendar for start cover --%>
			healthCalendar.reset();

			<%-- fund IDs become mandatory (back to default) --%>
			$('#clientMemberID').find('input').rules('add', 'required');
			$('#partnerMemberID').find('input').rules('add', 'required');

			<%-- Payments --%>
			healthFunds_CBH.$paymentLabel.text(healthFunds_CBH.paymentLabelOriginal);
			delete healthFunds_CBH.$paymentLabel;
			delete healthFunds_CBH.paymentLabelOriginal;

			$('.health-payment_details-type').off('change.CBH');
			$('#health_payment_details-selection p.CBH').remove();

			$('#health_payment_details_frequency').off('change.CBH');
			$('.health_bank-details_policyDay-message').html('');

			<%-- credit card and bank account frequency and day frequncy --%>
			paymentSelectsHandler.resetFrequencyCheck();

			<%-- Load join dec into label --%>
			if (healthFunds_CBH.ajaxJoinDec) {
				healthFunds_CBH.ajaxJoinDec.abort();
			}
			$('#health_declaration + label').html(healthFunds_CBH.joinDecLabelHtml);
		}
	},

	changeRelation: function() {
		$('#cbh_ineligible').slideUp(200, function(){ $(this).hide(); });
		if (healthChoices._cover == 'S') {
			return true;
		}
		switch ($('#health_application_cbh_familyrel').val()) {
			case 'grandchild':
			case 'niece':
			case 'nephew':
				var msg = 'Unfortunately due to your situation your partner and/or dependants are not eligible for CBHS products. You could <a href="javascript:void(0);" onclick="Results.startOver();" style="color:inherit;font-weight:inherit;font-size:inherit;">start again</a> and select "Single" cover for just yourself, or <a href="javascript:void(0);" onclick="QuoteEngine.prevSlide();" style="color:inherit;font-weight:inherit;font-size:inherit;">select a different product</a>.';
				$('#health_application_cbh_ineligible').rules('remove', 'required');
				$('#health_application_cbh_ineligible').rules('add', {required:true, messages:{required:msg}});
				$('#cbh_ineligible span').html(msg);
				$('#cbh_ineligible').slideDown(200);
				break;
		}
	}
};