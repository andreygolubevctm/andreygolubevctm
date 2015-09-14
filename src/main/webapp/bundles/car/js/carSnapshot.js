/**
 * carSnapshot modules activates event listeners which request the vehicle snapshot element
 * to be updated when triggered.
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
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.READY, function renderSnapshotOnJourneyReadySubscription() {
			_.defer(renderSnapshot);
		});
	}

	function renderSnapshot() {
		var firstSnapshotSlide = 1;
		if(!meerkat.modules.splitTest.isActive(13)) {
			firstSnapshotSlide = 0;
			var carMake = $('#quote_vehicle_make');
			var $snapshotBox = $(".quoteSnapshot");
			if (carMake.val() !== '') {
				$snapshotBox.removeClass('hidden');
			} else {
				$snapshotBox.addClass('hidden');
			}
		}
		var limit = meerkat.modules.journeyEngine.getStepsTotalNum();
		for(var i = firstSnapshotSlide; i < limit; i++) {
			var selector = '';
			if(i == 4) {
				selector = '.header-wrap';
			} else {
				selector = '.journeyEngineSlide:eq(' + i + ')';
			}
			meerkat.modules.contentPopulation.render(selector + ' .snapshot');
		}
	}

	meerkat.modules.register('carSnapshot', {
		init: initCarSnapshot,
		events: events
	});

})(jQuery);