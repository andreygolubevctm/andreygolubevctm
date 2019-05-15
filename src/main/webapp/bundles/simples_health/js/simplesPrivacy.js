;(function ($, undefined) {

    var meerkat = window.meerkat;

    var events = {};

    var pauseRecordingOverrideEnabled = false;

    var togglePrivacyClass = "privacy-off";

    function init() {

        /**
         * Only for call center users.
         */
        if(!meerkat.site.isCallCentreUser) {
            return;
        }

        if(meerkat.site.pauseRecordingOverride.enabled) {
	        pauseRecordingOverrideEnabled = true;
        }

        $(document).ready(function () {
            $('.agg_privacy').on('click', '.agg_privacy_button', function (event) {
                event.preventDefault();
                toggle($(this));
            });
        });
    }

    function callback(state) {
    	// Handle when db override turns off pause recording checks
    	if(pauseRecordingOverrideEnabled && !$('#health_pauseRecordingOverride').length) {
		    injectTrackingElement('health_pauseRecordingOverride');
		    triggerTouchEvent('Pause Recording Override');
		    return pauseRecordingOverrideEnabled;
	    } else {
		    // Attempt pause recording check
		    var callbackResult = meerkat.modules.healthAppCompliance.callback(state);
		    if($('#health_pauseRecordingFAILED').length) {
		    	// Always remove any existing tracking element
		    	$('#health_pauseRecordingFAILED').remove();
		    }
		    if (callbackResult !== true) {
			    injectTrackingElement('health_pauseRecordingFAILED');
			    triggerTouchEvent('Pause Recording Failed');
		    }
		    return callbackResult;
	    }
    }

    function injectTrackingElement(id) {
	    $('#paymentForm').append(
		    $('<input/>',{
			    type: 'hidden',
			    id: id,
			    name: id,
			    value: 'Y'
		    }).prop('data-attach', true)
	    );
    }

    function triggerTouchEvent(comment) {
	    _.defer(function() {
		    meerkat.messaging.publish('TRACKING_TOUCH', {
			    touchType: 'H',
			    touchComment: comment,
			    includeFormData: true,
			    productId: null,
			    callback: null,
			    customFields: null
		    });
	    });
    }

    function toggle($_obj) {
        var $_parent = $($_obj).closest('.agg_privacy');
        var $_body = $('body');
        var state = !$_body.hasClass(togglePrivacyClass);
        //Check the callback
        if (callback(state) !== true) {
            return false;
        }
        // This turns on/off the privacy control
        if (state === true) {
            show($_parent, $_body);
        } else {
            hide($_parent, $_body);
        }
    }

    function show($_parent, $_body) {
        $_body.addClass(togglePrivacyClass);
        $_parent.find('.agg_privacy_button span').html('Resume Recording');
    }

    function hide($_parent, $_body) {
        $_body.removeClass(togglePrivacyClass);
        $_parent.find('.agg_privacy_button span').html('Pause Recording');
    }

    meerkat.modules.register('simplesPrivacy', {
        init: init,
        events: events
    });

})(jQuery);