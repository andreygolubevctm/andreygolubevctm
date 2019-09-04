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
    $primaryABDPolicyStartDateContainer,
    $partnerABDPolicyStartDateContainer,
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
    partnerHasABDPolicy,
    $primaryABDPolicyStartDateApplicationContainer,
    $primaryABDPolicyStartDateApplication,
    $partnerABDPolicyStartDateApplicationContainer,
    $partnerABDPolicyStartDateApplication;

  var state = {
    hasPartner: false,
    primary: {
      hasCurrentCover: false,
      hasABDPolicy: false,
      age: 17
    },
    partner: {
      hasCurrentCover: false,
      hasABDPolicy: false,
      age: 17
    }
  };

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

      $primaryABDPolicyStartDateContainer = $('#primary_abd_start_date');
      $partnerABDPolicyStartDateContainer = $('#partner_abd_start_date');

      $primaryABDPolicyStartDate = $('#health_healthCover_primary_abdPolicyStart');
      $partnerABDPolicyStartDate = $('#health_healthCover_partner_abdPolicyStart');

      $primaryABDPolicyStartDateApplicationContainer = $('#health_previousfund_primary_abd_start_date');
      $partnerABDPolicyStartDateApplicationContainer = $('#health_previousfund_partner_abd_start_date');

      $primaryABDPolicyStartDateApplication = $('#health_previousfund_primary_abdPolicyStart');
      $partnerABDPolicyStartDateApplication = $('#health_previousfund_partner_abdPolicyStart');

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
      state.hasPartner = meerkat.modules.healthChoices.hasPartner();
      $abdEligibilityContent.addClass('hidden');
    });

    $primaryCurrentCover.change( function(e) {
      state.primary.hasCurrentCover = e.target.value === 'Y';
      showABDQuestion(true);
      showABDStartDate(true);
      setApplicationDetails();
      showABDSupportContent();
    });

    $partnerCurrentCover.change( function(e) {
      state.partner.hasCurrentCover = e.target.value === 'Y';
      showABDQuestion(false);
      showABDStartDate(false);
      setApplicationDetails();
      showABDSupportContent();
    });

    $healthPrimaryDateofBirth.change(function(e) {
      state.primary.age = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion(true);
      setApplicationDetails();
      showABDStartDate(true);
      showABDSupportContent();
    });

    $healthPartnerDateofBirth.change(function(e) {
      state.partner.age = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion();
      setApplicationDetails();
      showABDStartDate(false);
      showABDSupportContent();
    });

    $primaryABDQuestionApplication.change(function(e) {
      state.primary.hasABDPolicy = e.target.value === 'Y';
      $primaryABDQuestion.filter('[value="' + e.target.value + '"]').click();
      $primaryABDPolicyStartDateApplicationContainer.toggleClass('hidden', !state.primary.hasABDPolicy);
      setApplicationDetails();
    });

    $partnerABDQuestionApplication.change(function(e) {
      state.partner.hasABDPolicy = e.target.value === 'Y';
      $partnerABDQuestion.filter('[value="' + e.target.value + '"]').click();
      $partnerABDPolicyStartDateApplicationContainer.toggleClass('hidden', !state.partner.hasABDPolicy);
      setApplicationDetails();
      showABDSupportContent();
    });

    $primaryABDQuestion.change(function(e) {
      state.primary.hasABDPolicy = e.target.value === 'Y';
      $primaryABDQuestionApplication.filter('[value="' + e.target.value + '"]').click();
      showABDStartDate(true);
      showABDSupportContent();
    });

    $partnerABDQuestion.change(function(e) {
      state.partner.hasABDPolicy = e.target.value === 'Y';
      $partnerABDQuestionApplication.filter('[value="' + e.target.value + '"]').click();
      showABDStartDate();
      showABDSupportContent();
    });

    $primaryABDPolicyStartDate.change(function(e) {
      var dates= e.target.value.split('/');
      var date = dates[1] + '/' + dates[0] + '/' + dates[2];

      $primaryABDPolicyStartDateApplication.datepicker("setDate", new Date(date));
    });

    $partnerABDPolicyStartDate.change(function(e) {
      var dates= e.target.value.split('/');
      var date = dates[1] + '/' + dates[0] + '/' + dates[2];

      $partnerABDPolicyStartDateApplication.datepicker("setDate", new Date(date));
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
      if (state.primary.age >= 18 && state.primary.age < 45 && primaryHasCurrentCover) {
        $primaryABDQuestionContainer.removeClass('hidden');
      }
      else {
        $primaryABDQuestionContainer.addClass('hidden');
      }
    }
    else {
      if (state.partner.age >= 18 && state.partner.age < 45 && partnerHasCurrentCover) {
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
      (state.primary.hasCurrentCover && state.primary.hasABDPolicy && state.primary.age >= 18 && state.primary.age < 45) ? $primaryABDPolicyStartDateContainer.removeClass('hidden') : $primaryABDPolicyStartDateContainer.addClass('hidden');
    }
    else {
      (state.partner.hasCurrentCover && state.partner.hasABDPolicy && state.partner.age >= 18 && state.partner.age < 45) ? $partnerABDPolicyStartDateContainer.removeClass('hidden') : $partnerABDPolicyStartDateContainer.addClass('hidden');
    }
  }

  function showABDSupportContent() {
    $abdEligibilityContent.addClass('hidden');

    if(!hasPartner) {
      if ( state.primary.hasABDPolicy ) {
        $abdEligibilityContent.filter('#single_has_abd_policy').removeClass('hidden');
      }
      else if ( inRange(18, 30, state.primary.age) ) {
        console.log('here');
        $abdEligibilityContent.filter('#single_18_to_30').removeClass('hidden');
      }
    }
    else {
      if(state.primary.hasCurrentCover || state.partner.hasCurrentCover) {
        if ( state.primary.hasABDPolicy && state.partner.hasABDPolicy && state.primary.hasCurrentCover && state.partner.hasCurrentCover ) {
          $abdEligibilityContent.filter('#couple_both_has_abd').removeClass('hidden');
        }
        else if ( ( state.primary.hasABDPolicy && !state.partner.hasABDPolicy ) || ( !state.primary.hasABDPolicy && state.partner.hasABDPolicy ) ) {
          $abdEligibilityContent.filter('#couple_one_has_abd').removeClass('hidden');
        }
        else {
          if ( inRange(18, 30, state.primary.age) && inRange(18, 30, state.partner.age) && state.primary.hasCurrentCover && state.partner.hasCurrentCover) {
            $abdEligibilityContent.filter('#couple_both_18_to_30').removeClass('hidden');
          }
          else if ( (inRange(18, 30, state.primary.age) && !inRange(18, 30, state.partner.age)) || (!inRange(18, 30, state.primary.age) && inRange(18, 30, state.partner.age))  ) {
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