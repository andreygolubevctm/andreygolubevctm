;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		moduleEvents = {
			health: {
				SNAPSHOT_FIELDS_CHANGE: 'SNAPSHOT_FIELDS_CHANGE'
			}
		};

	var _cover = '',
		_state = '',
		_performUpdate=false,
		$elements = {};

	function init() {
		_setupFields();
		_eventListeners();
	}

	function initialise(cover) {
		setCover(cover);
	}

	function _setupFields () {
		$elements = {
			healthSit: $('#health_benefits_healthSitu'),
			healthSitGroup: $("input[name=health_situation_healthSitu]"),
			healthSitCSF : $('#health_situation_healthSitu_CSF'),
			healthCover: $('input[name=health_situation_healthCvr]'),
			state: $('#health_situation_state'),
			postcode: $('#health_situation_postcode'),
			suburb: $('#health_situation_suburb')
		};
	}

	function _eventListeners() {
		$elements.healthCover.on('change',function() {
			meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
		});

		$elements.healthSitGroup.on('change',function() {
			meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
		});
	}

	function hasSpouse() {
		switch(_cover) {
			case 'C':
			case 'F':
				return true;
			default:
				return false;
		}
	}

	function getCover() {
		return _cover;
	}

	function setCover(cover) {
		_cover = cover || 'SM'; // default to a single
	}

	function setState (state) {
		_state = state;
	}

	function returnCoverCode() {
		return _cover;
	}

	function shouldPerformUpdate(performUpdate) {
		_performUpdate = performUpdate;
	}

	meerkat.modules.register("healthChoices", {
		events: moduleEvents,
		init: init,
		initialise: initialise,
		hasSpouse: hasSpouse,
		returnCoverCode: returnCoverCode,
		setCover: setCover,
		getCover: getCover,
		setState: setState,
		shouldPerformUpdate: shouldPerformUpdate
	});

})(jQuery);