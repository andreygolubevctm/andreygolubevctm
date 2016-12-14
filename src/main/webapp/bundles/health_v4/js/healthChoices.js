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

    function getSituation() {
        return $('input[name=health_situation_healthCvr]:checked').val();
    }

	meerkat.modules.register("healthChoices", {
		events: moduleEvents,
		init: init,
		initialise: initialise,
		hasSpouse: hasSpouse,
		returnCoverCode: returnCoverCode,
		setCover: setCover,
		setState: setState,
        getSituation: getSituation,
		shouldPerformUpdate: shouldPerformUpdate
	});

})(jQuery);