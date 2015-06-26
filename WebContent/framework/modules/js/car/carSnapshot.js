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
				RENDER_CAR_SNAPSHOT : "RENDER_CAR_SNAPSHOT"
			}
		},
		moduleEvents = events.carSnapshot;

	function initCarSnapshot() {
		meerkat.messaging.subscribe(meerkatEvents.car.DROPDOWN_CHANGED, function renderSnapshotOnDropdownChangeSubscription() {
			_.defer(renderSnapshot);
		});
		meerkat.messaging.subscribe(moduleEvents.RENDER_CAR_SNAPSHOT, function renderSnapshotSubscription() {
			_.defer(renderSnapshot);
		});
	}

	function renderSnapshot() {
		var carMake = $('#quote_vehicle_make');
		var $snapshotBox = $(".quoteSnapshot");
		if (carMake.val() !== '') {
			$snapshotBox.removeClass('hidden');
		} else {
			$snapshotBox.addClass('hidden')
		}
		meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(0) .snapshot');
	}

	meerkat.modules.register('carSnapshot', {
		init: initCarSnapshot,
		events: events
	});

})(jQuery);