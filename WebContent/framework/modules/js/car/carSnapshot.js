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
		meerkat.messaging.subscribe(meerkatEvents.car.DROPDOWN_CHANGED, function renderSnapshotSubscription() {
			renderSnapshot();
		});
	}

	function renderSnapshot() {
		var carMake = $('#quote_vehicle_make');
		if (carMake.val() !== '') {
			var $snapshotBox = $(".quoteSnapshot");
			$snapshotBox.removeClass('hidden');
		}
		meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(0) .snapshot');
	}

	meerkat.modules.register('carSnapshot', {
		init: initCarSnapshot, //main entrypoint to be called.
		events: events //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);