;(function($, undefined) {

  var firstName = $('.person_name').first(),
      firstNameValue = firstName.val(),
      $elements = {
        principalResidenceInputs: $('input[name=home_occupancy_principalResidence]'),
        movedInYear: $('#home_occupancy_whenMovedIn_year'),
        movedInMonth: $('#home_occupancy_whenMovedIn_month'),
        textBubbleHeader: $('.lead-capture .well h4'),
        radioBtn: $('.lead-capture .radioBtn label'),
        leadCaptureHealth: $('.leadCapture-health'),
        leadCaptureEnergy: $('.leadCapture-energy')
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
    if (window.meerkat.site.vertical === 'home') {
      $elements.principalResidenceInputs.on('change', _checkJustMovedIn);
      $elements.movedInYear.on('change', _checkJustMovedIn);
      $elements.movedInMonth.on('change', _checkJustMovedIn);
    }
  }

  function _switchLeadCaptureComponent(leadCaptureVertical) {
    if (leadCaptureVertical !== state.leadCaptureVertical) {
      $elements.leadCaptureHealth.toggle();
      $elements.leadCaptureEnergy.toggle();
      state.leadCaptureVertical = leadCaptureVertical;
    }
  }

  function _checkJustMovedIn() {
    var date = new Date();
    var year = date.getFullYear().toString();
    var lastMonth = date.getMonth().toString();
    var thisMonth = (date.getMonth() + 1).toString();
    var principalResidence = $('input[name=home_occupancy_principalResidence]:checked').val() === "Y";
    var movedInYear = $elements.movedInYear.val();
    var movedInMonth = $elements.movedInMonth.val();
    // Must be principalResidence, not moved in yet or the last two months.
    if (principalResidence && ((movedInYear === year && _.indexOf([lastMonth, thisMonth], movedInMonth) !== -1) || movedInYear === 'NotAtThisAddress')) {
      _switchLeadCaptureComponent('energy');
    } else {
      _switchLeadCaptureComponent('health');
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