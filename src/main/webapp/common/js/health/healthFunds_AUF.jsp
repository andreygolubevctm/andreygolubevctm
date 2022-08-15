<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="now" class="java.util.Date"/>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
AUF
=======================
--%>
var healthFunds_AUF = {
  $paymentType : $('#health_payment_details_type input'),
  $paymentFrequency : $('#health_payment_details_frequency'),
  $paymentStartDate: $("#health_payment_details_start"),
  $creditPoliyDate: $('#health_payment_credit_policyDay'),
  $paymentTypeContainer: $('div.health-payment_details-type').siblings('div.fieldrow_legend'),
  $claimsAccountOptin: $('#health_payment_bank_claims'),
  $fortnightlyMessage: $('#health_auf_fortnightly_payment_frequency_message'),
  $paymentDetailsMessage: $('#simples-dialogue-229'),
  $paymentDetailsMessageText: $('#simples-dialogue-229 > div > div > label > div'),
  $fortnightlyBankMessage: $('#simples-dialogue-230'),
  $fortnightlyCreditMessage: $('#simples-dialogue-231'),
  set: function(){
    <%--dependant definition--%>
      meerkat.modules.healthFunds._dependants('This policy provides cover for children under the age of 23 or who are aged between 23-25 years and engaged in full time study. Student dependants do not need to be living at home to be added to the policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

      meerkat.modules.healthFunds._previousfund_authority(true);

    <%--school Age--%>
    meerkat.modules.healthDependants.updateConfig({schoolMinAge: 23, isAUF: true, showSchoolFields:true, showSchoolIdField:true, showSchoolCommencementField: true});

    <%--credit card & bank account frequency & day frequency--%>
    meerkat.modules.healthPaymentStep.overrideSettings('bank', { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true });
    meerkat.modules.healthPaymentStep.overrideSettings('credit', {'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true });
    meerkat.modules.healthPaymentStep.overrideSettings('isAUF', true);

    <%-- show health payment day script--%>
    if (meerkat.site.isCallCentreUser) {
      meerkat.modules.healthApplicationDynamicScripting.togglePaymentDayScript(true);
    }

    <%--selections for payment date--%>
    meerkat.modules.healthFunds.setPayments({ 'min':0, 'max':5, 'weekends':false });

    <%--fund offset check--%>
    meerkat.modules.healthFundTimeOffset.onInitialise({
        weekends: false,
        coverStartRange: {
            min: 0,
            max: 30
        },
        renderPaymentDaysCb: healthFunds_AUF.renderPaymentDay
    });

    healthFunds_AUF.$paymentType.on('change.AUF', function renderPaymentDayPaymentType(){
      healthFunds_AUF.renderPaymentDay();
      healthFunds_AUF.updateCreditCardMessage();
    });

    healthFunds_AUF.$paymentFrequency.on('change.AUF', function renderPaymentDayFrequency(){
      healthFunds_AUF.renderPaymentDay();
      healthFunds_AUF.updateCreditCardMessage();
    });

    healthFunds_AUF.$paymentStartDate.on("changeDate.AUF", function renderPaymentDayCalendar(e) {
      healthFunds_AUF.renderPaymentDay();
      healthFunds_AUF.updateCreditCardMessage();
    });

    healthFunds_AUF.$creditPoliyDate.on("change.AUF", function renderPaymentPolicyDate(e) {
      healthFunds_AUF.updateCreditCardMessage();
    });

    <%--credit card options--%>
    meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
    meerkat.modules.healthCreditCard.render();

    <%--failed application--%>
      meerkat.modules.healthFunds.applicationFailed = function(){
      meerkat.modules.transactionId.getNew();
    };

    <%-- Unset the refund optin radio buttons --%>
    healthFunds_AUF.$claimsAccountOptin.find("input:checked").each(function(){
      $(this).prop("checked",null).trigger("change");
    });
  },
  renderPaymentDay: function(){
    var _html = meerkat.modules.healthPaymentDay.paymentDays( healthFunds_AUF.$paymentStartDate.val() );
    meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
    meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);
  },
  updateCreditCardMessage: function(){
    var creditCardType = meerkat.modules.healthPaymentStep.getSelectedPaymentMethod();
    var policyDateSelect = healthFunds_AUF.$creditPoliyDate.find('option:selected').val();
    var premiumType = healthFunds_AUF.$paymentFrequency.val();
    if (premiumType === "halfyearly") {
      premiumType = "half-yearly";
    } else if (premiumType === "annually") {
      premiumType = "annual";
    }

    if (meerkat.site.isCallCentreUser) {
      <%-- Simples --%>
      if (premiumType === "fortnightly" && creditCardType === "cc") {
        healthFunds_AUF.$fortnightlyCreditMessage.toggleClass('hidden', false);
        healthFunds_AUF.$fortnightlyBankMessage.toggleClass('hidden', true);
        healthFunds_AUF.$paymentDetailsMessage.toggleClass('hidden', true);
      } else if (premiumType === "fortnightly" && creditCardType === "ba") {
        healthFunds_AUF.$fortnightlyBankMessage.toggleClass('hidden', false);
        healthFunds_AUF.$fortnightlyCreditMessage.toggleClass('hidden', true);
        healthFunds_AUF.$paymentDetailsMessage.toggleClass('hidden', true);
      } else if (premiumType !== "fortnightly" && creditCardType === "cc") {
        var message = "<p class='red'>As you have chosen to pay by credit card, an initial " + premiumType + " payment will be taken within the next 48 hours. Any adjustments will then be applied to the second payment. If you would like to change your payment frequency at any time, please reach out to Australian Unity.</p><p class='black'>If you have a Direct Debit, you will need to cancel it through your bank or your previous fund's online member service.</p>";
        healthFunds_AUF.$paymentDetailsMessageText.html(message);
        healthFunds_AUF.$paymentDetailsMessage.toggleClass('hidden', false);
        healthFunds_AUF.$fortnightlyBankMessage.toggleClass('hidden', true);
        healthFunds_AUF.$fortnightlyCreditMessage.toggleClass('hidden', true);
      } else {
        healthFunds_AUF.$fortnightlyBankMessage.toggleClass('hidden', true);
        healthFunds_AUF.$fortnightlyCreditMessage.toggleClass('hidden', true);
        healthFunds_AUF.$paymentDetailsMessage.toggleClass('hidden', true);
      }
    } else {
      <%-- Online --%>
      if (premiumType === "fortnightly" && creditCardType === "cc") {
        healthFunds_AUF.$fortnightlyMessage.text('Your initial payment will be the monthly premium taken within 48 hours. Your ongoing payments will be fortnightly. Any adjustments will then be applied to the second payment. If you would like to change your payment frequency at any time, please reach out to Australian Unity.');
        healthFunds_AUF.$fortnightlyMessage.toggleClass('hidden', false);
      } else if (premiumType === "fortnightly" && creditCardType === "ba") {
        healthFunds_AUF.$fortnightlyMessage.text('Your initial payment will be the monthly premium. Your ongoing payments will be fortnightly. If you would like to change your payment frequency at any time, please reach out to Australian Unity.');
        healthFunds_AUF.$fortnightlyMessage.toggleClass('hidden', false);
      } else if (premiumType !== "fortnightly" && creditCardType === "cc" ) {
        var message = 'As you have chosen to pay by credit card, an initial ' + premiumType + ' payment will be taken within the next 48 hours. Any adjustments will then be applied to the second payment. If you would like to change your payment frequency at any time, please reach out to Australian Unity.';
        healthFunds_AUF.$fortnightlyMessage.text(message);
        healthFunds_AUF.$fortnightlyMessage.toggleClass('hidden', false);
      } else {
        healthFunds_AUF.$fortnightlyMessage.toggleClass('hidden', true);
      }
    }
  },
  unset: function(){
      meerkat.modules.healthFunds._reset();
    <%--dependant definition off--%>
      meerkat.modules.healthFunds._dependants(false);

      meerkat.modules.healthFunds._previousfund_authority(false);

    <%--credit card options--%>
    meerkat.modules.healthCreditCard.resetConfig();
    meerkat.modules.healthCreditCard.render();

    <%--selections for payment date--%>
    meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), false);
    meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), false);

    healthFunds_AUF.$paymentTypeContainer.text('').slideUp();
    healthFunds_AUF.$paymentDetailsMessage.toggleClass('hidden', true);
    healthFunds_AUF.$fortnightlyMessage.toggleClass('hidden', true);
    healthFunds_AUF.$fortnightlyBankMessage.toggleClass('hidden', true);
    healthFunds_AUF.$fortnightlyCreditMessage.toggleClass('hidden', true);

    healthFunds_AUF.$paymentType.off('change.AUF');
    healthFunds_AUF.$paymentFrequency.off('change.AUF');
    healthFunds_AUF.$paymentStartDate.off("changeDate.AUF");
    healthFunds_AUF.$creditPoliyDate.off('change.AUF');

    <%--failed application--%>
    meerkat.modules.healthFunds.applicationFailed = function(){ return false; };
  }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />