;(function ($, undefined) {

  var meerkat = window.meerkat,
      $healthPrimaryDateofBirth,
      $healthPartnerDateofBirth,
      $primaryCurrentCover,
      $primaryABDQuestion,
      $partnerCurrentCover,
      $partnerABDQuestion,
      $primaryABDPolicyStartDate,
      $partnerABDPolicyStartDate;

  function init() {
    $(document).ready(function() {
      $healthPrimaryDateofBirth = $('#health_healthCover_primary_dob');
      $healthPartnerDateofBirth = $('#health_healthCover_partner_dob');
      $primaryCurrentCover = $('[name=health_healthCover_primary_cover]');
      $partnerCurrentCover = $('[name=health_healthCover_partner_cover]');
      $primaryABDQuestion = $('#health_previousfund_primaryhasABD');
      $partnerABDQuestion = $('#health_previousfund_partnerhasABD');
      $primaryABDPolicyStartDate = $('#primary_abd_start_date');
      $partnerABDPolicyStartDate = $('#partner_abd_start_date');
      _setupListeners();
    });
  }

  function calculateABDValue() {
    
  }

  function isABD() {

  }

  function isRABD() {

  }

  function _setupListeners() {
    $primaryCurrentCover.change( function() {
      showABDQuestion(true);
    });

    $partnerCurrentCover.change( function() {
      showABDQuestion();
    });

    $healthPrimaryDateofBirth.change(function() {
      showABDQuestion(true);
    });

    $healthPartnerDateofBirth.change(function() {
      showABDQuestion();
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
      calculateABDValue: calculateABDValue,
      isABD: isABD,
      isRABD: isRABD
  });

})(jQuery);