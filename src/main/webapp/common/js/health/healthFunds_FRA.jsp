<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
FRA
=======================
--%>
var healthFunds_FRA = {
    $policyDateCreditMessage : $('.health_payment_credit-details_policyDay-message'),
    $policyDateBankMessage : $('.health_payment_bank-details_policyDay-message'),
    $paymentType : $('#health_payment_details_type input'),
    $paymentFrequency : $('#health_payment_details_frequency'),
    $paymentStartDate: $("#health_payment_details_start"),
    $claimsAccountOptin: $('#health_payment_bank_claims'),
    set: function(){
        <%--dependant definition--%>
        meerkat.modules.healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

        <%--Authority--%>
        meerkat.modules.healthFunds._previousfund_authority(true);

        <%--remove the DR in your details--%>
        meerkat.modules.healthFunds.setDoctorOption($('.person-title').find('option[value=DR]').first());
        $('.person-title').find('option[value=DR]').remove();

        <%--selections for payment date--%>
        healthFunds_FRA.$paymentType.on('change.FRA', function updatePaymentMsgPaymentType(){
            healthFunds_FRA.updateMessage();
        });

        healthFunds_FRA.$paymentFrequency.on('change.FRA', function updatePaymentMsgFrequency(){
            healthFunds_FRA.updateMessage();
        });

        healthFunds_FRA.$paymentStartDate.on("changeDate.FRA", function updatePaymentMsgCalendar(e) {
            healthFunds_FRA.updateMessage();
        });

        <%--change age of dependants and school--%>
        meerkat.modules.healthDependants.updateConfig({school:false});
        meerkat.modules.healthDependants.setMaxAge(25);

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

        <%--claims account--%>
        meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
        meerkat.modules.healthCreditCard.render();

        <%--fund offset check--%>
        meerkat.modules.healthFundTimeOffset.onInitialise({
            weekends: true,
            coverStartRange: {
                min: 0,
                max: 30
            }
        });

        <%-- Unset the refund optin radio buttons --%>
        healthFunds_FRA .$claimsAccountOptin.find("input:checked").each(function(){
          $(this).prop("checked",null).trigger("change");
        });

    },
    updateMessage: function() {
        var messageField = null;
        if(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc'){
            messageField = healthFunds_FRA.$policyDateCreditMessage;
        } else {
            messageField = healthFunds_FRA.$policyDateBankMessage;
        }

        var premiumType = $('#health_payment_details_frequency').val(),
                startDate = meerkat.modules.dateUtils.returnDate($('#health_payment_details_start').val()).getTime(),
                <%-- Get today's date without hours --%>
                todayDate = new Date(new Date(meerkat.modules.utils.getUTCToday()).setHours(0,0,0,0)).getTime();

        var messageText;
        if(startDate === todayDate && premiumType === 'annually') {
            messageText = 'Your payment will be debited in the next 24 hours';
        } else if(startDate > todayDate && premiumType === 'annually') {
            messageText = 'Your payment will be debited on your policy start date';
        } else if(startDate === todayDate && premiumType === 'monthly') {
            messageText = 'Your first payment will be debited in the next 24 hours and thereafter on the same day each month';
        } else if(startDate > todayDate && premiumType === 'monthly') {
            messageText = 'Your first payment will be debited on your policy start date and thereafter on the same day each month';
        } else {
            messageText = 'Your payment will be deducted on the policy start date';
        }

        messageField.text(messageText);
    },
    unset: function(){
        meerkat.modules.healthFunds._reset();

        <%--dependant definition off--%>
        meerkat.modules.healthFunds._dependants(false);

        <%--Authority off--%>
        meerkat.modules.healthFunds._previousfund_authority(false);

        <%--re-insert the DR in your details--%>
        $('.person-title').append(meerkat.modules.healthFunds.getDoctorOption());

        <%--selections for payment date--%>
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), false);
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), false);
        healthFunds_FRA.$paymentType.off('change.FRA');
        healthFunds_FRA.$paymentFrequency.off('change.FRA');
        healthFunds_FRA.$paymentStartDate.off("changeDate.FRA");

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.resetConfig();
        meerkat.modules.healthCreditCard.render();

    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />