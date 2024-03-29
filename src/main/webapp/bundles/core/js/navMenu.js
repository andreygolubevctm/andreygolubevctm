/*
 * NAVBAR - The Off Canvas & Normal Menu Controller
 * --------------------------------------------------
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;
		debug = meerkat.logging.debug;

	/* Event Registry */
	var events = {
			navMenu: {
				READY: 'NAVMENU_READY'
			}
		},
		moduleEvents = events.navMenu;


	/* Variables */
	var $openElement,
        $closeElement,
		$contentPane,
		$navMenuRow,
		$underlayContainer;


	/* Functions that affect the toggle */
	function disable(){
		$openElement.addClass('disabled');
	}
	function enable(){
		$openElement.removeClass('disabled');
	}


	/* Functions that affect the menu system state itself */
	function open(){
        //The collapsing animation is too slow for some rapid open close calls. For simplicity, we stopped calling the collapse plugin functions.
        //$contentPane.collapse('show');
        $contentPane.addClass('in');

        //Push the page over, in whatever direction was designed or previously set.
        $navMenuRow.addClass('active');

        //An underlay closes the menu in case you click away
        $('<div class="navMenu-backdrop-underlay" />').prependTo($underlayContainer).on('click', close);
	}
	function close(){
        //The collapsing animation is too slow for some rapid open close calls. For simplicity, we stopped calling the collapse plugin functions.
        //$contentPane.collapse('hide');
        $contentPane.removeClass('in');

        //Restore page state.
        $navMenuRow.removeClass('active');

        //We no longer need the underlay as we have just closed
        $('.navMenu-backdrop-underlay').remove();

        // remove backdrop underlay for any dropdown that may exist in the navMenu
        $('.dropdown-backdrop').remove();
	}

	/* Toggle menu dependent on whether it contains any content */
	function toggleNavMenu() {
		if(hasContent()) {
			enable();
		} else {
			disable();
		}
	}

	/* Confirm if canvas contains anything other than the title element */
	function hasContent() {
		var count = -1; // Will always contain menu as an LI
		$('.navMenu-contents').find('.navbar-nav').find('li').each(function(){
			if($(this).is(':visible')) {
				count++;
			}
			if(count > 0) return;
		});
		return count > 0;
	}

	/* Main Entrypoint */
	function initNavmenu() {
		//log("[navMenu] Initialised"); //purely informational

		$(document).ready(function domready() {
			$openElement = $('[data-toggle=navMenuOpen]');
            $closeElement = $('[data-toggle=navMenuClose]');
			$contentPane = $('.navMenu-contents');
			$navMenuRow = $('.navMenu-row');
			$underlayContainer = $('.navMenu-row .navMenu-row-fixed');
			//.dropdown-interactive-base was the old reference for underlayContainer

			//Read the settings to determine the use of the menu styling
			if (meerkat.site.navMenu.type === 'offcanvas') {
				$navMenuRow.addClass('navMenu-offcanvas');

				if (meerkat.site.navMenu.direction === 'left') {
					$navMenuRow.addClass('navMenu-left');
				} else {
					$navMenuRow.addClass('navMenu-right');
				}
			}

			debug("[navMenu] Configured as: " + meerkat.site.navMenu.type + " " + meerkat.site.navMenu.direction); //more info again.

			$openElement.on('click', function() {
				if($openElement.hasClass('disabled') === false){
                    open();
				}
			});

            $closeElement.on('click', function() {
                close();
            });

			// Toggle the visibility of the offcanvas icon (no point showing if empty)
			toggleNavMenu();

		});
		//log("[navMenu] Initialised 1");
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange(){
			//When going into the benefits step on health it should override this event and not close the menu when changing steps.
			meerkat.modules.navMenu.close();
			toggleNavMenu();
		});
		//log("[navMenu] Initialised 2");
		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function closeXsMenus() {
			meerkat.modules.navMenu.close();
		});
		//log("[navMenu] Initialised 3");
		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function openXsMenus() {
			//Having one of the sub items open when entering small triggers the menu system to open in order to see that currently open menu.
			if($(".navbar-nav .open").length > 0){
				meerkat.modules.navMenu.open();
			}
			toggleNavMenu();
		});
		//log("[navMenu] Initialised 4");
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function jeStepInit(){
			toggleNavMenu();
		});
		log("[navMenu] Initialised 5");
		/* NAVMENU_READY event message being published for others to listen to: */
		meerkat.messaging.publish(moduleEvents.READY, this);

		//log("[navMenu] Initialised Completed");

	}

	meerkat.modules.register('navMenu', {
		init: initNavmenu, //main entrypoint to be called.
		events: events, //exposes the events object
		// Public Accessors
		close:close,
		open:open,
		enable:enable,
		disable:disable,
		toggleNavMenu:toggleNavMenu
	});

})(jQuery);