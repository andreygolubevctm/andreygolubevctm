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
    $policyDateCreditMessage : $('.health_credit-card-details_policyDay-message'),
    paymentDayChange : function(value) {
        healthFunds_GMH.$policyDateHiddenField.val(value);
    },

    set: function() {

        <%--Authority--%>
        healthFunds._previousfund_authority(true);

        <%--dependant definition--%>
        healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

        <%--schoolgroups and defacto
        TODO: TEST THIS --%>
        meerkat.modules.healthDependants.updateConfig({ showSchoolFields:true, 'schoolMinAge':21, 'schoolMaxAge':24 });

        <%--school labels--%>
        healthFunds._schoolLabel = $('.health_dependant_details_schoolGroup').first().find('.control-label').text();
        $('.health_dependant_details_schoolGroup').find('.control-label').text('Name of school/employer/educational institution your child is attending');

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 });

        <%--claims account--%>
        meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
        meerkat.modules.healthCreditCard.render();

        <%--calendar for start cover--%>
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);

        meerkat.messaging.subscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_GMH.paymentDayChange);

        <%--selections for payment date--%>
        $('#update-premium').on('click.GMH', function(){
            if(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc'){
                meerkat.modules.healthPaymentDate.paymentDaysRenderEarliestDay(healthFunds_GMH.$policyDateCreditMessage, $('#health_payment_details_start').val(), [1], 7);
            }
            else {
                meerkat.modules.healthPaymentDate.populateFuturePaymentDays($('#health_payment_details_start').val(), 14, true, true);
            }
        });

    },
    unset: function(){
        meerkat.messaging.unsubscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_GMH.paymentDayChange);

        healthFunds._reset();

        <%--Authority off--%>
        healthFunds._previousfund_authority(false);

        <%--dependant definition off--%>
        healthFunds._dependants(false);


        <%--school labels off--%>
        $('#mainform').find('.health_dependant_details_schoolGroup').find('.control-label').text( healthFunds._schoolLabel );

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.resetConfig();
        meerkat.modules.healthCreditCard.render();
        <%--selections for payment date--%>
        $('#update-premium').off('click.GMH');

    }
};

</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />