<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
HCF (HCF is usually setting the default values)
=======================
--%>

var healthFunds_HCF = {
    $paymentType : $('#health_payment_details_type input'),
    $paymentFrequency : $('#health_payment_details_frequency'),
    $paymentStartDate: $("#health_payment_details_start"),
	$claimsAccountOptin: $('#health_payment_bank_claims'),
    $paymentBankDayGroupLabel: $('.health_payment_bank-details_policyDay-group label'),
    $paymentCreditDayGroupLabel: $('.health_payment_credit-details_policyDay-group label'),
    set: function(){

        <%-- Dependants --%>
        meerkat.modules.healthFunds._dependants('This policy provides cover for your children aged less than 22 years plus students studying full time between the ages of 22 and 24. You can still obtain cover for your adult child outside these criteria by applying for a separate singles policy');
        <%-- unsure if something like this is required?  -     meerkat.modules.healthDependants.updateConfig({showFullTimeField:true, showSchoolFields:false, 'schoolMinAge':21, 'schoolMaxAge':25 }); --%>

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

        <%--allow weekend selection from the datepicker--%>
        meerkat.modules.healthFunds.setPayments({ 'min':2, 'max':29, 'weekends':true, 'countFrom':'today', 'maxDay':27 });

        <%--fund offset check--%>
        meerkat.modules.healthFundTimeOffset.onInitialise({
            weekends: true,
            coverStartRange: {
                min: 0,
                max: 90
            },
            renderPaymentDaysCb: healthFunds_HCF.renderPaymentDay
        });

        var healthFundText = "By joining HCF, you authorise HCF to contact your previous fund in order to obtain a clearance certificate. This will mean that, where applicable, you don’t need to re-serve any hospital waiting periods you served with your previous fund.";
        $('#clientMemberID').parent().after('<span class="hcf-clearance-certificate">' + healthFundText + '</span>');
        $('#partnerMemberID').parent().after('<span class="hcf-clearance-certificate">' + healthFundText + '</span>');

		<%-- Unset the refund optin radio buttons --%>
		healthFunds_HCF.$claimsAccountOptin.find("input:checked").each(function(){
		  $(this).prop("checked",null).trigger("change");
		});

        healthFunds_HCF.$paymentType.on('change.HCF', function renderPaymentDayPaymentType(){
            healthFunds_HCF.renderPaymentDay();
        });

        healthFunds_HCF.$paymentFrequency.on('change.HCF', function renderPaymentDayFrequency(){
            healthFunds_HCF.renderPaymentDay();
        });

        <%--update policy day label--%>
        healthFunds_HCF.$paymentBankDayGroupLabel.text('What day would you like your first and regular payment deducted?');
    },
    renderPaymentDay: function(){
        var _html = meerkat.modules.healthPaymentDay.paymentDays( healthFunds_HCF.$paymentStartDate.val() );
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), _html);
        meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), _html);
    },
    unset: function(){

        meerkat.modules.healthFunds._dependants(false);
        meerkat.modules.healthDependants.resetConfig();

        <%-- unsure if this is required too -    meerkat.modules.healthFunds._reset();  --%>

        $('.hcf-clearance-certificate').remove();

        healthFunds_HCF.$paymentType.off("changeDate.HCF");
        healthFunds_HCF.$paymentFrequency.off("changeDate.HCF");
        healthFunds_HCF.$paymentStartDate.off("changeDate.HCF");

        <%--reset policy day label--%>
        healthFunds_HCF.$paymentBankDayGroupLabel.text('What day would you like your payment deducted?');
    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />