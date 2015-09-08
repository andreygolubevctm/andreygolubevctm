/**
 * Property Features set logic
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	/* Variables */
	var initialised = false;
	var elements = {
			name:				'#home_property',
			coverType:			'#home_coverType'

	};

	function toggleSecurityFeatures(speed){

		var coverType = $(elements.coverType).find('option:selected').val();
		switch(coverType){
			case "Contents Cover Only":
			case "Home & Contents Cover":
				$(elements.name).slideDown(speed);
			break;
			default:
				$(elements.name).slideUp(speed);
		}

	}
	/* main entrypoint for the module to run first */
	function initHomePropertyFeatures() {
		if(!initialised) {
			initialised = true;
			log("[HomePropertiesFeatures] Initialised"); //purely informational
			toggleSecurityFeatures(0);
		}
	}

	meerkat.modules.register('homePropertyFeatures', {
		initHomePropertyFeatures: initHomePropertyFeatures, //main entrypoint to be called.
		toggleSecurityFeatures: toggleSecurityFeatures,
		events: moduleEvents //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);