;(function ($, undefined) {

  var meerkat = window.meerkat,
    meerkatEvents = meerkat.modules.events,
    elements;

  function init() {
    $(document).ready(function() {
      elements = {
        primary: {
          dateOfBirth: $('#health_healthCover_primary_dob'),
          age: 0,
          currentCover: $('[name=health_healthCover_primary_cover]'),
          abdQuestion: $('[name=health_healthCover_primary_abd]'),
          abdPolicyStartDate: $('#primary_abd_start_date')
        },
        partner: {
          dateOfBirth: $('#health_healthCover_partner_dob'),
          age: 0,
          currentCover: $('[name=health_healthCover_partner_cover]'),
          abdQuestion: $('[name=health_healthCover_partner_abd]'),
          abdPolicyStartDate: $('#partner_abd_start_date')
        },
        abdFilterQuestion: $('#abd_filter'),
        abdFilterRadios: $('[name=health_healthCover_filter_abd]'),
        dialogTriggers: $('.dialogPop')
      };

      _setupListeners('primary');
      _setupListeners('partner');
      elements.dialogTriggers.click(showABDModal);
      elements.abdFilterRadios.change( function(e) {
        onChangeAbdFilterRadios(e);
      });

      // If we already have cover (we probably have loaded the quote in from a transactionId) check if we should show all the
      // ABD elements
      if(hasCover('primary')) {
        elements.primary.age = meerkat.modules.age.returnAge(elements.primary.dateOfBirth.val(), true);
        showABDQuestion('primary');
        showABDStartDate('primary');
        showABDFilterQuestion();
      }

      if(hasCover('partner')) {
        elements.partner.age = meerkat.modules.age.returnAge(elements.partner.dateOfBirth.val(), true);
        showABDQuestion('partner');
        showABDStartDate('partner');
        showABDFilterQuestion();
      }

      meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, hideResultsFilter);
      meerkat.messaging.subscribe(meerkatEvents.RESULTS_UPDATED_INFO_RECEIVED, hideResultsFilter);
    });
  }

  function hasCover(type) {
    return elements[type].currentCover.filter(':checked').val() === 'Y';
  }

  function hasAbdPolicy(type) {
    var showAbdQuestion = elements[type].age >= 18 && elements[type].age <= 45 && hasCover(type);

    return showAbdQuestion && elements[type].abdQuestion.filter(':checked').val() === 'Y';
  }

  function onChangeAbdFilterRadios(e) {
    var unsure = e.target.value === 'N' || e.target.value === 'U';
    var modalContent = elements.abdFilterQuestion.find('.abdFilterModalContent').html();
    var $yesScripting = $('.simples-dialogue-138');
  
    if (unsure) {
      $yesScripting.addClass('hidden');
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
          var target = elements.abdFilterRadios.filter('[value="' + abdFilterValue+ '"]');
          var currentSelection = elements.abdFilterRadios.filter(':checked');
          currentSelection.parent('label').removeClass('active');
          currentSelection.prop('checked', false);
          target.prop('checked', true);
          target.parent('label').addClass('active');
          $('.filter-no-response-scripting').addClass('hidden');
          $yesScripting.toggleClass('hidden', abdFilterValue !== 'Y' );
        },
        onOpen: function() {
          $('[name=health_healthCover_filter_abd_final]').change( function(e) {
            $('.filter-no-response-scripting').toggleClass('hidden', e.target.value !== 'N');
          });
        }
      });
    }
    else {
      $yesScripting.removeClass('hidden');
    }
  }

  function isABD() {
    var isSingle = meerkat.modules.healthAboutYou.getSituation().indexOf("S") > -1;
    var primaryHasCover = hasCover('primary');
    var partnerHasCover = hasCover('partner');

    var primaryHasABD = hasAbdPolicy('primary');
    var partnerHasABD = hasAbdPolicy('partner');

    if(!primaryHasCover && (isSingle || !partnerHasCover)) {
      return true;
    }

    if(!primaryHasABD && (isSingle || !partnerHasABD)) {
      return true;
    }

    return false;
  }

  function isRABD() {
    return !isABD();
  }

  function showABDModal() {
    meerkat.modules.dialogs.show({
      title: $(this).attr("title"),
      htmlContent: $(this).attr("data-content"),
      className: $(this).attr("data-class")
    });
  }

  function _setupListeners(type) {
    elements[type].currentCover.change( function(e) {
      elements[type].hasCurrentCover = e.target.value === 'Y';
      showABDQuestion(type);
      showABDStartDate(type);
      showABDFilterQuestion();
    });

    elements[type].dateOfBirth.change(function(e) {
      elements[type].age = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion(type);
      showABDStartDate(type);
      showABDFilterQuestion();
    });

    elements[type].abdQuestion.change(function(e) {
      elements[type].hasAbdPolicy = e.target.value === 'Y';
      showABDStartDate(type);
      showABDFilterQuestion();
    });
  }

  function showABDFilterQuestion() {
    var hasAbd = hasAbdPolicy('primary') || hasAbdPolicy('partner');
    elements.abdFilterQuestion.toggleClass('hidden', !hasAbd);
  }

  function hideResultsFilter() {
    var rabdResult = Results.getReturnedResults().find(function(result) { return result.custom.reform.yad === "R" && result.premium.monthly.abd > 0; });
    $('.results-filters-abd').toggleClass('hidden', rabdResult === undefined);

    var simplesShowRABD = filterAbdProducts();

    if(isRABD()) {
      $('#rabd-reminder').toggleClass('hidden', !simplesShowRABD || rabdResult === undefined);
      $('#rabd-reminder-no-results').toggleClass('hidden', !simplesShowRABD || rabdResult !== undefined);
      $('.simples-dialogue-142').toggleClass('hidden', !simplesShowRABD || rabdResult !== undefined);
    }
  }

  function showABDQuestion(type) {
    var showAbdQuestion = elements[type].age >= 18 && elements[type].age <= 45 && hasCover(type);
    elements[type].abdQuestion.toggleClass('hidden', !showAbdQuestion);
  }

  function showABDStartDate(type) {
    elements[type].abdPolicyStartDate.toggleClass('hidden', !hasAbdPolicy(type));
  }

  function showPaymentsScript() {
    var selectedProduct = Results.getSelectedProduct();
    var isSingle = meerkat.modules.healthAboutYou.getSituation().indexOf("S") > -1;
    var primaryHasABD = hasAbdPolicy('primary');
    var partnerHasABD = hasAbdPolicy('partner');

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
    if(!elements.abdFilterRadios || elements.abdFilterRadios.filter(':checked') === undefined) {
      return false;
    }

    return elements.abdFilterRadios.filter(':checked').val() === "Y";
  }

  meerkat.modules.register('healthRABD', {
      init: init,
      isABD: isABD,
      isRABD: isRABD,
      showPaymentsScript: showPaymentsScript,
      filterAbdProducts: filterAbdProducts
  });

})(jQuery);