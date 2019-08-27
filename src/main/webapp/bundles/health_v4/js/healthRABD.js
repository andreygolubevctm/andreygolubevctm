;(function ($, undefined) {

  var meerkat = window.meerkat,
      $healthPrimaryDateofBirth,
      $healthSecondaryDateofBirth,
      $primaryCurrentCover,
      $primaryABDQuestion,
      $secondaryCurrentCover;

  function init() {
    $(document).ready(function() {
      $healthPrimaryDateofBirth = $('#health_healthCover_primary_dob');
      $healthSecondaryDateofBirth = $('#health_healthCover_partner_dob');
      $primaryCurrentCover = $('[name=health_healthCover_primary_cover]');
      $primaryABDQuestion = $('.primaryHasABD');
      shouldABDQuestionShow();
    });
  }

  function calculateABDValue() {
    
  }

  function isABD() {

  }

  function isRABD() {

  }

  function shouldABDQuestionShow() {
    var hasCover = false;
    var age = 18;

    $primaryCurrentCover.change( function(e) {
      hasCover = e.target.value;
      showABDQuestion(age, hasCover);
    });

    $healthPrimaryDateofBirth.change(function(e) {
      age = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion(age, hasCover);
    });
  }

  function showABDQuestion(age, hasCover) {
    if (age >= 18 && age <= 45 && hasCover === 'Y') {
      $primaryABDQuestion.removeClass('hidden');
    }
    else {
      $primaryABDQuestion.addClass('hidden');
    }
  }

  meerkat.modules.register('healthRABD', {
      init: init,
      calculateABDValue: calculateABDValue,
      isABD: isABD,
      isRABD: isRABD
  });

})(jQuery);