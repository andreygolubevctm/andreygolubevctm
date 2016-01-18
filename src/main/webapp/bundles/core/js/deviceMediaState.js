/* ========================================================================
 * Media query checking functions and events for JS
 * Based on ideas from:
 * http://seesparkbox.com/foundry/breakpoint_checking_in_javascript_with_css_user_values
 * http://davidwalsh.name/device-state-detection-css-media-queries-javascript
 * ======================================================================== */

//Requires underscore as _

/*
	if (getState() === 'md') {
		// Do whatever
	}
*/


;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			device: {
				RESIZE_DEBOUNCED: 'DEVICE_RESIZE_DEBOUNCED',
				STATE_CHANGE: 'DEVICE_MEDIA_STATE_CHANGE',
				STATE_ENTER_XS: 'DEVICE_STATE_ENTER_XS',
				STATE_ENTER_SM: 'DEVICE_STATE_ENTER_SM',
				STATE_ENTER_MD: 'DEVICE_STATE_ENTER_MD',
				STATE_ENTER_LG: 'DEVICE_STATE_ENTER_LG',
				STATE_LEAVE_XS: 'DEVICE_STATE_LEAVE_XS',
				STATE_LEAVE_SM: 'DEVICE_STATE_LEAVE_SM',
				STATE_LEAVE_MD: 'DEVICE_STATE_LEAVE_MD',
				STATE_LEAVE_LG: 'DEVICE_STATE_LEAVE_LG'
			}
		},
		moduleEvents = events.device;

	var previousState = false;



	// Create a method which returns device state based on css content
	function getState() {
		return $("html").css("font-family").replace(/'/g, "").replace(/\"/g, "");
	}

	function init() {

		// Get initial state when loading
		previousState = getState();

		// Listen for window resizes and report on debounce.
		$(window).resize(_.debounce(function() {
			var state = getState();

			// Announce that device has resized
			meerkat.messaging.publish(moduleEvents.RESIZE_DEBOUNCED, {previousState: previousState, state: state});

			if (state !== previousState) {
				// Announce the state change, either by JS pub/sub
				meerkat.messaging.publish(moduleEvents.STATE_CHANGE, {previousState: previousState, state: state});

				// trigger the state specific event too
				meerkat.messaging.publish(moduleEvents["STATE_ENTER_" + state.toUpperCase()]);

				if (previousState) {
					// trigger the previous state event
					meerkat.messaging.publish(moduleEvents["STATE_LEAVE_" + previousState.toUpperCase()]);
				}

				// Save the new state as current
				previousState = state;
			}
		}));

		//Just for debugging
		/*
		meerkat.messaging.subscribe(meerkat.modules.events.device.STATE_CHANGE, function deviceMediaStateChange(stateString){
			log('Device Media State:',stateString);
		});
		*/

		//log('[Modules]','deviceMediaState initialised');

	}//init()

	meerkat.modules.register("deviceMediaState", {
		init: init,
		events: events,
		get: getState
	});

})(jQuery);