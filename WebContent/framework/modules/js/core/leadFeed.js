;(function($, undefined){

	/**
	 * leadFeed provides a common gateway for the framework to submit lead feeds.
	 *
	 * It is presently just a basic ajax call however it can be extended later
	 * as needed. Better to have this functionality common.
	 **/

	var meerkat = window.meerkat,
		meerkatEvents =  meerkat.modules.events,
		events = {};

	function init(){
		// Nothing to be done
	}

	/**
	 * generate - submits data provided to the lead feed routing end point.
	 * Default settings are implemented however these can over overriden at will.
	 * @param data
	 * @param settings
	 */
	function generate(data, settings) {
		settings = settings || {};
		var request_obj = {
			url: "leadfeed/" + data.vertical + "/getacall.json",
			data: data,
			dataType: 'json',
			cache: false,
			useDefaultErrorHandling: false,
			numberOfAttempts: 3,
			errorLevel: "silent"
		}
		if(!_.isObject(settings) && !_.isEmpty(settings)) {
			request_obj = $.extend(request_obj, settings);
		}
		meerkat.modules.comms.post(request_obj);
	}

	meerkat.modules.register("leadFeed", {
		init: init,
		events: events,
		generate: generate
	});

})(jQuery);