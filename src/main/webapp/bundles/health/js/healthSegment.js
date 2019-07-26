;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		debug = meerkat.logging.debug,
		exception = meerkat.logging.exception;

	var currentSegments = false;

	function filterSegments() {		
		meerkat.modules.comms.get({
			url: 'segment/filter.json',
			cache: false,
			errorLevel: 'silent',
			dataType: 'json',
			useDefaultErrorHandling: false
		})
		.then(function onSuccess(json) {
			setCurrentSegments(json);
			hideBySegment();
		})
		.catch(function onError(obj, txt, errorThrown) {
			exception(txt + ': ' + errorThrown);
		});
	}

	function hideBySegment() {
		if (currentSegments.hasOwnProperty('segments') && currentSegments.segments.length > 0){
			_.each(currentSegments.segments, function(segment) {
				if (canHide(segment) === true) {
					$('.' + segment.classToHide).css("visibility", "hidden");
				}
			});
		}
	}

	function isSegmentsValid(segment) {
		if (!segment.hasOwnProperty('segmentId') || isNaN(segment.segmentId) || segment.segmentId <= 0) {
			debug("Segment is not valid");
			return false;
		}

		if (segment.hasOwnProperty('errors') && segment.errors.length > 0) {
			debug(segment.errors[0].message);
			return false;
		}

		return true;
	}

	function canHide(segment) {
		if (isSegmentsValid(segment) !== true) return false;
		if (!segment.hasOwnProperty('canHide') || segment.canHide !== true) return false;
		if (!segment.hasOwnProperty('classToHide') || segment.classToHide.length === 0 || !$.trim(segment.classToHide)) return false;
		return true;
	}

	function getCurrentSegments() {
		return currentSegments;
	}

	function setCurrentSegments(segments) {
		currentSegments = segments;
	}

	meerkat.modules.register("healthSegment", {
		filterSegments: filterSegments,
		hideBySegment: hideBySegment
	});

})(jQuery);