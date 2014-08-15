/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;


	function initCarCommencementDate() {

		var self = this;

		$(document).ready(function() {

			// Only init if CAR... obviously...
			if (meerkat.site.vertical !== "car")
				return false;

			// Set defaults for new and retrieve quotes
			if ($('#quote_options_commencementDate').val() !== '') {
				$('#quote_options_commencementDateDropdown_mobile').val($('#quote_options_commencementDate').val());
			}

			if ($('#quote_options_commencementDateDropdown_mobile').val() == null) {
				$('#quote_options_commencementDateDropdown_mobile').val('');
			}

		});

		$("#quote_options_commencementDate").on('change', function(event) {
			$('#quote_options_commencementDateDropdown_mobile').val($('#quote_options_commencementDate').val());
			// If the date is invalid for the, default the dropdown to "Please choose..."
			if ($('#quote_options_commencementDateDropdown_mobile').val() == null) {
				$('#quote_options_commencementDateDropdown_mobile').val('');
			}
		});

		$("#quote_options_commencementDate").attr('data-attach', 'true'); // Always allow this value to be collected even if hidden

		$("#quote_options_commencementDateDropdown_mobile").on('change', function(event) {
			$('#quote_options_commencementDate').val($('#quote_options_commencementDateDropdown_mobile').val());
			// Need to blur to validate the datepicker.
			$('#quote_options_commencementDate').blur();
			// Need to keyup to fire the event that highlights the correct date in the datepicker.
			$('#quote_options_commencementDate').keyup();
		});
	}

	meerkat.modules.register("carCommencementDate", {
		init : initCarCommencementDate
	});

})(jQuery);