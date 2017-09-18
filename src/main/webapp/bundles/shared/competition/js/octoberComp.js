/*jshint esversion: 6 */

;(function($, undefined) {

  const trigger = document.querySelector('.octoberComp__mobile__trigger');
  const banner = document.querySelector('.octoberComp__mobile');
  const nav = document.querySelector('.octoberComp__navbar');

  function toggleFooter() {
    banner.classList.toggle('octoberComp__mobile--active');
  }

  function init() {
    trigger.addEventListener('click', toggleFooter);
  }

  function showNav() {
    nav.style.display = '';
    nav.classList.add('octoberComp__navbar--active');
  }

  function hideNav() {
    nav.classList.remove('octoberComp__navbar--active');
  }

	meerkat.modules.register("octoberComp", {
		init: init,
    showNav: showNav,
    hideNav: hideNav
  });
})(jQuery);
