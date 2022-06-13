;(function ($, undefined) {

  var meerkat = window.meerkat,
      accordionContainer;

  function init() {
  }

  function toggleAccordions(accordionId, hide) {
    $('#' + accordionId).toggleClass('hidden', hide);
  }

  function initClickEvent(accordionId) {
    $('#' + accordionId).find('.accordion-title-container').on('click', expandAccordion);
  }

  function initClickEventBySelector(accordionSelector) {
    $(accordionSelector).find('.accordion-title-container').first().on('click', expandAccordion40px);
  }

  function initClickEventBySelectorForWrappedAccordions(accordionSelector) {
    $(accordionSelector).find('.accordion-title-container').first().on('click', expandCurrentAndParentAccordions40px);
  }

  function expandAccordion40px(event) {
    return expandAccordion(event, 40);
  }

  function expandCurrentAndParentAccordions40px(event) {
    return expandCurrentAndParentAccordions(event, 40);
  }

  function expandAccordion(event, height) {
    if (!height) {
      height = $(event.currentTarget).height();
    }
    event.stopPropagation();
    var target = event.target;
    if(target.classList.contains('expanded')) {
      target.parentElement.style.height = height + 'px';
      target.classList.remove('expanded');
    }else{
      target.classList.add('expanded');
      target.parentElement.style.height = (height + target.nextElementSibling.clientHeight) + 'px';
    }
  }

  function expandCurrentAndParentAccordions(event, height) {
    if (!height) {
      height = $(event.currentTarget).height();
    }
    event.stopPropagation();
    var target = event.target;
    // handle click on '+'
    if(!target.nextElementSibling) {
      target = target.parentElement;
    }
    // handle click on '-' with additional span
    if(target.nodeName !== 'DIV') {
      target = target.parentElement;
    }

    if(target.classList.contains('expanded')) {
      target.children[1].innerHTML = '+';
      target.parentElement.style.height = height + 'px';
      target.classList.remove('expanded');
    }else{
      target.children[1].innerHTML = '<span style="padding-right: 5px">-</span>';
      target.classList.add('expanded');
      target.parentElement.style.height = (height + target.nextElementSibling.clientHeight) + 'px';
    }

    var $parentAccordion = getParentAccordionTitleContainer(target, 4);
    if(target.classList.contains('expanded')) {
      $parentAccordion.style.height = (+($parentAccordion.style.height.replace('px', '')) + target.nextElementSibling.clientHeight) + 'px';
    } else {
      $parentAccordion.style.height = (+($parentAccordion.style.height.replace('px', '')) - target.nextElementSibling.clientHeight) + 'px';
    }
  }

  function getParentAccordionTitleContainer($element, order) {
    var $el = $element;
    for (var i = 0; i < order; i++) {
      $el = $el.parentElement;
    }
    return $el;
  }

  meerkat.modules.register("Accordion", {
    init: init,
    initClickEvent: initClickEvent,
    toggleAccordions: toggleAccordions,
    initClickEventBySelector: initClickEventBySelector,
    initClickEventBySelectorForWrappedAccordions: initClickEventBySelectorForWrappedAccordions
  });

})(jQuery);