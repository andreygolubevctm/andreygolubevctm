;(function($, undefined){

	var meerkat = window.meerkat;

	var timeout = 0,
		isActive = false;
		isModalOpen = false,
		isMobile = false,
		steps = [];
			
	function init() {
		var isMobile = meerkat.modules.performanceProfiling.isMobile();
		var navigationId = meerkat.modules.address.getWindowHash().split("/")[0];
		
		if(meerkat.site.callbackPopup.enabled) {
			idle = setInterval(count, 100);
		}

        if (meerkat.site.callbackPopup.timeoutStepEnabled) {
			steps = meerkat.site.callbackPopup.steps.split(',');
	       	if(_.indexOf(steps, navigationId) >= 0) {
           		setActive(true);
           	}
        }

		subscription();
	}

    function subscription() {

        $(document).on('click', '#health-callback-popup .close-popup', function(e) {
        	e.preventDefault();
            hideModal();
        });

    	if(meerkat.site.callbackPopup.timeoutMouseEnabled) {
	        $(document).on('mousemove', function (e) {
		        reset();
		    });
    	}

    	if(meerkat.site.callbackPopup.timeoutKeyboardEnabled) {
	        $(document).on('keypress', function (e) {
		        reset();
		    });
	    }

    	if(meerkat.site.callbackPopup.timeoutStepEnabled) {
	        meerkat.messaging.subscribe(meerkat.modules.events.journeyEngine.BEFORE_STEP_CHANGED, function showPopupOnJourneyReadySubscription() {
	            _.defer(function() {
					var navigationId = meerkat.modules.address.getWindowHash().split("/")[0];

	            	if(_.indexOf(steps, navigationId) >= 0) {
	                	setActive(true);
	                	reset();
	                } else {
	                	setActive(false);
	                }
	            });
	        });
	    }

        meerkat.messaging.subscribe(meerkat.modules.events.callbackModal.CALLBACK_MODAL_OPEN, function dontShowPopupOnModalOpenSubscription() {
			setActive(false);
        });

    }

	function count() {
		timeout += 1;
		if(isActive && timeout === meerkat.site.callbackPopup.timeout) {
			showModal();
		}
	}
	
	function reset() {
		timeout = 0;
	}

	function showModal() {
		if(isActive && !isModalOpen && !isMobile) {
			setModalState(true);
			
			var htmlTemplate = _.template($('#callback-popup').html());
	        $('body').append(htmlTemplate());
			$('#health-callback-popup').addClass(meerkat.site.callbackPopup.position);
		}
	}

	function hideModal() {
		setModalState(false);
		setActive(false);
		$('#health-callback-popup').remove();
		reset();
	}

	function setActive(value) {
		isActive = value;
	}

	function setModalState(value) {
		isModalOpen = value;
	}

	meerkat.modules.register("healthCallbackPopup", {
		init: init,
		reset: reset
	});

})(jQuery);