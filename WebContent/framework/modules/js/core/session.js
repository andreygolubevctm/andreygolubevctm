;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	// TODO - migrate code from session_pop.tag in to this module.

	function initSession() {

	}

	function poke() {
		sessionExpiry.poke();
	}

	function setTimeoutLength(timeout) {
		sessionExpiry._timeoutLength = timeout;
		sessionExpiry.init();
	}

	meerkat.modules.register("session", {
		init: initSession,
		poke: poke,
		setTimeoutLength: setTimeoutLength
	});

})(jQuery);