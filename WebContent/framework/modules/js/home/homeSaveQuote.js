;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {},
	moduleEvents = events;

	function getCopy(type){
		var copy = false;
		switch(type){
			case 'buttonLabel':
				copy = "Save Quote";
				break;
			case 'saveAgain':
				copy = 'Click \'Save Quote\' to update your saved quote <a href="javascript:;" class="btn btn-save saved-continue-link btn-save-quote">Save Quote</a>';
				break;
			case 'saveSuccess':
				copy = '<div class="col-xs-12"><h4>Your quote has been saved.</h4><p>To retrieve your quote <a href="' + meerkat.site.urls.base + 'retrieve_quotes.jsp" class="btn-cancel saved-continue-link btn-link">click here</a>.</p><a href="javascript:;" class="btn btn-cancel">Close</a></div>';
		}

		return copy;
	}

	meerkat.modules.register("homeSaveQuote", {
		events: events,
		getCopy: getCopy
	});

})(jQuery);