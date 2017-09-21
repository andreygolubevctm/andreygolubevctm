/*jshint esversion: 6 */

;(function($, undefined) {
  const trigger = document.querySelector('.octoberComp__mobile__trigger');
  const banner = document.querySelector('.octoberComp__mobile');
  const nav = document.querySelector('.octoberComp__navbarContainer');
  const octoberComp = banner && trigger;
  var bannerTxt;

  function setFooterPos() {
    if (!banner.classList.contains('octoberComp__mobile--active')) {
      var height = - (bannerTxt.clientHeight + 10) + 'px';
      banner.style.bottom = height;
    } else {
      banner.style.bottom = 0;
    }
  }

  function toggleFooter() {
    banner.classList.toggle('octoberComp__mobile--active');
    setFooterPos();
  }


  function init() {
      bannerTxt = banner.querySelector('p');
      trigger.addEventListener('click', toggleFooter);
      toggleFooter();
  }

  function showNav() {
      nav.style.display = '';
      nav.classList.add('octoberComp__navbarContainer--active');
  }

  function hideNav() {
      nav.classList.remove('octoberComp__navbarContainer--active');
  }
  
  function showMobileBanner() {
    banner.classList.remove('octoberComp__mobile__disabled');
  }
  
  function hideMobileBanner() {
    banner.classList.add('octoberComp__mobile__disabled');
  }

  var modules = octoberComp ? {
		init: init,
    showNav: showNav,
    hideNav: hideNav,
    showMobileBanner: showMobileBanner,
    hideMobileBanner: hideMobileBanner
  } : {};
	meerkat.modules.register("octoberComp", modules);
})(jQuery);
