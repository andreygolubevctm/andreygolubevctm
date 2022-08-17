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

						<div class="flexi-extras-icons">
							<%-- TODO - confirm all help text  --%>
							<field_v2:checkbox xpath="general-dental" value="general-dental" required="false" label="true" title="General Dental" helpId="269" className="flexi-icon HLTicon-general-dental"/>
							<field_v2:checkbox xpath="major-dental" value="major-dental" required="false" label="true" title="Major Dental" helpId="270" className="flexi-icon HLTicon-major-dental"/>
							<%--&lt;%&ndash; TODO - confirm data-value &ndash;%&gt;--%>
							<field_v2:checkbox xpath="orthodontics" value="orthodontics" required="false" label="true" title="Orthodontics" helpId="272" className="flexi-icon HLTicon-orthodontic"/>
							<field_v2:checkbox xpath="optical" value="optical" required="false" label="true" title="Optical" helpId="273" className="flexi-icon HLTicon-optical"/>
							<field_v2:checkbox xpath="physiotherapy" value="physiotherapy" required="false" label="true" title="Physiotherapy" helpId="274" className="flexi-icon HLTicon-physiotherapy"/>
							<%--&lt;%&ndash; TODO - confirm data-value and helpId &ndash;%&gt;--%>
							<field_v2:checkbox xpath="chiropractic_osteopath" value="chiropractic_osteopath" required="false" label="true" title="Chiropractic/ Osteopath" helpId="567" className="flexi-icon HLTicon-chiropractor"/>
							<field_v2:checkbox xpath="natural-therapies" value="natural-therapies" required="false" label="true" title="Natural Therapies" helpId="278" className="flexi-icon HLTicon-naturopathy"/>
							<field_v2:checkbox xpath="podiatry" value="podiatry" required="false" label="true" title="Podiatry" helpId="276" className="flexi-icon HLTicon-podiatry"/>
							<field_v2:checkbox xpath="pharmacy" value="pharmacy" required="false" label="true" title="Pharmacy" helpId="283" className="flexi-icon HLTicon-non-pbs-pharm"/>
							<%--&lt;%&ndash; TODO - confirm data-value and helpId &ndash;%&gt;--%>
							<field_v2:checkbox xpath="speech_eye_occupational-therapies" value="speech_eye_occupational-therapies" required="false" label="true" title="Speech/Eye/ Occupational Therapies" helpId="568" className="flexi-icon HLTicon-speech-therapy"/>
							<field_v2:checkbox xpath="health_management" value="health_management" required="false" label="true" title="Health Management" helpId="570" className="flexi-icon HLTicon-lifestyle-products"/>
						</div>
						<field_v2:validatedHiddenField xpath="health/application/bup/flexiextras" additionalAttributes=' data-rule-flexiExtras="true"' />
					</form_v2:fieldset>
				</c:set>
				<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

				$('#health_application').prepend('<c:out value="${html}" escapeXml="false" />');

			}

			var $bup_flexi_extras = $('#bup_flexi_extras'),
				$flexiExtrasHidden = $('#health_application_bup_flexiextras');

			$bup_flexi_extras.find('.flexi-extras-icons').each(function () {
				var $this = $(this);

				<%-- // fix positioning of label and help --%>
				$this.find('.flexi-icon[class*="HLTicon-"] label').each(function () {
					var $el = $(this);
                    var labelTxt = $("<span/>").addClass('iconLabel').append($.trim($el.text().replace('Need Help?', '')));
                    var helpLnk = $el.find('a').detach();
					$el.empty().append(helpLnk).append("<br>").append(labelTxt);
				});
			});

			<%-- TODO - pull flexi-available value from ratesheet data --%>
			$bup_flexi_extras.find('.flexi-available').text('4');  <%-- set the number of extras you can choose here --%>

			<%-- Obeserve the state change of the checkbox --%>
			$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon input[type="checkbox"]').change(function onFlexiExtraClick() {
				var $this = $(this);
				toggleFlexiExtra($this.val(), $this.prop("checked"))
			});

			<%-- preload --%>
			updateFromHiddenField();

			function toggleFlexiExtra(value, state){
				$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon input[type="checkbox"]').filter(function filterByValue() {
					return $(this).val() === value;
				}).prop('checked', state);

				return updateHiddenField();
			}

			function updateHiddenField() {
				var selectedExtrasArray = $bup_flexi_extras.find('.flexi-extras-icons .flexi-icon input[type="checkbox"]:checked').map(function() {
						return $(this).val();
					}).get(),
					selectedCount = selectedExtrasArray.length,
					availableCount = $bup_flexi_extras.find('.flexi-available:first').text(),
					remainingCount =  availableCount - selectedCount;

				$flexiExtrasHidden.val(selectedExtrasArray.join());

				if (remainingCount > 0) {
					$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon input[type="checkbox"]').attr('disabled', false);
					$bup_flexi_extras.find('.flexi-message-complete').addClass('hidden');
					$bup_flexi_extras.find('.flexi-message').removeClass('hidden');
					$bup_flexi_extras.find('.flexi-selected').text(selectedCount);
					$bup_flexi_extras.find('.flexi-remaining').text(remainingCount);
				} else if (remainingCount === 0){
					$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon input[type="checkbox"]:not(:checked)').attr('disabled', true);
					$bup_flexi_extras.find('.flexi-message-complete').removeClass('hidden');
					$bup_flexi_extras.find('.flexi-message').addClass('hidden');
					$flexiExtrasHidden.valid();
				} else {
					$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon input[type="checkbox"]:not(:checked)').attr('disabled', false);
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

				$bup_flexi_extras.find('.flexi-extras-icons .flexi-icon input[type="checkbox"]').each(function() {
					var value = $(this).val();
					return toggleFlexiExtra(value, $.inArray( value, values ) > -1);
				});
			}

			$.validator.addMethod('flexiExtras', function() {
				var isValid = $bup_flexi_extras.find('.flexi-extras-icons .flexi-icon input[type="checkbox"]:checked').length - $bup_flexi_extras.find('.flexi-available:first').text() === 0;
				$bup_flexi_extras.toggleClass('has-error', !isValid);
				return isValid;
			});

		}


		<%-- Authority Fund Name --%>
		$('#health_previousfund_primary_authority').setRequired(true, 'Bupa requires authorisation to contact your previous fund');
		$('#health_previousfund_partner_authority').setRequired(true, 'Bupa requires authorisation to contact your partner\'s previous fund');
		$('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').setRequired(false).attr('maxlength', '10');
		meerkat.modules.healthFunds._previousfund_authority(true);

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
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly':false, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });

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
		meerkat.modules.healthCreditCard.hideCardTypeAndExpiry();

		meerkat.modules.healthPaymentBambora.show();

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

		<%--schoolgroups and defacto--%>
		meerkat.modules.healthDependants.updateConfig({isBUP:true, showSchoolFields:true, 'schoolMinAge':healthFunds_BUP.extendedFamilyMinAge, 'schoolMaxAge':healthFunds_BUP.extendedFamilyMaxAge, showSchoolIdField:true, showSchoolCommencementField:true, dateStudyCommencedFieldName:'Study Start Date' });

	},
	updateMessage: function() {
		var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
		var payMethodSetting = (meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc') ? 'credit' : 'bank';
		var paymentMethodHasFreq = (payMethodSetting != null && meerkat.modules.healthPaymentStep.getSetting(payMethodSetting)[freq] == true) ? true : false;
		if (freq == 'fortnightly' && paymentMethodHasFreq) {
			var deductionText = "Your initial payment will be one month's premium and a fortnightly amount thereafter. If your policy start date is within the next 14 days from today, your 1st payment will be deducted on your start date. If your start day is outside 14 days, your initial payment will be taken within the next 24 hours.";
		} else {
			var deductionText = 'If your policy start date is within the next 14 days from today, your 1st payment will be deducted on your start date. If your start day is outside 14 days, your initial payment will be taken within the next 24 hours.';
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

		meerkat.modules.healthPaymentBambora.hide();

		<%-- selections for payment date --%>
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), false);
		meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), false);

		healthFunds_BUP.$paymentType.off('change.BUP');
		healthFunds_BUP.$paymentFrequency.off('change.BUP');
		healthFunds_BUP.$paymentStartDate.off("changeDate.BUP");

		$('.bup-payment-legend').remove();

		<%-- Unset any ipp tokenisation --%>
		meerkat.modules.healthPaymentBambora.reset();
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />
