;(function($, undefined) {
  
  var firstName = $('.person_name').first();
  var firstNameValue = firstName.val();
  var leadCapturePopup = $('.lead-capture .well h4');

  function clickHandler() {
    $('.lead-capture .radioBtn label').on('click', function(e) {
      $(this).parent().toggleClass('active');
      mapValueToInput(this);
    });
  }
  
  function mapValueToInput(el) {
    var checked = $(el).parent().hasClass('active');
    var backendValue = checked ? 'Y' : 'N';
    var targetClass = el.className;
    $('#' + targetClass).val(backendValue);
  }
  
  function onBlur() {
    firstName.on('blur', function(e) {
      firstNameValue = e.target.value;
      appendName(firstNameValue);
    });
  }
  
  function appendName(value) {
    leadCapturePopup.text('Hi ' + value);
  }

  function init() {
    clickHandler();
    onBlur();
    appendName(firstNameValue);
  }
  
  window.meerkat.modules.register("leadCapture", {
    init: init,
  });
})(jQuery);