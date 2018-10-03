/**
 * Cover History Logic
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	/* Variables */
	var initialised = false;

	/* main entrypoint for the module to run first */
	function initHomeHistory() {
		if(!initialised) {
			initialised = true;
			log("[HomeHistory] Initialised"); //purely informational
		}
	}

	meerkat.modules.register('homeHistory', {
		initHomeHistory: initHomeHistory //main entrypoint to be called.
	});

})(jQuery);

