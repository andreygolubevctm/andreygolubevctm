;(function ($, undefined) {

  var meerkat = window.meerkat,
      accordionContainer;

  function init() {
      $(document).ready(function () {
        accordionContainer = $('.accordion-container');
        
        accordionContainer.find('.accordion-title-container').on('click', expandAccordion);
        window.addEventListener('resize', function() {
          $('.accordion-container').each(function() {
            if($(this.firstElementChild).hasClass('expanded')) {
              $(this).height(60 + $(this)[0].lastElementChild.clientHeight);
            }
          });
        });
      });
  }

  function toggleAccordions(accordionId, hide) {
    $('#' + accordionId).toggleClass('hidden', hide);
  }

  function initClickEvent(accordionId) {
    $('#' + accordionId).find('.accordion-title-container').on('click', expandAccordion);
  }

  function expandAccordion(event) {
    event.stopPropagation();
    var target = event.target;

    if(target.classList.contains('expanded')) {
      target.parentElement.style.height = '60px';
      target.classList.remove('expanded');
    }else{
      target.classList.add('expanded');
      target.parentElement.style.height = (60 + target.nextElementSibling.clientHeight) + 'px';
    }
  }

  meerkat.modules.register("Accordion", {
      init: init,
      initClickEvent: initClickEvent,
      toggleAccordions: toggleAccordions
  });

})(jQuery);