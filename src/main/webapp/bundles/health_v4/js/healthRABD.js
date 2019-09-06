;(function ($, undefined) {

  var meerkat = window.meerkat,
    meerkatEvents = meerkat.modules.events,
    elements,
    state;

  function init() {
    $(document).ready(function() {
      state = {
        hasPartner: false,
        primary: {
          hasCurrentCover: false,
          hasABDPolicy: false,
          age: 0
        },
        partner: {
          hasCurrentCover: false,
          hasABDPolicy: false,
          age: 0
        }
      };

      elements = {
        primary: {
          dob: $('#health_healthCover_primary_dob'),
          currentCover: $('.health-cover_details input[type="radio"]'),
          abdQuestionContainer: $('.primaryHasABD'),
          abdQuestion: $('.health-cover_details_abd_current input[type="radio"]'),
          abdPolicyStartDateContainer: $('.health-cover_details_abd_start'),
          abdPolicyStartDate: $('#health_healthCover_primary_abdPolicyStart'),
          abdPolicyStartDateApplication: $('#health_previousfund_primary_abdPolicyStart')
        },
        partner: {
          dob: $('#health_healthCover_partner_dob'),
          currentCover: $('.health-cover_details-partner input[type="radio"]'),
          abdQuestionContainer: $('.partnerHasABD'),
          abdQuestion: $('.health-cover_details_partner_abd_current input[type="radio"]'),
          abdPolicyStartDateContainer: $('.health-cover_details_partner_abd_start'),
          abdPolicyStartDate: $('#health_healthCover_partner_abdPolicyStart'),
          abdPolicyStartDateApplication: $('#health_previousfund_partner_abdPolicyStart')
        },
        abdDetailsApplication: $('.abd-details-application'),
        abdDetailsApplicationSingleNoPHI: $('.abd-details-application-single'),
        abdDetailsApplicationCouple: $('.abd-details-application-couple'),
        dialogTriggers: $('.dialogPop'),
        abdEligibilityContent: $('.abd-support-text')
      };

      _setupListeners('primary');
      _setupListeners('partner');

      if(hasCover('primary')) {
        state.primary.age = meerkat.modules.age.returnAge(elements.primary.dob.val(), true);
        showABDQuestion('primary');
        showABDStartDate('primary');
        showABDSupportContent();
      }

      if(hasCover('partner')) {
        state.partner.age = meerkat.modules.age.returnAge(elements.partner.dob.val(), true);
        showABDQuestion('partner');
        showABDStartDate('partner');
        showABDSupportContent();
      }

      meerkat.messaging.subscribe(meerkatEvents.healthSituation.SITUATION_CHANGED, function() {
        state.hasPartner = meerkat.modules.healthChoices.hasPartner();
        showABDSupportContent();
      });
    });
  }

  function isABD(isApplicationPage) {

    if(!state.primary.hasCurrentCover && (!state.hasPartner || !state.partner.hasCurrentCover)) {
      return true;
    }

    if(!state.primary.hasABDPolicy && (!state.hasPartner || !state.partner.hasABDPolicy)) {
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

  function _setupListeners(type) {
    elements[type].currentCover.change(function(e) {
      state[type].hasCurrentCover = e.target.value === 'Y';
      showABDQuestion(type);
      showABDStartDate(type);
      setApplicationDetails();
      showABDSupportContent();
    });

    elements[type].dob.change(function(e) {
      state[type].age = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion(type);
      setApplicationDetails();
      showABDStartDate(type);
      showABDSupportContent();
    });

    elements[type].abdQuestion.change(function(e) {
      state[type].hasABDPolicy = e.target.value === 'Y';
      elements[type].abdQuestion.filter('[value="' + e.target.value + '"]').click();
      elements[type].abdPolicyStartDateContainer.toggleClass('hidden', !state[type].hasABDPolicy);
      showABDSupportContent();
      setApplicationDetails();
    });

    elements[type].abdPolicyStartDate.change(function(e) {
      var dates= e.target.value.split('/');
      var date = dates[1] + '/' + dates[0] + '/' + dates[2];

      elements[type].abdPolicyStartDateApplication.datepicker("setDate", new Date(date));
    });

    elements.dialogTriggers.click(showABDModal);
    meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, hideResultsFilter);
  }

  function hasCover(type) {
    return elements[type].currentCover.filter(':checked').val() === 'Y';
  }

  function hasAbdPolicy(type) {
    return elements[type].abdQuestion.filter(':checked').val() === 'Y';
  }

  function hideResultsFilter() {
    var rabdResult = Results.getReturnedResults().find(function(result) { return result.custom.reform.yad === "R" && result.premium.monthly.abd > 0; });
    $('.results-filters-abd').toggleClass('hidden', rabdResult === undefined);
  }

  function showABDQuestion(type) {
    var showQuestion = state[type].age >=18 && state[type].age <= 45 && hasCover(type);
    elements[type].abdQuestionContainer.toggleClass('hidden', !showQuestion);
  }

  function showABDStartDate(type) {
    var toDisplay = hasAbdPolicy(type) && hasCover(type);
    elements[type].abdPolicyStartDateContainer.toggleClass('hidden', !toDisplay);
  }

  function setApplicationDetails() {
    var selectedProduct = Results.getSelectedProduct();
    if(!selectedProduct || selectedProduct.premium.monthly.abd === 0) { return; }

    var isSingle =  !state.hasPartner;
    var primaryHasCover = elements.primary.currentCover.filter(":checked").val() === 'Y';

    elements.abdDetailsApplicationSingleNoPHI.toggleClass('hidden', primaryHasCover || !isSingle);
    elements.abdDetailsApplicationCouple.toggleClass('hidden', isSingle);
    elements.abdDetailsApplication.toggleClass('hidden', !isSingle);

    if(isABD(true)) {

      elements.abdDetailsApplication.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will confirm the exact discount you are eligible for.');
      elements.abdDetailsApplicationSingleNoPHI.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will confirm the exact discount you are eligible for.');
      elements.abdDetailsApplicationCouple.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will confirm the exact discount you are eligible for.');
    }else{

      var primaryHasABD = elements.primary.abdQuestion.filter(":checked").val() === 'Y';
      var partnerHasABD = elements.partner.abdQuestion.filter(":checked").val() === 'Y';

      if(primaryHasABD && ( !isSingle || partnerHasABD )) {
        elements.abdDetailsApplication.html('The price indicated in the summary above <strong>includes a retained age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
        elements.abdDetailsApplicationSingleNoPHI.html('The price indicated in the summary above <strong>includes a retained age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
        elements.abdDetailsApplicationCouple.html('The price indicated in the summary above <strong>includes a retained age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
      }else {
        elements.abdDetailsApplication.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
        elements.abdDetailsApplicationSingleNoPHI.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
        elements.abdDetailsApplicationCouple.html('The price indicated in the summary above <strong>includes an age-based discount</strong> based on what you’ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.');
      }
    }
  }

  function showABDSupportContent() {
    elements.abdEligibilityContent.addClass('hidden');

    if(!state.hasPartner) {
      if ( hasAbdPolicy('primary') ) {
        elements.abdEligibilityContent.filter('#single_has_abd_policy').removeClass('hidden');
      }
      else if ( inRange(18,30,state.primary.age) ) {
        elements.abdEligibilityContent.filter('#single_18_to_30').removeClass('hidden');
      }
    }
    else {
      if (hasCover('primary') || hasCover('partner')) {
        if(hasAbdPolicy('primary') && hasAbdPolicy('partner') && hasCover('primary') && hasCover('partner')) {
          elements.abdEligibilityContent.filter('#couple_both_has_abd').removeClass('hidden');
        }
        else if ((hasAbdPolicy('primary') && ! hasAbdPolicy('partner')) || (!hasAbdPolicy('primary') && hasAbdPolicy('partner'))) {
          elements.abdEligibilityContent.filter('#couple_one_has_abd').removeClass('hidden');
        }
        else {
          if ( inRange(18,30,state.primary.age) && inRange(18,30,state.partner.age) && hasCover('primary') && hasCover('partner')) {
            elements.abdEligibilityContent.filter('#couple_both_18_to_30').removeClass('hidden');
          }
          else if ((inRange(18,30,state.primary.age) && !inRange(18,30,state.partner.age)) || (!inRange(18,30,state.primary.age) && inRange(18,30,state.partner.age))) {
            elements.abdEligibilityContent.filter('#couple_one_18_to_30').removeClass('hidden');
          }
        }
      }
    }
  }

  function showABDModal() {
    meerkat.modules.dialogs.show({
      title: $(this).attr("title"),
      htmlContent: $(this).attr("data-content"),
      className: $(this).attr("data-class")
    });
  }

  meerkat.modules.register('healthRABD', {
    init: init,
    isABD: isABD,
    isRABD: isRABD,
    setApplicationDetails: setApplicationDetails
  });

})(jQuery);