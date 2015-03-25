;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {
		HIDDEN_FIELDS_POPULATED: 'HIDDEN_FIELDS_POPULATED'
	};

	var $currentAjaxRequest = null,
		dpIdCache = {};

	function initAddressLookup() {
		meerkat.messaging.subscribe(meerkatEvents.autocomplete.ELASTIC_SEARCH_COMPLETE, function elasticAddress(dpId) {
			getAddressData(dpId);
		});
	}

	function getAddressData(dpId) {
		// If a get details request takes too long and the user reselects cached address data, it will load in the ajax's
		// response instead of the cached data.
		// Here, we abort that request.
		if($currentAjaxRequest) {
			$currentAjaxRequest.abort();
			$currentAjaxRequest = null;
		}

		if(dpIdCache.hasOwnProperty(dpId)) {
			// Get the address data from the cache
			setAddressDataFields(dpIdCache[dpId]);
		} else {

			var $navButton = $('.journeyNavButton');

			// Lock Journey
			meerkat.modules.loadingAnimation.showInside($navButton);
			meerkat.messaging.publish(meerkat.modules.events.WEBAPP_LOCK, { source: 'address_lookup' });

			// Send a request for the address details associated with
			// the given dpId
			if(typeof dpId !== "undefined" && dpId !== "") {
				$currentAjaxRequest = meerkat.modules.comms.post({
					url: "/ctm/address/get.json",
					errorLevel: "mandatory",
					data: {
						dpId: dpId
					},
					onSuccess: function ajaxGetTypeaheadAddressDataSuccess(data) {
						dpIdCache[dpId] = data;
						setAddressDataFields(data);
						if(typeof data.dpId === "undefined" || data.dpId === "") {
							meerkat.modules.errorHandling.error({
								page: "elastic_search.js",
								errorLevel: "slient",
								description: "Could not find address with dpId of " + dpId,
								data: data
							});
						}
					},
					onError: function ajaxGetTypeaheadAddressDataError(xhr, status) {
						if(status !== "abort") {
							meerkat.modules.errorHandling.error({
								page: "elastic_search.js",
								errorLevel: "slient",
								description: "Something went wrong and the elastic address lookup failed for " + dpId,
								data: xhr
							});
						}
					},
					onComplete: function ajaxGetTypeaheadAddressDataComplete() {
						// Unlock Journey
						meerkat.messaging.publish(meerkat.modules.events.WEBAPP_UNLOCK, { source: 'address_lookup' });
						meerkat.modules.loadingAnimation.hide($navButton);
					}
				});
			}
		}

	}

	// Populate the hidden fields.
	function setAddressDataFields(data) {
		for (var addressItem in data) {
			var $hiddenAddressElement = $('#quote_riskAddress_'+addressItem);
			$hiddenAddressElement.val(data[addressItem]);
		}
	}

	meerkat.modules.register("address_lookup", {
		init: initAddressLookup,
		events: moduleEvents
	});

})(jQuery);