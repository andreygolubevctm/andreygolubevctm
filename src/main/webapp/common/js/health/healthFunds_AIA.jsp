<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
AIA
=======================
--%>
var healthFunds_AIA = {
    $policyDateHiddenField : $('.health_details-policyDate'),
    $paymentStartDate: $("#health_payment_details_start"),
    $partnerEmailRow: null,
    $partnerEmail: null,
    emailUniqueMsg: 'To activate your Vitality membership, a unique email is required for each adult on the policy. Duplicate emails are not supported.',
    $policyDateCreditMessage : $('.health_payment_credit-details_policyDay-message'),
    $policyDateBankMessage : $('.health_payment_bank-details_policyDay-message'),

    paymentDayChange : function(value) {
        healthFunds_AIA.$policyDateHiddenField.val(value);
    },

    set: function() {
        if (!_.isNull(healthFunds_AIA.$partnerEmailRow)) {
            healthFunds_AIA.$partnerEmailRow.show();
        } else {
            <c:set var="html">
                <c:set var="fieldXpath" value="health/application/partner/email" />
                <form_v2:row fieldXpath="${fieldXpath}" label="Email Address" id="partner-email">
                    <field_v2:email xpath="${fieldXpath}" title="your partners email address" required="true" size="40" />
                </form_v2:row>
            </c:set>

            <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
            $('.health-person-details-partner .form-group:nth-child(2)').after('<c:out value="${html}" escapeXml="false" />');

            healthFunds_AIA.$partnerEmailRow = $('#partner-email');
            healthFunds_AIA.$partnerEmail = healthFunds_AIA.$partnerEmailRow.find('input');
            healthFunds_AIA.$partnerEmail
                .attr('data-rule-isUnique', true)
                .attr('data-isUniqueTo', $('#health_application_email').val())
                .attr('data-msg-isUnique', healthFunds_AIA.emailUniqueMsg);
        }

        <%--Contact Point question--%>
        meerkat.modules.healthFunds.showHowToSendInfo('AIA', true);

        <%--Authority--%>
        meerkat.modules.healthFunds._previousfund_authority(true);
        $('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '50');

        <%--dependant definition--%>
        meerkat.modules.healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

        <%--schoolgroups and defacto --%>
        meerkat.modules.healthDependants.updateConfig({ showSchoolFields:true, 'schoolMinAge':21, 'schoolMaxAge':24, showSchoolIdField:true });

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':true, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':true, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 });

        <%--claims account--%>
        meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
        meerkat.modules.healthCreditCard.render();

        <%--calendar for start cover--%>
        if(_.has(meerkat.modules,'healthCoverStartDate')) {
            meerkat.modules.healthCoverStartDate.setCoverStartRange(0, 30);
        } else {
            meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);
        }
        healthFunds_AIA.$paymentStartDate.datepicker('setDaysOfWeekDisabled', '0,6');

        meerkat.messaging.subscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_AIA.paymentDayChange);

        <%-- update deduction message --%>
        var deductionText = "Your payment will be deducted on the policy start date";
        healthFunds_AIA.$policyDateCreditMessage.add(healthFunds_AIA.$policyDateBankMessage).text(deductionText);
    },
    unset: function(){
        healthFunds_AIA.$partnerEmailRow.hide();

        <%--Contact Point question--%>
        meerkat.modules.healthFunds.hideHowToSendInfo();

        meerkat.messaging.unsubscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_AIA.paymentDayChange);

        meerkat.modules.healthFunds._reset();

        <%--Authority off--%>
        meerkat.modules.healthFunds._previousfund_authority(false);
        $('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '10');

        <%--dependant definition off--%>
        meerkat.modules.healthFunds._dependants(false);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.resetConfig();
        meerkat.modules.healthCreditCard.render();
    }
};

</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />