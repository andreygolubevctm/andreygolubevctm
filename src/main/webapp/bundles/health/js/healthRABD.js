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
    $abdFilterQuestion,
    $abdFilterRadios,
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

      $primaryABDQuestion = $('[name=health_healthCover_primary_abd]');
      $partnerABDQuestion = $('[name=health_healthCover_partner_abd]');

      $primaryABDQuestionApplication = $('[name=health_previousfund_primary_abd]');
      $partnerABDQuestionApplication = $('[name=health_previousfund_partner_abd]');
      
      $abdDetailsApplication = $('.abd-details-application');
      $abdDetailsApplicationSingleNoPHI = $('.abd-details-application-single');
      $abdDetailsApplicationCouple = $('.abd-details-application-couple');

      $primaryABDPolicyStartDate = $('#primary_abd_start_date');
      $partnerABDPolicyStartDate = $('#partner_abd_start_date');

      $abdFilterQuestion = $('#abd_filter');

      $abdFilterRadios = $('[name=health_healthCover_filter_abd]');

      $dialogTriggers = $('.dialogPop');

      $abdEligibilityContent = $('.abd-support-text');

      $journeyType = $('[name=health_situation_healthCvr]');

      _setupListeners();
    });
  }

  function isABD(isApplicationPage) {
    var isSingle = meerkat.modules.healthAboutYou.getSituation().indexOf("S") > -1;
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
    $journeyType.change( function(e) {
      hasPartner = meerkat.modules.healthChoices.hasSpouse();
      $abdEligibilityContent.addClass('hidden');
    });

    $primaryCurrentCover.change( function(e) {
      primaryHasCurrentCover = e.target.value === 'Y';
      showABDQuestion(true);
      setApplicationDetails();
    });

    $partnerCurrentCover.change( function(e) {
      partnerHasCurrentCover = e.target.value === 'Y';
      showABDQuestion();
      setApplicationDetails();
    });

    $healthPrimaryDateofBirth.change(function(e) {
      primaryAge = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion(true);
      setApplicationDetails();
      
      if ($primaryABDQuestion.filter(':checked').length > 0) {
        showABDSupportContent();
      }
    });

    $healthPartnerDateofBirth.change(function(e) {
      partnerAge = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion();
      setApplicationDetails();
    });

    $primaryABDQuestionApplication.change(function() {
      setApplicationDetails();
    });

    $partnerABDQuestionApplication.change(function() {
      setApplicationDetails();
      if ( $partnerABDQuestion.filter(':checked').length > 0) {
        showABDSupportContent();
      }
    });

    $primaryABDQuestion.change(function(e) {
      primaryHasABDPolicy = e.target.value === 'Y';
      showABDStartDate(true);
      showABDSupportContent();
      showABDFilterQuestion();
    });

    $partnerABDQuestion.change(function(e) {
      partnerHasABDPolicy = e.target.value === 'Y';
      showABDStartDate();
      showABDSupportContent();
      showABDFilterQuestion();
    });

    $abdFilterRadios.change( function(e) {
      var unsure = e.target.value === 'N' || e.target.value === 'U';
      var modalContent = $abdFilterQuestion.find('.abdFilterModalContent').html();

      if (unsure) {
        meerkat.modules.dialogs.show({
          title: null,
          htmlContent: modalContent,
          className: '',
          buttons: [{
            label: "Ok",
            className: 'btn-next',
            closeWindow: true
          }],
          onClose: function(modalId) {
            var abdFilterValue = $('[name=health_healthCover_filter_abd_final]').filter(":checked").val();
            var target = $abdFilterRadios.filter('[value="' + abdFilterValue+ '"]');
            var currentSelection = $abdFilterRadios.filter(':checked');
            currentSelection.parent('label').removeClass('active');
            currentSelection.prop('checked', false);
            target.prop('checked', true);
            target.parent('label').addClass('active');
            $('.filter-no-response-scripting').addClass('hidden');
          },
          onOpen: function() {
            $('[name=health_healthCover_filter_abd_final]').change( function(e) {
              if (e.target.value === 'N') {
                $('.filter-no-response-scripting').removeClass('hidden');
              }
              else {
                $('.filter-no-response-scripting').addClass('hidden');
              }
            });
          }
        });
      }
    });


    $dialogTriggers.click(showABDModal);

    meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, hideResultsFilter);
  }

  function showABDFilterQuestion() {
    if ( primaryHasABDPolicy || partnerHasABDPolicy ) {
      $abdFilterQuestion.removeClass('hidden');
    }
    else {
      $abdFilterQuestion.addClass('hidden');
    }
  }

  function hideResultsFilter() {
    var rabdResult = Results.getReturnedResults().find(function(result) { return result.custom.reform.yad === "R" && result.premium.monthly.abd > 0; });
    $('.results-filters-abd').toggleClass('hidden', rabdResult === undefined);

    var simplesShowRABD = filterAbdProducts();

    if(isRABD) {
      $('#rabd-reminder').toggleClass('hidden', !simplesShowRABD || rabdResult === undefined);
      $('#rabd-reminder-no-results').toggleClass('hidden', !simplesShowRABD || rabdResult !== undefined);
      $('.simples-dialogue-142').toggleClass('hidden', !simplesShowRABD || rabdResult !== undefined);
    }
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

  function setApplicationDetails() {
    var selectedProduct = Results.getSelectedProduct();
    if(!selectedProduct || selectedProduct.premium.monthly.abd === 0) { return; }

    var isSingle = meerkat.modules.healthAboutYou.getSituation().indexOf("S") > -1;
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

  function showPaymentsScript() {
    var selectedProduct = Results.getSelectedProduct();
    var isSingle = meerkat.modules.healthAboutYou.getSituation().indexOf("S") > -1;
    var primaryHasABD = $primaryABDQuestionApplication.filter(":checked").val() === 'Y';
    var partnerHasABD = $primaryABDQuestionApplication.filter(":checked").val() === 'Y';

    if(selectedProduct.custom.reform.yad !== 'R') {
      if(isSingle && primaryHasABD) {
        return true;
      }

      if(!isSingle && (primaryHasABD || partnerHasABD)) {
        return true;
      }
    }

    return false;
  }

  function filterAbdProducts() {
    if(!$abdFilterRadios || $abdFilterRadios.filter(':checked') === undefined) {
      return false;
    }

    return $abdFilterRadios.filter(':checked').val() === "Y";
  }

  meerkat.modules.register('healthRABD', {
      init: init,
      isABD: isABD,
      isRABD: isRABD,
      setApplicationDetails: setApplicationDetails,
      showPaymentsScript: showPaymentsScript,
      filterAbdProducts: filterAbdProducts
  });

})(jQuery);