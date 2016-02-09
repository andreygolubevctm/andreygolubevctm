/**
* Description: 
* External documentation: 
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			example: {
				
			}
		},
		moduleEvents = events.example;

	function init(){

		$(document).ready(function($) {
			
		});

	}

	meerkat.modules.register("example", {
		init: init,
		events: events
	});

})(jQuery);