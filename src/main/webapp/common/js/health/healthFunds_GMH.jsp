<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
GMH
=======================
--%>
var healthFunds_GMH = {
    $policyDateHiddenField : $('.health_details-policyDate'),
    $policyDateCreditMessage : $('.health_payment_credit-details_policyDay-message'),
    $policyDateBankMessage : $('.health_payment_bank-details_policyDay-message'),
    $paymentType : $('#health_payment_details_type input'),
    $paymentFrequency : $('#health_payment_details_frequency'),
    $paymentStartDate: $("#health_payment_details_start"),
    $paymentTypeContainer: $('div.health-payment_details-type').siblings('div.fieldrow_legend'),
    $claimsAccountOptin: $('#health_payment_bank_claims'),
    paymentDayChange : function(value) {
        healthFunds_GMH.$policyDateHiddenField.val(value);
        healthFunds_GMH.updateMessage();
    },

    set: function() {

        <%--Authority--%>
        meerkat.modules.healthFunds._previousfund_authority(true);

        <%--dependant definition--%>
        meerkat.modules.healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

        <%--schoolgroups and defacto
        TODO: TEST THIS --%>
        meerkat.modules.healthDependants.updateConfig({ showSchoolFields:true, 'schoolMinAge':21, 'schoolMaxAge':24, showSchoolIdField:true });

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 });

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

        meerkat.messaging.subscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_GMH.paymentDayChange);


        healthFunds_GMH.$paymentType.on('change.GMH', function updatePaymentMsgPaymentType(){
            healthFunds_GMH.updateMessage();
        });

        healthFunds_GMH.$paymentFrequency.on('change.GMH', function updatePaymentMsgFrequency(){
            healthFunds_GMH.updateMessage();
        });

        healthFunds_GMH.$paymentStartDate.on("changeDate.GMH", function updatePaymentMsgCalendar(e) {
            healthFunds_GMH.updateMessage();
        });

        <%-- Unset the refund optin radio buttons --%>
        healthFunds_GMH.$claimsAccountOptin.find("input:checked").each(function(){
          $(this).prop("checked",null).trigger("change");
        });

    },
    updateMessage: function() {
        <%--selections for payment date--%>

        var messageField = null;
        if(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc'){
            messageField = healthFunds_GMH.$policyDateCreditMessage;
            healthFunds_GMH.$paymentTypeContainer.slideUp();
        } else {
            messageField = healthFunds_GMH.$policyDateBankMessage;
            healthFunds_GMH.$paymentTypeContainer.text('*GMHBA offers a 2% discount for bank account payments').slideDown();
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
        } else if(startDate === todayDate && premiumType === 'fortnightly') {
            messageText = 'Your first payment will be debited in the next 24 hours and thereafter on the same day each fortnight';
        } else if(startDate > todayDate && premiumType === 'fortnightly') {
            messageText = 'Your first payment will be debited on your policy start date and thereafter on the same day each fortnight';
        } else {
            messageText = 'Your payment will be deducted on the policy start date';
        }

        messageField.text(messageText);

    },
    unset: function(){
        meerkat.messaging.unsubscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_GMH.paymentDayChange);

        healthFunds_GMH.$paymentTypeContainer.text('').slideUp();

        meerkat.modules.healthFunds._reset();

        <%--Authority off--%>
        meerkat.modules.healthFunds._previousfund_authority(false);

        <%--dependant definition off--%>
        meerkat.modules.healthFunds._dependants(false);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.resetConfig();
        meerkat.modules.healthCreditCard.render();

        <%--selections for payment date--%>
        healthFunds_GMH.$paymentType.off('change.GMH');
        healthFunds_GMH.$paymentFrequency.off('change.GMH');
        healthFunds_GMH.$paymentStartDate.off("changeDate.GMH");

    }
};

</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />