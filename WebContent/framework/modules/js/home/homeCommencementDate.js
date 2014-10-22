(function($, undefined) {

	var meerkat = window.meerkat;

	var $desktopField = $('#home_startDate');
	var $mobileField = $('#home_startDateDropdown_mobile');

	function applyEventListeners() {

		$desktopField.on('change', function changeCommDate(event) {
			$mobileField.val($desktopField.val());

			// If the date is invalid for the, default the dropdown to "Please choose..."
			if ($mobileField.val() == null) {
				$mobileField.val('');
			}
		});

		$mobileField.on('change', function changeCommDate(event) {
			// Need to blur to validate the datepicker.
			// Need to keyup to fire the event that highlights the correct date in the datepicker.
			$desktopField.val($mobileField.val()).blur().keyup();
		});
	}

	function init() {
		$(document).ready(function() {

			// Only init on correct vertical
			if (meerkat.site.vertical !== 'home') {
				return false;
			}

			// Set defaults for new and retrieve quotes
			if ($desktopField.val() !== '') {
				$mobileField.val($desktopField.val());
			}

			if ($mobileField.val() == null) {
				$mobileField.val('');
			}

		});
		// Always allow this value to be collected even if hidden
		$desktopField.attr('data-attach', 'true');

		applyEventListeners();
	}

	meerkat.modules.register('homeCommencementDate', {
		init: init
	});

})(jQuery);