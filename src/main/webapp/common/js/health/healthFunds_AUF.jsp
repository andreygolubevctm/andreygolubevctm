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
  $paymentTypeContainer: $('div.health-payment_details-type').siblings('div.fieldrow_legend'),
  $claimsAccountOptin: $('#health_payment_bank_claims'),
  set: function(){
    <%--dependant definition--%>
      meerkat.modules.healthFunds._dependants('This policy provides cover for children under the age of 23 or who are aged between 23-25 years and engaged in full time study. Student dependants do not need to be living at home to be added to the policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

      meerkat.modules.healthFunds._previousfund_authority(true);

    <%--school Age--%>
    meerkat.modules.healthDependants.updateConfig({schoolMinAge: 23});

    <%--credit card & bank account frequency & day frequency--%>
    meerkat.modules.healthPaymentStep.overrideSettings('bank', { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true });
    meerkat.modules.healthPaymentStep.overrideSettings('credit', {'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true });

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
    });

    healthFunds_AUF.$paymentFrequency.on('change.AUF', function renderPaymentDayFrequency(){
      healthFunds_AUF.renderPaymentDay();
    });

    healthFunds_AUF.$paymentStartDate.on("changeDate.AUF", function renderPaymentDayCalendar(e) {
      healthFunds_AUF.renderPaymentDay();
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

    healthFunds_AUF.$paymentType.off('change.AUF');
    healthFunds_AUF.$paymentFrequency.off('change.AUF');
    healthFunds_AUF.$paymentStartDate.off("changeDate.AUF");

    <%--failed application--%>
    meerkat.modules.healthFunds.applicationFailed = function(){ return false; };
  }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />