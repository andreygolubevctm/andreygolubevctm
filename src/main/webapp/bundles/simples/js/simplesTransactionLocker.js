/*

	Tickle me, Elmo.

*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var currentTransactionId = 0,
		intervalSeconds = 60, /* 1 minute */
		timer;


	function init() {
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
		log('Locker started @ ' + _intervalSeconds + ' second interval.');
	}

	function stop() {
		clearInterval(timer);
		log('Locker stopped.');
	}

	/**
	 * Makes a call to the server to touch the session and keep it alive.
	 * Additionally, try to send an active transaction ID to keep it fresh in the session cache.
	 */
	function tickle() {
		if(currentTransactionId > 0) {
			meerkat.modules.comms.get({
				url: 'simples/transactions/lock.json',
				cache: false,
				errorLevel: 'silent',
				useDefaultErrorHandling: false,
				timeout: 5000,
				data: {
					transactionId: currentTransactionId
				},
                onSuccess: function onSuccess(json) {
                    if (json.hasOwnProperty('status') && json.status === 'OK') {
                        // un-hide the unlock button only when the lock is down
                        $('a.action-unlock').removeClass('hidden');
                    }
                },
				onError: function onError(obj, txt, errorThrown) {
					meerkat.modules.errorHandling.error({
						page: "simplesTransactionLocker.js",
						errorLevel: "silent",
						description: "failed to update lock " + txt,
						data: errorThrown
					});
				}
			});
		}
	}

    function unlock() {
        if(currentTransactionId > 0) {
            meerkat.modules.comms.get({
                url: 'simples/transactions/unlock.json',
                cache: false,
                errorLevel: 'silent',
                useDefaultErrorHandling: false,
                timeout: 5000,
                data: {
                    transactionId: currentTransactionId
                },
                onSuccess: function onSuccess(json) {
                    if (json.hasOwnProperty('status') && json.status === 'OK') {
                        alert('Quote: ' + currentTransactionId + ' is unlocked...\n You should close this quote ASAP so other operators can start amending the quote.');
                        // hide it as we don't need it anymore, if user leave the tab open, it will come back again from the lock.json
                        $('a.action-unlock').addClass('hidden');
                        return;
                    }
                    alert('Could not unlock quote: ' + currentTransactionId);
                },
                onError: function onError(obj, txt, errorThrown) {
                    alert('Could not unlock the quote...\n' + txt + ': ' + errorThrown);
                    meerkat.modules.errorHandling.error({
                        page: "simplesTransactionLocker.js",
                        errorLevel: "silent",
                        description: "failed to unlock " + txt,
                        data: errorThrown
                    });
                }
            });
        }
    }



	meerkat.modules.register('simplesTransactionLocker', {
		init: init,
		start: start,
		stop: stop,
        unlock: unlock
	});

})(jQuery);
