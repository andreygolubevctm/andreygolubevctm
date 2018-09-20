<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
BUP
=======================
--%>
var healthFunds_BUP = {
	$paymentType : $('#health_payment_details_type input'),
	$paymentFrequency : $('#health_payment_details_frequency'),
	$paymentStartDate: $("#health_payment_details_start"),
	$claimsAccountOptin: $('#health_payment_bank_claims'),
	$primaryMiddleName: $('#health_application_primary_middleName'),
	$partnerMiddleName: $('#health_application_partner_middleName'),
    extendedFamilyMinAge: 21,
    extendedFamilyMaxAge: 25,
    healthDependantMaxAge: 25,
	set: function () {

		healthFunds_BUP.isYourChoiceExtras = meerkat.modules.healthResults.getSelectedProduct().info.productTitle.indexOf('Your Choice Extras') > -1;

		if (healthFunds_BUP.isYourChoiceExtras) {

			<%-- Custom question: BUP flexi extras --%>
			if ($('#bup_flexi_extras').length > 0) {
				$('#bup_flexi_extras').show();
			} else {

				<c:set var="html">
					<form_v2:fieldset id="bup_flexi_extras" legend="" className="primary">

						<div class="col-sm-4 col-md-4 col-lg-3 hidden-xs no-padding"><img src="assets/graphics/logos/health/BUP.png" /></div>
						<div class="col-sm-8 col-md-8 col-lg-9 no-padding">
							<%-- TODO - use content from db or rate sheet rather than hard code --%>
							<h2>BUPA Your Choice Extras</h2>
							<p><strong>Your Choice Extras</strong> gives you the flexibility to choose the services you want to be covered for. Pick any <strong><span class="flexi-available">4</span> services</strong> from the selection below to build the right cover for your needs.</p>
						</div>
						<div class="flexi-message">You have selected <span class="flexi-selected text-tertiary"></span> of your <span class="flexi-available text-tertiary">4</span> <span class="text-tertiary">available</span> extras cover inclusions, <strong class="text-warning"><span class="flexi-remaining"></span> more selections remaining</strong></div>
						<div class="flexi-message-complete hidden">You have selected all of your <span class="flexi-available">4</span> available extras cover inclusions.</div>

						<ul class="flexi-extras-icons">
							<%-- TODO - confirm all help text  --%>
							<li class="flexi-icon HLTicon-general-dental" data-value="general-dental"><field_v2:help_icon helpId="269" /><br />General Dental</li>
							<li class="flexi-icon HLTicon-major-dental"  data-value="major-dental"><field_v2:help_icon helpId="270" /><br />Major Dental</li>
							<%-- TODO - confirm data-value --%>
							<li class="flexi-icon HLTicon-orthodontic" data-value="orthodontics"><field_v2:help_icon helpId="272" /><br />Orthodontics</li>
							<li class="flexi-icon HLTicon-optical" data-value="optical"><field_v2:help_icon helpId="273" /><br />Optical</li>
							<li class="flexi-icon HLTicon-physiotherapy" data-value="physiotherapy"><field_v2:help_icon helpId="274" /><br />Physiotherapy</li>
							<%-- TODO - confirm data-value and helpId --%>
							<li class="flexi-icon HLTicon-chiropractor" data-value="chiropractic_osteopath"><field_v2:help_icon helpId="567" /><br />Chiropractic/ Osteopath</li>
							<li class="flexi-icon HLTicon-naturopathy" data-value="natural-therapies"><field_v2:help_icon helpId="278" /><br />Natural Therapies</li>
							<li class="flexi-icon HLTicon-podiatry" data-value="podiatry"><field_v2:help_icon helpId="276" /><br />Podiatry</li>
							<li class="flexi-icon HLTicon-non-pbs-pharm" data-value="pharmacy"><field_v2:help_icon helpId="283" /><br />Pharmacy</li>
							<%-- TODO - confirm data-value and helpId --%>
							<li class="flexi-icon HLTicon-speech-therapy" data-value="speech_eye_occupational-therapies"><field_v2:help_icon helpId="568" /><br />Speech/Eye/ Occupational Therapies</li>
							<li class="flexi-icon HLTicon-lifestyle-products" data-value="health_management"><field_v2:help_icon helpId="570" /><br />Health Management</li>
						</ul>
						<field_v2:validatedHiddenField xpath="health/application/bup/flexiextras" additionalAttributes=' data-rule-flexiExtras="true"' />
					</form_v2:fieldset>
				</c:set>
				<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

				$('#health_application').prepend('<c:out value="${html}" escapeXml="false" />');

			}

			var $bup_flexi_extras = $('#bup_flexi_extras'),
				$flexiExtrasHidden = $('#health_application_bup_flexiextras');

			<%-- TODO - pull flexi-available value from ratesheet data --%>
			$bup_flexi_extras.find('.flexi-available').text('4');  <%-- set the number of extras you can choose here --%>

			$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon').on('click.BUP', function onFlexiExtraClick() {
				var $this = $(this);
				if ($this.hasClass('disabled')) {return;}
				toggleFlexiExtra($this.data('value'), !$this.hasClass('active'))
			});

			<%-- preload --%>
			updateFromHiddenField();

			function toggleFlexiExtra(value, state){
				$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon').filter(function filterByValue() {
					return $(this).data('value')=== value;
				}).toggleClass('active', state);

				return updateHiddenField();
			}

			function updateHiddenField() {
				var selectedExtrasArray = $bup_flexi_extras.find('.flexi-extras-icons .flexi-icon.active').map(function() {
						return $(this).data('value');
					}).get(),
					selectedCount = selectedExtrasArray.length,
					availableCount = $bup_flexi_extras.find('.flexi-available:first').text(),
					remainingCount =  availableCount - selectedCount;

				$flexiExtrasHidden.val(selectedExtrasArray.join());

				if (remainingCount > 0) {
					$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon.disabled').removeClass('disabled');
					$bup_flexi_extras.find('.flexi-message-complete').addClass('hidden');
					$bup_flexi_extras.find('.flexi-message').removeClass('hidden');
					$bup_flexi_extras.find('.flexi-selected').text(selectedCount);
					$bup_flexi_extras.find('.flexi-remaining').text(remainingCount);
				} else if (remainingCount === 0){
					$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon:not(.active)').addClass('disabled');
					$bup_flexi_extras.find('.flexi-message-complete').removeClass('hidden');
					$bup_flexi_extras.find('.flexi-message').addClass('hidden');
					$flexiExtrasHidden.valid();
				} else {
					<%-- remainingCount < 0, reset, only happens when user selected Flexi extra then go back selects Saver --%>
					$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon.active').removeClass('active');
					$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon.disabled').removeClass('disabled');
					$bup_flexi_extras.find('.flexi-message-complete').addClass('hidden');
					$bup_flexi_extras.find('.flexi-message').removeClass('hidden');
					$bup_flexi_extras.find('.flexi-selected').text(0);
					$bup_flexi_extras.find('.flexi-remaining').text(availableCount);
					$flexiExtrasHidden.val('');
					return false;
				}
				return true;
			}

			function updateFromHiddenField() {
				var values = $flexiExtrasHidden.val().split(',');

				$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon').each(function() {
					var value = $(this).data('value');
					return toggleFlexiExtra(value, $.inArray( value, values ) > -1);
				});
			}

			$.validator.addMethod('flexiExtras', function() {
				var isValid = $bup_flexi_extras.find('.flexi-extras-icons .flexi-icon.active').length - $bup_flexi_extras.find('.flexi-available:first').text() === 0;
				$bup_flexi_extras.toggleClass('has-error', !isValid);
				return isValid;
			});

		}


		<%-- Authority Fund Name --%>
		$('#health_previousfund_primary_authority').setRequired(true, 'Bupa requires authorisation to contact your previous fund');
		$('#health_previousfund_partner_authority').setRequired(true, 'Bupa requires authorisation to contact your partner\'s previous fund');
		$('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').setRequired(false).attr('maxlength', '10');
		meerkat.modules.healthFunds._previousfund_authority(true);
		healthFunds_BUP.$primaryMiddleName.setRequired(false);
		healthFunds_BUP.$partnerMiddleName.setRequired(false);

		<%--fund offset check--%>
		meerkat.modules.healthFundTimeOffset.onInitialise({
			weekends: false,
			coverStartRange: {
				min: 0,
				max: 60
			},
			renderPaymentDaysCb: healthFunds_BUP.updateMessage
		});

		<%-- Increase minimum age requirement for applicants from 16 to 17 --%>
		healthFunds_BUP.$_dobPrimary = $('#health_application_primary_dob');
		healthFunds_BUP.$_dobPartner = $('#health_application_partner_dob');
		healthFunds_BUP.$_dobPrimary.addRule('youngestDOB', 17, "primary person's age cannot be under 17");
		healthFunds_BUP.$_dobPartner.addRule('youngestDOB', 17, "partner's age cannot be under 17");

		<%-- Payment Options --%>
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });

		healthFunds_BUP.$paymentType.on('change.BUP', function updatePaymentMsgPaymentType(){
			healthFunds_BUP.updateMessage();
		});

		healthFunds_BUP.$paymentFrequency.on('change.BUP', function updatePaymentMsgFrequency(){
			healthFunds_BUP.updateMessage();
		});

		healthFunds_BUP.$paymentStartDate.on("changeDate.BUP", function updatePaymentMsgCalendar(e) {
			healthFunds_BUP.updateMessage();
		});

		<%-- credit card options --%>
		meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':true, 'diners':false });
		meerkat.modules.healthCreditCard.render();

		meerkat.modules.healthPaymentIPP.show();

		<%-- Dependant's Age and message --%>
		var familyCoverType = meerkat.modules.healthChoices.returnCoverCode();
        if (familyCoverType === 'EF' || familyCoverType === 'ESP') {
            meerkat.modules.healthFunds._dependants('This product provides cover for Adult Dependants aged between 21 and 25');
            meerkat.modules.healthDependants.updateConfig({extendedFamilyMinAge: healthFunds_BUP.extendedFamilyMinAge, extendedFamilyMaxAge: healthFunds_BUP.extendedFamilyMaxAge});
		} else {
            meerkat.modules.healthFunds._dependants('Dependent child means a person who does not have a partner and is \(i\) aged under 21 or \(ii\) is receiving a full time education at a school, college or university recognised by the company and who is not aged 25 or over.');
		}
		meerkat.modules.healthDependants.setMaxAge(healthFunds_BUP.healthDependantMaxAge);
		meerkat.modules.healthDependants.updateConfig({showMiddleName: true});

		<%-- Unset the refund optin radio buttons --%>
		healthFunds_BUP.$claimsAccountOptin.find("input:checked").each(function(){
		  $(this).prop("checked",null).trigger("change");
		});

		<%-- Fix name field widths to account for the middleName field --%>
		healthFunds_BUP.$primaryFirstname = $('#health_application_primary_firstname').closest('.row-content');
		healthFunds_BUP.$primarySurname = $('#health_application_primary_surname').closest('.row-content');
		healthFunds_BUP.$partnerFirstname = $('#health_application_partner_firstname').closest('.row-content');
		healthFunds_BUP.$partnerSurname = $('#health_application_partner_surname').closest('.row-content');
		healthFunds_BUP.$primaryFirstname.removeClass('col-sm-4').addClass('col-lg-4 col-sm-3');
		healthFunds_BUP.$primarySurname.removeClass('col-sm-4').addClass('col-lg-4 col-sm-3');
		healthFunds_BUP.$partnerFirstname.removeClass('col-sm-4').addClass('col-lg-4 col-sm-3');
		healthFunds_BUP.$partnerSurname.removeClass('col-sm-4').addClass('col-lg-4 col-sm-3');

	},
	updateMessage: function() {
		var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
		if (freq == 'fortnightly') {
			var deductionText = "Your initial payment will be one month's premium and a fortnightly amount thereafter. Your account will be debited within the next 24 hours.";
		} else {
			var deductionText = 'Your account will be debited within the next 24 hours.';
		};

		meerkat.modules.healthFunds.setPayments({ 'min':6, 'max':7, 'weekends':false });

		var date = new Date();
		var _html = meerkat.modules.healthPaymentDay.paymentDays(meerkat.modules.dateUtils.dateValueFormFormat(date));
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);

		<%-- Select the only option --%>
		$('.health_payment_credit_details-policyDay').prop('selectedIndex',1);
		$('.health_payment_bank_details-policyDay').prop('selectedIndex',1);
		<%-- Change the deduction rate --%>

		$('.health_payment_credit-details_policyDay-message').text( deductionText);
		$('.health_payment_bank-details_policyDay-message').text(deductionText);
	},
	unset: function () {
		"use strict";

        <%-- Authority Fund Name --%>
        var $bup_flexi_extras = $('#bup_flexi_extras');
        <%-- Hide Fund specific questions --%>
        $bup_flexi_extras.find('.flexi-extras-icons .flexi-icon').off('click.BUP');
        $bup_flexi_extras.hide();


        meerkat.modules.healthFunds._reset();

		<%-- Authority Fund Name --%>
        meerkat.modules.healthFunds._previousfund_authority(false);
		$('#health_previousfund_primary_authority, #health_previousfund_partner_authority').setRequired(false);
		$('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').setRequired(true).removeAttr('maxlength');

		<%-- Dependants --%>
        meerkat.modules.healthFunds._dependants(false);

		<%-- Age requirements for applicants (back to default) --%>

		healthFunds_BUP.$_dobPrimary.addRule('youngestDOB', dob_health_application_primary_dob.ageMin, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
		healthFunds_BUP.$_dobPartner.addRule('youngestDOB', dob_health_application_partner_dob.ageMin, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

		healthFunds_BUP.$_dobPrimary = undefined;
		healthFunds_BUP.$_dobPartner = undefined;

		<%-- fund Name's become mandatory (back to default) --%>
		$('#health_previousfund_primary_fundName, #health_previousfund_partner_fundName').setRequired(true);

		<%-- credit card options --%>
		meerkat.modules.healthCreditCard.resetConfig();
		meerkat.modules.healthCreditCard.render();

		meerkat.modules.healthPaymentIPP.hide();

		<%-- selections for payment date --%>
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), false);
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), false);

		healthFunds_BUP.$paymentType.off('change.BUP');
		healthFunds_BUP.$paymentFrequency.off('change.BUP');
		healthFunds_BUP.$paymentStartDate.off("changeDate.BUP");

		$('.bup-payment-legend').remove();
		
		<%-- Fix name field widths to account for removal of middleName field --%>
		healthFunds_BUP.$primaryFirstname.removeClass('col-lg-4 col-sm-3').addClass('col-sm-4');
		healthFunds_BUP.$primarySurname.removeClass('col-lg-4 col-sm-3').addClass('col-sm-4');
		healthFunds_BUP.$partnerFirstname.removeClass('col-lg-4 col-sm-3').addClass('col-sm-4');
		healthFunds_BUP.$partnerSurname.removeClass('col-lg-4 col-sm-3').addClass('col-sm-4');

		healthFunds_BUP.$primaryMiddleName.setRequired(true);
		healthFunds_BUP.$partnerMiddleName.setRequired(true);

		<%-- Unset any ipp tokenisation --%>
		meerkat.modules.healthPaymentIPP.reset();
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />