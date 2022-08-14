<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
AHM
=======================
--%>

var healthFunds_AHM = {
  $paymentType : $('#health_payment_details_type input'),
  $paymentFrequency : $('#health_payment_details_frequency'),
  $paymentStartDate: $("#health_payment_details_start"),
  $paymentTypeContainer: $('#simples-dialogue-222'),
  schoolMinAge: 21,
  schoolMaxAge: 24,
  extendedFamilyMinAge: 21,
  extendedFamilyMaxAge: 25,
  healthDependantMaxAge: 25,
  set: function(){

    <%--Dependants--%>
    var dependantsString = 'ahm can offer adult dependant coverage at an additional premium for a child of the Principal Member or their Partner, who is not married or living in a de facto relationship, has reached the age of 21 but is under the age of 25, and is not a Student Dependant. ahm call this +21';

    if(meerkat.site.content.callCentreNumber !== ''){
      dependantsString += ' so please call '+meerkat.site.content.brandDisplayName+' on <span class=\"callCentreNumber\">'+meerkat.site.content.callCentreNumber+"</span>";
      if(meerkat.site.liveChat.enabled) dependantsString += ' or chat to our consultants online';
      dependantsString += ' to discuss your health cover needs.';
    }else{
      dependantsString += '.';
    }

    <%-- Dependant's Age and message --%>
    var familyCoverType = meerkat.modules.healthChoices.returnCoverCode();
    if (familyCoverType === 'EF' || familyCoverType === 'ESP') {
        meerkat.modules.healthFunds._dependants('This product provides cover for Adult Dependants at an additional premium for a child of the Principal Member or their Partner, who is not married or living in a de facto relationship, has reached the age of 21 but is under the age of 25, and is not a Student Dependant');
        meerkat.modules.healthDependants.updateConfig({extendedFamilyMinAge: healthFunds_AHM.extendedFamilyMinAge, extendedFamilyMaxAge: healthFunds_AHM.extendedFamilyMaxAge});
    } else {
        meerkat.modules.healthFunds._dependants(dependantsString);
    }

    <%--change age of dependants and school--%>
    meerkat.modules.healthDependants.setMaxAge(healthFunds_AHM.healthDependantMaxAge);
    <%--schoolgroups and defacto--%>
    meerkat.modules.healthDependants.updateConfig({ showSchoolFields:true, useSchoolDropdownMenu: true, schoolIdMaxLength: 10, 'schoolMinAge':healthFunds_AHM.schoolMinAge, 'schoolMaxAge': healthFunds_AHM.schoolMaxAge, showSchoolIdField:true, 'schoolIdRequired':true, showSchoolCommencementField:true, 'schoolDateRequired':true });

    <%--School list--%>
    var list = '<select class="form-control">';
    list += meerkat.modules.healthDependants.getEducationalInstitutionsOptions();
    list += '</select>';
    
    $('.health_dependant_details_schoolGroup .row-content').each(function(i) {
      var name = $(this).find('input').attr('name');
      var id = $(this).find('input').attr('id');
      $(this).append(list);
      $(this).find('select').attr('name', name).attr('id', id+'select').setRequired(true, 'Please select dependant '+(i+1)+'\'s school');
    });
    <%--$('.health_dependant_details_schoolDateGroup input').mask('99/99/9999', {placeholder: 'DD/MM/YYYY'});--%>
    <%--Change the Name of School label--%>
    healthFunds_AHM.tmpSchoolLabel = $('.health_dependant_details_schoolGroup .control-label').html();
    $('.health_dependant_details_schoolGroup .control-label').html('Tertiary Institution this dependant is attending');
    $('.health_dependant_details_schoolGroup .help_icon').hide();

    <%--Previous fund--%>
    $('#health_previousfund_primary_authority').setRequired(true, 'AHM require authorisation to contact your previous fund');
    $('#health_previousfund_partner_authority').setRequired(true, 'AHM require authorisation to contact your partner\'s previous fund');
    <%--Authority--%>
      meerkat.modules.healthFunds._previousfund_authority(true);

    <%--credit card & bank account frequency & day frequency--%>
    meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
    meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });

    <%--claims account--%>
    meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
    meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

    <%--credit card options--%>
    meerkat.modules.healthCreditCard.setCreditCardConfig({ 'visa':true, 'mc':true, 'amex':false, 'diners':false });
    meerkat.modules.healthCreditCard.render();

    <%-- show health payment day script--%>
    if (meerkat.site.isCallCentreUser) {
      meerkat.modules.healthApplicationDynamicScripting.togglePaymentDayScript(true);
    }

    <%--selections for payment date--%>
      meerkat.modules.healthFunds.setPayments({
          'min':0,
          'max':28,
          'weekends':true,
          'maxDay' : 28
      });

    healthFunds_AHM.$paymentType.on('change.AHM', function populateFuturePaymentDaysPaymentType(){
      healthFunds_AHM.populateFuturePaymentDays();
    });

    healthFunds_AHM.$paymentFrequency.on('change.AHM', function populateFuturePaymentDaysFrequency(){
      healthFunds_AHM.populateFuturePaymentDays();
    });

    healthFunds_AHM.$paymentStartDate.on("changeDate.AHM", function populateFuturePaymentDaysCalendar(e) {
      healthFunds_AHM.populateFuturePaymentDays();
    });

    meerkat.modules.paymentGateway.setup({
      "paymentEngine" : meerkat.modules.healthPaymentGatewayWestpac,
      "name" : 'health_payment_gateway',
      "src" : '/' + meerkat.site.urls.context + 'ajax/html/health_paymentgateway.jsp',
      "handledType" :  {
        "credit" : true,
        "bank" : false
      },
	  "updateValidationSelectors" : meerkat.modules.healthPaymentStep.updateValidationSelectorsPaymentGateway,
	  "resetValidationSelectors" : meerkat.modules.healthPaymentStep.resetValidationSelectorsPaymentGateway,
      "paymentTypeSelector" : $("input[name='health_payment_details_type']:checked"),
       "getSelectedPaymentMethod" :  meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
    });

    <%--fund offset check--%>
    meerkat.modules.healthFundTimeOffset.onInitialise({
        weekends: true,
        coverStartRange: {
            min: 0,
            max: 28
        },
        renderPaymentDaysCb: healthFunds_AHM.populateFuturePaymentDays
    });
  },
  populateFuturePaymentDays: function() {
    if(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc'){
      meerkat.modules.healthPaymentDate.populateFuturePaymentDays($('#health_payment_details_start').val(), 0, false, false);
      healthFunds_AHM.$paymentTypeContainer.removeClass('hidden');
    }
    else {
      meerkat.modules.healthPaymentDate.populateFuturePaymentDays($('#health_payment_details_start').val(), 0, false, true);
      healthFunds_AHM.$paymentTypeContainer.addClass('hidden');
    }
  },
  unset: function(){
      meerkat.modules.healthFunds._reset();
    <%--Dependants--%>
      meerkat.modules.healthFunds._dependants(false);

    <%--School list--%>
    $('.health_dependant_details_schoolGroup select').remove();
    <%--Change the Name of School label--%>
    $('.health_dependant_details_schoolGroup .control-label').html(healthFunds_AHM.tmpSchoolLabel);
    delete healthFunds_AHM.tmpSchoolLabel;
    $('.health_dependant_details_schoolGroup .help_icon').show();

    <%--Previous fund--%>
    $('#health_previousfund_primary_authority, #health_previousfund_partner_authority').setRequired(false);

    <%--Authority off--%>
      meerkat.modules.healthFunds._previousfund_authority(false);

    <%--credit card options--%>
    meerkat.modules.healthCreditCard.resetConfig();
    meerkat.modules.healthCreditCard.render();

    <%--selections for payment date--%>
    meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_bank_details-policyDay'), false);
    meerkat.modules.healthPaymentDay.paymentDaysRender( $('.health_payment_credit_details-policyDay'), false);

    healthFunds_AHM.$paymentTypeContainer.addClass('hidden');

    healthFunds_AHM.$paymentType.off('change.AHM');
    healthFunds_AHM.$paymentFrequency.off('change.AHM');
    healthFunds_AHM.$paymentStartDate.off("changeDate.AHM");

    <%--Payment gateway--%>
    meerkat.modules.paymentGateway.reset();
  }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />