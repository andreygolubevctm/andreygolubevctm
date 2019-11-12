;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
            address_lookup : {
                HIDDEN_FIELDS_POPULATED: 'HIDDEN_FIELDS_POPULATED'
            }
        },
        moduleEvents = events.address_lookup;

	var baseURL = '';

	var $currentAjaxRequest = null,
		dpIdCache = {},
		addressFieldId,
		isPublicRedemptionPage = false,
		isSimplesRedemptionPage = false;

	function initAddressLookup() {
		$(document).ready(function ($) {
			isPublicRedemptionPage = meerkat.site.vertical === 'generic' && _.has(meerkat.modules, 'redemptionComponent');
			isSimplesRedemptionPage = meerkat.site.vertical === 'simples' && _.has(meerkat.modules, 'redemptionForm');
		});
		meerkat.messaging.subscribe(meerkatEvents.autocomplete.ELASTIC_SEARCH_COMPLETE, function elasticAddress(data) {
			getAddressData(data);
		});
	}

	function getAddressData(addressFieldData) {
		addressFieldId = addressFieldData.addressFieldId;
		var dpId = addressFieldData.dpid;
		var data = addressFieldData.data;

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
			// Don't lock on home, as the address is on the first slide and the next button is directly after the question.
			// If this address question moves it might be worth removing this condition.
			if (_.indexOf(['car','home'], meerkat.site.vertical) === -1 && !isPublicRedemptionPage && !isSimplesRedemptionPage) {
				meerkat.modules.loadingAnimation.showInside($navButton);
				meerkat.messaging.publish(meerkat.modules.events.WEBAPP_LOCK, { source: 'address_lookup' });
			}

			// Send a request for the address details associated with
			// the given dpId
			if(typeof dpId !== "undefined" && dpId !== "") {
				$currentAjaxRequest = meerkat.modules.comms.post({
					url: baseURL + "address/get.json",
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
						} else {
							meerkat.messaging.publish(moduleEvents.HIDDEN_FIELDS_POPULATED, { addressData: data });
						}
					},
					onError: function ajaxGetTypeaheadAddressDataError(xhr, status) {
						if(status !== "abort") {
							meerkat.modules.errorHandling.error({
								page: "elastic_search.js",
								errorLevel: "warning",
								description: "Something went wrong and the elastic address lookup failed for " + dpId,
								message: "Sorry, there was a problem loading your address details, please try again.",
								data: xhr
							});

							if (meerkat.site.vertical === 'home') {
								meerkat.modules.journeyEngine.gotoPath("start");
							}
							$('#' + addressFieldId + '_nonStd').trigger('click.elasticAddress').prop('checked', true);
						}
					},
					onComplete: function ajaxGetTypeaheadAddressDataComplete() {
						// Unlock Journey
						meerkat.messaging.publish(meerkat.modules.events.WEBAPP_UNLOCK, { source: 'address_lookup' });
						meerkat.modules.loadingAnimation.hide($navButton);
					}
				});
			}else if( isPublicRedemptionPage || isSimplesRedemptionPage || _.indexOf(['car','home'], meerkat.site.vertical) >= 0) {
				setAddressDataFields(data);
			}
		}

	}

	// Populate the hidden fields.
	function setAddressDataFields(data) {
		for (var addressItem in data) {
			var $hiddenAddressElement = $('#' + addressFieldId + '_'+addressItem);
			$hiddenAddressElement.val(data[addressItem]).trigger("change").trigger("change.elasticAddress");
		}
	}

    function setBaseURL(url){
        baseURL = url || '';
    }

	meerkat.modules.register("address_lookup", {
		init: initAddressLookup,
		events: events,
        setBaseURL: setBaseURL
	});

})(jQuery);