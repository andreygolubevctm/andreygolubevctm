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
  $paymentTypeContainer: $('div.health-payment_details-type').siblings('div.fieldrow_legend'),
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
    var list = '<select class="form-control"><option value="">Please choose...</option>';
    list += '<option value="ACP">Australian College of Phys. Ed</option>';
    list += '<option value="ACT">Australian College of Theology</option>';
    list += '<option value="ACTH">ACT High Schools</option>';
    list += '<option value="ACU">Australian Catholic University</option>';
    list += '<option value="ADA">Australian Defence Force Academy</option>';
    list += '<option value="AFTR">Australian Film, TV &amp; Radio School</option>';
    list += '<option value="AIR">Air Academy, Brit Aerospace Flight Trng</option>';
    list += '<option value="AMC">Austalian Maritime College</option>';
    list += '<option value="ANU">Australian National University</option>';
    list += '<option value="AVO">Avondale College</option>';
    list += '<option value="BC">Batchelor College</option>';
    list += '<option value="BU">Bond University</option>';
    list += '<option value="CQU">Central Queensland Universty</option>';
    list += '<option value="CSU">Charles Sturt University</option>';
    list += '<option value="CUT">Curtin University of Technology</option>';
    list += '<option value="DU">Deakin University</option>';
    list += '<option value="ECU">Edith Cowan University</option>';
    list += '<option value="EDUC">Education Institute Default</option>';
    list += '<option value="FU">Flinders University of SA</option>';
    list += '<option value="GC">Gatton College</option>';
    list += '<option value="GU">Griffith University</option>';
    list += '<option value="JCUNQ">James Cook University of Northern QLD</option>';
    list += '<option value="KVBVC">KvB College of Visual Communication</option>';
    list += '<option value="LTU">La Trobe University</option>';
    list += '<option value="MAQ">Maquarie University</option>';
    list += '<option value="MMCM">Melba Memorial Conservatorium of Music</option>';
    list += '<option value="MTC">Moore Theological College</option>';
    list += '<option value="MU">Monash University</option>';
    list += '<option value="MURUN">Murdoch University</option>';
    list += '<option value="NAISD">Natn\'l Aborign\'l &amp; Islander Skills Dev Ass.</option>';
    list += '<option value="NDUA">Notre Dame University Australia</option>';
    list += '<option value="NIDA">National Institute of Dramatic Art</option>';
    list += '<option value="NSWH">NSW High Schools</option>';
    list += '<option value="NSWT">NSW TAFE</option>';
    list += '<option value="NT">Northern Territory High Schools</option>';
    list += '<option value="NTT">NT TAFE</option>';
    list += '<option value="NTU">Northern Territory University</option>';
    list += '<option value="OLA">Open Learnng Australia</option>';
    list += '<option value="OTHER">Other Registered Tertiary Institutions</option>';
    list += '<option value="PSC">Photography Studies College</option>';
    list += '<option value="QCM">Queensland Conservatorium of Music</option>';
    list += '<option value="QCU">Queensland College of Art</option>';
    list += '<option value="QLDH">QLD High Schools</option>';
    list += '<option value="QLDT">QLD TAFE</option>';
    list += '<option value="QUT">Queensland University of Technology</option>';
    list += '<option value="RMIT">Royal Melbourne Institute of Techn.</option>';
    list += '<option value="SA">South Australian High Schools</option>';
    list += '<option value="SAT">SA TAFE</option>';
    list += '<option value="SCD">Sydney College of Divinity</option>';
    list += '<option value="SCM">Sydney Conservatorium of Music</option>';
    list += '<option value="SCU">Southern Cross University</option>';
    list += '<option value="SCUC">Sunshine Coast University College</option>';
    list += '<option value="SIT">Swinburn Institute of Technology</option>';
    list += '<option value="SJC">St Johns College</option>';
    list += '<option value="SYD">University of Sydney</option>';
    list += '<option value="TAS">TAS High Schools</option>';
    list += '<option value="TT">TAS TAFE</option>';
    list += '<option value="UA">University of Adelaide</option>';
    list += '<option value="UB">University of Ballarat</option>';
    list += '<option value="UC">University of Canberra</option>';
    list += '<option value="UM">University of Melbourne</option>';
    list += '<option value="UN">University of Newcastle</option>';
    list += '<option value="UNC">University of Capricornia Rockhampton</option>';
    list += '<option value="UNE">University of New England</option>';
    list += '<option value="UNSW">University Of New South Wales</option>';
    list += '<option value="UQ">University of Queensland</option>';
    list += '<option value="USA">University of South Australia</option>';
    list += '<option value="USQ">University of Southern Queensland</option>';
    list += '<option value="UT">University of Tasmania</option>';
    list += '<option value="UTS">University of Technlogy Sydney</option>';
    list += '<option value="UW">University of Wollongong</option>';
    list += '<option value="UWA">University of Western Australia</option>';
    list += '<option value="UWS">University of Western Sydney</option>';
    list += '<option value="VCAH">VIC College of Agriculture &amp; Horticulture</option>';
    list += '<option value="VIC">Victorian High Schools</option>';
    list += '<option value="VICT">VIC TAFE</option>';
    list += '<option value="VU">Victoria University</option>';
    list += '<option value="WA">Western Australia-High Schools</option>';
    list += '<option value="WAT">WA TAFE</option>';
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
      healthFunds_AHM.$paymentTypeContainer.text('*AHM will apply a 0.25% surcharge for all credit card transactions').slideDown();
    }
    else {
      meerkat.modules.healthPaymentDate.populateFuturePaymentDays($('#health_payment_details_start').val(), 0, false, true);
      healthFunds_AHM.$paymentTypeContainer.slideUp();
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

    healthFunds_AHM.$paymentTypeContainer.text('').slideUp();

    healthFunds_AHM.$paymentType.off('change.AHM');
    healthFunds_AHM.$paymentFrequency.off('change.AHM');
    healthFunds_AHM.$paymentStartDate.off("changeDate.AHM");

    <%--Payment gateway--%>
    meerkat.modules.paymentGateway.reset();
  }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />