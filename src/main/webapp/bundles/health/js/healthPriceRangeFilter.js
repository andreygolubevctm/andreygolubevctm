/*

Handling changes to the price range coming back from the ajax

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
	exception = meerkat.logging.exception
	meerkatEvents = meerkat.modules.events,
	log = meerkat.logging.info,
	// default values
	defaultPremiumsRange = {
			fortnightly : {
				min : 1,
				max : 300
			},
			monthly : {
				min : 1,
				max : 560
			},
			yearly : {
				min : 1,
				max : 4000
			}
	},
	initialised = false;

	function initHealthPriceRangeFilter() {
		if(!initialised) {
			initialised = true;
			// When the frequency filter is modified, update the price slider to reflect
			$('#filter-frequency input').on('change', onUpdateFrequency);
			$(document).on("resultsDataReady", onUpdatePriceFilterRange);
		}
	}

	function setUp() {
		meerkat.modules.utils.pluginReady('sliders').then(function() {
			var frequency = meerkat.modules.healthResults.getFrequencyInWords($('#health_filter_frequency').val());
			$('.health-filter-price .slider-control').trigger(meerkatEvents.sliders.EVENT_UPDATE_RANGE, getPremiumRange(frequency , false));
		})
		.catch(function onError(obj, txt, errorThrown) {
			exception(txt + ': ' + errorThrown);
		});
	}

	function onUpdateFrequency() {
		$('.health-filter-price .slider-control').trigger(meerkatEvents.sliders.EVENT_UPDATE_RANGE, getPremiumRange(getFrequency(), true));
	}

	function onUpdatePriceFilterRange() {
		$('.health-filter-price .slider-control').trigger(meerkatEvents.sliders.EVENT_UPDATE_RANGE, getPremiumRange(getFrequency(), false));
	}


	function getFrequency() {
		var frequency = meerkat.modules.healthResults.getFrequencyInWords($('#filter-frequency input:checked').val());
		if(!frequency) {
			frequency = Results.getFrequency();
		}
		return frequency;
	}

	function getPremiumRange(frequency , isUpdateFrequency) {
		var generalInfo = Results.getReturnedGeneral();

		if(!generalInfo || !generalInfo.premiumRange){
			premiumsRange = defaultPremiumsRange;
		} else {
			premiumsRange = generalInfo.premiumRange;
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
		return [Number(range.min) , Number(range.max), isUpdateFrequency];
	}

	meerkat.modules.register("healthPriceRangeFilter", {
		initHealthPriceRangeFilter: initHealthPriceRangeFilter,
		setUp: setUp
	});

})(jQuery);