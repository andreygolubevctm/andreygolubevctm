;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents =  meerkat.modules.events,
		log = meerkat.logging.info;


	function callFunctions(){
		log('[handoverCookieSetup]','Running the onready code');
		//So, we want NXI,NXS,NXQ and localhost to all act as test, but only NXI and local will show logging by default.
		if (meerkat.site.environment != "pro" || meerkat.site.environment != "prelive") {
			log('[handoverCookieSetup]','_CtMH setting test options now');
			_CtMH.setOpts({
				'debug': meerkat.site.showLogging,
				'asTest': true,
				'endp': meerkat.site.ctmh.fBase+'handover/confirm'
			});
			//The endp value actually isn't needed for ctm's side because we don't 'confirm' but we left it here for testing.
		}
		log('[handoverCookieSetup]','_CtMH running start now');
		_CtMH.start(meerkat.modules.transactionId.get(),meerkat.site.vertical);
	}

	function init(){
		log('[handoverCookieSetup]','Initialised');
		// listen for the returned results
		//$(document).on("resultsReturned", function(){
		meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, function resultsCallback() {
			log('[handoverCookieSetup]','RESULTS_DATA_READY','Triggered');
			// Check that the _CtMH object is set.
			if (typeof _CtMH !== 'undefined') {
				log('[handoverCookieSetup]','_CtMH is defined');
				_CtMH.onready(callFunctions());
			}
		});

		// listen for when the transfer happens to the partner
		meerkat.messaging.subscribe(meerkatEvents.partnerTransfer.TRANSFER_TO_PARTNER, function partnerTransferCallback(data){
			log('[handoverCookieSetup]','partnerTransfer.TRANSFER_TO_PARTNER','Triggered');
			// Check that the _CtMH object is set
			if (typeof _CtMH !== 'undefined') {
				_CtMH.add(data.transactionID,data.partnerID,data.productDescription);
			}
		});
	}

	meerkat.modules.register("handoverCookieSetup", {
		init: init
	});

})(jQuery);