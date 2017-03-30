;(function($, undefined){

	var meerkat = window.meerkat,
		$marketValue,
		$exoticManualEntry,
		$defaultQuestionsToHide,
		$exoticQuestionsToShow,
		$speechBubble,
		$carSnapshot,
		$carSnapshotRegoFieldset,
		$requiredFieldsToToggle,
		$resultsPage,
		$securityRow,
		$navBarContents,
		$youngDriver,
		$youngDriverQs,
		$vehicleUse,
		$vehicleUseOption,
		_threshold = 150000,
		$reasonElements = [];

	function init(){
		$marketValue = $('input[name=quote_vehicle_marketValue]');
		$exoticManualEntry = $('.exoticManualEntry').length > 0 ? $('.exoticManualEntry') : null;
		$speechBubble = $('.carHeadingBubbleContent');
		$resultsPage = $('.famous-results-page');
		$youngDriver = $('input[name=quote_drivers_youngExotic_exists]');
		$youngDriverQs = $('#quote_drivers_youngExoticToggleExoticArea, #quote_drivers_youngExoticExoticContFieldSet');
		$firstname = $('#quote_drivers_regular_firstname');
		$surname = $('#quote_drivers_regular_surname');
		$nameFields = $firstname.add($surname);
		$requiredFieldsToToggle = $('input[name=quote_contact_email], input[name=quote_contact_phoneinput]').add($nameFields);

		// navbar contents
		$navBarContents = $('#navbar-filter .nav, #navbar-filter-labels');

		// existing and new questions
		$defaultQuestionsToHide = $('#quote_optionsTypeOfCoverFieldRow, #quote_drivers_young_annualKilometresRow, #quoteAccessoriesFieldSet, .noOfKms,  #accidentDamageRow, .rego-not-my-car, #employment_status_row, #ownsAnotherCar, #quote_restricted_ageRow, .ydGreenBubble');
		$exoticQuestionsToShow = $('#quote_drivers_regular_convictionsRow, #quote_drivers_young_claimsRow, #quote_drivers_young_convictionsRow, .exoticUsageQuestions, .ydSpeechBubbleDriverDetails, #preferredContactMethodRow');
		$securityRow = $('#securityOptionRow');
		$vehicleUse = $('#quote_vehicle_use');
		$vehicleUseOption = $vehicleUse.find('option[value=02]');

		// snapshot fields
		$carSnapshot = $(".car-snapshot");
		$carSnapshotRegoFieldset = $('#RegoFieldSet');

		// reason fields
		_setupReasonFields();

		_eventSubscriptions();
	}

	function _setupReasonFields() {
		$reasonElements = [
			{ input: $('input[name=quote_drivers_regular_claims]'), row: $('#quote_drivers_regular_claims_reasonRow') },
			{ input: $('input[name=quote_drivers_regular_convictions]'), row: $('#quote_drivers_regular_conviction_reasonRow') },
			{ input: $('input[name=quote_drivers_youngExotic_claims]'), row: $('#quote_drivers_youngExotic_claims_reasonRow') },
			{ input: $('input[name=quote_drivers_youngExotic_convictions]'), row: $('#quote_drivers_youngExotic_conviction_reasonRow') }
		];
	}

	function toggleRequiredFields() {
		if (isExotic()) {
			$requiredFieldsToToggle.attr('required', 'required');
			$nameFields.attr('data-rule-personName','true');
			$firstname.attr('data-msg-required','Please enter your first name');
			$surname.attr('data-msg-required','Please enter your last name');
		} else {
			$requiredFieldsToToggle
				.removeAttr('required')
				.removeAttr('data-rule-personName','true')
				.removeAttr('data-msg-required');
		}
	}

	function confirmPartnerTesting(){
		if(_.indexOf(['localhost','nxi','nxs'], meerkat.site.environment) > -1) {
			var $providerList = $('#quote_filter_providerList');
			var $authToken = $('#quote_filter_authToken');
			return ($authToken.length && $authToken.val() === '0u812iiL7blk182') ||	($providerList.length && $providerList.val() === 'FAME');
		}
		return false;
	}

	// check if the user has used our normal journey or have come from the classic car landing page
	function isExotic() {
		if (meerkat.modules.carRegoLookup.isRegoLookupMode()) {
			return false;
		}

		if(meerkat.site.tracking.brandCode === 'ctm') {
			return parseInt($marketValue.val()) >= _threshold  || meerkat.site.isFromExoticPage === true || confirmPartnerTesting();
		}

		return false;
	}

	function toggleQuestions() {
		var is_exotic = isExotic();
		toggleVehicleUseOptions(is_exotic);
		if (is_exotic) {
			$defaultQuestionsToHide.hide();
			$exoticQuestionsToShow.removeClass('hidden');
			if ($securityRow.find('.select:first').length > 0) {
				$securityRow.hide();
			}
		} else {
			$defaultQuestionsToHide.show();
			$exoticQuestionsToShow.addClass('hidden');

			// carSecurityOptions has some additional show/hide logic for the security question hence this piece of code
			// if the $securityRow was added to the $defaultQuestionsToHide list of elements, it will show a row without the actual select box
			if ($securityRow.find('.select:first').length > 0) {
				$securityRow.show();
			}
		}
	}

	/**
	 * toggleVehicleUseOptions updates the options in the vehicle use question
	 * to match required for journey type
	 * @param exotic
     */
	function toggleVehicleUseOptions(exotic) {
		var is_exotic = exotic || false;
		var option02 = {
			normal : 'Private and/or commuting to work only',
			exotic : 'Private use only'
		};
		var option03 = 'Private use - twice monthly';
		var $option03 = $vehicleUse.find('option[value=03]');
		if(is_exotic) {
			$vehicleUseOption.empty().append(option02.exotic);
			if(!$option03.length) {
				$('<option/>',{
					value:'03',
					text:option03
				}).insertAfter($vehicleUseOption);
			}
		} else {
			$vehicleUseOption.empty().append(option02.normal);
			if($option03.length) $option03.remove();
		}
	}

	function _eventSubscriptions() {
		if ($exoticManualEntry !== null) {
			$exoticManualEntry.off('click').on('click', function manualExoticQEntry() {
				$('#quote_vehicle_selection').addClass('hidden');
				$('#quote_vehicle_exotic_selection').removeClass('hidden');

				// update the fields to listen for within the snapshot
				_updateSnapshotDataSource($carSnapshot);
				_updateSnapshotDataSource($carSnapshotRegoFieldset);
			});

			if (meerkat.site.isExoticManualEntry) {
				$exoticManualEntry.trigger('click');
			}
		}

		for (var i = 0; i < $reasonElements.length; i++) {
			_toggleReasonFields($reasonElements[i].input, $reasonElements[i].row);
		}

		$youngDriver.on('click', function toggleYoungDriverExotic(){
			if ($(this).val() === 'Y') {
				$youngDriverQs.slideDown();
			} else {
				$youngDriverQs.slideUp();
			}
		});

		// default to hidden
		$youngDriverQs.slideUp();

		if(_.indexOf(['localhost','nxi','nxs'], meerkat.site.environment) > -1) {
			var $providerList = $('#quote_filter_providerList');
			if($providerList.length) {
				$providerList.on('change.famousPartnerTesting', function providerListToggle(){
					toggleQuestions();
					updateSpeechBubble();
					toggleRequiredFields();
					toggleNavBarContents();
				});
			}
		}
	}

	function _updateSnapshotDataSource($el) {
		$el.find("span[data-source='#quote_vehicle_make']").attr('data-source', "#quote_vehicle_exotic_make");
		$el.find("span[data-source='#quote_vehicle_model']").attr('data-source', "#quote_vehicle_exotic_model");
		$el.find("span[data-source='#quote_vehicle_year']").attr('data-source', "#quote_vehicle_exotic_year");
	}

	function _toggleReasonFields($targetEl, $toggleEl) {
		$targetEl.on('click', function toggleReasonField() {
			if (isExotic()) {
				if ($targetEl.filter(":checked").val() === 'Y') {
					if ($toggleEl.hasClass('hidden')) {
						$toggleEl.removeClass('hidden');
					}
					$toggleEl.slideDown();
				} else {
					$toggleEl.slideUp();
				}
			}
		});
	}

	function toggleNavBarContents() {
		$navBarContents.toggleClass('hidden', isExotic());
	}

	// catering for the scenario where someone enters the normal journey and selects an exotic car but then goes back
	// and changes the car details to a non-exotic car.
	function updateSpeechBubble() {
		var exoticContent = meerkat.site.exoticCarContent,
			h4Text = isExotic() ? exoticContent.exoticHeading : exoticContent.normalHeading,
			pText = isExotic() ? exoticContent.exoticCopy : exoticContent.normalCopy;

		$speechBubble.find('h4').text(h4Text).stop().parent().find('p').text(pText);
	}

	function toggleFamousResultsPage() {
		if (isExotic()) {
			$(Results.settings.elements.page).removeClass('hidden').show();
		}

		$(Results.settings.elements.resultsContainer).toggleClass('hidden', isExotic());
		$resultsPage.toggleClass('hidden', !isExotic());
	}

	function toggleReasonFields() {
		for (var i = 0; i < $reasonElements.length; i++) {
			if (isExotic()) {
				$reasonElements[i].input.filter(':checked').trigger('click');
			} else {
				$reasonElements[i].row.hide();
			}
		}
	}

	meerkat.modules.register("carExotic", {
		init: init,
		isExotic: isExotic,
		toggleQuestions: toggleQuestions,
		updateSpeechBubble: updateSpeechBubble,
		toggleRequiredFields: toggleRequiredFields,
		toggleFamousResultsPage: toggleFamousResultsPage,
		toggleNavBarContents: toggleNavBarContents,
		toggleReasonFields: toggleReasonFields
	});

})(jQuery);