;(function ($, undefined) {

  var meerkat = window.meerkat,
    meerkatEvents = meerkat.modules.events,
    $healthPrimaryDateofBirth,
    $healthPartnerDateofBirth,
    $primaryCurrentCover,
    $primaryCurrentCoverApplication,
    $primaryABDQuestion,
    $partnerCurrentCover,
    $partnerCurrentCoverApplication,
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
      $primaryCurrentCoverApplication = $('[name=health_application_primary_cover]');

      $partnerCurrentCover = $('[name=health_healthCover_partner_cover]');
      $partnerCurrentCoverApplication = $('[name=health_application_partner_cover]');

      $primaryABDQuestionContainer = $('#health_healthCover_primaryhasABD');
      $partnerABDQuestionContainer = $('#health_healthCover_partnerhasABD');

      $primaryABDQuestion = $('[name=health_healthCover_primary_abd]');
      $partnerABDQuestion = $('[name=health_healthCover_partner_abd]');

      $primaryABDQuestionApplication = $('[name=health_previousfund_primary_abd]');
      $partnerABDQuestionApplication = $('[name=health_previousfund_partner_abd]');
      
      $abdDetailsApplication = $('.abd-details-application');
      $abdDetailsApplicationSingleNoPHI = $('.abd-details-application-single');
      $abdDetailsApplicationCouple = $('.abd-details-application-couple');

      $primaryABDPolicyStartDate = $('#primary_abd_start_date');
      $partnerABDPolicyStartDate = $('#partner_abd_start_date');

      $primaryABDPolicyStartDateApplication = $('#health_previousfund_primary_abd_start_date');
      $partnerABDPolicyStartDateApplication = $('#health_previousfund_partner_abd_start_date');


      $dialogTriggers = $('.dialogPop');

      $abdEligibilityContent = $('.abd-support-text');

      _setupListeners();
    });
  }

  function isABD(isApplicationPage) {

    if(!primaryHasCurrentCover && (!hasPartner || !partnerHasCurrentCover)) {
      return true;
    }

    if(!primaryHasABDPolicy && (!hasPartner || !partnerHasABDPolicy)) {
      return true;
    }

    return false;
  }

  function isRABD() {
    return !this.isABD();
  }

  function inRange(lowerBound, upperBound, value) {
    return value >= lowerBound && value <= upperBound;
  }

  function showABDModal() { 
    meerkat.modules.dialogs.show({
      title: $(this).attr("title"),
      htmlContent: $(this).attr("data-content"),
      className: $(this).attr("data-class")
    });
  }

  function _setupListeners() {
    meerkat.messaging.subscribe(meerkatEvents.healthSituation.SITUATION_CHANGED, function() {
      hasPartner = meerkat.modules.healthChoices.hasPartner();
      $abdEligibilityContent.addClass('hidden');
    });

    $primaryCurrentCover.change( function(e) {
      primaryHasCurrentCover = e.target.value === 'Y';
      showABDQuestion(true);
      showABDStartDate(true);
      setApplicationDetails();
      showABDSupportContent();
    });

    $partnerCurrentCover.change( function(e) {
      partnerHasCurrentCover = e.target.value === 'Y';
      showABDQuestion(false);
      showABDStartDate(false);
      setApplicationDetails();
      showABDSupportContent();
    });

    $healthPrimaryDateofBirth.change(function(e) {
      primaryAge = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion(true);
      setApplicationDetails();
      showABDStartDate(true);
      showABDSupportContent();
    });

    $healthPartnerDateofBirth.change(function(e) {
      partnerAge = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion();
      setApplicationDetails();
      showABDStartDate(false);
      showABDSupportContent();
    });

    $primaryABDQuestionApplication.change(function(e) {
      primaryHasABDPolicy = e.target.value === 'Y';
      $primaryABDQuestion.filter('[value="' + e.target.value + '"]').click();
      $primaryABDPolicyStartDateApplication.toggleClass('hidden', !primaryHasABDPolicy);
      setApplicationDetails();
    });

    $partnerABDQuestionApplication.change(function(e) {
      partnerHasABDPolicy = e.target.value === 'Y';
      $partnerABDQuestion.filter('[value="' + e.target.value + '"]').click();
      $partnerABDPolicyStartDateApplication.toggleClass('hidden', !partnerHasABDPolicy);
      setApplicationDetails();
      showABDSupportContent();
    });

    $primaryABDQuestion.change(function(e) {
      primaryHasABDPolicy = e.target.value === 'Y';
      $primaryABDQuestionApplication.filter('[value="' + e.target.value + '"]').click();
      showABDStartDate(true);
      showABDSupportContent();
    });

    $partnerABDQuestion.change(function(e) {
      partnerHasABDPolicy = e.target.value === 'Y';
      $partnerABDQuestionApplication.filter('[value="' + e.target.value + '"]').click();
      showABDStartDate();
      showABDSupportContent();
    });

    $dialogTriggers.click(showABDModal);

    meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, hideResultsFilter);
  }

  function hideResultsFilter() {
    var rabdResult = Results.getReturnedResults().find(function(result) { return result.custom.reform.yad === "R" && result.premium.monthly.abd > 0; });
    $('.results-filters-abd').toggleClass('hidden', rabdResult === undefined);
  }

  function showABDQuestion(isPrimary) {
    if (isPrimary) {
      if (primaryAge >= 18 && primaryAge < 45 && primaryHasCurrentCover) {
        $primaryABDQuestionContainer.removeClass('hidden');
      }
      else {
        $primaryABDQuestionContainer.addClass('hidden');
      }
    }
    else {
      if (partnerAge >= 18 && partnerAge < 45 && partnerHasCurrentCover) {
        $partnerABDQuestionContainer.removeClass('hidden');
      }
      else {
        $partnerABDQuestionContainer.addClass('hidden');
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

  function showABDStartDate(isPrimary) {
    if (isPrimary) {
      (primaryHasCurrentCover && primaryHasABDPolicy && primaryAge >= 18 && primaryAge < 45) ? $primaryABDPolicyStartDate.removeClass('hidden') : $primaryABDPolicyStartDate.addClass('hidden');
    }
    else {
      (partnerHasCurrentCover && partnerHasABDPolicy && partnerAge >= 18 && partnerAge < 45) ? $partnerABDPolicyStartDate.removeClass('hidden') : $partnerABDPolicyStartDate.addClass('hidden');
    }
  }

  function showABDSupportContent() {
    $abdEligibilityContent.addClass('hidden');

    if(!hasPartner) {
      if ( primaryHasABDPolicy ) {
        $abdEligibilityContent.filter('#single_has_abd_policy').removeClass('hidden');
      }
      else if ( inRange(18, 30, primaryAge) ) {
        console.log('here');
        $abdEligibilityContent.filter('#single_18_to_30').removeClass('hidden');
      }
    }
    else {
      if(primaryHasCurrentCover || partnerHasCurrentCover) {
        if ( primaryHasABDPolicy && partnerHasABDPolicy && primaryHasCurrentCover && partnerHasCurrentCover ) {
          $abdEligibilityContent.filter('#couple_both_has_abd').removeClass('hidden');
        }
        else if ( ( primaryHasABDPolicy && !partnerHasABDPolicy ) || ( !primaryHasABDPolicy && partnerHasABDPolicy ) ) {
          $abdEligibilityContent.filter('#couple_one_has_abd').removeClass('hidden');
        }
        else {
          if ( inRange(18, 30, primaryAge) && inRange(18, 30, partnerAge) && primaryHasCurrentCover && partnerHasCurrentCover) {
            $abdEligibilityContent.filter('#couple_both_18_to_30').removeClass('hidden');
          }
          else if ( (inRange(18, 30, primaryAge) && !inRange(18, 30, partnerAge)) || (!inRange(18, 30, primaryAge) && inRange(18, 30, partnerAge))  ) {
            $abdEligibilityContent.filter('#couple_one_18_to_30').removeClass('hidden');
          }
        }
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