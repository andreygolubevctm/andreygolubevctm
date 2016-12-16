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
    $paymentType : $('#health_payment_details_type input'),
    $paymentFrequency : $('#health_payment_details_frequency'),
    $paymentStartDate: $("#health_payment_details_start"),
    set: function(){
        <%--calendar for start cover--%>
        meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);

        <%--dependant definition--%>
        meerkat.modules.healthFunds._dependants('As a member of Westfund all children aged up to 21 are covered on a family policy. Children aged between 21-24 are entitled to stay on your cover at no extra charge if they are a full time or part-time student at School, college or University TAFE institution or serving an Apprenticeship or Traineeship.');

        <%--schoolgroups and defacto--%>
        meerkat.modules.healthDependants.updateConfig({showSchoolFields:true, 'schoolMinAge':18, 'schoolMaxAge':24, showSchoolIdField:true });

        <%--Adding a statement--%>
        var msg = 'Please note that the LHC amount quoted is an estimate and will be confirmed once Westfund has verified your details.';
        $paymentFrequency.closest('div.row-content').append('<p class="statement" style="margin-top:1em">' + msg + '</p>');

        <%--fund Name's become optional--%>
        $('#health_previousfund_primary_fundName, #health_previousfund_partner_fundName').setRequired(false);

        <%--fund ID's become optional--%>
        $('#clientMemberID input[type=text], #partnerMemberID input[type=text]').setRequired(false);

        <%--Authority--%>
        meerkat.modules.healthFunds._previousfund_authority(true);

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

        <%--claims account--%>
        meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

        <%--credit card options--%>
        meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
        meerkat.modules.healthCreditCard.render();

        healthFunds_WFD.$paymentType.on('change.WFD', function renderPaymentDaysPaymentType(){
            healthFunds_WFD.renderPaymentDays();
        });

        healthFunds_WFD.$paymentFrequency.on('change.WFD', function renderPaymentDaysFrequency(){
            healthFunds_WFD.renderPaymentDays();
        });

        healthFunds_WFD.$paymentStartDate.on("changeDate.WFD", function renderPaymentDaysCalendar(e) {
            healthFunds_WFD.renderPaymentDays();
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

    },
    renderPaymentDays: function() {
        var deductionDate = meerkat.modules.dateUtils.returnDate($('#health_payment_details_start').val());
        var distance = 4 - deductionDate.getDay();
        if(distance < 2) { <%-- COB Tue cutoff to make Thu of same week for payment--%>
            distance += 7;
        }
        deductionDate.setDate(deductionDate.getDate() + distance);

        var day = deductionDate.getDate();
        var isTeen = (day > 10 && day < 20);
        if((day % 10) == 1 && !isTeen ) {
            day += "st";
        } else if((day % 10) == 2 && !isTeen ) {
            day += "nd";
        } else if((day % 10) == 3 && !isTeen ) {
            day += "rd";
        } else {
            day += "th";
        }

        var deductionText = 'Please note that your first or full payment (annual frequency) ' +
                'will be debited from your payment method on ' + meerkat.modules.dateUtils.dateValueLongFormat(deductionDate);

        $('.health_credit-card-details_policyDay-message').text( deductionText);
        $('.health_bank-details_policyDay-message').text(deductionText);

        var _dayString = meerkat.modules.numberUtils.leadingZero(deductionDate.getDate() );
        var _monthString = meerkat.modules.numberUtils.leadingZero(deductionDate.getMonth() + 1 );
        var deductionDateValue = deductionDate.getFullYear() +'-'+ _monthString +'-'+ _dayString;

        $('.health_payment_credit_details-policyDay option').val(deductionDateValue);
        $('.health_payment_bank_details-policyDay option').val(deductionDateValue);
    },
    unset: function() {
        healthFunds_WFD.$paymentType.off('change.WFD');
        healthFunds_WFD.$paymentFrequency.off('change.WFD');
        healthFunds_WFD.$paymentStartDate.off("changeDate.WFD");
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

        $paymentFrequency.closest('div.row-content').find('p.statement').remove();

        <%--fund Name's become mandaory (back to default)--%>
        $('#health_previousfund_primary_fundName').attr('required', 'required');
        $('#health_previousfund_partner_fundName').attr('required', 'required');

        <%--Authority Off--%>
        meerkat.modules.healthFunds._previousfund_authority(false);

        <%--Age requirements for applicants (back to default)--%>
        healthFunds_WFD.$_dobPrimary.addRule('youngestDOB', dob_health_application_primary_dob.ageMin, "primary person's age cannot be under " + dob_health_application_primary_dob.ageMin);
        healthFunds_WFD.$_dobPartner.addRule('youngestDOB', dob_health_application_partner_dob.ageMin, "partner's age cannot be under " + dob_health_application_partner_dob.ageMin);

        delete healthFunds_WFD.$_dobPrimary;
        delete healthFunds_WFD.$_dobPartner;
    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />