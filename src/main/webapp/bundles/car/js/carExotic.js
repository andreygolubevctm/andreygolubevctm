;(function($, undefined){

	var meerkat = window.meerkat,
		$marketValue,
		$exoticManualEntry,
		$originalQuestionSet,
		$exoticQuestionSet,
		$questionsToHide,
		_threshold = 150000;

	function init(){
		$marketValue = $('input[name=quote_vehicle_marketValue]');
		$exoticManualEntry = $('.exoticManualEntry').length > 0 ? $('.exoticManualEntry') : null;
		$originalQuestionSet = $('#quote_vehicle_selection');
		$exoticQuestionSet = $('#quote_exotic_vehicle_selection');

		// existing questions
		$questionsToHide = $('#quote_vehicle_modificationsFieldRow, .noOfKms, #securityOptionRow, #accidentDamageRow, .rego-not-my-car');

		eventSubscriptions();
	}

	// check if the user has used our normal journey or have come from the classic car landing page
	function isExotic() {
		return (meerkat.site.tracking.brandCode === 'ctm' && (parseInt($marketValue.val()) >= _threshold  || meerkat.site.isFromExoticPage === true));
	}

	function hideNormalQuestions() {
		$questionsToHide.hide();
	}

	function showNormalQuestions() {
		$questionsToHide.show();
	}

	function updateSpeechBubble() {
		if (isExotic()) {

		} else {
			// else is used in case they go back and do a different car
		}
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
		isExotic: isExotic,
		hideNormalQuestions: hideNormalQuestions,
		showNormalQuestions: showNormalQuestions
	});

})(jQuery);