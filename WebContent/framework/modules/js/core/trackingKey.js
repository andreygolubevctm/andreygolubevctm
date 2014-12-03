;(function($, undefined){

	/**
	 * renderindMode listens to the journeyEngine READY & STEP_CHANGED events to update a hidden field. If the hidden field doesn't exist
	 * the code will inject the hidden field
	 *
	 * Since this is in core, this will allow all AMS verticals to automatically pickup the renderingMode xpath for debugging purposes as some
	 * devices like MS Surface can render both XS & MD(?) breakpoints
	 **/

	var meerkat = window.meerkat,
		meerkatEvents =  meerkat.modules.events,
		trackingKey = null,
		$trackingKeyFld = null;


	function init(){

		$(document).ready(function(){

			// Only action if page has results content IE ResultsModel exists
			if(typeof ResultsModel != 'undefined') {

				var prefix = meerkat.site.vertical == 'car' ? 'quote' : meerkat.site.vertical;
				var name = prefix + '_trackingKey';

				$trackingKeyFld = $('#' + name);

				// Add field to form is doesn't exist
				if (!$trackingKeyFld.length) {
					$('#mainform').append(
						$('<input />',{
							id		: name,
							name	: name,
							value	: trackingKey
						})
						.attr('type', 'hidden')
						.attr('data-autosave', 'true')
					);
				} else {
					var key = $trackingKeyFld.val();
					if(!_.isEmpty(key)) {
						set(key);
					}
				}

				// Listen for new results data - trigger for new trackingKey
				meerkat.messaging.subscribe(ResultsModel.moduleEvents.RESULTS_UPDATED_INFO_RECEIVED, update);
			}
		});
	}

	function update(data) {
		if (data.hasOwnProperty('trackingKey')) {
			set(data.trackingKey);
		}
	}

	function set(key) {
		trackingKey = key;
		$trackingKeyFld.val(trackingKey);
	}

	function get() {
		return trackingKey;
	}

	meerkat.modules.register("trackingKey", {
		init: init,
		get: get
	});

})(jQuery);