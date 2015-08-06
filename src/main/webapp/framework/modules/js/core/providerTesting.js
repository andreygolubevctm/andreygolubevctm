;(function($, undefined){

	/**
	 * leadFeed provides a common gateway for the framework to submit lead feeds.
	 *
	 * It is presently just a basic ajax call however it can be extended later
	 * as needed. Better to have this functionality common.
	 **/

	var meerkat = window.meerkat,
		meerkatEvents =  meerkat.modules.events,
		events = {};

	function init() {
		jQuery(document).ready(function($) {
			if($('#provider-testing-key-required').length) {
				meerkat.modules.dialogs.show({
					htmlContent: $('#provider-key-required').html(),
					className: 'provider-testing-key-required',
					onOpen: function(modalId) {
						$("#" + modalId).find('.modal-closebar').remove();
						$("#" + modalId).off('click');
					}
				});
			}
		});
	}

	meerkat.modules.register("providerTesting", {
		init: init,
		events: events
	});

})(jQuery);