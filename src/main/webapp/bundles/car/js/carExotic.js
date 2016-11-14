;(function($, undefined){

	var meerkat = window.meerkat,
		$marketValue,
		$exoticManualEntry,
		$originalQuestionSet,
		$exoticQuestionSet,
		$questionsToHide,
		$exoticQuestionsToShow,
		$speechBubble,
		$carSnapshot,
		$quoteVehicleMake,
		$quoteVehicleModel,
		$quoteVehicleYear,
		$regularDriverClaims,
		$regularDriverConvictions,
		$claimsReasonRow,
		$convictionRow,
		_threshold = 150000;

	function init(){
		$marketValue = $('input[name=quote_vehicle_marketValue]');
		$exoticManualEntry = $('.exoticManualEntry').length > 0 ? $('.exoticManualEntry') : null;
		$originalQuestionSet = $('#quote_vehicle_selection');
		$exoticQuestionSet = $('#quote_exotic_vehicle_selection');
		$speechBubble = $('.bubbleContent');
		$regularDriverClaims = $('input[name=quote_drivers_regular_claims]');
		$regularDriverConvictions = $('input[name=quote_drivers_regular_convictions]');
		$claimsReasonRow = $('#quote_drivers_regular_claims_reasonRow');
		$convictionRow = $('#quote_drivers_regular_conviction_reasonRow');

		// existing and new questions
		$questionsToHide = $('#quoteAccessoriesFieldSet, .noOfKms, #securityOptionRow, #accidentDamageRow, .rego-not-my-car, #employment_status_row, #ownsAnotherCar');
		$exoticQuestionsToShow = $('#quote_drivers_regular_convictionsRow');

		// snapshot fields
		$carSnapshot = $(".car-snapshot");
		$quoteVehicleMake = $carSnapshot.find("span[data-source='#quote_vehicle_make']");
		$quoteVehicleModel = $carSnapshot.find("span[data-source='#quote_vehicle_model']");
		$quoteVehicleYear = $carSnapshot.find("span[data-source='#quote_vehicle_year']");

		eventSubscriptions();
	}

	// check if the user has used our normal journey or have come from the classic car landing page
	function isExotic() {
		return (meerkat.site.tracking.brandCode === 'ctm' && (parseInt($marketValue.val()) >= _threshold  || meerkat.site.isFromExoticPage === true));
	}

	function toggleQuestions() {
		if (isExotic()) {
			$questionsToHide.hide();
			$exoticQuestionsToShow.removeClass('hidden');
		} else {
			$questionsToHide.show();
			$exoticQuestionsToShow.addClass('hidden');
		}
	}

	function eventSubscriptions() {
		if ($exoticManualEntry !== null) {
			$exoticManualEntry.on('click', function manualExoticQEntry() {
				$originalQuestionSet.addClass('hidden');
				$exoticQuestionSet.removeClass('hidden');

				// update the fields to listen for within the snapshot
				$quoteVehicleMake.attr('data-source', "#quote_exotic_vehicle_make");
				$quoteVehicleModel.attr('data-source', "#quote_exotic_vehicle_model");
				$quoteVehicleYear.attr('data-source', "#quote_exotic_vehicle_year");
			});
		}

		if (isExotic()) {
			toggleReasonFields($regularDriverClaims, $claimsReasonRow);
			toggleReasonFields($regularDriverConvictions, $convictionRow);
		}
	}

	function toggleReasonFields($targetEl, $toggleEl) {
		$targetEl.on('click', function toggleReasonField() {
			if ($targetEl.filter(":checked").val() === 'Y') {
				if ($toggleEl.hasClass('hidden')) {
					$toggleEl.removeClass('hidden');
				}
				$toggleEl.slideDown();
			} else {
				$toggleEl.slideUp();
			}
		});
	}

	function updateSpeechBubble() {
		var exoticContent = meerkat.site.exoticCarContent,
			h4Text = isExotic() ? exoticContent.exoticHeading : exoticContent.normalHeading,
			pText = isExotic() ? exoticContent.exoticCopy : exoticContent.normalCopy;

		$speechBubble.find('h4').text(h4Text);
		$speechBubble.find('p').text(pText);
	}

	meerkat.modules.register("carExotic", {
		init: init,
		isExotic: isExotic,
		toggleQuestions: toggleQuestions,
		updateSpeechBubble: updateSpeechBubble
	});

})(jQuery);