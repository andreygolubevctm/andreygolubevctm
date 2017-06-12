;(function($, undefined) {
  
  var firstName = $('.person_name').first(),
      firstNameValue = firstName.val(),
      $elements = {
        textBubbleHeader: $('.lead-capture .well h4'),
        radioBtn: $('.lead-capture .radioBtn label')
      },
      state = {
        field: 1,
        value: 'N',
        leadVertical: 'health' 
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
      _track();
    });
  }
  
  function _onBlur() {
    firstName.on('blur', function(e) {
      firstNameValue = e.target.value;
      _appendName(firstNameValue);
    });
  }
  
  function _track() {
    
  }
  
  function _onChange() {
    if (window.meerkat.site.vertical === 'home') {
      $('#home_occupancy_whenMovedIn_year').on('change', _checkJustMovedIn);
      $('#home_occupancy_whenMovedIn_month').on('change', _checkJustMovedIn);
    }
  }
  
  function _switch(field) {
    var $f1 = $('.f1');
    var $f2 = $('.f2');
    if (field !== state.field) {
      $f1.toggle();
      $f2.toggle();
      state.field = field;
      state.leadVertical = field === 1 ? 'health' : 'energy';
    }
  }
  
  function _checkJustMovedIn() {
    var date = new Date();
    var year = date.getFullYear().toString();
    var month = date.getMonth().toString();
    var movedInYear = $('#home_occupancy_whenMovedIn_year').val();
    var movedInMonth = $('#home_occupancy_whenMovedIn_month').val();
    if (movedInYear === year && movedInMonth === month || movedInYear === 'NotAtThisAddress') {
      _switch(2);
    } else {
      _switch(1);
    }
  }
  
  function _hideField2() {
    if (window.meerkat.site.vertical === 'home') {
      $('.f2').hide();
    }
  }

  function _eventListeners() {
    _clickHandler();
    _onChange();
    _onBlur();
  }

  function init() {
    _hideField2();
    _eventListeners();
    _appendName(firstNameValue);
  }
  
  window.meerkat.modules.register("leadCapture", {
    init: init,
  });
})(jQuery);