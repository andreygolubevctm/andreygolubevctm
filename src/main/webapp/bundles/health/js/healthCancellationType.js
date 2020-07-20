;(function($){

  // TODO: write unit test once DEVOPS-31 goes live

  var meerkat = window.meerkat,
      meerkatEvents = meerkat.modules.events,
      components;
  var CANCEL_HOSPITAL_ONLY = 'Do you want to keep your hospital or cancel it?';
  var CANCEL_EXTRAS_ONLY = 'Do you want to keep your extras or cancel it?';
  var CANCEL_EXTRAS_OR_BOTH = 'Do you want to cancel just extras or hospital and extras?';
  var CANCEL_HOSPITAL_OR_BOTH = 'Do you want to cancel just hospital or hospital and extras?';

  function init(){
      $(document).ready(function () {
          components = {
            primary: {
              $cancellationScript: $('.simples-dialogue-cancellation-type-primary'),
              $cancellationRadio: $('#health_previous_fund_cancellation_type_primary')
            },
            partner: {
              $cancellationScript: $('.simples-dialogue-cancellation-type-partner'),
              $cancellationRadio: $('#health_previous_fund_cancellation_type_partner')
            }
          };
        
          var product = Results.getSelectedProduct();
          if(product) {
            var productType = product.info.ProductType;
            var primaryCoverType = meerkat.modules.healthAboutYou.getPrimaryHealthCurrentCover();
            initCancellationComponent(components, 'primary', primaryCoverType, productType);

            if (meerkat.modules.health.hasPartner()) {
              var partnerCoverType = meerkat.modules.healthAboutYou.getPrimaryHealthCurrentCover();
              initCancellationComponent(components, 'partner', partnerCoverType, productType);
            }
          }
      });
  }

  function initCancellationComponent(components, type, typeCover, productType) {
    var _components = components[type];
    var scriptLabel = _components.$cancellationScript.find('.checkbox-custom').find('label');
    _components.$cancellationRadio.children().each(function() { $(this).toggleClass('hidden', false); });
    _components.$cancellationScript.toggleClass('hidden', true);
    $(_components.$cancellationRadio.children()[0]).css('border-right-width', '0px');

    if(typeCover === 'C') {
        if(productType === 'Ancillary') {
          _components.$cancellationScript.toggleClass('hidden', false);
          _components.$cancellationRadio.toggleClass('hidden', false);

            scriptLabel.text(CANCEL_EXTRAS_OR_BOTH);
            $(_components.$cancellationRadio.children()[2]).toggleClass('hidden', true);
            $(_components.$cancellationRadio.children()[3]).toggleClass('hidden', true);
            $(_components.$cancellationRadio.children()[4]).toggleClass('hidden', true);

        } else if(productType === 'Hospital') {
          _components.$cancellationScript.toggleClass('hidden', false);
          _components.$cancellationRadio.toggleClass('hidden', false);

            scriptLabel.text(CANCEL_HOSPITAL_OR_BOTH);
            $(_components.$cancellationRadio.children()[1]).toggleClass('hidden', true);
            $(_components.$cancellationRadio.children()[3]).toggleClass('hidden', true);
            $(_components.$cancellationRadio.children()[4]).toggleClass('hidden', true);

            $(_components.$cancellationRadio.children()[0]).css('border-right-width', '1px');
        }
    }

    if(typeCover === 'E') {
        if(productType === 'Hospital') {
          _components.$cancellationScript.toggleClass('hidden', false);
          _components.$cancellationRadio.toggleClass('hidden', false);
          $(_components.$cancellationRadio.children()[1]).css('border-left-width', '1px');

          $(_components.$cancellationRadio.children()[0]).toggleClass('hidden', true);
          $(_components.$cancellationRadio.children()[2]).toggleClass('hidden', true);
          $(_components.$cancellationRadio.children()[3]).toggleClass('hidden', true);

            scriptLabel.text(CANCEL_EXTRAS_ONLY);
        }
    }

    if(typeCover === 'H') {
        if(productType === 'Ancillary') {
          _components.$cancellationScript.toggleClass('hidden', false);
          _components.$cancellationRadio.toggleClass('hidden', false);
          $(_components.$cancellationRadio.children()[2]).css('border-left-width', '1px');

          $(_components.$cancellationRadio.children()[0]).toggleClass('hidden', true);
          $(_components.$cancellationRadio.children()[1]).toggleClass('hidden', true);
          $(_components.$cancellationRadio.children()[4]).toggleClass('hidden', true);

            scriptLabel.text(CANCEL_HOSPITAL_ONLY);
        }
    }
  }

  meerkat.modules.register('healthCancellationType', {
      init: init
  });

})(jQuery);