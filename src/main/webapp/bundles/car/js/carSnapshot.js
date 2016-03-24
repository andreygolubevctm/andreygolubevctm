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

        registerSnapShotFields();
	}

	function renderSnapshot() {
		var carMake = $('#quote_vehicle_make');
		var $snapshotBox = $(".quoteSnapshot");
		if (carMake.val() !== '') {
			$snapshotBox.removeClass('hidden');
		} else {
			$snapshotBox.addClass('hidden');
		}

        meerkat.modules.contentPopulation.render('.header-wrap');
        meerkat.modules.contentPopulation.render('.car-snapshot', true);
        meerkat.modules.contentPopulation.render('.driver-snapshot', true);
        meerkat.modules.contentPopulation.render('.parking-snapshot', true);
	}

    // Register all fields change events here instead of doing it one by one through other modules (except the ones that have already registered through carVehicleSelection.js)
    function registerSnapShotFields() {

        var fieldsArray = [
            $('#quote_vehicle_use'),
            $('input[name=quote_drivers_regular_gender]'),
            $('#quote_drivers_regular_dob'),
            $('#quote_drivers_regular_ncd'),
            $('#quote_riskAddress_suburbName'),
            $('#quote_riskAddress_suburb'),
            $('#quote_riskAddress_nonStdPostCode'),
            $('#quote_riskAddress_postCode'),
            $('#quote_vehicle_parking')
        ];

        $(fieldsArray).each(function () {
            $(this).on('change', renderSnapshot);
        });
    }

	meerkat.modules.register('carSnapshot', {
		init: initCarSnapshot,
		events: events
	});

})(jQuery);