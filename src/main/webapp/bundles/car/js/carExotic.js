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
		originalResultsTemplate = "",
		$youngDriverQs,
		$vehicleUse,
		$vehicleUseOption,
		_threshold = 150000;

	function init(){
		$marketValue = $('input[name=quote_vehicle_marketValue]');
		$exoticManualEntry = $('.exoticManualEntry').length > 0 ? $('.exoticManualEntry') : null;
		$speechBubble = $('.carHeadingBubbleContent');
		$resultsPage = $('.famous-results-page');
		$youngDriver = $('input[name=quote_drivers_youngExotic_exists]');
		$youngDriverQs = $('#quote_drivers_youngExoticToggleExoticArea, #quote_drivers_youngExoticExoticContFieldSet');

		$requiredFieldsToToggle = $('input[name=quote_contact_email], input[name=quote_contact_phoneinput]');

		// navbar contents
		$navBarContents = $('#navbar-filter .nav, #navbar-filter-labels');

		// existing and new questions
		$defaultQuestionsToHide = $('#quoteAccessoriesFieldSet, .noOfKms,  #accidentDamageRow, .rego-not-my-car, #employment_status_row, #ownsAnotherCar, #quote_restricted_ageRow, #quote_drivers_youngFieldSet, .ydGreenBubble');
		$exoticQuestionsToShow = $('#quote_drivers_regular_convictionsRow, .exoticUsageQuestions, #quote_drivers_youngExoticExoticFieldSet, #quote_drivers_youngExoticFieldSet, #quote_drivers_youngExoticContFieldSet, .ydSpeechBubbleDriverDetails, #preferredContactMethodRow');
		$securityRow = $('#securityOptionRow');
		$vehicleUse = $('#quote_vehicle_use');
		$vehicleUseOption = $vehicleUse.find('option[value=02]');

		// snapshot fields
		$carSnapshot = $(".car-snapshot");
		$carSnapshotRegoFieldset = $('#RegoFieldSet');

		_eventSubscriptions();
	}

	function toggleRequiredFields() {
		if (isExotic()) {
			$requiredFieldsToToggle.attr('required', 'required');
		} else {
			$requiredFieldsToToggle.removeAttr('required');
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
		}

		_toggleReasonFields($('input[name=quote_drivers_regular_claims]'), $('#quote_drivers_regular_claims_reasonRow'));
		_toggleReasonFields($('input[name=quote_drivers_regular_convictions]'), $('#quote_drivers_regular_conviction_reasonRow'));

		_toggleReasonFields($('input[name=quote_drivers_youngExotic_claims]'), $('#quote_drivers_youngExotic_claims_reasonRow'));
		_toggleReasonFields($('input[name=quote_drivers_youngExotic_convictions]'), $('#quote_drivers_youngExotic_conviction_reasonRow'));

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
			var templateHTML = $resultsPage.html();
			var _template = _.template(templateHTML);

			// backup the template
			if (originalResultsTemplate === "") {
				originalResultsTemplate = $(Results.settings.elements.page).html();
			}

			$(Results.settings.elements.page).html(_template({})).removeClass('hidden').show();

			$('#famous-alt-verticals .verticalButtons > div').removeClass().addClass('col-xs-12 col-sm-3');
		} else {

			if (originalResultsTemplate !== "") {
				$(Results.settings.elements.page).html(originalResultsTemplate);
			}
			$resultsPage.fadeIn();
		}
	}

	meerkat.modules.register("carExotic", {
		init: init,
		isExotic: isExotic,
		toggleQuestions: toggleQuestions,
		updateSpeechBubble: updateSpeechBubble,
		toggleRequiredFields: toggleRequiredFields,
		toggleFamousResultsPage: toggleFamousResultsPage,
		toggleNavBarContents: toggleNavBarContents
	});

})(jQuery);