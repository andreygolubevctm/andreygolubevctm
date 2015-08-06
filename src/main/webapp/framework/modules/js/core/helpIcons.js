;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {},
	moduleEvents = events;


	function init(){

		jQuery(document).ready(function($) {
			$('.help-icon').prop("tabindex", -1);
		});
	}



	meerkat.modules.register("helpIcons", {
		init: init,
		events: events
	});

})(jQuery);