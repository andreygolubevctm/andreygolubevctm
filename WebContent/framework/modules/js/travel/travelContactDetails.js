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
				$firstname.attr('required', 'required').valid();
				$surname.attr('required', 'required').valid();
				$email.attr('required', 'required').valid();
			} else {
				$firstname.removeAttr('required').valid();
				$surname.removeAttr('required').valid();
				$email.removeAttr('required').valid();
			}
		});
	}

	function init(){
		
		//Elements need to be in the page
		$(document).ready(function() {
			$firstname = $('#travel_firstName');
			$surname = $('#travel_surname');
			$email = $('#travel_email'); 
			$marketing = $('#travel_marketing');

			$firstname.removeAttr('required'); 
			$surname.removeAttr('required');
			$email.removeAttr('required');

			applyEventListeners();
		});
	}

	meerkat.modules.register("travelContactDetails", {
		init: init
	});

})(jQuery);