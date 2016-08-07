<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
TUH
=======================
--%>

var healthFunds_QTU = {
    $paymentStartDate: $("#health_payment_details_start"),
    set: function(){

        <c:set var="html">
            <c:set var="fieldXpath" value="health/application/qtu" />
            <form_v2:fieldset id="qtu_eligibility" legend="Eligibility" className="primary">
                <form_v2:row fieldXpath="${fieldXpath}/eligibility" label="Are you or any of your family a current or former union member?"  className="qtumain">
                    <field_v2:general_select type="healthNavQuestion_eligibility" xpath="${fieldXpath}/eligibility" title="Eligibility reason" required="true" initialText="Please select" disableErrorContainer="${true}" />
                </form_v2:row>

                <form_v2:row label="Which union are you a member of?" id="unionId">
                    <field_v2:general_select xpath="${fieldXpath}/union" title="Union" required="true" initialText="&nbsp;" />
                </form_v2:row>
            </form_v2:fieldset>
        </c:set>

        $('#health_application').prepend('<c:out value="${html}" escapeXml="false" />');

        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

        <%--allow weekend selection from the datepicker--%>
        healthFunds_QTU.$paymentStartDate.datepicker('setDaysOfWeekDisabled', '');

        var healthFundText = "By joining HCF, you authorise HCF to contact your previous fund in order to obtain a clearance certificate. This will mean that, where applicable, you don’t need to re-serve any hospital waiting periods you served with your previous fund.";
        $('#clientMemberID').parent().after('<span class="qtu-clearance-certificate">' + healthFundText + '</span>');
        $('#partnerMemberID').parent().after('<span class="qtu-clearance-certificate">' + healthFundText + '</span>');
    },
    unset: function(){
        $('.qtu-clearance-certificate').remove();
    }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />