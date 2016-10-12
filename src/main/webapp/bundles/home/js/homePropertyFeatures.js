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
	var $hasSecurity = $('input[name=home_property_hasSecurity]'),
		$securityFeatures = $('.securityFeatures');

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

	function toggleSecurityOptions(show) {
		if (show) {
			$securityFeatures.slideDown(200);
		} else {
			$securityFeatures.slideUp(200);
		}
	}

	function applyEventListeners() {
		$hasSecurity.on('change', function() {
			var hasSecurity = $(this).val();

			toggleSecurityOptions(hasSecurity === 'Y');

			// if no, uncheck checked features
			if (hasSecurity === 'N') {
				if ($securityFeatures.find(':input:checked').length > 0) {
					$securityFeatures.find(':input:checked').prop('checked', false).attr('checked', false);
				}
			} else {
				// else clean up validation
				$securityFeatures.find('.has-error, .has-success').removeClass('has-error has-success');
				$securityFeatures.find('.error-field').remove();
			}
		});
	}

	/* main entrypoint for the module to run first */
	function initHomePropertyFeatures() {
		if(!initialised) {
			initialised = true;
			log("[HomePropertiesFeatures] Initialised"); //purely informational
			toggleSecurityFeatures(0);
			applyEventListeners();

			if ($securityFeatures.find('input[type=checkbox]').is(':checked')) {
				$('#home_property_hasSecurity_Y').prop('checked', true).attr('checked', 'checked').change();
			} else {
				if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
					$('#home_property_hasSecurity_N').prop('checked', true).attr('checked', 'checked').change();
				}

			}
		}
	}

	meerkat.modules.register('homePropertyFeatures', {
		initHomePropertyFeatures: initHomePropertyFeatures, //main entrypoint to be called.
		toggleSecurityFeatures: toggleSecurityFeatures,
		events: moduleEvents //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);