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
      mobileFixedCssFix();
  }

  function showNav() {
      nav.style.display = '';
      nav.classList.add('octoberComp__navbarContainer--active');
  }

  function hideNav() {
      nav.classList.remove('octoberComp__navbarContainer--active');
  }
  
  function closeMobileBanner() {
    banner.classList.remove('octoberComp__mobile--active');
    setFooterPos();
  }
  
  function showMobileBanner() {
    banner.classList.remove('octoberComp__mobile__disabled');
  }
  
  function hideMobileBanner() {
    banner.classList.add('octoberComp__mobile__disabled');
  }
  
  function mobileFixedCssFix() {
    if ('ontouchstart' in window) {
        /* cache dom references */ 
        var $body = $('body'); 
        
        /* bind events */
        
        var inputTypes = 'input[type=tel], input[type=number], input[type=text], input[type=email], select';
        $(document)
        .on('click', inputTypes, function() {
            $body.addClass('fixfixed');
        })
        .on('blur touchend', inputTypes, function() {
            $body.removeClass('fixfixed');
        });
    }
  }
  
  function compOff() {
    return;
  }

  var modules = octoberComp ? {
		init: init,
    showNav: showNav,
    hideNav: hideNav,
    showMobileBanner: showMobileBanner,
    hideMobileBanner: hideMobileBanner,
    closeMobileBanner: closeMobileBanner
  } : 
  {
    showNav: compOff,
    hideNav: compOff,
    showMobileBanner: compOff,
    hideMobileBanner: compOff,
    closeMobileBanner: compOff
  };
	meerkat.modules.register("octoberComp", modules);
})(jQuery);
