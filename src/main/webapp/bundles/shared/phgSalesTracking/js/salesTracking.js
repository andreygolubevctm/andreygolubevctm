;(function($, undefined){

	var meerkat = window.meerkat;

	function addPHGImpressionTracking() {
console.log("addPHGImpressionTracking");
		if (meerkat.site.PHGPostImpressions.url && meerkat.site.PHGPostImpressions.partnerValues) {
			_.each(Results.model.availablePartners, function addPHGTrackingToPage(brandCode) {
				console.log("TTEST", meerkat.site.PHGPostImpressions.url+""+meerkat.site.PHGPostImpressions.partnerValues[brandCode]);
			});
		}
	}

	meerkat.modules.register("salesTracking", {
		addPHGImpressionTracking: addPHGImpressionTracking
	});

})(jQuery);