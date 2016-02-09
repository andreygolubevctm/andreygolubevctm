/**
* Description: Used to hide/auto-hide the unsupported message.
* External documentation:
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			unsupportedBrowser: {

			}
		},
		moduleEvents = events.unsupportedBrowser,
		closeButton = '#js-close-unsupported-browser';

	function init(){

		jQuery(document).ready(function($) {
			if($(closeButton).length) {
				eventSubscriptions();
				applyEventListeners();
			}
		});

	}
	/**
	 * Hide and don't show again when clicked, if localStorage is supported.
	 * Otherwise, just hide for current page load.
	 */
	function eventSubscriptions() {
		var $el = $(closeButton);
		if(Modernizr.localstorage === true) {
			if(localStorage.getItem("closedUnsupportedBrowser") !== null) {
				$el.parent().remove();
			}
		}
		// Check for it again, as it may have been removed.
		if($el.length) {
			$el.off('click').on('click', function(e) {
				e.preventDefault();
				e.stopPropagation();
				$(this).parent().remove();
				if(Modernizr.localstorage === true) {
					localStorage.setItem("closedUnsupportedBrowser", "true");
				}
				return false;
			});
		}
	}
	/**
	 * Auto-hide on results.
	 */
	function applyEventListeners() {
		$(document).on("resultsLoaded", function() {
				$(closeButton).click();
		});
	}

	meerkat.modules.register("unsupportedBrowser", {
		init: init,
		events: events
	});

})(jQuery);