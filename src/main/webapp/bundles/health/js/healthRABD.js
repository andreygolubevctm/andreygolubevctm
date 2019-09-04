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
          hasCurrentCover: false,
          abdQuestion: $('[name=health_healthCover_primary_abd]'),
          hasAbdPolicy: false,
          abdPolicyStartDate: $('#primary_abd_start_date')
        },
        partner: {
          dateOfBirth: $('#health_healthCover_partner_dob'),
          age: 0,
          currentCover: $('[name=health_healthCover_partner_cover]'),
          hasCurrentCover: false,
          abdQuestion: $('[name=health_healthCover_partner_abd]'),
          hasAbdPolicy: false,
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

      meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, hideResultsFilter);
      meerkat.messaging.subscribe(meerkatEvents.RESULTS_UPDATED_INFO_RECEIVED, hideResultsFilter);
    });
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
              if ( abdFilterValue === 'Y' ) {
                $yesScripting.removeClass('hidden');
              }
              else {
                $yesScripting.addClass('hidden');
              }
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
        else {
          $yesScripting.removeClass('hidden');
        }
  }

  function isABD() {
    var isSingle = meerkat.modules.healthAboutYou.getSituation().indexOf("S") > -1;
    var primaryHasCover = elements.primary.hasCurrentCover;
    var partnerHasCover = elements.partner.hasCurrentCover;

    var primaryHasABD = elements.primary.hasAbdPolicy;
    var partnerHasABD = elements.partner.hasAbdPolicy;

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
    });

    elements[type].dateOfBirth.change(function(e) {
      elements[type].age = meerkat.modules.age.returnAge(e.target.value, true);
      showABDQuestion(type);
    });

    elements[type].abdQuestion.change(function(e) {
      elements[type].hasAbdPolicy = e.target.value === 'Y';
      showABDStartDate(type);
      showABDFilterQuestion();
    });
  }

  function showABDFilterQuestion() {
    var hasAbd = elements.primary.hasAbdPolicy || elements.partner.hasAbdPolicy;
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
    var showAbdQuestion = elements[type].age >= 18 && elements[type].age <= 45 && elements[type].hasCurrentCover ;
    elements[type].abdQuestion.toggleClass('hidden', !showAbdQuestion);
  }

  function showABDStartDate(type) {
    elements[type].abdPolicyStartDate.toggleClass('hidden', !elements[type].hasAbdPolicy);
  }

  function showPaymentsScript() {
    var selectedProduct = Results.getSelectedProduct();
    var isSingle = meerkat.modules.healthAboutYou.getSituation().indexOf("S") > -1;
    var primaryHasABD = elements.primary.hasAbdPolicy;
    var partnerHasABD = elements.partner.hasAbdPolicy;

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