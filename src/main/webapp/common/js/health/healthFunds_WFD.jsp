<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
WFD
=======================
--%>

var healthFunds_WFD = {
    ajaxJoinDec: false,
    $paymentFrequency : $('#health_payment_details_frequency'),
    $paymentStartDate: $("#health_payment_details_start"),
    schoolMinAge: 21,
    schoolMaxAge: 24,
    extendedFamilyMinAge: 21,
    extendedFamilyMaxAge: 25,
    set: function(){
        <%--dependant definition--%>
        var dependantsString = 'As a member of Westfund, your children aged between 21-24 are entitled to stay on your cover at no extra charge for a child of the Principal Member or their Partner, who is not married or living in a de facto relationship.';

        <%-- Dependant's Age and message --%>
        var familyCoverType = meerkat.modules.healthChoices.returnCoverCode();
        if (familyCoverType === 'EF' || familyCoverType === 'ESP') {
            meerkat.modules.healthFunds._dependants('This product provides cover for Adult Dependants at an additional premium for a child of the Principal Member or their Partner, who is not married or living in a de facto relationship, has reached the age of 21 but is under the age of 25, and is not a Student Dependant');
            meerkat.modules.healthDependants.updateConfig({extendedFamilyMinAge: healthFunds_WFD.extendedFamilyMinAge, extendedFamilyMaxAge: healthFunds_WFD.extendedFamilyMaxAge});
        } else {
            meerkat.modules.healthFunds._dependants(dependantsString);
        }

        <%--schoolgroups and defacto--%>
        meerkat.modules.healthDependants.updateConfig({showSchoolFields:false, 'schoolMinAge': healthFunds_WFD.schoolMinAge, 'schoolMaxAge': healthFunds_WFD.schoolMaxAge, showSchoolIdField:false });

        <%--Adding a statement--%>
        var msg = 'Please note that the LHC amount quoted is an estimate and will be confirmed once Westfund has verified your details.';
        healthFunds_WFD.$paymentFrequency.closest('div.row-content').append('<p class="statement" style="margin-top:1em">' + msg + '</p>');

        <%--Previous fund--%>
        $('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '10');

        <%--Authority--%>
        meerkat.modules.healthFunds._previousfund_authority(true);

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':false });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

        <%--claims account--%>
	    meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
	    meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
        meerkat.modules.healthCreditCard.render();

        healthFunds_WFD.$paymentFrequency.on('change.WFD', function renderPaymentDaysFrequency(){
            healthFunds_WFD.renderDeductionMessage();
        });

        <%--fund offset check--%>
        meerkat.modules.healthFundTimeOffset.onInitialise({
            weekends: true,
            coverStartRange: {
                min: 0,
                max: 29
            }
        });

        <%--Age requirements for applicants--%>
        <%--primary--%>
        healthFunds_WFD.$_dobPrimary = $('#health_application_primary_dob');
        <%--partner--%>
        healthFunds_WFD.$_dobPartner = $('#health_application_partner_dob');

        healthFunds_WFD.$_dobPrimary.addRule('youngestDOB', 18, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
        healthFunds_WFD.$_dobPartner.addRule('youngestDOB', 18, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

        <%-- Custom question: Partner relationship --%>
        if ($('#wfd_partnerrel').length > 0) {
            $('#wfd_partnerrel').show();
        }
        else {
            <c:set var="html">
            <c:set var="fieldXpath" value="health/application/wfd/partnerrel" />
            <form_v2:row id="wfd_partnerrel" fieldXpath="${fieldXpath}" label="Relationship to you">
            <field_v2:array_select xpath="${fieldXpath}"
                    required="true"
                    title="Relationship to you" items="=Please choose...,2=Spouse,3=Defacto" placeHolder="Relationship" disableErrorContainer="${true}" />
            </form_v2:row>
            </c:set>
            <c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />
            $('#health_application_partner_genderRow').after('<c:out value="${html}" escapeXml="false" />');
        }

        if (meerkat.site.tracking.brandCode == 'wfdd') {
            <%-- May need to add remove additional properties from this field see onChangeNoEmailChkBox for example --%>
            $('#health_application_optInEmail-group').css('display', 'none');
            $('#applicationForm_1').append('<input type="hidden" name="health_application_optInEmail" value="N" />');
            $('#health_application_noEmailGroup').css('display', 'block');
        }

        function onChangeNoEmailChkBox(){
            var $applicationEmailGroup = $('#health_application_emailGroup'),
                $applicationEmailField = $("#health_application_email");

            if ( $("#health_application_no_email").is(":checked") ) {
                $applicationEmailGroup.find('*').removeClass("has-success").removeClass("has-error");
                $applicationEmailGroup.find('.error-field').remove();

                $applicationEmailField.val('');
                $applicationEmailField.prop('required', false);
                $applicationEmailField.prop('disabled', true);

                $('#applicationForm_1').append('<input type="hidden" name="health_application_email" value="email@westfund.com.au" />');

            } else {
                $('input[type="hidden"][name="health_application_email"]').remove();

                $applicationEmailField.prop('required', true);
                $applicationEmailField.prop('disabled', false);

            }
        }

        if (meerkat.site.tracking.brandCode == 'wfdd') {
            onChangeNoEmailChkBox();
            $("#health_application_no_email").on("click.WFD",function() {onChangeNoEmailChkBox();});
        }

    },
    renderDeductionMessage: function() {

        var deductionMsg = meerkat.modules.healthPaymentStep.getSelectedFrequency() === 'annually' ? 'Your first payment will be debited within 48 hours.' :
                (meerkat.modules.healthPaymentStep.getSelectedFrequency() === 'monthly' ?
                'Your first payment will be debited within 48 hours and this will be a pro-rata amount for the remainder of the month. Your regular premium will be deducted from your nominated account on the 1st of every month.' :
                'Your first payment will be debited within 48 hours and this will be a pro-rata amount until next Thursday. Your regular premium will be deducted from your nominated account on a Thursday.');

        healthFunds_WFD.$paymentFrequency.closest('div.row-content').find('.deduction-message').remove();
        healthFunds_WFD.$paymentFrequency.closest('div.row-content').find('.statement').before('<p class="deduction-message" style="margin-top:1em; color: #ff5f5f">'+ deductionMsg +'</p>');
    },
    unset: function() {

        healthFunds_WFD.$paymentFrequency.off('change.WFD');

        if (meerkat.site.tracking.brandCode == 'wfdd') {
            healthFunds_WFD.$paymentFrequency.off('change.WFD');
            $('input[type="hidden"][name="health_application_optInEmail"]').remove();
            $('#health_application_optInEmail-group').css('display', 'block');
        }

        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), false);
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), false);
        $('#health_application_no_email').off('click.WFD');

        meerkat.modules.healthFunds._reset();

        <%--dependant definition off--%>
        meerkat.modules.healthFunds._dependants(false);

        healthFunds_WFD.$paymentFrequency.closest('div.row-content').find('p.deduction-message, p.statement').remove();

        <%--Previous fund--%>
        $('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').removeAttr('maxlength');

        <%--Authority Off--%>
        meerkat.modules.healthFunds._previousfund_authority(false);

        <%--Age requirements for applicants (back to default)--%>
        healthFunds_WFD.$_dobPrimary.addRule('youngestDOB', dob_health_application_primary_dob.ageMin, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
        healthFunds_WFD.$_dobPartner.addRule('youngestDOB', dob_health_application_partner_dob.ageMin, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

        delete healthFunds_WFD.$_dobPrimary;
        delete healthFunds_WFD.$_dobPartner;

        $('#wfd_partnerrel').hide();
    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />