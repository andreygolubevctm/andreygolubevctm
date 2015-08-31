<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
NIB
=======================
--%>
        
var healthFunds_NIB = {
    set: function(){
        <%--Contact Point question--%>
        healthApplicationDetails.showHowToSendInfo('NIB', true);

        <%-- Partner authority--%>
        healthFunds._partner_authority(true);

        <%--dependant definition--%>
        healthFunds._dependants('This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 25 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.');

        <%--schoolgroups and defacto--%>
        healthDependents.config = { 'school':true, 'defacto':false, 'schoolMin':21, 'schoolMax':24 };

        <%--fund ID's become optional--%>
        $('#clientMemberID input').rules("remove", "required");
        $('#partnerMemberID input').rules("remove", "required");
        healthFunds._previousfund_authority(true);

        <%--calendar for start cover--%>
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 29);

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 });

        <%--claims account--%>
        meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
        meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':true, 'diners':false });
        meerkat.modules.healthCreditCard.render();

        $('#update-premium').on('click.NIB', function() {
            var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
            if (freq == 'fortnightly') {
                healthFunds._payments = { 'min':0, 'max':10, 'weekends':false, 'countFrom' : 'effectiveDate'};
            } else {
                healthFunds._payments = { 'min':0, 'max':27, 'weekends':true , 'countFrom' : 'today', 'maxDay' : 27};
            }
            var _html = healthFunds._paymentDays( $('#health_payment_details_start').val() );
            healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
            healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
        });

        function onChangeNoEmailChkBox(){
            var $applicationEmailGroup = $('#health_application_emailGroup'),
                    $applicationEmailField = $("#health_application_email"),
                    $contactPointPost = $("#health_application_contactPoint_P"),
                    $contactPointEmail = $("#health_application_contactPoint_E");

            if( $("#health_application_no_email").is(":checked") ) {
                $applicationEmailGroup.find('*').removeClass("has-success").removeClass("has-error");
                $applicationEmailGroup.find('.error-field').remove();

                $applicationEmailField.val('');
                $applicationEmailField.prop('required', false);
                $applicationEmailField.prop('disabled', true);

                $contactPointPost.prop("checked",true);
                $contactPointPost.parents().first().addClass("active");

                $contactPointEmail.attr('disabled', true);
                $contactPointEmail.parents('.btn-form-inverse').removeClass("active").attr('disabled',true);

                $('#health_application_optInEmail-group').slideUp();
            }else{
                $applicationEmailField.prop('required', true);
                $applicationEmailField.prop('disabled', false);
                $contactPointEmail.parents('.btn-form-inverse').attr('disabled',false);
                $contactPointEmail.prop('disabled', false);
            }
        }
        onChangeNoEmailChkBox();
        $("#health_application_no_email").on("click.NIB",function() {onChangeNoEmailChkBox();});

    },
    unset: function(){
        $('#update-premium').off('click.NIB');

        $("#health_application_email").prop('required', true);
        $("#health_application_email").prop('disabled', false);
        $("#health_application_contactPoint_E").prop('disabled', false);
        $("#health_application_contactPoint_E").parents('.btn-form-inverse').attr('disabled',false);

        $('#health_application_no_email').off('click.NIB');
        healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
        healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);

        <%--Contact Point question--%>
        healthApplicationDetails.hideHowToSendInfo();

        healthFunds._reset();

        <%--Authority off--%>
        healthFunds._previousfund_authority(false);

        <%--dependant definition off--%>
        healthFunds._dependants(false);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.resetConfig();
        meerkat.modules.healthCreditCard.render();
    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />