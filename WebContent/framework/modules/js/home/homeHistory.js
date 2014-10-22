/**
 * Cover History Logic
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	/* Variables */
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
		$(document).ready(function() {
			$('input[name='+elements.name+'_previousInsurance]').on('change', function(){
				toggleHistoryFields()
			});
		});
	}
	/* main entrypoint for the module to run first */
	function initHomeHistory() {
		log("[HomeHistory] Initialised"); //purely informational
		applyEventListeners();
		$(document).ready(function() {
			toggleHistoryFields(0);
		});
	}

	meerkat.modules.register('homeHistory', {
		initHomeHistory: initHomeHistory, //main entrypoint to be called.
		events: moduleEvents //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);

