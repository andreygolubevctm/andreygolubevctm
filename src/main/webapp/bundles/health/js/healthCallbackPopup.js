;(function($, undefined){

	var meerkat = window.meerkat;

	var isActive = false,
		isModalOpen = false,
		isMobile = false,
		steps = [],
		intervalId,
		hasDisplayedTimedCallBack = false;
			
	function init() {
		if (meerkat.site.callbackPopup.enabled === true && meerkat.site.pageAction !== "confirmation") {

			isMobile = meerkat.modules.performanceProfiling.isMobile();
			var navigationId = meerkat.modules.address.getWindowHash().split("/")[0];

			setActive(!meerkat.site.isCallCentreUser);

			if (meerkat.site.callbackPopup.timeoutStepEnabled) {
				steps = meerkat.site.callbackPopup.steps.split(',');
				if(_.indexOf(steps, navigationId) >= 0) {
					setActive(true);
				}
			}
			startTimer();
			subscription();

		}
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

					hideModal();
	            	if(_.indexOf(steps, navigationId) >= 0 && !hasDisplayedTimedCallBack) {
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

	function displayCallBackModal() {
		showModal();
		clearInterval(intervalId);
		hasDisplayedTimedCallBack = true;
	}

	function startTimer(){
		if(isActive && typeof meerkat.site.callbackPopup.timeout !== 'undefined' && !hasDisplayedTimedCallBack) {
			var interval = meerkat.site.callbackPopup.timeout * 1000;
			intervalId = setInterval(displayCallBackModal, interval);
		}
	}

	function reset() {
		clearInterval(intervalId);
		startTimer();
	}

	function showModal() {
		if(isActive && !isModalOpen && !isMobile) {

            setModalState(false);

            if ($('#callback-popup').html()) {
                setModalState(true);
                var htmlTemplate = _.template($('#callback-popup').html());
                $('body').append(htmlTemplate());
                $('#health-callback-popup').addClass(meerkat.site.callbackPopup.position);
            }

		}
	}

	function hideModal() {
		setModalState(false);
		setActive(false);
		$('#health-callback-popup').remove();
		clearInterval(intervalId);
	}

	function setActive(value) {
		isActive = value;
	}

	function setModalState(value) {
		isModalOpen = value;
	}

	function trigger(){
		if(_.indexOf(['localhost','nxi','nxq'], meerkat.site.environment.toLowerCase()) !== -1) {
			isActive = !meerkat.site.isCallCentreUser;
			displayCallBackModal();
		}
	}

	meerkat.modules.register("healthCallbackPopup", {
		init: init,
		trigger:trigger
	});

})(jQuery);