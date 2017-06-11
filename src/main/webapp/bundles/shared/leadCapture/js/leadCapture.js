;(function($, undefined) {
  
  var firstName = $('.person_name').first(),
      firstNameValue = firstName.val(),
      $elements = {
        textBubbleHeader: $('.lead-capture .well h4'),
        radioBtn: $('.lead-capture .radioBtn label')
      };
  
  function _mapValueToInput(el) {
    var checked = $(el).parent().hasClass('active');
    var backendValue = checked ? 'Y' : 'N';
    var targetClass = el.className;
    $('#' + targetClass).val(backendValue);
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
      appendName(firstNameValue);
    });
  }

  function init() {
    _clickHandler();
    _onBlur();
    _appendName(firstNameValue);
  }
  
  window.meerkat.modules.register("leadCapture", {
    init: init,
  });
})(jQuery);