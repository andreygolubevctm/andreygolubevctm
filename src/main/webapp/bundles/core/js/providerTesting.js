;(function($, undefined){

	/**
	 * leadFeed provides a common gateway for the framework to submit lead feeds.
	 *
	 * It is presently just a basic ajax call however it can be extended later
	 * as needed. Better to have this functionality common.
	 **/

	var meerkat = window.meerkat;

	function init() {
		$(document).ready(function($) {
			if($('#provider-testing-key-required').length) {
				meerkat.modules.dialogs.show({
					htmlContent: $('#provider-testing-key-required').html(),
					onOpen: function(modalId) {
						$("#" + modalId).find('.modal-closebar').remove();
						$("#" + modalId).off('click');
					}
				});
			}
		});
	}

	meerkat.modules.register("providerTesting", {
		init: init
	});

})(jQuery);