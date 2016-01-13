;(function($, undefined){

	var meerkat = window.meerkat;

	function addPHGImpressionTracking() {
		if (meerkat.site.PHGPostImpressionsEnabled === true && typeof typeof meerkat.site.PHGPostImpressions !== 'undefined'  && typeof meerkat.site.PHGPostImpressions.url !== 'undefined' && typeof meerkat.site.PHGPostImpressions.partnerValues !== 'undefined') {
			var links = "";
			_.each(Results.model.availablePartners, function addPHGTrackingToPage(brandCode) {
				links += "<script type='text/javascript' src='" + meerkat.site.PHGPostImpressions.url+""+meerkat.site.PHGPostImpressions.partnerValues[brandCode] + "'></script>";
			});
			$('body').append(links);
		}
	}

	meerkat.modules.register("salesTracking", {
		addPHGImpressionTracking: addPHGImpressionTracking
	});

})(jQuery);