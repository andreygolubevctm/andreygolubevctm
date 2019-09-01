;(function ($, undefined) {

  var meerkat = window.meerkat,
    $healthPrimaryDateofBirth,
    $healthPartnerDateofBirth,
    $primaryCurrentCover,
    $primaryABDQuestion,
    $partnerCurrentCover,
    $partnerABDQuestion,
    $primaryABDPolicyStartDate,
    $partnerABDPolicyStartDate,
    $dialogTriggers,
    $journeyType,
    $abdEligibilityContent,
    hasPartner,
    primaryAge,
    primaryHasCurrentCover,
    primaryHasABDPolicy,
    partnerAge,
    partnerHasCurrentCover,
    partnerHasABDPolicy;

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

      $dialogTriggers = $('.dialogPop');

      $abdEligibilityContent = $('.abd-support-text');

      $journeyType = $('[name=health_situation_healthCvr]');

      _setupListeners();
    });
  }

  function inRange(lowerBound, upperBound, value) {
    return value >= lowerBound && value <= upperBound;
  }

  function calculateABDValue() {

  }

  function isABD() {

  }

  function isRABD() {

  }

  function showABDModal() { 
    meerkat.modules.dialogs.show({
      title: $(this).attr("title"),
      htmlContent: $(this).attr("data-content"),
      className: $(this).attr("data-class")
    });
  }

  function _setupListeners() {
    $journeyType.change( function(e) {
      hasPartner = meerkat.modules.healthChoices.hasPartner();
      $abdEligibilityContent.addClass('hidden');
    });

    $primaryCurrentCover.change( function(e) {
      primaryHasCurrentCover = e.target.value === 'Y';
      showABDQuestion(true);
    });

    $partnerCurrentCover.change( function(e) {
      partnerHasCurrentCover = e.target.value === 'Y';
      showABDQuestion();
    });

    $healthPrimaryDateofBirth.change(function(e) {
      primaryAge = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion(true);
      if ($primaryABDQuestion.filter(':checked').length > 0) {
        showABDSupportContent();
      }
    });

    $healthPartnerDateofBirth.change(function(e) {
      partnerAge = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion();
      if ( $partnerABDQuestion.filter(':checked').length > 0) {
        showABDSupportContent();
      }
    });

    $primaryABDQuestion.change(function(e) {
      primaryHasABDPolicy = e.target.value === 'Y';
      showABDStartDate(true);
      showABDSupportContent();
    });

    $partnerABDQuestion.change(function(e) {
      partnerHasABDPolicy = e.target.value === 'Y';
      showABDStartDate();
      showABDSupportContent();
    });

    $dialogTriggers.click(showABDModal);
  }

  function showABDQuestion(isPrimary) {
    if (isPrimary) {
      if (primaryAge >= 18 && primaryAge <= 45 && primaryHasCurrentCover) {
        $primaryABDQuestion.removeClass('hidden');
      }
      else {
        $primaryABDQuestion.addClass('hidden');
      }
    }
    else {
      if (partnerAge >= 18 && partnerAge <= 45 && partnerHasCurrentCover) {
        $partnerABDQuestion.removeClass('hidden');
      }
      else {
        $partnerABDQuestion.addClass('hidden');
      }
    }
  }

  function showABDStartDate(isPrimary) {
    if (isPrimary) {
      primaryHasABDPolicy ? $primaryABDPolicyStartDate.removeClass('hidden') : $primaryABDPolicyStartDate.addClass('hidden');
    }
    else {
      partnerHasABDPolicy ? $partnerABDPolicyStartDate.removeClass('hidden') : $partnerABDPolicyStartDate.addClass('hidden');
    }
  }

  function showABDSupportContent() {
    $abdEligibilityContent.addClass('hidden');

    if(!hasPartner) {
      if ( primaryHasABDPolicy ) {
        $abdEligibilityContent.filter('#single_has_abd_policy').removeClass('hidden');
      }
      else if ( primaryAge >= 18 && primaryAge < 30 ) {
        $abdEligibilityContent.filter('#single_18_to_30').removeClass('hidden');
      }
    }
    else {
      if ( primaryHasABDPolicy && partnerHasABDPolicy ) {
        $abdEligibilityContent.filter('#couple_both_has_abd').removeClass('hidden');
      }
      else if ( ( primaryHasABDPolicy && !partnerHasABDPolicy ) || ( !primaryHasABDPolicy && partnerHasABDPolicy ) ) {
        $abdEligibilityContent.filter('#couple_one_has_abd').removeClass('hidden');
      }
      else {
        if ( inRange(18, 30, primaryAge) && inRange(18, 30, partnerAge)) {
          $abdEligibilityContent.filter('#couple_both_18_to_30').removeClass('hidden');
        }
        else if ( (inRange(18, 30, primaryAge) && !inRange(18, 30, partnerAge)) || (!inRange(18, 30, primaryAge) && inRange(18, 30, partnerAge))  ) {
          $abdEligibilityContent.filter('#couple_one_18_to_30').removeClass('hidden');
        }
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