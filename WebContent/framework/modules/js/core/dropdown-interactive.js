/* ========================================================================
 * Extending Bootstrap dropdown: dropdown.js v3.0.3
 * http://getbootstrap.com/javascript/#dropdowns
 * ======================================================================== */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		$newBackdropElement = $('<div class="dropdown-backdrop" />');

	function init() {

		// Set up touch events on touch devices, not just for dropdown-interactive.
		$(document).ready(function() {
			if (!Modernizr.touch) return;
			// Stop the background page being scrollable when a dropdown is open (doesn't work on mobiles really)
			$(document).on('touchmove', '.dropdown-backdrop, .dropdown-interactive form', function(e) {
				//if (meerkat.modules.deviceMediaState.get() === 'xs') return true;
				e.preventDefault();
				e.stopPropagation();
			});
			// Allow the dropdown body to be scrollable
			$(document).on('touchmove', '.dropdown-interactive .scrollable', function(e) {
				e.stopPropagation();
			});
		});



		//NOTE: Bootstrap's own component adds backdrops on mobile. WATCH OUT!
		$(document).on('show.bs.dropdown', function(event) {
			addBackdrop($(event.target));
		});



		$(document).on('shown.bs.dropdown', function(event) {
			if (!event.target) return;

				var useCache = true;
				if (meerkat.modules.deviceMediaState.get() === 'xs') useCache = false;

				// Size to fit in viewport (defered to improve likelihood this would work on android)
				_.defer(function(){
					if (fitIntoViewport($(event.target), useCache)) {
						$(document.body).addClass('dropdown-fitviewport');
					}
				});

				// Lock down the page scrolling (like modal)
				$(document.body).addClass('dropdown-open');
		});



		$(document).on('hidden.bs.dropdown', function(event) {
			// Unlock page scrolling
			$(document.body)
				.removeClass('dropdown-open')
				.removeClass('dropdown-fitviewport');
		});



		//
		// On resize, resize dropdowns into viewport
		//
		meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, function resizeDropdowns(state) {
			//log('dropdown-interactive DEVICE_RESIZE_DEBOUNCED received', state);

			$('.dropdown-interactive').each(function() {
				var $this = $(this);

				// Invalidate any cached height (even closed dropdowns)
				$this.removeAttr('data-maxheight');
				resetFit($this);

				if ($this.hasClass('open')) {
					if (fitIntoViewport($this, false)) {
						$(document.body).addClass('dropdown-fitviewport');
					}
					$(document.body).addClass('dropdown-open');
				}
			});
		});
	}



	function addBackdrop($dropdown) {
		var $backdropBase = $dropdown.closest('.dropdown-interactive-base'),
			$backdropAlternative = $dropdown.closest('.dropdown-interactive');

		if ($backdropBase.length && $backdropAlternative.length) {
			//When we find a specific base class market (needed for the page head because of nested dropdowns) we attach the background after.
			return $newBackdropElement.prependTo($backdropBase).on('click', clearMenus);
		} else if ($backdropAlternative.length) {
			//When we don't find a specific base class marker, we put it after the parent dropdown interactive div.
			return $newBackdropElement.prependTo($backdropAlternative).on('click', clearMenus);
		}
	}



	//
	// If a dropdown is too high for the viewport, size down the scrollable area.
	// Returns true if the resize was done, otherwise false.
	//
	function fitIntoViewport($dropdown, useCache) {
		if (!$dropdown || $dropdown.length === 0) return;
		//log('fitIntoViewport', $dropdown);

		var viewportHeight = 0,
			maxHeight = 0,
			extraHeights = 0;

		// Use cached height
		if (useCache === true && $dropdown.attr('data-maxheight')) {
			maxHeight = $dropdown.attr('data-maxheight');
		}
		else {
			// Get initial heights
			viewportHeight = $(window).height();

			// Bonus elements to consider when on XS
			if (meerkat.modules.deviceMediaState.get() === 'xs') {
				//extraHeights += $dropdown.find('.dropdown-container').offset().top;

				extraHeights += $('header .navbar-header').outerHeight();
				//console.log('header', $('header .navbar-header').outerHeight());

				extraHeights += $dropdown.find('.activator').outerHeight();
				//console.log('activator', $dropdown.find('.activator').outerHeight());

				$dropdown.prevAll('li:visible').each(function () {
					//console.log($(this).outerHeight(), this);

					extraHeights += $(this).outerHeight();
				});
			}
			else {
				extraHeights += 20; //Non-XS margins it at the bottom.

				// Check if this dropdown has an affix-able navbar. If so we need to factor in its height.
				$dropdown.closest('.navbar-affix').each(function() {
					extraHeights += $(this).outerHeight();
				});
			}

			// Find how tall the scrollable area is
			extraHeights += $dropdown.find('form').outerHeight() - $dropdown.find('.scrollable').outerHeight();

			//log('extraHeights:' + extraHeights);
			//log('form height:' + $dropdown.find('form').outerHeight());

			// Calc the maxheight of the scrollable area
			maxHeight = viewportHeight - extraHeights;

			// Cache this on the DOM
			$dropdown.attr('data-maxheight', maxHeight);
		}

		//log('fitIntoViewport viewport:' + viewportHeight + ' extraHeights:' + extraHeights + ' maxHeight:' + maxHeight);

		if (maxHeight > 0) {
			$dropdown.find('.dropdown-container .scrollable').css('max-height', maxHeight).css('overflow-y', 'auto');

			// Force a scroll to the navbar to that we fill the viewport with the dropdown
		/*	var $scrollToElement = $dropdown.closest('.navbar-affix');
			if ($scrollToElement.length > 0) {
				if (!$scrollToElement.hasClass('affix') && !$scrollToElement.hasClass('affix-bottom')) {
					$('html, body').stop().animate({
						scrollTop: $scrollToElement.offset().top
					}, 0);
				}
			}
*/
			return true;
		}
		else {
			resetFit($dropdown);
			return false;
		}
	}



	function resetFit($dropdown) {
		$dropdown.find('.dropdown-container .scrollable').css('max-height', '');
	}



	// Extension of BOOTSTRAP PLUGIN FUNCTIONALITY
	// ============================================
	function clearMenus() {
		$('[data-toggle="dropdown"]').parent('.open').children('[data-toggle="dropdown"]').dropdown('toggle');
	}



	meerkat.modules.register("dropdownInteractive", {
		init: init,
		fitIntoViewport: fitIntoViewport,
		addBackdrop: addBackdrop
	});

})(jQuery);