;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var moduleEvents = {};

	var isActive		=	false,
		fromMonth		=	null,
		disabledFunds	=	[];

	function getIsActive() {
		return isActive;
	}

	function getFromMonth() {
		return fromMonth;
	}

	function isFundDisabled(fund) {
		return _.indexOf(disabledFunds, fund) >= 0;
	}

	function init() {

		var self = this;

		$(document).ready(function() {

			var json = meerkat.site.alternatePricing;
			if(!_.isNull(json) && _.isObject(json) && !_.isEmpty(json)) {
				// A little sanity check
				if(json.hasOwnProperty("isActive") && json.hasOwnProperty("fromMonth") && json.hasOwnProperty("disabledFunds")) {
					isActive = json.isActive;
					fromMonth = json.fromMonth;
					disabledFunds = json.disabledFunds;
				}
			}

		});
	}

	meerkat.modules.register("healthAltPricing", {
		init: init,
		events: moduleEvents,
		getIsActive: getIsActive,
		getFromMonth: getFromMonth,
		isFundDisabled: isFundDisabled
	});

})(jQuery);