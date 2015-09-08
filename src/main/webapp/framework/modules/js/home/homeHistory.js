/**
 * Cover History Logic
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	/* Variables */
	var initialised = false;
	var elements = {
			name:					"home_disclosures",
			atCurrentAddress:		".atCurrentAddress",
			pastInsurer:			".pastInsurer",
			insuranceExpiry:		".insuranceExpiry",
			insuranceCoverLength:	".insuranceCoverLength"
	};

	/* Here you put all functions for use in your module */
	function toggleHistoryFields(speed){

		if( $('input[name='+elements.name+'_previousInsurance]:checked').val() == 'Y' ){
			$(elements.atCurrentAddress+', '+elements.pastInsurer+', '+elements.insuranceExpiry+', '+elements.insuranceCoverLength).slideDown(speed);
		} else {
			$(elements.atCurrentAddress+', '+elements.pastInsurer+', '+elements.insuranceExpiry+', '+elements.insuranceCoverLength).slideUp(speed);
		}

	}

	function applyEventListeners() {
		$('input[name='+elements.name+'_previousInsurance]').on('change', function prevInsChange(){
			toggleHistoryFields();
		});
	}

	/* main entrypoint for the module to run first */
	function initHomeHistory() {
		if(!initialised) {
			initialised = true;
			log("[HomeHistory] Initialised"); //purely informational
			applyEventListeners();
			toggleHistoryFields(0);
		}
	}

	meerkat.modules.register('homeHistory', {
		initHomeHistory: initHomeHistory //main entrypoint to be called.
	});

})(jQuery);

