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
	// Default to showing the alert, except on confirmation pages or generic verticals.
	var safeToLeave = true;

	function initLeavePageWarning() {

		var supportsUnload = !meerkat.modules.performanceProfiling.isIos() && !meerkat.modules.performanceProfiling.isIE8() && !meerkat.modules.performanceProfiling.isIE9() && !meerkat.modules.performanceProfiling.isIE10();

		$(document).ready(function() {
			safeToLeave = meerkat.site.vertical === 'generic' || meerkat.site.pageAction == 'confirmation' ? true : false;

			if(supportsUnload === false && $('#js-logo-link').length) {
				$('#js-logo-link').on('click', function(e) {
					meerkat.modules.leavePageWarning.disable();
					if(!confirm(fetchMessage())) {
						return false;
					}
				});
			}

			window.addEventListener('ca_signout', (e) => {
				disable();
				location.reload();
			}, false);
		});


		if(meerkat.site.leavePageWarning.enabled && meerkat.site.isCallCentreUser === false && supportsUnload === true){

			window.onbeforeunload = function() {

				if(safeToLeave === false) {
					return fetchMessage();
				} else {
					return;
				}
			};

			meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange( step ){
				safeToLeave = false;
			});

			if(meerkatEvents.saveQuote) {
				meerkat.messaging.subscribe(meerkatEvents.saveQuote.QUOTE_SAVED, function quoteSaved() {
					safeToLeave = true;
				});
			}

		}

	}

	function fetchMessage() {
		if(meerkat.modules.saveQuote && meerkat.modules.saveQuote.isAvailable() === true) {
			return meerkat.site.leavePageWarning.message;
		} else {
			if (typeof meerkat.site.leavePageWarning.defaultMessage !== 'undefined') {
				return meerkat.site.leavePageWarning.defaultMessage;
			}
			return;
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