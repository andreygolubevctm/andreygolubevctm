<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>

<%-- Because of cross domain issues with the payment gateway, we always use a CTM iframe to proxy to HAMBS' iframes so we need iframe src URL and hostOrigin to be pulled from CTM's settings (not the base and root URLs of the current brand) --%>
<c:set var="ctmSettings" value="${settingsService.getPageSettingsByCode('CTM','HEALTH')}"/>
<c:set var="hostOrigin">${ctmSettings.getRootUrl()}</c:set>
<c:if test="${fn:endsWith(hostOrigin, '/')}">
    <c:set var="hostOrigin">${fn:substring( hostOrigin, 0, fn:length(hostOrigin)-1 )}</c:set>
</c:if>

<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
MYO
=======================
--%>
var healthFunds_MYO = {
    $policyDateHiddenField : $('.health_details-policyDate'),
    $paymentStartDate: $("#health_payment_details_start"),
    $partnerEmailRow: null,
    $partnerEmail: null,
    emailUniqueMsg: 'To activate your Vitality membership, a unique email is required for each adult on the policy. Duplicate emails are not supported.',
    $policyDateCreditMessage : $('.health_payment_credit-details_policyDay-message'),
    $policyDateBankMessage : $('.health_payment_bank-details_policyDay-message'),
    $contactPoint: $('#health_application_contactPoint'),
    $contactPointMessage: null,

    paymentDayChange : function(value) {
        healthFunds_MYO.$policyDateHiddenField.val(value);
    },

    set: function() {
        if (!_.isNull(healthFunds_MYO.$partnerEmailRow)) {
            healthFunds_MYO.$partnerEmailRow.show();
        } else {
            <c:set var="html">
                <c:set var="fieldXpath" value="health/application/partner/email" />
                <form_v2:row fieldXpath="${fieldXpath}" label="Email Address" id="partner-email">
                    <field_v2:email xpath="${fieldXpath}" title="your partners email address" required="true" size="40" />
                </form_v2:row>
            </c:set>

            <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
            $('.health-person-details-partner .form-group:nth-child(2)').after('<c:out value="${html}" escapeXml="false" />');

            healthFunds_MYO.$partnerEmailRow = $('#partner-email');
            healthFunds_MYO.$partnerEmail = healthFunds_MYO.$partnerEmailRow.find('input');
            healthFunds_MYO.$partnerEmail
                .attr('data-rule-isUnique', true)
                .attr('data-isUniqueTo', $('#health_application_email').val())
                .attr('data-msg-isUnique', healthFunds_MYO.emailUniqueMsg);
        }

        <%--Contact Point question--%>
        meerkat.modules.healthFunds.showHowToSendInfo('MYO', true);

        <%--Authority--%>
        meerkat.modules.healthFunds._previousfund_authority(true);
        $('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '50');

        <%--dependant definition--%>
        meerkat.modules.healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

        <%--schoolgroups and defacto --%>
        meerkat.modules.healthDependants.updateConfig({ showSchoolFields:true, 'schoolMinAge':21, 'schoolMaxAge':24, showSchoolIdField:true });

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 });

        <%--claims account--%>
        meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
        meerkat.modules.healthCreditCard.render();

        <%--fund offset check--%>
        meerkat.modules.healthFundTimeOffset.onInitialise({
            weekends: false,
            coverStartRange: {
                min: 0,
                max: 30
            }
        });

        meerkat.messaging.subscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_MYO.paymentDayChange);

        <%-- update deduction message --%>
        var deductionText = "Your payment will be deducted on the policy start date";
        healthFunds_MYO.$policyDateCreditMessage.add(healthFunds_MYO.$policyDateBankMessage).text(deductionText);

        meerkat.modules.paymentGateway.setup({
            "paymentEngine" : meerkat.modules.healthPaymentGatewayNAB,
            "name" : 'health_payment_gateway',
            "src": '${ctmSettings.getBaseUrl()}', <%-- the CTM iframe source URL --%>
            "origin": '${hostOrigin}', <%-- the CTM host origin --%>
            "providerCode": 'myo',
            "brandCode": '${pageSettings.getBrandCode()}',
            "handledType" :  {
                "credit" : true,
                "bank" : false
            },
            "updateValidationSelectors" : meerkat.modules.healthPaymentStep.updateValidationSelectorsPaymentGateway,
            "resetValidationSelectors" : meerkat.modules.healthPaymentStep.resetValidationSelectorsPaymentGateway,
            "paymentTypeSelector" : $("input[name='health_payment_details_type']:checked"),
            "getSelectedPaymentMethod" :  meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
        });


        if (_.isNull(healthFunds_MYO.$contactPointMessage)) {
            var contactPointCopy = '<span class="fieldrow_legend" id="health_application_contactPointMessage">SMS is limited to notifications, members communications will be sent by email.</span>';
            $(contactPointCopy).insertAfter(healthFunds_MYO.$contactPoint);
            healthFunds_MYO.$contactPointMessage = $('#health_application_contactPointMessage');
        } else {
            healthFunds_MYO.$contactPointMessage.show();
        }
    },
    unset: function(){
        healthFunds_MYO.$partnerEmailRow.hide();

        <%--Contact Point question--%>
        meerkat.modules.healthFunds.hideHowToSendInfo();

        meerkat.messaging.unsubscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_MYO.paymentDayChange);

        meerkat.modules.healthFunds._reset();

        <%--Authority off--%>
        meerkat.modules.healthFunds._previousfund_authority(false);
        $('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '10');

        <%--dependant definition off--%>
        meerkat.modules.healthFunds._dependants(false);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.resetConfig();
        meerkat.modules.healthCreditCard.render();

        meerkat.modules.paymentGateway.reset();

        healthFunds_MYO.$contactPointMessage.hide();
    }
};

</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />