/*

Handling changes to the price range coming back from the ajax

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events,
	log = meerkat.logging.info,
	// default values
	defaultPremiumsRange = {
			fortnightly : {
				min : 0,
				max : 300
			},
			monthly : {
				min : 0,
				max : 560
			},
			yearly : {
				min : 0,
				max : 4000
			}
	};

	function init() {
		// When the frequency filter is modified, update the price slider to reflect
		$('#filter-frequency input').on('change', onUpdatePriceFilterRange);
		$(document).on("resultsDataReady", onUpdatePriceFilterRange);
	}


	function onUpdatePriceFilterRange() {
		meerkat.messaging.publish(meerkatEvents.sliders.UPDATE_PRICE_RANGE, getPremiumRange());
	}

	function getPremiumRange() {
		var generalInfo = Results.getReturnedGeneral();
		var premiumsRange = generalInfo.premiumRange;
		if(!premiumsRange){
			premiumsRange = defaultPremiumsRange;
		}

		var frequency = meerkat.modules.healthResults.getFrequencyInWords($('#filter-frequency input:checked').val());
		if(!frequency) {
			frequency = Results.getFrequency();
		}

		var range  = {};
		switch(frequency) {
		case 'fortnightly':
			if(premiumsRange.fortnightly.max <= 0) {
				premiumsRange.fortnightly.max = defaultPremiumsRange.fortnightly.max;
			}
			range = premiumsRange.fortnightly;
			break;
		case 'monthly':
			if(premiumsRange.monthly.max <= 0) {
				premiumsRange.monthly.max = defaultPremiumsRange.monthly.max;
			}
			range = premiumsRange.monthly;
			break;
		case 'annually':
			if(premiumsRange.yearly.max <= 0) {
				premiumsRange.yearly.max = defaultPremiumsRange.yearly.max;
			}
			range = premiumsRange.yearly;
			break;
		default:
			range = premiumsRange.monthly;
		}
		return [range.min , range.max];
	}

	meerkat.modules.register("healthPriceRangeFilter", {
		init: init
	});

})(jQuery);