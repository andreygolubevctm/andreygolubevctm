/*
 *
 * Handling of the contact details
 *
*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		$firstname,
		$surname,
		$email,
		$marketing;



	function applyEventListeners(){

		$marketing.on('change', function() {

			if ($(this).is(':checked')) {
				$email.attr('required', 'required').valid();
			} else {
				$email.removeAttr('required').valid();
			}
		});
	}

	function init(){
		
		//Elements need to be in the page
		$(document).ready(function() {
			$email = $('#travel_email'); 
			$marketing = $('#travel_marketing');

			$email.removeAttr('required');

			applyEventListeners();
		});
	}

	meerkat.modules.register("travelContactDetails", {
		init: init
	});

})(jQuery);