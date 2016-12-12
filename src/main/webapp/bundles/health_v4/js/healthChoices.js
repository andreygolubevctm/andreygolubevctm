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
		_situation = '',
		_state = '',
		_performUpdate=false,
		$elements = {};

	function init() {
		_setupFields();
		_eventListeners();
	}

	function initialise(cover, situation) {
		setCover(cover, true, true);
		_setSituation(situation, _performUpdate);
	}

	function _setupFields () {
		$elements = {
			healthSit: $('#health_benefits_healthSitu'),
			healthSitGroup: $("input[name=health_situation_healthSitu]"),
			healthSitCSF : $('#health_situation_healthSitu_CSF'),
			healthCover: $('#health_situation_healthCvr'),
			state: $('#health_situation_state'),
			postcode: $('#health_situation_postcode'),
			suburb: $('#health_situation_suburb'),
			location: $('#health_situation_location')
		};
	}

	function _eventListeners() {
		$elements.healthCover.on('change',function() {
			setCover($(this).val());
			meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
		});

		// we need to wait till the field gets proparly populated from the address search ajax
		$elements.location.on('change',function() {
			setTimeout(function() {
				meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
			},250);

		}).on('blur',function() {
			setLocation($(this).val());
		});

		$elements.healthSitGroup.on('change',function() {
			meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
		});

		// For loading in.
		if($elements.location.val() !== '') {
			setLocation($elements.location.val());
		}
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
		_cover = cover;
		_updateSituation();
	}

	function _updateSituation() {
		var $familyTile = $elements.healthSitCSF.siblings("span").first();
		var copy = $familyTile.text();

		switch(_cover) {
			case 'F':
			case 'SPF':
				copy = copy.replace('Start a family','Grow my family');
				break;
			default:
				copy = copy.replace('Grow my family','Start a family');
		}
		$familyTile.text(copy);
	}

	function _setSituation(situation, performUpdate) {
		if (performUpdate !== false)
			_performUpdate = true;

		//// Change the message
		if (situation != _situation) {
			_situation = situation;
		}

		$elements.healthSit.val( situation );

		if (!_.isEmpty(situation)) {
			$elements.healthSitGroup.filter('[value='+situation+']').prop('checked', true).trigger('change');
		}
	}

	function _isValidLocation( location ) {

		var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/),
		value = $.trim(String(location));

		if( value !== '' ) {
			if( value.match(search_match) ) {
				return true;
			}
		}

		return false;
	}

	function setLocation(location) {

		if( _isValidLocation(location) ) {
			var value = $.trim(String(location));
			var pieces = value.split(' ');
			var state = pieces.pop();
			var postcode = pieces.pop();
			var suburb = pieces.join(' ');
			$elements.state.val(state);
			$elements.postcode.val(postcode).trigger("change");
			$elements.suburb.val(suburb);

			setState(state);
		} else if (meerkat.site.isFromBrochureSite) {
			//Crappy input which doesn't get validated on brochureware quicklaunch should be cleared as they didn't get the opportunity to see results via typeahead on our side.
			$elements.location.val("");
		}
	}

	function setState (state) {
		_state = state;
	}

	//return readable values
	function returnCover() {
		return $('#health_situation_healthCvr option:selected').text();
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
		returnCover: returnCover,
		returnCoverCode: returnCoverCode,
		setCover: setCover,
		setLocation: setLocation,
		setState: setState,
		shouldPerformUpdate: shouldPerformUpdate
	});

})(jQuery);