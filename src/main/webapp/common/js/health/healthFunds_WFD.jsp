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
        <%--calendar for start cover--%>
	    if(_.has(meerkat.modules,'healthCoverStartDate')) {
		    meerkat.modules.healthCoverStartDate.setCoverStartRange(0, 29);
	    } else {
		    meerkat.modules.healthPaymentStep.setCoverStartRange(0, 29);
	    }

        <%--dependant definition--%>
        var dependantsString = 'As a member of Westfund, your children aged between 21-24 are entitled to stay on your cover at no extra charge if they are a full time or part-time student at School, college or University TAFE institution or serving an Apprenticeship or Traineeship.<br />Westfund also offer adult dependant coverage at an additional premium for your children aged between 21-24(inclusive) who are not receiving full-time or part-time education at a school, college or university.';

        <%-- Dependant's Age and message --%>
        var familyCoverType = meerkat.modules.healthChoices.returnCoverCode();
        if (familyCoverType === 'EF' || familyCoverType === 'ESP') {
            meerkat.modules.healthFunds._dependants('This product provides cover for your children aged between 21-24(inclusive) who are not receiving full-time or part-time education at a school, college or university at an additional premium.');
            meerkat.modules.healthDependants.updateConfig({extendedFamilyMinAge: healthFunds_WFD.extendedFamilyMinAge, extendedFamilyMaxAge: healthFunds_WFD.extendedFamilyMaxAge});
        } else {
            meerkat.modules.healthFunds._dependants(dependantsString);
        }

        <%--schoolgroups and defacto--%>
        meerkat.modules.healthDependants.updateConfig({showSchoolFields:true, 'schoolMinAge': healthFunds_WFD.schoolMinAge, 'schoolMaxAge': healthFunds_WFD.schoolMaxAge, showSchoolIdField:true });

        <%--Adding a statement--%>
        var msg = 'Please note that the LHC amount quoted is an estimate and will be confirmed once Westfund has verified your details.';
        healthFunds_WFD.$paymentFrequency.closest('div.row-content').append('<p class="statement" style="margin-top:1em">' + msg + '</p>');

        <%--Previous fund--%>
        $('#health_previousfund_primary_memberID, #health_previousfund_partner_memberID').attr('maxlength', '10');

        <%--Authority--%>
        meerkat.modules.healthFunds._previousfund_authority(true);

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':false });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':false });

        <%--claims account--%>
        meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
        meerkat.modules.healthCreditCard.render();

        healthFunds_WFD.$paymentFrequency.on('change.WFD', function renderPaymentDaysFrequency(){
            healthFunds_WFD.renderDeductionMessage();
        });

        <%--allow weekend selection from the datepicker--%>
        healthFunds_WFD.$paymentStartDate.datepicker('setDaysOfWeekDisabled', '');

        <%--Age requirements for applicants--%>
        <%--primary--%>
        healthFunds_WFD.$_dobPrimary = $('#health_application_primary_dob');
        <%--partner--%>
        healthFunds_WFD.$_dobPartner = $('#health_application_partner_dob');

        healthFunds_WFD.$_dobPrimary.addRule('youngestDOB', 18, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
        healthFunds_WFD.$_dobPartner.addRule('youngestDOB', 18, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

        <%-- Load join dec into label--%>
        healthFunds_WFD.joinDecLabelHtml = $('#health_declaration + label').html();
        healthFunds_WFD.ajaxJoinDec = $.ajax({
            url: '/' + meerkat.site.urls.context + 'health/provider/content/get.json?providerId=7&providerContentTypeCode=JDO',
            type: 'GET',
            async: true,
            dataType: 'html',
            timeout: 20000,
            cache: true,
            success: function(htmlResult) {
                if(typeof htmlResult === 'string')
                    htmlResult = JSON.parse(htmlResult);

                $('#health_declaration + label').html(htmlResult.providerContentText);
                $('a#joinDeclarationDialog_link').remove();
            },
            error: function(obj,txt) {
            }
        });

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

    },
    renderDeductionMessage: function() {
        var deductionMsg = meerkat.modules.healthPaymentStep.getSelectedFrequency() === 'monthly' ?
                'Your first payment will be debited within 48 hours and this will be a pro-rata amount for the remainder of the month. Your regular premium will be deducted from your nominated account on the 1st of every month.' :
                'Your first payment will be debited within 48 hours and this will be a pro-rata amount until next Thursday. Your regular premium will be deducted from your nominated account on a Thursday.';

        healthFunds_WFD.$paymentFrequency.closest('div.row-content').find('.deduction-message').remove();
        healthFunds_WFD.$paymentFrequency.closest('div.row-content').find('.statement').before('<p class="deduction-message" style="margin-top:1em">'+ deductionMsg +'</p>');
    },
    unset: function() {
        healthFunds_WFD.$paymentFrequency.off('change.WFD');
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), false);
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), false);

        meerkat.modules.healthFunds._reset();

        <%--dependant definition off--%>
        meerkat.modules.healthFunds._dependants(false);

        <%--reset the join dec to original general label and abort AJAX request--%>
        if (healthFunds_WFD.ajaxJoinDec) {
            healthFunds_WFD.ajaxJoinDec.abort();
        }
        $('#health_declaration + label').html(healthFunds_WFD.joinDecLabelHtml);

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