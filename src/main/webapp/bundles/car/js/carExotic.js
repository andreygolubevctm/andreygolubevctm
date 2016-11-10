;(function($, undefined){

	var meerkat = window.meerkat,
		$marketValue,
		_threshold = 150000;

	function init(){
		$marketValue = $('input[name=quote_vehicle_marketValue]');
	}

	// check if the user has used our normal journey or have come from the classic car landing page
	function isExotic() {
		return (meerkat.site.tracking.brandCode === 'ctm' && (parseInt($marketValue.val()) >= _threshold  || meerkat.site.isFromExoticPage === true));
	}

	meerkat.modules.register("carExotic", {
		init: init,
		isExotic: isExotic
	});

})(jQuery);