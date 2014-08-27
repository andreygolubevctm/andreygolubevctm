/*

	Tickle me, Elmo.

*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var currentTransactionId = 0,
		intervalSeconds = 300, /* 5 minutes */
		timer;



	function init() {

		// Only run if requested
		if ($('[data-provide="simples-tickler"]').length === 0) return;

		// Subscribe to the transactionId changing
		meerkat.messaging.subscribe(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, function tranIdChange(obj) {
			if (obj === undefined) {
				currentTransactionId = 0;
			}
			else {
				currentTransactionId = obj;
			}

		});

		start(intervalSeconds);
	}

	function start(_intervalSeconds) {
		var intervalMs = _intervalSeconds * 1000;

		clearInterval(timer);

		timer = setInterval(tickle, intervalMs);
		log('Tickler started @ ' + _intervalSeconds + ' second interval.');
	}

	function stop() {
		clearInterval(timer);
		log('Tickler stopped.');
	}

	/**
	 * Makes a call to the server to touch the session and keep it alive.
	 * Additionally, try to send an active transaction ID to keep it fresh in the session cache.
	 */
	function tickle() {
		meerkat.modules.comms.post({
			url: 'simples/ajax/tickle.jsp',
			cache: false,
			errorLevel: 'silent',
			useDefaultErrorHandling: false,
			timeout: 5000,
			data: {
				transactionId: currentTransactionId
			},
			onError: function onError(obj, txt, errorThrown) {

				if (obj.status === 401) {
					alert('Oh bother, it looks like your session is no longer active. Please click OK and log in again.');

					// Redirect back to login
					window.top.location.href = 'simples.jsp';
				}
				else {
					alert('Something bad happened when trying to keep your session active. If this occurs again please restart your browser.');
				}
			}
		});
	}



	meerkat.modules.register('simplesTickler', {
		init: init,
		start: start,
		stop: stop
	});

})(jQuery);
