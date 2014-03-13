;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	// TODO - migrate code from session_pop.tag in to this module.

	function poke(){
		sessionExpiry.poke(); // calls legacy code
	}

	function initSession() {
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange(event){
			poke();
		});
	}

	meerkat.modules.register("session", {
		init: initSession,
		poke: poke
	});

})(jQuery);