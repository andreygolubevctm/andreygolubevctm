;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var moduleEvents = {};

	var isActive		=	false,
		fromMonth		=	null,
		disabledFunds	=	[],
		initialised		=	false;

	function getIsActive() {
		return isActive;
	}

	function getFromMonth() {
		return fromMonth;
	}

	function isFundDisabled(fund) {
		return _.indexOf(disabledFunds, fund) >= 0;
	}

	function initHealthAltPricing() {
		if(!initialised) {
			initialised = true;
			var json = meerkat.site.alternatePricing;
			if(!_.isNull(json) && _.isObject(json) && !_.isEmpty(json)) {
				// A little sanity check
				if(json.hasOwnProperty("isActive") && json.hasOwnProperty("fromMonth") && json.hasOwnProperty("disabledFunds")) {
					isActive = json.isActive;
					fromMonth = json.fromMonth;
					disabledFunds = json.disabledFunds;
				}
			}

		}
	}

	meerkat.modules.register("healthAltPricing", {
		initHealthAltPricing: initHealthAltPricing,
		events: moduleEvents,
		getIsActive: getIsActive,
		getFromMonth: getFromMonth,
		isFundDisabled: isFundDisabled
	});

})(jQuery);