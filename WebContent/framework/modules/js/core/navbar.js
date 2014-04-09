;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;
		//msg = meerkat.messaging;

	var $mobileNavBarHamburger;
	var $navBarXsMenu;
	var $underlayContainer;

	function disable(){
		$mobileNavBarHamburger.addClass('disabled');
	}

	function enable(){
		$mobileNavBarHamburger.removeClass('disabled');
	}

	function open(){
		if($mobileNavBarHamburger.hasClass('collapsed') === true){
			//The collapsing animation is too slow for some rapid open close calls. For simplicity, we stopped calling the collapse plugin functions.
			//$navBarXsMenu.collapse('show');
			$navBarXsMenu.addClass('in');

			$mobileNavBarHamburger.removeClass('collapsed');
			$('<div class="dropdown-backdrop-underlay" />').prependTo($underlayContainer).on('click', close);
		}
	}

	function close(){
		if($mobileNavBarHamburger.hasClass('collapsed') === false){
			//The collapsing animation is too slow for some rapid open close calls. For simplicity, we stopped calling the collapse plugin functions.
			//$navBarXsMenu.collapse('hide');
			$navBarXsMenu.removeClass('in');

			$mobileNavBarHamburger.addClass("collapsed");
			$('.dropdown-backdrop-underlay').remove();
		}
	}

	function init(){
		$mobileNavBarHamburger = $('.xs-nav-bar-toggler');
		$navBarXsMenu = $('.navbar-collapse-menu');
		$underlayContainer = $('.dropdown-interactive-base');

		$mobileNavBarHamburger.on('click', function() {
			if($mobileNavBarHamburger.hasClass('disabled') === false){
				if($mobileNavBarHamburger.hasClass('collapsed') === true){
					open();
				}else{
					close();
				}
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange(){
			//When going into the benefits step on health it should override this event and not close the menu when changing steps.
			meerkat.modules.navbar.close();
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function closeXsMenus() {
			close();
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function openXsMenus() {
			if($(".navbar-nav .open").length > 0){
				open();
			}
		});
	}

	meerkat.modules.register("navbar", {
		init: init,
		close:close,
		open:open,
		enable:enable,
		disable:disable
	});

})(jQuery);