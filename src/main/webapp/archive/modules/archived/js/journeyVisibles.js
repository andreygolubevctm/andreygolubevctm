/*
	This module controls elements on the page that need to hide or show on certain steps/slides.

	Associated CSS is in journeyEngine.less

	USAGE:
		data-slide-visible
			Apply the 'data-slide-visible' attribute to the element that will be hidden or shown.
			The value of the attribute is a list of journey engine step IDs.

	EXAMPLE:
		<li data-slide-visible="details,benefits,results,apply,payment">

*/
/*
DISABLED and replaced with CSS in journeyEngine.less
*/
;(function($, undefined){

	var meerkat = window.meerkat,
		log = window.meerkat.logging.info,
		transitionDuration = 200;



	function toggleSlideVisibles(navigationId) {

		var stateIsXS = (meerkat.modules.deviceMediaState.get() === 'xs');

		$slideVisibles.each(function toggleElements() {
			var $this = $(this),
				width = 0;

			// Is the element visible on this step?
			if ($this.attr('data-slide-visible').indexOf(navigationId) > -1) {

				$this.removeClass('hidden');

				if (!stateIsXS) {
					if ($this.attr('data-slide-visible-width')) {
						width = $this.attr('data-slide-visible-width');
					}

					$this.animate(
						{ 'width': width },
						transitionDuration
					);
				}
			}
			// Otherwise hide it
			else {

				if (stateIsXS) {
					$this.addClass('hidden');
				}
				else {
					$this.animate(
						{ 'width': 0 },
						transitionDuration,
						function() {
							$this.addClass('hidden');
						}
					);
				}
			}
		});
	}

	//
	// On breakpoint change, re-apply widths on non-XS. On XS remove the widths.
	//
	function breakpointChange() {

		var stateIsXS = (meerkat.modules.deviceMediaState.get() === 'xs');

		$slideVisibles.each(function updateElements() {
			var $this = $(this),
				width = 0;

			if (stateIsXS) {
				$this.css('width', '');
			}
			else {
				if ($this.attr('data-slide-visible-width')) {
					width = $this.attr('data-slide-visible-width');
				}

				if ($this.hasClass('hidden')) {
					$this.css('width', 0);
				}
				else {
					$this.css('width', width);
				}
			}
		});
	}



	function init() {
		//
		// Collect the elements.
		//
		$slideVisibles = $('[data-slide-visible]');
		$slideVisibles.each(function collectWidths() {
			var $this = $(this),
				width = 0;

			// Temporarily show the element so we can read the width
			$this.css('width', 'auto');
			width = $this.outerWidth();
			$this.attr('data-slide-visible-width', width);

			// Remove width (falls back to LESS rules)
			$this.css('width', '');
		});



		meerkat.messaging.subscribe("EVENT_STEP_INIT", function jeStepChange(step) {
			toggleSlideVisibles(step.navigationId);
		});

		meerkat.messaging.subscribe("EVENT_STEP_CHANGED", function jeStepChange(step) {
			toggleSlideVisibles(step.navigationId);
		});

		meerkat.messaging.subscribe(meerkat.modules.events.device.STATE_CHANGE, function breakpointChanged(states) {
			breakpointChange();
		});
	}



	meerkat.modules.register("journeyVisibles", {
		init: init
	});

})(jQuery);
