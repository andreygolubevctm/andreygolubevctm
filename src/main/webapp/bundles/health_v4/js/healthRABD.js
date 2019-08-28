;(function ($, undefined) {

  var meerkat = window.meerkat,
      $healthPrimaryDateofBirth,
      $healthPartnerDateofBirth,
      $primaryCurrentCover,
      $primaryABDQuestion,
      $partnerCurrentCover,
      $partnerABDQuestion;

  function init() {
    $(document).ready(function() {
      $healthPrimaryDateofBirth = $('#health_healthCover_primary_dob');
      $healthPartnerDateofBirth = $('#health_healthCover_partner_dob');
      $primaryCurrentCover = $('[name=health_healthCover_primary_cover]');
      $partnerCurrentCover = $('[name=health_healthCover_partner_cover]');
      $primaryABDQuestion = $('#health_previousfund_primaryhasABD');
      $partnerABDQuestion = $('#health_previousfund_partnerhasABD');
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

  meerkat.modules.register('healthRABD', {
      init: init,
      calculateABDValue: calculateABDValue,
      isABD: isABD,
      isRABD: isRABD
  });

})(jQuery);