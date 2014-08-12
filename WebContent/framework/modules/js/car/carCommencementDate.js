/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	var elements = {
			input:		"#quote_options_commencementDate",
			calendar:	"#quote_options_commencementDate_calendar"
	};

	function initCarCommencementDate() {

		var self = this;

		_.extend(meerkat.site, {commencementDateRange:commencementDateSettings});

		$(document).ready(function() {

			// Only init if CAR... obviously...
			if (meerkat.site.vertical !== "car")
				return false;

			if(meerkat.site.hasOwnProperty('commencementDate') && !_.isEmpty(meerkat.site.commencementDate)) {
				var min = new Date(meerkat.modules.utilities.invertDate(meerkat.site.commencementDateRange.min));
				var max = new Date(meerkat.modules.utilities.invertDate(meerkat.site.commencementDateRange.max));
				var now = new Date(meerkat.modules.utilities.invertDate(meerkat.site.commencementDate));
				if(now.getTime() < min.getTime() || now.getTime() > max.getTime()){
					meerkat.site.commencementDate = '';
					$(elements.input).val('');
				}
			}

			$(elements.calendar)
			.datepicker({ clearBtn:false, format:"dd/mm/yyyy"})
			.datepicker('setStartDate', meerkat.site.commencementDateRange.min)
			.datepicker('setEndDate', meerkat.site.commencementDateRange.max)
			.datepicker("update", meerkat.site.commencementDate)
			.on("changeDate", function updateStartCoverDateHiddenField(e) {
				$(elements.input).val( e.format() );
			});
		});

	}

	meerkat.modules.register("carCommencementDate", {
		init : initCarCommencementDate,
		events : moduleEvents
	});

})(jQuery);