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
		$regularDriverClaims,
		$regularDriverConvictions,
		$claimsReasonRow,
		$convictionRow,
		$carSnapshotRegoFieldset,
		_threshold = 150000;

	function init(){
		$marketValue = $('input[name=quote_vehicle_marketValue]');
		$exoticManualEntry = $('.exoticManualEntry').length > 0 ? $('.exoticManualEntry') : null;
		$originalQuestionSet = $('#quote_vehicle_selection');
		$exoticQuestionSet = $('#quote_vehicle_exotic_selection');
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
		$carSnapshotRegoFieldset = $('#RegoFieldSet');

		_eventSubscriptions();
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

	function _eventSubscriptions() {
		if ($exoticManualEntry !== null) {
			$exoticManualEntry.on('click', function manualExoticQEntry() {
				$originalQuestionSet.addClass('hidden');
				$exoticQuestionSet.removeClass('hidden');

				// update the fields to listen for within the snapshot
				_updateSnapshotDataSource($carSnapshot);
				_updateSnapshotDataSource($carSnapshotRegoFieldset);
			});
		}

		if (isExotic()) {
			_toggleReasonFields($regularDriverClaims, $claimsReasonRow);
			_toggleReasonFields($regularDriverConvictions, $convictionRow);
		}
	}

	function _updateSnapshotDataSource($el) {
		$el.find("span[data-source='#quote_vehicle_make']").attr('data-source', "#quote_vehicle_exotic_make");
		$el.find("span[data-source='#quote_vehicle_model']").attr('data-source', "#quote_vehicle_exotic_model");
		$el.find("span[data-source='#quote_vehicle_year']").attr('data-source', "#quote_vehicle_exotic_year");
	}

	function _toggleReasonFields($targetEl, $toggleEl) {
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