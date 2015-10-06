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
	var $toggleElement,
		$contentPane,
		$navMenuRow,
		$underlayContainer;


	/* Functions that affect the toggle */
	function disable(){
		$toggleElement.addClass('disabled');
	}
	function enable(){
		$toggleElement.removeClass('disabled');
	}


	/* Functions that affect the menu system state itself */
	function open(){
		if($toggleElement.hasClass('collapsed') === true){

			//The collapsing animation is too slow for some rapid open close calls. For simplicity, we stopped calling the collapse plugin functions.
			//$contentPane.collapse('show');
			$contentPane.addClass('in');

			//Push the page over, in whatever direction was designed or previously set.
			$navMenuRow.addClass('active');
			//Set the toggle element state
			$toggleElement.removeClass('collapsed');

			//An underlay closes the menu in case you click away
			$('<div class="navMenu-backdrop-underlay" />').prependTo($underlayContainer).on('click', close);
		}
	}
	function close(){
		if($toggleElement.hasClass('collapsed') === false){

			//The collapsing animation is too slow for some rapid open close calls. For simplicity, we stopped calling the collapse plugin functions.
			//$contentPane.collapse('hide');
			$contentPane.removeClass('in');

			//Restore page state.
			$navMenuRow.removeClass('active');
			//Set the toggle element state
			$toggleElement.addClass("collapsed");

			//We no longer need the underlay as we have just closed
			$('.navMenu-backdrop-underlay').remove();
		}
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
			if($(this).css('display') == 'block') {
				count++;
			}
			if(count > 0) return;
		});
		return count > 0;
	}

	/* Main Entrypoint */
	function initNavmenu() {
		log("[navMenu] Initialised"); //purely informational

		$(document).ready(function domready() {
			$toggleElement = $('[data-toggle=navMenu]');
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

			$toggleElement.on('click', function() {
				if($toggleElement.hasClass('disabled') === false){
					if($toggleElement.hasClass('collapsed') === true){
						open();
					}else{
						close();
					}
				}
			});

			// Toggle the visibility of the offcanvas icon (no point showing if empty)
			toggleNavMenu();

		});

		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange(){
			//When going into the benefits step on health it should override this event and not close the menu when changing steps.
			meerkat.modules.navMenu.close();
			toggleNavMenu();
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function closeXsMenus() {
			meerkat.modules.navMenu.close();
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function openXsMenus() {
			//Having one of the sub items open when entering small triggers the menu system to open in order to see that currently open menu.
			if($(".navbar-nav .open").length > 0){
				meerkat.modules.navMenu.open();
			}
			toggleNavMenu();
		});

		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function jeStepInit(){
			toggleNavMenu();
		});

		/* NAVMENU_READY event message being published for others to listen to: */
		meerkat.messaging.publish(moduleEvents.READY, this);

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