;(function($, undefined){

	//
	// The leave page warning is enabled via database settings (specific to brand/vertical - see layout:page tag). 
	// The warning is also disabled for simples users.
	//

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			leavePageWarning: {
				
			}
		},
		moduleEvents = events.leavePageWarning;

	var safeToLeave = true;

	function initLeavePageWarning() {

		if(meerkat.site.leavePageWarning.enabled && meerkat.site.isCallCentreUser === false && meerkat.modules.performanceProfiling.isIE8() === false && meerkat.modules.performanceProfiling.isIE9() === false){
			
			window.onbeforeunload = function(){ 

				if(safeToLeave === false && meerkat.modules.saveQuote.isAvailable() === true){			
					return meerkat.site.leavePageWarning.message;
				}else{
					return ;
				}				
			}

			meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange( step ){
				safeToLeave = false;
			});

			meerkat.messaging.subscribe(meerkatEvents.saveQuote.QUOTE_SAVED, function quoteSaved(){
				safeToLeave = true;
			});	

		}	

	}

	function disable(){
		safeToLeave = true;
	}

	meerkat.modules.register("leavePageWarning", {
		init: initLeavePageWarning,
		events:events,
		disable:disable
	});

})(jQuery);