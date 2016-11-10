;(function($, undefined){

	var meerkat = window.meerkat,
		$marketValue,
		$exoticManualEntry,
		$originalQuestionSet,
		$exoticQuestionSet,
		_threshold = 150000;

	function init(){
		$marketValue = $('input[name=quote_vehicle_marketValue]');
		$exoticManualEntry = $('.exoticManualEntry').length > 0 ? $('.exoticManualEntry') : null;
		$originalQuestionSet = $('#quote_vehicle_selection');
		$exoticQuestionSet = $('#quote_exotic_vehicle_selection');

		eventSubscriptions();
	}

	// check if the user has used our normal journey or have come from the classic car landing page
	function isExotic() {
		return (meerkat.site.tracking.brandCode === 'ctm' && (parseInt($marketValue.val()) >= _threshold  || meerkat.site.isFromExoticPage === true));
	}

	function eventSubscriptions() {
		if ($exoticManualEntry !== null) {
			$exoticManualEntry.on('click', function manualExoticQEntry() {
				$originalQuestionSet.addClass('hidden');
				$exoticQuestionSet.removeClass('hidden');
			});
		}
	}

	meerkat.modules.register("carExotic", {
		init: init,
		isExotic: isExotic
	});

})(jQuery);