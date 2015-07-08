/*
 *
 * Handling of the start page
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

	/**
	 * Pass the element container to hide
	 * makeVisible: true will show it, false will hide it.
	 */
	function toggleView($el, makeVisible) {
		if(makeVisible) {
			$el.addClass('show_Y').removeClass('show_N show_');
		} else {
			$el.addClass('show_N').removeClass('show_Y show_');
		}

	}

	function init(){

		//Elements need to be in the page
		$(document).ready(function() {
			$firstname = $('#competition_contact_firstName');
			$surname = $('#competition_contact_lastName');
			$email = $('#competition_contact_email');
			$marketing = $('#competition_contact_optIn');

			$firstname.removeAttr('required');
			$surname.removeAttr('required');
			$email.removeAttr('required');

			applyEventListeners();

		});
	}

	meerkat.modules.register("competitionStart", {
		init: init
	});

})(jQuery);