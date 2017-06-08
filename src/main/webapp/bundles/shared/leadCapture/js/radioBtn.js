;(function($, undefined) {

  function clickHandler() {
    $('.lead-capture .radioBtn label').on('click', function() {
      $(this).parent().toggleClass('active');
    });
  }

  function init() {
    clickHandler();
  }
  
  window.meerkat.modules.register("leadCapture", {
    init: init,
  });
})(jQuery);