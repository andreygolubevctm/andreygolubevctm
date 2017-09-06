;(function($, undefined) {

  var firstName = $('.person_name').first(),
      firstNameValue = firstName.val(),
      $elements = {
        principalResidenceInputs: $('input[name=home_occupancy_principalResidence]'),
        whenMovedIn: $('#home_occupancy_whenMovedIn_year'),
        textBubbleHeader: $('.lead-capture .well h4'),
        radioBtn: $('.lead-capture .radioBtn label'),
        health: $('.leadCapture-health'),
        energy: $('.leadCapture-energy')
      },
      state = {
        value: 'N',
        leadCaptureVertical: 'health'
      };

  function _mapValueToInput(el) {
    var checked = $(el).parent().hasClass('active');
    var backendValue = checked ? 'Y' : 'N';
    var targetClass = el.className;
    $('#' + targetClass).val(backendValue);
    state.value = backendValue;
  }

  function _appendName(value) {
    $elements.textBubbleHeader.text('Hi ' + value);
  }

  function _clickHandler() {
    $elements.radioBtn.on('click', function(e) {
      $(this).parent().toggleClass('active');
      _mapValueToInput(this);
    });
  }

  function _onBlur() {
    firstName.on('blur', function(e) {
      firstNameValue = e.target.value;
      _appendName(firstNameValue);
    });
  }

  function getTrackingData() {
    if (state.value === 'Y') {
      return state.leadCaptureVertical;
    }
    return null;
  }

  function _onChange() {
    if (window.meerkat.site.vertical === 'home' && window.meerkat.site.tracking.brandCode === 'ctm') {
      $elements.whenMovedIn.on('change', _checkJustMovedIn);
      $elements.principalResidenceInputs.on('change', _principalResidenceChange);
    }
  }
  
  function _principalResidenceChange() {
    if ($('input[name=home_occupancy_principalResidence]:checked').val() === 'N') {
      $elements.health.hide();
      $elements.energy.hide();
    }
  }

  function _checkJustMovedIn() {
    if ($elements.whenMovedIn.val() === 'NotAtThisAddress') {
      $elements.health.hide();
      $elements.energy.show();
      state.leadCaptureVertical = 'energy';
    } else {
      $elements.health.show();
      $elements.energy.hide();
      state.leadCaptureVertical = 'health';
    }
  }

  function _eventListeners() {
    _clickHandler();
    _onChange();
    _onBlur();
  }

  function init() {
    _eventListeners();
    _appendName(firstNameValue);
  }

  window.meerkat.modules.register("leadCapture", {
    init: init,
    getTrackingData: getTrackingData
  });
})(jQuery);