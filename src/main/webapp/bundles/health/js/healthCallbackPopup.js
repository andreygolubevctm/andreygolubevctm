;(function($, undefined){

	var meerkat = window.meerkat;

	var timeout = 0,
		dontShow = false;
		isModalOpen = false,
		isMobile = false;
			
	function init() {
		var isMobile = meerkat.modules.performanceProfiling.isMobile();
		
		if(meerkat.site.callbackPopup.enabled === 'Y') {
			idle = setInterval(count, 1000);
		}

		subscription();
	}

    function subscription() {

        $(document).on('click', '#health-callback-popup .close-popup', function(e) {
        	e.preventDefault();
            hideModal();
        });

    	if(meerkat.site.callbackPopup.timeoutMouseEnabled === 'Y') {
	        $(document).on('mousemove', function (e) {
		        reset();
		    });
    	}

    	if(meerkat.site.callbackPopup.timeoutKeyboardEnabled === 'Y') {
	        $(document).on('keypress', function (e) {
		        reset();
		    });
	    }

    	if(meerkat.site.callbackPopup.timeoutStepEnabled === 'Y') {
	        meerkat.messaging.subscribe(meerkat.modules.events.journeyEngine.BEFORE_STEP_CHANGED, function showPopupOnJourneyReadySubscription() {
	            _.defer(function() {
	                reset();
	            });
	        });
	    }

        meerkat.messaging.subscribe(meerkat.modules.events.callbackModal.CALLBACK_MODAL_OPEN, function showPopupOnModalOpenSubscription() {
            dontShow = true;
        });

    }

	function count() {
		timeout += 1;
		if(!dontShow && timeout === meerkat.site.callbackPopup.timeout) {
			showModal();
		}
	}
	
	function reset() {
		timeout = 0;
	}

	function showModal() {
		if(!isModalOpen  && !isMobile) {
			isModalOpen = true;
			
			
			var htmlTemplate = _.template($('#callback-popup').html());
	        $('body').append(htmlTemplate());
			$('#health-callback-popup').addClass(meerkat.site.callbackPopup.position);
		}
	}

	function hideModal() {
		isModalOpen = false;
		setDontShow();
		$('#health-callback-popup').remove();
		reset();
	}

	function setDontShow() {
		dontShow = true;
	}

	meerkat.modules.register("healthCallbackPopup", {
		init: init,
		reset: reset
	});

})(jQuery);