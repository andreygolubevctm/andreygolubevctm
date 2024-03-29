;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var events = {
			simplesInterface: {
				TRANSACTION_ID_CHANGE: 'TRANSACTION_ID_CHANGE'
			}
		},
		moduleEvents = events.simplesInterface;

	var $iframe = $('#simplesiframe'),
        $simplesCalendar = $('.simples-calendar .icon-calendar');

	function resizeIframe() {
		if ($iframe.length === 0) return;

		var buffer = 8; //scroll bar buffer
		var height = window.innerHeight || document.body.clientHeight || document.documentElement.clientHeight;
		height -= $iframe.position().top + buffer;
		height = (height < 50) ? 50 : height;
		$iframe.height(height); // + 'px';

		//log('resizeIframe', height);
	}

	//
	// Get transaction ID posted from iframe
	//
	function receiveMessage(event) {
		try {
			if (event.data.eventType === 'transactionId') {
				//log('Received tranId', event.data.transactionId);
				meerkat.messaging.publish(moduleEvents.TRANSACTION_ID_CHANGE, event.data.transactionId);
			}
		}
		catch(e) {
			log('Error receiving postMessage', e);
		}
	}

	function init() {
		// Make the iframe fit the space remaining after the header
		$(document).ready(resizeIframe);

		$(window).resize(_.debounce(resizeIframe));

		// Listen for messages from journey in iframe
		if (window.addEventListener) {
			window.addEventListener('message', receiveMessage, false);
		}


        $(document).ready(function() {
            // Load time date
            meerkat.modules.timeDate.initTimeDate($('.time-date-holder'));

            // Setup calendar to today
            $simplesCalendar.datepicker('update', new Date().toLocaleDateString());

			// On iframe load
            $iframe.on('load', function() {
                var $framebody = $iframe.contents().find('body');

				// Hide datepicker on iframe click
                $framebody.on('click', function () {
                    $simplesCalendar.datepicker('hide');
                });
            });
        });
	}



	meerkat.modules.register('simplesInterface', {
		init: init,
		events: events
	});

})(jQuery);
