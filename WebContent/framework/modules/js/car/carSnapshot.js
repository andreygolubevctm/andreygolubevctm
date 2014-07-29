/**
 * Brief explanation of the module and what it achieves. <example: Example pattern code for a meerkat module.>
 * Link to any applicable confluence docs: <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			carSnapshot: {
			}
		},
		moduleEvents = events.example;

	function initCarSnapshot() {

		meerkat.messaging.subscribe(meerkatEvents.car.SELECTION_RENDERED, function renderSnapshotSubscription(type) {
			renderSnapshot(type.type);
		});
	}

	function renderSnapshot(type) {
		var $el = $(".quoteSnapshot");
		if(type == 'fuels' || type == 'types') {
			$el.removeClass('hidden');
			meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(0) .snapshot');
		}
		else {
			$el.addClass('hidden');
			meerkat.modules.contentPopulation.empty('.journeyEngineSlide:eq(0) .snapshot');
		}
	}

	meerkat.modules.register('carSnapshot', {
		init: initCarSnapshot, //main entrypoint to be called.
		events: events //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);