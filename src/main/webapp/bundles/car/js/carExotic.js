;(function($, undefined){

	var meerkat = window.meerkat,
		$marketValue,
		$exoticManualEntry,
		$defaultQuestionsToHide,
		$exoticQuestionsToShow,
		$speechBubble,
		$carSnapshot,
		$carSnapshotRegoFieldset,
		_threshold = 150000;

	function init(){
		$marketValue = $('input[name=quote_vehicle_marketValue]');
		$exoticManualEntry = $('.exoticManualEntry').length > 0 ? $('.exoticManualEntry') : null;
		$speechBubble = $('.carHeadingBubbleContent');

		// existing and new questions
		$defaultQuestionsToHide = $('#quoteAccessoriesFieldSet, .noOfKms, #securityOptionRow, #accidentDamageRow, .rego-not-my-car, #employment_status_row, #ownsAnotherCar, #quote_restricted_ageRow, #quote_drivers_youngFieldSet, .ydGreenBubble');
		$exoticQuestionsToShow = $('#quote_drivers_regular_convictionsRow, #quote_drivers_youngExoticFieldSet');

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
			$defaultQuestionsToHide.hide();
			$exoticQuestionsToShow.removeClass('hidden');
		} else {
			$defaultQuestionsToHide.show();
			$exoticQuestionsToShow.addClass('hidden');
		}
	}

	function _eventSubscriptions() {
		if ($exoticManualEntry !== null) {
			$exoticManualEntry.on('click', function manualExoticQEntry() {
				$('#quote_vehicle_selection').addClass('hidden');
				$('#quote_vehicle_exotic_selection').removeClass('hidden');

				// update the fields to listen for within the snapshot
				_updateSnapshotDataSource($carSnapshot);
				_updateSnapshotDataSource($carSnapshotRegoFieldset);
			});
		}

		if (isExotic()) {
			_toggleReasonFields($('input[name=quote_drivers_regular_claims]'), $('#quote_drivers_regular_claims_reasonRow'));
			_toggleReasonFields($('input[name=quote_drivers_regular_convictions]'), $('#quote_drivers_regular_conviction_reasonRow'));

			_toggleReasonFields($('input[name=quote_drivers_young_claims]'), $('#quote_drivers_young_claims_reasonRow'));
			_toggleReasonFields($('input[name=quote_drivers_young_convictions]'), $('#quote_drivers_young_conviction_reasonRow'));
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

	// catering for the scenario where someone enters the normal journey and selects an exotic car but then goes back
	// and changes the car details to a non-exotic car.
	function updateSpeechBubble() {
		var exoticContent = meerkat.site.exoticCarContent,
			h4Text = isExotic() ? exoticContent.exoticHeading : exoticContent.normalHeading,
			pText = isExotic() ? exoticContent.exoticCopy : exoticContent.normalCopy;

		$speechBubble.find('h4').text(h4Text).stop().parent().find('p').text(pText);
	}

	meerkat.modules.register("carExotic", {
		init: init,
		isExotic: isExotic,
		toggleQuestions: toggleQuestions,
		updateSpeechBubble: updateSpeechBubble
	});

})(jQuery);