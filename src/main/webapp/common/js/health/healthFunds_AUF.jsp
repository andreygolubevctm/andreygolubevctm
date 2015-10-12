<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
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
  set: function(){
    <%--dependant definition--%>
    healthFunds._dependants('This policy provides cover for children under the age of 23 or who are aged between 23-25 years and engaged in full time study. Student dependants do not need to be living at home to be added to the policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

    <%--school Age--%>
    meerkat.modules.healthDependants.updateConfig({schoolMin: 23});

    <%--credit card & bank account frequency & day frequency--%>
    meerkat.modules.healthPaymentStep.overrideSettings('bank', { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true });
    meerkat.modules.healthPaymentStep.overrideSettings('credit', {'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true });

    <%--calendar for start cover--%>
    meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);

    <%--selections for payment date--%>
    healthFunds._payments = { 'min':0, 'max':5, 'weekends':false };
    $('#update-premium').on('click.AUF', function(){
      var _html = healthFunds._paymentDays( $('#health_payment_details_start').val() );
      healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
      healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
    });

    <%--credit card options--%>
    meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
    meerkat.modules.healthCreditCard.render();

    <%--failed application--%>
    healthFunds.applicationFailed = function(){
      meerkat.modules.transactionId.getNew();
    };
  },
  unset: function(){
    healthFunds._reset();
    <%--dependant definition off--%>
    healthFunds._dependants(false);

    <%--credit card options--%>
    meerkat.modules.healthCreditCard.resetConfig();
    meerkat.modules.healthCreditCard.render();

    <%--selections for payment date--%>
    healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
    healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
    $('#update-premium').off('click.AUF');

    <%--failed application--%>
    healthFunds.applicationFailed = function(){ return false; };
  }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />