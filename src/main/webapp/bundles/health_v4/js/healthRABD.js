;(function ($, undefined) {

  var meerkat = window.meerkat,
      $healthPrimaryDateofBirth,
      $healthPartnerDateofBirth,
      $primaryCurrentCover,
      $primaryCurrentCoverApplication,
      $primaryABDQuestion,
      $partnerCurrentCover,
      $partnerCurrentCoverApplication,
      $partnerABDQuestion,
      $abdDetailsApplication,
      $abdDetailsApplicationSingleNoPHI,
      $abdDetailsApplicationCouple;
      $partnerABDQuestion,
      $primaryABDPolicyStartDate,
      $partnerABDPolicyStartDate;

  function init() {
    $(document).ready(function() {
      $healthPrimaryDateofBirth = $('#health_healthCover_primary_dob');
      $healthPartnerDateofBirth = $('#health_healthCover_partner_dob');

      $primaryCurrentCover = $('[name=health_healthCover_primary_cover]');
      $primaryCurrentCoverApplication = $('[name=health_application_primary_cover]');

      $partnerCurrentCover = $('[name=health_healthCover_partner_cover]');
      $partnerCurrentCoverApplication = $('[name=health_application_partner_cover]');

      $primaryABDQuestion = $('#health_previousfund_primaryhasABD');
      $partnerABDQuestion = $('#health_previousfund_partnerhasABD');

      $primaryABDQuestionApplication = $('[name=health_previousfund_primary_abd]');
      $partnerABDQuestionApplication = $('[name=health_previousfund_partner_abd]');
      
      $abdDetailsApplication = $('.abd-details-application');
      $abdDetailsApplicationSingleNoPHI = $('.abd-details-application-single');
      $abdDetailsApplicationCouple = $('.abd-details-application-couple');

      $primaryABDPolicyStartDate = $('#primary_abd_start_date');
      $partnerABDPolicyStartDate = $('#partner_abd_start_date');
      _setupListeners();
    });
  }

  function isABD(isApplicationPage) {
    var isSingle = meerkat.modules.healthSituation.getSituation().indexOf("S") > -1;
    var primaryHasCover = $primaryCurrentCover.filter(":checked").val() === 'Y';
    var partnerHasCover = $partnerCurrentCover.filter(":checked").val() === 'Y';

    var primaryHasABD = isApplicationPage ? $primaryABDQuestionApplication.filter(":checked").val() === 'Y' : $primaryABDQuestion.filter(":checked").val() === 'Y';
    var partnerHasABD = isApplicationPage ? $primaryABDQuestionApplication.filter(":checked").val() === 'Y' : $partnerABDQuestion.filter(":checked").val() === 'Y';

    if(!primaryHasCover && (isSingle || !partnerHasCover)) {
      return true;
    }

    if(!primaryHasABD && (isSingle || !partnerHasABD)) {
      return true;
    }

    return false;
  }

  function isRABD() {
    return !this.isABD();
  }

  function _setupListeners() {
    $primaryCurrentCover.change( function() {
      showABDQuestion(true);
      setApplicationDetails();
    });

    $partnerCurrentCover.change( function() {
      showABDQuestion();
      setApplicationDetails();
    });

    $healthPrimaryDateofBirth.change(function() {
      showABDQuestion(true);
      setApplicationDetails();
    });

    $healthPartnerDateofBirth.change(function() {
      showABDQuestion();
      setApplicationDetails();
    });

    $primaryABDQuestionApplication.change(function() {
      setApplicationDetails();
    });

    $partnerABDQuestionApplication.change(function() {
      setApplicationDetails();
    });

    $primaryABDQuestion.change(function() {
      showABDPolicyStartDate(true);
    });

    $partnerABDQuestion.change(function() {
      showABDPolicyStartDate();
    });
  }

  function showABDQuestion(isPrimary) {
    var hasCover = false;
    var age = 17;

    if(isPrimary) {
      hasCover = $primaryCurrentCover.filter(":checked").val() === 'Y';
      age = meerkat.modules.age.returnAge($healthPrimaryDateofBirth.val(), true);

      if (age >= 18 && age <= 45 && hasCover) {
        $primaryABDQuestion.removeClass('hidden');
      }
      else {
        $primaryABDQuestion.addClass('hidden');
      }
    }
    else {
      hasCover = $partnerCurrentCover.filter(":checked").val() === 'Y';
      age = meerkat.modules.age.returnAge($healthPartnerDateofBirth.val(), true);

      if (age >= 18 && age <= 45 && hasCover) {
        $partnerABDQuestion.removeClass('hidden');
      }
      else {
        $partnerABDQuestion.addClass('hidden');
      }
    }
  }

  function setApplicationDetails() {
    var selectedProduct = Results.getSelectedProduct();
    if(!selectedProduct || selectedProduct.premium.monthly.abd === 0) { return; }

    var isSingle = meerkat.modules.healthSituation.getSituation().indexOf("S") > -1;
    var primaryHasCover = $primaryCurrentCoverApplication.filter(":checked").val() === 'Y';

    $abdDetailsApplicationSingleNoPHI.toggleClass('hidden', primaryHasCover || !isSingle);
    $abdDetailsApplicationCouple.toggleClass('hidden', isSingle);
    $abdDetailsApplication.toggleClass('hidden', !isSingle);
    
    if(isABD(true)) {
      
      $abdDetailsApplication.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will confirm the exact discount you are eligible for.');
      $abdDetailsApplicationSingleNoPHI.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will confirm the exact discount you are eligible for.');
      $abdDetailsApplicationCouple.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will confirm the exact discount you are eligible for.');
    }else{
            
      var primaryHasABD = $primaryABDQuestionApplication.filter(":checked").val() === 'Y';
      var partnerHasABD = $primaryABDQuestionApplication.filter(":checked").val() === 'Y';

      if(primaryHasABD && ( !isSingle || partnerHasABD )) {
        $abdDetailsApplication.html('The price indicated in the summary above <strong>includes a retained age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
        $abdDetailsApplicationSingleNoPHI.html('The price indicated in the summary above <strong>includes a retained age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
        $abdDetailsApplicationCouple.html('The price indicated in the summary above <strong>includes a retained age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
      }else {
        $abdDetailsApplication.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
        $abdDetailsApplicationSingleNoPHI.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
        $abdDetailsApplicationCouple.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
      }
    }
  }
  
  function showABDPolicyStartDate(isPrimary) {
    var hasABD = false;

    if (isPrimary) {
      hasABD = $primaryABDQuestion.find(":checked").val() === 'Y';

      if (hasABD) {
        console.log('here');
        $primaryABDPolicyStartDate.removeClass('hidden');
      }
      else {
        $primaryABDPolicyStartDate.addClass('hidden');
      }
    }
    else {
      hasABD = $partnerABDQuestion.find(":checked").val() === 'Y';

      if (hasABD) {
        $partnerABDPolicyStartDate.removeClass('hidden');
      }
      else {
        $partnerABDPolicyStartDate.addClass('hidden');
      }
    }
  }

  meerkat.modules.register('healthRABD', {
      init: init,
      isABD: isABD,
      isRABD: isRABD,
      setApplicationDetails: setApplicationDetails
  });

})(jQuery);