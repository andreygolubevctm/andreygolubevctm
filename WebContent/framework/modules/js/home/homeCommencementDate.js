(function($, undefined) {

	var meerkat = window.meerkat;

	var $desktopField = $('#home_startDate');

	function applyEventListeners() {}

	function init() {
		$(document).ready(function() {

			// Only init on correct vertical
			if (meerkat.site.vertical !== 'home') {
				return false;
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