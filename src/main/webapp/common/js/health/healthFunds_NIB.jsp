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
    $paymentType : $('#health_payment_details_type input'),
    $paymentFrequency : $('#health_payment_details_frequency'),
    $paymentStartDate: $("#health_payment_details_start"),
    $paymentTypeContainer: $('div.health-payment_details-type').siblings('div.fieldrow_legend'),
    $medicareFirstname: $('#health_payment_medicare_firstName'),
    $medicareLastname: $('#health_payment_medicare_surname'),
    set: function(){
        <%--Contact Point question--%>
        meerkat.modules.healthFunds.showHowToSendInfo('NIB', true);

        <%-- Previous funds --%>
        $('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '10');
            
        <%-- Partner authority--%>
        meerkat.modules.healthFunds._partner_authority(true);

        <%--dependant definition--%>
        meerkat.modules.healthFunds._dependants('This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 25 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.');

        <%--schoolgroups and defacto--%>
        meerkat.modules.healthDependants.updateConfig({ showSchoolFields:true, 'schoolMinAge':21, 'schoolMaxAge':24, showSchoolIdField:true });

        meerkat.modules.healthFunds._previousfund_authority(true);

        <%--fund offset check--%>
        meerkat.modules.healthFundTimeOffset.onInitialise({
            weekends: true,
            coverStartRange: {
                min: 0,
                max: 29
            },
            renderPaymentDaysCb: healthFunds_NIB.renderPaymentDays
        });

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

        healthFunds_NIB.$paymentType.on('change.NIB', function renderPaymentDaysPaymentType(){
            healthFunds_NIB.renderPaymentDays();
        });

        healthFunds_NIB.$paymentFrequency.on('change.NIB', function renderPaymentDaysFrequency(){
            healthFunds_NIB.renderPaymentDays();
        });

        healthFunds_NIB.$paymentStartDate.on("changeDate.NIB", function renderPaymentDaysCalendar(e) {
            healthFunds_NIB.renderPaymentDays();
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

        <%-- Medicare Fields --%>
        healthFunds_NIB.$medicareFirstname.add(healthFunds_NIB.$medicareLastname).attr('maxlength','24').attr('data-rule-personNameLtd','true').removeAttr('data-rule-personName');
    },
    renderPaymentDays: function(){
        var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
        if (freq == 'fortnightly') {
            meerkat.modules.healthFunds.setPayments({ 'min':0, 'max':10, 'weekends':false, 'countFrom' : 'effectiveDate'});
            <%-- Redundant code, due to the fact that rules are getting triggered on the payment step for cover start date
                 calendar on the application step, due to the cover start date being moved to the application step. --%>
            <%--healthFunds_NIB.$paymentStartDate.datepicker('setDaysOfWeekDisabled', '0,6');--%>
        } else {
            meerkat.modules.healthFunds.setPayments({ 'min':0, 'max':27, 'weekends':true , 'countFrom' : 'effectiveDate', 'maxDay' : 27});
            <%-- Redundant code, due to the fact that rules are getting triggered on the payment step for cover start date
                 calendar on the application step, due to the cover start date being moved to the application step. --%>
            <%--healthFunds_NIB.$paymentStartDate.datepicker('setDaysOfWeekDisabled', '');--%>
        }
        var _html = meerkat.modules.healthPaymentDay.paymentDays( $('#health_payment_details_start').val() );
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);

        if(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc'){
            healthFunds_NIB.$paymentTypeContainer.slideUp();
        } else {
            healthFunds_NIB.$paymentTypeContainer.text('*NIB offers a 4% discount for bank account payments').slideDown();
        }
    },
    unset: function(){
        healthFunds_NIB.$paymentType.off('change.NIB');
        healthFunds_NIB.$paymentFrequency.off('change.NIB');
        healthFunds_NIB.$paymentStartDate.off("changeDate.NIB");

        $("#health_application_email").setRequired(true).prop('disabled', false);
        $("#health_application_contactPoint_E").prop('disabled', false).parents('.btn-form-inverse').attr('disabled',false);

        $('#health_application_no_email').off('click.NIB');
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), false);
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), false);

        healthFunds_NIB.$paymentTypeContainer.text('').slideUp();

        <%--Contact Point question--%>
        meerkat.modules.healthFunds.hideHowToSendInfo();

        meerkat.modules.healthFunds._reset();

        <%--Authority off--%>
        meerkat.modules.healthFunds._previousfund_authority(false);

        <%--dependant definition off--%>
        meerkat.modules.healthFunds._dependants(false);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.resetConfig();
        meerkat.modules.healthCreditCard.render();

        <%-- Medicare Fields --%>
        healthFunds_NIB.$medicareFirstname.add(healthFunds_NIB.$medicareLastname).removeAttr('maxlength').removeAttr('data-rule-personNameLtd').attr('data-rule-personName','true');
    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />