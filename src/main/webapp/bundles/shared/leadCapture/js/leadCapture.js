;(function($, undefined) {

  var firstName = $('.person_name').first(),
      firstNameValue = firstName.val(),
      $elements = {
        principalResidenceInputs: $('input[name=home_occupancy_principalResidence]'),
        whenMovedIn: $('#home_occupancy_whenMovedIn_year'),
        textBubbleHeader: $('.lead-capture .well h4'),
        radioBtn: $('.lead-capture .radioBtn label'),
        health: $('.leadCapture-health'),
        energyMovingIn: $('.leadCapture-energy-movingIn'),
        energyResiding: $('.leadCapture-energy-residing')
      },
      state = {
        value: 'N',
        leadCaptureVertical: 'health',
        movingIn: null,
        currentLivingIn: null
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
      $elements.energyMovingIn.hide();
      $elements.health.hide();
      $elements.energyResiding.hide();
    }
  }

  function _checkJustMovedIn() {
    if ($elements.whenMovedIn.val() === 'NotAtThisAddress' && state.movingIn) {
      $elements.energyMovingIn.show();
      $elements.health.hide();
      $elements.energyResiding.hide();
      state.leadCaptureVertical = 'energy';
    } else if(state.currentLivingIn === 'health') {
      $elements.energyMovingIn.hide();
      $elements.health.show();
      $elements.energyResiding.hide();
      state.leadCaptureVertical = 'health';
    } else if(state.currentLivingIn === 'energy') {
      $elements.energyMovingIn.hide();
      $elements.health.hide();
      $elements.energyResiding.show();
      state.leadCaptureVertical = 'energy';
    } else {
      $elements.energyMovingIn.hide();
      $elements.health.hide();
      $elements.energyResiding.hide();
      state.leadCaptureVertical = null;
    }
  }
  
  /*
  var test = {
    movingIn: {
      energy: 100
    },
    currentLivingIn: {
      energy: 50,
      health: 50
    }
  };
  */
  function splitTest(values) {
    var currentLivingIn = values.currentLivingIn,
        movingIn = values.movingIn,
        rangeValue = Math.random() * 100;
    if (currentLivingIn.energy > rangeValue) {
      state.currentLivingIn = 'energy';
    } else if((currentLivingIn.health + currentLivingIn.energy) > rangeValue) {
      state.currentLivingIn = 'health';
    } else {
      state.currentLivingIn = null;
    }
    if (movingIn.energy > rangeValue) {
      state.movingIn = 'energy';
    } else {
      state.movingIn = null;
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
    getTrackingData: getTrackingData,
    splitTest: splitTest
  });
})(jQuery);