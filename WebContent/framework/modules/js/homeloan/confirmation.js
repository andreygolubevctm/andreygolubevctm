/**
* Description: Homeloan Confirmation Module
* External documentation:
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			confirmation: {

			}
		},
		moduleEvents = events.confirmation;

	function init(){

		jQuery(document).ready(function($) {

			if (typeof meerkat.site === 'undefined') return;
			if (meerkat.site.pageAction !== "confirmation") return;

			meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
				method:'completedApplication',
				object:{}
			});

		});

	}

	meerkat.modules.register("confirmation", {
		init: init,
		events: events
	});

})(jQuery);