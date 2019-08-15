(function($, undefined) {

	var meerkat = window.meerkat;

	function applyEventListeners() {}

	function init() {

		$(document).on('ready', function() {
			_.defer(function(){
				meerkat.modules.commencementDate.initCommencementDate({
					dateField :		"#home_startDate",
					getResults :	meerkat.modules.homeResults.get,
					updateData :	function updateDataWithIcon(data) {
						_.extend(data, meerkat.modules.homeEditDetails.getFormData());
					}
				});
			});
		});
	}

	meerkat.modules.register('homeCommencementDate', {
		init: init
	});

})(jQuery);