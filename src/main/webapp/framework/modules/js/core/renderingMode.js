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
		$renderingModeFld;


	function init(){
		// the check below occurs because this code can be executed before the site config stuff is set
		if (typeof meerkat.site === 'undefined') { return; }
		if (meerkat.site.pageAction == 'confirmation') { return; }

		// to record what the device rendering mode is
		var fld = meerkat.site.vertical == 'car' ? 'quote' : meerkat.site.vertical;
		$renderingModeFld = $('#'+fld+'_renderingMode');

		if (!$renderingModeFld.length) {
			// inject the field if it doesn't exist
			$('#mainform').append('<input type="hidden" name="'+fld+'_renderingMode" id="'+fld+'_renderingMode" class="" value="'+meerkat.modules.deviceMediaState.get()+'" data-autosave="true">');
		} else {
			// otherwise record the initial device rendering mode
			meerkat.messaging.subscribe(meerkatEvents.journeyEngine.READY, record);
		}

		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.BEFORE_STEP_CHANGED, record);

		// need to do this event subscription as the transition to the results page for all AMS projects go through the onAfterEnter event which 
		// does the write to the database BEFORE the hidden field is updated correctly
		meerkat.messaging.subscribe(meerkatEvents.RESULTS_INITIALISED, record);
	}

	function record() {
		$renderingModeFld.val(meerkat.modules.deviceMediaState.get());	
	}

	meerkat.modules.register("renderingMode", {
		init: init
	});

})(jQuery);