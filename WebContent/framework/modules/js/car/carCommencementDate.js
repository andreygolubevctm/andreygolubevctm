/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	function initCarCommencementDate() {

		$(document).ready(function() {

			meerkat.modules.commencementDate.initCommencementDate({
				dateField :		"#quote_options_commencementDate",
				getResults :	meerkat.modules.carResults.get,
				updateData :	function updateDataWithYoungDriver(data) {
					_.extend(data, {
						youngDriver : $('input[name=quote_drivers_young_exists]:checked').val()
					});
				}
			});

		});
	}

	meerkat.modules.register("carCommencementDate", {
		init : initCarCommencementDate
	});

})(jQuery);