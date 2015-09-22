/**
 * Brief explanation of the module and what it achieves. <example: Example pattern code for a meerkat module.>
 * Link to any applicable confluence docs: <example: http://confluence:8090/display/CM/Meerkat+Modules>
 */

;(function($, undefined){

	// You do not need to keep the meerkatEvents, events, log etc if you do not use them.
	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			example: {
				READY: 'EXAMPLE_READY'
			}
		},
		moduleEvents = events.example;

	/* Variables */
	var aUsefullGlobal = null;

	/* Here you put all functions for use in your module */

	/* main entrypoint for the module to run first */
	function initExample() {
		log("[example] Initialised"); //purely informational

		/* Call your magic here */

		/* Example of the EXAMPLE_READY event message being published for others to listen to: */
		meerkat.messaging.publish(moduleEvents.READY, this);

	}

	meerkat.modules.register('example', {
		init: initExample, //main entrypoint to be called.
		events: events //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);