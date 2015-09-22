(function ($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	function initReloadQuote() {

	}

	function loadQuote() {

		var params = getURLVars(window.location.search),
			dat = "vertical=travel&action=load&id="+params.id+"&hash="+params.hash+"&type="+params.type+"&vertical=TRAVEL&transactionId="+ params.id;

		if(typeof meerkat.modules.transactionId.get() == 'undefined'){
			meerkat.modules.transactionId.set(params.id);
		}
		meerkat.modules.comms.post({
			url: "ajax/json/remote_load_quote.jsp",

			data: dat,
			cache: false,
			useDefaultErrorHandling: false,
			errorLevel: "fatal",
			timeout: 30000,
			onError: onSubmitToLoadQuoteError,
			onSuccess: function onSubmitSuccess(resultData) {
				meerkat.modules.leavePageWarning.disable();
				window.location = resultData.result.destUrl + '&ts=' + Number(new Date());
			}
		});
	}

	function onSubmitToLoadQuoteError(jqXHR, textStatus, errorThrown, settings, resultData) {
		stateSubmitInProgress = false;
		meerkat.modules.errorHandling.error({
			message:		"An error occurred when attempting to retrieve your quotes",
			page:			"travelReloadQuote.js:loadQuote()",
			errorLevel:		"warning",
			description:	"Ajax request to remote_load_quote.jsp failed to return a valid response: " + errorThrown,
			data: resultData
		});
		meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK, { source: 'loadQuote'});
	}

	function getURLVars(sSearch) {
		if (sSearch.length > 1) {
			var obj = {};
			for (var aItKey, nKeyId = 0, aCouples = sSearch.substr(1).split("&"); nKeyId < aCouples.length; nKeyId++) {
				aItKey = aCouples[nKeyId].split("=");
				obj[decodeURIComponent(aItKey[0])] = aItKey.length > 1 ? decodeURIComponent(aItKey[1]) : "";
			}

			return obj;
		}
	}

	meerkat.modules.register("travelReloadQuote", {
		init: initReloadQuote,
		loadQuote: loadQuote
	});

})(jQuery);