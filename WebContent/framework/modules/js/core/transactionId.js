/**
* Description: Transaction ID handler
* External documentation: 
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			transactionId: {
				CHANGED: "CHANGED"
			}
		},
		moduleEvents = events.transactionId;

	var transactionId,
		waitingOnNewTransactionId = false;

	var $transactionId;

	function init(){
		setTransactionIdFromPage();

		jQuery(document).ready(function($) {
			$transactionId = $(".transactionId");
			set(transactionId);
			updateSimples();
		});
	}

	function get() {
		if(typeof transactionId === "undefined"){
			setTransactionIdFromPage();
		}
		return transactionId;
	}

	function set( newTransactionId ) {
		transactionId = newTransactionId;
		render();
		updateSimples();
	}

	function setTransactionIdFromPage(){
		if(meerkat.site.initialTransactionId !== null && typeof meerkat.site.initialTransactionId === "number"){
			transactionId = meerkat.site.initialTransactionId;
			meerkat.site.initialTransactionId = null;
		}
	}

	function fetch( isAsync, actionId, retryAttempts, callback ){

		meerkat.modules.comms.post({
			url: "ajax/json/get_transactionid.jsp",
			dataType: "json",
			async: isAsync,
			errorLevel: "silent",
			data: {
				quoteType: meerkat.site.vertical,
				id_handler: actionId
			},
			onSuccess: function fetchTransactionIdSuccess(msg){

				if( msg.transaction_id !== transactionId ) {
					set(msg.transaction_id); // will update the private transactionId and render it on the page
					meerkat.messaging.publish(moduleEvents.CHANGED, {transactionId: transactionId});
				}

				if( typeof callback === "function" ) {
					callback(transactionId);
				}

			},
			onError: function fetchTransactionIdError(jqXHR, textStatus, errorThrown, settings, resultData) {

				// @todo = implement multiple attempts as part of the comms module
				if (retryAttempts > 0 && waitingOnNewTransactionId) {
					fetch(isAsync, data, retryAttempts-1, callback);
				} else {
					meerkat.modules.errorHandling.error({
						message: "An error occurred fetching a transaction ID. Please check your connection or try again later.",
						page: "core/transactionId.js module",
						description: "fetch() AJAX request(s) returned an error: " + textStatus + ' ' + errorThrown + ". Original transactionId: " + transactionId,
						errorLevel: "fatal",
						data: transactionId
					});

					if( typeof callback == "function" ) {
						callback(0);
					}
				}

			}
		});

	}

	// Makes an asynchronous ajax call that increments the transaction. Try to do this bundled up in another call if you can
	function getNew(retryAttempts, callback) {
		waitingOnNewTransactionId = true;
		fetch(true, 'increment_tranId', retryAttempts, function(transactionId) {
			
			waitingOnNewTransactionId = false;
			
			if( typeof callback == "function" ) {
				callback(transactionId);
			}
		})
	}

	function updateSimples() {
		try{
			if(meerkat.site.isCallCentreUser){
				parent.postMessage({
					eventType:"transactionId",
					transactionId:transactionId
				}, "*");
			}
		}catch(e){

		}
	}

	function render() {
		if( typeof transactionId === "number" && transactionId > 0 ) {
			$transactionId.html( transactionId );
		}
	}

	meerkat.modules.register("transactionId", {
		init: init,
		events: events,
		get: get,
		set: set,
		getNew: getNew
	});

})(jQuery);