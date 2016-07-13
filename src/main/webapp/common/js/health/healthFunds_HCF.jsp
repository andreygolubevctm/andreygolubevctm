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
    $paymentStartDate: $("#health_payment_details_start"),
    set: function(){
        <%--credit card & bank account frequency & day frequency--%>
        meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

        <%--allow weekend selection from the datepicker--%>
        healthFunds_HCF.$paymentStartDate.datepicker('setDaysOfWeekDisabled', '');

        var healthFundText = "By joining HCF, you authorise HCF to contact your previous fund in order to obtain a clearance certificate. This will mean that, where applicable, you don’t need to re-serve any hospital waiting periods you served with your previous fund.";
        $('#clientMemberID').parent().after('<span class="hcf-clearance-certificate">' + healthFundText + '</span>');
        $('#partnerMemberID').parent().after('<span class="hcf-clearance-certificate">' + healthFundText + '</span>');
  },
  unset: function(){
      $('.hcf-clearance-certificate').remove();
  }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />