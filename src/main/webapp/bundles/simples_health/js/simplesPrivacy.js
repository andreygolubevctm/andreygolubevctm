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
    	if(pauseRecordingOverrideEnabled && !$('#health_pauseRecordingOverride').length) {
		    // Add hidden field to track affected transactions
		    $('#paymentForm').append(
			    $('<input/>',{
			    	type: 'hidden',
				    id: 'health_pauseRecordingOverride',
				    name: 'health_pauseRecordingOverride',
				    value: 'Y'
			    }).prop('data-attach', true)
		    );
		    // Ensure form is written immediately to db (albeit deferred momentarily)
		    _.defer(function() {
		    	meerkat.messaging.publish('TRACKING_TOUCH', {
				    touchType: 'H',
				    touchComment: 'Override',
				    includeFormData: true,
				    productId: null,
				    callback: null,
				    customFields: null
			    });
		    });
	    }
        return pauseRecordingOverrideEnabled || meerkat.modules.healthAppCompliance.callback(state);
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