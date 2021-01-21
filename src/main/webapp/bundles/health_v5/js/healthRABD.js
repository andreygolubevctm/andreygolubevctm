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
          dobPreResults: $('#health_healthCover_primary_dob'),
          dob: $('#health_application_primary_dob'),
          currentlyHaveAnyKindOfCoverPreResults: $('input[name=health_healthCover_primary_cover]'),
          currentCover: $('input[type="radio"][name="health_application_primary_cover"]'),
          abdQuestionContainer: $('.primaryHasABD'),
          abdQuestion: $('.health-cover_details_abd_current input[type="radio"]'),
          abdPolicyStartDateContainer: $('.health-cover_details_abd_start'),
          abdPolicyStartDate: $('#health_healthCover_primary_abdPolicyStart'),
          abdPolicyStartDateApplication: $('#health_previousfund_primary_abdPolicyStart')
        },
        partner: {
          dobPreResults: $('#health_healthCover_partner_dob'),
          dob: $('#health_application_partner_dob'),
          currentlyHaveAnyKindOfCoverPreResults: $('input[name=health_healthCover_partner_cover]'),
          currentCover: $('input[type="radio"][name="health_application_partner_cover"]'),
          abdQuestionContainer: $('.partnerHasABD'),
          abdQuestion: $('.health-cover_details_partner_abd_current input[type="radio"]'),
          abdPolicyStartDateContainer: $('.health-cover_details_partner_abd_start'),
          abdPolicyStartDate: $('#health_healthCover_partner_abdPolicyStart'),
          abdPolicyStartDateApplication: $('#health_previousfund_partner_abdPolicyStart')
        },
        abdDetailsApplicationSingle: $('.abd-details-application-single'),
        abdDetailsApplicationSingleNoPHI: $('.abd-details-application-single-no-phi'),
        abdDetailsApplicationCouple: $('.abd-details-application-couple'),
        abdDetailsApplicationCoupleNoPHI: $('.abd-details-application-couple-no-phi'),
        dialogTriggers: $('.dialogPop'),
        abdEligibilityContent: $('.abd-support-text')
      };

      _setupListeners('primary');
      _setupListeners('partner');
      elements.dialogTriggers.click(showABDModal);
      meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, hideResultsFilter);

      state.primary.hasCurrentCover = elements['primary'].currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'Y';
      state.partner.hasCurrentCover = elements['partner'].currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'Y';

      if (state.primary.hasCurrentCover) {
        state.primary.age = meerkat.modules.age.returnAge(elements.primary.dob.val(), true);
        state.primary.hasABDPolicy = elements.primary.abdQuestion.filter(':checked').val() === 'Y';
        showABDQuestion('primary');
        showABDStartDate('primary');
        showABDSupportContent();
      }

      if (state.partner.hasCurrentCover) {
        state.partner.age = meerkat.modules.age.returnAge(elements.partner.dob.val(), true);
        state.partner.hasABDPolicy = elements.partner.abdQuestion.filter(':checked').val() === 'Y';
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

  function isABD() {

    if (!state.primary.hasCurrentCover && (!state.hasPartner || !state.partner.hasCurrentCover)) {
      return true;
    }

    if (!hasAbdPolicy('primary') && (!state.hasPartner || !hasAbdPolicy('partner'))) {
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
    elements[type].currentlyHaveAnyKindOfCoverPreResults.change(function(e) {
      state[type].hasCurrentCover = e.target.value === 'Y';
      showABDQuestion(type);
      showABDStartDate(type);
      setApplicationDetails();
      showABDSupportContent();
    });

    elements[type].currentCover.change(function(e) {
      state[type].hasCurrentCover = e.target.value === 'Y';
      showABDQuestion(type);
      showABDStartDate(type);
      setApplicationDetails();
      showABDSupportContent();
    });

    elements[type].dobPreResults.change(function(e) {
      state[type].age = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion(type);
      setApplicationDetails();
      showABDStartDate(type);
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
  }

  function hasAbdPolicy(type) {
    var showAbdQuestion = eligibleForAlreadyHavingABD(type);
    return showAbdQuestion && state[type].hasABDPolicy;
  }

  function eligibleForAlreadyHavingABD(type) {
    return inRange(18,44, state[type].age) && state[type].hasCurrentCover && meerkat.modules.age.isBornAfterFirstOfApril1989(elements[type].dob.val());
  }

  function hideResultsFilter() {
    var rabdResult = Results.getReturnedResults().find(function(result) { return result.custom.reform.yad === "R" && result.premium.monthly.abd > 0; });
    $('.results-filters-abd').toggleClass('hidden', rabdResult === undefined);
  }

  function showABDQuestion(type) {
    var showQuestion = eligibleForAlreadyHavingABD(type);
    elements[type].abdQuestionContainer.toggleClass('hidden', !showQuestion);
  }

  function showABDStartDate(type) {
    elements[type].abdPolicyStartDateContainer.toggleClass('hidden', !hasAbdPolicy(type));
  }

  function setApplicationDetails() {
    var selectedProduct = Results.getSelectedProduct();
    if(!selectedProduct || selectedProduct.premium.monthly.abd === 0) {
      elements.abdDetailsApplicationSingle.html('');
      elements.abdDetailsApplicationSingleNoPHI.html('');
      elements.abdDetailsApplicationCouple.html('');
      elements.abdDetailsApplicationCoupleNoPHI.html('');
      return;
    }

    var isSingle = !state.hasPartner;
    var primaryHasCover = state.primary.hasCurrentCover;
    var partnerHasCover = state.partner.hasCurrentCover;
    var primaryHasABD = hasAbdPolicy('primary');
    var partnerHasABD = hasAbdPolicy('partner');
    var partnerInABDRange = inRange(18, 29, state.partner.age);
    var primaryInABDRange = inRange(18, 29, state.primary.age);

    elements.abdDetailsApplicationSingleNoPHI.toggleClass('hidden', primaryHasCover || !isSingle);
    elements.abdDetailsApplicationSingle.toggleClass('hidden', !isSingle || (isSingle && !primaryHasCover));

    var abdDetailsApplicationCouple = false;
    var abdDetailsApplicationCoupleRabdNaForPartner = false;
    var abdDetailsApplicationCouplePartnerHasRabd = false;
    var abdDetailsApplicationCoupleNoPHI = false;

    if (!isSingle && (primaryInABDRange || partnerInABDRange)) {
      if (!primaryHasCover && !partnerHasCover) {
        abdDetailsApplicationCoupleNoPHI = true;  // show feedback under do you have cover
      } else if ((!partnerInABDRange || !partnerHasCover) && (primaryHasCover && primaryHasABD)) { // partner RABD Question wont be visible
        abdDetailsApplicationCoupleRabdNaForPartner = true;
      } else if (partnerInABDRange && partnerHasCover) {  // show feedback under RABD question for partner
        abdDetailsApplicationCouplePartnerHasRabd = true;
      } else {
        abdDetailsApplicationCouple = true;  // show feedback under do you have cover
      }
    }

    elements.abdDetailsApplicationCouple.toggleClass('hidden', !abdDetailsApplicationCouplePartnerHasRabd);
    elements.abdDetailsApplicationCoupleNoPHI.toggleClass('hidden', !(abdDetailsApplicationCoupleNoPHI || (abdDetailsApplicationCoupleRabdNaForPartner || abdDetailsApplicationCouple)));

    var abdNoPhiMsg = 'The price indicated in the summary above includes an age-based discount based on what you&apos;ve told us. Your new health fund will confirm the exact discount you are eligible for.';
    var abdHasCoverMsg = 'The price indicated in the summary above includes an age-based discount based on what you&apos;ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.';
    var abrRetainedMsg = 'The price indicated in the summary above includes a retained age-based discount based on what you&apos;ve told us. Your new health fund will request a clearance certificate from your previous fund to confirm the exact discount you are eligible for.';

    if(isABD()) {
      // Does not already have a policy with an age based discount
      if (primaryHasCover || (!isSingle && partnerHasCover)) {
        // Checking if each party is InABDRange on the line above would mean that abdHasCoverMsg would only be applied if the party that has cover is also in InABDRange
        // this would treat the situation where a party is InABDRange and does not have cover yet their partner is not InABDRange and has cover the same as abdNoPHI
        if (isSingle) {
          // is single and has cover - but not one with an age based discount and is in the age group where ADB is applicable
          elements.abdDetailsApplicationSingle.html(abdHasCoverMsg);
          elements.abdDetailsApplicationSingleNoPHI.html(abdHasCoverMsg);
        } else {
          // one or both (have cover - but not one with an age based discount AND is in the age group where ADB is applicable)
          elements.abdDetailsApplicationCouple.html(abdHasCoverMsg);
          elements.abdDetailsApplicationCoupleNoPHI.html(abdHasCoverMsg);
        }
      } else {
        // no previous cover
        if (isSingle) {
          elements.abdDetailsApplicationSingle.html(abdNoPhiMsg);
          elements.abdDetailsApplicationSingleNoPHI.html(abdNoPhiMsg);
        } else {
          elements.abdDetailsApplicationCouple.html(abdNoPhiMsg);
          elements.abdDetailsApplicationCoupleNoPHI.html(abdNoPhiMsg);
        }
      }
    } else {
      if (primaryHasABD || (partnerHasABD && !isSingle)) {
        // Already has a policy with an age based discount
        if (isSingle) {
          // is single and has an age based discount that could be retained
          elements.abdDetailsApplicationSingle.html(abrRetainedMsg);
          elements.abdDetailsApplicationSingleNoPHI.html(abrRetainedMsg);
        } else {
          // one or both has an age based discount that could be retained
          elements.abdDetailsApplicationCouple.html(abrRetainedMsg);
          elements.abdDetailsApplicationCoupleNoPHI.html(abrRetainedMsg);
        }
      } else {
        // Already has a policy - but not one with an age based discount
        if (isSingle) {
          elements.abdDetailsApplicationSingle.html(abdHasCoverMsg);
          elements.abdDetailsApplicationSingleNoPHI.html(abdHasCoverMsg);
        } else {
          elements.abdDetailsApplicationCouple.html(abdHasCoverMsg);
          elements.abdDetailsApplicationCoupleNoPHI.html(abdHasCoverMsg);
        }
      }
    }
  }

  function showABDSupportContent() {
    elements.abdEligibilityContent.addClass('hidden');

    var primaryABD = hasAbdPolicy('primary');
    var partnerABD = hasAbdPolicy('partner');

    var primaryInRange = inRange(18, 29, state.primary.age);
    var partnerInRange = inRange(18, 29, state.partner.age);

    var primaryABDVisible = !elements.primary.abdQuestionContainer.hasClass('hidden');
    var partnerABDVisible = !elements.partner.abdQuestionContainer.hasClass('hidden');

    if(!state.hasPartner) {
      if ( primaryABD ) {
        elements.abdEligibilityContent.filter('#single_has_abd_policy').toggleClass('hidden', false);
      }
      else if ( primaryInRange ) {
        elements.abdEligibilityContent.filter('#single_18_to_30').toggleClass('hidden', false);
      }
    }
    else {

      if ((partnerABD && partnerABDVisible) || (primaryABD && primaryABDVisible)) {
        if (primaryABD && partnerABD && primaryABDVisible && partnerABDVisible) {
          elements.abdEligibilityContent.filter('#couple_both_has_abd').toggleClass('hidden', false);
        }
        else if ((primaryABD && (!partnerABD || !partnerABDVisible)) || ((!primaryABD || !primaryABDVisible) && partnerABD)) {
          elements.abdEligibilityContent.filter('#couple_one_has_abd').toggleClass('hidden', false);
        }
      } else {
        if ( primaryInRange && partnerInRange) {
          elements.abdEligibilityContent.filter('#couple_both_18_to_30').toggleClass('hidden', false);
        }
        else if (primaryInRange || partnerInRange) {
          elements.abdEligibilityContent.filter('#couple_one_18_to_30').toggleClass('hidden', false);
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

  // ABD - Age Based Discount | RABD - Retained Age Based Discount
  meerkat.modules.register('healthRABD', {
    init: init,
    isABD: isABD,
    isRABD: isRABD,
    setApplicationDetails: setApplicationDetails
  });

})(jQuery);
