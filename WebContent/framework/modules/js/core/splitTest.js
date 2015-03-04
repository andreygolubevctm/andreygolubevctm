;(function($, undefined){

	/**
	 * splitTest listens to the journeyEngine READY & STEP_CHANGED events to update a hidden field. If the hidden field doesn't exist
	 * the code will inject the hidden field
	 *
	 * Since this is in core, this will allow all AMS verticals to automatically pickup the renderingMode xpath for debugging purposes as some
	 * devices like MS Surface can render both XS & MD(?) breakpoints
	 **/

	var meerkat = window.meerkat,
		meerkatEvents =  meerkat.modules.events,
		currentJourney = null,
		currentJourneyList = [],
		currentJourneyFieldLabel = "currentJourney",
		$currentJourney = null;

	var events = {
			splitTest: {
				SPLIT_TEST_READY: 'SPLIT_TEST_READY'
			}
		},
		moduleEvents = events.splitTest;


	function init(){

		$(document).ready(function(){
			var prefix = meerkat.site.vertical == 'car' ? 'quote' : meerkat.site.vertical;
			var name = prefix + "_" + currentJourneyFieldLabel;
			$currentJourney = $('#' + name);
			var current_journey = $currentJourney.val();
			if(!_.isEmpty(current_journey)) {
				set(current_journey);
			}
			//
			meerkat.messaging.publish(moduleEvents.SPLIT_TEST_READY);
		});
	}

	function set(current_journey) {
		currentJourney = current_journey;
		currentJourneyList = _.isEmpty(currentJourney) ? [] : currentJourney.split('-');
		$currentJourney.val(currentJourney);
	}

	function get(to_list) {
		to_list = to_list || false;
		return to_list === true ? _.extend({}, currentJourneyList) : currentJourney;
	}

	function isActive( jrny ) {
		return _.indexOf(currentJourneyList, String(jrny)) >= 0;
	}

	meerkat.modules.register("splitTest", {
		init: init,
		events: events,
		get: get,
		isActive : isActive
	});

})(jQuery);